# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps a [link][1] object within a {JRD}
    #
    # Links represent links to resources external to the entity. They are
    # _optional_ within a JRD so may not appear in your Webfinger setup.
    #
    # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.4
    class Link
      extend Logging

      # Parses and maybe-returns a {Link} when the value is one
      #
      # [Links][1] within the {JRD} are member objects representing a link to
      # another resource.
      #
      # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.4
      #
      # @since 0.1.0
      # @api private
      #
      # @param data [Hash] the data to parse as a link object
      # @return [Link, nil] the link parsed from the data
      def self.parse(data)
        unless (rel = LinkRelationType.parse(data[:rel]))
          return warn(
            "Webfinger link rel is missing or malformed: #{data.inspect}, ignoring"
          )
        end

        new(
          rel: rel,
          href: Href.parse(data[:href]),
          properties: Properties.parse(data[:properties]),
          titles: Titles.parse(data[:titles]),
          type: data[:type]
        )
      end

      # Creates a new {Link}
      #
      # @since 0.1.0
      # @api private
      #
      # @param rel [LinkRelationType] the type of relation the {Link} represents
      # @param href [Href, nil] the optional {Href} URI of the link
      # @param properties [Properties, nil] the optional list of {Properties}
      #   describing the link
      # @param titles [Titles, nil] the optional list of {Titles} naming the link
      # @param type [String, nil] the optional media type of the target resource
      def initialize(rel:, href: nil, properties: nil, titles: nil, type: nil)
        @href = href
        @properties = properties
        @rel = rel
        @titles = titles
        @type = type
      end

      # The optional hypertext reference to a URI for the {Link}
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Href, nil] the optional {Href} URI of the link
      attr_reader :href

      # The optional {Properties} characterizing the {Link}
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Properties, nil] the optional list of {Properties} describing
      #   the link
      attr_reader :properties

      # The {LinkRelationType} describing what the {Link} links to
      #
      # @since 0.1.0
      # @api private
      #
      # @return [LinkRelationType] the type of relation the {Link} represents
      attr_reader :rel

      # The optional {Titles} describing the {Link}
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Titles, nil] the optional list of {Titles} naming the link
      attr_reader :titles

      # The optional media type of the {#href} for the {Link}
      #
      # @since 0.1.0
      # @api private
      #
      # @return [String, nil] the optional media type of the target resource
      attr_reader :type

      # Converts the {Link} into a JSON-serializable Hash
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Hash] the Link as a JSON-compatible Hash
      def to_h
        result = {rel:}
        result[:href] = href if href
        result[:properties] = properties if properties
        result[:titles] = titles if titles
        result[:type] = type if type
        result
      end
    end
  end
end
