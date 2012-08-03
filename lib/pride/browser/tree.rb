module Pride
  class Browser < Qt::TabWidget
    # A tree widget designed to display objects. Clicking on those objects
    # triggers a signal, mainly to allow opening them in a new tap.
    class Tree < Qt::TreeView
      # Regular item, simply attached to an arbitrary ruby object.
      class Item < Qt::StandardItem
        def initialize(object)
          super Pry.view_clip(object)
          @object = object
        end

        attr_reader :object
      end

      def initialize
        super()

        self.header_hidden = true

        # Kept as an ivar because Qt won't keep a reference to this for us
        @model = Qt::StandardItemModel.new

        @proxy_model = Qt::SortFilterProxyModel.new
        @proxy_model.source_model        = @model
        @proxy_model.dynamic_sort_filter = true
        @proxy_model.filter_key_column   = 0

        self.sorting_enabled = true

        self.model = @proxy_model

        reload

        connect(SIGNAL("activated(const QModelIndex&)")) do |index|
          index = @proxy_model.map_to_source(index)
          obj   = @model.item_from_index(index).object

          emit object_selected(RubyVariant.new(obj))
        end
      end

      # Reloads the widget's content as needed. Defaults to a no-op.
      def reload
      end

      # Defines a filter to select which items to show.
      #
      # @param [String] filter Wildcard matching all the items to show
      def filter(filter)
        @proxy_model.filter_reg_exp = Qt::RegExp.new(filter,
                                                     Qt::CaseInsensitive,
                                                     Qt::RegExp::Wildcard)
      end

      signals "object_selected(QVariant)"
    end
  end
end
