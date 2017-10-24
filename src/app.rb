# coding: utf-8
require 'sinatra'
require 'json'
require 'pry-byebug'
require 'securerandom'
require_relative 'modules/error_handler'
require_relative 'modules/shorty'

include ErrorHandler

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
  record = Shorty.new(url, shortcode, settings.recorded_urls).process
  settings.recorded_urls[record[:shortcode]] = record
  status 201
  {shortcode: record[:shortcode]}.to_json
end

get '/:shortcode/stats' do
  shortcode = params[:shortcode]
  return shortcode_not_found if settings.recorded_urls[shortcode].nil?
  record = settings.recorded_urls[shortcode]
  { startDate: record[:startDate],
    lastSeenDate: record[:startDate],
    redirectCount: record[:redirectCount] }.to_json
end
