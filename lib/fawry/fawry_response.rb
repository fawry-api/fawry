# frozen_string_literal: true

module Fawry
  class FawryResponse
    attr_reader :fawry_api_response

    def initialize(fawry_api_response)
      @fawry_api_response = fawry_api_response

      build_response
    end

    def success?
      status_code == 200
    end

    def failure?
      !success?
    end

    def fawry_api_response_body
      fawry_api_response
    end

    private

    # Adds keys from fawry API response as methods
    # on FawryResponse instance that return the value
    # of each key
    #
    # type => type
    # referenceNumber => reference_number
    # merchantRefNumber => merchant_ref_number
    # expirationTime => expiration_time
    # statusCode => status_code
    # statusDescription => status_description
    #
    # fawry_res = FawryResponse.new(response)
    # fawry_res.status_code => 200
    # fawry_res.reference_number => 1234567
    def build_response
      fawry_api_response.keys.each do |key|
        method_name = key.split(/(?=[A-Z])/).map(&:downcase).join('_') # statusCode => status_code
        method_body = proc { fawry_api_response[key] }

        self.class.public_send(:define_method, method_name, method_body)
      end
    end
  end
end
