# frozen_string_literal: true

# == Schema Information
#
# Table name: task_labels
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  label_id   :bigint
#  task_id    :bigint
#
# Indexes
#
#  index_task_labels_on_label_id  (label_id)
#  index_task_labels_on_task_id   (task_id)
#


class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
