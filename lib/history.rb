require 'yaml'
require 'colored'

class History
  def self.reconstruct_changes

    @@localities = Locality.unscoped
    @@localities = Hash[@@localities.collect{|loc| [loc.name, loc]}]

    @@locations = Location.unscoped
    @@locations = Hash[@@locations.collect{|loc| [loc.name, loc]}]
    @@locations['12th Ave Laundry'] = Location.find_by_cached_slug 'lather-daddy'
    @@locations['ADD Motor Works'] = Location.find_by_cached_slug 'add-a-ball-amusements'
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
  - Lylas Family Espresso
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
  - Artful Dodger Tattoo
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
      locality = @@localities[locality_name]
      raise "Couldn't find #{locality_name}" if locality.nil?
      location_names.each do |location_name|
        @@locations[location_name] = Location.new(locality: locality, name: location_name)
      end
    end

    @@titles = Title.unscoped.where("status is null or status != ?", Title::STATUS::HIDDEN)
    @@titles = Hash[@@titles.collect{|loc| [loc.name, loc]}]
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
      'JM', "Johnny Mnemonic",
      'WOZ', "The Wizard of Oz",
      'JP', "Jurassic Park",
      'Pinball', 'Pinball (SS)'
    ].each do |abbrev, name|
      @@titles[abbrev] = Title.where(name: name).first
      raise "Couldn't find #{name}" if @@titles[abbrev].nil?
    end

    machine_changes = []

    old_state = {}
    Dir.glob("#{Rails.root}/history/*.yml").sort.each do |filename|
      new_changes, new_state = created_changes_from_state_file(old_state, filename)
      machine_changes += new_changes
      old_state = new_state
    end

    # OK, now we're at a state after issue 31 (October 2013). It will still be a couple
    # months before I enable change tracking in the database, but issue 32 doesn't come
    # out until another month after that. Let's get the changes that issue 32 has recorded
    # and compare that to what we have in the database.
    issue_32_changes, new_state = created_changes_from_state_file(old_state, "#{Rails.root}/history/32._yml")

    # these ignorable changes are changes that I manually verified are in the DB already
    ignorable_changes = YAML.load_file("#{Rails.root}/history/ignore32._yml")
    issue_32_changes.delete_if do |change|
      change_in_words = change.to_words
      ignorable_changes.include?(change_in_words)
    end

    # Changes that are left are ones we missed
    machine_changes += issue_32_changes

    organic_machine_changes = MachineChange.
      where("localities.area_id = 1 AND machine_changes.updated_at != ?", Time.at(1387148957)).
      order('machine_changes.created_at asc').
                joins('
                  join machines on machines.id = machine_changes.machine_id 
                  join locations on locations.id = machines.location_id
                  join localities on localities.id = locations.locality_id
                  ')

    machine_changes += organic_machine_changes
    return machine_changes

  end

  def self.created_changes_from_state_file old_state, filename
    new_state = {}
    machine_changes = []
    issue = YAML.load_file(filename)
    date = Time.parse(issue.delete('__DATE__'))
    issue.each do |neighborhood, hood_locations|
      hood_locations.each do |location_pair|
        location_name = location_pair.first
        location = match_list(location_name, @@locations)
        new_state[location] = []
        games = location_pair.last
        games.each do |name|
          title = match_list(name, @@titles)
          new_state[location] << title
        end
      end
    end

    # resolve changes necessary to get to new_state from old_state
    new_state.each do |new_location, new_games|
      old_games = old_state.delete(new_location)
      if old_games.nil?
        # new_location is new this issue
        old_games = []
      end
      added_games = new_games - old_games
      removed_games = old_games - new_games
      added_games.each do |title|
        mc = MachineChange.new(
          change_type: MachineChange::ChangeType::CREATE, 
        )
        mc.machine = Machine.new(title: title, location: new_location)
        mc.created_at = date
        machine_changes << mc
      end
      removed_games.each do |title|
        mc = MachineChange.new(
          change_type: MachineChange::ChangeType::DELETE, 
        )
        mc.machine = Machine.new(title: title, location: new_location)
        mc.created_at = date
        machine_changes << mc
      end
    end

    # locations still left in old_state no longer exist, delete all their games
    old_state.each do |old_location, old_games|
      old_games.each do |title|
        mc = MachineChange.new(
          change_type: MachineChange::ChangeType::DELETE, 
        )
        mc.machine = Machine.new(title: title, location: old_location)
        mc.created_at = date
        machine_changes << mc
      end
      old_location.deleted_at = date
    end
    return machine_changes, new_state
  end

  def self.match_list(name, list)
    if list[name]
      return list[name]
    end
    regexp = Regexp.compile(name.sub(/\bthe \b/i, ''), Regexp::IGNORECASE)
    matches = list.keys.select{|n| n.gsub(/’/, "'") =~ regexp}.collect{|n| list[n] }
    if matches.size == 0
      raise "Couldn't find match for #{name}"
    elsif matches.size > 1
      raise "#{name} matched #{matches.collect(&:name).join(', ')}"
    else
      return matches.first
    end  
  end
end
