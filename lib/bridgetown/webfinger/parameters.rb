# frozen_string_literal: true

require "uri"

module Bridgetown
  module Webfinger
    # Parses URI parameters in the Webfinger style
    #
    # This is necessary because Rack handles parameters differently than the
    # Webfinger specification. In Rack, repeated parameters compete in a
    # last-one-wins scheme. For example:
    #
    #     https://example.com?foo=1&foo=2&bar=3
    #
    # parses into:
    #
    #     {"foo" => 2, "bar" => 3}
    #
    # whereas Webfinger's processing [wants this][1]:
    #
    #     {"foo" => [1, 2], "bar" => 3}
    #
    # per the phrasing “the "rel" parameter MAY be included multiple times in
    # order to request multiple link relation types.”
    #
    # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.3
    #
    # @since 0.1.0
    # @api private
    class Parameters
      # Splits query parameters at the ampersand and optional spaces
      #
      # This was borrowed from [Rack::QueryParser][2] and simplified.
      #
      # [2]: https://rubydoc.info/gems/rack/Rack/QueryParser
      SPLITTER = %r{& *}n

      # Parses a query string for a webfinger request into a hash
      #
      # This method cleans any unrelated parameters from the result and combines
      # multiple requests for `rel`s into an array. It also handles unescaping
      # terms.
      #
      # @since 0.1.0
      # @api private
      #
      # @param [String] query_string the query string for a webfinger request
      # @return [Parameters] the cleaned param values
      def self.from_query_string(query_string)
        query_string
          .split(SPLITTER)
          .map { |pair| pair.split("=", 2).map! { |component| decode(component) } }
          .each_with_object(Parameters.new) do |(param, value), result|
            case param
            when "resource" then result.resource = value
            when "rel" then result.add_rel(value)
            end
          end
      end

      # Decodes a URI component; an alias to the URI method, for brevity
      #
      # @since 0.1.0
      # @api private
      # @private
      #
      # @param component [String] the component from the URI
      # @return [String] the decoded component
      private_class_method def self.decode(component)
        URI.decode_uri_component(component)
      end

      # Creates a new {Parameters} from an optional resource and rel
      #
      #
      #
      # @since 0.1.0
      # @api public
      #
      # @example Create an empty
      #
      # @param resource [String, nil] the resource for the request
      # @param rel [Array<String>, nil] the types of relation to scope the links to
      # @return [void]
      def initialize(resource: nil, rel: nil)
        @resource = resource
        @rel = rel
      end

      # The list of link relations requested within the {Parameters}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Reading the link relations requested as a URL parameter
      #
      #   params = Bridgetown::Webfinger::Parameters.from_query_string(
      #     "resource=acct%3Abilbo%40bagend.com&" \
      #     "rel=http%3A%2F%2Fwebfinger.net%2Frel%2Favatar&" \
      #     "rel=http%3A%2F%2Fwebfinger.net%2Frel%2Fprofile-page"
      #   )
      #   params.rel
      #   #=> ["https://webfinger.net/rel/avatar", "https://webfinger.net/rel/profile-page"]
      # @return [Array<String>, nil] the types of relation to scope the links to
      attr_reader :rel

      # The decoded resource requested within the {Parameters}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Reading the resource requested as a URL parameter
      #
      #    params = Bridgetown::Webfinger::Parameters.from_query_string(
      #      "resource=acct%3Abilbo%40bagend.com"
      #    )
      #    params.resource #=> "acct:bilbo@bagend.com"
      #
      # @return [String, nil] the resource for the request
      attr_accessor :resource

      # Checks for value object equality
      #
      # @since 0.1.0
      # @api private
      #
      # @param other [Parameters] the other parameter set to compare against
      # @return [Boolean] true when they are equal, false otherwise
      def ==(other)
        other.instance_of?(Parameters) &&
          resource == other.resource &&
          rel == other.rel
      end
      alias_method :eql?, :==

      # Adds a link relation, or "rel," to the {Parameters}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Adding a link relation to a new {Parameters} instance
      #
      #   params = Bridgetown::Webfinger::Parameters.new
      #   params.add_rel("http://webfinger.net/rel/avatar")
      #   params.rel  #=> ["http://webfinger.net/rel/avatar"]
      #
      # @param rel [String] a type of relation to add to the scope request
      # @return [void]
      def add_rel(rel)
        return unless rel

        (@rel ||= []).push(rel)
      end

      # Allows the {Parameters} to be used in a Hash key; part of value object semantics
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Integer]
      def hash
        [resource, *rel].hash
      end
    end
  end
end
