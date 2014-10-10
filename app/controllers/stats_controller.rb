require 'history'
class StatsController < ApplicationController
  # before_filter :require_admin_user
  skip_before_filter :redirect_to_wordpress

  def index
    # historical data from spreadsheet
    @machines_over_time = [
# [Time.parse("9/2007"),  16],
# [Time.parse("10/2007"), 27],
[Time.parse("3/2008"),  79],
[Time.parse("9/2009"),  161],
[Time.parse("2/2010"),  159],
[Time.parse("5/2010"),  160],
[Time.parse("8/2010"),  161],
[Time.parse("10/2010"), 191],
[Time.parse("4/2011"),  195],
[Time.parse("6/2011"),  198],
[Time.parse("8/2011"),  199],
[Time.parse("10/2011"), 199],
[Time.parse("1/2012"),  213],
[Time.parse("4/2012"),  218],
[Time.parse("6/2012"),  222],
[Time.parse("8/2012"),  225],
[Time.parse("10/2012"), 220],
[Time.parse("1/2013"),  232],
[Time.parse("3/2013"),  242],
[Time.parse("5/2013"),  252],
[Time.parse("8/2013"),  262],
[Time.parse("10/2013"), 277],
    ]

    changes = MachineChange.
                where("localities.area_id = 1 AND machine_changes.created_at > ?", Time.parse("2013-12-15 21:09")).
                order('created_at desc').
                joins('
                  join machines on machines.id = machine_changes.machine_id 
                  join locations on locations.id = machines.location_id
                  join localities on localities.id = locations.locality_id
                  ')
    current_count = Machine.
                  where("localities.area_id = 1").
                  joins('
                  join locations on locations.id = machines.location_id
                  join localities on localities.id = locations.locality_id
                  ').count
    changes.each do |change|
      @machines_over_time << [change.created_at, current_count]
      # We're going backwards in time, so if the change was a creation we have to subtract one
      current_count += change.change_type == MachineChange::ChangeType::CREATE ? -1 : 1
    end

    # @oldest_machines = Machine.order("created_at asc").limit(40)
  end

  def index2
    # state = {}
    # warnings = []
    current_count = 0
    @machines_over_time = {}
    @title_count = Hash.new(0)
    @titles_over_time = {}
    @locality_count = Hash.new(0)
    @localities_over_time = {}
    changes = History.reconstruct_changes.sort{|a,b|a.created_at <=> b.created_at}
    changes.each do |change|
      delta = change.change_type == MachineChange::ChangeType::CREATE ? 1 : -1
      # state[change.machine.location.name] ||= []
      # case change.change_type
      # when MachineChange::ChangeType::CREATE
      #   if state[change.machine.location.name].include?(change.machine.title.name)
      #     warnings << ("Adding #{change.machine.title.name} to #{change.machine.location.name} (#{change.created_at}) but it already has one")
      #   end
      #   state[change.machine.location.name] << change.machine.title.name
      # when MachineChange::ChangeType::DELETE
      #   deleted = state[change.machine.location.name].delete(change.machine.title.name)
      #   if !deleted
      #     warnings << ("Tried to remove #{change.machine.title.name} from #{change.machine.location.name} (#{change.created_at}) but there isn't one there!")
      #   end
      # end
      current_count += delta
      @machines_over_time[change.created_at] = current_count

      @title_count[change.machine.title] += delta
      @titles_over_time[change.machine.title.name] ||= {}
      @titles_over_time[change.machine.title.name][change.created_at] = @title_count[change.machine.title]

      @locality_count[change.machine.location.locality] += delta
      @localities_over_time[change.machine.location.locality.name] ||= {}
      @localities_over_time[change.machine.location.locality.name][change.created_at] = @locality_count[change.machine.location.locality]
    end
    # log_state(state, 'reconstructed_state')

    [@titles_over_time, @localities_over_time].each do |data_over_time|
      data = data_over_time.keys
      data.each do |name|
        data_over_time[name] = data_over_time[name].to_a
      end
    end

    render action: 'index'
    # logger.warn warnings.join("\n")
    # real_machines = Machine.
    #               where("localities.area_id = 1").
    #               joins('
    #               join locations on locations.id = machines.location_id
    #               join localities on localities.id = locations.locality_id
    #               ')
    # real_state = {}
    # real_machines.each do |machine|
    #   real_state[machine.location.name] ||= []
    #   real_state[machine.location.name] << machine.title.name
    # end
    # log_state(real_state, 'real_state')
  end

  def log_state state, name
    state.each do |place, games|
      games.sort!
    end
    state = state.to_a.sort{|a,b|a.first<=>b.first}
    File.open("#{Rails.root}/#{name}.yml", 'w+') do |f|
      f.puts state.to_yaml
    end

  end

end
