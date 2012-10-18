set :user, "andrewcole"
set :application, "list.skillshot.ndrew.org"
set :deploy_to, "/home/#{user}/#{application}"
role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run

