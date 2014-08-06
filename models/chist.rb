class Chist < Sequel::Model
  many_to_one :user
  unrestrict_primary_key

  def before_create
    self.id ||= SecureRandom.hex
    super
  end

  def id
    if values[:id]
      super.gsub("-", "")
    else
      super
    end
  end
end
