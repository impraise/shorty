require 'json'
require 'uri'

# = ShortyController
class ShortyController
  def initialize(request)
    @request = request
  end

  def shorten
    record = Shortcode.create(json_params['url'], json_params['shortcode'])

    response(201, { shortcode: record.shortcode }.to_json)
  end

  def go(shortcode)
    record = Shortcode.find(shortcode)

    record.use

    response(302, '', 'Location' => record.url)
  end

  def stats(shortcode)
    record = Shortcode.find(shortcode)

    response(200, record.stats.to_json)
  end

  def error(error)
    case error
    when JSON::ParserError
      response(400, 'Malformed JSON.')
    when MalformedUrl
      response(400, 'url is malformed.')
    when UndefinedUrl
      response(400, 'url is not present.')
    when DuplicateShortcode
      response(409, 'The desired shortcode is already in use. Shortcodes are case-sensitive.')
    when MalformedShortcode
      response(422, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
    when ShortcodeNotFound
      response(404, 'The shortcode cannot be found in the system.')
    else
      response(500, 'Something went wrong')
    end
  end

  def response(code, message, headers = {})
    headers['Content-Type'] = 'application/json'
    Rack::Response.new(message, code, headers)
  end

  def params
    @request.params
  end

  def json_params
    @json_params ||= JSON.parse(@request.body.read)
  end
end
