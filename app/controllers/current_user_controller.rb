class CurrentUserController < ApplicationController
  def index
    if @current_user
      render json: { "user": UserSerializer.new(@current_user).serializable_hash[:data][:attributes] }
    else
      render json: { "user": nil }, status: :ok
    end
  end
end
