# frozen_string_literal: true

module URLs
  ##
  # Finds ShortUrls
  ##
  class Updater
    # @param short_url [ShortUrl]
    # @return [ShortUrl]
    def self.update!(short_url:)
      short_url.redirect_count += 1
      short_url.last_seen_date = Time.current
      short_url.save!
      short_url.reload
    end
  end
end
