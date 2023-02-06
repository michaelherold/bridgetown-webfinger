# frozen_string_literal: true

Bridgetown.configuration(
  root_dir: __dir__,
  destination: Dir.mktmpdir("bridgetown-webfinger-integration-dest")
)

require "bridgetown-core/rack/boot"

Bridgetown::Rack.boot

run RodaApp.freeze.app
