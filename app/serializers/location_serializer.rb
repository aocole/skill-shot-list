class LocationSerializer < BaseSerializer
  attributes :name,
    :address,
    :city,
    :postal_code,
    :latitude,
    :longitude,
    :phone,
    :url,
    :all_ages
end
