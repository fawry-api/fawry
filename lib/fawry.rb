# frozen_string_literal: true

require 'fawry/version'
require 'fawry/connection'
require 'fawry/errors'
require 'fawry/utils'
require 'fawry/fawry_request'
require 'fawry/fawry_response'
require 'fawry/fawry_callback'
require 'fawry/requests/charge_request'
require 'fawry/requests/refund_request'
require 'fawry/requests/payment_status_request'
require 'fawry/requests/create_card_token_request'
require 'fawry/requests/list_tokens_request'
require 'fawry/requests/delete_token_request'
require 'fawry/contracts/charge_request_contract'
require 'fawry/contracts/refund_request_contract'
require 'fawry/contracts/payment_status_request_contract'
require 'fawry/contracts/create_card_token_request_contract'
require 'fawry/contracts/list_tokens_request_contract'
require 'fawry/contracts/delete_token_request_contract'

module Fawry
  class << self
    # Sends a charge request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:merchant_ref_num).value(:string)
    # required(:customer_profile_id).value(:string)
    # required(:amount).value(:decimal)
    # required(:description).value(:string)
    # required(:customer_mobile).value(:string)
    # required(:charge_items).array(:hash) do
    #   required(:item_id).value(:string)
    #   required(:description).value(:string)
    #   required(:price).value(:decimal)
    #   required(:quantity).value(:integer)
    # end
    # optional(:merchant_code).value(:string)
    # optional(:fawry_secure_key).value(:string)
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
    # @raise [Fawry::InvalidFawryRequestError] raised when one
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
    # required(:reference_number).value(:string)
    # required(:refund_amount).value(:decimal)
    # optional(:merchant_code).value(:string)
    # optional(:fawry_secure_key).value(:string)
    # optional(:reason).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequestError] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?
    def refund(params, opts = {})
      FawryRequest.new('refund', params, opts).fire_refund_request
    end

    # Sends a payment status request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:merchant_ref_number).value(:string)
    # optional(:merchant_code).value(:string)
    # optional(:fawry_secure_key).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequestError] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?
    def payment_status(params, opts = {})
      FawryRequest.new('payment_status', params, opts).fire_payment_status_request
    end

    # Sends a card token request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:customer_profile_id).value(:string)
    # required(:customer_mobile).value(:string)
    # required(:merchant_code).value(:string)
    # required(:customer_email).value(:string)
    # required(:card_number).value(:string)
    # required(:expiry_year).value(:string)
    # required(:expiry_month).value(:string)
    # required(:cvv).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequestError] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?

    def create_card_token(params, opts = {})
      FawryRequest.new('create_card_token', params, opts).fire_create_card_token_request
    end

    # Sends a list tokens request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:merchant_code).value(:string)
    # required(:customer_profile_id).value(:string)
    # optional(:fawry_secure_key).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequestError] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?

    def list_tokens(params, opts = {})
      FawryRequest.new('list_tokens', params, opts).fire_list_tokens_request
    end

    # Sends delete token request to Fawry API
    # performs param validation and builds
    # the request signature
    #
    # @param params [Hash] list of params to send to fawry
    # required(:customer_profile_id).value(:string)
    # optional(:merchant_code).value(:string)
    # optional(:fawry_secure_key).value(:string)
    #
    # @param opts [Hash] list of options to
    # configure the request
    # @option opts :sandbox [Boolean] whether to
    # send the request to fawry sandbox env or not
    # false by default
    #
    # @raise [Fawry::InvalidFawryRequestError] raised when one
    # or more of the params are invalid. the message
    # specifices which params and why are they invalid
    #
    # @return [Fawry::FawryResponse] an object that
    # has Fawry API response keys as instance methods
    # plus some convenience methods e.g. success?

    def delete_token(params, opts = {})
      FawryRequest.new('delete_token', params, opts).fire_delete_token_request
    end

    # Parses Fawry callback v2 into
    # FawryCallback object with callback
    # params as instance methods
    #
    # @param params [Hash] list of params sent
    # from fawry server callback
    #
    # @param opts [Hash] list of options to
    # configure the request. currently no
    # options available
    #
    # @raise [Fawry::InvalidSignatureError] raised when
    # request signature cannot be verified
    #
    # @return [Fawry::FawryCallback] an object that
    # has Fawry server callback params' keys as instance methods
    def parse_callback(params, opts = {})
      FawryCallback.new(params, opts).parse
    end
  end
end
