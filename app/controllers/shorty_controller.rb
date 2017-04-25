require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'uri'

# = ShortyController
class ShortyController < Sinatra::Base
  class UndefinedUrl < StandardError; end
  class MalformedUrl < StandardError; end
  class DuplicateShortcode < StandardError; end
  class MalformedShortcode < StandardError; end
  class ShortcodeNotFound < StandardError; end

  configure do
    set show_exceptions: false
    set dump_errors: false
  end

  post '/shorten' do
    storage = InMemoryStorage.instance

    url = request_params['url']

    raise UndefinedUrl unless url
    raise MalformedUrl unless url =~ /^#{URI.regexp}$/

    shortcode = request_params['shortcode']

    if shortcode
      raise DuplicateShortcode if storage.exists? shortcode
      raise MalformedShortcode unless shortcode =~ /^[0-9a-zA-Z_]{4,}$/
    else
      shortcode = 'ABCde9'
    end

    storage.store(shortcode, url)

    status 201
    json shortcode: shortcode
  end

  get '/:shortcode' do
    storage = InMemoryStorage.instance

    shortcode = params[:shortcode]

    record = storage.find(shortcode)

    raise ShortcodeNotFound unless record

    storage.use(shortcode)

    [302, { 'Location' => record[:url] }, '']
  end

  get '/:shortcode/stats' do
    storage = InMemoryStorage.instance

    shortcode = params[:shortcode]

    record = storage.find(shortcode)

    raise ShortcodeNotFound unless record

    status 200
    json record
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
