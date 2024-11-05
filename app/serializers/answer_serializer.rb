class AnswerSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :question_id

  attribute :body do |object|
    object.body.to_trix_html
  end

  attribute :user do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end
end
