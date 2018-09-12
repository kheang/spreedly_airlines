Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'flights#index'

  resources :payment_methods, only: [:create, :index]
  resources :purchases, only: [:new, :create, :index]
end
