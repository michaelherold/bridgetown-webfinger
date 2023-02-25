# frozen_string_literal: true

# A routing tree for building Rack applications
#
# @see https://roda.jeremyevans.net/
class Roda
  # The namespace Roda uses for loading plugins by convention
  module RodaPlugins
    # A plugin that integrates Webfinger behavior into a Bridgetown Roda app
    #
    # This plugin requires the Bridgetown SSR plugin to be enabled before it.
    #
    # It reads data from the `authors` data for the Bridgetown site to validate
    # author accounts, then extracts the `webfinger` key from the author to
    # build the JSON Resource Descriptor.
    module BridgetownWebfinger
      # The Roda hook for configuring the plugin
      #
      # @since 0.1.0
      # @api private
      #
      # @param app [::Roda] the Roda application to configure
      # @return [void]
      def self.configure(app)
        return unless app.opts[:bridgetown_site].nil?

        # :nocov: Because it's difficult to set up multiple contexts
        raise(
          "Roda app failure: the bridgetown_ssr plugin must be registered before " \
          "bridgetown_webfinger"
        )
        # :nocov:
      end

      # Methods included in to the Roda request
      #
      # @see http://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Base/RequestMethods.html
      module RequestMethods
        # Builds the Webfinger route within the Roda application
        #
        # @since 0.1.0
        # @api public
        #
        # @example Enabling the Webfinger route
        #
        #   class RodaApp < Bridgetown::Rack::Roda
        #     plugin :bridgetown_ssr
        #     plugin :bridgetown_webfinger
        #
        #     route do |r|
        #       r.bridgetown_webfinger
        #     end
        #   end
        #
        # @return [void]
        def bridgetown_webfinger
          bridgetown_site = roda_class.opts[:bridgetown_site]

          on(".well-known/webfinger") do
            is do
              get do
                params = Bridgetown::Webfinger::Parameters.from_query_string(query_string)
                host = URI(bridgetown_site.config.url).host
                response["Access-Control-Allow-Origin"] =
                  bridgetown_site.config.webfinger.allowed_origins

                unless (resource = params.resource)
                  next response.webfinger_error("Missing required parameter: resource", status: 400)
                end

                if (jrd = webfinger_maybe_jrd(resource, host: host, params: params, site: bridgetown_site))
                  response.webfinger_success(jrd)
                else
                  response.webfinger_error("Unknown resource: #{resource}", status: 404)
                end
              end
            end
          end
        end

        private

        # Constructs a JRD for the appropriate account from author metadata
        #
        # @since 0.1.0
        # @api private
        #
        # @param resource [String] the resource URI from the parameters
        # @param host [String] the host domain from the site configuration
        # @param params [Bridgetown::Webfinger::Parameters] the parameters for the request
        # @param site [Bridgetown::Site] the site for the Bridgetown instance
        # @return [Bridgetown::Webfinger::JRD, nil] the JRD when possible, nil otherwise
        def webfinger_maybe_jrd(resource, host:, params:, site:)
          return unless (uri = URI.parse(resource)).instance_of?(URI::Acct)
          return unless (authors = site.data.authors)

          webfinger =
            if (acct = authors[uri.account])
              acct.webfinger
            elsif uri.account.empty? && uri.host == host && authors.length == 1
              uri.account = uri.host
              authors.values.first.webfinger
            else
              return
            end

          jrd = Bridgetown::Webfinger::JRD.parse(uri.to_s, webfinger)
          jrd.links&.select! { |link| params.rel.include?(link.rel) } if params.rel
          jrd
        end
      end

      # Methods included in to the Roda response
      #
      # @see http://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Base/ResponseMethods.html
      module ResponseMethods
        # Renders an error in the style of Bridgetown Webfinger
        #
        # @since 0.1.0
        # @api private
        #
        # @param message [String] the error message for the response
        # @param status [Integer] the status code for the response
        # @return [String] the response body
        def webfinger_error(message, status:)
          self["Content-Type"] = "application/json"
          self.status = status

          JSON.pretty_generate({error: message})
        end

        # Renders a JSON Resource Descriptor for Webfinger
        #
        # @since 0.1.0
        # @api private
        #
        # @param jrd [Bridgetown::Webfinger::JRD] the JRD to render
        # @return [String] the response body
        def webfinger_success(jrd)
          self["Content-Type"] = "application/jrd+json"

          JSON.pretty_generate(jrd.to_h)
        end
      end
    end

    register_plugin :bridgetown_webfinger, BridgetownWebfinger
  end
end
