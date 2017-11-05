Rails.application.routes.draw do
  resources :short_links
  get '/:shortcode' => 'short_links#get_short_code'
  resources :stats
end
