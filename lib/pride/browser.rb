require 'pride/browser/tree'
require 'pride/browser/class_tree'

module Pride
  # Displays different trees of objects that can be accessed by the users.
  class Browser < Qt::TabWidget
    def initialize
      super()

      @trees = []

      add_tab(class_tree = ClassTree.new, "Modules")
      @trees << class_tree

      @trees.each do |tree|
        tree.connect(SIGNAL("object_selected(QVariant)")) do |obj|
          emit object_selected(obj)
        end
      end

      reload
    end

    # Filters some of the items in the currently shown tree.
    #
    # @param [String] filter Wildcard matching items to show
    def filter(filter)
      current_widget.filter filter
    end

    # Reloads the widget and its shortcuts.
    def reload
      Config.object.inject_shortcuts self
      @trees.each(&:reload)
    end

    signals "object_selected(QVariant)"
  end
end
