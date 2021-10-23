class MachineChange < ApplicationRecord
  belongs_to :machine, with_deleted: true
  class ChangeType
    CREATE = 'create'
    DELETE = 'delete'

    def self.all_types
      constants.collect{|sym|const_get sym}
    end
  end
  validates_presence_of :change_type, :machine
  validates_inclusion_of :change_type, in: ChangeType.all_types

  def add?
    change_type == ChangeType::CREATE
  end
  alias create? add?

  def remove?
    change_type == ChangeType::DELETE
  end
  alias delete? remove?

  def to_words
    "#{machine.title.name} #{change_type == ChangeType::CREATE ? 'added to' : 'removed from'} #{machine.location.name}"
  end
end
