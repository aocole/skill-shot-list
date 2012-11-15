class Area < ActiveRecord::Base
  has_many :localities
  validates_presence_of :name
  is_sluggable :name

  def center
    begin
      min_lat = Location.unscoped.find(:first, :joins => ["join localities on locality_id=localities.id join areas on localities.area_id=areas.id and areas.id=#{self.id}"], :order => 'latitude asc', :limit => 1).latitude
      max_lat = Location.unscoped.find(:first, :joins => ["join localities on locality_id=localities.id join areas on localities.area_id=areas.id and areas.id=#{self.id}"], :order => 'latitude desc', :limit => 1).latitude
      min_long = Location.unscoped.find(:first, :joins => ["join localities on locality_id=localities.id join areas on localities.area_id=areas.id and areas.id=#{self.id}"], :order => 'longitude asc', :limit => 1).longitude
      max_long = Location.unscoped.find(:first, :joins => ["join localities on locality_id=localities.id join areas on localities.area_id=areas.id and areas.id=#{self.id}"], :order => 'longitude desc', :limit => 1).longitude

      return (min_lat+max_lat)/2.0, (min_long+max_long)/2.0
    rescue
      return [47.6139, -122.345] # Seattle
    end
  end
end
