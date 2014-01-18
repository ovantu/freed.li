Wispper::Application.routes.draw do
  # for niçe URL with locale as parameter. locale is not necesary and goes first to en than to de
  scope "(:locale)", locale: /en|de|es/ do
    resources :posts
    resources :feeds, :path => "freeds"
    root :to => "home#index"
    get "freeds/:feed_id/posts/new" => "posts#new", :as => "new_post_for_feed"
    devise_for :users, :controllers => {:registrations => "registrations"}
    resources :users
  end
end