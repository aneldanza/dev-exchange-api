class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :destroy]

  # GET /answers
  def index
    @answers = Answer.all.includes(:user, :question, :comments)

    render json: @answers.map { |answer| AnswerSerializer.new(answer).serializable_hash[:data][:attributes] }
  end

  # GET /answers/:id
  def show
    @answer = Answer.includes(:user, :question, :comments).find(params[:id])
    render json: AnswerSerializer.new(@answer, { params: { detailed: true } }).serializable_hash[:data][:attributes], status: :ok
  end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      render json: AnswerSerializer.new(@answer).serializable_hash[:data][:attributes], status: :created, location: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      render json: AnswerSerializer.new(@answer).serializable_hash[:data][:attributes], status: :ok
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_answer
    @answer = Answer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def answer_params
    params.require(:answer).permit(:body, :user_id, :question_id, :id)
  end
end
