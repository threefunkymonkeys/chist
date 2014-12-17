Sequel.migration do
  up do
    create_table :user_api_keys do
      primary_key :id
      foreign_key :user_id, :users
      Text :name
      Text :key
    end

    add_index :user_api_keys, :key
  end

  down do
    drop_table :user_api_keys
  end
end
