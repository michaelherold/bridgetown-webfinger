# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # The [builder class][1] for working with Webfinger in Bridgetown
    #
    # [1]: https://www.bridgetownrb.com/docs/plugins#introduction-to-the-builder-api
    class Builder < Bridgetown::Builder
      include Logging

      # The hook method for enabling the builder's behavior
      #
      # @since 0.1.0
      # @api private
      #
      # @return [void]
      def build
        generator :static_file
      end

      private

      # Builds a static Webfinger file when correctly configured
      #
      # @since 0.1.0
      # @api private
      #
      # @return [void]
      def static_file
        return unless config.webfinger.static
        return unless (host = extract_site_host)
        return unless (account, data = extract_authors_from_site_data)

        site.add_generated_page StaticFile.new(site, account: account, data: data, host: host)
      end

      # Extracts the site's host from its configuration
      #
      # @since 0.1.0
      # @api private
      #
      # @return [String, nil] String when configured correctly, nil otherwise
      def extract_site_host
        host = site.config.url

        if !host || host.empty?
          warn(
            "bridgetown-webfinger did not find your site's host configured at " \
            "`site.config.url`; this is unsupported by static files so will be ignored"
          )
          return
        end

        uri = URI(host)

        if uri.is_a?(URI::HTTP)
          uri.host
        elsif uri.instance_of?(URI::Generic)
          uri.to_s
        else
          warn(
            "bridgetown-webfinger detected a malformed host in your site configuration " \
            "(#{uri} from `site.config.url`); this is unsupported and will be ignored"
          )
        end
      end

      # Extracts the author from the site's data
      #
      # @since 0.1.0
      # @api private
      #
      # @return [HashWithDotAccess::Hash, nil] Hash when configured correctly, nil otherwise
      def extract_authors_from_site_data
        unless (authors = site.data.authors) && !authors.empty?
          warn(
            "bridgetown-webfinger did not detect any authors at `site.data.authors`; " \
            "this is unsupported by static files so will be ignored"
          )
          return
        end

        unless authors.size == 1
          warn(
            "bridgetown-webfinger discovered multiple authors; this is unsupported " \
            "by static files so will be ignored"
          )
          return
        end

        authors.first
      end

      # The static Webfinger file to serve
      class StaticFile < Bridgetown::GeneratedPage
        # Initializes a new static Webfinger file
        #
        # @since 0.1.0
        # @api private
        #
        # @param site [Bridgetown::Site] the site object
        # @param account [String] the account for the {URI::Acct}
        # @param data [HashWithDotAccess::Hash] the data for the Webfinger JRD
        # @param host [String] the host for the {URI::Acct}
        # @return [void]
        def initialize(site, account:, data:, host:)
          super(site, __dir__, "/.well-known", "webfinger", from_plugin: true)

          @subject = URI::Acct.build({account: account, host: host}).to_s
          @jrd = JRD.parse(@subject, data.webfinger)

          self.content = JSON.pretty_generate(@jrd.to_h)
        end

        # The {JRD} forming the data model for the static Webfinger page
        #
        # @since 0.1.0
        # @api private
        #
        # @return [JRD] the JSON Resource Descriptor to serve for Webfinger
        attr_reader :jrd

        # The subject of the {JRD}
        #
        # @since 0.1.0
        # @api private
        #
        # @return [String] the subject for the JRD to serve
        attr_reader :subject
      end
    end
  end
end
