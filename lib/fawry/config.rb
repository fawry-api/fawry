# frozen_string_literal: true

module Fawry
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new

      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :sandbox, :fawry_secure_key, :fawry_merchant_code

    def initialize
      @sandbox = false
      @fawry_secure_key = nil
      @fawry_merchant_code = nil
    end
  end
end
