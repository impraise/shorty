module Shorty
  module ErrorHandlingHelper
    def handle_api_error(error)
      case error
      when Errors::ShortcodeAlreadyExistsError
        status_code = Error::Codes::SHORTY_SHORTCODE_ALREADY_EXISTS
        message = Error::Messages::SHORTY_SHORTCODE_ALREADY_EXISTS

      when Errors::ShortyNotFoundError
        status_code = Error::Codes::SHORTY_NOT_FOUND
        message = Error::Messages::SHORTY_NOT_FOUND

      when Errors::ShortcodeMalformedError
        status_code = Error::Codes::SHORTY_MALFORMED_SHORTCODE
        message = Error::Messages::SHORTY_MALFORMED_SHORTCODE

      else
        status_code = Error::Codes::SHORTY_DEFAULT_ERROR
        message = Error::Messages::SHORTY_DEFAULT_ERROR
      end

      error!({ error: message }, status_code)
    end
  end
end
