# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module CardTokenRequest

      def fire_card_token_request
        fawry_api_response = Connection.post(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_card_token_request
        {
          path: 'cards/cardToken',
          params: {},
          body: card_token_request_transformed_params,
          options: options
        }
      end

      def card_token_request
        @card_token_request ||= params
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def card_token_request_transformed_params
        {
          merchantCode: fawry_merchant_code,
          customerProfileId: card_token_request[:customer_profile_id],
          customerMobile: card_token_request[:customer_mobile],
          customerEmail: card_token_request[:customer_email],
          cardNumber: card_token_request[:cardNumber],
          expiryYear: card_token_request[:expiryYear],
          expiryMonth: card_token_request[:expiryMonth],
          cvv: card_token_request[:cvv],
        }.compact
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def fawry_merchant_code
        ENV.fetch('FAWRY_MERCHANT_CODE') { card_token_request[:merchantCode] }
      end

      def fawry_secure_key
        ENV.fetch('FAWRY_SECURE_KEY') { card_token_request[:fawry_secure_key] }
      end

      def validate_card_token_params!
        contract = Contracts::CardTokenRequestContract.new.call(card_token_request)
        raise InvalidFawryRequestError, contract.errors.to_h if contract.failure?
      end
    end
  end
end
