class AddParanoidFieldsToMachines < ActiveRecord::Migration
  def change
    rename_column :machines, :creator_id, :created_by_id
    add_column :machines, :deleted_by_id, :integer
    add_column :machines, :deleted_at, :datetime
    add_foreign_key :machines, :users, column: :deleted_by_id, dependent: :nullify
  end
end
