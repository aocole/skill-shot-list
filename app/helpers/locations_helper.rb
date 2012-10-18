module LocationsHelper

  def map_url location
    q = [:address, :city, :state, :postal_code].collect{|attr|CGI.escape(location[attr])}.join('+')
    "https://maps.google.com/maps?q=#{q}"
  end

  def map_link location
    "(#{link_to 'map', map_url(location)})"
  end

end
