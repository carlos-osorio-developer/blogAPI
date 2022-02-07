class PostsController < ApplicationController
  include Secure
  before_action :authenticate_user!, only: [:create, :update]

  rescue_from Exception do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :not_found
  end

  def index
    @posts = Post.where(published: true).includes(:user).order(created_at: :desc)
    if params[:search].present?      
      @posts = PostsSearchService.search(@posts, params[:search])      
    end
    render json: @posts, status: :ok
  end  

  def show    
    @post = Post.find(params[:id])
    if (@post.published || @post.user == Current.user)
      render json: @post, status: :ok
    else
      render json: { error: "You are not authorized to view this post." }, status: :unauthorized      
    end
  end

  def new
    @post = Post.new
  end

  def create       
    @post = Current.user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end

  def update
    @post = Current.user.posts.find(params[:id])
    if @post.update(update_params)
      render json: @post, status: :ok
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end  

  #add whitelisted params
  private
  def post_params
    params.require(:post).permit(:title, :content, :published)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end    
end
