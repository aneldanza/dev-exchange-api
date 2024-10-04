class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
  end

  def show
    @user = User.includes(:tags, :questions).find(params[:id])
    # check if current_user is the same as the user being requested
    if current_user && current_user.id == @user.id
      render json: FullUserSerializer.new(@user, include: [:tags]).serializable_hash[:data][:attributes], status: 200
    else
      render json: UserSerializer.new(@user, include: [:tags]).serializable_hash[:data][:attributes], status: 200
    end
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

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :description)
  end
end
