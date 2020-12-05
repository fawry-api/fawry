# frozen_string_literal: true

RSpec.describe Fawry::Connection do
  context 'production env requests' do
    it 'makes requets to fawry production url if sandbox option is false' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      Fawry::FawryRequest.new('charge', params, sandbox: false).fire_charge_request

      expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
    end
  end

  context 'sandbox requests' do
    it 'makes requets to fawry sandbox url if sandbox option is true' do
      stub_request(:post, Fawry::Connection::FAWRY_SANDBOX_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      Fawry::FawryRequest.new('charge', params, sandbox: true).fire_charge_request

      expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_SANDBOX_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
    end
  end
end
