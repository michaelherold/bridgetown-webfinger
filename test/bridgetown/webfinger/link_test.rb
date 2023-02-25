# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class LinkTest < Minitest::Test
      def test_a_fully_appropriate_example
        link = link(
          href: "https://example.com/",
          rel: "http://webfinger.net/rel/profile-page",
          type: "text/html",
          properties: {
            "http://packetizer.com/ns/name" => "Bilbo Baggins"
          },
          titles: {
            "en-us" => "Bilbo Baggins's blog"
          }
        )

        assert_equal "https://example.com/", link.href
        assert_equal "http://webfinger.net/rel/profile-page", link.rel
        assert_equal "text/html", link.type
        assert_equal "Bilbo Baggins", link.properties["http://packetizer.com/ns/name"]
        assert_equal "Bilbo Baggins's blog", link.titles["en-us"]
      end

      def test_ignoring_links_without_rels
        output = with_log_output do
          link = link(href: "https://example.com/")

          assert_nil link
        end

        assert_match %r{rel is missing}, output
      end

      def test_link_without_properties
        output = with_log_output do
          link = link(
            href: "https://example.com/",
            rel: "http://webfinger.net/rel/profile-page",
            type: "text/html"
          )

          assert_nil link.properties
        end

        refute_match %r{Webfinger link properties}, output
      end

      def test_pruning_malformed_properties
        output = with_log_output do
          link = link(
            rel: "http://webfinger.net/rel/profile-page",
            properties: {1 => "Bilbo Baggins", "foo" => "bar"}
          )

          assert_nil link.properties
        end

        assert_match %r{Webfinger property}, output
      end

      def test_pruning_malformed_titles
        output = with_log_output do
          link = link(
            rel: "http://webfinger.net/rel/profile-page",
            titles: {"en-us" => 1, 1 => "foo"}
          )

          assert_nil link.titles
        end

        assert_match %r{Webfinger title key}, output
        assert_match %r{Webfinger title value}, output
      end

      private

      def link(**kwargs)
        metadata(**kwargs)
          .then { |m| Link.parse(m) }
      end

      def metadata(**kwargs)
        HashWithDotAccess::Hash.new(kwargs)
      end

      def with_log_output
        original_logger = Bridgetown.logger
        output = StringIO.new
        Bridgetown.instance_variable_set(
          :@logger,
          Bridgetown::LogAdapter.new(
            Bridgetown::LogWriter.new.tap do |writer|
              writer.define_singleton_method(:logdevice) { |_| output }
            end,
            :debug
          )
        )
        yield if block_given?
        output.string
      ensure
        Bridgetown.instance_variable_set(:@logger, original_logger)
      end
    end
  end
end
