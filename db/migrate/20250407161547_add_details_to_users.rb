class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :phase, :integer, default: 0
    add_index :users, :name
  end
end