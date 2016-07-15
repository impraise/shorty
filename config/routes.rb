Rails.application.routes.draw do
  scope defaults: { format: :json } do
    post 'shorten', to: 'shorten#create'
    get ':shortcode', to: 'shorten#show'
    get ':shortcode/stats', to: 'shorten#stats'
  end
end
