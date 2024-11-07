class Question < ApplicationRecord
  has_rich_text :body
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy

  validates_presence_of :title, :body
  validates_uniqueness_of :title
  validate :must_have_tags

  private

  def must_have_tags
    errors.add(:base, "must have at least one tag") if tags.empty?
  end
end
