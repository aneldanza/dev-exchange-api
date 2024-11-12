class VotesController < ApplicationController
  before_action :authorize_user, only: [:create]

  def create
    @votable = params[:votable_type].constantize.find(params[:votable_id])

    if is_owner?
      render json: { errors: ["You can't vote for your own content"] }, status: :forbidden
      return
    end

    @vote = @votable.votes.new(vote_params)
    @vote.user = current_user
    if @vote.save
      render json: { votable_id: @votable.id, votable_type: @votable.class.to_s, value: @vote.value }, status: :ok
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
