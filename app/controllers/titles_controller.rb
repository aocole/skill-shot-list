class TitlesController < ApplicationController
  before_action :require_admin_user, except: [:active]
  layout Proc.new{|c|
    c.request.path_parameters[:action] == 'active' && c.request.format.json? ? 
    'empty' : 
    'application'
  }
  caches_action :active, 
    if: Proc.new{|c|!c.admin?}, 
    layout: false, 
    cache_path: Proc.new{|c| {
        callback: c.params[:callback]
      }
    }
  cache_sweeper :title_sweeper

  # GET /titles
  # GET /titles.json
  def index
    @titles = Title.all
    respond_to do |format|
      format.html
      format.json { render json: @titles }
    end
  end

  def active
    @titles = Title.
      select("distinct title.*, #{Title::DEFAULT_ORDER}").
      joins('as title inner join machines as machine on machine.title_id=title.id').
      where('machine.deleted_at is null').
      includes(:locations)
    if params[:wordpress]
      s = render_to_string template: 'titles/wordpress', formats: [:html], layout: false
      respond_to do |format|
        format.json { render json: [s] }
      end
      return
    end
    respond_to do |format|
      format.html
      format.json { render json: @titles }
    end
  end

  def duplicate
    @titles = Title.
      select('name, count(name) as duplicate_count').
      group('name').
      having('count(name) > 1')
  end

  def dupe_resolve
    @titles = Title.where(name: params[:name])
  end

  def idless
    @titles = Title.where(ipdb_id: nil)
  end

  # GET /titles/1
  # GET /titles/1.json
  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.json
  def new
    @title = Title.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @title }
    end
  end

  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # POST /titles
  # POST /titles.json
  def create
    @title = Title.new(title_params)

    respond_to do |format|
      if @title.save
        format.html { redirect_to @title, notice: 'Title was successfully created.' }
        format.json { render json: @title, status: :created, location: @title }
      else
        format.html { render action: "new" }
        format.json { render json: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.json
  def update
    @title = Title.find(params[:id])

    respond_to do |format|
      if @title.update_attributes(title_params)
        format.html { redirect_to @title, notice: 'Title was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.json
  # Doesn't actually destroy the title, just hides it so import won't re-create it.
  def destroy
    @title = Title.find(params[:id])
    @title.status = Title::STATUS::HIDDEN
    @title.save!

    respond_to do |format|
      format.html { redirect_back fallback_location: root_pathredirect_to :back }
      format.json { head :ok }
    end
  end

  def search
    @titles = params[:term].blank? ? [] : Title.find(:all, conditions: ["name ilike ?", "%#{params[:term]}%"])
    respond_to do |format|
      format.html { render action: 'dupe_resolve'}
      format.json { render json: @titles.collect{|title|{label: title.name, value: title.id}} }
    end
  end

  private

  def title_params
    params.require(:title).permit(:ipdb_id, :name)
  end
end
