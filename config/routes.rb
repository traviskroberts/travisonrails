Travisonrails::Application.routes.draw do
  match '' => 'main#index', :as => :home
  match 'index(/:page)' => 'main#index', :as => :paged_home, :constraints => { :page => /\d+/ }

  match 'feed/posts.:format' => 'main#feed', :as => :post_rss

  match ':year(/:month(/:day(/:slug)))' => 'main#by_date', :as => :date, :constraints => { :year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/ }
  match 'posts/tagged-with/:name(/:page)' => 'main#tagged', :as => :tagged, :constraints => { :page => /\d+/ }
  match 'category/:name' => 'main#category', :as => :category
  match 'posts' => 'main#posts', :as => :posts
  match 'feed' => 'main#old_rss', :as => :feed

  resources :blog_posts

  namespace :admin do
    match '' => 'posts#login'

    resources :posts do
      collection do
        get :login
        get :logout
        post :signin
        post :search
      end
      member do
        put :approve
      end
    end
  end
end
