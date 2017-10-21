# frozen_string_literal: true

module URLs
  ##
  # Handles short code validations
  ##
  class Validator
    # Validates short_code uniqueness
    # @return [void]
    # @raise [CustomErrors::ShortCodeAlreadyInUse] Generated short code
    #   is not unique
    def self.validate_short_code_uniquness!(short_code:)
      unique = ShortUrl.where(short_code: short_code).blank?
      return if unique
      raise CustomErrors::ShortCodeAlreadyInUse,
        'The desired short code is already in use. '\
        'Shortcodes are case-sensitive.'
    end

    # Partially validates short_code format
    # @return [void]
    # @raise [CustomErrors::InvalidShortCodeFormat] The desired short code
    #   has an invalid format
    def self.validate_short_code_format!(short_code:)
      return if /^[0-9a-zA-Z_]{4,}$/.match?(short_code)
      raise CustomErrors::InvalidShortCodeFormat,
        'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.'
    end
  end
end
