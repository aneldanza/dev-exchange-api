class TagsController < ApplicationController
  def index
    @tags = Tag.all
    render json: @tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end
end
