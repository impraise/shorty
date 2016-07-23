require "scrivener"

module Validators
  class ShortenURL < Scrivener
    attr_accessor :url, :shortcode

    def validate
      assert_present(:url)

      assert_format(:shortcode, /^[0-9a-zA-Z_]{6}$/) unless shortcode.nil?
    end
  end
end
