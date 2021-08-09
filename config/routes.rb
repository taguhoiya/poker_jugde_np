Rails.application.routes.draw do
  resources :poker
  root to: 'poker#index'
end
