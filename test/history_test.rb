require File.expand_path("../helpers.rb", __FILE__)

context "a history" do
  setup do
    pry_hist = Pry::History.new

    ("0".."9").each do |c|
      pry_hist << "#{c}"
    end

    Pride::History.new(pry_hist)
  end

  asserts(:current_line).empty

  context "after modifiying line" do
    hookup { topic.save_line("foo bar") }

    asserts(:current_line).equals "foo bar"
    asserts(:index).equals 0

    context "and going up" do
      hookup { topic.to_previous_line }

      asserts(:current_line).equals "9"
      asserts(:index).equals 1

      context "and changing that line" do
        hookup { topic.save_line("baz") }

        asserts(:current_line).equals "baz"
        asserts(:index).equals 1

        context "and going back down" do
          hookup { topic.to_next_line }

          asserts(:current_line).equals "foo bar"
          asserts(:index).equals 0

          context "twice" do
            hookup { topic.to_next_line }

            asserts(:current_line).equals "foo bar"
            asserts(:index).equals 0
          end
        end

        context "and resetting" do
          hookup { topic.reset_index }

          asserts(:current_line).empty
          asserts(:index).equals 0

          context "and going back up" do
            hookup { topic.to_previous_line }

            asserts(:current_line).equals "9"
            asserts(:index).equals 1

            context "twice" do
              hookup { topic.to_previous_line }

              asserts(:current_line).equals "8"
              asserts(:index).equals 2
            end
          end
        end

        context "and going up again" do
          hookup { topic.to_previous_line }

          asserts(:current_line).equals "8"
          asserts(:index).equals 2
        end
      end
    end
  end

  context "after going all the way up" do
    hookup { 15.times { topic.to_previous_line } }

    asserts(:current_line).equals "0"
    asserts(:index).equals 10
  end
end
