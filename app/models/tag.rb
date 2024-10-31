class Tag < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :questions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_validation :downcase_name

  private

  def downcase_name
    self.name = name.downcase
  end
end
