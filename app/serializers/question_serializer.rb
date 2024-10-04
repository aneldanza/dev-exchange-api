# /Users/aneldanza/Desktop/portfolio/dev-exchange-api/app/serializers/question_serializer.rb

class QuestionSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :body, :created_at, :updated_at

  has_many :tags, serializer: TagSerializer

  attribute :tags do |object|
    object.tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end
end
