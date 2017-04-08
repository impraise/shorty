require 'spec_helper'
require 'rack/test'

describe Api::Shortener do
  include Rack::Test::Methods

  describe 'POST /api/v1/shorten' do
    context 'without url' do
      it 'returns status 400' do
        post '/api/v1/shorten', {}
        expect(last_response.status).to be 400
      end
    end

    context 'with url' do
      let(:url) { 'http://example.com' }

      context 'without shortcode' do
        let(:params) { { url: url } }

        it 'returns status 201' do
          post '/api/v1/shorten', params
          expect(last_response.status).to be 201
        end

        it 'stores the shortcode' do
          post '/api/v1/shorten', params
          expect(ShortcodeModel.find_shortcode(json['shortcode'])).to_not be_nil
        end
      end

      context 'with shortcode' do
        let(:shortcode) { 'example' }
        let(:params) {
          {
            url: url,
            shortcode: shortcode
          }
        }

        it 'returns status 201' do
          post '/api/v1/shorten', params
          expect(last_response.status).to be 201
        end

        it 'returns the same shortcode' do
          post '/api/v1/shorten', params
          expect(json['shortcode']).to eq shortcode
        end

        context 'with wrong shortcode format' do
          before do
            params[:shortcode] = %w(123 12$213 abc!56).sample
          end

          it 'returns status 422' do
            post '/api/v1/shorten', params
            expect(last_response.status).to be 422
          end
        end

        context 'with already created shortcode' do
          before do
            post '/api/v1/shorten', params
          end

          it 'returns status 409' do
            post '/api/v1/shorten', params
            expect(last_response.status).to be 409
          end

          context 'shortcode in upper case' do
            before do
              params[:shortcode] = shortcode.upcase
            end

            it 'returns status 409' do
              post '/api/v1/shorten', params
              expect(last_response.status).to be 409
            end
          end
        end
      end
    end
  end

  describe 'GET /api/v1/:shortcode' do
    context 'without shortcode' do
      it 'returns status 404' do
        get '/api/v1/'
        expect(last_response.status).to be 404
      end
    end

    context 'with shortcode' do
      context 'when is not created' do
        it 'returns status 404' do
          get '/api/v1/example'
          expect(last_response.status).to be 404
        end
      end

      context 'when is created' do
        let(:shortcode) { 'example' }
        let(:url) { 'example.com' }
        before do
          ShortcodeModel.add_shortcode(shortcode, url)
        end

        it 'returns status 304' do
          get "/api/v1/#{shortcode}"
          expect(last_response.status).to be 302
        end

        it 'has the location header set properly' do
          get "/api/v1/#{shortcode}"
          expect(last_response.location).to eq(url)
        end
      end
    end
  end

  describe 'GET /api/v1/:shortcode/stats' do
    context 'when is not created' do
      it 'returns status 404' do
        get '/api/v1/example/stats'
        expect(last_response.status).to be 404
      end
    end

    context 'when is created' do
      let(:shortcode) { 'example' }
      let(:url) { 'example.com' }
      before do
        ShortcodeModel.add_shortcode(shortcode, url)
      end

      it 'returns status 200' do
        get "/api/v1/#{shortcode}/stats"
        expect(last_response.status).to be 200
      end

      it 'returns the stats' do
        get "/api/v1/#{shortcode}/stats"
        expect(json['startDate']).to be_between(1.minute.ago, 1.minute.from_now)
        expect(json['redirectCount']).to eq 0
        expect(json.key? 'lastSeenDate').to be_falsey
      end

      context 'when a redirect was issued' do
        before do
          get "/api/v1/#{shortcode}"
        end

        it 'returns status 200' do
          get "/api/v1/#{shortcode}/stats"
          expect(last_response.status).to be 200
        end

        it 'returns the stats' do
          get "/api/v1/#{shortcode}/stats"
          expect(json['startDate']).to be_between(1.minute.ago, 1.minute.from_now)
          expect(json['redirectCount']).to eq 1
          expect(json['lastSeenDate']).to be_between(1.minute.ago, 1.minute.from_now)
        end
      end
    end
  end
end
