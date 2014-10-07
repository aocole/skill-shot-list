class StatsController < ApplicationController
  before_filter :require_admin_user

  def index

    changes = MachineChange.order('created_at desc')
    current_count = Machine.count
    time_series = [
    ]
    changes.each do |change|
      time_series << [change.created_at, current_count]
      # We're going backwards in time, so if the change was a creation we have to subtract one
      current_count += change.change_type == MachineChange::ChangeType::CREATE ? -1 : 1
    end

    @machines_over_time = time_series
  end

end
