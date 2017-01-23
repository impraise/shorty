module ShortenException
  class UrlPresenceErrorException < ArgumentError; end
  class ShortCodeFormatException < Exception; end
  class ShortcodeAlreadyInUseException < Exception; end
  class ShortUrlNotFoundException < Exception; end
end
