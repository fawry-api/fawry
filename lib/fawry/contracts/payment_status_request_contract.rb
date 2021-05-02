# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class PaymentStatusRequestContract < Dry::Validation::Contract
      params do
        required(:merchant_ref_number).value(:string)
        optional(:merchant_code).value(:string)
        optional(:fawry_secure_key).value(:string)
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
