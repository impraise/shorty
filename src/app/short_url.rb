class ShortUrl
  include DataMapper::Resource
  property :shortcode,String, :key => true
  property :url, String, :required => true
  property :created_at, DateTime
  property :last_redirect_at, DateTime
  property :redirect_count, Integer, default: 0

  validates_uniqueness_of :shortcode
  validates_format_of :shortcode, with:  /^[0-9a-zA-Z_]{4,}$/

  def generate_shortcode!
    begin
      new_shortcode = ShortcodeGenerator.random_shortcode
    end while ShortUrl.get(new_shortcode)
    self.shortcode = new_shortcode
  end

  def increase_redirect_count!
    self.redirect_count = redirect_count + 1
    self.last_redirect_at = DateTime.now
  end
end
