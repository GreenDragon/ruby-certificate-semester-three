class User < ActiveRecord::Base
  acts_as_authentic

  # magically handled by acts_as_authenic?
  # validates_uniqueness_of :login, :email, :allow_blank => true
end
