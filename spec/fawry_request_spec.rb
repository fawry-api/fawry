# frozen_string_literal: true

RSpec.describe Fawry::FawryRequest do
  context 'charge request' do
    describe '.new' do
      it 'builds the correct charge request' do
        fawry_request = described_class.new('charge', params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::ChargeRequest)).to be true
        expect(fawry_request.action).to eq('charge')
        expect(fawry_request.request[:path]).to eq('charge')
        expect(fawry_request.request[:body].keys).to eq(fawry_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a charge request to fawry' do
        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'charge')
          .with(body: fawry_params)
          .to_return(status: 200, body: fawry_api_response)

        described_class.new('charge', params, {}).fire_charge_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'charge')
          .with(body: fawry_params)
      end
    end
  end

  context 'refund request' do
    describe '.new' do
      it 'builds the correct refund request' do
        fawry_request = described_class.new('refund', refund_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::RefundRequest)).to be true
        expect(fawry_request.action).to eq('refund')
        expect(fawry_request.request[:path]).to eq('refund')
        expect(fawry_request.request[:body].keys).to eq(fawry_refund_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a refund request to fawry' do
        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'refund')
          .with(body: fawry_refund_params)
          .to_return(status: 200, body: fawry_refund_response)

        described_class.new('refund', refund_params, {}).fire_refund_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'refund')
          .with(body: fawry_refund_params)
      end
    end
  end

  context 'payment status request' do
    describe '.new' do
      it 'builds the correct payment status request' do
        fawry_request = described_class.new('payment_status', payment_status_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::PaymentStatusRequest)).to be true
        expect(fawry_request.action).to eq('payment_status')
        expect(fawry_request.request[:path]).to eq('status')
        expect(fawry_request.request[:params].keys).to eq(fawry_payment_status_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a payment status request to fawry' do
        stub_request(:get, Fawry::Connection::FAWRY_BASE_URL + 'status')
          .with(query: fawry_payment_status_params)
          .to_return(status: 200, body: fawry_payment_status_response)

        described_class.new('payment_status', payment_status_params, {}).fire_payment_status_request

        expect(WebMock).to have_requested(:get, Fawry::Connection::FAWRY_BASE_URL + 'status')
          .with(query: fawry_payment_status_params)
      end
    end
  end
end
