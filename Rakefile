require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"

Rake::TestTask.new(:test) do |t|
  t.libs.concat(["lib", "test"])
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

namespace :data do
  desc "Pull the list of current registered link relations from the IANA database"
  task :link_relations do
    require "csv"
    require "open-uri"

    URI
      .open("https://www.iana.org/assignments/link-relations/link-relations-1.csv")
      .then { |csv| CSV.parse(csv, headers: true) }
      .then { |csv| csv["Relation Name"] }
      .each { |rel| puts rel }
  end
end

task default: [:test, "standard:fix"]
