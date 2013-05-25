# Be sure to restart your server when you modify this file.
if %w(development test).include? Rails.env
  Skillshot::Application.config.secret_token = 'c74363ccf2373ccfdd2acdea4161fba381a593735df64242cd8468edb0987d42f5a6070c33eb5c770a5e8004e097e61e49088652bec61'
else
  if ENV['SECRET_TOKEN'].present?
    Skillshot::Application.config.secret_token = ENV['SECRET_TOKEN']

  # Do not raise an error if secret token is not available during assets precompilation
  elsif ENV['RAILS_GROUPS'] != 'assets'
    raise <<-ERROR
      If you are deploying to Heroku, please run the following command to set your secret token:
          heroku config:add SECRET_TOKEN="$(bundle exec rake secret)"
    ERROR
  end
end