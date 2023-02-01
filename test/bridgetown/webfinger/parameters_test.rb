# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class ParametersTest < Minitest::Test
      def test_cleaning_irrelevant_params
        params = Parameters.from_query_string("a=b&b=c&resource=foo")

        assert_equal Parameters.new(resource: "foo"), params
      end

      def test_combining_multiple_rels_into_an_array
        params = Parameters.from_query_string("resource=foo&rel=a&rel=b")

        assert_equal Parameters.new(resource: "foo", rel: %w[a b]), params
      end

      def test_last_one_wins_policy_for_resource
        params = Parameters.from_query_string("resource=foo&resource=bar")

        assert_equal Parameters.new(resource: "bar"), params
      end

      def test_unescaping_works_as_expected
        params = Parameters.from_query_string(
          "resource=acct%3Atantek.com%40tantek.com"
        )

        assert_equal(
          Parameters.new(resource: "acct:tantek.com@tantek.com"),
          params
        )
      end

      def test_ignoring_a_rel_with_no_value
        params = Parameters.from_query_string("resource=foo&rel")

        assert_equal Parameters.new(resource: "foo"), params
      end

      def test_value_object_semantics
        query =
          "resource=acct%3Atest%40example.com&" \
          "rel=http%3A%2F%2Fwebfinger.net%2Frel%2Fprofile-page"
        params1 = Parameters.from_query_string(query)
        params2 = Parameters.from_query_string(query)

        assert params1 == params2
        assert params1.hash == params2.hash
        assert params1.eql?(params2)
        refute params1.equal?(params2)
      end
    end
  end
end
