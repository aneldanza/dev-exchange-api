# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
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

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: "User logged in successfully",
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      },
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ").last
      jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: {
        status: 200,
        message: "User logged out successfully",
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session",
      }, status: :unauthorized
    end
  end
end
