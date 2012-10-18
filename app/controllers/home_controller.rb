class HomeController < ApplicationController
  caches_page :wrapper

  # There is a cron job set up on Dreamhost to hit
  # this action as a keep-alive for Passenger
  def noop
    render :nothing => true
  end
  
  def wrapper
    render :partial => 'layouts/wrapper'
  end
end
