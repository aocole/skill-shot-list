class AddCreatorToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :creator_id, :integer
    add_foreign_key :machines, :users, :column => :creator_id, :dependent => :nullify
  end

  def self.down
    remove_foreign_key :machines, :creator_id
    remove_column :machines, :creator_id
  end
end
