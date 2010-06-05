# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_iCalWrapper_session',
  :secret      => '15e6420f35d087053557c7b8f89fa692b356f45ca6283b046cb4b4ea8fc089d45bdf7048690977cbb7eed39f6f90377d1430fca9bcdf580d7d71f0942449f43a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
