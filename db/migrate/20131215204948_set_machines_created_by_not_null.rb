class SetMachinesCreatedByNotNull < ActiveRecord::Migration
  def up
    change_column :machines, :created_by_id, :integer, null: false
  end

  def down
    change_column :machines, :created_by_id, :integer, null: true
  end
end
