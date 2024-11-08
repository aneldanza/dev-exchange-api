class CommentSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :commentable_id, :commentable_type, :body

  attribute :user do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end
end
