require 'integration_spec_helper'
require 'shorty/repositories/shorties_repository'

describe Shorty::ShortiesRepository do
  include_context 'MongoDB'

  subject { described_class.new }

  context '#create' do
    context 'when shorty already exists' do
      let(:shorty) do
        Support::Shorties.existing_shorty
      end

      it 'returns false' do
        expect(subject.create(shorty)).to be false
      end
    end

    context 'when shorty does not exist' do
      let(:shorty) do
        Support::Shorties.new_shorty
      end

      it 'returns new shorty' do
        expect(subject.create(shorty)).to eq shorty
      end
    end

    context '#find_and_increment_shortcode' do
      context 'when shorty does not exist' do
        let(:shorty) do
          Support::Shorties.new_shorty
        end
        it 'returns false' do
          expect(subject.find_and_increment_shortcode(shorty.shortcode)). to be false
        end
      end

      context 'when shorty exists' do
        let(:shorty) do
          Support::Shorties.existing_shorty
        end

        it 'returns shorty with access_count incremented' do
          result = subject.find_and_increment_shortcode(shorty.shortcode)

          expect(result.shortcode).to eq shorty.shortcode
          expect(result.access_count).to eq shorty.access_count + 1
        end
      end

      context '#find_by_shortcode' do
        context 'when shorty does not exist' do
          let(:shorty) do
            Support::Shorties.new_shorty
          end
          it 'returns false' do
            expect(subject.find_by_shortcode(shorty.shortcode)). to be false
          end
        end

        context 'when shorty exists' do
          let(:shorty) do
            Support::Shorties.existing_shorty
          end

          it 'returns shorty' do
            result = subject.find_and_increment_shortcode(shorty.shortcode)

            expect(result.shortcode).to eq shorty.shortcode
            expect(result.url).to eq shorty.url
          end
        end
      end
    end
  end
end
