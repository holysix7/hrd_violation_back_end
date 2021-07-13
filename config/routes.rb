Rails.application.routes.draw do
  # devise_for :users
  namespace :v1 do
    resources :auths, only: [:create, :destroy]
    # resources :hrd_violations
    get '/hrd_violations' => 'hrd_violations#index'
    get '/hrd_violation/show' => 'hrd_violations#show_violation'
    post '/hrd_violations' => 'hrd_violations#create'
    put '/hrd_violations' => 'hrd_violations#approve'

    get '/getpenalties' => 'hrd_violations#get_penalties'
    get '/auths/sysaccount' => 'auths#sysaccount'
    get '/auths/sysaccount/show' => 'auths#show_account'

    # HRD ABSENCE
    resources :hrds
  end
  get '/v1/violation/show' => 'v1/hrds#show'
  get '/v1/employee_absence/show' => 'v1/hrds#show'
  put '/v1/employee_absence/approve' => 'v1/hrds#approve'
end
