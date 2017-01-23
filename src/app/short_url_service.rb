class ShortUrlService
  # rescue ShortenException::UrlPresenceErrorException => e
  # rescue ShortenException::ShortCodeFormatException => e
  # rescue ShortenException::ShortcodeAlreadyInUseException => e
  def self.shorten(parameters)
    raise ShortenException::UrlPresenceErrorException.new('url is not present') if parameters[:url].nil? || parameters[:url].empty? #400
    short_url = ShortUrl.new(parameters)
    if parameters[:shortcode]
      raise ShortenException::ShortCodeFormatException.new('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.') unless parameters[:shortcode] =~ /^[0-9a-zA-Z_]{4,}$/ # 422
      if short_url.save
        short_url
      else
        raise ShortenException::ShortcodeAlreadyInUseException.new("The the desired shortcode is already in use. Shortcodes are case-sensitive.")
      end
    else
      short_url.generate_shortcode!
      short_url.save
      short_url
    end
  end
end
