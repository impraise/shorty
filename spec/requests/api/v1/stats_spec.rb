require 'spec_helper'
require 'rails_helper'
require 'support/shared_factories'

RSpec.describe 'Stats', type: :request do
  include_context 'shared factories'

  describe 'GET /api/v1/:shortcode/fetch_stats' do
    context 'when shortcode does not exist' do

      it 'returns 404 response' do
        get "/api/v1/abcdefa/stats"
        expect(JSON.parse(response.body).values.first).to include('shortcode cannot be found')
        expect(response.status).to eq 404
      end
    end

    before { get "/api/v1/#{shortcode}/stats" }
    context 'when shortcode does exists' do

      it "returns stats object" do
        expect(JSON.parse(response.body)).not_to be_empty
      end

      it "returns 200 OK" do
        expect(response.status).to eq 200
      end
    end
  end
end
