# app/serializers/tag_serializer.rb
class TagSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at

  attribute :questions do |object, params|
    if params && params[:detailed]
      object.posts.map { |post| QuestionSerializer.new(post).serializable_hash[:data][:attributes] }
    else
      object.posts.map { |post| { id: post.id } }
    end
  end
end
