class Shorty < Sinatra::Application

  before do
    content_type 'application/json'
  end

  post '/shorten' do
    data = JSON.parse(request.body.read) rescue halt(400, json({"error": "Invalid Data"}))
    validate_request(data)

    shortcode = UrlShortcode.new(data)

    if shortcode.save
      status 201
      json({ shortcode: shortcode.shortcode })
    else
      halt 500, json(shortcode.errors)
    end
  end

  get '/:shortcode' do
    shortcode = shortcode_or_404
    shortcode.update_redirect_count

    redirect "http://google.com", 302
  end

  get '/:shortcode/stats' do
    shortcode = shortcode_or_404

    json(shortcode.stats)
  end

  private

  def validate_request(data)
    raise ShortyException::MissingParameterError unless data.key?('url')
    raise ShortyException::FormatException       if data.key?('shortcode') && !(/^[0-9a-zA-Z_]{4,}$/ =~ data["shortcode"])
    raise ShortyException::RecordNotUnique.new() if UrlShortcode.all(shortcode: data["shortcode"]).count > 0
  rescue ShortyException::MissingParameterError
    halt(400, json({"error": "'url' is not present"}))
  rescue ShortyException::FormatException
    halt(422, json({"error": "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$." }))
  rescue ShortyException::RecordNotUnique
    halt(409, json({"error": "The the desired shortcode is already in use. Shortcodes are case-sensitive."}))
  end

  def shortcode_or_404
    UrlShortcode.first(shortcode: params[:shortcode]) || halt(404, json({"error": "The shortcode cannot be found in the system"}))
  end

end
