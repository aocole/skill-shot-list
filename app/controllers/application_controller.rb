class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :admin?, :mobile_device?
  before_filter :check_for_mobile

  def admin?
    current_user && current_user.admin
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_admin_user
    if require_user
      unless current_user.admin
        redirect_to :back, :alert => "You are not authorized to access that page"
      end
    else
      return false
    end
  end

  def require_user
    if current_user
      return true
    else
      store_location
      redirect_to new_user_session_url, :alert=> "You must be logged in to access this page"
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to :back, :alert => "You must be logged out to access this page"
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(*args)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(*args)
    session[:return_to] = nil
  end

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path('app/views_mobile')
  end

end
