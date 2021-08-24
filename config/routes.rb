Rails.application.routes.draw do
  resources :pokers
  root to: 'pokers#index'
  mount API::Root => '/'
end
