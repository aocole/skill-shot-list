class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :name
      t.integer :ipdb_id

      t.timestamps
    end
  end
end
