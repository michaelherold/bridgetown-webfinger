require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"

Rake::TestTask.new(:test) do |t|
  t.libs.concat(["lib", "test"])
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: [:test, "standard:fix"]
