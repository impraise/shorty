# coding: utf-8
require 'sinatra'
require 'json'
require 'pry-byebug'
require 'securerandom'
require_relative 'modules/error_handler'
require_relative 'modules/shorty'

include ErrorHandler

set :bind, '0.0.0.0'
set :recorded_urls, {}
set :show_exceptions, false

error URLNotFound do
  url_not_found
end

error ShortcodePatterError do
  shortcode_no_match_pattern
end

error ShortcodeAlreadyInUse do
  shortcode_in_use
end

error ShortcodeNotFound do
  shortcode_not_found
end

before do
  content_type :json, charset: 'utf-8'
end

get '/' do
  content_type :html, charset: 'utf-8'
  "<h1>TODO: Write an HTML response with the basic usage</h1>"
end

get '/:shortcode' do
  shortcode = params[:shortcode]
  raise ShortcodeNotFound if settings.recorded_urls[shortcode].nil?
  record = settings.recorded_urls[shortcode]
  record[:lastSeenDate] = Time.now
  record[:redirectCount] += 1
  redirect record[:url]
end

post '/shorten' do
  url = params[:url]
  shortcode = params[:shortcode]
  raise URLNotFound if url.nil?
  raise ShortcodePatterError if !shortcode.nil? && !shortcode.match(URL_PATTERN)
  raise ShortcodeAlreadyInUse unless settings.recorded_urls[shortcode].nil?
  record = Shorty.new(url, shortcode, settings.recorded_urls).process
  settings.recorded_urls[record[:shortcode]] = record
  status 201
  {shortcode: record[:shortcode]}.to_json
end

get '/:shortcode/stats' do
  shortcode = params[:shortcode]
  raise ShortcodeNotFound if settings.recorded_urls[shortcode].nil?
  record = settings.recorded_urls[shortcode]
  { startDate: record[:startDate],
    lastSeenDate: record[:startDate],
    redirectCount: record[:redirectCount] }.to_json
end
