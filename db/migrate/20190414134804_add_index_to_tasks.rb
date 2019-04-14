class AddIndexToTasks < ActiveRecord::Migration[5.2]

  def change
    add_index :tasks , :name , unique: true
    change_column :tasks , :name , :string , limit: 20
    change_column :tasks , :content , :text , limit: 120
  end
end
