require 'rails_helper'

RSpec.describe Api::V1::ShortnerController do
  include JsonResponse

  describe '#create' do
    context 'URL provided' do
      let(:url) { 'http://example.com' }

      it 'creates a record' do
        expect { post :create, params: { url: url } }.to change(Link, :count).by(1)
      end

      it 'returns the new shortcode' do
        post :create, params: { url: url }

        expect(json_response).to match(shortcode: anything)
      end

      it 'returns 201 status code' do
        post :create, params: { url: url }

        expect(response.status).to eq 201
      end

      it 'returns 400 if the url not valid' do
        post :create, params: { url: 'invalid' }

        expect(response.status).to eq 400
      end
    end

    context 'URL no provided' do
      it 'returns 400 error' do
        post :create, params: {}

        expect(response.status).to eq 400
      end
    end

    context 'shortcode provided' do
      let(:url) { 'http://example.com' }
      let(:code) { 'somecode' }

      it 'assigned to the new record' do
        post :create, params: { url: url, shortcode: 'somecode' }

        expect(Link).to be_exist(code: 'somecode')
      end

      it 'returns 409 error when shortcode not uniq' do
        Link.create!(url: 'http://other.com', code: 'somecode')

        post :create, params: { url: url, shortcode: 'somecode' }

        expect(response.status).to eq 409
      end

      it 'returns 422 error when shortcode not in the proper format' do
        post :create, params: { url: url, shortcode: '!somecode' }

        expect(response.status).to eq 422
      end
    end
  end
end
