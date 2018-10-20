class DeleteMachinesWithHiddenTitles < ActiveRecord::Migration
  def up
    Machine.unscoped.where(:titles => {:status => 'hidden'}).includes(:title).each do |machine|
      machine.machine_changes.each do |mc|
        mc.destroy
      end
      machine.destroy!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigrationError.new "Can't undelete the deleted machines!"
  end
end
