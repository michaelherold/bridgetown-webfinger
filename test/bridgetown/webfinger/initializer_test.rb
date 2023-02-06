# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class InitializerTest < Bridgetown::TestCase
      def setup
        super
        @config = Bridgetown.configuration(
          "root_dir" => root_dir,
          "source" => source_dir,
          "destination" => dest_dir,
          "quiet" => true
        )
        @site = Bridgetown::Site.new(@config)
        maybe_reload_initializer(@config)
      end

      def test_merging_into_preexisting_configuration_prefers_the_preexisting
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            webfinger do
              static false
            end

            init "bridgetown-webfinger", static: true
          end
        RUBY

        @config.run_initializers! context: :static

        refute @config.webfinger.static
      end

      def test_setting_allowed_origins
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            init "bridgetown-webfinger", allowed_origins: "https://bagend.com"
          end
        RUBY

        @config.run_initializers! context: :static

        assert_equal "https://bagend.com", @config.webfinger.allowed_origins
      end
    end
  end
end
