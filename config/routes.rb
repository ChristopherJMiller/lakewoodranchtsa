Rails.application.routes.draw do
  root 'pages#home'

  resources :users, only: [:index, :show, :new, :create, :edit, :update] do
    put '/change_password', to: 'users#change_password'
    resources :awards
  end

  resources :sign_up_sheets do
    resources :attendees, only: [:index, :create, :destroy]
  end

  get '/verify_email/:token', to: 'users#verify_email'

  resource :sessions, only: [:create, :destroy]

  resources :events do
    resources :teams do
      resources :team_members, only: [:index, :new, :edit, :create, :update, :destroy]
    end
  end

  resources :announcements

  resources :accountability_logs do
    resources :submissions, only: [:index, :new, :show, :create, :destroy]
  end

  resources :documents

  get '/admin/dashboard', to: 'pages#dashboard'

  get 'log_in', to: 'sessions#new'
  get 'register', to: 'users#new'
  get 'log_out', to: 'sessions#destroy'
end
