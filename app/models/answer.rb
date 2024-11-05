class Answer < ApplicationRecord
  has_rich_text :body
  belongs_to :user
  belongs_to :question

  validates :body, presence: true
end
