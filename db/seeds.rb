# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)
Locality.delete_all
Area.delete_all

seattle = Area.create({name: 'Seattle'})
belltown = Locality.create(name: "Belltown/Denny Regrade", area: seattle)
shortys = Location.create(
  name: "Shorty's",
  address: "2222 2nd Ave",
  city: "Seattle",
  state: "WA",
  postal_code: "98121",
  url: "http://shortydog.com/",
  phone: "(206) 441-5449",
  locality: belltown,
  all_ages: false
).save

[
    "Downtown",
    "Pioneer Square/International District",
    "SODO",
    "Queen Anne",
    "Eastlake",
    "Capitol Hill",
    "Central District/Madison Park",
    "U District/North Side",
    "Fremont/Wallingford",
    "Ballard",
    "Greenwood/Green Lake",
    "Georgetown",
    "West Seattle",
    "White Center",
    "Beacon Hill/Columbia City"
].each do |name|
  Locality.create({name: name, area: seattle})
end

king_county = Area.create({name: 'King County'})
[
    "Auburn",
    "Bellevue",
    "Burien",
    "Issaquah",
    "Kent",
    "Kenmore",
    "Kirkland",
    "Redmond",
    "Renton",
    "Tukwila"
].each do |name|
  Locality.create({name: name, area: king_county})
end

tacoma = Area.create({name: 'Tacoma'})
[
    "Downtown",
    "Enumclaw"
].each do |name|
  Locality.create({name: name, area: tacoma})
end

