class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_from_record_invalid

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    post = Post.find(params[:id])
    
    render json: post
  end

  def create
    post = Post.create!(post_params)
    if post.valid?
      render json: post, status: :created
    else
      render json: {errors: post.errors.full_messages}, status: :unprocessable_entity
    end
    # render json: post, except: [:title, :content, :category],  status: :created
  end

  def update
    post = Post.find(params[:id])

    post.update!(post_params)
    render json: post, except: [:title, :content, :category], status: :ok
    
  end

  private

  def post_params
    params.permit(:category, :content, :title)
  end

  def rescue_from_record_invalid(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
