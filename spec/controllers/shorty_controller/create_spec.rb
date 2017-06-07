require 'spec_helper'
require 'json'

RSpec.describe ShortyController::Create do
  describe '.call' do
    before do
      allow(Shortener).to receive(:call).and_return('sh0rty')
    end

    let(:request_body) { double('body', rewind: nil, read: "{\"url\":\"foo\",\"shortcode\":\"sh0rty\"}") }
    let(:request) { double('request', body: request_body) }
    let(:expected_response) { {shortcode: 'sh0rty'}.to_json }

    subject { described_class.call(request) }

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
end
