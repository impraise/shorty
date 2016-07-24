Rails.application.routes.draw do
  current_api_routes = -> {
    post :shorten, to: 'shortner#create'

    get '/:shortcode/stats', to: 'shortner#stats'
    get '/:shortcode', to: 'shortner#show'
  }

  namespace :api, defaults: { format: :json }, constraints: { format: 'json' } do
    namespace :v1, &current_api_routes
  end

  scope module: :api,  defaults: { format: :json }, constraints: { format: 'json' } do
    scope module: :v1, &current_api_routes
  end
end
