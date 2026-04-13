#encoding: UTF-8
require 'active_support/core_ext/hash'
require 'logger'

require 'data_collector/version'
require 'data_collector/runner'
require 'data_collector/pipeline'
require 'data_collector/ext/xml_utility_node'

module DataCollector
  class Error < StandardError
  end

  class InputError < Error
    attr_reader :code, :body

    def initialize(message = nil, code: nil, body: nil, cause: nil)
      super(message)  # sets #message
      @code = code
      @body = body

      # Attach cause if explicitly provided and Ruby version doesn’t auto-chain
      # (In modern Ruby, raising inside a rescue sets #cause automatically;
      # you can also pass cause: to raise, shown below.)
      set_backtrace(cause.backtrace) if backtrace.nil? && cause && cause.backtrace
      @cause = cause if cause
    end

    # Optional explicit accessor if you pass cause manually above
    def cause
      super || @cause
    end

    def to_h
      { error: self.class.name, message: message, code: code, body: body }
    end
  end

end
