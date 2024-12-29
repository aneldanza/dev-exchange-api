class Answer < Post
  include PgSearch::Model

  belongs_to :question

  # pg_search_scope :search_by_user_and_tag,
  #                 associated_against: {
  #                   user: :username,
  #                   question: [{ tags: :name }],
  #                 },
  #                 using: {
  #                   tsearch: { prefix: true },
  #                 }

  # pg_search_scope :search_by_body,
  #                 associated_against: {
  #                   rich_text_body: :body,
  #                 },
  #                 using: {
  #                   tsearch: { prefix: true },
  #                 }

  def tags
    question.tags
  end
end
