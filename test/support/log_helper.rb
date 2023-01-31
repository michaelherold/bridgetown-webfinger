# frozen_string_literal: true

module LogHelper
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
