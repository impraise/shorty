module ShortyController
  class Create < ApplicationController
    def self.call(request)
      request.body.rewind
      params = JSON.parse(request.body.read)

      shortcode = Shortener.call(*params.values_at(:url, :shortcode))

      build_response(status: 200, body: {shortcode: shortcode}.to_json, content_type: :json)
    end
  end
end
