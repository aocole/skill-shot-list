class Location < ActiveRecord::Base
  default_scope order('locality_id asc, name asc')
  has_many :machines, :include => :title
  belongs_to :locality
  has_one :area, :through => :locality
  geocoded_by :full_street_address
  after_validation :geocode
  validates_presence_of :name, :locality
  is_sluggable :name

  def full_street_address
    [address, city, state, postal_code].compact.join(', ')
  end

end
