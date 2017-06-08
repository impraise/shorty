class Shortener
  class UrlMissingError < StandardError; end
  class ShortcodeAlreadyInUse < StandardError; end

  class << self
    def call(url, shortcode)
      validate_url_presence!(url)

      shortcode ||= SecureRandom.urlsafe_base64(4)
      create_shorty(url, shortcode)
      shortcode
    end

    private

    def create_shorty(url, shortcode)
      raise ShortcodeAlreadyInUse if Shorty.exists?(shortcode: shortcode)
      Shorty.create(url: url, shortcode: shortcode, created_at: DateTime.current, redirect_count: 0)
    end

    def validate_url_presence!(url)
      raise UrlMissingError if url.blank?
    end
  end
end
