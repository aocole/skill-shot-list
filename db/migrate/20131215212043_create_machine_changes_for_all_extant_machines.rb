class CreateMachineChangesForAllExtantMachines < ActiveRecord::Migration
  def up
    values = Machine.all.collect do |machine|
      "(#{machine.id}, 'create', '#{machine.created_at.to_s(:db)}', '#{Time.now.utc.to_s(:db)}')"
    end
    execute "insert into machine_changes (machine_id, change_type, created_at, updated_at) values #{values.join(',')}"
  end

  def down
    MachineChange.destroy_all
  end
end
