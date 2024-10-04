class QuestionController < ApplicationController
  before_action :authorize_user, only: [:create, :update, :destroy]

  def index
    @questions = Question.all
    render json: @users.map { |question| QuestionSerializer.new(question).serializable_hash[:data][:attributes] }
  end

  def show
    @question = Question.includes(:tags).find(params[:id])
    render json: QuestionSerializer.new(@question, include: [:tags]).serializable_hash[:data][:attributes], status: 200
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      render json: QuestionSerializer.new(@question).serializable_hash[:data][:attributes], status: 201
    else
      render json: { error: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question = Question.includes(:tags).find(params[:id])
    @question.update(question_params)
    render json: QuestionSerializer.new(@question).serializable_hash[:data][:attributes], status: 200
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :tags)
  end
end
