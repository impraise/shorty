# coding: utf-8
require 'sinatra'
require 'json'
require 'pry-byebug'

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
  redirect settings.recorded_urls[params[:shortcode]]
end

post '/shorten' do
  url = params[:url]
  shortcode = params[:shortcode]
  settings.recorded_urls[shortcode] = url
  {shortcode: shortcode}.to_json
end
