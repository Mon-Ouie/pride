# -*- coding: utf-8 -*-

module Pride
  # Within Config resides Pride's user-modifiable configuration — colors, key
  # bindings, etc.
  module Config
    # @return [Array<Qt::Color>] All 256 colors supported by Pride, mostly used
    #   when translating ANSI color codes.
    DefaultColors = [# XTerm's 256 colors
                     Qt::Color.new(0, 0, 0),       # Black
                     Qt::Color.new(205, 0, 0),     # Red
                     Qt::Color.new(0, 205, 0),     # Green
                     Qt::Color.new(205, 205, 0),   # Yellow
                     Qt::Color.new(0, 0, 205),     # Blue
                     Qt::Color.new(205, 0, 205),   # Maegnta
                     Qt::Color.new(0, 205, 205),   # Cyan
                     Qt::Color.new(229, 229, 229), # White

                     Qt::Color.new(77, 77, 77),    # Bright colors
                     Qt::Color.new(255, 0, 0),
                     Qt::Color.new(0, 255, 0),
                     Qt::Color.new(255, 255, 0),
                     Qt::Color.new(0, 0, 255),
                     Qt::Color.new(255, 0, 255),
                     Qt::Color.new(0, 255, 255),
                     Qt::Color.new(255, 255, 255),

                     Qt::Color.new(0, 0, 0),
                     Qt::Color.new(0, 0, 95),
                     Qt::Color.new(0, 0, 135),
                     Qt::Color.new(0, 0, 175),
                     Qt::Color.new(0, 0, 215),
                     Qt::Color.new(0, 0, 255),
                     Qt::Color.new(0, 95, 0),
                     Qt::Color.new(0, 95, 95),
                     Qt::Color.new(0, 95, 135),
                     Qt::Color.new(0, 95, 175),
                     Qt::Color.new(0, 95, 215),
                     Qt::Color.new(0, 95, 255),
                     Qt::Color.new(0, 135, 0),
                     Qt::Color.new(0, 135, 95),
                     Qt::Color.new(0, 135, 135),
                     Qt::Color.new(0, 135, 175),
                     Qt::Color.new(0, 135, 215),
                     Qt::Color.new(0, 135, 255),
                     Qt::Color.new(0, 175, 0),
                     Qt::Color.new(0, 175, 95),
                     Qt::Color.new(0, 175, 135),
                     Qt::Color.new(0, 175, 175),
                     Qt::Color.new(0, 175, 215),
                     Qt::Color.new(0, 175, 255),
                     Qt::Color.new(0, 215, 0),
                     Qt::Color.new(0, 215, 95),
                     Qt::Color.new(0, 215, 135),
                     Qt::Color.new(0, 215, 175),
                     Qt::Color.new(0, 215, 215),
                     Qt::Color.new(0, 215, 255),
                     Qt::Color.new(0, 255, 0),
                     Qt::Color.new(0, 255, 95),
                     Qt::Color.new(0, 255, 135),
                     Qt::Color.new(0, 255, 175),
                     Qt::Color.new(0, 255, 215),
                     Qt::Color.new(0, 255, 255),
                     Qt::Color.new(95, 0, 0),
                     Qt::Color.new(95, 0, 95),
                     Qt::Color.new(95, 0, 135),
                     Qt::Color.new(95, 0, 175),
                     Qt::Color.new(95, 0, 215),
                     Qt::Color.new(95, 0, 255),
                     Qt::Color.new(95, 95, 0),
                     Qt::Color.new(95, 95, 95),
                     Qt::Color.new(95, 95, 135),
                     Qt::Color.new(95, 95, 175),
                     Qt::Color.new(95, 95, 215),
                     Qt::Color.new(95, 95, 255),
                     Qt::Color.new(95, 135, 0),
                     Qt::Color.new(95, 135, 95),
                     Qt::Color.new(95, 135, 135),
                     Qt::Color.new(95, 135, 175),
                     Qt::Color.new(95, 135, 215),
                     Qt::Color.new(95, 135, 255),
                     Qt::Color.new(95, 175, 0),
                     Qt::Color.new(95, 175, 95),
                     Qt::Color.new(95, 175, 135),
                     Qt::Color.new(95, 175, 175),
                     Qt::Color.new(95, 175, 215),
                     Qt::Color.new(95, 175, 255),
                     Qt::Color.new(95, 215, 0),
                     Qt::Color.new(95, 215, 95),
                     Qt::Color.new(95, 215, 135),
                     Qt::Color.new(95, 215, 175),
                     Qt::Color.new(95, 215, 215),
                     Qt::Color.new(95, 215, 255),
                     Qt::Color.new(95, 255, 0),
                     Qt::Color.new(95, 255, 95),
                     Qt::Color.new(95, 255, 135),
                     Qt::Color.new(95, 255, 175),
                     Qt::Color.new(95, 255, 215),
                     Qt::Color.new(95, 255, 255),
                     Qt::Color.new(135, 0, 0),
                     Qt::Color.new(135, 0, 95),
                     Qt::Color.new(135, 0, 135),
                     Qt::Color.new(135, 0, 175),
                     Qt::Color.new(135, 0, 215),
                     Qt::Color.new(135, 0, 255),
                     Qt::Color.new(135, 95, 0),
                     Qt::Color.new(135, 95, 95),
                     Qt::Color.new(135, 95, 135),
                     Qt::Color.new(135, 95, 175),
                     Qt::Color.new(135, 95, 215),
                     Qt::Color.new(135, 95, 255),
                     Qt::Color.new(135, 135, 0),
                     Qt::Color.new(135, 135, 95),
                     Qt::Color.new(135, 135, 135),
                     Qt::Color.new(135, 135, 175),
                     Qt::Color.new(135, 135, 215),
                     Qt::Color.new(135, 135, 255),
                     Qt::Color.new(135, 175, 0),
                     Qt::Color.new(135, 175, 95),
                     Qt::Color.new(135, 175, 135),
                     Qt::Color.new(135, 175, 175),
                     Qt::Color.new(135, 175, 215),
                     Qt::Color.new(135, 175, 255),
                     Qt::Color.new(135, 215, 0),
                     Qt::Color.new(135, 215, 95),
                     Qt::Color.new(135, 215, 135),
                     Qt::Color.new(135, 215, 175),
                     Qt::Color.new(135, 215, 215),
                     Qt::Color.new(135, 215, 255),
                     Qt::Color.new(135, 255, 0),
                     Qt::Color.new(135, 255, 95),
                     Qt::Color.new(135, 255, 135),
                     Qt::Color.new(135, 255, 175),
                     Qt::Color.new(135, 255, 215),
                     Qt::Color.new(135, 255, 255),
                     Qt::Color.new(175, 0, 0),
                     Qt::Color.new(175, 0, 95),
                     Qt::Color.new(175, 0, 135),
                     Qt::Color.new(175, 0, 175),
                     Qt::Color.new(175, 0, 215),
                     Qt::Color.new(175, 0, 255),
                     Qt::Color.new(175, 95, 0),
                     Qt::Color.new(175, 95, 95),
                     Qt::Color.new(175, 95, 135),
                     Qt::Color.new(175, 95, 175),
                     Qt::Color.new(175, 95, 215),
                     Qt::Color.new(175, 95, 255),
                     Qt::Color.new(175, 135, 0),
                     Qt::Color.new(175, 135, 95),
                     Qt::Color.new(175, 135, 135),
                     Qt::Color.new(175, 135, 175),
                     Qt::Color.new(175, 135, 215),
                     Qt::Color.new(175, 135, 255),
                     Qt::Color.new(175, 175, 0),
                     Qt::Color.new(175, 175, 95),
                     Qt::Color.new(175, 175, 135),
                     Qt::Color.new(175, 175, 175),
                     Qt::Color.new(175, 175, 215),
                     Qt::Color.new(175, 175, 255),
                     Qt::Color.new(175, 215, 0),
                     Qt::Color.new(175, 215, 95),
                     Qt::Color.new(175, 215, 135),
                     Qt::Color.new(175, 215, 175),
                     Qt::Color.new(175, 215, 215),
                     Qt::Color.new(175, 215, 255),
                     Qt::Color.new(175, 255, 0),
                     Qt::Color.new(175, 255, 95),
                     Qt::Color.new(175, 255, 135),
                     Qt::Color.new(175, 255, 175),
                     Qt::Color.new(175, 255, 215),
                     Qt::Color.new(175, 255, 255),
                     Qt::Color.new(215, 0, 0),
                     Qt::Color.new(215, 0, 95),
                     Qt::Color.new(215, 0, 135),
                     Qt::Color.new(215, 0, 175),
                     Qt::Color.new(215, 0, 215),
                     Qt::Color.new(215, 0, 255),
                     Qt::Color.new(215, 95, 0),
                     Qt::Color.new(215, 95, 95),
                     Qt::Color.new(215, 95, 135),
                     Qt::Color.new(215, 95, 175),
                     Qt::Color.new(215, 95, 215),
                     Qt::Color.new(215, 95, 255),
                     Qt::Color.new(215, 135, 0),
                     Qt::Color.new(215, 135, 95),
                     Qt::Color.new(215, 135, 135),
                     Qt::Color.new(215, 135, 175),
                     Qt::Color.new(215, 135, 215),
                     Qt::Color.new(215, 135, 255),
                     Qt::Color.new(215, 175, 0),
                     Qt::Color.new(215, 175, 95),
                     Qt::Color.new(215, 175, 135),
                     Qt::Color.new(215, 175, 175),
                     Qt::Color.new(215, 175, 215),
                     Qt::Color.new(215, 175, 255),
                     Qt::Color.new(215, 215, 0),
                     Qt::Color.new(215, 215, 95),
                     Qt::Color.new(215, 215, 135),
                     Qt::Color.new(215, 215, 175),
                     Qt::Color.new(215, 215, 215),
                     Qt::Color.new(215, 215, 255),
                     Qt::Color.new(215, 255, 0),
                     Qt::Color.new(215, 255, 95),
                     Qt::Color.new(215, 255, 135),
                     Qt::Color.new(215, 255, 175),
                     Qt::Color.new(215, 255, 215),
                     Qt::Color.new(215, 255, 255),
                     Qt::Color.new(255, 0, 0),
                     Qt::Color.new(255, 0, 95),
                     Qt::Color.new(255, 0, 135),
                     Qt::Color.new(255, 0, 175),
                     Qt::Color.new(255, 0, 215),
                     Qt::Color.new(255, 0, 255),
                     Qt::Color.new(255, 95, 0),
                     Qt::Color.new(255, 95, 95),
                     Qt::Color.new(255, 95, 135),
                     Qt::Color.new(255, 95, 175),
                     Qt::Color.new(255, 95, 215),
                     Qt::Color.new(255, 95, 255),
                     Qt::Color.new(255, 135, 0),
                     Qt::Color.new(255, 135, 95),
                     Qt::Color.new(255, 135, 135),
                     Qt::Color.new(255, 135, 175),
                     Qt::Color.new(255, 135, 215),
                     Qt::Color.new(255, 135, 255),
                     Qt::Color.new(255, 175, 0),
                     Qt::Color.new(255, 175, 95),
                     Qt::Color.new(255, 175, 135),
                     Qt::Color.new(255, 175, 175),
                     Qt::Color.new(255, 175, 215),
                     Qt::Color.new(255, 175, 255),
                     Qt::Color.new(255, 215, 0),
                     Qt::Color.new(255, 215, 95),
                     Qt::Color.new(255, 215, 135),
                     Qt::Color.new(255, 215, 175),
                     Qt::Color.new(255, 215, 215),
                     Qt::Color.new(255, 215, 255),
                     Qt::Color.new(255, 255, 0),
                     Qt::Color.new(255, 255, 95),
                     Qt::Color.new(255, 255, 135),
                     Qt::Color.new(255, 255, 175),
                     Qt::Color.new(255, 255, 215),
                     Qt::Color.new(255, 255, 255),
                     Qt::Color.new(8, 8, 8),
                     Qt::Color.new(18, 18, 18),
                     Qt::Color.new(28, 28, 28),
                     Qt::Color.new(38, 38, 38),
                     Qt::Color.new(48, 48, 48),
                     Qt::Color.new(58, 58, 58),
                     Qt::Color.new(68, 68, 68),
                     Qt::Color.new(78, 78, 78),
                     Qt::Color.new(88, 88, 88),
                     Qt::Color.new(98, 98, 98),
                     Qt::Color.new(108, 108, 108),
                     Qt::Color.new(118, 118, 118),
                     Qt::Color.new(128, 128, 128),
                     Qt::Color.new(138, 138, 138),
                     Qt::Color.new(148, 148, 148),
                     Qt::Color.new(158, 158, 158),
                     Qt::Color.new(168, 168, 168),
                     Qt::Color.new(178, 178, 178),
                     Qt::Color.new(188, 188, 188),
                     Qt::Color.new(198, 198, 198),
                     Qt::Color.new(208, 208, 208),
                     Qt::Color.new(218, 218, 218),
                     Qt::Color.new(228, 228, 228),
                     Qt::Color.new(238, 238, 238)]

    # @return [String] An ERB template to generate a CSS stylesheet that can be
    #   used to color HTML generated by CodeRay.
    DefaultStylesheet = <<end_of_style
