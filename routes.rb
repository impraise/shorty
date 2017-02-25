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
    shortcode = UrlShortcode.first(shortcode: params[:shortcode]) || halt(404, json({"error": "The shortcode cannot be found in the system"}))
    shortcode.update_redirect_count

    redirect "http://google.com", 302
  end

  private

  def validate_request(data)
    case request.request_method
    when 'POST'
      status = 400 and raise ShortyException::MissingParameterError.new("'url' is not present") unless data.key?('url')
      status = 422 and raise ShortyException::FormatException.new("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.") if data.key?('shortcode') && !(/^[0-9a-zA-Z_]{4,}$/ =~ data["shortcode"])
      status = 409 and raise ShortyException::RecordNotUnique.new("The the desired shortcode is already in use. Shortcodes are case-sensitive.") if UrlShortcode.all(shortcode: data["shortcode"]).count > 0
    when 'GET'
      "test"
    end
  rescue ShortyException::MissingParameterError, ShortyException::FormatException, ShortyException::RecordNotUnique => e
    halt(status, json({"error": e.message}))
  end

end
