require "sinatra/json"

class Routes < Sinatra::Base

  before do
    content_type 'application/json'
  end
  # POST /shorten
  # Content-Type: "application/json"
  post "/shorten" do
    begin
      @short_url = ShortUrlService.shorten(params)
      status 201
      json({ shortcode: @short_url.shortcode })
    rescue ShortenException::UrlPresenceErrorException => e
      halt(400,e.message)
    rescue ShortenException::ShortCodeFormatException => e
      halt(409,e.message)
    rescue ShortenException::ShortcodeAlreadyInUseException => e
      halt(422,e.message)
    end
  end
  # GET /:shortcode
  # Content-Type: "application/json"
  get "/:shortcode" do
    begin
      @short_url = ShortUrlService.get_with_increment(params[:shortcode])
      headers 'Location' => @short_url.url
      body ''
      status 302
    rescue ShortenException::ShortUrlNotFoundException => e
      halt(404, e.message)
    end
  end

  # GET /:shortcode/stats
  # Content-Type: "application/json"
  get "/:shortcode/stats" do
    begin
      @short_url = ShortUrlService.get_as_json(params[:shortcode])
      json(@short_url)
    rescue ShortenException::ShortUrlNotFoundException => e
      halt(404, e.message)
    end
  end
end
