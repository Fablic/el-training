class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, on: :create, presence: true, length: { in: 8..72 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password, on: :update, presence: true, length: { in: 8..72 }, format: { with: VALID_PASSWORD_REGEX }, allow_blank: true
end
