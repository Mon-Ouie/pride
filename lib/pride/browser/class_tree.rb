module Pride
  class Browser < Qt::TabWidget
    # A tree that shows all constants that refer to modules, iterating
    # recursively from top-level constants (i.e. Object).
    class ClassTree < Tree
      def reload
        @model.clear

        root = @model.invisible_root_item

        root.append_row Item.new(Object)
        traverse_module root, Object
      end

      def traverse_module(item, mod, seen = Set.new([mod]))
        mod.constants(false).each do |const|
          begin
            val = mod.const_get(const)
          rescue NameError, LoadError # for autoload
            next
          end

          if !seen.include?(val) && Module === val
            seen << val
            item.append_row  Item.new(val) { |sub_item|
              traverse_module(sub_item, val, seen)
            }
          end
        end
      end
    end
  end
end
