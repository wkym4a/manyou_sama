class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.bigint :user_id , null: false
      t.string :name , null: false
      t.text :content , null: false
      t.datetime :limit
      t.integer :priority , null: false , default: 2
      t.integer :status , null: false , default: 0

      t.timestamps
    end
  end
end
