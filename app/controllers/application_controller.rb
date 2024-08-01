class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :skip_session_storage, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end

  def skip_session_storage
    request.session_options[:skip] = true
  end
end
