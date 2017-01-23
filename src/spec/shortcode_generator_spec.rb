require 'spec_helper'

RSpec.describe ShortcodeGenerator do
  context "CHAR_OPTIONS" do
    it 'should have an array of alphanumeric chars' do
      ShortcodeGenerator::CHAR_OPTIONS.each do |option|
        expect(option).to match(/[0-9a-zA-Z_]/)
      end
    end
  end
  context "#random_char" do
    it 'should collect one char from CHAR_OPTIONS' do
      100.times do
        expect(ShortcodeGenerator::CHAR_OPTIONS).to include(ShortcodeGenerator.random_char)
      end
    end
    it 'random char should match expression /[0-9a-zA-Z_]/' do
      100.times do
        expect(ShortcodeGenerator.random_char).to match(/[0-9a-zA-Z_]/)
      end
    end
  end
  context "random_shortcode" do
    it "should have 6 chars" do
      100.times do
        expect(ShortcodeGenerator.random_shortcode.size).to eq(6)
      end
    end
    it 'should match expression /^[0-9a-zA-Z_]{6}$/' do
      100.times do
        expect(ShortcodeGenerator.random_shortcode).to match(/^[0-9a-zA-Z_]{6}$/)
      end
    end
  end
end
