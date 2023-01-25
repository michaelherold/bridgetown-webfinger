# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # A wrapper for wrapping models within a {JRD}
    #
    # @since 0.1.0
    # @api private
    class Model < SimpleDelegator
      include Logging
    end
  end
end
