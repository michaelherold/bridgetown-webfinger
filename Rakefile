require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"

namespace :test do
  desc "Runs unit and integration tests"
  task all: ["test:unit", "test:integration"]

  Rake::TestTask.new(:unit) do |t|
    t.libs.concat(["lib", "test"])
    t.description = "Run unit tests"
    t.test_files = FileList["test/**/*_test.rb"].exclude("test/integration_test.rb")
    t.warning = false
  end

  Rake::TestTask.new(:integration) do |t|
    t.libs.concat(["lib", "test"])
    t.description = "Run integration tests"
    t.test_files = FileList["test/integration_test.rb"]
    t.warning = false
  end
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

task default: ["test:all", "standard:fix"]
