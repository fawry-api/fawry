# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module PaymentStatusRequest
      def fire_payment_status_request
        fawry_api_response = Connection.get(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_payment_status_request
        {
          path: 'status',
          params: payment_status_request_transformed_params,
          body: {},
          options: options
        }
      end

      def request_params
        @request_params = params
      end

      def payment_status_request_transformed_params
        {
          merchantCode: request_params[:merchant_code],
          merchantRefNumber: request_params[:merchant_ref_number],
          signature: payment_status_request_signature
        }.compact
      end

      def validate_payment_status_params!
        contract = Contracts::PaymentStatusRequestContract.new.call(request_params)
        raise InvalidFawryRequest, contract.errors.to_h if contract.failure?
      end

      def payment_status_request_signature
        Digest::SHA256.hexdigest("#{request_params[:merchant_code]}#{request_params[:merchant_ref_number]}"\
                                 "#{request_params[:fawry_secure_key]}")
      end
    end
  end
end
