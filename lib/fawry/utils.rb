# frozen_string_literal: true

module Fawry
  module Utils
    TRUTH_VALUES = [true, 'true', '1', 't'].freeze

    # Adds keys from fawry API response as methods
    # on object instance that return the value
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
    def enrich_object(fawry_params)
      fawry_params.each_key do |key|
        method_name = key.to_s.split(/(?=[A-Z])/).map(&:downcase).join('_') # statusCode => status_code
        instance_variable_set("@#{method_name}", fawry_params[key])
        method_body = proc { instance_variable_get("@#{method_name}") }

        self.class.public_send(:define_method, method_name, method_body)
      end
    end
  end
end
