class Stat < ApplicationRecord
  belongs_to :short_link

  def update_from_endpoint
    self.redirect_count += 1
    self.last_seen_date = DateTime.now.in_time_zone('UTC').iso8601
    self.save!
  end
end
