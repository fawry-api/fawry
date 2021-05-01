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

Fawry.configure do |config|
  config.sandbox = false
  config.fawry_secure_key = nil
  config.fawry_merchant_code = nil
end

# rubocop:disable Metrics/MethodLength
def params
  { merchant_code: 'merchant_code',
    merchant_ref_num: 'io5jxf3jp27kfh8m719arcqgw7izo7db',
    customer_profile_id: 'ocvsydvbu2gcp528wvl64i9z5srdalg5',
    customer_mobile: '012345678901',
    payment_method: 'PAYATFAWRY',
    currency_code: 'EGP',
    amount: 20.5,
    fawry_secure_key: 'fawry_secure_key',
    description: 'the charge request description',
    charge_items: [{ item_id: 'fk3fn9flk8et9a5t9w3c5h3oc684ivho',
                     description: 'asdasd', price: 20.5, quantity: 1 }] }
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
    chargeItems: [{ itemId: 'fk3fn9flk8et9a5t9w3c5h3oc684ivho', description: 'asdasd',
                    price: 20.5, quantity: 1 }],
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

def refund_params
  { merchant_code: 'merchant_code',
    reference_number: '931337410',
    refund_amount: 20.5,
    fawry_secure_key: 'fawry_secure_key' }
end

def fawry_refund_params
  {
    merchantCode: refund_params[:merchant_code],
    referenceNumber: refund_params[:reference_number],
    refundAmount: refund_params[:refund_amount],
    signature: '3ddbaf9457ed9b5f6e048e1775ff7eaccd477070e31cf28a90d879e8f9689323'
  }.compact
end

def fawry_refund_response
  { type: 'ResponseDataModel',
    statusCode: 200,
    statusDescription: 'Operation done successfully' }.to_json
end

def payment_status_params
  { merchant_code: 'merchant_code',
    merchant_ref_number: 'io5jxf3jp27kfh8m719arcqgw7izo7db',
    fawry_secure_key: 'fawry_secure_key' }
end

def fawry_payment_status_params
  {
    merchantCode: payment_status_params[:merchant_code],
    merchantRefNumber: payment_status_params[:merchant_ref_number],
    signature: '7ce8b004c8f18391c273d94c7b3adde7bfa85466104d61c238a27d64fed0d99a'
  }.compact
end

def create_token_params
  {
    customer_profile_id: '1',
    customer_mobile: '01112018697',
    customer_email: 'tssst@gmail.com',
    card_number: '4242424242424242',
    expiry_year: '21',
    expiry_month: '05',
    cvv: '123',
    merchant_code: 'merchant_code'
  }
end

def fawry_create_token_params
  {
    merchantCode: create_token_params[:merchant_code],
    customerProfileId: create_token_params[:customer_profile_id],
    customerMobile: create_token_params[:customer_mobile],
    customerEmail: create_token_params[:customer_email],
    cardNumber: create_token_params[:card_number],
    expiryYear: create_token_params[:expiry_year],
    expiryMonth: create_token_params[:expiry_month],
    cvv: create_token_params[:cvv]
  }.compact
end

def create_card_token_response
  { type: 'CardTokenResponse',
    statusCode: 200,
    statusDescription: 'Operation done successfully' }.to_json
end

def list_tokens_params
  {
    merchant_code: 'merchant_code',
    customer_profile_id: 'customer_profile_id',
    fawry_secure_key: 'fawry_secure_key'
  }
end

def fawry_list_tokens_params
  {
    merchantCode: list_tokens_params[:merchant_code],
    customerProfileId: list_tokens_params[:customer_profile_id],
    signature: 'a05d6e98f405c5207e623f9f336f1ab0fa88af82008faeacfd4dcf89d35b022b'
  }.compact
end

def list_tokens_response
  { type: 'CustomerTokensResponse',
    statusCode: 200,
    statusDescription: 'Operation done successfully' }.to_json
end

def delete_token_params
  {
    merchant_code: 'merchant_code',
    customer_profile_id: 'customer_profile_id',
    card_token: 'card_token',
    fawry_secure_key: 'fawry_secure_key'
  }
end

def fawry_delete_token_params
  {
    merchantCode: delete_token_params[:merchant_code],
    customerProfileId: delete_token_params[:customer_profile_id],
    signature: 'dceabc10e46a4093b5fec54d782d9049e04080fdde3fa6a5bbf5455303491c2c',
    cardToken: delete_token_params[:card_token]
  }.compact
end

def delete_token_response
  { type: 'CardTokenResponse',
    statusCode: 200,
    statusDescription: 'Operation done successfully' }.to_json
end

def fawry_payment_status_response
  { 'type' => 'PaymentStatusResponse', 'referenceNumber' => '931849400',
    'merchantRefNumber' => 'x0y9y9k17pk5sqlartlj07bcu8q8t7x3',
    'paymentAmount' => 20.5, 'expirationTime' => 1_573_223_034_378, 'paymentMethod' => 'PAYATFAWRY',
    'paymentStatus' => 'UNPAID',
    'statusCode' => 200, 'statusDescription' => 'Operation done successfully' }.to_json
end

def fawry_api_failure_response
  { 'type' => 'ChargeResponse',
    'statusCode' => 9946,
    'statusDescription' => 'INVALID_SIGNATURE' }.to_json
end

def fawry_callback_params
  { requestId: 'c72827d084ea4b88949d91dd2db4996e', fawryRefNumber: '970177',
    merchantRefNumber: '9708f1cea8b5426cb57922df51b7f790',
    customerMobile: '01004545545', customerMail: 'fawry@fawry.com',
    paymentAmount: 152.00, orderAmount: 150.00, fawryFees: 2.00,
    shippingFees: '', orderStatus: 'NEW', paymentMethod: 'PAYATFAWRY',
    messageSignature: 'b0175565323e464b01dc9407160368af5568196997fb6e379374a4f4fbbcf587',
    orderExpiryDate: 1_533_554_719_314,
    orderItems: [{ itemCode: 'e6aacbd5a498487ab1a10ae71061535d', price: 150.0, quantity: 1 }] }
end
