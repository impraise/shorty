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

    def unprocessable!(message: "Unprocessable Entity", description: "The submitted entity is unprocessable")

      res.status = 422

      format_json({ message: message, description: description })
    end

    def parse_request
      unprocessable!(description: "Wrong Request Content Type") unless json_request?

      JSON.parse(req.body.read)
    end

  end
end
