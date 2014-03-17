Sequel.migration do
  up do
    create_table :chists do
      primary_key :id
      foreign_key :user_id, :users
      String :title, :null => false
      Text :chist, :null => false
      Text :chist_raw, :null => false
      Boolean :public, :default => true
    end
  end

  down do
    drop_table :chists
  end
end
