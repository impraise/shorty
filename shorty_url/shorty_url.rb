require 'securerandom'

require_relative 'errors'
require_relative 'storage'
require_relative 'stats'

module ShortyUrl
  SHORT_CODE_LENGTH = 6

  class << self
    def shortcode(url, shortcode = nil)
      # TODO: improve algorithm to avoid possible collisions
      shortcode ||= SecureRandom.hex(SHORT_CODE_LENGTH / 2)

      raise ::ShortyUrl::ShortCodeAlreadyInUseError if storage.find(shortcode)

      storage.add(shortcode, url)
      shortcode
    end

    def decode(shortcode)
      link = decoded(shortcode)
      return unless link

      link.stats.track_redirect!
      link.url
    end

    def stats(shortcode)
      link = decoded(shortcode)
      link && link.stats
    end

    def storage
      @storage ||= Storage.new
    end

    private

    def decoded(shortcode)
      storage.find(shortcode)
    end
  end
end
