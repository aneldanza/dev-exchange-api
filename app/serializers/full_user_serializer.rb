# app/serializers/full_user_serializer.rb
class FullUserSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email, :created_at, :updated_at

  has_many :tags, serializer: TagSerializer
end
