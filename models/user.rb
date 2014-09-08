class User < Sequel::Model
  include Shield::Model

  one_to_many :chists

  ALLOWED_PROVIDERS = [:facebook, :twitter, :github]
  @@sel_ds = self.db[:user_favorites].where(:user_id => :$u, :chist_id => :$c)
  @@ins_ds = self.db["INSERT INTO user_favorites (user_id, chist_id) VALUES (?, ?)", :$u, :$c]
  @@del_ds = self.db["DELETE FROM user_favorites WHERE user_id = ? AND chist_id = ?", :$u, :$c]

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

  def favorited?(chist)
    @@sel_ds.call(:select, :u => self.id, :c => chist.id).any?
  end

  def toggle_favorite(chist)
    if self.favorited?(chist)
      puts @@del_ds.call(:delete, :u => self.id, :c => chist.id)
    else
      @@ins_ds.call(:insert, :u => self.id, :c => chist.id)
    end
  end

  def search_chists(query)
    Chist.where("user_id = ? AND chist ILIKE ?", self.id, "%#{query}%")
  end

  def favorite_chists
    Chist.join(:user_favorites, :chist_id => :id).where("user_favorites.user_id = ?", self.id).order(Sequel.desc(:created_at))
  end

  def ordered_chists
    favs = favorite_chists
    reg_chists = Chist.where("user_id = ?", self.id).order(Sequel.desc(:created_at))
    reg_chists = reg_chists.where("id NOT IN ?", favs.map(&:id)) if favs.any?
    favs.to_a + reg_chists.to_a
  end
end
