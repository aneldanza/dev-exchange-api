class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end

  def create
    @tag = Tag.new(name: params[:name])
    if @tag.save
      render json: TagSerializer.new(@tag).serializable_hash[:data][:attributes]
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def search
    @tags = Tag.where("name ILIKE ?", "%#{params[:name]}%").limit(5)
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end
end
