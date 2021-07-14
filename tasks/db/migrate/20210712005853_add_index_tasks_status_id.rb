class AddIndexTasksStatusId < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :status_id
    add_index :tasks, :limit_date
    add_index :tasks, :created_at
  end
end
