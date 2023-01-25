# frozen_string_literal: true

require "bridgetown"
require "zeitwerk"

require_relative "bridgetown/webfinger/uri/acct"

# A progressive site generator and fullstack framework
#
# @see https://www.bridgetownrb.com/
module Bridgetown
  # A Bridgetown plugin that adds support for serving [Webfinger][1] requests
  #
  # The plugin handles either static or dynamic requests, served with data backed
  # by your Bridgetown site's data.
  #
  # [1]: https://datatracker.ietf.org/doc/html/rfc7033
  module Webfinger
    # The Zeitwerk loader responsible for auto-loading constants
    #
    # @private
    Loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false).tap do |loader|
      loader.ignore(__FILE__)
      loader.ignore(File.join(__dir__, "bridgetown", "webfinger", "uri", "acct"))
      loader.inflector.inflect("jrd" => "JRD")
      loader.setup
    end

    # Checks whether a given string is a URI of a registered type
    #
    # This will not convert the item into a URI object and it is able to
    # properly handle when there are multiple URIs in the string (by returning
    # false).
    #
    # @param uri [String] the string to check as a URI
    # @return [Boolean] true when it is a URI, false when it is not
    def self.uri?(uri)
      uri.is_a?(String) &&
        uri == URI.extract(uri).first
    end
  end
end

# @param config [Bridgetown::Configuration::ConfigurationDSL]
Bridgetown.initializer :"bridgetown-webfinger" do |config|
end
