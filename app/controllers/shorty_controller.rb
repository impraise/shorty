require 'sinatra/base'
require 'sinatra/json'
require 'json'

# = ShortyController
class ShortyController < Sinatra::Base
  class UndefinedUrl < StandardError; end
  class DuplicateShortcode < StandardError; end
  class MalformedShortcode < StandardError; end

  configure do
    set show_exceptions: false
    set dump_errors: false
  end

  post '/shorten' do
    url = request_params['url']

    raise UndefinedUrl unless url

    shortcode = request_params['shortcode']

    if shortcode
      raise MalformedShortcode unless /^[0-9a-zA-Z_]{4,}$/.match shortcode
      # Check if shortcode exists
    else
      shortcode = 'ABCde9'
    end

    status 201
    json shortcode: shortcode
  end

  get '/:shortcode' do
    status 302
    json stub: true
  end

  get '/:shortcode/stats' do
    status 200
    json stub: true
  end

  error JSON::ParserError do
    [400, 'Malformed JSON']
  end

  error UndefinedUrl do
    [400, 'url is not present']
  end

  error DuplicateShortcode do
    [409, 'The desired shortcode is already in use. Shortcodes are case-sensitive.']
  end

  error MalformedShortcode do
    [422, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.']
  end

  def request_params
    @json_params ||= JSON.parse(request.body.read)
  end
end
