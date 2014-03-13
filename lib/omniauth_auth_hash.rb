module OmniAuth
  class AuthHash
    def to_signup_hash
      {
        uid:   uid || '',
        name:  self.respond_to?(:extra) && extra.respond_to?(:name) && !extra.name.empty? ? extra.name : \
              (self.respond_to?(:info) && info.respond_to?(:name) && !info.name.empty? ? info.name : ''),
        email: self.respond_to?(:extra) && extra.respond_to?(:email) && !extra.email.empty? ? extra.email : \
              (self.respond_to?(:info) && info.respond_to?(:email) && !info.email.empty? ? info.email : ''),
        provider: provider || ''
      }
    end
  end
end
