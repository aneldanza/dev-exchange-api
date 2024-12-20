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
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end

  def logged_in?
    !!@current_user
  end

  def search_posts
    if params[:query].present?
      questions = Question.search_by_title_and_body(params[:query])
      answers = Answer.search_by_body(params[:query])
    else
      questions = Question.all
      answers = Answer.all
    end

    posts = questions + answers

    if params[:sort].present?
      posts = sort_posts(posts, params[:sort])
    end

    posts = posts.map { |post| serialize_post(post) }

    render json: Kaminari.paginate_array(posts).page(params[:page]).per(5)
  end

  def serialize_post(post)
    if post.is_a?(Answer)
      { type: "answer", post: PostSerializer.new(post).serializable_hash[:data][:attributes] }
    else
      { type: "question", post: PostSerializer.new(post).serializable_hash[:data][:attributes] }
    end
  end

  def sort_posts(posts, sort)
    case sort
    when "newest"
      posts.sort_by(&:created_at).reverse
    when "oldest"
      posts.sort_by(&:created_at)
    when "score"
      posts.sort_by(&:score).reverse
    end
  end

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end
end
