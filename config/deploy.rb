require 'bundler/capistrano'

set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'

default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false

set :repository,  "git://github.com/aocole/skill-shot-list.git"
set :rails_env, 'production'
set :branch, 'master'
set :deploy_via, :remote_cache

set :scm, :git
logger.level = 1
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
after "deploy:update_code","deploy:config_symlink"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :config_symlink do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
end

require './config/boot'
require 'airbrake/capistrano'

