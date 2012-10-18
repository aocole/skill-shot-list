class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :url
      t.string :phone
      t.boolean :all_ages

      t.timestamps
    end
  end
end
