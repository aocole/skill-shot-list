class Location < ActiveRecord::Base
  acts_as_paranoid :columns => 'deleted_at', :column_type => 'time'
  DEFAULT_ORDER = "regexp_replace(name, '^The ', '')"
  default_scope -> {order("locality_id asc, #{DEFAULT_ORDER} asc")}
  has_many :machines, :include => :title, :dependent => :destroy
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
