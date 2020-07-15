# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module RefundRequest
      def fire_refund_request
        fawry_api_response = Connection.post(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_refund_request
        {
          path: 'payments/refund',
          params: {},
          body: refund_request_transformed_params,
          options: options
        }
      end

      def request_params
        @request_params = params
      end

      def refund_request_transformed_params
        {
          merchantCode: fawry_merchant_code,
          referenceNumber: request_params[:reference_number],
          refundAmount: request_params[:refund_amount],
          reason: request_params[:reason],
          signature: refund_request_signature
        }.compact
      end

      def fawry_merchant_code
        ENV.fetch('FAWRY_MERCHANT_CODE') { request_params[:merchant_code] }
      end

      def fawry_secure_key
        ENV.fetch('FAWRY_SECURE_KEY') { request_params[:fawry_secure_key] }
      end

      def validate_refund_params!
        contract = Contracts::RefundRequestContract.new.call(request_params)
        raise InvalidFawryRequestError, contract.errors.to_h if contract.failure?
      end

      def refund_request_signature
        Digest::SHA256.hexdigest("#{fawry_merchant_code}#{request_params[:reference_number]}"\
                                 "#{format('%<refund_amount>.2f', refund_amount: request_params[:refund_amount])}"\
                                 "#{request_params[:reason]}#{fawry_secure_key}")
      end
    end
  end
end
