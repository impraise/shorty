require 'spec_helper'

RSpec.describe Shortener do
  describe '.call' do
    context 'when shortcode is nil' do
      before do
        allow(SecureRandom)
          .to receive(:urlsafe_base64)
          .with(4)
          .and_return('fo0b4r')
      end

      it 'generates a shortcode' do
        expect(described_class.call('url', nil)).to eq 'fo0b4r'
      end
    end

    context 'when shortcode is present' do
      it 'returns the given shortcode' do
        expect(described_class.call('url', 'sh0rty')).to eq 'sh0rty'
      end
    end
  end
end
