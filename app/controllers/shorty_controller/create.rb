module ShortyController
  class Create < ApplicationController
    def self.call(request)
      request.body.rewind
      params = JSON.parse(request.body.read)

      shortcode = Shortener.call(*params.values_at('url', 'shortcode'))

      json_response(status: 200, body: {shortcode: shortcode}.to_json)
    rescue Shortener::UrlMissingError
      json_response(status: 400, body: {error: "url is not present"}.to_json)
    rescue Shortener::ShortcodeAlreadyInUse
      json_response(
        status: 409,
        body: {error: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}.to_json
      )
    rescue Shortener::ShortcodeFormatInvalid
      json_response(
        status: 422,
        body: {error: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$"}.to_json
      )
    end
  end
end
