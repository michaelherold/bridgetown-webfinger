# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps a `titles` member within a {Link}
    class Titles < Model
      # Parses and maybe-returns {Titles} when the value is one
      #
      # Titles within the {JRD} are name/value pairs [with language tag names
      # and string values][2]. When the language is indeterminate, use `"und"`.
      #
      # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.4.4
      #
      # @since 0.1.0
      # @api private
      #
      # @param data [Hash] the data to parse as a titles object
      # @return [Titles, nil] the titles parsed from the data
      def self.parse(data)
        return unless data.is_a?(Hash)

        data = data.select do |key, value|
          if !key.is_a?(String)
            next warn("Webfinger title key is not a string: #{key}, ignoring")
          elsif !value.is_a?(String)
            next warn("Webfinger title value for #{key} is not a string: #{value}, ignoring")
          else
            true
          end
        end

        if !data.empty?
          new(data)
        else
          warn("All Webfinger link titles pruned: #{data.inspect}, ignoring")
        end
      end
    end
  end
end
