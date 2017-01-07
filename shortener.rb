require 'grape'

class Shortener < Grape::API
  format :json
  namespace :hello do
    get :world do
      {hello: 'world'}
    end
  end
end
