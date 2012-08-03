module Pride
  # Object meant to filter all events of the application, to prevent
  # ShortcutOverride events from being used. Those prevent us from using a
  # shortcut bound to e.g. Ctrl+A when a TextEdit is selected, which is not what
  # we want.
  #
  # @example
  #    app = Qt::Application.new
  #    app.install_event_filter EventFilter.new
  class EventFilter < Qt::Object
    protected
    def eventFilter(obj, event)
      event.type == Qt::Event::ShortcutOverride
    end
  end
end
