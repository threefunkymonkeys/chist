class Chist < Sequel::Model
  many_to_one :user
  unrestrict_primary_key

  def before_create
    self.id ||= SecureRandom.hex
    super
  end

  def before_save
    self.public = force_boolean(self.public)
    true
  end

  def id
    if values[:id]
      super.gsub("-", "")
    else
      super
    end
  end

  def destroy_cascade
    self.class.db["DELETE FROM user_favorites WHERE user_id = ? AND chist_id = ?", self.user_id, self.id].all
    self.destroy
  end

  def url
    "/chists/#{id}"
  end

  def to_hash
    {
      :id         => id,
      :title      => title,
      :url        => url,
      :public     => self.public,
      :format     => format,
      :created_at => created_at,
      :updated_at => updated_at
    }
  end

  private

  def force_boolean(val)
    case val.class
    when Numeric
      val == 0 ? false : true
    when String
      !val.strip.empty?
    when Hash, Array
      !val.empty?
    else
      !!val
    end
  end
end
