class PostsController < ApplicationController

  rescue_from Exception do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end

  def index
    @posts = Post.where(published: true).order(created_at: :desc)
    if params[:search].present?      
      @posts = @posts.where("title LIKE ?", "%#{params[:search]}%")
    end
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(update_params)
      render json: @post, status: :ok
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end  

  #add whitelisted params
  private
  def post_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
  
end
