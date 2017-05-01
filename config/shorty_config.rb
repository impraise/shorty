config[:valid_shortcode_regex] = Regexp.new(
  ENV.fetch('VALID_SHORTCODE_REGEX', '^[0-9a-zA-Z_]{4,}$')
)
