Wispper::Application.routes.draw do
  resources :posts
  get "freeds/:feed_id/posts/new" => "posts#new", :as => "new_post_for_feed"

  resources :feeds, :path => "freeds"

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end