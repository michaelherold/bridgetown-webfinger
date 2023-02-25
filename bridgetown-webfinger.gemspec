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

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "bridgetown", ">= 1.2", "< 2.0"
  spec.add_dependency "uri", ">= 0.12.0"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler", ">= 2"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/michaelherold/bridgetown-webfinger/issues",
    "changelog_uri" => "https://github.com/michaelherold/bridgetown-webfinger/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/bridgetown-webfinger/#{Bridgetown::Webfinger::VERSION}",
    "homepage_uri" => "https://github.com/michaelherold/bridgetown-webfinger",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/michaelherold/bridgetown-webfinger"
  }
end
