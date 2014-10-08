m = MachineChange.
      where("localities.area_id = 1").
      order('created_at desc').
                joins('
                  join machines on machines.id = machine_changes.machine_id 
                  join locations on locations.id = machines.location_id
                  join localities on localities.id = locations.locality_id
                  ')


require 'yaml'
require 'colored'

localities = Locality.unscoped
localities = Hash[localities.collect{|loc| [loc.name, loc]}]

locations = Location.unscoped
locations = Hash[locations.collect{|loc| [loc.name, loc]}]
locations['12th Ave Laundry'] = Location.find_by_cached_slug 'lather-daddy'
locations['ADD Motor Works'] = Location.find_by_cached_slug 'add-a-ball-amusements'
old_locations =<<END
---
Downtown:
  - Thistle
  - Fenix
Columbia City:
  - AMF Imperial Lanes
U District/North Side:
  - Galway Arms
  - Piccolo's Pizza
  - Rat and Raven
  - Cafe Racer
  - South Campus Center
  - Pink Gorilla
  - Shanty Tavern
  - Resevoir
  - Caroline Tavern
Greenwood/Green Lake:
  - Little Red Hen
  - Sundown Saloon
  - Sweet Lou's
SODO:
  - Goldies
  - Club Motor
Georgetown:
  - Calamity Jane's
  - Tiger Lounge
  - Auto Quest
  - Uncle Mo's
Pioneer Square/International District:
  - Cowgirls Inc
  - Fuel
Belltown/Denny Regrade:
  - 5 Point Laundry
  - Lava Lounge
  - Nite Lite
Capitol Hill:
  - Elite
  - Auto Battery
  - Chieftain
  - Wild Rose
  - Neighbours
  - Eagle
  - King Cobra
  - Elite
Fremont/Wallingford:
  - Fremont Dock
  - High Dive
  - Buckaroo Tavern
  - Dubliner
  - Sock Monster
  - Pete's Fremont Fire Pit
Ballard:
  - Snoose Junction
  - Molly Maguires
  - Zesto's
  - Goofy's
Eastlake:
  - El Corazon
  - Cafe Venus
Queen Anne:
  - Jabu's
  - Jillian's
  - Funhouse
  - Hula Hula
  - Floyd's Place
  - Fun Forest Arcade
  - Ozzie's
  - Spectator
  - Bandit's
West Seattle:
  - Alki Tavern
  - Rocksports
  - Shipwreck Tavern
  - Admiral Pub
  - Feedback Lounge
  - Roxbury Lanes
  - Tug Tavern
White Center:
  - Barrel Tavern
  - Brewsky's
  - Papa's
  - Marv's Boiler
  - Wall Bar
South Lake Union:
  - Lunch Box Laboratory
END
old_locations = YAML.load(old_locations)
old_locations.each do |locality_name, location_names|
  locality = localities[locality_name]
  raise "Couldn't find #{locality_name}" if locality.nil?
  location_names.each do |location_name|
    locations[location_name] = Location.new(locality: locality, name: location_name)
  end
end

titles = Title.unscoped
titles = Hash[titles.collect{|loc| [loc.name, loc]}]
Hash[
  'SP', 'South Park',
  'SW', 'Star Wars (Data East)',
  'AFM', 'Attack from Mars',
  'T3', 'Terminator 3: Rise of the Machines',
  'TSPP', 'The Simpsons Pinball Party',
  'POTC', 'Pirates of the Caribbean',
  'TAF', 'The Addams Family',
  'CP', 'The Champion Pub',
  'FGY', 'Family Guy',
  'EK', 'Evel Knievel',
  'JY', 'Junk Yard',
  'LOTR', 'The Lord of the Rings',
  'MM', 'Medieval Madness',
  'MB', 'Monster Bash',
  'RFM', 'Revenge From Mars',
  'SM', 'Spider-Man',
  'STTNG', 'Star Trek: The Next Generation',
  'WOF', 'Wheel Of Fortune',
  'BSD', 'Bram Stoker\'s Dracula',
  'PZ', 'The Party Zone',
  'WCS', 'World Cup Soccer',
  'Getaway', 'The Getaway: High Speed II',
  'SS', 'Scared Stiff',
  'CFTBL', 'Creature from the Black Lagoon',
  'FH', 'Funhouse',
  'SWE1', 'Star Wars Episode I',
  'FT', 'Fish Tales',
  'CC', 'Cactus Canyon',
  'TZ', 'Twilight Zone',
  'DM', 'Demolition Man',
  'TOM', 'Theatre of Magic',
  'DW', 'Doctor Who',
  'TOTAN', 'Tales of the Arabian Nights',
  'T2', 'Terminator 2: Judgment Day',
  'NGG', 'No Good Gofers',
  'IJ', 'Indiana Jones (Williams)',
  'IJ(S)', 'Indiana Jones (Stern)',
  'GNR', "Guns N' Roses",
  'IM', "Iron Man",
  'TRON', "TRON Legacy",
  'Shadow', "The Shadow",
  'RS', "Red & Ted's Road Show",
  'DESW', "Star Wars (Data East)",
  'Jack-Bot', "JackBot",
  'Pinbot', "PINBOT",
  'Four Million BC', "Four Million B.C.",
  'Hulk', 'The Incredible Hulk',
  'Transformers', 'Transformers (Pro)',
  'ST', "Star Trek (Data East)",
  'BBH', 'Big Buck Hunter Pro',
  'EBD', 'Eight Ball Deluxe (1980 Bally)',
  'RBION', "Ripley's Believe It or Not!",
  'EATPM', "Elvira and the Party Monsters",
  'WPT', "World Poker Tour",
  'JM', "Johnny Mnemonic"
].each do |abbrev, name|
  titles[abbrev] = Title.where(name: name).first
  raise "Couldn't find #{name}" if titles[abbrev].nil?
end

def match_list(name, list)
  if list[name]
    # puts "#{name} => #{list[name].name}".green
    return list[name]
  end
  regexp = Regexp.compile(name.sub(/\bthe \b/i, ''), Regexp::IGNORECASE)
  matches = list.keys.select{|name| name.gsub(/’/, "'") =~ regexp}.collect{|name|list[name]}
  if matches.size == 0
    puts "Couldn't find match for #{name}".red
  elsif matches.size > 1
    puts "#{name} matched #{matches.collect(&:name).join(', ')}".red
  else
    return matches.first
    # puts "#{name} => #{matches.first.name}".green
  end  
end

Dir.glob("history/*.yml").each do |filename|
  state = YAML.load_file(filename)
  state.each do |neighborhood, hood_locations|

    hood_locations.each do |location|
      location_name = location.first
      match_list(location_name, locations)

      games = location.last
      games.each do |name|
        match_list(name, titles)
      end

    end
  end
end 

