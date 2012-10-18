class AddIndexOnTitleIpdbId < ActiveRecord::Migration
  def self.up
    add_index(:titles, :ipdb_id, :unique => true)
  end

end
