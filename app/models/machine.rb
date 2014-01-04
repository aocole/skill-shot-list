class Machine < ActiveRecord::Base
  acts_as_paranoid :columns => 'deleted_at', :column_type => 'time'
  belongs_to :location, :touch => true, :with_deleted => true
  belongs_to :title
  belongs_to :created_by, :class_name => 'User'
  belongs_to :deleted_by, :class_name => 'User'
  has_many :machines_changes
  validates_presence_of :location, :title, :created_by

  def <=> other
    self.title.sort_name <=> other.title.sort_name
  end
end
