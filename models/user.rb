class User < Sequel::Model
  include Shield::Model

  def self.fetch(email)
    find(:email => email)
  end
end
