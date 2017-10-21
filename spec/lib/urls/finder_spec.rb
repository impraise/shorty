# frozen_string_literal: true

describe URLs::Finder do
  let(:encoded_short_url) { create(:encoded_short_url) }
  let(:short_url) { create(:short_url) }

  subject { URLs::Finder }

  describe 'find!' do
    it 'does not raise exception when short_url is found' do
      expect do
        subject.find!(short_code: encoded_short_url.short_code)
      end.to_not raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises ActiveRecord::RecordNotFound when short url is not found' do
      short_code = '123456'
      expect do
        subject.find!(short_code: short_code)
      end.to raise_error(
        ActiveRecord::RecordNotFound,
        "The #{short_code} cannot be found in the system"
      )
    end

    context 'raw short codes' do
      it 'does not raise exception when short_url is found' do
        expect do
          subject.find!(short_code: short_url.short_code)
        end.to_not raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end


  describe 'decode_short_code' do
    it 'does not raise exception when short_code is not Base64 decoded' do
      expect do
        subject.decode_short_code!(short_code: short_url.short_code)
      end.to_not raise_error(ArgumentError)
    end
  end
end
