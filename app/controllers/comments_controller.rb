class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  def show
    render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :ok
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :created, location: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if !author?(@comment.user_id)
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment).serializable_hash[:data][:attributes], status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if !author?(@comment.user_id)
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type, :id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
