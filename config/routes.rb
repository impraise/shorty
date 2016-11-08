Rails.application.routes.draw do
  post '/shorten', to: 'url#shorten'
  get '/:shortcode/stats', to: 'url#stats'
  get '/:shortcode', to: 'url#redirect'
end
