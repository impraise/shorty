require 'securerandom'
require_relative 'storage'
require_relative 'stats'

module ShortyUrl
  SHORT_CODE_LENGTH = 6

  class << self
    def shortcode(url)
      # TODO: improve algorithm to avoid possible collisions
      shortcode = SecureRandom.hex(SHORT_CODE_LENGTH / 2)
      storage.add(shortcode, url)
      shortcode
    end

    def decode(shortcode)
      decoded(shortcode).url
    end

    def stats(shortcode)
      decoded(shortcode).stats
    end

    private

    def decoded(shortcode)
      storage.find(shortcode)
    end

    def storage
      @storage ||= Storage.new
    end
  end
end
