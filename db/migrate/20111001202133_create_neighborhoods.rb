class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name, null: false
      t.integer :region_id, null: false

      t.timestamps
    end
    add_foreign_key :neighborhoods, :regions
  end
end
