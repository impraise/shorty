json.short_links @short_links do |short_link|
  json.url short_link.url
  json.shortcode short_link.shortcode
end
