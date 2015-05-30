Travisonrails::Application.routes.draw do
  match '' => 'main#index', :as => :home
  match 'index(/:page)' => 'main#index', :as => :paged_home, :constraints => { :page => /\d+/ }

  match 'feed/posts.:format' => 'main#feed', :as => :post_rss

  # redirects for moving blog
  get "/2013/02/20/shoulda-matcher-model-extras", to: redirect("http://nomethoderror.com/blog/2013/02/20/shoulda-matchers-model-extras/")
  get "/2011/10/02/using-god-gem-to-monitor-mysql", to: redirect("http://nomethoderror.com/blog/2011/10/02/using-god-gem-to-monitor-mysql/")
  get "/2011/09/13/using-wildcard-domains-with-rails", to: redirect("http://nomethoderror.com/blog/2011/09/13/using-wildcard-domains-with-rails/")
  get "/2010/05/25/deploy-sinatra-application-with-capistrano", to: redirect("http://nomethoderror.com/blog/2010/05/25/deploy-a-sinatra-application-with-capistrano/")

  match ':year(/:month(/:day(/:slug)))' => 'main#by_date', :as => :date, :constraints => { :year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/ }
  match 'posts/tagged-with/:name(/:page)' => 'main#tagged', :as => :tagged, :constraints => { :page => /\d+/ }
  match 'category/:name' => 'main#category', :as => :category
  match 'posts' => 'main#posts', :as => :posts
  match 'feed' => 'main#old_rss', :as => :feed

  namespace :admin do
    match '' => 'posts#login'

    resources :posts do
      collection do
        get :login
        get :logout
        post :signin
        post :search
      end
    end
  end
end
