class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:create, :update, :destroy]
  before_action :set_commentable, only: [:create]

  def show
    render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :ok
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :created, location: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    check_if_user_is_owner(@comment.user_id)

    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    check_if_user_is_owner(@comment.user_id)
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type, :id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = Post.find(comment_params[:commentable_id])
  end
end
