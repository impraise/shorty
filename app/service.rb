require 'sinatra'
require 'pry'
require_relative '../app/lib/shorty'

before do
  content_type :json
end

post '/shorten' do
  url = params[:url]
  shortcode = params[:shortcode]

  shorty = Shorty.new(url: url, shortcode: shortcode).save

  status 201
  {shortcode: shorty.shortcode}.to_json
end

get '/:shortcode' do

end

get '/:shortcode/stats' do

end

