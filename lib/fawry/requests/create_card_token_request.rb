# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module CreateCardTokenRequest

      def fire_create_card_token_request
        fawry_api_response = Connection.post(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_create_card_token_request
        {
          path: 'cards/cardToken',
          params: {},
          body: create_card_token_request_transformed_params,
          options: options
        }
      end

      def create_card_token_request
        @create_card_token_request ||= params
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def create_card_token_request_transformed_params
        {
          merchantCode: fawry_merchant_code,
          customerProfileId: create_card_token_request[:customer_profile_id],
          customerMobile: create_card_token_request[:customer_mobile],
          customerEmail: create_card_token_request[:customer_email],
          cardNumber: create_card_token_request[:card_number],
          expiryYear: create_card_token_request[:expiry_year],
          expiryMonth: create_card_token_request[:expiry_month],
          cvv: create_card_token_request[:cvv],
        }.compact
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def fawry_merchant_code
        ENV.fetch('FAWRY_MERCHANT_CODE') { create_card_token_request[:merchant_code] }
      end

      def fawry_secure_key
        ENV.fetch('FAWRY_SECURE_KEY') { create_card_token_request[:fawry_secure_key] }
      end

      def validate_card_token_params!
        contract = Contracts::CreateCardTokenRequestContract.new.call(create_card_token_request)
        raise InvalidFawryRequestError, contract.errors.to_h if contract.failure?
      end
    end
  end
end
