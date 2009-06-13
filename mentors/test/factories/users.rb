salt = Authlogic::Random.hex_token
crypted_password = Authlogic::CryptoProviders::Sha512.encrypt("letmein" + salt)

Factory.define :valid_user, :class => User do |u|
  u.login 'DarthVader'
  u.email 'darth@deathstar.net'
  u.password 'letmein'
  u.password_confirmation { |u| u.password }
  u.password_salt salt
  u.crypted_password crypted_password
end

Factory.define :invalid_user, :class => User do |u|
end

Factory.define :admin_user, :class => User do |u|
  u.login 'admin'
  u.email 'root@deathstar.net'
  u.password 'password'
  u.password_confirmation { |u| u.password }
end
