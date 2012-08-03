require File.expand_path("../helpers.rb", __FILE__)

class TestTree < Pride::Browser::Tree
  def initialize
    super

    root.append_row Item.new("foo")
    root.append_row Item.new(3) { |item|
      item.append_row Item.new(:foo)
      item.append_row Item.new(:bar)
    }
    root.append_row Item.new([1, 2, 3, 4, 5])
  end

  def root
    @model.invisible_root_item
  end

  def translate_index(index)
    @proxy_model.map_from_source index
  end
end

context "an object tree" do
  setup { TestTree.new }

  asserts("displays some items directly") do
    tree_has_item? %{"foo"} and tree_has_item? "3"
  end

  asserts("clips if needed") do
    tree_has_item? Pry.view_clip([1, 2, 3, 4, 5])
  end

  asserts("can open items") do
    item = topic.root.child(1).child(0)
    expect_signals(topic,
                   "object_selected(QVariant)" => ->(var) {
                     var.value == :foo
                   }) do
      topic.emit topic.activated(topic.translate_index(item.index))
    end
  end
end
