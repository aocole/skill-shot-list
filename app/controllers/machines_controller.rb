class MachinesController < ApplicationController
  before_filter :require_location, :except => [:edit, :update, :destroy, :recent]
  before_filter :require_user, :except => [:show]
  cache_sweeper :machine_sweeper

  def require_location
    @location = Location.find_using_slug!(params[:location_id], :include => :machines)
  end

  # GET /machines
  # GET /machines.json
  def index
    @machines = @location.machines
    @machine = Machine.new
    @titles = Title.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @machines }
    end
  end

  def recent
    @machines = Machine.find :all, :order => 'created_at desc', :limit => 100, :include => [:creator, :title, :location]
  end

  def common
    @all = Machine.find :all, 
      :order => 'cnt desc', 
      :limit => 10, 
      :group => 'title_id', 
      :joins => 'join titles on titles.id=machines.title_id', 
      :select => 'titles.name, count(*) as cnt'
    @seattle = Machine.find :all, 
      :order => 'cnt desc', 
      :limit => 10, 
      :group => 'title_id', 
      :select => 'titles.name, count(*) as cnt', 
      :conditions => 'areas.name = "seattle"',
      :joins => "\
        join titles on titles.id=machines.title_id \
        join locations on locations.id=machines.location_id \
        join localities on localities.id=locations.locality_id \
        join areas on areas.id=localities.area_id"
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
    @machine = Machine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @machine }
    end
  end

  # GET /machines/new
  # GET /machines/new.json
  def new
    @machine = Machine.new
    @titles = Title.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @machine }
    end
  end

  # GET /machines/1/edit
  def edit
    @machine = Machine.find(params[:id])
  end

  # POST /machines
  # POST /machines.json
  def create
    @title = Title.find_by_id(params[:title_id])
    logger.debug "Creating a new machine. current user is #{current_user}"
    @machine = Machine.new({
        :location => @location,
        :title => @title,
        :creator => current_user
      })

    respond_to do |format|
      if @machine.save
        format.html { redirect_to location_machines_path(@location), :notice => 'Machine was successfully created.' }
        format.json { render :json => @machine, :status => :created, :location => @machine }
      else
        format.html { redirect_to location_machines_path(@location), :notice => @machine.errors.full_messages.join('. ') }
        format.json { render :json => @machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /machines/1
  # PUT /machines/1.json
  def update
    raise "Not implemented"
    @machine = Machine.find(params[:id])
#    valid_keys = %w{name}
#    params[:machine].delete_if{|k,v|!valid_keys.include?(k)}
#
#    respond_to do |format|
#      if @machine.update_attributes(params[:machine])
#        format.html { redirect_to @machine, :notice => 'Machine was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.json { render :json => @machine.errors, :status => :unprocessable_entity }
#      end
#    end
  end

  # DELETE /machines/1
  # DELETE /machines/1.json
  def destroy
    @machine = Machine.find(params[:id])
    @machine.destroy

    respond_to do |format|
      format.html { redirect_to location_machines_path(@machine.location), :notice => 'Machine was deleted.'  }
      format.json { head :ok }
    end
  end
end
