require File.expand_path("../helpers.rb", __FILE__)

context "a widget config" do
  setup { Pride::Config::WidgetConfig.new }

  asserts(:each_shortcut).same_elements []

  asserts(:action_for, "Ctrl+A").nil
  asserts(:action_for, "Ctrl+B").nil
  asserts(:action_for, "Ctrl+C").nil

  context "after binding" do
    hookup do
      @some_proc       = proc {}
      @some_other_proc = proc {}

      topic.bind("Ctrl+A", &@some_proc)
      topic.bind("Ctrl+C", &@some_other_proc)
    end

    asserts(:each_shortcut).same_elements {
      [
       ["Ctrl+A", @some_proc],
       ["Ctrl+C", @some_other_proc],
      ]
    }

    asserts(:action_for, "Ctrl+A").equals { @some_proc }
    asserts(:action_for, "Ctrl+B").nil
    asserts(:action_for, "Ctrl+C").equals { @some_other_proc }

    context "after unbinding" do
      hookup do
        topic.unbind "Ctrl+A"
      end

      asserts(:each_shortcut).same_elements {
        [
         ["Ctrl+C", @some_other_proc],
        ]
      }

      asserts(:action_for, "Ctrl+A").nil
      asserts(:action_for, "Ctrl+B").nil
      asserts(:action_for, "Ctrl+C").equals { @some_other_proc }
    end
  end
end
