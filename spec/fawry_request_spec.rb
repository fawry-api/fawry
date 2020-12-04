# frozen_string_literal: true

RSpec.describe Fawry::FawryRequest do
  context 'charge request' do
    describe '.new' do
      it 'builds the correct charge request' do
        fawry_request = described_class.new('charge', params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::ChargeRequest)).to be true
        expect(fawry_request.action).to eq('charge')
        expect(fawry_request.request[:path]).to eq('payments/charge')
        expect(fawry_request.request[:body].keys).to eq(fawry_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a charge request to fawry' do
        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
          .to_return(status: 200, body: fawry_api_response)

        described_class.new('charge', params, {}).fire_charge_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
      end
    end

    context 'when reading configuration keys' do
      before do
        ENV.delete('FAWRY_SECURE_KEY')
        ENV.delete('FAWRY_MERCHANT_CODE')
      end
      let(:params_without_config_keys) do
        temp = params.tap { |ps| ps.delete(:fawry_secure_key) }
        temp.tap { |ps| ps.delete(:merchant_code) }
      end

      it 'reads config keys from environment variables' do
        ENV['FAWRY_SECURE_KEY'] = 'fawry_secure_key'
        ENV['FAWRY_MERCHANT_CODE'] = 'merchant_code'

        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
          .to_return(status: 200, body: fawry_api_response)

        described_class.new('charge', params_without_config_keys, {}).fire_charge_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
      end

      context 'when config keys are missing from params and environment variables' do
        it 'raises Fawry::InvalidFawryRequestError' do
          expect do
            described_class.new('charge', params_without_config_keys, {}).fire_charge_request
          end.to raise_error(Fawry::InvalidFawryRequestError)
        end
      end
    end
  end

  context 'refund request' do
    describe '.new' do
      it 'builds the correct refund request' do
        fawry_request = described_class.new('refund', refund_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::RefundRequest)).to be true
        expect(fawry_request.action).to eq('refund')
        expect(fawry_request.request[:path]).to eq('payments/refund')
        expect(fawry_request.request[:body].keys).to eq(fawry_refund_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a refund request to fawry' do
        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/refund')
          .with(body: fawry_refund_params)
          .to_return(status: 200, body: fawry_refund_response)

        described_class.new('refund', refund_params, {}).fire_refund_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/refund')
          .with(body: fawry_refund_params)
      end
    end

    context 'when reading configuration keys' do
      before do
        ENV.delete('FAWRY_SECURE_KEY')
        ENV.delete('FAWRY_MERCHANT_CODE')
      end
      let(:params_without_secure_key) { params.tap { |ps| ps.delete(:fawry_secure_key) } }

      it 'reads config keys from environment variables' do
        ENV['FAWRY_SECURE_KEY'] = 'fawry_secure_key'

        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
          .to_return(status: 200, body: fawry_api_response)

        described_class.new('charge', params_without_secure_key, {}).fire_charge_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
      end
    end
  end

  context 'payment status request' do
    describe '.new' do
      it 'builds the correct payment status request' do
        fawry_request = described_class.new('payment_status', payment_status_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::PaymentStatusRequest)).to be true
        expect(fawry_request.action).to eq('payment_status')
        expect(fawry_request.request[:path]).to eq('payments/status')
        expect(fawry_request.request[:params].keys).to eq(fawry_payment_status_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a payment status request to fawry' do
        stub_request(:get, Fawry::Connection::FAWRY_BASE_URL + 'payments/status')
          .with(query: fawry_payment_status_params)
          .to_return(status: 200, body: fawry_payment_status_response)

        described_class.new('payment_status', payment_status_params, {}).fire_payment_status_request

        expect(WebMock).to have_requested(:get, Fawry::Connection::FAWRY_BASE_URL + 'payments/status')
          .with(query: fawry_payment_status_params)
      end
    end

    context 'when reading configuration keys' do
      before do
        ENV.delete('FAWRY_SECURE_KEY')
        ENV.delete('FAWRY_MERCHANT_CODE')
      end
      let(:params_without_merchant_code) { params.tap { |ps| ps.delete(:merchant_code) } }

      it 'reads config keys from environment variables' do
        ENV['FAWRY_MERCHANT_CODE'] = 'merchant_code'

        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
          .to_return(status: 200, body: fawry_api_response)

        described_class.new('charge', params_without_merchant_code, {}).fire_charge_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'payments/charge')
          .with(body: fawry_params)
      end
    end
  end

  context 'create card token request' do
    describe '.new' do
      it 'builds the correct create card token request' do
        fawry_request = described_class.new('create_card_token', create_token_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::CreateCardTokenRequest)).to be true
        expect(fawry_request.action).to eq('create_card_token')
        expect(fawry_request.request[:path]).to eq('cards/cardToken')
        expect(fawry_request.request[:body].keys).to eq(fawry_create_token_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a create card token request to fawry' do
        stub_request(:post, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(body: fawry_create_token_params)
          .to_return(status: 200, body: create_card_token_response)

        described_class.new('create_card_token', create_token_params, {}).fire_create_card_token_request

        expect(WebMock).to have_requested(:post, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(body: fawry_create_token_params)
      end
    end
  end

  context 'list card tokens request' do
    describe '.new' do
      it 'builds the correct list card tokens request' do
        fawry_request = described_class.new('list_tokens', list_tokens_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::ListTokensRequest)).to be true
        expect(fawry_request.action).to eq('list_tokens')
        expect(fawry_request.request[:path]).to eq('cards/cardToken')
        expect(fawry_request.request[:params].keys).to eq(fawry_list_tokens_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a list card tokens request to fawry' do
        stub_request(:get, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(query: fawry_list_tokens_params)
          .to_return(status: 200, body: list_tokens_response)

        described_class.new('list_tokens', list_tokens_params, {}).fire_list_tokens_request

        expect(WebMock).to have_requested(:get, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(query: fawry_list_tokens_params)
      end
    end
  end

  context 'delete card token request' do
    describe '.new' do
      it 'builds the correct delete card token request' do
        fawry_request = described_class.new('delete_token', delete_token_params, {})
        expect(fawry_request.class.included_modules.include?(Fawry::Requests::DeleteTokenRequest)).to be true
        expect(fawry_request.action).to eq('delete_token')
        expect(fawry_request.request[:path]).to eq('cards/cardToken')
        expect(fawry_request.request[:body].keys).to eq(fawry_delete_token_params.keys)
      end
    end

    describe '#fire' do
      it 'fires a list card tokens request to fawry' do
        stub_request(:delete, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(body: fawry_delete_token_params)
          .to_return(status: 200, body: delete_token_response)

        described_class.new('delete_token', delete_token_params, {}).fire_delete_token_request

        expect(WebMock).to have_requested(:delete, Fawry::Connection::FAWRY_BASE_URL + 'cards/cardToken')
          .with(body: fawry_delete_token_params)
      end
    end
  end
end
