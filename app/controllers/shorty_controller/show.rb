module ShortyController
  class Show < ApplicationController
    def self.call(shortcode)
      shorty = Shorty.find_by!(shortcode: shortcode)
      shorty.update_visit_stats
      json_response(status: 302,  body: shorty.url)
    rescue ActiveRecord::RecordNotFound
      json_response(status: 404, body: { error: "The shortcode could not be found in the system" }.to_json)
    end
  end
end
