class Machine < ActiveRecord::Base
  belongs_to :location, :touch => true
  belongs_to :title
  belongs_to :creator, :class_name => 'User'
  validates_presence_of :location, :title, :creator

  def <=> other
    self.title.sort_name <=> other.title.sort_name
  end
end
