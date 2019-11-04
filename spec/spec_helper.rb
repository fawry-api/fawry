# frozen_string_literal: true

require 'bundler/setup'
require 'fawry'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# rubocop:disable Metrics/MethodLength
def params
  { "merchant_code": 'merchant_code',
    "merchant_ref_num": 'io5jxf3jp27kfh8m719arcqgw7izo7db',
    "customer_profile_id": 'ocvsydvbu2gcp528wvl64i9z5srdalg5',
    "customer_mobile": '012345678901',
    "payment_method": 'PAYATFAWRY',
    "currency_code": 'EGP',
    "amount": 20.5,
    'fawry_secure_key': 'fawry_secure_key',
    "description": 'the charge request description',
    "charge_items": [{ "item_id": 'fk3fn9flk8et9a5t9w3c5h3oc684ivho',
                       "description": 'asdasd', "price": 20.5, "quantity": 1 }] }
end
# rubocop:enable Metrics/MethodLength

# rubocop:disable Metrics/MethodLength
def fawry_params
  {
    merchantCode: params[:merchant_code],
    merchantRefNum: params[:merchant_ref_num],
    customerProfileId: params[:customer_profile_id],
    customerMobile: params[:customer_mobile],
    paymentMethod: params[:payment_method],
    amount: params[:amount],
    description: params[:description],
    paymentExpiry: params[:payment_expiry],
    chargeItems: [{ 'itemId': 'fk3fn9flk8et9a5t9w3c5h3oc684ivho', 'description': 'asdasd',
                    'price': 20.5, 'quantity': 1 }],
    currencyCode: 'EGP',
    signature: '68a1ff1e7189137f1b3c98784399b3adc49bd644d159593a8ed2fc70a810bd7b'
  }.compact
end
# rubocop:enable Metrics/MethodLength

def fawry_api_response
  { 'type' => 'ChargeResponse',
    'referenceNumber' => '931215518',
    'merchantRefNumber' => 'io5jxf3jp27kfh8m719arcqgw7izo7db',
    'expirationTime' => 1_572_884_477_505,
    'statusCode' => 200,
    'statusDescription' => 'Operation done successfully' }.to_json
end

def fawry_api_failure_response
  { 'type' => 'ChargeResponse',
    'statusCode' => 9946,
    'statusDescription' => 'INVALID_SIGNATURE' }.to_json
end
