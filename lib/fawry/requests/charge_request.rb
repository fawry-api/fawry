# frozen_string_literal: true

require 'digest'

module Fawry
  module Requests
    module ChargeRequest
      DEFAULTS = { payment_method: 'PAYATFAWRY', currency_code: 'EGP' }.freeze

      def fire_charge_request
        fawry_api_response = Connection.post(request[:path], request[:params], request[:body], request[:options])
        response_body = JSON.parse(fawry_api_response.body)

        FawryResponse.new(response_body)
      end

      private

      def build_charge_request
        {
          path: 'charge',
          params: {},
          body: charge_request_transformed_params,
          options: options
        }
      end

      def request_params
        @request_params ||= DEFAULTS.merge(params)
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def charge_request_transformed_params
        {
          merchantCode: request_params[:merchant_code],
          merchantRefNum: request_params[:merchant_ref_num],
          customerProfileId: request_params[:customer_profile_id],
          cardToken: request_params[:card_token],
          customerMobile: request_params[:customer_mobile],
          customerEmail: request_params[:customer_email],
          paymentMethod: request_params[:payment_method],
          amount: request_params[:amount],
          description: request_params[:description],
          paymentExpiry: request_params[:payment_expiry],
          chargeItems: charge_items,
          currencyCode: request_params[:currency_code],
          signature: charge_request_signature
        }.compact
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def validate_charge_params!
        contract = Contracts::ChargeRequestContract.new.call(request_params)
        raise InvalidFawryRequest, contract.errors.to_h if contract.failure?
      end

      def charge_items
        request_params[:charge_items].each { |hash| hash[:itemId] = hash.delete(:item_id) }
      end

      # rubocop:disable Metrics/AbcSize
      def charge_request_signature
        Digest::SHA256.hexdigest("#{request_params[:merchant_code]}#{request_params[:merchant_ref_num]}"\
                                 "#{request_params[:customer_profile_id]}#{request_params[:payment_method]}"\
                                 "#{format('%<amount>.2f', amount: request_params[:amount])}"\
                                 "#{request_params[:card_token]}#{request_params[:fawry_secure_key]}")
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
