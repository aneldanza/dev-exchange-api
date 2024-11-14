class VotesController < ApplicationController
  before_action :authorize_user, only: [:cast_vote]

  def cast_vote
    votable_name = params[:vote][:votable_type]
    @votable = votable_name.constantize.find(params[:vote][:votable_id])

    if is_owner?
      render json: { errors: ["You can't vote for your own content"] }, status: :forbidden
      return
    end

    @vote = @votable.votes.find_or_initialize_by(user_id: current_user.id)

    if @vote.value == params[:vote][:value].to_i
      render json: { errors: ["You have already #{@vote.value === 1 ? "up" : "down"}voted this #{votable_name.downcase}"] }, status: :conflict
      return
    end

    @vote.value = params[:vote][:value]

    if @vote.save
      render json: { message: "Vote successfully cast", vote: @vote }, status: :ok
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
end
