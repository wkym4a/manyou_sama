class AddIndexToTasks2 < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks , :content , :text , limit: 400
  end
end
