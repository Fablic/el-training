class DropTaskLables < ActiveRecord::Migration[6.0]
  def change
    drop_table :task_lables do |t|
      t.references :task, foreign_key: true
      t.string :color
      t.integer :color_group, null: false

      t.timestamps
    end
  end
end
