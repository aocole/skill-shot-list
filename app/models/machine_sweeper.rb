class MachineSweeper < ActionController::Caching::Sweeper
  observe Machine # This sweeper is going to keep an eye on the Machine model

  # If our sweeper detects that a Machine was created call this
  def after_create(machine)
    expire_cache_for(machine)
  end

  # If our sweeper detects that a Machine was updated call this
  def after_update(machine)
    expire_cache_for(machine)
  end

  # If our sweeper detects that a Machine was deleted call this
  def after_destroy(machine)
    expire_cache_for(machine)
  end

  private
  def expire_cache_for(machine)
    # Expire the index page now that we added a new machine
    %w{0 1}.each do |num|
      expire_action(:controller => 'areas', :action => 'show', :id => machine.location.area, :mobile => num)
      expire_action(:controller => 'locations', :action => 'show', :id => machine.location, :mobile => num)
      expire_action(:controller => 'titles', :action => 'active', :mobile => num)
    end
    expire_fragment('trivia')
  end
  
end
