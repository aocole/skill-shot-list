class AddCachedSlugToAreas < ActiveRecord::Migration
  
  def self.up
    add_column :areas, :cached_slug, :string
    
    add_index  :areas, :cached_slug
  end

  def self.down
    remove_column :areas, :cached_slug
  end
  
end
