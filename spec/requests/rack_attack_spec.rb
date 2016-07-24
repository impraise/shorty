require 'rails_helper'

describe 'Rack:Attack', type: :request do
  include Rack::Test::Methods

  let!(:url_address) { create(:url_address, shortcode: 'superman') }
  let(:limit) { 100 }

  context "GET /:shortcode" do
    it 'must have the same status requesting below the limit' do
      Timecop.freeze(Time.now - 15.minutes) do
        limit.times do
          get '/superman', params: {}, headers: { 'REMOTE_ADDR' => '1.2.3.4' }
        end

        expect(last_response.status).to eq(302)
      end
    end

    it 'must change the status requesting above the limit' do
      Timecop.freeze(Time.now - 30.minutes) do
        (limit + 20).times do
          get '/superman', params: {}, headers: { 'REMOTE_ADDR' => '1.2.3.4' }
        end

        expect(last_response.status).to eq(429)
      end
    end
  end
end