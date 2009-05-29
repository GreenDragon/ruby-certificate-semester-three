Factory.define :valid_user, :class => User do |u|
  u.login 'DarthVader'
  u.email 'darth@deathstar.net'
  u.password 'letmein'
  u.password_confirmation 'letmein'
  #u.crypted_password ''
  #u.password_salt ''
  #u.persistence_token ''
end

Factory.define :invalid_user, :class => User do |u|
end
