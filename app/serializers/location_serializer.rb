class LocationSerializer < BaseSerializer
  attributes :name,
    :address,
    :city,
    :postal_code,
    :latitude,
    :longitude,
    :phone,
    :url,
    :all_ages,
    :num_games

  def num_games
    object.machines.size
  end
end
