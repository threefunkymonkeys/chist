Sequel.migration do
  change do
    create_table(:mail_queues) do
      primary_key :id
      String :priority, :text=>true, :null=>false
      String :to_email, :text=>true, :null=>false
      String :to_name, :text=>true, :null=>false
      String :from_email, :text=>true, :null=>false
      String :from_name, :text=>true, :null=>false
      String :subject, :text=>true, :null=>false
      String :body, :text=>true
    end

    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:user_favorites) do
      Integer :user_id, :null=>false
      String :chist_id, :null=>false

      primary_key [:user_id, :chist_id]
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
    
    create_table(:attachments) do
      primary_key :id
      foreign_key :mail_queue_id, :mail_queues, :key=>[:id]
      String :file_path, :text=>true, :null=>false
      String :content_type, :text=>true, :null=>false
    end

    create_table(:chists) do
      foreign_key :user_id, :users, :key=>[:id]
      String :title, :text=>true, :null=>false
      String :chist, :text=>true, :null=>false
      String :chist_raw, :text=>true, :null=>false
      TrueClass :public, :default=>false
      String :format, :default=>"none", :text=>true, :null=>false
      String :id, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
    end

    create_table(:user_api_keys, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :user_id, :users, :key=>[:id]
      String :name, :text=>true
      String :key, :text=>true

      index [:key]
    end
  end
end
