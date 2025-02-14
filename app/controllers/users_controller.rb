class UsersController < ApplicationController
  before_action :authorize_user, only: [:update, :destroy]

  def index
    serialized_users = @users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }

    render json: paginate_records(serialized_users, params[:page], params[:limit], "users")
  end

  def show
    @user = User.includes(:tags, :questions).find(params[:id])

    # check if current_user is the same as the user being requested
    render json: FullUserSerializer.new(@user, include: [:tags]).serializable_hash[:data][:attributes], status: 200
  end

  def update
    @user = User.includes(:tags, :questions).find(params[:id])

    check_if_user_is_owner(@user.id)

    @user.update(user_params)
    render json: FullUserSerializer.new(@user).serializable_hash[:data][:attributes], status: 200
  end

  def destroy
    @user = User.find(params[:id])

    check_if_user_is_owner(@user.id)

    @user.destroy
    head :no_content
  end

  def search_posts
    if params[:user_id].present? && params[:tag_name].present?
      user = User.find(params[:user_id])
      tag = Tag.find_by(name: params[:tag_name])
      posts = user.posts.filter { |post| post.tags.include?(tag) }
      if params[:sort].present?
        posts = sort_posts(posts, params[:sort])
      end

      render json: posts.map { |post| PostSerializer.new(post).serializable_hash[:data][:attributes] }
    else
      render json: { error: "User ID and tag name are required" }, status: :bad_request
    end
  end

  def search_users
    if params[:value].present?
      @users = User.search_by_name(params[:value])
    else
      @users = User.all
    end

    index
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :description)
  end
end
