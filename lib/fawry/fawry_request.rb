# frozen_string_literal: true

module Fawry
  class FawryRequest
    attr_reader :action, :params, :request

    def initialize(action, params)
      @action = action
      @params = params

      build_request
    end

    private

    def build_request
      case action
      when 'charge'
        self.class.include Requests::ChargeRequest
        validate_charge_params!
        @request = build_charge_request
      end
    end
  end
end
