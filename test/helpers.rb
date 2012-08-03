$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'riot'
require 'pride'

Riot.reporter = Riot::PrettyDotMatrixReporter

TestApp = Qt::Application.new []

def tree_items(text)
  topic.model.source_model.find_items(text)
end

def tree_item(text)
  tree_items(text).first
end

def tree_has_item?(text)
  tree_items(text).size > 0
end

def def_class(name)
  undef_class(name) if Object.const_defined? name
  Object.const_set name, Class.new
end

def undef_class(name)
  Object.send :remove_const, name
end

def item_children
  Array.new(topic.row_count) do |i|
    topic.child i
  end
end

def item_has_child?(text)
  item_children.any? { |c| c.text == text }
end

def expect_signals(widget, signals)
  result = false

  signals.each do |sig, action|
    topic.connect(SIGNAL(sig)) do |*args|
      result = action.call(*args)
    end
  end

  yield widget

  result
end
