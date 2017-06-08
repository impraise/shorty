require 'spec_helper'
require 'json'

RSpec.describe ShortyController::Create do
  describe '.call' do
    let(:request_body) { double('body', rewind: nil, read: "{\"url\":\"foo\",\"shortcode\":\"sh0rty\"}") }
    let(:request) { double('request', body: request_body) }

    subject { described_class.call(request) }

    context 'when Shorty creation is successful' do
      before do
        allow(Shortener).to receive(:call).and_return('sh0rty')
      end

      let(:expected_response) { {shortcode: 'sh0rty'}.to_json }

      it 'returns status 200' do
        expect(subject.status).to eq 200
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected response body' do
        expect(subject.body).to eq expected_response
      end
    end

    context 'when URL is blank' do
      before do
        allow(Shortener).to receive(:call).and_raise(Shortener::UrlMissingError)
      end

      let(:expected_response) { {error: "url is not present"}.to_json }

      it 'returns status 400' do
        expect(subject.status).to eq 400
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected response body' do
        expect(subject.body).to eq expected_response
      end
    end

    context 'when shortcode is already being used' do
      before do
        allow(Shortener).to receive(:call).and_raise(Shortener::ShortcodeAlreadyInUse)
      end

      let(:expected_response) { {error: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}.to_json }

      it 'returns status 409' do
        expect(subject.status).to eq 409
      end

      it 'returns JSON content_type' do
        expect(subject.content_type).to eq :json
      end

      it 'returns the expected response body' do
        expect(subject.body).to eq expected_response
      end
    end
  end
end
