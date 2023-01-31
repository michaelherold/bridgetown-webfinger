# frozen_string_literal: true

# @param config [Bridgetown::Configuration::ConfigurationDSL]
# @param static [Boolean] whether to use static file rendering or not
Bridgetown.initializer "bridgetown-webfinger" do |config, static: true|
  options = {static: static}

  # :nocov: Because it's not possible to show coverage for both branches
  if config.webfinger
    config.webfinger Bridgetown::Utils.deep_merge_hashes(options, config.webfinger)
  else
    config.webfinger(options)
  end
  # :nocov:

  config.builder Bridgetown::Webfinger::Builder
end
