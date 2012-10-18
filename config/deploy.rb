require 'bundler/capistrano'

set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'

default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false

set :repository,  "http://svn.skillshot.ndrew.org/svn/trunk/app/skillshot"
set :rails_env, 'production'
set :deploy_via, :export

set :scm, :subversion
set :scm_username, 'aocole'
logger.level = 1
set :scm_password, Proc.new {
  puts "WARNING: YOUR SVN PASSWORD WILL BE ECHOED TO THE SCREEN SEVERAL TIMES IN LOG LINES. Run with -v for less logging." unless logger.level < 2
  Capistrano::CLI.password_prompt('SVN Password: ')
}
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

        require './config/boot'
        require 'airbrake/capistrano'
