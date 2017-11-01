ENVIRONMENT = 'development'
short_code_collisions = Hash.new
require 'pry'

require_relative 'database_setup'
require_relative 'shorty/collision'
require_relative 'shorty/shortcoder'
require_relative 'shorty/shorty'
require_relative 'shorty/shorty_serializer'
require 'sinatra'
require 'sinatra/json'

#TODO extract requires, create environments, refactor code

get '/' do
  "let's do this!!!"
end

before do
  content_type :json
end

helpers do
  def json_params
    begin
      JSON.parse(request.body.read)
    rescue
      halt 400, { message: 'Invalid JSON' }.to_json
    end
  end

  def get_shorty(shortcode)
    shorty_id = Shortcoder.decode(shortcode)
    Shorty[shorty_id]
  end

  def serialize(shorty)
    ShortySerializer.new(shorty).to_json
  end

  def halt_not_found
    halt(404, 'The shortcode cannot be found in the system')
  end
end

get '/:shortcode' do |shortcode|
  shorty = get_shorty(shortcode)
  if shorty.nil?
    halt_not_found
  else
    redirect to(shorty.get_url)
  end
end

get '/:shortcode/stats' do |shortcode|
  shorty = get_shorty(shortcode)
  if shorty.nil?
    halt_not_found
  else
    json serialize(shorty)
  end
end

post '/shorten' do
  shorty = Shorty.new(json_params)
  if shorty.valid?
    shorty.save
    halt 201, { shortcode: shorty.shortcode }.to_json
  else
    errors = shorty.errors
    if errors.key?(:missing_url)
      halt(400, errors[:missing_url].first)
    elsif errors.key?(:duplicated_shortcode)
      halt(409, errors[:duplicated_shortcode].first)
    elsif errors.key?(:invalid_shortcode)
      halt(422, errors[:invalid_shortcode].first)
    elsif errors.key?(:invalid_url)
      halt(400, errors[:invalid_url].first)
    else
      halt(400)
    end
  end
end
