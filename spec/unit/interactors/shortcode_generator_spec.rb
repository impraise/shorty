require 'shorty/interactors/shortcode_generator'
require 'shorty/repositories/shorties_repository'
require 'shorty/interactors/find_shorty'
require 'support/shorties'

RSpec.describe Shorty::Interactors::ShortcodeGenerator do
  SHORTCODE_REGEX = /^[0-9a-zA-Z_]{6}$/

  subject(:shortcode_generator) do
    described_class.new(
      shorties_repository: shorties_repository,
      random_generator: random_generator
    )
  end

  let(:shorties_repository) do
    instance_double(Shorty::ShortiesRepository)
  end

  let(:random_generator) do
    SecureRandom
  end

  let(:shorty_as_entity) do
    Support::Shorties.new_shorty
  end

  let(:shortcode) do
    subject.call
  end

  context '#call' do
    context 'when no shortcodes exist' do
      it 'returns a valid shortcode' do
        expect(shorties_repository)
          .to receive(:find_by_shortcode)
          .and_return(false)
        expect(random_generator)
          .to receive(:urlsafe_base64)
          .with(4)
          .and_call_original

        expect(shortcode).to match SHORTCODE_REGEX
      end
    end

    context 'when the shortcode exists' do
      let(:existing_code) { shorty_as_entity.shortcode }
      let(:new_code) { 'fake_2' }

      it 'attemps to generate a new shortcode' do
        expect(shorties_repository)
          .to receive(:find_by_shortcode)
          .and_return(shorty_as_entity, false)
        expect(random_generator)
          .to receive(:urlsafe_base64)
          .with(4)
          .and_return(existing_code, new_code)

        expect(shortcode).not_to eq existing_code
        expect(shortcode).to match SHORTCODE_REGEX
      end
    end
  end
end
