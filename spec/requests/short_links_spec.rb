require 'rails_helper'

RSpec.describe 'Shorty api', type: :request do

  let!(:short_links) { create_list(:short_link, 10) }
  let(:short_link_id) { short_links.first.id }
  let(:shortcode) { short_links.first.shortcode }


  # test for GET request on /:shortcode
  describe 'GET /:shortcode' do
    before { get "/#{shortcode}" }

    context 'when shortcode exists' do
      it 'returns the shortcode' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['shortcode']).to eq(shortcode)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
