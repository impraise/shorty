Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :short_links
      resources :stats
      get 'get_short_code/:shortcode' => 'short_links#get_short_code'
    end
  end
end
