# frozen_string_literal: true

RSpec.describe Fawry::FawryCallback do
  before do
    ENV['FAWRY_SECURE_KEY'] = 'fawry_secure_key'
  end

  describe '#parse' do
    it 'wraps fawry server callback into FawryCallback instance' do
      fawry_callback = described_class.new(fawry_callback_params, {}).parse
      expect(fawry_callback.class).to eq(Fawry::FawryCallback)
    end

    it 'adds fawry API response keys as methods on FawryResponse instance' do
      fawry_callback = described_class.new(fawry_callback_params, {}).parse
      expect(fawry_callback.order_status).to eq('NEW')
      expect(fawry_callback.fawry_ref_number).to eq('970177')
    end

    context 'request signature' do
      it 'does not raise error when signature is valid' do
        expect do
          described_class.new(fawry_callback_params, {}).parse
        end.to_not raise_error
      end

      it 'raises InvalidSignatureError if signature cannot be verified' do
        expect do
          described_class.new(fawry_callback_params.merge(messageSignature: 'abc'), {}).parse
        end.to raise_error(Fawry::InvalidSignatureError)
      end
    end
  end
end
