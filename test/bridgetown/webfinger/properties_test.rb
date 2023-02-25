# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module Webfinger
    class PropertiesTest < Minitest::Test
      def test_a_fully_appropriate_example
        properties = Properties.parse(
          {"http://packetizer.com/ns/name" => "Bilbo Baggins"}
        )

        assert_equal "Bilbo Baggins", properties["http://packetizer.com/ns/name"]
      end

      def test_parsing_nil
        assert_nil Properties.parse(nil)
      end

      def test_pruning_malformed_properties
        output = with_log_output do
          properties = Properties.parse(1_234)

          assert_nil properties
        end

        assert_match %r{Webfinger link properties are malformed}, output
      end

      private

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
