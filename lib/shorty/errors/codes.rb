module Shorty
  module Error
    class Codes
      SHORTY_NOT_FOUND = 404
      SHORTY_SHORTCODE_ALREADY_EXISTS = 409
      SHORTY_MALFORMED_SHORTCODE = 422
      SHORTY_DEFAULT_ERROR = 400
    end

    class Messages
      SHORTY_NOT_FOUND = 'The shortcode cannot be found in the system.'.freeze
      SHORTY_SHORTCODE_ALREADY_EXISTS = 'The desired shortcode is already in use. Shortcodes are case-sensitive.'.freeze
      SHORTY_MALFORMED_SHORTCODE = 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'.freeze
      SHORTY_DEFAULT_ERROR = 'Unknown Error'.freeze
    end
  end
end
