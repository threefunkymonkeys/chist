Sequel.migration do
  up do
    create_table :user_favorites do
      Integer :user_id, :null => false
      Uuid :chist_id, :null => false
    end

    execute("ALTER TABLE user_favorites ADD PRIMARY KEY (user_id,chist_id)")
  end

  down do
    drop_table :user_favorites
  end
end
