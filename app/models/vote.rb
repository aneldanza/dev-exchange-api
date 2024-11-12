class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_type votable_id] }
  validates :value, inclusion: { in: [-1, 1] }
end
