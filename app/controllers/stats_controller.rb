class StatsController < ApplicationController
  before_filter :require_admin_user

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

end
