class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end

  def search
    @tags = Tag.where("name ILIKE ?", "%#{params[:name]}%").limit(5)
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end
end
