class PostSerializer
  include JSONAPI::Serializer

  attributes :created_at, :updated_at, :user_id

  attribute :body do |object|
    object.body.to_trix_html
  end

  attribute :id do |object|
    if object.is_a?(Question)
      nil
    elsif object.is_a?(Answer)
      object.id
    end
  end

  attribute :question_id do |object|
    if object.is_a?(Question)
      object.id
    elsif object.is_a?(Answer)
      object.question.id
    end
  end

  attribute :title do |object|
    if object.is_a?(Question)
      object.title
    elsif object.is_a?(Answer)
      object.question.title
    end
  end

  attribute :tags do |object|
    if object.is_a?(Question)
      object.tags
    elsif object.is_a?(Answer)
      object.question.tags
    end
  end

  attribute :answers do |object|
    if object.is_a?(Question)
      object.answers.count
    elsif object.is_a?(Answer)
      nil
    end
  end

  attribute :user do |object|
    {
      username: object.user ? object.user.username : nil,
      id: object.user ? object.user.id : nil,
    }
  end

  attribute :votes do |object|
    object.votes.map(&:value).sum
  end
end