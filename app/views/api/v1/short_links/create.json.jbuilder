json.ignore_nil!
binding.pry
@short_link.valid? ? (json.shortcode @object) : (json.errors @object)
