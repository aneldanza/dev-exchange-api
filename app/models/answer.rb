class Answer < Post
  include PgSearch::Model

  belongs_to :question

  def tags
    question.tags
  end
end
