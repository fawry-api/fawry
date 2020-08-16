# frozen_string_literal: true

RSpec.describe Fawry::FawryResponse do
  describe '.new' do
    it 'wraps fawry API response inside FawryResponse instance' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      fawry_response = Fawry::FawryRequest.new('charge', params, {}).fire_charge_request

      expect(fawry_response.class).to eq(Fawry::FawryResponse)
      expect(fawry_response.success?).to be true
    end

    it 'adds fawry API response keys as methods on FawryResponse instance' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      fawry_response = Fawry::FawryRequest.new('charge', params, {}).fire_charge_request

      expect(fawry_response.class).to eq(Fawry::FawryResponse)
      expect(fawry_response.status_code).to eq(200)
      expect(fawry_response.reference_number).to eq('931215518')
      expect(fawry_response.type).to eq('ChargeResponse')
      expect(fawry_response.merchant_ref_number).to eq('io5jxf3jp27kfh8m719arcqgw7izo7db')
      expect(fawry_response.expiration_time).to eq(1_572_884_477_505)
      expect(fawry_response.status_description).to eq('Operation done successfully')
    end
  end

  describe '#success?' do
    it 'returns true if operation was a success at fawry' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      fawry_response = Fawry::FawryRequest.new('charge', params, {}).fire_charge_request

      expect(fawry_response.success?).to be true
      expect(fawry_response.failure?).to be false
    end
  end

  describe '#failure?' do
    it 'returns true if operation failed at fawry' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_failure_response)

      fawry_response = Fawry::FawryRequest.new('charge', params, {}).fire_charge_request

      expect(fawry_response.failure?).to be true
      expect(fawry_response.success?).to be false
    end
  end

  describe '#fawry_api_response_body' do
    it 'returns fawry api response body' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      fawry_response = Fawry::FawryRequest.new('charge', params, {}).fire_charge_request

      expect(fawry_response.fawry_api_response_body).to eq(JSON.parse(fawry_api_response))
    end
  end
end
