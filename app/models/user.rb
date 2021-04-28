class User < ApplicationRecord
  # validates :email, uniqueness: true, presence: true
  # validates :password, presence: { require: true }
  # validates :password, confirmation: true
  # validates_confirmation_of :password
  validates :api_key, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: true

  has_secure_password
end


# validates :email, uniqueness: true, presence: true
#   validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
#   validates_confirmation_of :password
  # validates :password, presence: { require: true }
