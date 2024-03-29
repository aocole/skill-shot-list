class LocationsController < ApplicationController
  before_action :require_admin_user, except: [:show, :index, :for_wordpress, :for_wordpress_list]
  cache_sweeper :location_sweeper
  
  def index
    respond_to do |format|
      format.html { redirect_to :root }
      format.json { render json: regular_locations}
    end
  end

  def for_wordpress
    locations = regular_locations.select{|l| l.machines.size > 0} # TODO: get sql to do this

    respond_to do |format|
      format.html {render layout: false}
      format.json {render json: locations, each_serializer: LocationDetailSerializer}
    end
  end

  def for_wordpress_list
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.includes(machines: [:title]).find_using_slug!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render(
          {json: @location, serializer: LocationDetailSerializer},
          {layout: false}
        )
      }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new(city: 'Seattle', state: 'WA')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find_using_slug!(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find_using_slug!(params[:id])
    respond_to do |format|
      if @location.update_attributes(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.includes(:area, :machines).find_using_slug!(params[:id]) # area needed for cache sweeper
    @location.machines.each do |machine|
      machine.deleted_by = current_user
      machine.save!
    end

    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was deleted." }
      format.json { head :ok }
    end
  end

  private

  def regular_locations
    Location.
        unscoped. # sigh, i shouldn't have used default_scope
        where('deleted_at is null').
        includes(:machines).
        order('name asc')
  end

  def location_params
    params.require(:location).permit(:name, :locality_id, :address, :city, :state, :postal_code, :url, :phone, :all_ages)
  end

end
