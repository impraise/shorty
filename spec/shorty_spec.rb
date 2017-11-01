require 'spec_helper'

describe Shorty do
  VALID_URL = 'http://testing.shorty'
  INVALID_URL = 'testing.shorty'

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
      #TODO
    end

    let 'updates last seen date' do
      #TODO
    end
  end

  #TODO refactor
end
