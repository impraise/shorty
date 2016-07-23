Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { format: 'json' } do
    namespace :v1 do
      post :shorten, to: 'shortner#create'
      get '/:shortcode/stats', to: 'shortner#stats'
      get '/:shortcode', to: 'shortner#show'
    end
  end
end
