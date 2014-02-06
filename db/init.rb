puts 'Creating users table if not exists...'
DB.create_table? :users do
  primary_key :id
  String :email, :null => false
  String :crypted_password, :null => false
  String :name, :null => true
  String :username, :null => true
  Boolean :valid, :default => false
end
