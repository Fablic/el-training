class CreateTaskLabelRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :task_label_relationships do |t|
      t.references :task, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
