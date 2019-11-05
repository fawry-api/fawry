# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class RefundRequestContract < Dry::Validation::Contract
      params do
        required(:merchant_code).value(:string)
        required(:reference_number).value(:string)
        required(:refund_amount).value(:decimal)
        required(:fawry_secure_key).value(:string)
        optional(:reason).value(:string)
      end
    end
  end
end
