# frozen_string_literal: true

describe API::V1::ShortUrl, type: :api do
  let(:short_url) { create :short_url }

  it 'returns 404 when short_url is not found' do
    get 'api/v1/a_short_code'
    expect(last_response.status).to eq(404)
  end

  describe 'when short_url is found' do
    before do
      get "api/v1/#{short_url.short_code}"
    end

    it 'updates the short_url' do
      expect(short_url.reload.redirect_count).to eq(1)
      expect(short_url.reload.last_seen_date).to be_present
    end

    it 'returns 302' do
      expect(last_response.status).to eq(302)
    end

    it 'returns 302' do
      expect(last_response.headers['Location']).to eq(short_url.url)
    end
  end
end
