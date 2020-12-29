# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :tasks, through: :task_label_relations
end
