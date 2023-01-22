# frozen_string_literal: true

require "bridgetown"
require "zeitwerk"

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
      loader.setup
    end
  end
end

# @param config [Bridgetown::Configuration::ConfigurationDSL]
Bridgetown.initializer :"bridgetown-webfinger" do |config|
end
