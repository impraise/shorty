require 'spec_helper'

describe Shorty do
  describe 'encode' do
    context 'code already in collisions' do
      it 'creates code from the id in collisions' do
        shortcode = Shortcoder.hashid.encode(2)
        Collision.create(shortcode: shortcode, shorty_id: 1)
        expected_shortcode = Shortcoder.hashid.encode(1)

        expect(Shortcoder.encode(2)).to eq expected_shortcode
      end
    end
  end
end
