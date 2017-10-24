# coding: utf-8
require 'sinatra'
require 'json'
require 'pry-byebug'
require 'securerandom'

URL_PATTERN = /^[0-9a-zA-Z_]{4,}$/

set :bind, '0.0.0.0'
set :recorded_urls, {}

before do
  content_type :json, charset: 'utf-8'
end

get '/' do
  content_type :html, charset: 'utf-8'
  "<h1>TODO: Write an HTML response with the basic usage</h1>"
end

get '/:shortcode' do
  shortcode = params[:shortcode]
  return shortcode_not_found if settings.recorded_urls[shortcode].nil?
  record = settings.recorded_urls[shortcode]
  record[:lastSeenDate] = Time.now
  record[:redirectCount] += 1
  redirect record[:url]
end

post '/shorten' do
  url = params[:url]
  shortcode = params[:shortcode]
  return url_not_present if url.nil?
  return shortcode_no_match_pattern if !shortcode.nil? && !shortcode.match(URL_PATTERN)
  return shortcode_in_use unless settings.recorded_urls[shortcode].nil?
  shortcode ||= generate_shortcode
  settings.recorded_urls[shortcode] = {url: url, startDate: Time.now, lastSeenDate: nil, redirectCount: 0}
  status 201
  {shortcode: shortcode}.to_json
end

get '/:shortcode/stats' do
  shortcode = params[:shortcode]
  return shortcode_not_found if settings.recorded_urls[shortcode].nil?
  record = settings.recorded_urls[shortcode]
  { startDate: record[:startDate],
    lastSeenDate: record[:startDate],
    redirectCount: record[:redirectCount] }.to_json
end

def url_not_present
  status 400
  {message: "'url' is not present"}.to_json
end

def shortcode_no_match_pattern
  status 422
  {message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."}.to_json
end

def shortcode_in_use
  status 409
  {message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}.to_json
end

def shortcode_not_found
  status 404
  {message: "The shortcode cannot be found in the system"}.to_json
end

def generate_shortcode
  shortcode = SecureRandom.hex(5)
  return shortcode if settings.recorded_urls[shortcode].nil?
  generate_shortcode
end
