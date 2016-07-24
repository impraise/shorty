require 'rails_helper'

describe UrlAddress, type: :model do
  describe 'validations' do
    it 'must have url' do
      expect(subject).to be_invalid
      expect(subject.errors[:url]).to include("can't be blank")
    end

    it 'must validate the URL format' do
      subject.url = 'htt//wrongurl'

      expect(subject).to be_invalid
      expect(subject.errors[:url]).to eq(['is invalid'])
    end

    it 'must validate the shortcode format' do
      subject.shortcode = 'm!5h0rtc0d3'

      expect(subject).to be_invalid
      expect(subject.errors[:shortcode]).to eq(['must have six alphanumeric chars and/or underscore'])
    end

    it 'must have a valid HTTP URL' do
      subject.url = 'http://example.com/'

      expect(subject.errors[:shortcode]).to be_empty
    end

    it 'must have a valid HTTPS URL' do
      subject.url = 'https://example.com/'
      subject.valid?

      expect(subject.errors[:shortcode]).to be_empty
    end

    it 'must have a valid shortcode' do
      subject.shortcode = 'sample'
      subject.valid?

      expect(subject.errors[:shortcode]).to be_empty
    end

    it 'must be valid' do
      subject.shortcode = 'sample'
      subject.url = 'http://example.com/'

      expect(subject).to be_valid
    end
  end

  describe 'shortcode' do
    let(:url) { create(:url_address) }

    it 'must ensure the uniqueness of shortcode' do
      duplicated = build(:url_address, shortcode: url.shortcode)

      expect(duplicated).to be_invalid
      expect(duplicated.errors[:shortcode]).to eq(['the the desired shortcode is already in use'])
    end

    it 'must accept the given shortcode' do
      url_address = create(:url_address, shortcode: 's4mp13')

      expect(url_address.shortcode).to eq('s4mp13')
    end

    context 'not given' do
      it 'must ensure the presence of shortcode' do
        expect(url.shortcode).to match(/\A[0-9a-zA-Z_]{6}\z/)
      end
    end
  end

  describe 'redirect counter' do
    let(:url) { create(:url_address) }

    it 'must increment the redirect counter' do
      expect(url.redirect_count).to eq(0)
      5.times { url.register_access! }
      expect(url.redirect_count).to eq(5)
    end
  end
end
