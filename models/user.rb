class User < Sequel::Model
  include Shield::Model

  one_to_many :chists

  def self.fetch(email)
    find(:email => email)
  end

  def activate
    self.valid = true #use self to avoid collition
    validation_code = ""
    save
  end
end
