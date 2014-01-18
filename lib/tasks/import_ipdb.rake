class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end

namespace :import do
  desc "Imports IPDB file"
  task :ipdb => :environment do
    I18n.enforce_available_locales = true
    require 'htmlentities'
    unless ENV['file']
      puts "Must specify 'file={filename}'"
      exit
    end
    ActiveRecord::Base.logger = nil
    f = File.read(ENV['file']).
      encode("UTF-8", 'ASCII', :invalid => :replace, :undef => :replace, :replace => "").
      force_encoding('UTF-8')
    coder = HTMLEntities.new
    f.scan(/<tr>.+?\?gid=(\d+)&.+?>([^<]*)</) do |ipdb_id, name|
      title = Title.find_by_ipdb_id(ipdb_id)
      title ||= Title.new
      title.name = coder.decode(name)
      title.ipdb_id = ipdb_id
      if title.changed?
        if title.save
          puts "Updated #{title.name}".yellow
        else
          errors = title.errors.full_messages.join(', ')
          if errors == 'Ipdb has already been taken'
            print 'dup '
          else
            puts "#{ipdb_id}-#{name} failed: #{errors}".red
          end
        end
      end
    end
    puts
  end
end
