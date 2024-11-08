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

  attribute :question, if: Proc.new { |record, params| params && params[:detailed] } do |object|
    {
      title: object.question.title,
      body: object.question.body.to_trix_html,
    }
  end

  attribute :comments do |object|
    object.comments.map { |comment| CommentSerializer.new(comment).serializable_hash[:data][:attributes] }
  end
end
