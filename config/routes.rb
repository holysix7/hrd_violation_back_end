Rails.application.routes.draw do
  # devise_for :users
  namespace :v1 do
    resources :auths, only: [:create, :destroy]
    # resources :hrd_violations
    get '/hrd_violations' => 'hrd_violations#index'
    post '/hrd_violations' => 'hrd_violations#create'
    put '/hrd_violations' => 'hrd_violations#approve'

    get '/getpenalties' => 'hrd_violations#get_penalties'
  end
end
