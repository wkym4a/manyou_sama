class CreateTaskTags < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tags do |t|
      t.references :task, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
