Rails.application.routes.draw do
  # ERRORS
  match '/404', via: :all, to: 'errors#not_found'
  match '/500', via: :all, to: 'errors#internal_server_error'
  
  # WORKER (Github Cronjob)
  get "/create_new_topic", to: "worker#create_new_topic"
  
  # SIDEKIQ
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # USERS
  devise_for :users
  resources :users, only: [:show] do
    get :submission, on: :member
  end
  
  # PAGES
  get "/about", to: "pages#about"
  root to: 'submissions#index'

  # CONTACTS
  resources :contacts, except: [:edit, :update]

  # SUBMISSIONS
  resources :submissions do
    get :submission, on: :member
  end

  # FILE UPLOADS
  resources :file_uploads, only: [:destroy]

  # TOPICS
  resources :topics, only: [:create]
end
