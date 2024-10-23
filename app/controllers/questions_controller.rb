class QuestionsController < ApplicationController
  before_action :authorize_user, only: [:create, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions.map { |question| QuestionSerializer.new(question).serializable_hash[:data][:attributes] }
  end

  def show
    @question = Question.includes(:user, :tags).find(params[:id])
    render json: QuestionSerializer.new(@question, include: [:tags]).serializable_hash[:data][:attributes], status: 200
  end

  def create
    tagsData = params[:question].delete(:tags)
    tags = Tag.where(id: tagsData.map { |tag| tag[:id] })
    @question = Question.new(question_params)
    @question.tags << tags

    if @question.save
      render json: QuestionSerializer.new(@question).serializable_hash[:data][:attributes], status: 201
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question = Question.includes(:tags).find(params[:id])
    if @question.update(question_params)
      render json: QuestionSerializer.new(@question).serializable_hash[:data][:attributes], status: 200
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
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
