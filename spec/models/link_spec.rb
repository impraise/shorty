require 'rails_helper'

RSpec.describe Link, type: :model do
  it 'validates url presence' do
    link = FactoryGirl.build(:link, url: nil)
    expect(link).not_to be_valid
  end

  it 'validates shortcode presence' do
    link = FactoryGirl.build(:link, shortcode: nil)
    expect(link).not_to be_valid
  end

  it 'validates shortcode format' do
    link = FactoryGirl.build(:link, shortcode: 'abra-kadabra')
    expect(link).not_to be_valid
  end

  it 'validates shortcode uniqueness' do
    FactoryGirl.create(:link, shortcode: 'aaaaaa')
    link = FactoryGirl.build(:link, shortcode: 'aaaaaa')
    expect(link).not_to be_valid
  end

  it 'generates valid random shortcode' do
    link = FactoryGirl.build(:link, shortcode: Link.generate_shortcode)
    expect(link).to be_valid
  end
end
