require 'history'
class StatsController < ApplicationController
  # before_filter :require_admin_user
  skip_before_filter :redirect_to_wordpress

  def index
    render layout:false
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
    spm = Location.find_by_cached_slug 'seattle-pinball-museum'
    psid = Locality.find_by_cached_slug 'pioneer-square-international-district'
    idwospm = "Pioneer Sq./ID w/o SPM"
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

      # This smooths out spikyness caused by games being added and removed from a location
      # on the same day
      adjusted_change_time = change.created_at.at_midnight

      current_count += delta
      @machines_over_time[adjusted_change_time] = current_count

      @title_count[change.machine.title] += delta
      @titles_over_time[change.machine.title.name] ||= {}
      @titles_over_time[change.machine.title.name][adjusted_change_time] = @title_count[change.machine.title]

      @locality_count[change.machine.location.locality] += delta
      @localities_over_time[change.machine.location.locality.name] ||= {}
      @localities_over_time[change.machine.location.locality.name][adjusted_change_time] = @locality_count[change.machine.location.locality]
      if change.machine.location.locality == psid && change.machine.location != spm 
        @locality_count[idwospm] += delta
        @localities_over_time[idwospm] ||= {}
        @localities_over_time[idwospm][adjusted_change_time] = @locality_count[idwospm]
      end
    end
    last_date = changes.last.created_at.at_midnight
    [@titles_over_time, @localities_over_time].each do |dataset|
      dataset.each do |name, time_series_hash|
        last_date_of_this_hash = time_series_hash.keys.max
        last_value = time_series_hash[last_date_of_this_hash]
        time_series_hash[last_date] = last_value
      end
    end

    [
      "Belltown/Denny Regrade", 
      "U District/North Side",
      "White Center",
      "Greenwood/Green Lake",
      "SODO",
      "Columbia City",
      "Downtown",
      "Eastlake",
      "Queen Anne",
      "Central District/Madison Park",
      "South Lake Union",
      "West Seattle"].each do |hood|
      @localities_over_time.delete(hood)
    end
    @localities_over_time["Pioneer Sq./ID"] = @localities_over_time.delete "Pioneer Square/International District"

    [@titles_over_time, @localities_over_time].each do |data_over_time|
      data = data_over_time.keys
      data.each do |name|
        data_over_time[name] = data_over_time[name].to_a
      end
    end

    render action: 'index', layout: false
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
