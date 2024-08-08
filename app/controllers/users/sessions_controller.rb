# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ActionController::Cookies

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
    authorize_user

    if @current_user
      cookies.delete(:jwt, secure: true, same_site: :none)
      @current_user.revoke_token
      Rails.logger.debug("*** current user is: #{@current_user.jti}")
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
    set_jwt_cookie(current_user)
    Rails.logger.debug("is cookie set on cookies.signed[:jwt] - #{cookies.signed[:jwt].present?}")
    render json: {
      status: {
        code: 200, message: "User logged in successfully",
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      },
    }, status: :ok
  end
end
