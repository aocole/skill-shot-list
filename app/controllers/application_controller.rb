class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :admin?
  before_filter :redirect_to_wordpress

  def redirect_to_wordpress
    return if current_user
    return if kind_of? UserSessionsController
    return unless request.format.html?
    if kind_of?(TitlesController) && request.path_parameters[:action] == 'active'
      redirect_to 'http://www.skill-shot.com/pinball-titles', status: 301
      return false
    end
    redirect_to 'http://www.skill-shot.com/pinball-list', status: 301
    return false
  end

  def admin?
    current_user && current_user.admin
  end

  def default_serializer_options
    {
      root: false
    }
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
        respond_to do |format|
          format.html {redirect_to :back, :alert => "You are not authorized to access that page"}
          format.json {render :json => {:error => 'unauthorized', :message => "You are not authorized to access that page"}, :status => 403}
        end
      end
    else
      return false
    end
  end

  def require_user
    if current_user
      return true
    else
      respond_to do |format|
        format.html {
          store_location
          redirect_to new_user_session_url, :alert=> "You must be logged in to access this page"
        }
        format.json {render :json => {:error => 'unauthorized', :message => "You must be logged in to access this page"}, :status => 403}
      end
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to :root
      return false
    end
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(*args)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(*args)
    session[:return_to] = nil
  end
end
