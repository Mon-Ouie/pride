module Pride
  class Window < Qt::MainWindow
    def initialize
      super()

      self.central_widget = @tabs = Qt::TabWidget.new
      self.status_bar = Qt::StatusBar.new

      add_dock_widget Qt::LeftDockWidgetArea,
                      Qt::DockWidget.new("Object browser") { |dock|
        dock.features = Qt::DockWidget::DockWidgetMovable ||
                        Qt::DockWidget::DockWidgetFloatable
        dock.widget = @browser = Browser.new
      }

      @browser.connect SIGNAL("object_selected(QVariant)") do |obj|
        open_object obj.value
      end

      reload
      open_object TOPLEVEL_BINDING

      @in_query = false
    end

    # @return [Qt::TabWidget]
    attr_reader :tabs

    # @return [Browser]
    attr_reader :browser

    # @return [Boolean] True when a query is taking place.
    def in_query?
      @in_query
    end

    # Reolads the widget's configuration
    def reload
      Config.window.inject_shortcuts self

      ANSIToQt.reload
      @browser.reload

      @tabs.count.times do |i|
        @tabs.widget(i).reload
      end
    end

    # Asks for user to input a string. Upon completion, a block gets called with
    # the new line.
    #
    # @param [String] label Label showed before the prompt
    # @option opts [Boolean] :interactive If true, the block will be called
    #   after every change, with two arguments: two lines, and a boolean that is
    #   true only when the user presses return.
    #
    def query(label, opts = {})
      return if @in_query

      interactive = opts[:interactive]

      @in_query = true

      status_bar.clear_message

      status_bar.add_widget(label = Qt::Label.new(label, status_bar))
      status_bar.add_widget Qt::LineEdit.new(status_bar) { |line|
        line.set_focus Qt::ShortcutFocusReason

        if interactive
          yield "", false # start with an empty string

          line.connect SIGNAL("textChanged(QString)") do |text|
            yield text, false
          end

          line.connect SIGNAL("returnPressed()") do
            yield line.text, true
            end_query(label, line)
          end
        else
          line.connect SIGNAL("returnPressed()") do
            yield line.text unless line.text.empty?
            end_query(label, line)
          end
        end
      }, 1
    end

    # Marks the end of a query, thus removing the temporary widget that had been
    # added.
    #
    # @param [Qt::Label] label
    # @param [Qt::LineEdit] line
    def end_query(label, line)
      status_bar.remove_widget label
      status_bar.remove_widget line
      @in_query = false
    end

    # Sets a new temporary message
    # @param [String] msg
    def show_message(msg)
      status_bar.show_message msg
    end

    # Removes the temporary message
    def clear_message
      status_bar.clear_message
    end

    # @return [String] Current temporary message
    def current_message
      status_bar.current_message
    end

    # @retun [ObjectWidget]
    def current_page
      @tabs.current_widget
    end

    # Opens a new object in a tab.
    #
    # @param [Object] obj
    def open_object(obj)
      # Pride should work even with "weird" objects (up to some point at least),
      # including BasicObject.new which does not implement is_a? or
      # respond_to?.

      target = Binding === obj ? obj.eval("self") : obj

      term = begin
               obj.to_pride_widget
             rescue NoMethodError
               ObjectWidget.new(obj)
             end

      @tabs.add_tab(term, Pry.view_clip(target))
    end
  end
end
