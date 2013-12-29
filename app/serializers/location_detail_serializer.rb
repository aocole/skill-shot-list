class LocationDetailSerializer < LocationSerializer
  has_many :machines

  def machines
    object.machines.sort
  end
end
