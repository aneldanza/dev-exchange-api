class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :skip_session_storage, if: :devise_controller?
  before_action :set_current_user

  def set_jwt_cookie(resource)
    token = resource.generate_jwt
    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      # secure: Rails.env.production?, # Only send cookie over HTTPS in production
      secure: true, # use true for same_site none cookie
      expires: 30.minutes.from_now, # Match JWT expiration time
      same_site: :none,
    }
  end

  def set_current_user
    token = cookies.signed[:jwt]

    if token.present?
      begin
        # Decode the JWT token
        decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: "HS256")
        jti = decoded_token.first["jti"]

        # Find the user based on the jti
        @current_user = User.find_by(jti: jti)
      rescue
        Rails.logger.error "JWT decode error: #{e.message}"
      end
    else
      @current_user = nil
    end
  end

  def authorize_user
    Rails.logger.debug("*** inside authorize_user method")

    if !logged_in?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end

    # Extract the JWT token from the cookies
    # token = cookies.signed[:jwt]

    # if token.present?
    #   begin
    #     # Decode the JWT token
    #     decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: "HS256")
    #     jti = decoded_token.first["jti"]

    #     # Find the user based on the jti
    #     @current_user = User.find_by(jti: jti)
    #     Rails.logger.debug("*** curent user in authorize_user is: #{@current_user.jti}")

    #     # Handle case where user is not found
    #     if @current_user.nil?
    #       render json: { error: "Unauthorized" }, status: :unauthorized
    #     end
    #   rescue JWT::DecodeError => e
    #     Rails.logger.error "JWT decode error: #{e.message}"
    #     render json: { error: "Unauthorized" }, status: :unauthorized
    #   end
    # else
    #   render json: { error: "No token provided" }, status: :unauthorized
    # end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end

  def logged_in?
    !!@current_user
  end

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end
end
