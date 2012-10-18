class AddCachedSlugToLocations < ActiveRecord::Migration
  
  def self.up
    add_column :locations, :cached_slug, :string
    add_index  :locations, :cached_slug
  end

  def self.down
    remove_column :locations, :cached_slug
  end
  
end
