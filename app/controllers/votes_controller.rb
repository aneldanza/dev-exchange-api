class VotesController < ApplicationController
  before_action :authorize_user, only: [:cast_vote]
  before_action :set_votable, only: [:cast_vote]

  def cast_vote
    if is_owner?
      render json: { errors: ["You can't vote for your own content"] }, status: :forbidden
      return
    end

    @vote = @votable.votes.find_or_initialize_by(user_id: current_user.id)

    if @vote.value == vote_params[:value].to_i
      render json: { errors: ["You have already #{@vote.value === 1 ? "up" : "down"}voted this #{vote_params[:votable_type]}"] }, status: :conflict
      return
    end

    @vote.value = (@vote.value || 0) + vote_params[:value].to_i

    if @vote.save
      render json: { message: "Your vote has been successfully cast.", vote: @vote }, status: :ok
    else
      render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:value, :votable_id, :votable_type)
  end

  def is_owner?
    @votable.user == current_user
  end

  def set_votable
    @votable = Post.find(vote_params[:votable_id])
  end
end
