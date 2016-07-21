Rails.application.routes.draw do
  namespace :api, defaults: { :format => :json }  do
    namespace :v1 do
      post :shorten, to: 'shortner#create'
    end
  end
end
