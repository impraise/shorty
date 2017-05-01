require 'shorty/interactors/create_shorty'
require 'shorty/interactors/shortcode_generator'
require 'shorty/repositories/shorties_repository'
require 'shorty/errors/error'

RSpec.describe Shorty::Interactors::CreateShorty do
  subject(:create_shorty) do
    described_class.new(
      shorties_repository: shorties_repository,
      shortcode_generator: shortcode_generator
    )
  end

  let(:shorty_as_entity) { Support::Shorties.new_shorty }
  let(:shortcode) { shorty_as_entity.shortcode }
  let(:url) { shorty_as_entity.url }
  let(:shorties_repository) do
    instance_double(Shorty::ShortiesRepository)
  end

  let(:shortcode_generator) do
    instance_double(Shorty::Interactors::ShortcodeGenerator)
  end

  let(:shortcode_conflict_error) do
    Shorty::Errors::ShortcodeAlreadyExistsError
  end

  let(:response) do
    subject.call(url: url, shortcode: shortcode)
  end

  context '#call' do
    context 'when shortcode already exists' do
      it 'returns an error' do
        expect(shorties_repository)
          .to receive(:create)
          .and_return(false)

        expect { response }.to raise_error shortcode_conflict_error
      end
    end

    context 'when shortcode does not exist' do
      it 'returns a shorty' do
        expect(shorties_repository)
          .to receive(:create)
          .and_return(shorty_as_entity)

        expect(response.shortcode).to eq shorty_as_entity.shortcode
        expect(response.url).to eq shorty_as_entity.url
      end
    end

    context 'when shorty is not provided' do
      let(:shortcode) { 'fake_1' }
      let(:response) do
        subject.call(url: url)
      end

      it 'returns a shorty with generated shortcode' do
        expect(shorties_repository)
          .to receive(:create)
          .and_return(shorty_as_entity)

        expect(shortcode_generator)
          .to receive(:call)
          .and_return(shortcode)

        expect(response.shortcode).to eq shortcode
        expect(response.url).to eq shorty_as_entity.url
      end
    end
  end
end
