class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  rescue_from Exception do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end

  def index
    @posts = Post.where(published: true).includes(:user).order(created_at: :desc)
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
  
  def authenticate_user!
    headers = request.headers
    token_regex = /Bearer (\w+)/    

    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      if Current.user = User.find_by_auth_token(token)user
        @current_user = Current.user
      else
        render json: {error: 'Invalid token'}, status: :unauthorized
      end
    end
  end
end
