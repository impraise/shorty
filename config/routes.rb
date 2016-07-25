Rails.application.routes.draw do
  post '/shorten',         to: 'shorten_url#create'
  get '/:shortcode',       to: 'shorten_url#show'
  get '/:shortcode/stats', to: 'shorten_url#stats'
end
