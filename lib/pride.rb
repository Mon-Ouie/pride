# -*- coding: utf-8 -*-

require 'Qt4'
require 'coderay'
require 'erb'
require 'pry'
require 'set'

require 'pride/version'

require 'pride/config'
require 'pride/commands'
require 'pride/history'

require 'pride/ansi_to_qt'
require 'pride/event_filter'
require 'pride/ruby_variant'

require 'pride/object_terminal'
require 'pride/object_widget'
require 'pride/browser'
require 'pride/window'

# This is a temporary work-around for a bug within the Qt bindings. It will be
# removed when the next version gets released.
class << Qt::Internal
  alias _pride_find_pclassid find_pclassid
  private :_pride_find_pclassid

  def find_pclassid(val)
    if String === val
      _pride_find_pclassid val
    else
      Qt::Internal::ModuleIndex.new(nil, nil)
    end
  end
end

module Pride
  module_function
  def start
    # Allows to load usre-defined config from .pryrc
    Pry.initial_session_setup

    app = Qt::Application.new(ARGV)

    win = Pride::Window.new
    win.show

    # Must be called after showing the window. Otherwise, the event filter never
    # gets run (which seems to be related to the use of require within a Fiber,
    # for some reason).
    app.install_event_filter EventFilter.new

    app.exec
  end

  # Defines a shortcut.
  #
  # @param [Qt::Widget] widget Widget which has to be selected for the shortcut
  #    to be usable.
  # @param [String] key Key sequence to press to trigger the shortcut
  # @yield Every time the shortcut is activated, with self set to the widget
  def add_shortcut(widget, key, &block)
    seq = Qt::KeySequence.new(key)

    Qt::Shortcut.new(seq, widget) do |shortcut|
      shortcut.connect(SIGNAL("activated()")) do
        widget.instance_eval(&block)
      end

      shortcut.context = Qt::WidgetWithChildrenShortcut
    end
  end
end
