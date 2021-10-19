class CreateMachineChanges < ActiveRecord::Migration
  def change
    create_table :machine_changes do |t|
      t.integer :machine_id, null: false
      t.string :change_type, null: false

      t.timestamps
    end
    add_foreign_key :machine_changes, :machines, dependent: :destroy
  end
end
