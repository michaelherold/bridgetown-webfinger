# frozen_string_literal: true

require "bridgetown-webfinger"

Bridgetown.configure do |config|
  url "https://bagend.com"

  init "bridgetown-webfinger", static: false
end
