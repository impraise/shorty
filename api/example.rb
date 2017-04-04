require 'grape'
require 'redis'

module Api
  class Example < Grape::API
    format :json
    prefix :api

    resource :urls do
      get :store do
        redis = Redis.new
        redis.set('example', 'hello world')
        200
      end
    end
  end
end
