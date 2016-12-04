require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'time'

class Link
  include DataMapper::Resource

  property :shortcode,        String,  :key => true
  property :url,              String,  :required => true, :length => 255
  property :redirects_count,  Integer, :default => 0
  property :created_at,       Time
  property :last_redirect_at, Time

  # Increments the number of redirects counter `redirects_count`
  # and updates the timestamp `last_redirect_at`.
  def seen!()
    self.redirects_count += 1
    self.last_redirect_at = Time.now
  end

  # Returns the representation according to https://github.com/impraise/shorty spec.
  def as_json()
    data = {
      'redirectCount' => self.redirects_count,
      'startDate' => self.created_at.utc.iso8601,
    }

    if self.redirects_count > 0
      data['lastSeenDate'] = self.last_redirect_at.utc.iso8601
    end

    data
  end
end
