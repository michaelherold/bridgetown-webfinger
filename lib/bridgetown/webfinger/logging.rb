# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Helper methods for logging purposes
    module Logging
      # When including the module, also extend it as well
      #
      # @since 0.1.0
      # @api private
      # @private
      #
      # @param base [Module] the base module or class including the module
      # @return [void]
      def self.included(base)
        super
        base.extend(self)
      end

      # Sends a warning message through the Bridgetown logger
      #
      # @since 0.1.0
      # @api public
      #
      # @example Print a warning in the logger
      #
      #    extend Bridgetown::Webfinger::Logging
      #    warn "I like some of you less than you deserve"
      #
      # @param msg [String] the message to log
      # @return [void]
      def warn(msg)
        Bridgetown.logger.warn(msg)
        nil
      end
    end
  end
end
