# /Users/aneldanza/Desktop/portfolio/dev-exchange-api/app/serializers/question_serializer.rb

class QuestionSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :created_at, :updated_at

  attribute :body do |object|
    object.body.to_trix_html
  end

  has_many :tags, serializer: TagSerializer
  has_many :answers, serializer: AnswerSerializer

  attribute :answers, if: Proc.new { |record, params| params && params[:detailed] } do |object|
    object.answers.map { |answer| AnswerSerializer.new(answer).serializable_hash[:data][:attributes] }
  end

  attribute :tags do |object|
    object.tags
  end

  attribute :user, if: Proc.new { |record, params| params && params[:detailed] } do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end

  attribute :comments, if: Proc.new { |record, params| params && params[:detailed] } do |object|
    object.comments.map { |comment| CommentSerializer.new(comment).serializable_hash[:data][:attributes] }
  end
end
