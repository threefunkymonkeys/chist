Sequel.migration do
  up do
    create_table :mail_queues do
      primary_key :id
      String :priority, :null => false
      String :to_email, :null => false
      String :to_name,  :null => false
      String :from_email, :null => false
      String :from_name,  :null => false
      String :subject, :null => false
      Text   :body
    end

    create_table :attachments do
      primary_key :id
      foreign_key :mail_queue_id, :mail_queues
      String :file_path, :null => false
      String :content_type, :null => false
    end

  end

  down do
    drop_table :mail_queues
    drop_table :attachments
  end
end
