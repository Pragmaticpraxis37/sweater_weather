class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, password_confirmation: true
  validates :api_key, uniqueness: true, presence: true

  has_secure_password
end
