module Pride
  # Module that allows to insert a string that uses ANSI-code into a terminal
  # object.
  module ANSIToQt
    # Regular exrpession that matches ANSI codes
    Pattern = %r{(\e\[\??\d+(?:[;\d]*)\w)}

    # Set of styles. Gets filled by calling the reload method.
    Styles  = {}

    module_function

    # Recreates the Styles hash from the current config.
    def reload
      colors = Config.colors

      foreground = Config.foreground
      background = Config.background

      Styles[:clear] = Qt::TextCharFormat.new { |fmt|
        fmt.foreground = Qt::Brush.new(foreground)
        fmt.background = Qt::Brush.new(background)

        fmt.font_weight    = Qt::Font::Normal
        fmt.font_italic    = false
        fmt.font_underline = false
      }

      Styles[:normal] = Qt::TextCharFormat.new { |fmt|
        fmt.foreground = Qt::Brush.new(foreground)
        fmt.background = Qt::Brush.new(background)

        fmt.font_weight    = Qt::Font::Normal
        fmt.font_underline = false
      }

      Styles[:bold] = Qt::TextCharFormat.new { |fmt|
        fmt.font_weight = Qt::Font::Bold
      }

      Styles[:no_bold] = Qt::TextCharFormat.new { |fmt|
        fmt.font_weight = Qt::Font::Normal
      }

      Styles[:light] = Qt::TextCharFormat.new { |fmt|
        fmt.font_weight = Qt::Font::Light
      }

      Styles[:italic] = Qt::TextCharFormat.new { |fmt|
        fmt.font_italic = true
      }

      Styles[:no_italic] = Qt::TextCharFormat.new { |fmt|
        fmt.font_italic = false
      }

      Styles[:underline] = Qt::TextCharFormat.new { |fmt|
        fmt.font_underline = true
      }

      Styles[:color] = Array.new(256) do |i|
        Qt::TextCharFormat.new { |fmt|
          fmt.foreground = Qt::Brush.new(colors[i])
        }
      end

      Styles[:default_color] = Qt::TextCharFormat.new { |fmt|
        fmt.foreground = Qt::Brush.new(foreground)
      }

      Styles[:background] = Array.new(256) do |i|
        Qt::TextCharFormat.new { |fmt|
          fmt.background = Qt::Brush.new(colors[i])
        }
      end

      Styles[:default_background] = Qt::TextCharFormat.new { |fmt|
        fmt.background = Qt::Brush.new(background)
      }
    end

    # Inserts a string at a cursor
    #
    # @param [Qt::TextCursor] cursor Cursor to insert the string at
    # @param [String] string String that may contain new-lines and ANSI codes
    def insert(cursor, string)
      string.split(Pattern).each_with_index do |str, i|
        if i.even?
          cursor.insert_text str
        else
          enable_ansi_code(cursor, str)
        end
      end
    end

    # Applies an ANSI code to change text style.
    #
    # @param [Qt::TextCursor] cursor Cursor to apply the style to
    # @param [String] code ANSI code to apply.
    def enable_ansi_code(cursor, code)
      return if code[-1] != "m" # only graphics related codes are supported

      ids = code[(code.index("[") + 1)...-1].split(";").each

      loop do
        case val = ids.next.to_i
        when 38
          case ids.next.to_i
          when 5
            if style = Styles[:color][ids.next.to_i]
              cursor.merge_char_format style
            end
          end
        when 48
          case ids.next.to_i
          when 5
            if style = Styles[:background][ids.next.to_i]
              cursor.merge_char_format style
            end
          end
        else # codes that don't need arguments
          if format = to_format(val)
            cursor.merge_char_format format
          end
        end
      end
    end

    # @param [Integer] id Identifier of some argument for a graphics selection
    #   ANSI code. That code is assumed to not require more arguments.
    # @return [Qt::TextCharFormat, nil] A style to merge with the current one.
    def to_format(id)
      case id
      when 0      then Styles[:clear]
      when 1      then Styles[:bold]
      when 2      then Styles[:light]
      when 3      then Styles[:italic]
      when 4      then Styles[:underline]
      #    5      then # blink (slow)
      #    6      then # blink (rapid)
      #    7      then # invert
      #    8      then # ?
      #    9      then # ?
      #    10     then # default font
      #    11..19 then # alternative font
      #    20     then # ?
      when 21     then Styles[:no_bold]
      when 22     then Styles[:normal]
      when 23     then Styles[:no_italic]
      when 24     then Styles[:no_underline]
      #    25     then # blink off
      #    26     then # nothing
      #    27     then # uninvert
      #    28     then # ?
      #    29     then # ?
      when 30..37 then Styles[:color][id - 30]
      #    38     then # 256-color foreground
      when 39     then Styles[:default_color]
      when 40..47 then Styles[:background][id - 40]
      #    48     then # 256-color background
      when 49     then Styles[:default_background]
      #    50     then # nothing
      #    51     then # ?
      #    52     then # ?
      #    53     then # ?
      #    54     then # ?
      #    56..59 then # nothing
      #    60     then # ?
      #    61     then # ?
      #    62     then # ?
      #    63     then # ?
      #    64     then # ?
      end
    end

    reload
  end
end
