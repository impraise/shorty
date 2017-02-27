require 'spec_helper'
require_relative '../../lib/url_shortcode_generator'

RSpec.describe UrlShortcodeGenerator do

  describe "#generate_shortcode" do
    it "should generate a 6 character securerandom code" do
      expect(UrlShortcodeGenerator.generate_shortcode.size).to eq(6)
    end

    it "should match the given format of ^[0-9a-zA-Z_]{6}$" do
      expect(UrlShortcodeGenerator.generate_shortcode).to match(/^[0-9a-zA-Z_]{6}$/)
    end
  end

end
