class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
