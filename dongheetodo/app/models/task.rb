class Task < ApplicationRecord
  belongs_to :user
  has_many :labels

  enum status: {未着手: 1, 着手中: 2, 完了: 3}
  enum priority: {低: 1, 中: 2, 高: 3}
end
