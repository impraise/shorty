Rails.application.routes.draw do
  post '/shorten',         to: 'shorten_url#create'
  get '/:shortcode',       to: 'shorten_url#show',  constraints: { shortcode: /[0-9a-zA-Z_]{4,}/ }
  get '/:shortcode/stats', to: 'shorten_url#stats', constraints: { shortcode: /[0-9a-zA-Z_]{4,}/ }
end
