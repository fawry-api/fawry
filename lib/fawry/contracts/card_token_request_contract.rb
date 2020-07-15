# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class CardTokenRequestContract < Dry::Validation::Contract
      params do
        required(:customerProfileId).value(:string)
        required(:customerMobile).value(:string)
        required(:merchantCode).value(:string)
        required(:customerEmail).value(:string)
        required(:cardNumber).value(:string)
        required(:expiryYear).value(:string)
        required(:expiryMonth).value(:string)
        required(:cvv).value(:string)
      end

      rule(:customerEmail) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key? && key.failure('has invalid format')
        end
      end

      rule(:merchantCode) do
        if ENV['FAWRY_MERCHANT_CODE'].nil? && value.nil?
          key(:merchant_code).failure('fawry merchant code is required as a param or an env var')
        end
      end

    end
  end
end
