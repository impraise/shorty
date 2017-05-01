require 'acceptance_spec_helper'

describe Shorty::Shorty do
  include Rack::Test::Methods

  include_context 'MongoDB'

  context 'get /:shortcode' do
    before do
      get "/#{shorty.shortcode}"
    end

    context 'and shortcode exists' do
      let(:shorty) { Support::Shorties.existing_shorty }

      it 'returns redirect to url' do
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(shorty.url)
      end
    end
    context 'and shortcode does not exist' do
      let(:shorty) { Support::Shorties.new_shorty }
      let(:shorty_not_found_error) do
        { error: 'The shortcode cannot be found in the system.' }
      end

      it 'returns error' do
        expect(last_response.status).to eq(404)
        expect(MultiJson.load(last_response.body, symbolize_keys: true))
          .to eq(shorty_not_found_error)
      end
    end
  end

  context 'get /:shortcode/stats' do
    let(:shorty) { Support::Shorties.existing_shorty }

    context 'and the shortcode was never accessed' do
      let(:response) do
        {
          startDate: Time.now.iso8601,
          redirectCount: shorty.access_count
        }
      end

      it 'returns shortcode stats without lastSeenDate' do
        get "/#{shorty.shortcode}/stats"

        expect(last_response.status).to eq(200)
        expect(MultiJson.load(last_response.body, symbolize_keys: true))
          .to eq(response)
      end
    end
    context 'and the shortcode has been accessed' do
      let(:response) do
        {
          startDate: Time.now.iso8601,
          lastSeenDate: Time.now.iso8601,
          redirectCount: shorty.access_count + 1
        }
      end

      it 'returns shortcode stats with lastSeenDate' do
        get "/#{shorty.shortcode}"
        get "/#{shorty.shortcode}/stats"

        expect(last_response.status).to eq(200)
        expect(MultiJson.load(last_response.body, symbolize_keys: true))
          .to eq(response)
      end
    end

    context 'and shortcode does not exist' do
      let(:shorty) { Support::Shorties.new_shorty }
      let(:shorty_not_found_error) do
        { error: 'The shortcode cannot be found in the system.' }
      end

      it 'returns error' do
        get "/#{shorty.shortcode}/stats"

        expect(last_response.status).to eq(404)
        expect(MultiJson.load(last_response.body, symbolize_keys: true))
          .to eq(shorty_not_found_error)
      end
    end
  end

  context 'post /shorten' do
    context 'without url' do
      let(:url_not_present_error) do
        { error: 'url is not present' }
      end

      it 'returns error' do
        post '/shorten'

        expect(last_response.status).to eq(400)
        expect(MultiJson.load(last_response.body, symbolize_keys: true))
          .to eq(url_not_present_error)
      end
    end

    context 'with invalid shortcode' do
      before do
        post '/shorten', url: 'url', shortcode: shortcode
      end
      let(:shorty) { Support::Shorties.existing_shorty }
      let(:shortcode) { shorty.shortcode }

      let(:invalid_shortcode_error) do
        { error: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$' }
      end

      context 'because it is too small' do
        let(:shortcode) { 'a2' }

        it 'returns invalid error' do
          expect(last_response.status).to eq(422)
          expect(MultiJson.load(last_response.body, symbolize_keys: true))
            .to eq(invalid_shortcode_error)
        end
      end

      context 'because it contains invalid chars' do
        let(:shortcode) { 'a2ad?' }

        it 'returns invalid error' do
          expect(last_response.status).to eq(422)
          expect(MultiJson.load(last_response.body, symbolize_keys: true))
            .to eq(invalid_shortcode_error)
        end
      end

      context 'because it already exists' do
        let(:existing_shortcode_error) do
          {
            error: 'The desired shortcode is already in use. Shortcodes are case-sensitive.'
          }
        end

        it 'returns existing error' do
          expect(last_response.status).to eq(409)
          expect(MultiJson.load(last_response.body, symbolize_keys: true))
            .to eq(existing_shortcode_error)
        end
      end
    end
  end
end
