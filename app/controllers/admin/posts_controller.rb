class Admin::PostsController < ApplicationController
  layout 'admin'
  before_filter :check_authentication, :except => [:login, :signin]

  def login
    redirect_to admin_posts_url if current_user
    @user_session = UserSession.new
  end

  def signin
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to admin_posts_url
    else
      render :action => 'login'
    end
  end

  def logout
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to admin_posts_url
  end

  def index
    @posts = Post.order('posts.date DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def search
    @posts = Post.where('title ILIKE ?', "%#{params[:query]}%").paginate(:page => params[:page], :per_page => 10)
    render :action => 'index'
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    get_tags(@post)
  end

  def create
    @post = Post.new(params[:post])
    save_tags(params[:tags], @post)
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to admin_posts_path
    else
      flash.now[:error] = 'The post could not be created'
      render :action => 'new'
    end
  end

  def update
    @post = Post.find(params[:id])
    save_tags(params[:tags], @post)
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to admin_posts_path
    else
      flash.now[:error] = 'The post could not be updated.'
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_path }
      format.js { render(:update) { |page| page.remove dom_id(@post) } }
    end
  end

  private
    def check_authentication
      redirect_to login_admin_posts_url unless current_user
    end
end
