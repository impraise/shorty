require 'grape'
require 'redis'

module Api
  class Example < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    content_type :json, 'application/json'
    default_format :json

    resource :urls do
      get :store do
        redis = Redis.new
        redis.set('example', 'hello world')
        { message: 200 }
      end
    end
  end
end
