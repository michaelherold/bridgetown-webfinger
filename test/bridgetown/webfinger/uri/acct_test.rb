# frozen_string_literal: true

require "test_helper"

module URI
  class ACCTTest < Minitest::Test
    def test_simple_example
      uri = URI.parse("acct:foobar@status.example.net")

      assert_equal "acct", uri.scheme
      assert_equal "foobar", uri.account
      assert_equal "status.example.net", uri.host
    end

    # The reasoning behind this is not straightforward, so let's walk through it:
    #
    # 1. [Section 2.4 of RFC3986][1] says that “Because the percent ("%")
    #    character serves as the indicator for percent-encoded octets, it must
    #    be percent-encoded as "%25" for that octet to be used as data within a
    #    URI. Implementations must not percent-encode or decode the same string
    #    more than once […]”;
    # 2. Ruby's URI implementation follows these rules;
    # 3. And when using the `build` method, the operator is directly entering
    #    data so "should not" be handling percent-encoded data.
    #
    # Given these constraints, this method percent-encodes the account so it is
    # most ergonomic for library operators.
    #
    # [1]: https://datatracker.ietf.org/doc/html/rfc3986#section-2.4
    def test_building_from_encoded_strings_doubly_encodes
      uri = URI::Acct.build(["juliet%40capulet.example", "shoppingsite.example"])

      assert_equal "acct:juliet%2540capulet.example@shoppingsite.example", uri.to_s
      assert_equal "juliet%40capulet.example", uri.account
      assert_equal "shoppingsite.example", uri.host
    end

    def test_building_from_unencoded_strings
      uri = URI::Acct.build(["juliet@capulet.example", "shoppingsite.example"])
      uri2 = URI::Acct.build({account: "juliet@capulet.example", host: "shoppingsite.example"})

      assert_equal "acct:juliet%40capulet.example@shoppingsite.example", uri.to_s
      assert_equal "juliet@capulet.example", uri.account
      assert_equal "shoppingsite.example", uri.host
      assert_equal uri2, uri
    end

    def test_checking_arguments_raises_on_unescaped_account
      assert_raises URI::InvalidComponentError do
        parts = URI.split("acct:juliet@capulet.example@shoppingsite.example").tap do |result|
          result << nil
          result << true
        end

        URI::Acct.new(*parts)
      end
    end

    def test_checking_arguments_raises_on_missing_opaque
      assert_raises URI::InvalidComponentError do
        URI::Acct.new("acct", nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
      end
    end

    def test_checking_arguments_raises_on_missing_account
      assert_raises URI::InvalidComponentError do
        parts = URI.split("acct:shoppingsite.example").tap do |result|
          result << nil
          result << true
        end

        URI::Acct.new(*parts)
      end
    end
  end
end
