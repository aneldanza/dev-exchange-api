class Answer < ApplicationRecord
  has_rich_text :body
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true
end
