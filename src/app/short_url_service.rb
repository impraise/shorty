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
  # rescue ShortenException::ShortUrlNotFoundException => e
  def self.get_with_increment(shortcode)
    short_url = ShortUrl.get(shortcode)
    if short_url
      short_url.increase_redirect_count!
      short_url.save
      short_url
    else
      raise ShortenException::ShortUrlNotFoundException.new("The shortcode cannot be found in the system")
    end
  end

  def self.get_as_json(shortcode)
    short_url = ShortUrl.get(shortcode)
    if short_url
      short_url_as_json = {
        startDate: short_url.created_at.to_time.utc.iso8601,
        redirectCount: short_url.redirect_count
      }
      if short_url.redirect_count > 0
        short_url_as_json[:lastSeenDate]= short_url.last_redirect_at.to_time.utc.iso8601
      end
      short_url_as_json
    else
      raise ShortenException::ShortUrlNotFoundException.new("The shortcode cannot be found in the system")
    end

  end

end
