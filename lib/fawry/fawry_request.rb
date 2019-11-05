# frozen_string_literal: true

module Fawry
  class FawryRequest
    DEFAULT_OPTIONS = { sandbox: false }.freeze

    attr_reader :action, :params, :request, :options

    def initialize(action, params, opts)
      @action = action
      @params = params
      @options = DEFAULT_OPTIONS.merge(opts)

      build_request
    end

    private

    def build_request
      case action
      when 'charge'
        self.class.include Requests::ChargeRequest
        validate_charge_params!
        @request = build_charge_request
      when 'refund'
        self.class.include Requests::RefundRequest
        validate_refund_params!
        @request = build_refund_request
      end
    end
  end
end
