class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include PgSearch::Model

  validates_presence_of :email, :username

  has_and_belongs_to_many :tags
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :votes, dependent: :nullify

  # Scopes to differentiate between questions and answers
  has_many :questions, -> { where(type: "Question") }, class_name: "Post"
  has_many :answers, -> { where(type: "Answer") }, class_name: "Post"

  has_rich_text :description

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  include PgSearch::Model

  pg_search_scope :search_by_name,
                  against: %i[username],
                  using: {
                    tsearch: { prefix: true, any_word: true },
                    trigram: { threshold: 0.1 },
                  }
end
