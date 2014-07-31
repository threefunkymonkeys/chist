Sequel.migration do
  up do
    add_column :chists, :created_at, DateTime
    add_column :chists, :updated_at, DateTime
  end

  down do
    drop_column :chists, :created_at
    drop_column :chists, :updated_at
  end
end
