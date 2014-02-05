class User < Sequel::Model
  include Shield::Model

  set_primary_key [:email]
end
