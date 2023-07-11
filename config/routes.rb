Rails.application.routes.draw do
  # ERRORS
  match '/404', via: :all, to: 'errors#not_found'
  match '/500', via: :all, to: 'errors#internal_server_error'
  
  # SIDEKIQ
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # USERS
  devise_for :users
  
  # PAGES
  get "/about", to: "pages#about"
  root to: 'submissions#index'

  # CONTACTS
  resources :contacts, except: [:edit, :update]

  # SUBMISSIONS
  resources :submissions
end
