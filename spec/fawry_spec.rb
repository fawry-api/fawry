# frozen_string_literal: true

RSpec.describe Fawry do
  it 'has a version number' do
    expect(Fawry::VERSION).not_to be nil
  end

  describe '.charge' do
    it 'performs charge request successfully' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      response = described_class.charge(params)
      expect(response.success?).to be true
      expect(response.status_code).to eq(200)
      expect(response.reference_number).to eq('931215518')
    end
  end

  describe '.refund' do
    it 'performs refund request successfully' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/refund')
        .with(body: fawry_refund_params)
        .to_return(status: 200, body: fawry_refund_response)

      response = described_class.refund(refund_params)
      expect(response.success?).to be true
      expect(response.status_code).to eq(200)
    end
  end

  describe '.payment_status' do
    it 'performs payment status request successfully' do
      stub_request(:get, Fawry::Connection::FAWRY_BASE_URL + 'payments/status')
        .with(query: fawry_payment_status_params)
        .to_return(status: 200, body: fawry_payment_status_response)

      response = described_class.payment_status(payment_status_params)
      expect(response.success?).to be true
      expect(response.status_code).to eq(200)
    end
  end

  describe '.parse_callback' do
    it 'parses fawry service callback into FawryCallback' do
      ENV['FAWRY_SECURE_KEY'] = 'fawry_secure_key'

      fawry_callback = described_class.parse_callback(fawry_callback_params, {})
      expect(fawry_callback.class).to eq(Fawry::FawryCallback)
      expect(fawry_callback.order_status).to eq('NEW')
    end
  end
end
