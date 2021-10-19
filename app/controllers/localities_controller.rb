class LocalitiesController < ApplicationController
  before_filter :require_area
  before_filter :require_admin_user, except: :index

  def require_area
    @area = Area.includes(:localities).find_using_slug!(params[:area_id])
  end

  # GET /localities
  # GET /localities.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @area.localities }
    end
  end

  # GET /localities/1
  # GET /localities/1.json
  def show
    @locality = Locality.find_using_slug!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @locality }
    end
  end

  # GET /localities/new
  # GET /localities/new.json
  def new
    @locality = Locality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @locality }
    end
  end

  # GET /localities/1/edit
  def edit
    @locality = Locality.find_using_slug!(params[:id])
  end

  # POST /localities
  # POST /localities.json
  def create
    @locality = Locality.new(name: params[:locality][:name], area: @area)

    respond_to do |format|
      if @locality.save
        format.html { redirect_to area_localities_path(@area), notice: 'Locality was successfully created.' }
        format.json { render json: @locality, status: :created, location: @locality }
      else
        format.html { render action: 'index' }
        format.json { render json: @locality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /localities/1
  # PUT /localities/1.json
  def update
    @locality = Locality.find_using_slug!(params[:id])

    respond_to do |format|
      if @locality.update_attributes(update_params)
        format.html { redirect_to area_locality_path(@area, @locality), notice: 'Locality was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @locality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localities/1
  # DELETE /localities/1.json
  def destroy
    @locality = Locality.find_using_slug!(params[:id])
    @locality.destroy

    respond_to do |format|
      format.html { redirect_to localities_url }
      format.json { head :ok }
    end
  end

  def update_params
    params.require(:locality).permit(:name)
  end
end
