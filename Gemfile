# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "bridgetown", ENV["BRIDGETOWN_VERSION"] if ENV["BRIDGETOWN_VERSION"]

group :development do
  gem "inch"
  gem "pry"
  gem "pry-byebug"
  gem "rackup" # for yard server; https://github.com/lsegal/yard/issues/1473
  gem "rake"
  gem "standard"
  gem "yard"
end

group :test do
  gem "minitest"
  gem "minitest-reporters"
  gem "rack-test"
  gem "simplecov"
end
