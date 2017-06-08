module ShortyController
  class Stats < ApplicationController
    def self.call(shortcode)
      shorty = Shorty.find_by!(shortcode: shortcode)
      response_body = {startDate: shorty.created_at, lastSeenDate: shorty.last_seen_at, redirectCount: shorty.redirect_count}

      json_response(status: 200, body: response_body.to_json)
    rescue ActiveRecord::RecordNotFound
      json_response(status: 404, body: { error: "The shortcode could not be found in the system" }.to_json)
    end
  end
end
