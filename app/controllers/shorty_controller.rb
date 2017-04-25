require 'sinatra/base'
require 'sinatra/json'

# = ShortyController
class ShortyController < Sinatra::Base
  post '/shorten' do
    status 201
    json shortcode: 'ABXy'
  end

  get '/:shortcode' do
    json stub: true
  end

  get '/:shortcode/stats' do
    json stub: true
  end
end
