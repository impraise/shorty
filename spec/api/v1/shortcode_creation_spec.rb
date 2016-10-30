require_relative '../api_spec_helper'

describe ShortyUrl::API::V1 do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:url) { 'www.google.com' }
  let(:content_type) { 'application/json' }

  context 'POST shorten' do
    let(:endpoint) { 'shorten' }

    context 'valid parameters' do
      before do
        post endpoint, parameters.to_json, 'CONTENT_TYPE' => content_type
      end

      shared_examples 'shortcode is created' do
        it 'returns status 201' do
          expect(last_response.status).to eq(201)
        end
      end

      context 'desired shortcode parameter is present' do
        let(:desired_shortcode) { 'asdf12' }

        let(:parameters) do
          {
            url: url,
            shortcode: desired_shortcode
          }
        end

        include_examples 'shortcode is created'

        it 'returns shortcode in body, which equals to desired shortcode' do
          expect(JSON.parse(last_response.body)['shortcode']).to eq(desired_shortcode)
        end
      end

      context 'desired shortcode parameter is absent' do
        let(:parameters) { { url: url } }

        include_examples 'shortcode is created'

        it 'returns random shortcode in body' do
          expect(JSON.parse(last_response.body)['shortcode']).to_not be_nil
        end
      end
    end

    context 'invalid parameters' do
      context 'url is absent' do
        let(:status) { 400 }
        let(:error) { 'url is missing' }

        before do
          post endpoint, {}, 'CONTENT_TYPE' => content_type
        end

        include_examples 'api:error'
      end

      context 'desired shortcode is not valid' do
        let(:invalid_desired_shortcode) { '123' }

        let(:parameters) do
          {
            url: url,
            shortcode: invalid_desired_shortcode
          }
        end

        let(:status) { 422 }
        let(:error) { 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$' }

        before do
          post endpoint, parameters.to_json, 'CONTENT_TYPE' => content_type
        end

        include_examples 'api:error'
      end

      context 'desired shortcode is already in use' do
        let(:used_desired_shortcode) { '123asd' }

        let(:parameters) do
          {
            url: url,
            shortcode: used_desired_shortcode
          }
        end

        let(:status) { 409 }
        let(:error) do
          'The the desired shortcode is already in use. Shortcodes are case-sensitive.'
        end

        before do
          ShortyUrl.shortcode('https://www.facebook.com', used_desired_shortcode)
          post endpoint, parameters.to_json, 'CONTENT_TYPE' => content_type
        end

        include_examples 'api:error'
      end
    end
  end
end
