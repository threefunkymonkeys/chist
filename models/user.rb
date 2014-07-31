class User < Sequel::Model
  include Shield::Model

  one_to_many :chists

  ALLOWED_PROVIDERS = [:facebook, :twitter, :github]

  def self.fetch(email)
    find(:email => email)
  end

  def activate
    self.valid = true #use self to avoid collition
    validation_code = ""
    save
  end

  def has_provider?(provider)
    !self.send("#{provider}_user").nil?
  end

  def add_provider(provider, user_id)
    return false unless ALLOWED_PROVIDERS.include? provider.to_sym
    self.update(:"#{provider}_user" => user_id)
  end

  def latest_chists
    Chist.where(:user_id => self.id).order(Sequel.desc(:created_at)).limit(5)
  end
end
