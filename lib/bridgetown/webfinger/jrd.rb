# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # A model of a [JSON Resource Descriptor][1]
    #
    # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4
    class JRD
      include Logging

      # Parses and maybe-returns a {JRD} when the subject and data form one
      #
      # {JRD}s can describe any resource identifiable via a URI, whether you want
      # to give public directory information about people via `acct:` URIs,
      # copyright information about an article, or perhaps license information
      # about a library.
      #
      # @since 0.1.0
      # @api public
      #
      # @example Convert a Hash into a sanitized {JRD}
      #
      #    Bridgetown::Webfinger::JRD.parse(
      #      "acct:bilbo@bagend.com",
      #      {
      #        aliases: ["https://bilbobaggins.com/"],
      #        links: [
      #          {
      #            href: "https://bagend.com/bilbo",
      #            rel: "http://webfinger.net/rel/profile-page",
      #            type: "text/html",
      #            properties: {
      #              "http://packetizer.com/ns/name" => "Bilbo @ Bag End"
      #            },
      #            titles: {
      #              "en-us" => "Bilbo Baggins's blog"
      #            }
      #          }
      #        ],
      #        properties: {
      #          "http://packetizer.com/ns/name" => "Bilbo Baggins"
      #        }
      #      }
      #    )
      #
      # @param subject [String] the (nominally) optional subject identified by
      #   the JRD; _should_ be present but is not _required_
      # @param data [Hash] the data hash containing information to add to the
      #   JRD
      # @return [JRD, nil] a {JRD} when the information is valid, nil otherwise
      def self.parse(subject, data)
        aliases = Array(data[:aliases]).filter_map { |moniker| Alias.parse(moniker) }
        links = Array(data[:links]).filter_map { |link| Link.parse(link) }
        properties = Properties.parse(data[:properties])
        subject = Webfinger.uri?(subject) ? subject : nil

        new(
          aliases: (!aliases.empty?) ? aliases : nil,
          links: (!links.empty?) ? links : nil,
          properties: properties,
          subject: subject
        )
      end

      # Creates a new {JRD}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Creating a new {JRD} without parsing a Hash
      #
      #   Bridgetown::Webfinger::JRD.new(
      #     subject: "acct:bilbo@bagend.com",
      #     aliases: [Bridgetown::Webfinger::Alias.new("https://bilbobaggins.com/")]
      #   )
      #
      # @param aliases [Array<Alias>, nil] the optional {Alias}es for the resource
      # @param links [Array<Link>, nil] the optional {Link}s related to the resource
      # @param properties [Properties] the optional {Properties} describing the resource
      # @param subject [String, nil] the (nominally) optional subject URI for the resource
      def initialize(aliases: nil, links: nil, properties: nil, subject: nil)
        @aliases = aliases
        @links = links
        @properties = properties
        @subject = subject
      end

      # The list of {Alias}es for the resource
      #
      # @since 0.1.0
      # @api public
      #
      # @example Read the {Alias}es for a {JRD}
      #
      #   jrd = Bridgetown::Webfinger::JRD.parse(
      #     "acct:bilbo@bagend.com",
      #     {aliases: ["https://bilbobaggins.com"]}
      #   )
      #   jrd.aliases
      #
      # @return [Array<Alias>, nil] the optional {Alias}es for the resource
      attr_reader :aliases

      # The list of {Link}s for the resource
      #
      # @since 0.1.0
      # @api public
      #
      # @example Read the {Link}s for a {JRD}
      #
      #   jrd = Bridgetown::Webfinger::JRD.parse(
      #     "acct:bilbo@bagend.com",
      #     {links: [{href: "https://bilbobaggins.com", rel: "https://webfinger.net/rel/avatar"}]}
      #   )
      #   jrd.links
      #
      # @return [Array<Link>, nil] the optional {Link}s related to the resource
      attr_reader :links

      # The list of {Properties} for the resource
      #
      # @since 0.1.0
      # @api public
      #
      # @example Read the {Properties} for a {JRD}
      #
      #   jrd = Bridgetown::Webfinger::JRD.parse(
      #     "acct:bilbo@bagend.com",
      #     {properties: {"http://packetizer.com/ns/name" => "Bilbo Baggins"}}
      #   )
      #   jrd.properties
      #
      # @return [Properties, nil] the optional {Properties} describing the resource
      attr_reader :properties

      # The subject of the {JRD}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Read the subject for a {JRD}
      #
      #   jrd = Bridgetown::Webfinger::JRD.parse("acct:bilbo@bagend.com")
      #   jrd.subject  #=> "acct:bilbo@bagend.com"
      #
      # @return [String, nil] the (nominally) optional subject URI for the resource
      attr_reader :subject

      # Converts the {JRD} to a JSON-serializable Hash
      #
      # @since 0.1.0
      # @api private
      #
      # @return [Hash] the JRD as a JSON-compatible Hash
      def to_h
        result = {subject:}
        result[:aliases] = aliases if aliases
        result[:links] = links.map(&:to_h) if links
        result[:properties] = properties.to_h if properties
        result
      end
    end
  end
end
