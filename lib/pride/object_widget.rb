module Pride
  # This is the widget Pry is going to use when it displays detailed information
  # about an object. The default implementation just includes an ObjectTerminal,
  # but you can add any information you want in subclasses.
  class ObjectWidget < Qt::Widget
    def initialize(object, parent = nil)
      super(parent)

      @object = object

      self.layout = Qt::VBoxLayout.new do |layout|
        layout.add_widget title_label("Terminal")
        layout.add_widget(@term = ObjectTerminal.new(@object, self))
      end

      load_shortcuts
    end

    # @return [Object]
    attr_reader :object

    # @return [ObjectTerminal]
    attr_reader :term

    def reload
      load_shortcuts
      @term.reload
    end

    private

    def load_shortcuts
      Config.object.inject_shortcuts self
    end

    # @param [String] title HTML-safe title of a section
    # @return [Qt::Label] Label that gives a title-style to the text
    def title_label(title)
      Qt::Label.new("<h1>#{title}</h1>", self) do |label|
        label.text_format = Qt::RichText
      end
    end
  end
end

class Object
  # @return [Pride::ObjectWidget] Widget displaying information about an
  #   object. This method can be redefined as needed.
  def to_pride_widget
    Pride::ObjectWidget.new self
  end
end
