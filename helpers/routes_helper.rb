require "json"

module ShortyService
  module Helpers
    def format_json(resource)
      res.headers["Content-Type"] = "application/json; charset=UTF-8"
      res.write JSON.dump(resource)

      res.finish
    end

    def json_request?
      !!(req.env["CONTENT_TYPE"] =~ /application\/json/)
    end

    def created!(resource)
      res.status = 201

      format_json(resource)
    end

    def response(status:, body:)
      res.status = status

      format_json(body)
    end

    def unprocessable!(message: "Unprocessable Entity", description: "The submitted entity is unprocessable", errors: {})
      res.status = 422

      format_json({ message: message, description: description, errors: errors })
    end

    def server_error(message: "Internal Server Error", description: "Internal Error")
      res.status = 500

      format_json({ message: message, description: description })
    end

    def parse_request
      unprocessable!(description: "Wrong Request Content Type") unless json_request?

      JSON.parse(req.body.read)
    end

    def error_response!(errors)
      if errors[:url] == [:not_present]
        response(status: 406, body: { description: "URL is not present" })

      elsif errors[:shortcode] == [:not_unique]
        response(status: 409, body: { description: "The the desired shortcode is already in use. Shortcodes are case-sensitive." })

      elsif errors[:shortcode] == [:format]
        unprocessable!(description: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$")

      else
        unprocessable!
      end
    end
  end
end
