# frozen_string_literal: true

module Bridgetown
  module Webfinger
    # Wraps a `properties` member within a {Link} or {JRD}
    class Properties < Model
      # Parses and maybe-returns {Properties} when the value is one
      #
      # Properties within the {JRD} are name/value pairs [with URIs for names
      # and strings or nulls for values][1].
      #
      # [1]: https://datatracker.ietf.org/doc/html/rfc7033#section-4.4.4.5
      #
      # @since 0.1.0
      # @api private
      #
      # @param data [Hash] the data to parse as a properties object
      # @return [Properties, nil] the properties parsed from the data
      def self.parse(data)
        unless data.is_a?(Hash)
          return warn("Webfinger link properties are malformed: #{data.inspect}, ignoring")
        end

        properties = data.select do |name, value|
          if !Webfinger.uri?(name)
            next warn("Webfinger property name is not a URI: #{name}, ignoring")
          elsif !value.is_a?(String) || value.nil?
            next warn("Webfinger property value is not a nullable string: #{value}, ignoring")
          else
            true
          end
        end

        if !properties.empty?
          new(properties)
        else
          warn("All Webfinger link properties pruned: #{data.inspect}, ignoring")
        end
      end
    end
  end
end
