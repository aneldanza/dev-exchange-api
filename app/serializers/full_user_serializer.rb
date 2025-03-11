# app/serializers/full_user_serializer.rb
class FullUserSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :email, :created_at, :updated_at

  has_many :tags, serializer: TagSerializer
  has_many :questions, serializer: QuestionSerializer

  attribute :tags do |object|
    object.tags.map { |tag| TagSerializer.new(tag).serializable_hash[:data][:attributes] }
  end

  attribute :posts_by_tag do |user|
    user.tags.map do |tag|
      {
        tag: tag,
        posts: user.posts.filter { |post| post.tags.include?(tag) }.map { |post| PostSerializer.new(post).serializable_hash[:data][:attributes] },
      }
    end.sort_by { |tag_posts| -tag_posts[:posts].length }
  end

  attribute :description do |object|
    object.description.body.to_trix_html if object.description.present?
  end

  attribute :questions do |object|
    object.questions.map { |question| PostSerializer.new(question).serializable_hash[:data][:attributes] }
  end

  attribute :answers do |object|
    object.answers.map { |answer| PostSerializer.new(answer).serializable_hash[:data][:attributes] }
  end

  attribute :votes do |object|
    object.votes
  end
end
