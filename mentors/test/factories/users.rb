Factory.define :valid_user, :class => User do |u|
  u.login 'DarthVader'
  u.email 'darth@deathstar.net'
  u.password 'letmein'
  u.password_confirmation { |u| u.password }
end

Factory.define :invalid_user, :class => User do |u|
end

Factory.define :admin_user, :class => User do |u|
  u.login 'admin'
  u.email 'root@deathstar.net'
  u.password 'password'
  u.password_confirmation { |u| u.password }
end
