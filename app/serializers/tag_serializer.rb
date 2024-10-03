# app/serializers/tag_serializer.rb
class TagSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at
end
