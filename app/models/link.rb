class Link < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  one_to_many :clicks

  def validate
    super
    validates_unique :shortcode
    validates_format URI::Parser.new.make_regexp, :url
    validates_format /^[0-9a-zA-Z_]{4,}$/, :shortcode
  end

  def before_validation
    generate_unique_shortcode
    super
  end

  def start_date
    created_at.iso8601
  end

  def last_seen_date
    clicks.last.created_at.iso8601 unless clicks.empty?
  end

  private

  def generate_random_shortcode
    SecureRandom.hex(3)
  end

  def generate_unique_shortcode
    return unless shortcode.nil? || shortcode.empty?
    new_shortcode = generate_random_shortcode

    until Link.where(shortcode: new_shortcode).first.nil? do
      new_shortcode = generate_random_shortcode
    end

    self.shortcode ||= generate_random_shortcode
  end
end
