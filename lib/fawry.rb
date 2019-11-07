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
    # Sends a charge request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:merchant_code).value(:string)
    # required(:merchant_ref_num).value(:string)
    # required(:customer_profile_id).value(:string)
    # required(:amount).value(:decimal)
    # required(:description).value(:string)
    # required(:customer_mobile).value(:string)
    # required(:fawry_secure_key).value(:string)
    # required(:charge_items).array(:hash) do
    #   required(:item_id).value(:string)
    #   required(:description).value(:string)
    #   required(:price).value(:decimal)
    #   required(:quantity).value(:integer)
    # end
    # optional(:currency_code).value(:string)
    # optional(:card_token).value(:string)
    # optional(:customer_email).value(:string)
    # optional(:payment_method).value(:string)
    # optional(:payment_expiry).value(:integer)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    # Example: `Fawry.charge(params, sandbox: true)`
    #
    # @raise [Fawry::InvalidFawryRequest] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?
    def charge(params, opts = {})
      FawryRequest.new('charge', params, opts).fire_charge_request
    end

    # Sends a refund request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:merchant_code).value(:string)
    # required(:reference_number).value(:string)
    # required(:refund_amount).value(:decimal)
    # required(:fawry_secure_key).value(:string)
    # optional(:reason).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequest] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?
    def refund(params, opts = {})
      FawryRequest.new('refund', params, opts).fire_refund_request
    end
  end
end
