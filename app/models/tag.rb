class Tag < ApplicationRecord
  include PgSearch::Model

  has_and_belongs_to_many :users
  has_and_belongs_to_many :questions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_validation :downcase_name

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: {
                      prefix: true,
                      normalization: 2,
                    },
                  }

  private

  def downcase_name
    self.name = name.downcase
  end
end
