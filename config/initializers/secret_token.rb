# Be sure to restart your server when you modify this file.
# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if %w(development test).include? Rails.env
  Skillshot::Application.config.secret_key_base = '0c6aefae71130657b95fb08e33a88ee080099721e9288dc4936a092c61ee57ffcaecf5ddc0f51849ec00bc7e881420cd6f2dbc3a83d6bbbf3117aa84479b1c9d'
else
  if ENV['SECRET_TOKEN'].present?
    Skillshot::Application.config.secret_key_base = ENV['SECRET_TOKEN']

  # Do not raise an error if secret token is not available during assets precompilation
  elsif ENV['RAILS_GROUPS'] != 'assets'
    raise <<-ERROR
      If you are deploying to Heroku, please run the following command to set your secret token:
          heroku config:add SECRET_TOKEN="$(bundle exec rake secret)"
    ERROR
  end
end
