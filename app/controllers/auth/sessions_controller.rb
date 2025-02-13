# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  respond_to :json

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def respond_to_on_destroy
    set_current_user

    if @current_user
      render json: {
        status: 200,
        message: "logged out successfully",
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session.",
      }, status: :unauthorized
    end
  end

  private

  def respond_with(current_user, _opts = {})
    @token = request.env["warden-jwt_auth.token"]
    headers["Authorization"] = @token

    render json: {

      status: 200, message: "User logged in successfully",
      data: {
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
        token: @token,
      },

    }, status: :ok
  end
end
