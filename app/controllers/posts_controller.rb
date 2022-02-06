class PostsController < ApplicationController
  def index
    @posts = Post.where(published: true).order(created_at: :desc)
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end
end
