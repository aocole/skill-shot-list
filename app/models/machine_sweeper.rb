class MachineSweeper < ActionController::Caching::Sweeper
  observe Machine # This sweeper is going to keep an eye on the Machine model

  # If our sweeper detects that a Machine was created call this
  def after_create(machine)
    expire_cache_for(machine)
    MachineChange.create! machine: machine, change_type: MachineChange::ChangeType::CREATE
  end

  # If our sweeper detects that a Machine was updated call this
  def after_update(machine)
    expire_cache_for(machine)
  end

  # If our sweeper detects that a Machine was deleted call this
  def after_destroy(machine)
    expire_cache_for(machine)
    MachineChange.create! machine: machine, change_type: MachineChange::ChangeType::DELETE
  end

  private
  def expire_cache_for(machine)
    # Expire the index page now that we added a new machine
    expire_fragment('trivia')
  end

end
