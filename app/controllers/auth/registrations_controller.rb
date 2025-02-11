# frozen_string_literal: true

class Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        sign_in(resource_name, resource) # Log in the user after registration

        @token = request.env["warden-jwt_auth.token"]
        headers["Authorization"] = @token

        # pass token to frontend
        render json: {
          data: {
            user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
            token: @token,
          },
          message: "Signed up and logged in successfully",
        }, status: :ok
      else
        expire_data_after_sign_in!
        render json: { message: "Account created. Please log in to activate.", errors: ["Signed up but account not active yet"] }, status: :unprocessable_entity
      end
    else
      clean_up_passwords(resource)
      render json: { message: "Sign up failed", errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
