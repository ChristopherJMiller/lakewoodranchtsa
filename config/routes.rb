Rails.application.routes.draw do
  #root 'pages#home'

  resources :users, only: [:index, :show, :new, :create, :edit, :update] do
    put '/change_password', to: 'users#change_password'
  end

  get '/verify_email/:token', to: 'users#verify_email'

end
