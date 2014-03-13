module OmniAuth
  class AuthHash
    def to_signup_hash
      {
        uid:   uid,
        name:  self.respond_to?(:info) && info.respond_to?(:name) && !info.name.empty? ? info.name : \
              (self.respond_to?(:extra) && extra.respond_to?(:name) && !extra.name.empty? ? extra.name : ''),
        email: self.respond_to?(:info) && info.respond_to?(:email) && !info.email.empty? ? info.email : \
              (self.respond_to?(:info) && extra.respond_to?(:email) && !extra.email.empty? ? extra.email : ''),
        provider: provider
      }
    end
  end
end
