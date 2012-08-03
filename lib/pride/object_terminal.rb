module Pride
  # An ObjectTerminal is a widget that reads user input and passes them on to a
  # Pry instance to print the results. It provides some readline-like key
  # combination for convenience.
  class ObjectTerminal < Qt::TextEdit
    # Simple object that allows to send data from the widget to Pry.
    class Input
      # Reads a line from the widget.
      #
      # Actually, this just yields an instruction that tells the widget to wait
      # for input. The widget will then resume to the fiber when the user enters
      # a line.
      def readline(prompt)
        Fiber.yield :wait, prompt
      end

      # The proc will be used from the widget
      attr_accessor :completion_proc
    end

    # IO-like object that allows to get the output of an instruction back from
    # Pry.
    class Output
      # Yields some text to write to the widget.
      def write(data)
        Fiber.yield :write, data.to_s
        data.size
      end

      def <<(data)
        Fiber.yield :write, data.to_s
        self
      end

      # Yields a sequence of strings to print on the widget.
      def print(*strings)
        strings.each do |str|
          Fiber.yield :write, str.to_s
        end

        nil
      end

      # Yields a sequence of lines to print on the widget.
      #
      # Notice this needs to special case Array, since IO#puts does that
      # too. Instead of printing the result of Array#to_s, we need to print
      # every element on a new line.
      def puts(*lines)
        Fiber.yield :write, "\n" if lines.empty?

        lines.each do |line|
          if line.is_a? Array
            # Actually I changed my mind, warning about shadowing a variable is
            # silly.
            line.each { |sub_line| puts(sub_line) }
          else
            Fiber.yield :write, line.to_s.chomp + "\n"
          end
        end

        nil
      end
    end

    # Creates an ObjectTerminal which will interact with a given object
    def initialize(object, parent = nil)
      super(parent)

      @min_position = 0

      @history = History.new
      @object  = object
      @completer = Qt::Completer.new

      setup_style
      setup_completer
      reload

      create_repl
    end

    # Object that the REPL operates on (or, operated on at first)
    attr_reader :object

    # @return [Qt::Completer] Object used when dealing with autocompletion
    attr_reader :completer

    # @return [Integer] Minimal position we are allowed to write from
    attr_reader :min_position

    # @return [Input] Input object for Pry
    attr_reader :input

    # @return [Output] Output object for Pry
    attr_reader :output

    # @return [Pride::History]
    attr_reader :history

    # Sends a line to Pry
    #
    # @param [String] line Input line. Doesn't need to be terminated with a
    # line-break character.
    def enter_line(line)
      handle_fiber(line.chomp)
    end

    # Adds an output line to the terminal.
    #
    # @param [String] res Line to write. May contain ANSI codes.
    def add_result(res)
      change_cursor { |c|
        saved_format = c.char_format # moving changes char format
        c.move_position document.character_count - 1
        c.char_format = saved_format

        ANSIToQt.insert(c, res)
      }
    end

    # Starts to expect the user to enter a line of input.
    #
    # @param [String] prompt Prompt to be printed before
    def wait_for_line(prompt = ">> ")
      move_cursor Qt::TextCursor::End

      change_cursor { |c|
        c.move_position Qt::TextCursor::End
        c.merge_char_format ANSIToQt::Styles[:clear]
        ANSIToQt.insert(c, prompt)
      }

      self.read_only = false

      @history.reset_index

      bar = vertical_scroll_bar # Scroll down
      bar.value = bar.maximum

      # Define the position the current line begins
      @min_position = document.character_count - 1
    end

    # Reloads the widget's configuration.
    def reload
      document.default_style_sheet = Config.stylesheet

      palette = self.palette
      palette.set_color Qt::Palette::Base, Config.background
      self.palette = palette

      Config.term.each_shortcut do |key, block|
        Pride.add_shortcut(self, key) do
          change_cursor { |c| c.clear_selection }
          instance_eval(&block)
        end
      end
    end

    # Yields a copy of the current cursor to a block, then sets the cursor to
    # that (possibly modified) cursor.
    def change_cursor
      cursor = text_cursor
      yield cursor
      self.text_cursor = cursor
    end

    # @return [String] The current line of code
    def line
      cursor = text_cursor

      cursor.position = document.character_count - 1
      cursor.set_position(@min_position, Qt::TextCursor::KeepAnchor)

      if line = cursor.selected_text
        line.force_encoding("UTF-8")
      end
    end

    # Replaces the content of the current line with something else.
    #
    # @param [String] line
    def replace_line(line)
      cursor = text_cursor

      cursor.position = document.character_count - 1
      cursor.set_position(@min_position, Qt::TextCursor::KeepAnchor)

      cursor.insert_text line

      change_cursor { |c| c.position = document.character_count - 1 }

      highlight
    end

    # @return [Integer] Index of the current character relatively to the
    #   beginning of the line.
    def line_pos
      text_cursor.position - @min_position
    end

    # @return [Boolean] True if a character can be inserted at the current
    #   position
    def can_write?
      text_cursor.position >= @min_position
    end

    # @param [Integer] position
    # @return [Boolean] True if a character can be inserted at position
    def can_write_from?(position)
      position >= @min_position
    end

    # Runs syntax highlighting on the current line of code
    def highlight
      return unless Config.live_highlight

      code = CodeRay.scan(line, :ruby).html

      cursor = text_cursor

      pos = cursor.position
      cursor.move_position Qt::TextCursor::End
      cursor.set_position @min_position, Qt::TextCursor::KeepAnchor
      cursor.remove_selected_text

      cursor.insert_html "<code>#{code}</code>"
      cursor.position = pos

      self.text_cursor = cursor
    end

    # Submits the current line to Pry
    def submit_line
      line = self.line
      return unless line

      self.read_only = true

      change_cursor do |c|
        c.move_position Qt::TextCursor::End
        c.merge_char_format ANSIToQt::Styles[:clear]
        c.insert_text "\n"
      end

      enter_line(line)
    end

    # @return [Integer] Position to complete from
    def completion_pos
      cursor = text_cursor
      cursor.move_position Qt::TextCursor::PreviousWord
      cursor.position
    end

    # @return [String] String that the completer object should complete
    def completion_prefix
      cursor = text_cursor
      pos    = cursor.position

      cursor.move_position Qt::TextCursor::PreviousWord
      cursor.move_position(Qt::TextCursor::NextWord,
                           Qt::TextCursor::KeepAnchor)

      if pos == cursor.position
        cursor.selected_text
      end
    end

    # Selects the previous line of history.
    def to_previous_line
      @history.save_line(line || "")

      if @history.to_previous_line and line = @history.current_line
        replace_line line
      end
    end

    # Selects the next line of history.
    def to_next_line
      @history.save_line(line || "")

      if @history.to_next_line and line = @history.current_line
        replace_line line
      end
    end

    # @return [Boolean] True if the completer popup is being shown
    def completing?
      @completer.popup.visible?
    end

    # Autocompletes the current word.
    def complete
      insert_completion @completer.current_completion
      @completer.popup.hide
    end

    # Selects the previous completion string.
    def select_previous_completion
      completer.current_row -= 1
      completer.popup.current_index =
        completer.popup.current_index.sibling(completer.current_row, 0)
    end

    # Selects the next completion string.
    def select_next_completion
      completer.current_row += 1
      completer.popup.current_index =
        completer.popup.current_index.sibling(completer.current_row, 0)
    end

    # Inserts a completed string (overwriting the completion prefix).
    #
    # @param [String] completion Completed string
    def insert_completion(completion)
      cursor = text_cursor
      size = completion.size - @completer.completion_prefix.size

      cursor.move_position Qt::TextCursor::Left
      cursor.move_position Qt::TextCursor::EndOfWord

      return unless can_write_from? cursor.position

      cursor.insert_text completion[-size..-1]
      self.text_cursor = text_cursor

      highlight
    end

    # Updates the completion prefix and the completions strings, or set them if
    # they weren't set already.
    #
    # If there's no completion prefix, discards the completion prefix.
    def update_completion_prefix
      Qt::Application.set_override_cursor Qt::Cursor.new(Qt::WaitCursor)

      pos  = completion_pos
      word = completion_prefix

      if word
        completions = @input.completion_proc.call(word)
        model       = Qt::StringListModel.new(completions)

        @completion_pos = pos

        @completer.model = model

        if word != @completer.completion_prefix
          @completer.completion_prefix   = word
          @completer.popup.current_index = @completer.completion_model.
            index(0, 0)
        end

        rect = cursor_rect
        rect.width = @completer.popup.size_hint_for_column(0) +
          @completer.popup.vertical_scroll_bar.size_hint.width

        @completer.complete rect
      else
        @completer.popup.hide
      end

      Qt::Application.restore_override_cursor
    end

    protected # by default, such Qt event handlers are protected

    # Handle keys manually. Basically only insert text here, since most key
    # bindings are handled by Qt::Shortcuts (for speed reason, mostly).
    def keyPressEvent(ev)
      if ev.matches(Qt::KeySequence::Copy)
        Qt::Application.clipboard.text = text_cursor.selected_text
        return
      end

      if is_read_only
        ev.ignore
        return
      end

      if ev.matches(Qt::KeySequence::Paste) && can_write?
        text_cursor.insert_text Qt::Application.clipboard.text
        highlight
        return
      end

      cursor = text_cursor
      txt    = ev.text

      if cursor.position >= @min_position &&
            !txt.empty? &&
          !txt.between?("\C-a", "\C-z")
        cursor.clear_selection
        cursor.insert_text txt
        highlight
      else
        ev.ignore
      end

      if completing? && @input.completion_proc
        if completion_pos == @completion_pos
          update_completion_prefix
        else
          @completer.popup.hide
        end
      end
    end

    # Redefine copy and paste

    def canInsertFromMimData(src)
      src.has_text && can_write?
    end

    def insertFromMimeData(src)
      text_cursor.insert_text src.text
      highlight
    end

    # Disable cut using mouse

    def dragEnterEvent(ev); end
    def dragMoveEvent(ev);  end
    def dragLeaveEvent(ev); end

    private

    # Sets up some parameters related to the TextEdit widget itself (e.g. word
    # wrap)
    def setup_style
      self.read_only      = true
      self.word_wrap_mode = Qt::TextOption::WrapAnywhere
    end

    # Creates a completer bound to the widget. Actual completions to pick from
    # are set later on, using @input.completion_proc.
    def setup_completer
      @completer = Qt::Completer.new

      @completer.widget           = self
      @completer.completion_mode  = Qt::Completer::PopupCompletion
      @completer.case_sensitivity = Qt::CaseSensitive

      @completer.connect(SIGNAL("activated(QString)")) { |completion|
        insert_completion(completion)
      }

      @completion_pos = 0 # index of the completed character
    end

    # Starts the REPL.
    #
    # The REPL runs in a fiber, which will allow interaction with the Pry
    # instance by yielding in the input and output objects.
    #
    # Notice this methods assumes the widget is already read to get
    def create_repl
      @pry_fiber = Fiber.new do
        loop do
          @input  = Input.new
          @output = Output.new

          Pry.start(@object, :input => @input, :output => @output)
        end
      end

      handle_fiber # wait until we're asked for the first line of input
    end

    # Makes the widget interact with Pry.
    #
    # This will read everything Pry sends us until we are asked for another line
    # of input, and also send a first line if needed.
    #
    # @param [String, nil] input If set, is sent to Pry as an input line.
    def handle_fiber(input = nil)
      Qt::Application.set_override_cursor Qt::Cursor.new(Qt::WaitCursor)

      loop do
        instruction, arg = @pry_fiber.resume(input)

        case instruction
        when :write
          add_result arg
        when :wait
          wait_for_line arg
          Qt::Application.restore_override_cursor
          return
        end
      end
    end
  end
end
