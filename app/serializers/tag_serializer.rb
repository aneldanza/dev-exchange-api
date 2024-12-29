# app/serializers/tag_serializer.rb
class TagSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at

  attribute :questions do |object|
    object.posts.map { |post| QuestionSerializer.new(post).serializable_hash[:data][:attributes] }
  end
end
