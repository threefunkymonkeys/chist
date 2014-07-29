Sequel.migration do
  up do
    add_column :users, :github_user,   String, null: true
    add_column :users, :twitter_user,  String, null: true
    add_column :users, :facebook_user, String, null: true
  end

  down do
    drop_column :users, :github_user
    drop_column :users, :twitter_user
    drop_column :users, :facebook_user
  end
end
