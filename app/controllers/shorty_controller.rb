require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'uri'

# = ShortyController
class ShortyController < Sinatra::Base
  configure do
    set show_exceptions: false
    set dump_errors: false
  end

  post '/shorten' do
    record = Shortcode.create(request_params['url'], request_params['shortcode'])

    status 201
    json shortcode: record.shortcode
  end

  get '/:shortcode' do
    record = Shortcode.find(params[:shortcode])

    record.use

    [302, { 'Location' => record.url }, '']
  end

  get '/:shortcode/stats' do
    record = Shortcode.find(params[:shortcode])

    status 200
    json record.stats
  end

  error JSON::ParserError do
    [400, 'Malformed JSON.']
  end

  error MalformedUrl do
    [400, 'url is malformed.']
  end

  error UndefinedUrl do
    [400, 'url is not present.']
  end

  error DuplicateShortcode do
    [409, 'The desired shortcode is already in use. Shortcodes are case-sensitive.']
  end

  error MalformedShortcode do
    [422, 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.']
  end

  error ShortcodeNotFound do
    [404, 'The shortcode cannot be found in the system.']
  end

  def request_params
    @json_params ||= JSON.parse(request.body.read)
  end
end
