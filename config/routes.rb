ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  
  map.with_options :controller => 'main' do |m|
    m.home '', :action => 'index'
    m.paged_home 'index/:page', :action => 'index', :requirements => {:page => /\d+/}, :page => nil
    m.old_rss 'feed/posts', :action => 'old_rss'
    m.post_rss 'feed/posts.:format', :action => 'feed'
    m.date ':year/:month/:day/:title', :action => "by_date",
						:requirements => { :year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/},
						:day => nil, :month => nil, :title => nil
		m.tagged 'posts/tagged-with/:name/:page', :action => 'tagged', :requirements => {:page => /\d+/}, :page => nil
		m.category 'category/:name', :action => 'category'
		m.posts 'posts', :action => 'posts'
		m.feed 'feed', :action => 'old_rss'
  end
  
  map.connect 'manage', :controller => 'manage/posts', :action => 'login'
  
  map.resources :posts,
                :path_prefix => '/manage',
                :name_prefix => 'admin_',
                :controller => 'manage/posts',
                :member => {:comments => :get, :delete_comment => :delete, :approve => :put},
                :collection => {:login => :get, :logout => :get, :signin => :post}

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
