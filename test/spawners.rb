module Faker
  class Internet < Base
    def self.safe_unique_email
      email = safe_email
      if User.find(:email => email).nil?
        email
      else
        safe_unique_email
      end
    end
  end
end

User.extend(Spawn).spawner do |user|
  user.email = Faker::Internet.safe_unique_email
  user.name  = Faker::Name.name
  user.username = Faker::Internet.user_name
  user.password = Faker::Internet.password
  user.valid = true
end
