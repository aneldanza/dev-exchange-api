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
      posts = Post.search_by_title_and_body(params[:query])
    else
      posts = Post.all
    end

    if params[:sort].present? && %w[newest oldest score].include?(params[:sort])
      posts = sort_posts(posts, params[:sort])
    end

    posts = posts.map { |post| PostSerializer.new(post).serializable_hash[:data][:attributes] }

    page_size = params[:limit].present? ? params[:limit].to_i : 1
    page_number = params[:page].present? ? params[:page].to_i : 1

    paginated_posts = Kaminari.paginate_array(posts).page(page_number).per(page_size)

    render json: {
      posts: paginated_posts,
      total_pages: paginated_posts.total_pages,
      current_page: paginated_posts.current_page,
      total_results: posts.count,
      next_page: paginated_posts.next_page,
      prev_page: paginated_posts.prev_page,
      first_page: paginated_posts.first_page?,
      last_page: paginated_posts.last_page?,
    }
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

  def paginate_records(records, page, per_page, name)
    page_number = page ? page.to_i : 1
    page_size = per_page.present? && per_page.to_i > 0 ? per_page.to_i : 10
    paginate_records = Kaminari.paginate_array(records).page(page_number).per(page_size)

    return {
             name => paginate_records,
             total_pages: paginate_records.total_pages,
             current_page: paginate_records.current_page,
             total_results: records.count,
             next_page: paginate_records.next_page,
             prev_page: paginate_records.prev_page,
             first_page: paginate_records.first_page?,
             last_page: paginate_records.last_page?,
           }
  end

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end
end
