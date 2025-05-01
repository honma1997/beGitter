class AddGithubUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :github_username, :string
    add_index :users, :github_username
  end
end
