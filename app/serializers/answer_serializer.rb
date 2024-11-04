class AnswerSerializer
  include JSONAPI::Serializer

  attributes :id, :body, :created_at, :updated_at, :question_id

  attribute :user do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end
end
