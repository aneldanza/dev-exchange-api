class Answer < ApplicationRecord
  include PgSearch::Model

  has_rich_text :body
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, presence: true

  pg_search_scope :search_by_user_and_tag,
                  associated_against: {
                    user: :username,
                    question: :title,
                    tags: :name,
                  },
                  using: {
                    tsearch: { prefix: true },
                  }

  def score
    votes.sum(:value)
  end

  def tags
    question.tags
  end
end
