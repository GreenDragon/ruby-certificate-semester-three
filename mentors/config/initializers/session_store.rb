# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mentors_session',
  :secret      => '0a012dac70cf720bc1fce9eb60aa3eae2905789f80eabc822822973a822c98104c7ae55f3cdb977645dc43a193443e3a35775b2fbcf4cbd6a04e1dd177438c33'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
