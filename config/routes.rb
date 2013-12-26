Wispper::Application.routes.draw do
  resources :posts
  get "posts/new/:feed_id" => "posts#new", :as => "new_post_for_feed"

  resources :feeds

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end