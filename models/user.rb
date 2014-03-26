class User < Sequel::Model
  include Shield::Model

  one_to_many :chists

  def self.fetch(email)
    find(:email => email)
  end
end
