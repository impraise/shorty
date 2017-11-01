require 'hashids'

class Shortcoder
  def self.decode(shortcode)
    if collision = Collision.where(shortcode: shortcode).first
      collision.shorty_id
    else
      hashid.decode(shortcode).first
    end
  end

  def self.encode(id)
    code = self.hashid.encode(id)
    if collision = Collision.where(shortcode: code).first
      shortcode = encode(collision.shorty_id)
      add_to_collisions(shortcode, id)
      shortcode
    else
      code
    end
  end

  def self.hashid
    @@hashid ||= Hashids.new("not too much salt", 6)
  end

  def self.add_to_collisions(shortcode, shorty_id)
    Collision.create(shortcode: shortcode, shorty_id: shorty_id)
  end
end
