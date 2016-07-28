Rails.application.routes.draw do

  post 'shorten', to: 'shorts#create'

  get ':shortcode', to: 'shorts#show'

  get ':shortcode/stats', to: 'shorts#stats'

end
