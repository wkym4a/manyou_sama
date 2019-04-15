class AddIndexContentToTasks3 < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks , :content , :text , limit: 120
  end
end
