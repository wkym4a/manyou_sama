class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :cd, null: false, limit: 3
      t.string :name, null: false, limit: 20

      t.timestamps
    end

    add_index :tags , :cd , unique: true
  end
end
