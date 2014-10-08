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
locations = Location.unscoped
locations = Hash[locations.collect{|loc| [loc.name, loc]}]
locations['12th Ave Laundry'] = Location.find_by_cached_slug 'lather-daddy'

localities = Locality.unscoped
localities = Hash[localities.collect{|loc| [loc.name, loc]}]

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
  'GNR', "Guns N' Roses"
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

