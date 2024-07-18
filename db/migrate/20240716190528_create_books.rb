class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title, null:false
      t.string :isbn, null:false
      t.string :author, null:false
      t.integer :available_copies, null: false, default: 0

      t.timestamps
    end
    add_index :books, :isbn, unique: true 
    add_index :books, :title              
  end
end
