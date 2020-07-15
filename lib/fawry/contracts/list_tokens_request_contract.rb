# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class ListTokensRequestContract < Dry::Validation::Contract
      params do
        required(:merchantCode).value(:string)
        required(:customerProfileId).value(:string)
        optional(:fawry_secure_key).value(:string)
      end

      rule(:fawry_secure_key) do
        if ENV['FAWRY_SECURE_KEY'].nil? && value.nil?
          key(:fawry_secure_key).failure('fawry secure key is required as a param or an env var')
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
