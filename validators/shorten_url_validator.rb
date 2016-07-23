require "scrivener"

module Validators
  class ShortenURL < Scrivener
    attr_accessor :url, :shortcode

    def validate
      assert_present(:url)

      unless shortcode.nil?
        redis = Redis.client
        url   = redis.call "GET", shortcode

        assert_format(:shortcode, /^[0-9a-zA-Z_]{6}$/)
        assert(url.nil?, [:shortcode, :not_unique])
      end
    end
  end
end
