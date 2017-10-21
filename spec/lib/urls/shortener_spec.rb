# frozen_string_literal: true

describe URLs::Shortener do
  let(:params) do
    {
      url: Faker::Internet.url,
      short_code: ''.rjust(6, SecureRandom.base64).gsub(/\+|=|\//, '_')
    }
  end

  subject { URLs::Shortener.new params }

  describe '#shortify!' do
    context 'valid parameters' do
      it 'creates a new ShortUrl' do
        expect { subject.shortify! }.to change { ShortUrl.count }.by 1
      end

      it 'generates a short_code when short_code is nil' do
        params.delete(:short_code)
        short_url = subject.shortify!
        expect(short_url.short_code).to be_present
      end

      it 'justifies the short_code when short_code is less that 6' do
        params[:short_code] = params[:short_code][0, 2]
        short_url = subject.shortify!
        expect(short_url.short_code).to be_present
      end

      describe 'validations' do
        before do
          allow(URLs::Validator)
            .to receive(:validate_short_code_uniquness!)
            .with(short_code: '123456')

          allow(URLs::Validator)
            .to receive(:validate_short_code_format!)
            .with(short_code: '123456')
        end

        it 'ask for short_code uniqueness validation' do
          params[:short_code] = '123456'
          subject.shortify!
          expect(URLs::Validator)
            .to have_received(:validate_short_code_uniquness!)
            .with(short_code: params[:short_code])
        end

        it 'asks for short_code format validation' do
          params[:short_code] = '123456'
          subject.shortify!
          expect(URLs::Validator)
            .to have_received(:validate_short_code_format!)
            .with(short_code: params[:short_code])
        end
      end
    end
  end
end
