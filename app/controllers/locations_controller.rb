class LocationsController < ApplicationController
  before_filter :require_admin_user, :except => [:show, :index]
  caches_action :show, :if => Proc.new{|c|!c.admin?}, :layout => false
  cache_sweeper :location_sweeper

  def index
    redirect_to :root
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find_using_slug!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new(:city => 'Seattle', :state => 'WA')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find_using_slug!(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    valid_keys = %w{name locality_id address city state postal_code url phone all_ages}
    params[:location].delete_if{|k,v|!valid_keys.include?(k)}
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, :notice => 'Location was successfully created.' }
        format.json { render :json => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.json { render :json => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find_using_slug!(params[:id])
    valid_keys = %w{name locality_id address city state postal_code url phone all_ages}
    params[:location].delete_if{|k,v|!valid_keys.include?(k)}

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, :notice => 'Location was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find_using_slug!(params[:id], :include => :area) # area needed for cache sweeper
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, :notice => "Location was deleted." }
      format.json { head :ok }
    end
  end
end