* {
  color: <%= foreground.name %>;
  background-color: <%= background.name %>;
  white-space: pre-wrap;
}

.debug {
  color: black !important;
  background: blue !important;
}

.annotation { color:#007 }
.attribute-name { color:#b48 }
.attribute-value { color:#700 }
.binary { color:#509 }
.char .content { color:#D20 }
.char .delimiter { color:#710 }
.char { color:#D20 }
.class { color:#B06; font-weight:bold }
.class-variable { color:#369 }
.color { color:#0A0 }
.comment { color:#777 }
.comment .char { color:#444 }
.comment .delimiter { color:#444 }
.complex { color:#A08 }
.constant {
  color: <%= colors[3].name %>;
  font-weight:bold
}
.decorator { color:#B0B }
.definition { color:#099; font-weight:bold }
.delimiter { color:black }
.directive { color:#088; font-weight:bold }
.doc { color:#970 }
.doc-string { color:#D42; font-weight:bold }
.doctype { color:#34b }
.entity { color:#800; font-weight:bold }
.error { color:#F00; background-color:#FAA }
.escape  { color:#666 }
.exception { color:#C00; font-weight:bold }
.float { color:#60E }
.function { color:#06B; font-weight:bold }
.global-variable { color:#d70 }
.hex { color:#02b }
.imaginary { color:#f00 }
.include { color:#B44; font-weight:bold }
.inline { background-color: hsla(0,0%,0%,0.07); color: black }
.inline-delimiter { font-weight: bold; color: #666 }
.instance-variable { color:#33B }
.integer  { color:<%= colors[4].name %>; font-weight: bold; }
.key .char { color: #60f }
.key .delimiter { color: #404 }
.key { color: #606 }
.keyword { color:#080; font-weight:bold }
.label { color:#970; font-weight:bold }
.local-variable { color:#963 }
.namespace { color:#707; font-weight:bold }
.octal { color:#40E }
.operator { }
.predefined { color:#369; font-weight:bold }
.predefined-constant { color:#069 }
.predefined-type { color:#0a5; font-weight:bold }
.preprocessor { color:#579 }
.pseudo-class { color:#00C; font-weight:bold }
.regexp .content { color:#808 }
.regexp .delimiter { color:#404 }
.regexp .modifier { color:#C2C }
.regexp { background-color:hsla(300,100%,50%,0.06); }
.reserved { color:#080; font-weight:bold }
.shell .content { color:#2B2 }
.shell .delimiter { color:#161 }
.shell { background-color:hsla(120,100%,50%,0.06); }
.string .char { color: #b0b }
.string .content { color: #D20 }
.string .delimiter { color: #710 }
.string .modifier { color: #E40 }
.string { background-color:hsla(0,100%,50%,0.05); }
.symbol .content { color:#A60 }
.symbol .delimiter { color:#630 }
.symbol { color:#A60 }
.tag { color:#070 }
.type { color:#339; font-weight:bold }
.value { color: #088; }
.variable  { color:#037 }

.insert { background: hsla(120,100%,50%,0.12) }
.delete { background: hsla(0,100%,50%,0.12) }
.change { color: #bbf; background: #007; }
.head { color: #f8f; background: #505 }
.head .filename { color: white; }

.delete .eyecatcher {
  background-color: hsla(0,100%,50%,0.2);
  border: 1px solid hsla(0,100%,45%,0.5);
  margin: -1px;
  border-bottom: none;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
}

.insert .eyecatcher {
  background-color: hsla(120,100%,50%,0.2);
  border: 1px solid hsla(120,100%,25%,0.5);
  margin: -1px;
  border-top: none;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
}

.insert .insert { color: #0c0; background:transparent; font-weight:bold }
.delete .delete { color: #c00; background:transparent; font-weight:bold }
.change .change { color: #88f }
.head .head { color: #f4f }
end_of_style

    # Stores configuration related to a specific widget.
    class WidgetConfig
      def initialize
        @map = {}
      end

      # @yieldparam [String] shortcut Sequence to press to trigger a block
      # @yieldparam [Proc] action
      def each_shortcut(&block)
        @map.each(&block)
      end

      # Defines the shortcuts into a widget's config.
      #
      # @param [Qt::Widget] widget
      def inject_shortcuts(widget)
        each_shortcut do |key, action|
          Pride.add_shortcut(widget, key, &action)
        end
      end

      # Sets a key binding for one or more key sequences.
      #
      # @param [String, Array<String>] key Set of key sequences to bind
      # @param [Proc] action Action to be run when the key is pressed.
      def bind(keys, &action)
        Array(keys).each do |key|
          @map[key] = action
        end
      end

      # @param [String, Array<String>] key Key sequence to unbind
      #
      # Unbinds some key sequences.
      def unbind(keys)
        Array(keys).each do |key|
          @map.delete key
        end
      end

      # @param [Qt::KeySequence] seq A sequence to match
      # @return [Proc, nil] code to run if that sequence is pressed
      def action_for(seq)
        @map[seq]
      end
    end

    @background = Qt::Color.new("black")
    @foreground = Qt::Color.new("white")

    @colors              = DefaultColors.dup
    @stylesheet_template = ERB.new(DefaultStylesheet)

    @window  = WidgetConfig.new
    @term    = WidgetConfig.new
    @object  = WidgetConfig.new
    @browser = WidgetConfig.new

    @live_highlight = true

    class << self
      # @return [Qt::Color] Background color of object terminals.
      attr_accessor :background

      # @return [Qt::Color] Foreground color of object terminals.
      attr_accessor :foreground

      # @return [Array<Qt::Color>] Colors used when translating ANSI color
      #   codes.
      attr_accessor :colors

      # @return [Boolean] True to highlight code as it is typed.
      attr_accessor :live_highlight

      # @return [WidgetConfig]
      attr_reader :window

      # @return [WidgetConfig]
      attr_reader :term

      # @return [WidgetConfig]
      attr_reader :object

      # @return [WidgetConfig]
      attr_reader :browser

      # @param [String] code ERB template to generate a CSS stylsheet to be used
      #   in the object terminal.
      def stylsheet_template=(code)
        @stylesheet_template = ERB.new(code)
      end

      # @return [String] The stylsheet using the current configuration
      def stylesheet
        @stylesheet_template.result(binding)
      end
    end

    window.bind "Alt+R" do
      reload
    end

    window.bind "Alt+X" do
      query "Eval: " do |code|
        begin
          open_object TOPLEVEL_BINDING.eval(code)
        rescue Exception => e
          show_message "#{e.class}: #{e}"
        end
      end
    end

    window.bind "Ctrl+S" do
      query "Search: ", :interactive => true do |filter, done|
        browser.filter filter

        if done
          browser.current_widget.set_focus Qt::ShortcutFocusReason
        end
      end
    end

    window.bind "Alt+Left" do
      @tabs.current_index -= 1
    end

    window.bind "Alt+Right" do
      @tabs.current_index += 1
    end

    window.bind "Alt+T" do
      if page = current_page
        page.term.set_focus Qt::ShortcutFocusReason
      end
    end

    term.bind ["Left", "Ctrl+B"] do
      move_cursor Qt::TextCursor::Left
    end

    term.bind ["Right", "Ctrl+F"] do
      move_cursor Qt::TextCursor::Right
    end

    term.bind ["Up", "Ctrl+N"] do
      if completing?
        select_previous_completion
      elsif can_write?
        to_next_line
      else
        move_cursor Qt::TextCursor::Up
      end
    end

    term.bind ["Down", "Ctrl+P"] do
      if completing?
        select_next_completion
      elsif can_write?
        to_previous_line
      else
        move_cursor Qt::TextCursor::Down
      end
    end

    term.bind "Alt+B" do
      move_cursor Qt::TextCursor::PreviousWord
    end

    term.bind "Alt+F" do
      move_cursor Qt::TextCursor::NextWord
    end

    term.bind "Ctrl+A" do
      if can_write? # to start of writable zone
        change_cursor { |c| c.position = min_position }
      else
        move_cursor Qt::TextCursor::StartOfLine
      end
    end

    term.bind "Ctrl+E" do
      move_cursor Qt::TextCursor::EndOfLine
    end

    term.bind "Return" do
      if completing?
        complete
      elsif can_write?
        submit_line
      end
    end

    term.bind "Escape" do
      if completing?
        completer.popup.hide
      else
        clear_focus
      end
    end

    term.bind "Backspace" do
      if line_pos > 0
        text_cursor.delete_previous_char
        highlight
      end
    end

    term.bind ["Ctrl+W", "Alt+Backspace"] do
      if can_write?
        cursor = text_cursor
        cursor.move_position(Qt::TextCursor::PreviousWord,
                             Qt::TextCursor::KeepAnchor)
        if can_write_from? cursor.position
          cursor.remove_selected_text
          highlight
        end
      end
    end

    term.bind "Ctrl+K" do
      if can_write?
        cursor = text_cursor
        cursor.move_position(Qt::TextCursor::EndOfLine,
                             Qt::TextCursor::KeepAnchor)
        cursor.remove_selected_text
        highlight
      end
    end

    term.bind ["Tab", "Backtab"] do
      if completing?
        complete
      else
        update_completion_prefix
      end
    end
  end
end
