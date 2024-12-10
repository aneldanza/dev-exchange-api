class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end

  def show
    @tag = Tag.includes(:questions).find(params[:id])
    render json: TagSerializer.new(@tag).serializable_hash[:data][:attributes]
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
    @tags = Tag.search_by_name(params[:name]).limit(5)
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
