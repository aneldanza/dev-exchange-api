class Question < ApplicationRecord
  include PgSearch::Model

  has_rich_text :body
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates_presence_of :title, :body
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

  pg_search_scope :search_by_title_and_body,
                  against: %i[title body],
                  using: {
                    tsearch: { prefix: true },
                  }

  def score
    votes.sum(:value)
  end

  private

  def must_have_tags
    errors.add(:base, "must have at least one tag") if tags.empty?
  end
end
