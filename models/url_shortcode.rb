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

end
