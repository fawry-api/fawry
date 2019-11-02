require 'digest'

module Fawry
  module Requests
    module ChargeRequest
      def fire
        Connection.post(request[:path], request[:params], request[:body])
        # FawryResponse.new(response)
      end

      private

      DEFAULTS = { payment_method: 'PAYATFAWRY', currency_code: 'EGP' }.freeze

      def build_charge_request
        {
          path: 'charge',
          params: {},
          body: charge_request_params
        }
      end

      def charge_request_params
        {
          merchantCode: params[:merchant_code],
          merchantRefNum: params[:merchant_ref_num],
          customerProfileId: params[:customer_profile_id],
          cardToken: params[:card_token],
          customerMobile: params[:customer_mobile],
          customerEmail: params[:customer_email],
          paymentMethod: params[:payment_method],
          amount: params[:amount],
          description: params[:description],
          paymentExpiry: params[:payment_expiry],
          chargeItems: params[:charge_items],
          currencyCode: params[:currency_code],
          signature: charge_signature
        }
      end

      def validate_charge_params!
        # do nothing for now
      end

      def charge_signature
        Digest::SHA256.hexdigest("#{params[:merchant_code]}#{params[:merchant_ref_num]}#{params[:customer_profile_id]} \
                                 #{params[:payment_method]}#{format('%.2f', params[:amount])}#{params[:fawry_secure_key]}")
      end
    end
  end
end
