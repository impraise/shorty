class Shortener
  class UrlMissingError < StandardError; end
  class ShortcodeAlreadyInUse < StandardError; end
  class ShortcodeFormatInvalid < StandardError; end

  class << self
    def call(url, shortcode)
      validate_url_presence!(url)
      validate_shortcode!(shortcode)

      shortcode ||= SecureRandom.urlsafe_base64(4)
      create_shorty(url, shortcode)
      shortcode
    end

    private

    def create_shorty(url, shortcode)
      Shorty.create(url: url, shortcode: shortcode, created_at: DateTime.current, redirect_count: 0)
    end

    def validate_shortcode!(shortcode)
      return if shortcode.blank?
      validate_shortcode_uniqueness!(shortcode)
      validate_shortcode_format!(shortcode)
    end

    def validate_shortcode_format!(shortcode)
      raise ShortcodeFormatInvalid unless shortcode.match(/^[0-9a-zA-Z_]{4,}$/)
    end

    def validate_shortcode_uniqueness!(shortcode)
      raise ShortcodeAlreadyInUse if Shorty.exists?(shortcode: shortcode)
    end

    def validate_url_presence!(url)
      raise UrlMissingError if url.blank?
    end
  end
end
