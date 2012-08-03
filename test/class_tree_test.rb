require File.expand_path("../helpers.rb", __FILE__)

module RandomNamespace
  SomeClass  = Class.new
  SomeModule = Module.new
  SomeObject = Object.new
end

RandomObject = Object.new

context "a class tree" do
  setup { Pride::Browser::ClassTree.new }

  asserts "stores top-level modules" do
    tree_has_item? "RandomNamespace"
  end

  denies "sorts other objects" do
    tree_has_item? "RandomObject"
  end

  context "a module's item" do
    setup { tree_item("RandomNamespace") }

    asserts "contains modules" do
      item_has_child? "RandomNamespace::SomeModule"
    end

    asserts "contains classes" do
      item_has_child? "RandomNamespace::SomeClass"
    end

    denies "contains other objects" do
      item_has_child? "RandomNamespace::SomeObject"
    end
  end

  context "with a new-class defined" do
    hookup do
      def_class :OtherNamespace
      topic.reload
    end

    asserts "added that new class" do
      tree_has_item? "OtherNamespace"
    end

    asserts "keeps old classes" do
      tree_has_item? "RandomNamespace"
    end

    context "with a class removed" do
      hookup do
        undef_class :OtherNamespace
        topic.reload
      end

      denies "still stores that class" do
        tree_has_item? "OtherNamespace"
      end

      asserts "keeps old classes" do
        tree_has_item? "RandomNamespace"
      end
    end
  end
end
