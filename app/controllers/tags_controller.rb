class TagsController < ApplicationController
  def index
    serialized_tags = @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }

    render json: paginate_records(serialized_tags, params[:page], params[:limit], "tags")
  end

  def show
    @tag = Tag.includes(:posts).find(params[:id])
    render json: TagSerializer.new(@tag, { params: { detailed: true } }).serializable_hash[:data][:attributes]
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: TagSerializer.new(@tag).serializable_hash[:data][:attributes]
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def search
    if params[:name].present?
      @tags = Tag.search_by_name(params[:name])
      if params[:sort].present? && %w[popular newest new oldest name].include?(params[:sort])
        @tags = sort_searched_tags(@tags, params[:sort])
      else
        @tags = sort_searched_tags(@tags, "popular")
      end
    else
      @tags = Tag.all
      if params[:sort].present? && %w[popular newest new oldest name].include?(params[:sort])
        @tags = sort_tags(@tags, params[:sort])
      else
        @tags = sort_tags(@tags, "popular")
      end
    end

    index
  end

  private

  def sort_tags(tags, sort)
    case sort
    when "popular"
      tags.left_joins(:posts).group(:id).order("COUNT(posts.id) DESC")
    when "newest", "new"
      tags.order(created_at: :desc)
    when "oldest"
      tags.order(created_at: :asc)
    when "name"
      tags.order(name: :asc)
    end
  end

  def sort_searched_tags(tags, sort)
    case sort
    when "popular"
      tags.joins(:posts).group("tags.id, pg_search_978c2f8941354cf552831b.rank").order("COUNT(posts.id) DESC")
    when "newest", "new"
      tags.reorder(created_at: :desc)
    when "oldest"
      tags.reorder(created_at: :asc)
    when "name"
      tags.reorder(name: :asc)
    end
  end

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
