# /Users/aneldanza/Desktop/portfolio/dev-exchange-api/app/serializers/question_serializer.rb

class QuestionSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :created_at, :updated_at

  attribute :body do |object|
    object.body.to_trix_html
  end

  # has_many :tags, serializer: TagSerializer
  # has_many :answers, serializer: AnswerSerializer

  attribute :answers do |object, params|
    if params && params[:detailed]
      object.answers.map { |answer| AnswerSerializer.new(answer).serializable_hash[:data][:attributes] }
    else
      object.answers.count
    end
  end

  attribute :tags do |object|
    object.tags
  end

  attribute :user do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end

  attribute :comments do |object, params|
    if params && params[:detailed]
      object.comments.map { |comment| CommentSerializer.new(comment).serializable_hash[:data][:attributes] }
    else
      object.comments.count
    end
  end

  attribute :votes do |object|
    object.votes.map(&:value).sum
  end
end
