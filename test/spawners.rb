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
  user.validation_code = SecureRandom.hex(24)
  user.update_password = false
end

Chist.extend(Spawn).spawner do |chist|
  chist.user_id ||= User.spawn.id
  chist.title ||= Faker::Name.name
  chist.chist_raw ||= Faker::Lorem.paragraph(2)
  chist.chist ||= Faker::Lorem.paragraph(2)
end
