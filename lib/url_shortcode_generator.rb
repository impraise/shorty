require "securerandom"

class UrlShortcodeGenerator

  def self.generate
    SecureRandom.urlsafe_base64(6)[0..5].tr('=', '0')
  end

end
