class Manage::PostsController < ApplicationController
  layout 'admin'
	before_filter :check_authentication, :except => [:login, :signin]
	
	cache_sweeper :site_sweeper, :only => [:create, :update, :destroy, :delete_comment, :approve]
	
	def login
	  redirect_to admin_posts_path unless session[:user].nil?
	end
	
	def signin
    session[:user] = User.authenticate(params[:username],params[:password]).id
    redirect_to admin_posts_path
  rescue Exception => ex
    logger.warn('ERROR' + ex.message)
    flash[:error] = ex.message
    redirect_to :action => 'login'
  end
  
  def logout
    session[:user] = nil
    redirect_to admin_posts_path
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
    render :nothing => true
  end
  
  # GET /posts
  def index
    @posts = Post.paginate(:all, :page => params[:page], :per_page => 10, :order => 'posts.date DESC')
    respond_to do |format|
      format.html # index.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error getting the list of posts.'
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error getting the requested post.'
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error creating the post.'
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    get_tags(@post)
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error editing the post.  The post could not be found.'
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    save_tags(params[:tags], @post)
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to admin_posts_path }
      else
        flash.now[:error] = 'The post could not be created'
        format.html { render :action => 'new' }
      end
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error creating the post.'
    render :action => 'new'
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])
    save_tags(params[:tags], @post)
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to admin_posts_path }
      else
        flash.now[:error] = 'The post could not be updated.'
        format.html { render :action => 'edit' }
      end
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error updating the post.'
    render :action => 'edit'
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_path }
      format.js { render(:update) { |page| page.remove dom_id(@post) } }
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    render :nothing => true
  end
  
  def comments
    @post = Post.find(params[:id])
    @comments = @post.comments unless @post.nil?
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
    flash.now[:error] = 'There was an error getting the comments for that post.'
  end
  
  def delete_comment
    comment = Comment.find(params[:id])
    comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_admin_post_path(comment.post) }
      format.js { render(:update) { |page| page.remove dom_id(comment) } }
    end
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
  end
  
  def approve
    comment = Comment.find(params[:id])
    comment.update_attribute(:approved, 1)
    respond_to do |format|
      format.html { redirect_to comments_admin_post_path(comment.post) }
      format.js { render(:update) { |page| page.replace_html "comment_status_#{comment.id}", 'approved' } }
    end
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
  end
  
  private
  def check_authentication
		redirect_to :action => 'login' unless session[:user]
	end
end
