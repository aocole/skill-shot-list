class AddStatusToTitles < ActiveRecord::Migration
  def self.up
    add_column :titles, :status, :string
  end

  def self.down
  end
end
