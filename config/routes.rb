Rails.application.routes.draw do
  apipie

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :short_links, only: [:create]
      get '/:shortcode/stats' => 'stats#fetch_stats'
      post 'shorten' => 'short_links#create'
      get 'fetch_short_code/:shortcode' => 'short_links#fetch_short_code'
    end
  end
end
