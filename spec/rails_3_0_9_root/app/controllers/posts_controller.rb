class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @posts = current_user.posts
  end

  def show
    @post = current_user.posts.build(params[:post])
  rescue
    redirect_to posts_url
  end

  def new
    @post = current_user.posts.build
    @services = current_user.social_services
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @services = current_user.social_services
  rescue
    redirect_to posts_url
  end

  def create
    @post = current_user.posts.build(params[:post])
    @services = current_user.social_services
    if @post.save
      if params[:services]
        errors = @post.push_to_services(params[:services])
        if errors
          @service_errors = errors
          render :action => "edit" and return
        end
      end
      redirect_to(@post, :notice => 'Post was successfully created.')
    else
      render :action => "new"
    end
  rescue
    redirect_to posts_url
  end

  def update
    @post = current_user.posts.find(params[:id])
    @services = current_user.social_services
    if @post.update_attributes(params[:post])
      if params[:services]
        errors = @post.push_to_services(params[:services])
        if errors
          @service_errors = errors
          render :action => "edit" and return
        end
      end
      redirect_to(@post, :notice => 'Post was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to(posts_url)
  rescue
    redirect_to posts_url
  end
end
