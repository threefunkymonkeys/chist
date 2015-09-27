Sequel.migration do
  up do
    create_table :contacts do
      primary_key :id
      String :email, :null => false
      String :name, :null => false
      Text :message, :null => false
      Text :sample, :null => true
      Boolean :read, :default => false
      DateTime :created_at
    end
  end

  down do
    drop_table :contacts
  end
end

