class AddStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :integer, null: false, default: 0, after: :end_date
  end
end
