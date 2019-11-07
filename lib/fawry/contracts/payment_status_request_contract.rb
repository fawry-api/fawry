# frozen_string_literal: true

require 'dry-validation'

module Fawry
  module Contracts
    class PaymentStatusRequestContract < Dry::Validation::Contract
      params do
        required(:merchant_code).value(:string)
        required(:merchant_ref_number).value(:string)
        required(:fawry_secure_key).value(:string)
      end
    end
  end
end
