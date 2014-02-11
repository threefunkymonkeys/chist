Sequel.migration do
  up do
    add_column :users, :github_user,   String, null: true
    add_column :users, :twitter_user,  String, null: true
    add_column :users, :facebook_user, String, null: true
  end

  down do
    remove_column :users, :github_user
    remove_column :users, :twitter_user
    remove_column :users, :facebook_user
  end
end
