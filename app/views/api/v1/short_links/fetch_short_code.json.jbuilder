json.ignore_nil!
@short_link ? (json.shortcode @object) : (json.errors @object)
