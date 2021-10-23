class Locality < ApplicationRecord
  default_scope -> {order('area_id asc, name asc')}
  belongs_to :area
  has_many :locations
  validates_presence_of :name, :area
  is_sluggable :name
end
