# frozen_string_literal: true

describe URLs::Validator do
  let(:short_code) { '______' }

  subject { URLs::Validator }

  describe 'validate_short_code_uniquness!' do
    it 'does not raise exception when short_code is unique' do
      expect do
        subject.validate_short_code_uniquness!(short_code: short_code)
      end.to_not raise_error(CustomErrors::ShortCodeAlreadyInUse)
    end

    it 'raises ShortCodeAlreadyInUse when short_code is not unique' do
      short_code = '123456'
      create(:short_url, short_code: short_code)

      expect do
        subject.validate_short_code_uniquness!(short_code: short_code)
      end.to raise_error(
        CustomErrors::ShortCodeAlreadyInUse,
        'The desired short code is already in use. '\
        'Shortcodes are case-sensitive.'
      )
    end
  end

  describe 'validate_short_code_format!' do
    it 'does not raise exception when short_code format is valid' do
      expect do
        subject.validate_short_code_format!(short_code: short_code)
      end.to_not raise_error(CustomErrors::InvalidShortCodeFormat)
    end

    context 'InvalidShortCodeFormat is raised' do
      it 'when short_code is too short' do
        short_code = '123'
        expect do
          subject.validate_short_code_format!(short_code: short_code)
        end.to raise_error(
          CustomErrors::InvalidShortCodeFormat,
          'The shortcode fails to meet the '\
          'following regexp: ^[0-9a-zA-Z_]{4,}$.'
        )
      end

      it 'when short_code has an invalid character' do
        short_code = '123+56'
        expect do
          subject.validate_short_code_format!(short_code: short_code)
        end.to raise_error(
          CustomErrors::InvalidShortCodeFormat,
          'The shortcode fails to meet the '\
          'following regexp: ^[0-9a-zA-Z_]{4,}$.'
        )
      end
    end
  end
end
