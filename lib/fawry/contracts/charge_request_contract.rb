# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class ChargeRequestContract < Dry::Validation::Contract
      params do
        required(:merchant_ref_num).value(:string)
        required(:customer_profile_id).value(:string)
        required(:amount).value(:decimal)
        required(:description).value(:string)
        required(:customer_mobile).value(:string)
        required(:charge_items).array(:hash) do
          required(:item_id).value(:string)
          required(:description).value(:string)
          required(:price).value(:decimal)
          required(:quantity).value(:integer)
        end
        optional(:language).value(:string)
        optional(:merchant_code).value(:string)
        optional(:fawry_secure_key).value(:string)
        optional(:currency_code).value(:string)
        optional(:card_token).value(:string)
        optional(:customer_email).value(:string)
        optional(:payment_method).value(:string)
        optional(:payment_expiry).value(:integer)
      end

      rule(:customer_email) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key? && key.failure('has invalid format')
        end
      end

      rule(:payment_method) do
        if key? && value == 'CARD' && values[:card_token].nil?
          key.failure('card_token is required when payment_method is CARD')
        end
      end

      rule(:fawry_secure_key) do
        if Fawry.configuration.fawry_secure_key.nil? && ENV['FAWRY_SECURE_KEY'].nil? && value.nil?
          key(:fawry_secure_key).failure('fawry secure key is required in either Fawry.configuration or'\
            'as an environment variable (FAWRY_SECURE_KEY), or as an argument to this method')
        end
      end

      rule(:merchant_code) do
        if Fawry.configuration.fawry_merchant_code.nil? && ENV['FAWRY_MERCHANT_CODE'].nil? && value.nil?
          key(:merchant_code).failure('fawry merchant code is required in either Fawry.configuration or'\
            'as an environment variable (FAWRY_MERCHANT_CODE), or as an argument to this method')
        end
      end
    end
  end
end
