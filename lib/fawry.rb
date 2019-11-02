# frozen_string_literal: true

require 'fawry/version'
require 'fawry/connection'
require 'fawry/errors'
require 'fawry/fawry_request'
require 'fawry/requests/charge_request'
require 'fawry/contracts/charge_request_contract'

module Fawry
  def self.charge(params)
    params = { "merchant_code": 'UJmQBdBgYkM=', "merchant_ref_num": 'io5jxf3jp27kfh8m719arcqgw7izo7db',
               "customer_profile_id": 'ocvsydvbu2gcp528wvl64i9z5srdalg5',
               "customer_mobile": '01118343069',
               "amount": 20.5,
               'fawry_secure_key': '729189fbf99944d3a4cf851e17becf0e',
               "description": 'the charge request description',
               "charge_items": [{ "item_id": 'fk3fn9flk8et9a5t9w3c5h3oc684ivho',
                                  "description": 'asdasd', "price": 20.5, "quantity": 1 }] }
    FawryRequest.new('charge', params).fire
  end
end
