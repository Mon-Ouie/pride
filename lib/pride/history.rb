module Pride
  # Wrapper to access Pride's history
  class History
    # @param [Pry::History] history History object managed by Pry
    def initialize(history = Pry.history)
      @pry_history      = history
      @modified_history = {}

      self.index = 0
    end

    # @return [Pry::History]
    attr_reader :pry_history

    # @return [Integer] Index, relatively to the end of history, where 0 is a
    #   new line and 1 the last line in history.
    attr_reader :index

    # Sets a new index, making sure it fits within the size of the history.
    #
    # @param [Integer] index New index. Can be negative.
    def index=(index)
      size = @pry_history.to_a.size

      if index > size
        @index = size
      elsif index < 0
        @index = 0
      else
        @index = index
      end
    end

    # Saves the line for an index, so that changes added by the user are
    # remembered until a new line gets entered.
    def save_line(line)
      @modified_history[@index] = line.dup
    end

    # Selects the previous line
    # @return [Boolean] True if the index has changed
    def to_previous_line
      old_index = @index
      self.index += 1
      @index != old_index
    end

    # Selects the next line
    # @return [Boolean] True if the index has changed
    def to_next_line
      old_index = @index
      self.index -= 1
      @index != old_index
    end

    # @return [String]
    def current_line
      if cached_line = @modified_history[@index]
        cached_line
      elsif @index == 0
        ""
      else
        # Moral consolation: Array#dup doesn't really copy the buffer unless it
        # is needed.

        @pry_history.to_a[-@index]
      end
    end

    # Resets the index to point to the last line. Also clears modified lines.
    def reset_index
      @modified_history.clear
      self.index = 0
    end
  end
end
