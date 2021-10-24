class AreasController < ApplicationController
  before_action :require_admin_user, except: [:show]
  layout Proc.new{|c|c.params[:id] == 'wordpress' ? 'empty' : 'application'}
  caches_action :show, 
    if: Proc.new{|c|!c.admin?}, 
    layout: false, 
    cache_path: Proc.new{|c| {
        callback: c.params[:callback]
      }
    }
  cache_sweeper :location_sweeper
  cache_sweeper :title_sweeper
  cache_sweeper :machine_sweeper

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas }
    end
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    if params[:id] == 'wordpress'
      @areas = Area.includes(
        localities: {
          locations: {
            machines: :title
          }
        }
      ).all
      s = render_to_string template: 'areas/wordpress', formats: :html, layout: false
      respond_to do |format|
        format.json { render json: [s] }
        format.html { render plain: s }
      end
      return
    else
      @area = Area.includes(localities: {locations: {machines: :title}}).find_using_slug!(params[:id])

      # check all geocodes
      failed_geocode = false
      @area.localities.each do |locality|
        locality.locations.each do |location|
          if !location.geocoded? && !failed_geocode
            begin
              location.geocode
            rescue => e
              failed_geocode = true # keeps us from wasting time if the geocoder api is down
            end
            location.save
          end
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @area }
    end
  end

  def machines_per_location_report
    show
  end

  def print
    @area = Area.find_using_slug!(params[:id])

    respond_to do |format|
      format.html { render layout: false}
      format.json { render json: @area }
    end
  end

  # GET /areas/new
  # GET /areas/new.json
  def new
    @area = Area.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area }
    end
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find_using_slug!(params[:id])
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)

    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'Area was successfully created.' }
        format.json { render json: @area, status: :created, location: @area }
      else
        format.html { render action: "new" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /areas/1
  # PUT /areas/1.json
  def update
    @area = Area.find_using_slug!(params[:id])

    respond_to do |format|
      if @area.update_attributes(area_params)
        format.html { redirect_to @area, notice: 'Area was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area = Area.find_using_slug!(params[:id])
    @area.destroy

    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { head :ok }
    end
  end

  private

  def area_params
    params.require(:area).permit(:name)
  end
end
