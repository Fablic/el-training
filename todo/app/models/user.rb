# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: {case_sensitive: false}
end
