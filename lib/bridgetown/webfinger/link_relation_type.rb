# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps the type of a {Link} relation
    class LinkRelationType < Model
      # The list of relation types, as [registered with IANA][1]
      #
      # This constant can be regenerated with the `data:link_relations` Rake
      # task.
      #
      # [1]: https://www.iana.org/assignments/link-relations
      #
      # @since 0.1.0
      # @api private
      REGISTERED = Set.new(%w[
        about
        acl
        alternate
        amphtml
        appendix
        apple-touch-icon
        apple-touch-startup-image
        archives
        author
        blocked-by
        bookmark
        canonical
        chapter
        cite-as
        collection
        contents
        convertedfrom
        copyright
        create-form
        current
        describedby
        describes
        disclosure
        dns-prefetch
        duplicate
        edit
        edit-form
        edit-media
        enclosure
        external
        first
        glossary
        help
        hosts
        hub
        icon
        index
        intervalafter
        intervalbefore
        intervalcontains
        intervaldisjoint
        intervalduring
        intervalequals
        intervalfinishedby
        intervalfinishes
        intervalin
        intervalmeets
        intervalmetby
        intervaloverlappedby
        intervaloverlaps
        intervalstartedby
        intervalstarts
        item
        last
        latest-version
        license
        linkset
        lrdd
        manifest
        mask-icon
        media-feed
        memento
        micropub
        modulepreload
        monitor
        monitor-group
        next
        next-archive
        nofollow
        noopener
        noreferrer
        opener
        openid2.local_id
        openid2.provider
        original
        p3pv1
        payment
        pingback
        preconnect
        predecessor-version
        prefetch
        preload
        prerender
        prev
        preview
        previous
        prev-archive
        privacy-policy
        profile
        publication
        related
        restconf
        replies
        ruleinput
        search
        section
        self
        service
        service-desc
        service-doc
        service-meta
        sip-trunking-capability
        sponsored
        start
        status
        stylesheet
        subsection
        successor-version
        sunset
        tag
        terms-of-service
        timegate
        timemap
        type
        ugc
        up
        version-history
        via
        webmention
        working-copy
        working-copy-of
      ]).freeze

      # Parses a maybe-returns a {LinkRelationType} when the value is one
      #
      # Link relation types may either be a URI to a relation type description
      # or a value [registered with IANA][1].
      #
      # [1]: https://www.iana.org/assignments/link-relations
      #
      # @since 0.1.0
      # @api private
      #
      # @param rel [String] the rel to parse and validate
      # @return [LinkRelationType, nil] the link relation type parsed from the rel
      def self.parse(rel)
        return unless Webfinger.uri?(rel) || REGISTERED.include?(rel)

        new(rel)
      end
    end
  end
end
