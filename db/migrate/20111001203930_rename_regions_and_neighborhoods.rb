class RenameRegionsAndNeighborhoods < ActiveRecord::Migration
  def self.up
    remove_foreign_key :neighborhoods, :regions
    rename_table(:regions, :areas)
    rename_table(:neighborhoods, :localities)
    rename_column(:localities, :region_id, :area_id)
    add_foreign_key :localities, :areas
  end
end
