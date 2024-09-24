class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :created_at, :updated_at

  has_many :tags, serializer: TagSerializer

  attribute :tags do |object|
    object.tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end
end
