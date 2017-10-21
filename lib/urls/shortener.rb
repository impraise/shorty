# frozen_string_literal: true

module URLs
  ##
  # Responsible for handling the creation and genration of short urls
  # @attr params [Hash] Contains attributes for creating short urls
  #   @option url [String] The url to be shortened
  #   @option short_code [String] The short_code to use for shorting the [see url].
  #     short_code can be nil.
  ##
  class Shortener
    def initialize(params)
      @params = params
    end

    # @return [ShortUrl]
    def shortify!
      generate_short_code
      validate!
      ShortUrl.create!(
        @params.merge(start_date: Time.current)
      )
    end

    private

    # Generates short code from
    #   {file:config/initializers/constants/short_code_regex.rb} pattern
    #   and appends a string in the proper format to it.
    # @note A short code consisting of `_' (underscores) is accepted
    def generate_short_code
      @params[:short_code] =
        @params[:short_code].to_s.rjust(
          6,
          SecureRandom.base64.gsub(/\+|=|\//, '_')
        )
    end

    # Calls Validator's validate_short_code_uniquness and
    #   validate_short_code_format to handle the validations
    #   of short codes
    # @see Validator#validate_short_code_uniquness
    # @see Validator#validate_short_code_format
    def validate!
      Validator.validate_short_code_uniquness!(
        short_code: @params[:short_code]
      )

      Validator.validate_short_code_format!(
        short_code: @params[:short_code]
      )
    end
  end
end
