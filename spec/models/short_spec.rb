require 'rails_helper'

RSpec.describe Short, type: :model do

  it "validates the presence of url" do
    short = Short.new()
    expect(short.valid?).to be_falsey
    expect(short.errors.messages).to include({:url => ["url is not present"]})
  end

  it "validates uniqueness of shortcode" do
    short1 = Short.create(url: "http://example.com", shortcode: "valid1")
    short2 = Short.new(url: "http://example.com", shortcode: "valid1")
    expect(short2.valid?).to be_falsey
    expect(short2.errors.messages).to include({:shortcode => ["The the desired shortcode is already in use. Shortcodes are case-sensitive."]})
  end

  it "validates format of shortcode" do
    short = Short.new(url: "http://example.com", shortcode: "invalid")
    expect(short.valid?).to be_falsey
    expect(short.errors.messages).to include({:shortcode => ["The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{6}$"]})
  end

  it "generates a shortcode if one is not provided" do
    short = Short.new(url: "http://example.com")
    expect(short.valid?).to be_truthy
    expect(short.shortcode).to be_truthy
  end

  describe "#increment_count!" do
    it "increments the redirect_count by 1" do
      short = Short.create(url: "http://example.com")
      expect(short.redirect_count).to eq(0)
      short.increment_count!
      expect(short.redirect_count).to eq(1)
    end
  end

end
