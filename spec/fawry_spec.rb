# frozen_string_literal: true

RSpec.describe Fawry do
  it 'has a version number' do
    expect(Fawry::VERSION).not_to be nil
  end

  describe '.charge' do
    it 'returns success' do
      stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'charge')
        .with(body: fawry_params)
        .to_return(status: 200, body: fawry_api_response)

      response = described_class.charge(params)
      expect(response.success?).to be true
      expect(response.status_code).to eq(200)
      expect(response.reference_number).to eq('931215518')
    end
  end
end
