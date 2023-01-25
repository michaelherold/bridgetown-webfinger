# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps an `href` member within a {Link}, which is the target URI
    class Href < Model
      # Parses and maybe-returns an {Href} when the value is one
      #
      # Hrefs [must be URIs][1] so when the value is not a proper URI, it is
      # ignored.
      #
      # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.4.3
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Href, nil] an {Href} when the value is a URI, nil otherwise
      def self.parse(href)
        if Webfinger.uri?(href)
          new(href)
        else
          warn(
            "Webfinger link href is malformed: #{href.inspect}, ignoring"
          )
        end
      end
    end
  end
end
