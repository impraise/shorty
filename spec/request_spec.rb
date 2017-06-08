require 'spec_helper'

RSpec.describe 'API requests' do
  let(:app) { Sinatra::Application }

  describe 'GET /:shortcode' do
    before do
      allow(ShortyController::Show).to receive(:call).with('example').and_return(response)
    end

    let(:response) { double('response', status: status, body: response_body, content_type: :json) }

    context 'when the given shortcode exists' do
      let(:status) { 302 }
      let(:response_body) do
        'http://example.com'
      end

      it 'redirects to http://example.com' do
        get '/example'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to eq 'http://example.com/'
      end
    end

    context 'when shortcode does not exist' do
      let(:status) { 404 }
      let(:response_body) { { error: "The shortcode could not be found in the system" }.to_json }
      it 'returns successful status' do
        get '/example'
        expect(last_response).to be_not_found
      end

      it 'returns the expected response' do
        get '/example'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        get '/example'
        expect(last_response.content_type).to eq "application/json"
      end
    end
  end

  describe 'GET /:shortcode/stats' do
    before do
      allow(ShortyController::Stats).to receive(:call).with('example').and_return(response)
    end

    let(:response) { double('response', status: status, body: response_body, content_type: :json) }

    context 'when the given shortcode exists' do
      let(:status) { 200 }
      let(:response_body) do
        {
          startDate:  DateTime.yesterday,
          lastSeenDate: DateTime.current,
          redirectCount: 2
        }.to_json
      end

      it 'returns successful status' do
        get '/example/stats'
        expect(last_response).to be_ok
      end

      it 'returns the expected response' do
        get '/example/stats'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        get '/example/stats'
        expect(last_response.content_type).to eq "application/json"
      end
    end

    context 'when shortcode does not exist' do
      let(:status) { 404 }
      let(:response_body) { { error: "The shortcode could not be found in the system" }.to_json }
      it 'returns successful status' do
        get '/example/stats'
        expect(last_response).to be_not_found
      end

      it 'returns the expected response' do
        get '/example/stats'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        get '/example/stats'
        expect(last_response.content_type).to eq "application/json"
      end
    end
  end

  describe 'POST /shorten' do
    let(:response) { double('response', status: status, body: response_body, content_type: :json) }

    before do
      allow(ShortyController::Create).to receive(:call).and_return(response)
    end

    context 'when params are valid' do
      let(:status) { 200 }
      let(:response_body) do
        {
          shortcode: 'example',
        }.to_json
      end

      it 'returns successful status' do
        post '/shorten'
        expect(last_response).to be_ok
      end

      it 'returns the expected response' do
        post '/shorten'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        post '/shorten'
        expect(last_response.content_type).to eq "application/json"
      end
    end

    context 'when url is blank' do
      let(:status) { 400 }
      let(:response_body) do
        {error: "url is not present"}.to_json
      end

      it 'returns successful status' do
        post '/shorten'
        expect(last_response).to be_bad_request
      end

      it 'returns the expected response' do
        post '/shorten'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        post '/shorten'
        expect(last_response.content_type).to eq "application/json"
      end
    end

    context 'when url shortcode is already being used' do
      let(:status) { 409 }
      let(:response_body) do
        {error: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}.to_json
      end

      it 'returns successful status' do
        post '/shorten'
        expect(last_response.status).to eq 409
      end

      it 'returns the expected response' do
        post '/shorten'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        post '/shorten'
        expect(last_response.content_type).to eq "application/json"
      end
    end

    context 'when url shortcode format is invalid' do
      let(:status) { 422 }
      let(:response_body) do
        {error: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$"}.to_json
      end

      it 'returns successful status' do
        post '/shorten'
        expect(last_response).to be_unprocessable
      end

      it 'returns the expected response' do
        post '/shorten'
        expect(last_response.body).to eq response_body
      end

      it 'responds as JSON content_type' do
        post '/shorten'
        expect(last_response.content_type).to eq "application/json"
      end
    end
  end
end
