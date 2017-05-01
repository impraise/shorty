require 'shorty/interactors/find_shorty'
require 'shorty/repositories/shorties_repository'

RSpec.describe Shorty::Interactors::FindShorty do
  subject(:find_shorty) do
    described_class.new(shorties_repository: shorties_repository)
  end

  let(:shorty_as_entity) do
    Support::Shorties.new_shorty
  end

  let(:shortcode) { shorty_as_entity.shortcode }
  let(:access_count) { shorty_as_entity.access_count }
  let(:url) { shorty_as_entity.url }

  let(:shorties_repository) do
    instance_double(Shorty::ShortiesRepository)
  end

  let(:not_found_error) do
    Shorty::Errors::ShortyNotFoundError
  end

  let(:response) do
    subject.call(shortcode: shortcode)
  end

  context '#call' do
    context 'when successfully fetch the shorty' do
      it 'returns the shorty' do
        expect(shorties_repository)
          .to receive(:find_and_increment_shortcode)
          .with(shortcode)
          .and_return(shorty_as_entity)

        expect(response).to eq(shorty_as_entity)
      end
    end

    context 'when the shorty does not exists' do
      it 'returns SHORTY_NOT_FOUND error code' do
        expect(shorties_repository)
          .to receive(:find_and_increment_shortcode)
          .with(shortcode)
          .and_return(false)

        expect { response }.to raise_error not_found_error
      end
    end
  end
end
