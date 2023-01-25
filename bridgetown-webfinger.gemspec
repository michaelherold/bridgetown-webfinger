# frozen_string_literal: true

require_relative "lib/bridgetown/webfinger/version"

Gem::Specification.new do |spec|
  spec.name = "bridgetown-webfinger"
  spec.version = Bridgetown::Webfinger::VERSION
  spec.author = "Michael Herold"
  spec.email = "opensource@michaeljherold.com"
  spec.summary = "Adds structured support for Webfinger to Bridgetown sites"
  spec.homepage = "https://github.com/michaelherold/bridgetown-webfinger"
  spec.license = "MIT"

  spec.files = %w[CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[bridgetown-webfinger.gemspec]
  spec.files += Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "bridgetown", ">= 1.0", "< 2.0"
  spec.add_dependency "uri", ">= 0.12.0"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler", ">= 1.16"
end
