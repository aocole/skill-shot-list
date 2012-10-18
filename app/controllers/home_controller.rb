class HomeController < ApplicationController
  caches_page :wrapper

  # There is a cron job set up on Dreamhost to hit
  # this action as a keep-alive for Passenger
  def noop
    render :nothing => true
  end
  
  def index
    @area = Area.find_using_slug 'seattle'
    if @area
      render '/areas/show'
    else
      flash.keep
      redirect_to admin_index_path
    end
  end

  def wrapper
    render :partial => 'layouts/wrapper'
  end
end
