class UsersController < ApplicationController
  before_action :require_user

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = @current_user

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = @current_user
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(user_params)
    @user.admin = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to(root_url, notice: 'User was successfully created.') }
        format.xml  { render xml: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = @current_user
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(@user, notice: 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :initials, :password, :password_confirmation)
  end

end
