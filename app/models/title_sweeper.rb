class TitleSweeper < ActionController::Caching::Sweeper
  observe Title # This sweeper is going to keep an eye on the Title model

  # If our sweeper detects that a Title was updated call this
  def after_update(title)
    expire_cache_for(title)
  end

  # If our sweeper detects that a Title was deleted call this
  def after_destroy(title)
    expire_cache_for(title)
  end

  private
  def expire_cache_for(title)
    # Expire the index page now that we added a new title
    expire_fragment(Regexp.new("/areas/\\."))
    expire_fragment(Regexp.new("/locations/\\."))
    expire_action(:controller => 'titles', :action => 'active')
    expire_fragment('trivia')
  end
end