require 'rails_helper'

describe UrlAddressSerializer do
  let(:url) { create(:url_address) }
  let(:serialized_url) { UrlAddressSerializer.new(url) }
  let(:data) { JSON.parse(serialized_url.to_json, symbolize_names: true) }

  it 'returns the serialized UrlAddress with lastSeenDate' do
    Timecop.freeze do
      url.register_access!

      expect(url.redirect_count).to eq(1)
      expect(data.keys).to eq([:startDate, :lastSeenDate, :redirectCount])
      expect(data[:startDate]).to eq(url.created_at.iso8601(3).to_s)
      expect(data[:lastSeenDate]).to eq(url.updated_at.iso8601(3).to_s)
      expect(data[:redirectCount]).to eq(url.redirect_count)
    end
  end

  it 'returns the serialized UrlAddress' do
    Timecop.freeze do
      expect(data).to_not have_key(:lastSeenDate)
      expect(data.keys).to eq([:startDate, :redirectCount])
      expect(data[:startDate]).to eq(url.created_at.iso8601(3).to_s)
      expect(data[:redirectCount]).to eq(0)
    end
  end
end
