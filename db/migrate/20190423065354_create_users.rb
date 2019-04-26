class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :cd, null: false, limit: 3
      t.string :name, null: false, limit: 20
      t.string :email, null: false, limit: 255
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users , :cd , unique: true
    add_index :users , :email , unique: true
  end
end
