Wispper::Application.routes.draw do
  resources :posts

  resources :feeds

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end