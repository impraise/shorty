# coding: utf-8
require 'sinatra'
require 'json'
require 'pry-byebug'

require_relative 'modules/error_handler'
require_relative 'modules/shorty'

include ErrorHandler

set :bind, '0.0.0.0'
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
  record = Shorty.find(shortcode)
  raise ShortcodeNotFound if record.nil?
  record.update_counter
  redirect record.url
end

post '/shorten' do
  url = params[:url]
  shortcode = params[:shortcode]
  raise URLNotFound if url.nil?
  raise ShortcodePatterError if !shortcode.nil? && !shortcode.match(URL_PATTERN)
  raise ShortcodeAlreadyInUse unless Shorty.find(shortcode).nil?
  record = Shorty.new({url: url, shortcode: shortcode})
  record.save
  status 201
  {shortcode: record.shortcode}.to_json
end

get '/:shortcode/stats' do
  shortcode = params[:shortcode]
  record = Shorty.find(shortcode)
  raise ShortcodeNotFound if record.nil?
  { startDate: record.startDate,
    lastSeenDate: record.lastSeenDate,
    redirectCount: record.redirectCount }.to_json
end
