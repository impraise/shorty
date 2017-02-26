class UrlShortcode

  include DataMapper::Resource

  property :id,             Serial,  key: true
  property :shortcode,      String,  unique: true
  property :url,            String,  required: true
  property :redirect_count, Integer, default: 0
  property :created_at,     DateTime
  property :last_visited_at,DateTime

  validates_uniqueness_of :shortcode
  validates_format_of :shortcode, with: /^[0-9a-zA-Z_]{4,}$/

  before :save do
    self.shortcode ||= UrlShortcodeGenerator.generate_shortcode
  end

  def update_redirect_count
    self.update(redirect_count: self.redirect_count + 1, last_visited_at: DateTime.now)
  end

  def stats
    Hash.new.tap do |h|
      h[:startDate] = self.start_date
      h[:redirectCount] = self.redirect_count
      h[:lastSeenDate] = self.last_visited_date if self.redirect_count > 0
    end
  end

  def start_date
    self.created_at.to_time.utc.iso8601(3)
  end

  def last_visited_date
    self.last_visited_at.to_time.utc.iso8601(3) if self.last_visited_at
  end

end
