class AddLocalityIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :locality_id, :integer
  end
end
