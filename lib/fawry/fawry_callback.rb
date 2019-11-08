# frozen_string_literal: true

module Fawry
  class FawryCallback
    include Utils

    attr_reader :callback_params, :fawry_secure_key, :options

    def initialize(callback_params, fawry_secure_key, opts)
      @callback_params = callback_params
      @fawry_secure_key = fawry_secure_key
      @options = opts
    end

    def parse
      verify_callback_signature!
      build_callback

      self
    end

    private

    # Adds keys from fawry API response as methods
    # on FawryCallback instance that return the value
    # of each key
    #
    # type => type
    # referenceNumber => reference_number
    # merchantRefNumber => merchant_ref_number
    # expirationTime => expiration_time
    # statusCode => status_code
    # statusDescription => status_description
    #
    # fawry_callback = FawryCallback.new(callback_params, fawry_secure_key)
    # fawry_callback.order_status => PAID
    # fawry_callback.fawry_ref_number => 1234567
    def build_callback
      enrich_object(callback_params)
    end

    def verify_callback_signature!
      raise InvalidSignatureError, 'Invalid Signature' unless signature == callback_params[:messageSignature]
    end

    # rubocop:disable Metrics/AbcSize
    def signature
      Digest::SHA256.hexdigest("#{callback_params[:fawryRefNumber]}#{callback_params[:merchantRefNum]}"\
                               "#{format('%<paymentAmount>.2f', paymentAmount: callback_params[:paymentAmount])}"\
                               "#{format('%<orderAmount>.2f', orderAmount: callback_params[:orderAmount])}"\
                               "#{callback_params[:orderStatus]}#{callback_params[:paymentMethod]}"\
                               "#{callback_params[:paymentRefrenceNumber]}#{fawry_secure_key}")
    end
    # rubocop:enable Metrics/AbcSize
  end
end
