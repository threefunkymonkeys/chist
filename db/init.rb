puts 'Creating users table if not exists...'
DB.create_table? :users do
  primary_key :id
  String :email
  String :crypted_password
  String :name
  String :username
end
