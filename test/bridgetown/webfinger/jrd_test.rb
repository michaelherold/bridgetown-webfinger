# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class JRDTest < Minitest::Test
      def test_a_fully_appropriate_example
        subject = "acct:bilbo@bagend.com"
        data = {
          aliases: ["https://bilbobaggins.com/"],
          links: [
            {
              href: "https://bagend.com/bilbo",
              rel: "http://webfinger.net/rel/profile-page",
              type: "text/html",
              properties: {
                "http://packetizer.com/ns/name" => "Bilbo @ Bag End"
              },
              titles: {
                "en-us" => "Bilbo Baggins's blog"
              }
            }
          ],
          properties: {
            "http://packetizer.com/ns/name" => "Bilbo Baggins"
          }
        }

        jrd = JRD.parse(subject, data)

        assert_equal "acct:bilbo@bagend.com", jrd.subject
        assert_equal ["https://bilbobaggins.com/"], jrd.aliases
        assert_equal "https://bagend.com/bilbo", jrd.links.first.href
        assert_equal "http://webfinger.net/rel/profile-page", jrd.links.first.rel
        assert_equal "text/html", jrd.links.first.type
        assert_equal "Bilbo @ Bag End", jrd.links.first.properties["http://packetizer.com/ns/name"]
        assert_equal "Bilbo Baggins's blog", jrd.links.first.titles["en-us"]
        assert_equal "Bilbo Baggins", jrd.properties["http://packetizer.com/ns/name"]
      end

      def test_pruning_malformed_aliases
        output = with_log_output do
          subject = "acct:bilbo@bagend.com"
          data = {
            aliases: ["oops"]
          }

          jrd = JRD.parse(subject, data)

          assert_equal "acct:bilbo@bagend.com", jrd.subject
          assert_nil jrd.aliases
        end

        assert_match %r{Webfinger alias is malformed}, output
      end

      def test_pruning_malformed_links
        output = with_log_output do
          subject = "acct:bilbo@bagend.com"
          data = {
            links: [
              {
                href: "https://bagend.com/bilbo",
                type: "text/html"
              }
            ]
          }

          jrd = JRD.parse(subject, data)

          assert_equal "acct:bilbo@bagend.com", jrd.subject
          assert_nil jrd.links
        end

        assert_match %r{rel is missing}, output
      end

      def test_pruning_malformed_properties
        output = with_log_output do
          subject = "acct:bilbo@bagend.com"
          data = {
            properties: {
              "oops" => "Bilbo Baggins",
              "https://oops.id/id/itagain" => 1
            }
          }

          jrd = JRD.parse(subject, data)

          assert_equal "acct:bilbo@bagend.com", jrd.subject
          assert_nil jrd.properties
        end

        assert_match %r{Webfinger property name}, output
        assert_match %r{Webfinger property value}, output
      end

      def test_converting_to_json
        jrd = JRD.parse("acct:bilbo@bagend.com", {})

        json = JSON.generate(jrd.to_h)

        assert_equal '{"subject":"acct:bilbo@bagend.com"}', json
      end

      private

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
