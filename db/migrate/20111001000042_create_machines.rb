class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.integer :title_id, null: false
      t.integer :location_id, null: false

      t.timestamps
    end
    add_foreign_key :machines, :titles, dependent: :delete
    add_foreign_key :machines, :locations, dependent: :delete

  end
end
