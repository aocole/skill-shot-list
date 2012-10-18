namespace :import do
  desc "Imports IPDB file"
  task :ipdb => :environment do
    require 'iconv'
    require 'htmlentities'
    unless ENV['file']
      puts "Must specify 'file={filename}'"
      exit
    end
    f = File.read(ENV['file'])
    coder = HTMLEntities.new
    f.scan(/<tr>.+?\?gid=(\d+)&.+?>([^<]*)</) do |ipdb_id, name|
      title = Title.find_by_ipdb_id(ipdb_id)
      title ||= Title.new
      title.name = coder.decode(Iconv.conv('ASCII//IGNORE', 'UTF8', name))
      title.ipdb_id = ipdb_id
      if title.save
        putc '.'
      else
        puts "#{ipdb_id}-#{name} failed: #{title.errors.full_messages.join(', ')}"
      end
    end
    
  end
end