class MachineChange < ActiveRecord::Base
  belongs_to :machine, :with_deleted => true
  class ChangeType
    CREATE = 'create'
    DELETE = 'delete'

    def self.all_types
      constants.collect{|sym|const_get sym}
    end
  end
  attr_accessible :change_type, :machine
  validates_presence_of :change_type, :machine
  validates_inclusion_of :change_type, :in => ChangeType.all_types

  def add?
    change_type == ChangeType::CREATE
  end
  alias create? add?

  def remove?
    change_type == ChangeType::DELETE
  end
  alias delete? remove?
end
