Wispper::Application.routes.draw do
  # for niçe URL with locale as parameter. locale is not necesary and goes first to en than to de
  scope "(:locale)", locale: /en|de|es/ do
    authenticated :user do
        # Rails 4 users must specify the 'as' option to give it a unique name
        root :to => "feeds#index", :as => "authenticated_root"
      end
    resources :posts
    resources :feeds, :path => "feeds"
    root :to => "home#index"
    get "feeds/:feed_id/posts/new" => "posts#new", :as => "new_post_for_feed"
    devise_for :users, :controllers => {:registrations => "registrations"}
    resources :users
    post "evaluations/:id" => "evaluations#accept_post",  as: "accept_post"
    delete "evaluations/:id" => "evaluations#decline_post",  as: "decline_post"
    put "evaluations/:id" => "evaluations#pass_post",  as: "pass_post"
    get "search/" => "search#show", as: "search"
  end
end