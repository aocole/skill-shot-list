# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Skillshot::Application.load_tasks


task :cache_header do
  wordpress_host = ENV['WORDPRESS_HOST'] || 'www.skill-shot.com'
  header_url = "http://" + wordpress_host + '/header-for-rails.php'
  header = RestClient.get(header_url).body
  File.open('app/views/layouts/_header.html.erb', 'w+') {|f| f.puts header}
end
