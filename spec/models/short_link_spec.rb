require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  describe 'shortlink' do
    let!(:short_link) { create(:short_link) }

    # checks if ShortLink has a 1 to 1 relation with Stat
    it { should have_one(:stat) }

    # checks if url is present
    it { should validate_presence_of(:url)}

    it 'generates valid shortcode' do
      expect(!!(short_link[:shortcode] =~ /\A[0-9a-zA-Z_]{6}\z/i)).to eq true
    end
  end

  describe 'preferential shortcode' do
    it 'checks for valid pref shortcode' do
      short_link = ShortLink.new(url: 'http://example.com', shortcode: '123456')
      expect(short_link.valid_preferential_shortcode?(:shortcode)).to eq true
    end
  end

end
