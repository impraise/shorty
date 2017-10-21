# frozen_string_literal: true

describe URLs::Updater do
  let(:short_url) { create(:short_url) }

  subject { URLs::Updater }

  describe 'update!' do
    before do
      subject.update!(short_url: short_url)
    end

    it 'updates the short_url redirect_count' do
      expect(short_url.reload.redirect_count).to eq(1)
    end

    it 'updates the short_url last_seen_date' do
      expect(short_url.reload.last_seen_date).to be_present
    end
  end
end
