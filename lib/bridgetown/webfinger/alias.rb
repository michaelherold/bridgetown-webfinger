# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps an `alias` member within a {JRD}, which is a URI identifying the same subject
    class Alias < Model
      # Parses and maybe-returns an {Alias} when the value is one
      #
      # Aliases [must be URIs][1] so when the value is not a proper URI, it is
      # ignored.
      #
      # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.2
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Alias, nil] an {Alias} when the value is a URI, nil otherwise
      def self.parse(moniker)
        if Webfinger.uri?(moniker)
          new(moniker)
        else
          warn(
            "Webfinger alias is malformed: #{moniker.inspect}, ignoring"
          )
        end
      end
    end
  end
end
