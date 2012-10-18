class AddLatLongToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
  end
end
