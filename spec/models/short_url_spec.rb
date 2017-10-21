# frozen_string_literal: true

describe ShortUrl, type: :model do
  context 'validation' do
    subject { build :short_url }

    it do
      is_expected.to validate_presence_of(:url)
    end

    it do
      is_expected.to allow_value(Faker::Internet.url).for(:url)
    end

    it do
      is_expected.to_not allow_value('http:\\').for(:url)
    end

    it do
      is_expected.to_not allow_value('1234567').for(:short_code)
    end

    it do
      is_expected.to_not allow_value('123+56').for(:short_code)
    end

    it do
      is_expected.to_not allow_value('1').for(:short_code)
    end

    it do
      is_expected.to validate_presence_of(:short_code)
    end

    it do
      is_expected.to validate_presence_of(:start_date)
    end

    it 'should validate that :last_seen_date cannot be empty/falsy '\
      'when redirect_count is > 0' do

      expect do
        create(:short_url, redirect_count: 1, last_seen_date: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
