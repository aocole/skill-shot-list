class AdminController < ApplicationController
  before_action :require_admin_user

  def index
  end

  def clear_all_cache
    expire_fragment /./
    redirect_to({action: :index}, {notice: "All caches cleared."})
  end

end
