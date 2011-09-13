class Admin::PostsController < ApplicationController
  layout 'admin'
  before_filter :check_authentication, :except => [:login, :signin]

  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy, :approve]

  def login
    redirect_to admin_posts_path if current_user
    @user_session = UserSession.new
  end

  def signin
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to admin_posts_path
    else
      render :action => 'login'
    end
  end

  def logout
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to admin_posts_path
  end

  def index
    @posts = Post.order('posts.date DESC').paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error getting the list of posts.'
  end

  def search
    @posts = Post.where('title LIKE ?', "%#{params[:query]}%").paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render :action => 'index' }
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error getting the requested post.'
  end

  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
    end
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error creating the post.'
  end

  def edit
    @post = Post.find(params[:id])
    get_tags(@post)
  rescue Exception => ex
    logger.warn('ERROR: ' + ex.message)
    flash.now[:error] = 'There was an error editing the post.  The post could not be found.'
  end

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

  private
    def check_authentication
      redirect_to login_admin_posts_path unless current_user
    end
end
