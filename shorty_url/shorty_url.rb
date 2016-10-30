require 'securerandom'

require_relative 'errors'
require_relative 'links_storage'

module ShortyUrl
  SHORT_CODE_LENGTH = 6
  STATS = Struct.new :start_date, :last_seen_date, :redirect_count

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

      @storage.update(
        shortcode,
        redirect_count: link[:redirect_count] + 1,
        last_seen_date: Time.now
      )

      link[:url]
    end

    def stats(shortcode)
      link = decoded(shortcode)
      stats_for(link)
    end

    def storage
      @storage ||= LinksStorage.new
    end

    private

    def decoded(shortcode)
      storage.find(shortcode)
    end

    def stats_for(link)
      return unless link

      STATS.new link[:start_date], link[:last_seen_date], link[:redirect_count]
    end
  end
end
