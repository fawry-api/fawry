# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module ListTokensRequest
      def fire_list_tokens_request
        fawry_api_response = Connection.get(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_list_tokens_request
        {
          path: 'cards/cardToken',
          params: list_tokens_request_transformed_params,
          body: {},
          options: options
        }
      end

      def request_params
        @request_params = params
      end

      def list_tokens_request_transformed_params
        {
          merchantCode: fawry_merchant_code,
          customerProfileId: request_params[:customer_profile_id],
          signature: list_tokens_request_signature
        }.compact
      end

      def fawry_merchant_code
        Fawry.configuration.fawry_merchant_code || ENV.fetch('FAWRY_MERCHANT_CODE') { request_params[:merchant_code] }
      end

      def fawry_secure_key
        Fawry.configuration.fawry_secure_key || ENV.fetch('FAWRY_SECURE_KEY') { request_params[:fawry_secure_key] }
      end

      def validate_list_tokens_params!
        contract = Contracts::ListTokensRequestContract.new.call(request_params)
        raise InvalidFawryRequestError, contract.errors.to_h if contract.failure?
      end

      def list_tokens_request_signature
        Digest::SHA256.hexdigest("#{fawry_merchant_code}#{request_params[:customer_profile_id]}"\
                                 "#{fawry_secure_key}")
      end
    end
  end
end
