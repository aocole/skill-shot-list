class AddMoreAddressFieldsToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :postal_code, :string
  end
end
