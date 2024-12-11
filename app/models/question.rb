class Question < Post
  include PgSearch::Model

  has_many :answers, dependent: :destroy

  validates_uniqueness_of :title
  validate :must_have_tags

  pg_search_scope :search_by_user_and_tag,
                  associated_against: {
                    user: :username,
                    tags: :name,
                  },
                  using: {
                    tsearch: { prefix: true },
                  }

  # pg_search_scope :search_by_title_and_body,
  #                 against: %i[title],
  #                 associated_against: {
  #                   rich_text_body: :body,
  #                 },
  #                 using: {
  #                   tsearch: { prefix: true },
  #                 }

  private

  def must_have_tags
    errors.add(:base, "must have at least one tag") if tags.empty?
  end
end
