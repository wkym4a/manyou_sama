class RemoveUserIdFromTasks < ActiveRecord::Migration[5.2]
  def up
    remove_column :tasks, :user_id, :string
  end
  
  def down
    add_column :tasks, :user_id, :string
  end
end
