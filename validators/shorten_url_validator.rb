require "scrivener"

module Validators
  class ShortenURL < Scrivener
    attr_accessor :url, :shortcode

    def validate
      assert_present(:url)

      unless shortcode.nil?
        url   = Redis.client.call "GET", shortcode

        assert_format(:shortcode, /^[0-9a-zA-Z_]{6}$/)
        assert(url.nil?, [:shortcode, :not_unique])
      else
        self.shortcode = valid_shortcode
      end
    end

    private

    def valid_shortcode
      loop do
        code = SecureRandom.hex(3)

        return code unless Redis.client.call("GET", code)
      end
    end
  end
end
