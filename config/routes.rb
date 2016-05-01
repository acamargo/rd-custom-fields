Rails.application.routes.draw do
  resource :sessions, only: [:new, :create, :destroy]
  resources :custom_fields
  resources :contacts, path: '/'
end
