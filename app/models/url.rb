class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :shortcode, type: String, default: -> { generate_random_shortcode }
  field :last_seen_at, type: DateTime
  field :redirect_count, type: Integer, default: 0

  validates :url, presence: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{4,}\z/ }, uniqueness: true

  def visit!
  	self.last_seen_at = Time.zone.now
  	self.inc(redirect_count: 1)
  end

  def generate_random_shortcode
  	possible_characters = [*'0'..'9', *'a'..'z', *'A'..'Z', '_']
  	6.times.map { possible_characters.sample }.join
  end
end