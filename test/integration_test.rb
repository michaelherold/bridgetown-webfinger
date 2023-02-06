# frozen_string_literal: true

require "test_helper"

if ENV["CI"] || ENV["COVERAGE"]
  SimpleCov.command_name "test:integration"
end

module Bridgetown
  module Webfinger
    class IntegrationTest < Bridgetown::TestCase
      include Rack::Test::Methods

      def app
        ENV["RACK_ENV"] = "development"
        @@webfinger_app ||= ::Rack::Builder.parse_file(
          File.expand_path("integration/config.ru", __dir__)
        )
      end

      def site
        app.opts[:bridgetown_site]
      end

      def test_the_happy_path
        get "/.well-known/webfinger?resource=acct%3Abilbo%40bagend.com"

        assert last_response.ok?, "Response did not return a 200 OK"
        assert_equal "application/jrd+json", last_response.headers["Content-Type"]
        assert_equal(
          site.data.authors.bilbo.webfinger.merge(subject: "acct:bilbo@bagend.com"),
          JSON.parse(last_response.body)
        )
      end

      def test_a_site_uri_search_with_a_single_author
        get "/.well-known/webfinger?resource=acct%3Abagend.com"

        assert last_response.ok?, "Response did not return a 200 OK"
        assert_equal "application/jrd+json", last_response.headers["Content-Type"]
        assert_equal(
          site.data.authors.bilbo.webfinger.merge(subject: "acct:bagend.com@bagend.com"),
          JSON.parse(last_response.body)
        )
      end

      def test_an_unknown_author_returns_an_error
        get "/.well-known/webfinger?resource=acct%3Afrodo%40bagend.com"

        assert last_response.not_found?, "Response did not return a 404 Not Found"
        assert_equal "application/json", last_response.headers["Content-Type"]
        assert_equal(
          {"error" => "Unknown resource: acct:frodo@bagend.com"},
          JSON.parse(last_response.body)
        )
      end

      def test_a_missing_resource_returns_an_error
        get "/.well-known/webfinger"

        assert last_response.bad_request?, "Response did not return a 200 OK"
        assert_equal "application/json", last_response.headers["Content-Type"]
        assert_equal(
          {"error" => "Missing required parameter: resource"},
          JSON.parse(last_response.body)
        )
      end
    end
  end
end
