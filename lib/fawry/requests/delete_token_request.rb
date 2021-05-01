# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module DeleteTokenRequest
      def fire_delete_token_request
        fawry_api_response = Connection.delete(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_delete_token_request
        {
          path: 'cards/cardToken',
          params: {},
          body: delete_token_request_transformed_params,
          options: options
        }
      end

      def request_params
        @request_params = params
      end

      def delete_token_request_transformed_params
        {
          merchantCode: fawry_merchant_code,
          customerProfileId: request_params[:customer_profile_id],
          signature: delete_token_request_signature,
          cardToken: request_params[:card_token]
        }.compact
      end

      def fawry_merchant_code
        Fawry.configuration.fawry_merchant_code || ENV.fetch('FAWRY_MERCHANT_CODE') { request_params[:merchant_code] }
      end

      def fawry_secure_key
        Fawry.configuration.fawry_secure_key || ENV.fetch('FAWRY_SECURE_KEY') { request_params[:fawry_secure_key] }
      end

      def card_token
        request_params[:card_token]
      end

      def validate_delete_token_params!
        contract = Contracts::ListTokensRequestContract.new.call(request_params)
        raise InvalidFawryRequestError, contract.errors.to_h if contract.failure?
      end

      def delete_token_request_signature
        Digest::SHA256.hexdigest("#{fawry_merchant_code}#{request_params[:customer_profile_id]}"\
                                 "#{card_token}#{fawry_secure_key}")
      end
    end
  end
end
