# app/serializers/tag_serializer.rb
class TagSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at

  attribute :questions do |object|
    object.questions.map { |question| QuestionSerializer.new(question).serializable_hash[:data][:attributes] }
  end
end
