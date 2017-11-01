require 'spec_helper'

describe Shorty do
  describe 'create' do
    context 'with valid url' do
      context 'without shortcode' do
        it 'creates a shorty' do
          shorty = Shorty.new(url: VALID_URL)

          expect(shorty).to be_valid
        end
      end

      context 'with valid shortcode' do
        it 'creates a shorty' do
          shorty = Shorty.new(url: VALID_URL, shortcode: 'abAB1')

          expect(shorty).to be_valid
        end
      end

      context 'with invalid shortcode' do
        it 'fails to create a shorty' do
          shorty = Shorty.new(url: VALID_URL, shortcode: 'ab__cc')

          expect(shorty).to_not be_valid
        end
      end

      context 'with duplicated shortcode' do
        it 'fails to create a shorty' do
          shorty = Shorty.create(url: VALID_URL, shortcode: 'abAB12')
          shorty_copy = Shorty.new(url: VALID_URL, shortcode: 'abAB12')

          expect(shorty_copy).to_not be_valid
        end
      end
    end

    context 'with invalid url' do
      it 'fails to create a shorty' do
        shorty = Shorty.new(url: INVALID_URL)

        expect(shorty).to_not be_valid
      end
    end
  end

  describe 'get_url' do
    let 'increments redirect count' do
      shorty = Shorty.create(url: VALID_URL)

      expect(shorty.redirect_count).to eq 0

      shorty.get_url

      expect(shorty.redirect_count).to eq 1
    end

    let 'updates last seen date' do
      shorty = Shorty.create(url: VALID_URL)
      initial_time = shorty.last_seen_date

      shorty.get_url

      expect(shorty.last_seen_date).to_not eq initial_time
    end
  end
end
