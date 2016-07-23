require "json"

module ShortyService
  module Helpers
    def format_json(resource)
      res.headers["Content-Type"] = "application/json; charset=UTF-8"
      res.write JSON.dump(resource)
    end
  end
end
