# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class BuilderTest < Bridgetown::TestCase
      include LogHelper

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

      def test_static_mode_enables_rendering_the_webfinger_file
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            init "bridgetown-webfinger", static: true
          end
        RUBY

        render_site

        assert File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was not rendered"
      end

      def test_disabling_static_mode_disables_rendering_the_webfinger_file
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            init "bridgetown-webfinger", static: false
          end
        RUBY

        render_site

        refute File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was rendered"
      end

      def test_generic_uri_site_url_still_allows_rendering_the_webfinger_file
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            url "bagend.com"
            init "bridgetown-webfinger", static: true
          end
        RUBY

        render_site

        assert File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was not rendered"
      end

      def test_missing_site_url_disables_rendering_the_webfinger_file
        output = with_log_output do
          with_initializer(<<~RUBY)
            Bridgetown.configure do
              url nil
              init "bridgetown-webfinger"
            end
          RUBY

          render_site

          refute File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was rendered"
        end

        assert_match(/site\.config\.url/, output)
      end

      def test_malformed_site_url_disables_rendering_the_webfinger_file
        output = with_log_output do
          with_initializer(<<~RUBY)
            Bridgetown.configure do
              url "mailto:bilbo@bagend.com"
              init "bridgetown-webfinger"
            end
          RUBY

          render_site

          refute File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was rendered"
        end

        assert_match(/malformed host/, output)
      end

      def test_missing_author_disables_rendering_the_webfinger_file
        output = with_log_output do
          default_initializer
          with_data("authors.yml", {})

          render_site

          refute File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was rendered"
        end

        assert_match(/any authors/, output)
      end

      def test_multiple_authors_disables_rendering_the_webfinger_file
        output = with_log_output do
          default_initializer
          with_data("authors.yml", {"bilbo" => {}, "frodo" => {}})

          render_site

          refute File.exist?(dest_dir(".well-known/webfinger")), "The static Webfinger file was rendered"
        end

        assert_match(/multiple authors/, output)
      end

      private

      def render_site
        @config.run_initializers! context: :static
        @site.process
      end

      def default_initializer
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            url "https://bagend.com"
            init "bridgetown-webfinger", static: true
          end
        RUBY
      end
    end
  end
end
