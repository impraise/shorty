module Factories
  def create_shortened_url(url: 'http://foo.bar', shortcode: 'foobar')
    ShortenedUrl.create(url: url, shortcode: shortcode, start_date: Time.now.utc)
  end
end