class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  validates_presence_of :email, :username

  has_and_belongs_to_many :tags
  has_many :questions
  has_rich_text :description

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def generate_jwt
    JWT.encode(
      {
        jti: self.jti,
        sub: id,
        exp: 30.minutes.from_now.to_i,
      },
      Rails.application.credentials.devise_jwt_secret_key!
    )
  end

  def revoke_token
    update!(jti: SecureRandom.uuid)
  end
end
