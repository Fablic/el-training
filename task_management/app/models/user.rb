# frozen_string_literal: true

# ユーザテーブル
class User < ApplicationRecord
  belongs_to :authority
  has_many :tasks, dependent: :destroy
  has_many :label, dependent: :destroy

  validates :login_id, presence: true, length: { maximum: 12 }, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :authority_id, presence: true

  has_secure_password

  def admin_user?
    login_user_auth = Authority.select(:role).find_by(id: authority_id)
    login_user_auth.role == Settings.authority[:admin]
  end

  def general_user?
    login_user_auth = Authority.select(:role).find_by(id: authority_id)
    login_user_auth.role >= Settings.authority[:general]
  end
end
