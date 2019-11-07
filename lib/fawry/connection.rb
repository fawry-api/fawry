# frozen_string_literal: true

require 'faraday'
require 'json'

module Fawry
  class Connection
    FAWRY_BASE_URL = 'https://www.atfawry.com/ECommerceWeb/Fawry/payments/'

    FAWRY_SANDBOX_BASE_URL = 'https://atfawry.fawrystaging.com//ECommerceWeb/Fawry/payments/'

    class << self
      def post(path, params, body, options)
        conn = options[:sandbox] ? sandbox_connection : connection

        conn.post(path) do |request|
          request.params = params
          request.body = body.to_json
        end
      end

      def get(path, params, body, options)
        conn = options[:sandbox] ? sandbox_connection : connection

        conn.get(path) do |request|
          request.params = params
          request.body = body.to_json
          # Fawry doesn't understand encoded params
          request.options = request.options.merge(params_encoder: ParamsSpecialEncoder)
        end
      end

      private

      def connection
        @connection ||= Faraday.new(url: FAWRY_BASE_URL, headers: { 'Content-Type': 'application/json',
                                                                    'Accept': 'application/json' })
      end

      def sandbox_connection
        @sandbox_connection ||= Faraday.new(url: FAWRY_SANDBOX_BASE_URL, headers: { 'Content-Type': 'application/json',
                                                                                    'Accept': 'application/json' })
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
          arr.map { |str| str.split('=') }.to_h
        end
      end
    end
  end
end
