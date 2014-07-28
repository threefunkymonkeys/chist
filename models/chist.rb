class Chist < Sequel::Model
  many_to_one :user
  unrestrict_primary_key

  def before_create
    values[:id] ||= SecureRandom.hex
    super
  end
end
