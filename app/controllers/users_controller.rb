class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
  end

  def show
    @user = User.includes(:tags, :questions).find(params[:id])
    # check if current_user is the same as the user being requested
    render json: FullUserSerializer.new(@user, include: [:tags]).serializable_hash[:data][:attributes], status: 200
  end

  def update
    @user = User.includes(:tags, :questions).find(params[:id])
    if current_user && current_user.id == @user.id
      @user.update(user_params)
      render json: FullUserSerializer.new(@user).serializable_hash[:data][:attributes], status: 200
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user && current_user.id == @user.id
      @user.destroy
      head :no_content
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def search_posts
    if params[:user_id].present? && params[:tag_name].present?
      user = User.includes(:answers).find(params[:user_id])
      tag_name = params[:tag_name]

      questions = Question.search_by_user_and_tag("#{user.username} #{tag_name}")
      answers = user.answers.where(question_id: Question.joins(:tags).where(tags: { name: tag_name }).pluck(:id))

      posts = questions + answers

      if params[:sort].present?
        case params[:sort]
        when "newest"
          posts = posts.order(created_at: :desc)
          # answers = answers.order(created_at: :desc)
        when "oldest"
          posts = posts.order(created_at: :asc)
          # answers = answers.order(created_at: :asc)
        when "score"
          posts = posts.sort_by(&:score).reverse
          # answers = answers.sort_by(&:score).reverse
        end
      end

      render json: posts.map { |post| serialize_post(post) }

      # render json: {
      #   questions: questions.map { |question| QuestionSerializer.new(question).serializable_hash[:data][:attributes] },
      #   answers: answers.map { |answer| AnswerSerializer.new(answer).serializable_hash[:data][:attributes] },
      # }
    else
      render json: { error: "User ID and tag name are required" }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :description)
  end

  def serialize_post(post)
    if post.is_a?(Answer)
      { type: "answer", post: PostSerializer.new(post).serializable_hash[:data][:attributes] }
    else
      { type: "question", post: PostSerializer.new(post).serializable_hash[:data][:attributes] }
    end
  end
end
