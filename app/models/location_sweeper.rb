class LocationSweeper < ActionController::Caching::Sweeper
  observe Location # This sweeper is going to keep an eye on the Location model

  # If our sweeper detects that a Location was created call this
  def after_create(location)
    expire_cache_for(location)
  end

  # If our sweeper detects that a Location was updated call this
  def after_update(location)
    expire_cache_for(location)
  end

  # If our sweeper detects that a Location was deleted call this
  def after_destroy(location)
    expire_cache_for(location)
  end

  private
  def expire_cache_for(location)
    # Expire the index page now that we added a new location
    %w{0 1}.each do |num|
      expire_action(:controller => 'areas', :action => 'show', :id => location.area, :mobile => num)
      expire_action(:controller => 'locations', :action => 'show', :id => location, :mobile => num)
      expire_action(:controller => 'titles', :action => 'active', :mobile => num)
    end
    expire_fragment('trivia')
  end
end
