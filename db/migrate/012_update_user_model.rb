Sequel.migration do
  up do
    add_column :users, :token_reset, String, null: true
  end

  down do
    drop_column :users, :token_reset
  end
end
