require 'history'
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

namespace :history do
  desc "Tests the history function"
  task :test => :environment do
    ActiveRecord::Base.logger = nil
      changes = History.reconstruct_changes
      nil_titles = changes.select{|c| c.machine.title.nil?}
  end
end
