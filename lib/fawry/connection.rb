# frozen_string_literal: true

require 'faraday'
require 'json'

module Fawry
  class Connection
    FAWRY_BASE_URL = 'https://atfawry.fawrystaging.com//ECommerceWeb/Fawry/payments/'

    class << self
      def post(path, params, body)
        connection.post(path) do |request|
          request.params = params
          request.body = body.to_json
        end
      end

      private

      def connection
        @connection ||= Faraday.new(url: FAWRY_BASE_URL, headers: { 'Content-Type': 'application/json',
                                                                    'Accept': 'application/json' })
      end
    end
  end
end
