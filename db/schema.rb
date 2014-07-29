Sequel.migration do
  change do
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:users) do
      primary_key :id
      String :email, :text=>true, :null=>false
      String :crypted_password, :text=>true, :null=>false
      String :name, :text=>true
      String :username, :text=>true
      TrueClass :valid, :default=>false
      String :github_user, :text=>true
      String :twitter_user, :text=>true
      String :facebook_user, :text=>true
      String :validation_code, :text=>true
      TrueClass :update_password, :default=>false
    end
    
    create_table(:chists) do
      foreign_key :user_id, :users, :key=>[:id]
      String :title, :text=>true, :null=>false
      String :chist, :text=>true, :null=>false
      String :chist_raw, :text=>true, :null=>false
      TrueClass :public, :default=>true
      String :format, :default=>"none", :text=>true, :null=>false
      String :id, :null=>false
      
      primary_key [:id]
    end
  end
end
