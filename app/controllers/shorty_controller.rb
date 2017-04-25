require 'sinatra/base'

# = ShortyController
class ShortyController < Sinatra::Base
  post '/shorten'

  get '/:shortcode'

  get '/:shortcode/stats'
end
