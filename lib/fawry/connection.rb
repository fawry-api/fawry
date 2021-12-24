# frozen_string_literal: true

require 'faraday'
require 'json'

module Fawry
  class Connection
    FAWRY_BASE_URL = 'https://www.atfawry.com/ECommerceWeb/Fawry/'

    FAWRY_SANDBOX_BASE_URL = 'https://atfawry.fawrystaging.com//ECommerceWeb/Fawry/'

    class << self
      include Utils

      def post(path, params, body, options)
        sandbox = Fawry.configuration.sandbox || TRUTH_VALUES.include?(ENV.fetch('FAWRY_SANDBOX', options[:sandbox]))
        conn =  sandbox ? sandbox_connection : connection

        conn.post(path) do |request|
          request.params = params
          request.body = body.to_json
        end
      end

      def get(path, params, body, options)
        sandbox = Fawry.configuration.sandbox || TRUTH_VALUES.include?(ENV.fetch('FAWRY_SANDBOX', options[:sandbox]))
        conn =  sandbox ? sandbox_connection : connection

        conn.get(path) do |request|
          request.params = params
          request.body = body.to_json
          # Fawry doesn't understand encoded params
          request.options = request.options.merge(params_encoder: ParamsSpecialEncoder)
        end
      end

      def delete(path, params, body, options)
        sandbox = Fawry.configuration.sandbox || TRUTH_VALUES.include?(ENV.fetch('FAWRY_SANDBOX', options[:sandbox]))
        conn =  sandbox ? sandbox_connection : connection

        conn.delete(path) do |request|
          request.params = params
          request.body = body.to_json
          # Fawry doesn't understand encoded params
          request.options = request.options.merge(params_encoder: ParamsSpecialEncoder)
        end
      end

      private

      def connection
        @connection ||= Faraday.new(url: FAWRY_BASE_URL, headers: { 'Content-Type': 'application/json',
                                                                    Accept: 'application/json' })
      end

      def sandbox_connection
        @sandbox_connection ||= Faraday.new(url: FAWRY_SANDBOX_BASE_URL, headers: { 'Content-Type': 'application/json',
                                                                                    Accept: 'application/json' })
      end

      # Fawry does not understand encoded params
      # so we use this encoder to convert the params
      # hash to a string of query params without encoding
      # { a: 1, b: 2 } => a=1&b=2
      class ParamsSpecialEncoder
        def self.encode(hash)
          hash.each_with_object([]) { |(k, v), arr| arr << "#{k}=#{v}" }.join('&')
        end

        def self.decode(string)
          arr = string.split('&')
          arr.to_h { |str| str.split('=') }
        end
      end
    end
  end
end
