# frozen_string_literal: true

require "uri"

# A module providing classes to handle Uniform Resource Identifiers ([RFC2396][1])
#
# [1]: https://datatracker.ietf.org/doc/html/rfc2396
module URI
  # A URI for an account on a system
  #
  # @since 0.1.0
  # @api public
  #
  # @example Parsing an acct URI from a string
  #
  #   URI.parse("acct:bilbo@bagend.com")
  #
  # See [RFC7565](https://datatracker.ietf.org/doc/html/rfc7565) for more
  # information.
  class Acct < Generic
    # The components of the URI
    #
    # @private
    COMPONENT = [:scheme, :account, :host].freeze

    # Builds a {URI::Acct} from components
    #
    # Note: Do not enter already percent-encoded data as a component for the
    # account because the implementation will do this step for you. If you're
    # building from components received externally, consider using
    # `URI.decode_uri_component` before using it to build a URI with this
    # method.
    #
    # @since 0.1.0
    # @api public
    #
    # @example Building an acct URI from an array of attributes
    #
    #   URI::Acct.build(["bilbo", "bagend.com"])
    #
    # @example Building an acct URI from a hash of attributes
    #
    #   URI::Acct.build({ account: "bilbo", host: "bagend.com" })
    #
    # @param args [Hash<Symbol, String>, Array<String>] the components to use,
    #   either as a Hash of `{account: String, host: String}` or a positional,
    #   2-element `Array` of the form `[account, host]`
    # @return [URI::Acct] the built URI
    # @raise [ArgumentError] when the components are incorrect
    def self.build(args)
      components = Util.make_components_hash(self, args)

      components[:account] ||= ""
      components[:account] &&= URI.encode_uri_component(components[:account])
      components[:host] ||= ""
      components[:opaque] = "#{components.delete(:account)}@#{components.delete(:host)}"

      super(components)
    end

    # Instantiates a new {URI::Acct} from a long list of components
    #
    # @since 0.1.0
    # @api public
    #
    # @example Manually constructing a URI — with value checking — for the masochistic
    #   URI::Acct.new(["acct", nil, nil, nil, nil, nil, "bilbo@bagend.com", nil, nil, nil, true])
    #
    # @param args [Array<String>] the components to set for the URI
    # @return [URI::Acct]
    # @raise [InvalidComponentError] when the account name is malformed
    def initialize(*args)
      super

      raise InvalidComponentError, "missing opaque part for acct URI" unless @opaque

      account, _, host = @opaque.rpartition("@")
      @opaque = nil

      if args[10] # arg_check
        self.account = account
        self.host = host
      else
        @account = account
        @host = host
      end
    end

    # The account part (also known as the userpart) of the URI
    #
    # @since 0.1.0
    # @api public
    #
    # @example Checking the account for a URI
    #
    #  URI.parse("acct:bilbo@bagend.com").account #=> "bilbo"
    #
    # @return [String]
    attr_reader :account

    # Sets the account part of the URI
    #
    # @since 0.1.0
    # @api public
    #
    # @example Setting the account for a URI
    #
    #  uri = URI.parse("acct:bilbo@bagend.com")
    #  uri.account = "frodo"
    #  uri.account #=> "frodo"
    #
    # @param value [String] a percent-encoded account name for the URI
    # @return [void]
    # @raise [InvalidComponentError] when the value is malformed
    def account=(value)
      raise InvalidComponentError, "missing account part for acct URI" if value.empty?
      raise InvalidComponentError, "account part not percent-encoded for acct URI" if value.include?("@")

      @account = URI.decode_uri_component(value)
    end

    # Converts the URI into a string
    #
    # @since 0.1.0
    # @api public
    #
    # @example Converting a URI to a string
    #
    #   URI.parse("acct:bilbo@bagend.com").to_s
    #
    # @return [String] the formatted version of the {URI::Acct}
    def to_s
      @scheme + ":" + URI.encode_uri_component(account) + "@" + host
    end
  end

  register_scheme "ACCT", Acct
end
