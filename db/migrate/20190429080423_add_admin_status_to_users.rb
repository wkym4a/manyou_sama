class AddAdminStatusToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :admin_status, :integer , null: false , default: 0
  end
  
  def down
    remove_column :users, :admin_status, :integer
  end

end
