json.ignore_nil!
@short_link.valid? ? (json.shortcode @object) : (json.errors @object)
