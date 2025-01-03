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
    else
      @tags = Tag.left_joins(:posts).group(:id).order("COUNT(posts.id) DESC")
    end

    index
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
