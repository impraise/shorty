module ErrorHandler
  def url_not_present
    status 400
    {message: "'url' is not present"}.to_json
  end

  def shortcode_no_match_pattern
    status 422
    {message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."}.to_json
  end

  def shortcode_in_use
    status 409
    {message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}.to_json
  end

  def shortcode_not_found
    status 404
    {message: "The shortcode cannot be found in the system"}.to_json
  end
end
