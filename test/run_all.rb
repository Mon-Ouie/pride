require File.expand_path("../helpers.rb", __FILE__)

Dir.glob File.expand_path("../**/*_test.rb", __FILE__) do |file|
  load file
end
