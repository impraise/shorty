class Shortcode < Grape::Validations::Base
  SHORTCODE_REGEX = Shorty.config[:valid_shortcode_regex]

  def validate_param!(attr_name, params)
    raise malformed_error unless @option.match? params[attr_name]
  end

  def malformed_error
    Shorty::Errors::ShortcodeMalformedError
  end
end
