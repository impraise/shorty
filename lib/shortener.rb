class Shortener
  def self.call(url, shortcode)
    shortcode ||= SecureRandom.urlsafe_base64(4)
  end
end
