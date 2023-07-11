Rails.application.routes.draw do
  get 'submissions/index'
  get 'submissions/new'
  get 'submissions/show'
  get 'submissions/edit'
  get 'submissions/update'
  get 'submissions/destroy'
  match '/404', via: :all, to: 'errors#not_found'
  match '/500', via: :all, to: 'errors#internal_server_error'
  
  devise_for :users
  
  # PAGES
  get "/about", to: "pages#about"
  root to: 'submissions#index'

  # CONTACTS
  resources :contacts, except: [:edit, :update]

  resources :submissions
end
