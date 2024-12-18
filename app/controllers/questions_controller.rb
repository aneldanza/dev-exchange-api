class QuestionsController < ApplicationController
  before_action :authorize_user, only: [:create, :update, :destroy]

  def index
    questions = Question.all

    page_number = params[:page].present? ? params[:page].to_i : 1
    page_size = params[:limit].present? && params[:limit].to_i > 0 ? params[:limit].to_i : 10

    if params[:sort].present? && %w[newest oldest score].include?(params[:sort])
      questions = sort_posts(questions, params[:sort])
    end

    questions = questions.map { |question| QuestionSerializer.new(question).serializable_hash[:data][:attributes] }

    paginated_questions = Kaminari.paginate_array(questions).page(page_number).per(page_size)

    render json: {
      questions: paginated_questions,
      total_pages: paginated_questions.total_pages,
      current_page: paginated_questions.current_page,
      total_results: questions.count,
      next_page: paginated_questions.next_page,
      prev_page: paginated_questions.prev_page,
      first_page: paginated_questions.first_page?,
      last_page: paginated_questions.last_page?,
    }
  end

  def show
    @question = Question.includes(:user, :tags, :answers, :comments).find(params[:id])
    render json: QuestionSerializer.new(@question, { params: { detailed: true } }).serializable_hash[:data][:attributes], status: 200
  end

  def create
    tagsData = params[:question].delete(:tags)
    tags = tagsData.map do |tag|
      findOrCreateTag(tag)
    end
    @question = Question.new(question_params)
    @question.tags << tags

    if @question.save
      user = User.find(@question.user_id)
      updateRecordTags(user, tags)
      render json: QuestionSerializer.new(@question, { params: { detailed: true } }).serializable_hash[:data][:attributes], status: 201
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question = Question.includes(:tags).find(params[:id])
    tagsData = params[:question].delete(:tags)
    tags = tagsData.map do |tag|
      findOrCreateTag(tag)
    end

    if @question.update(question_params)
      user = User.find(@question.user_id)
      updateRecordTags(user, tags)
      @question.tags = tags
      render json: QuestionSerializer.new(@question, { params: { detailed: true } }).serializable_hash[:data][:attributes], status: 200
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
    params.require(:question).permit(:title, :body, :user_id, :tags, :tag_ids)
  end

  def findOrCreateTag(tag_data)
    if tag_data[:id] == 0
      Tag.create(name: tag_data[:name])
    else
      Tag.find(tag_data[:id])
    end
  end

  def updateRecordTags(record, tags)
    tags.each do |tag|
      record.tags << tag unless record.tags.include?(tag)
    end
  end
end
