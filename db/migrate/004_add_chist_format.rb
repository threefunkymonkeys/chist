Sequel.migration do
  up do
    add_column :chists, :format, String, null: false, default: 'none'
  end

  down do
    remove_column :chists, :format
  end
end

