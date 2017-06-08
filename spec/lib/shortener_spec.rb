require 'spec_helper'

RSpec.describe Shortener do
  describe '.call' do
    before do
      allow(Shorty)
        .to receive(:create)
        .and_return(double)
      allow(Shorty)
        .to receive(:exists?)
        .and_return(shortcode_exists)
    end

    context 'when shortcode is nil' do
      let(:shortcode_exists) { false }

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
      context 'and it already exists' do
        let(:shortcode_exists) { true }

        it 'raises ShortcodeAlreadyInUse' do
          expect{described_class.call('http://foo.com', 'sh0rty')}
            .to raise_error Shortener::ShortcodeAlreadyInUse
        end
      end

      context 'and it do not exist on database' do
        let(:shortcode_exists) { false }

        it 'returns the given shortcode' do
          expect(described_class.call('url', 'sh0rty')).to eq 'sh0rty'
        end
      end
    end

    context 'when URL is blank' do
      let(:shortcode_exists) { false }
      it 'raises UrlMissingError' do
        expect{described_class.call('', 'sh0rty')}.to raise_error Shortener::UrlMissingError
      end
    end
  end
end
