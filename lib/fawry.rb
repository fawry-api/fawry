# frozen_string_literal: true

require 'fawry/version'
require 'fawry/connection'
require 'fawry/fawry_request'
require 'fawry/requests/charge_request'

module Fawry
  def self.charge(params)
    FawryRequest.new('charge', params).fire
  end
end
