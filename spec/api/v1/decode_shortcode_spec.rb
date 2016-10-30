require_relative '../api_spec_helper'

describe ShortyUrl::API::V1 do
  include Rack::Test::Methods

  def app
    described_class
  end

  context 'GET /:shortcode' do
    context "shortcode doesn't exist in system" do
      let(:shortcode) { 'abcd12' }
      let(:status) { 404 }
      let(:error) { 'The shortcode cannot be found in the system' }

      before { get shortcode }

      include_examples 'api:error'
    end

    context 'shortcode exists in system' do
      let(:url) { 'www.google.com' }

      before { get ShortyUrl.shortcode(url) }

      it 'returns 302 status' do
        expect(last_response.status).to eq(302)
      end

      it "returns url in header 'Location'" do
        expect(last_response.headers['Location']).to eq url
      end
    end
  end
end
