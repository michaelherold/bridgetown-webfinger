# frozen_string_literal: true

# @param config [Bridgetown::Configuration::ConfigurationDSL]
# @param allowed_origins [String] the value to use for the
#   `Access-Control-Allow-Origin` header in the Roda plugin. Only override this
#   if you're hosting private Webfinger data due to the [spec][1] saying, "servers
#   SHOULD support the least restrictive setting"
# @param static [Boolean] whether to use static file rendering or not
#
# [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-5
Bridgetown.initializer "bridgetown-webfinger" do |config, allowed_origins: "*", static: true|
  options = {allowed_origins: allowed_origins, static: static}

  # :nocov: Because it's not possible to show coverage for both branches
  if config.webfinger
    config.webfinger Bridgetown::Utils.deep_merge_hashes(options, config.webfinger)
  else
    config.webfinger(options)
  end
  # :nocov:

  config.builder Bridgetown::Webfinger::Builder
end
