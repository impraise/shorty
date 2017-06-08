class Shorty < ActiveRecord::Base
  def update_visit_stats
    update_attributes(last_seen_at: DateTime.current, redirect_count: redirect_count+1)
  end
end
