# frozen_string_literal: true

require 'fawry/version'
require 'fawry/connection'
require 'fawry/errors'
require 'fawry/fawry_request'
require 'fawry/fawry_response'
require 'fawry/requests/charge_request'
require 'fawry/requests/refund_request'
require 'fawry/contracts/charge_request_contract'
require 'fawry/contracts/refund_request_contract'

module Fawry
  class << self
    def charge(params)
      FawryRequest.new('charge', params).fire
    end

    def refund(params)
      FawryRequest.new('refund', params).fire
    end
  end
end
