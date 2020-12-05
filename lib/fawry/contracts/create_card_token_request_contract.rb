# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class CreateCardTokenRequestContract < Dry::Validation::Contract
      params do
        required(:customer_profile_id).value(:string)
        required(:customer_mobile).value(:string)
        required(:merchant_code).value(:string)
        required(:customer_email).value(:string)
        required(:card_number).value(:string)
        required(:expiry_year).value(:string)
        required(:expiry_month).value(:string)
        required(:cvv).value(:string)
      end

      rule(:customer_email) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key? && key.failure('has invalid format')
        end
      end

      rule(:merchant_code) do
        if ENV['FAWRY_MERCHANT_CODE'].nil? && value.nil?
          key(:merchant_code).failure('fawry merchant code is required as a param or an env var')
        end
      end
    end
  end
end
