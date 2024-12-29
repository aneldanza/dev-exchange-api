class Post < ApplicationRecord
  belongs_to :user
  belongs_to :question, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_and_belongs_to_many :tags
  has_rich_text :body

  validates :body, presence: true
  validates :title, presence: true, if: :question?

  include PgSearch::Model
  pg_search_scope :search_by_title_and_body,
                  against: :title,
                  associated_against: {
                    rich_text_body: [:body],
                  },
                  using: {
                    tsearch: { prefix: true },
                  }

  pg_search_scope :search_by_user_and_tag,
                  associated_against: {
                    user: :username,
                    tags: :name,
                    rich_text_body: [:body],
                  },
                  using: {
                    tsearch: { prefix: true },
                  }

  def question?
    type == "Question"
  end

  def answer?
    type == "Answer"
  end

  def score
    votes.sum(:value)
  end
end
