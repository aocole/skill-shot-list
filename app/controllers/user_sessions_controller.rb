class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        format.html { redirect_back_or_default root_url, :notice => "Login successful!" }
        format.json {
          render :json =>
          {
            :success => true
          }
        }
      else
        format.html { render :action => :new }
        format.json { render :json => {:success => false} }
      end
    end
  end

  def destroy
    current_user_session.destroy
    redirect_back_or_default new_user_session_url, :notice => "Logout successful!"
  end
end
