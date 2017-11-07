Rails.application.routes.draw do
  apipie

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :short_links
      post 'shorten' => 'short_links#create'
      resources :stats
      get 'fetch_short_code/:shortcode' => 'short_links#fetch_short_code'
    end
  end
end
