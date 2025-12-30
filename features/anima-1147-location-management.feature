@location-management @world-building @MVP-FOUNDATION
Feature: Location Management
  As a world creator
  I want to create and manage locations within my world
  So that characters and players can navigate and interact with different places

  Background:
    Given I am authenticated as a valid user
    And I have an active world named "Adventure World"
    And the world has a coordinate system configured

  # ==========================================
  # Create a Location
  # ==========================================

  @create @basic
  Scenario: Create a basic location with required fields
    Given I am on the location management page
    When I create a new location with:
      | name        | Mystic Forest           |
      | type        | wilderness              |
      | description | An ancient enchanted forest |
    Then the location should be created successfully
    And the location should have a unique identifier
    And the location should be visible in the world map

  @create @detailed
  Scenario: Create a location with full details
    Given I am creating a new location
    When I provide location details:
      | name         | Dragon's Lair                           |
      | type         | dungeon                                  |
      | description  | A cavernous lair deep in the mountains |
      | coordinates  | x: 150, y: 200, z: -50                  |
      | size         | large                                    |
      | terrain      | rocky                                    |
      | climate      | hot                                      |
      | danger_level | extreme                                  |
      | visibility   | hidden                                   |
    And I save the location
    Then the location should be created with all specified attributes
    And the location should appear at the specified coordinates

  @create @with-image
  Scenario: Create a location with visual assets
    Given I am creating a new location "Crystal Caverns"
    When I upload location assets:
      | asset_type   | file                    |
      | map_icon     | crystal_icon.png        |
      | background   | cavern_background.jpg   |
      | thumbnail    | cavern_thumb.png        |
      | ambient_art  | crystal_glow.gif        |
    And I save the location
    Then all visual assets should be associated with the location
    And assets should be displayed in appropriate contexts

  @create @from-template
  Scenario: Create a location from template
    Given location templates exist:
      | template_name | type       | default_properties           |
      | tavern        | building   | capacity: 50, indoor: true   |
      | village       | settlement | population: 200, shops: 5    |
      | forest        | wilderness | size: large, danger: low     |
    When I create a location from template "tavern"
    And I customize the name to "The Rusty Anchor"
    Then the location should inherit template properties
    And I should be able to override default values

  @create @batch
  Scenario: Batch create multiple locations
    Given I have a locations import file with 20 locations
    When I import the locations file
    Then all 20 locations should be created
    And each location should have valid identifiers
    And import summary should show success count

  @create @validation
  Scenario: Validate location creation requirements
    Given I am creating a new location
    When I attempt to save without required fields:
      | missing_field |
      | name          |
    Then I should see validation error "Name is required"
    And the location should not be created

  @create @duplicate-check
  Scenario: Prevent duplicate location names in same region
    Given a location "Market Square" exists in region "Capital City"
    When I create a new location named "Market Square" in region "Capital City"
    Then I should see warning about duplicate name
    And I should be prompted to confirm or rename

  # ==========================================
  # Create Location Hierarchy
  # ==========================================

  @hierarchy @parent-child
  Scenario: Create location with parent relationship
    Given a location "Kingdom of Valdris" exists with type "kingdom"
    When I create a child location:
      | name   | City of Thornhaven |
      | type   | city               |
      | parent | Kingdom of Valdris |
    Then "City of Thornhaven" should be a child of "Kingdom of Valdris"
    And the hierarchy should be reflected in navigation

  @hierarchy @multi-level
  Scenario: Create multi-level location hierarchy
    Given I create a hierarchy structure:
      | level | name              | parent            | type       |
      | 1     | The Realm         | null              | world      |
      | 2     | Northern Lands    | The Realm         | region     |
      | 3     | Frostpeak City    | Northern Lands    | city       |
      | 4     | Royal District    | Frostpeak City    | district   |
      | 5     | King's Palace     | Royal District    | building   |
      | 6     | Throne Room       | King's Palace     | room       |
    Then the full hierarchy should be navigable
    And breadcrumb navigation should show all levels

  @hierarchy @move
  Scenario: Move location to different parent
    Given "Village of Oakdale" is a child of "Eastern Province"
    When I move "Village of Oakdale" to parent "Western Province"
    Then "Village of Oakdale" should be a child of "Western Province"
    And it should no longer appear under "Eastern Province"
    And all child locations should move with it

  @hierarchy @orphan
  Scenario: Handle orphaned locations
    Given "Lost Temple" has no parent location
    When I view unassigned locations
    Then "Lost Temple" should appear in orphaned locations list
    And I should be able to assign it to a parent

  @hierarchy @circular-prevention
  Scenario: Prevent circular hierarchy references
    Given "Region A" is parent of "Region B"
    And "Region B" is parent of "Region C"
    When I attempt to set "Region C" as parent of "Region A"
    Then I should see error "Circular reference detected"
    And the hierarchy should remain unchanged

  @hierarchy @inheritance
  Scenario: Inherit properties from parent location
    Given "Dark Forest" has properties:
      | property     | value    |
      | danger_level | high     |
      | climate      | cold     |
      | faction      | neutral  |
    When I create child location "Witch's Cottage" without specifying these properties
    Then "Witch's Cottage" should inherit parent properties
    And inherited properties should be marked as such

  # ==========================================
  # Link Locations with Paths
  # ==========================================

  @paths @create
  Scenario: Create path between two locations
    Given locations exist:
      | name           |
      | Town Square    |
      | Harbor District|
    When I create a path:
      | from           | Town Square     |
      | to             | Harbor District |
      | name           | Harbor Road     |
      | type           | road            |
      | travel_time    | 10 minutes      |
      | bidirectional  | true            |
    Then the path should connect both locations
    And travel should be possible in both directions

  @paths @one-way
  Scenario: Create one-way path
    Given locations "Cliff Top" and "Valley Floor" exist
    When I create a one-way path:
      | from   | Cliff Top    |
      | to     | Valley Floor |
      | name   | Waterfall    |
      | type   | natural      |
    Then travel should only be possible from "Cliff Top" to "Valley Floor"
    And reverse travel should not be available

  @paths @requirements
  Scenario: Create path with travel requirements
    Given path "Mountain Pass" connects "Lowlands" and "Highland Village"
    When I set path requirements:
      | requirement        | value                    |
      | min_level          | 10                       |
      | required_item      | Climbing Gear            |
      | required_skill     | mountaineering >= 5      |
      | restricted_classes | none                     |
    Then only characters meeting requirements can use the path
    And requirements should be displayed to players

  @paths @conditional
  Scenario: Create conditionally available path
    Given path "Secret Tunnel" connects "Castle" and "Forest"
    When I set path conditions:
      | condition       | value                    |
      | time_available  | night_only               |
      | quest_required  | discover_secret_passage  |
      | faction_access  | thieves_guild            |
    Then the path should only be usable when conditions are met
    And hidden paths should not appear until discovered

  @paths @multiple
  Scenario: Create multiple paths between same locations
    Given locations "City Center" and "Market District" exist
    When I create multiple paths:
      | name          | type       | travel_time | cost   |
      | Main Street   | road       | 5 minutes   | free   |
      | Back Alley    | alley      | 3 minutes   | free   |
      | Carriage      | transport  | 2 minutes   | 5 gold |
    Then all paths should be available for travel
    And players should be able to choose their route

  @paths @dynamic
  Scenario: Dynamic path availability
    Given path "Frozen Lake Crossing" exists
    When I configure dynamic availability:
      | season  | available |
      | winter  | true      |
      | spring  | false     |
      | summer  | false     |
      | autumn  | false     |
    Then the path should only be usable in winter
    And status should update with season changes

  @paths @network
  Scenario: View location path network
    Given multiple locations with interconnecting paths exist
    When I view the path network map
    Then I should see all locations as nodes
    And all paths should be displayed as connections
    And path properties should be visible on hover

  # ==========================================
  # Assign Characters to Locations
  # ==========================================

  @characters @assign
  Scenario: Assign character to a location
    Given character "Sir Roland" exists
    And location "Castle Stronghold" exists
    When I assign "Sir Roland" to "Castle Stronghold"
    Then "Sir Roland" should be present at "Castle Stronghold"
    And the location's occupant list should include "Sir Roland"

  @characters @home-location
  Scenario: Set character home location
    Given character "Merchant Elara" exists
    When I set home location to "Market Square"
    Then "Market Square" should be the character's home
    And character should return home when no other location set
    And home location should be marked distinctly

  @characters @work-location
  Scenario: Set character work location with schedule
    Given character "Blacksmith Torgen" exists
    When I configure work location:
      | location  | The Forge         |
      | schedule  | 8:00 - 18:00      |
      | days      | Monday - Saturday |
    Then the character should be at "The Forge" during work hours
    And character should be at home location outside work hours

  @characters @patrol-route
  Scenario: Configure character patrol route
    Given character "Guard Captain" exists
    When I set patrol route:
      | sequence | location       | duration   |
      | 1        | Main Gate      | 30 minutes |
      | 2        | Wall North     | 20 minutes |
      | 3        | Tower East     | 15 minutes |
      | 4        | Wall South     | 20 minutes |
      | 5        | Main Gate      | repeat     |
    Then the character should follow the patrol route
    And current location should update based on time

  @characters @multiple-characters
  Scenario: Assign multiple characters to location
    Given location "Tavern" exists with capacity 30
    When I assign characters:
      | character_name  |
      | Bartender Bob   |
      | Waitress Mary   |
      | Bard Thomas     |
      | Patron 1-10     |
    Then all characters should be present at "Tavern"
    And location should show 13 occupants
    And occupant list should be viewable

  @characters @movement
  Scenario: Track character movement between locations
    Given character "Wandering Merchant" is at "Village A"
    When the character moves to "Village B" via "Trade Route"
    Then character location should update to "Village B"
    And movement should be logged with timestamp
    And travel time should be applied

  @characters @spawn
  Scenario: Configure character spawn location
    Given character template "Goblin Scout" exists
    When I set spawn configuration:
      | location     | Goblin Cave      |
      | max_spawns   | 5                |
      | respawn_time | 10 minutes       |
      | spawn_chance | 80%              |
    Then goblins should spawn at the specified location
    And spawn limits should be respected

  # ==========================================
  # Location-Based Events
  # ==========================================

  @events @trigger
  Scenario: Create location entry event
    Given location "Haunted Mansion" exists
    When I create an entry event:
      | trigger      | on_enter                              |
      | event_type   | narrative                             |
      | content      | A chill runs down your spine...       |
      | one_time     | false                                 |
    Then the event should trigger when players enter
    And the narrative should be displayed

  @events @exit
  Scenario: Create location exit event
    Given location "Safe Haven" exists
    When I create an exit event:
      | trigger     | on_exit                               |
      | event_type  | warning                               |
      | content     | Are you sure you want to leave safety?|
      | confirm     | true                                  |
    Then players should see confirmation when leaving
    And they should be able to cancel the exit

  @events @timed
  Scenario: Create timed location event
    Given location "Ancient Temple" exists
    When I create a timed event:
      | trigger_time | midnight                     |
      | event_type   | encounter                    |
      | description  | The temple awakens           |
      | spawn_entity | Temple Guardian              |
      | duration     | 1 hour                       |
    Then the event should trigger at midnight
    And the guardian should spawn for the duration

  @events @random
  Scenario: Configure random location events
    Given location "Wilderness Path" exists
    When I configure random events:
      | event_name      | chance | cooldown   |
      | Bandit Ambush   | 15%    | 30 minutes |
      | Merchant Meet   | 10%    | 1 hour     |
      | Weather Change  | 25%    | 15 minutes |
      | Wildlife Sight  | 40%    | 5 minutes  |
    Then events should trigger randomly based on chance
    And cooldowns should prevent rapid repetition

  @events @chain
  Scenario: Create chained location events
    Given location "Mystery Cave" exists
    When I create event chain:
      | step | event                  | next_trigger           |
      | 1    | Discover entrance      | enter_cave             |
      | 2    | Navigate darkness      | find_light             |
      | 3    | Reveal treasure        | solve_puzzle           |
      | 4    | Claim reward           | complete               |
    Then events should trigger in sequence
    And progress should be tracked per player

  @events @conditional
  Scenario: Create conditional location event
    Given location "Dragon's Den" exists
    When I create conditional event:
      | condition           | player_level >= 20 AND has_item('Dragon Bane') |
      | success_event       | Challenge the dragon                            |
      | failure_event       | The dragon ignores you                          |
    Then appropriate event should trigger based on conditions
    And players should understand requirements

  @events @scheduled
  Scenario: Schedule recurring location event
    Given location "Town Square" exists
    When I schedule recurring event:
      | name        | Weekly Market                |
      | schedule    | Every Saturday 9:00 - 17:00  |
      | effects     | spawn_merchants, reduce_prices|
    Then the event should occur on schedule
    And location should be modified during event

  # ==========================================
  # Dynamic Location Properties
  # ==========================================

  @dynamic @time-based
  Scenario: Configure time-based property changes
    Given location "City Streets" exists
    When I configure time-based properties:
      | time_period | lighting  | danger_level | crowd_density |
      | dawn        | dim       | low          | sparse        |
      | day         | bright    | very_low     | busy          |
      | dusk        | dim       | medium       | moderate      |
      | night       | dark      | high         | sparse        |
    Then properties should change based on game time
    And transitions should be smooth

  @dynamic @season-based
  Scenario: Configure seasonal property changes
    Given location "Forest Glade" exists
    When I configure seasonal properties:
      | season | foliage   | wildlife | resources        |
      | spring | budding   | active   | flowers, herbs   |
      | summer | lush      | abundant | berries, game    |
      | autumn | colorful  | moderate | mushrooms, nuts  |
      | winter | bare      | scarce   | firewood only    |
    Then properties should reflect current season
    And available resources should update

  @dynamic @player-actions
  Scenario: Properties change based on player actions
    Given location "Mining Town" exists with prosperity "medium"
    When players complete mining quests:
      | quest_count | prosperity_change |
      | 10          | +1 level          |
      | 25          | +1 level          |
      | 50          | +1 level          |
    Then town prosperity should increase
    And new services should become available

  @dynamic @degradation
  Scenario: Configure location degradation over time
    Given location "Abandoned Fort" exists
    When I configure degradation:
      | property         | rate          | min_value |
      | structural       | -1% per week  | 10%       |
      | cleanliness      | -2% per day   | 0%        |
      | defensive_rating | -0.5% per day | 20%       |
    Then properties should degrade over time
    And alerts should trigger at thresholds

  @dynamic @restoration
  Scenario: Restore degraded location properties
    Given "Ruined Temple" has structural integrity at 25%
    When players contribute to restoration:
      | resource    | quantity | effect        |
      | stone       | 100      | +10% struct   |
      | gold        | 500      | +5% struct    |
      | labor_hours | 50       | +15% struct   |
    Then structural integrity should improve
    And restoration progress should be tracked

  @dynamic @state-machine
  Scenario: Configure location state machine
    Given location "Contested Territory" exists
    When I define location states:
      | state       | transitions_to              | trigger                |
      | peaceful    | contested                   | enemy_presence         |
      | contested   | occupied, liberated         | battle_outcome         |
      | occupied    | contested                   | resistance_action      |
      | liberated   | peaceful                    | time_elapsed: 7 days   |
    Then location should transition between states
    And current state should affect gameplay

  # ==========================================
  # Location Capacity Limits
  # ==========================================

  @capacity @set
  Scenario: Set location capacity limit
    Given location "Small Tavern" exists
    When I set capacity limit to 25 occupants
    Then the capacity should be recorded
    And current occupancy should be tracked

  @capacity @enforce
  Scenario: Enforce capacity when limit reached
    Given location "Meeting Hall" has capacity 50
    And current occupancy is 50
    When a player attempts to enter
    Then entry should be denied
    And player should see message "Location is at capacity"

  @capacity @queue
  Scenario: Queue players when location is full
    Given location "Popular Shop" has capacity 10
    And the shop is at capacity
    When I enable queue system
    And a player attempts to enter
    Then the player should be added to queue
    And estimated wait time should be displayed

  @capacity @reservations
  Scenario: Allow capacity reservations
    Given location "Grand Theater" has capacity 200
    When I enable reservation system
    And 50 seats are reserved for "Royal Performance"
    Then available capacity should show 150
    And reserved seats should be held until event

  @capacity @dynamic
  Scenario: Configure dynamic capacity based on conditions
    Given location "Market Square" exists
    When I configure dynamic capacity:
      | condition        | capacity |
      | normal           | 100      |
      | market_day       | 200      |
      | festival         | 500      |
      | emergency        | 50       |
    Then capacity should adjust based on active condition
    And overflow handling should activate when needed

  @capacity @vip-override
  Scenario: Allow VIP override of capacity limits
    Given location "Exclusive Club" is at capacity
    When a player with "VIP" status attempts to enter
    Then entry should be allowed despite capacity
    And VIP entry should be logged

  @capacity @categories
  Scenario: Set capacity by occupant category
    Given location "Arena" exists
    When I set categorized capacity:
      | category     | limit |
      | combatants   | 20    |
      | spectators   | 500   |
      | staff        | 30    |
      | vip          | 50    |
    Then each category should have separate limits
    And total should not exceed overall capacity 600

  # ==========================================
  # Search Locations by Properties
  # ==========================================

  @search @basic
  Scenario: Search locations by name
    Given multiple locations exist in the world
    When I search for locations with name containing "Castle"
    Then I should see all locations with "Castle" in the name
    And results should be sorted by relevance

  @search @type
  Scenario: Search locations by type
    Given locations of various types exist
    When I filter locations by type "dungeon"
    Then only dungeon-type locations should appear
    And count should match total dungeons

  @search @properties
  Scenario: Search locations by property values
    Given locations with various danger levels exist
    When I search with criteria:
      | property     | operator | value  |
      | danger_level | >=       | high   |
      | has_treasure | =        | true   |
    Then only matching locations should appear
    And results should show matching properties

  @search @proximity
  Scenario: Search locations by proximity
    Given I am at location with coordinates x:100, y:100
    When I search for locations within 50 units
    Then only nearby locations should appear
    And results should be sorted by distance

  @search @connected
  Scenario: Search for connected locations
    Given I am at "Central Hub"
    When I search for directly connected locations
    Then all locations with paths from "Central Hub" should appear
    And path information should be included

  @search @available-services
  Scenario: Search locations by available services
    Given locations offer various services
    When I search for locations with services:
      | service     |
      | blacksmith  |
      | healer      |
      | inn         |
    Then locations offering all specified services should appear
    And service details should be shown

  @search @advanced
  Scenario: Advanced multi-criteria search
    Given a complex world with many locations
    When I perform advanced search:
      | criteria          | value                    |
      | type              | city OR town             |
      | region            | Northern Lands           |
      | population        | > 1000                   |
      | has_market        | true                     |
      | faction           | allied OR neutral        |
    Then only locations matching all criteria should appear
    And search should complete efficiently

  @search @save
  Scenario: Save and reuse search criteria
    Given I have performed a complex search
    When I save the search as "Trading Posts"
    Then the search should be saved to my profile
    And I should be able to execute it again by name

  # ==========================================
  # Location-Based Quests
  # ==========================================

  @quests @trigger
  Scenario: Quest triggers on location entry
    Given quest "Investigate the Ruins" exists
    And quest has trigger location "Ancient Ruins"
    When a player enters "Ancient Ruins" for the first time
    Then quest should be offered to the player
    And location should be marked as quest location

  @quests @objectives
  Scenario: Quest with location-based objectives
    Given quest "Patrol Duty" has objectives:
      | objective          | location        | action    |
      | Visit North Gate   | North Gate      | visit     |
      | Inspect Tower      | Watch Tower     | interact  |
      | Report to Captain  | Guard Barracks  | speak_npc |
    Then objectives should track location visits
    And progress should update on completion

  @quests @chain
  Scenario: Location quest chain
    Given quest chain "Mystery of the Forest" spans locations:
      | quest_step | location         | unlocks_location |
      | 1          | Forest Edge      | Deep Woods       |
      | 2          | Deep Woods       | Hidden Grove     |
      | 3          | Hidden Grove     | Ancient Tree     |
    Then completing each step should unlock next location
    And chain progress should be visible

  @quests @instance
  Scenario: Quest creates instanced location
    Given quest "Dungeon Delve" requires private instance
    When player accepts the quest
    Then a personal instance of "Dark Dungeon" should be created
    And instance should persist until quest completion
    And other players should not access this instance

  @quests @timed
  Scenario: Time-limited location quest
    Given quest "Race Against Time" is active
    When player must reach "Destination" within 10 minutes
    Then timer should start on quest acceptance
    And location should be reachable within time limit
    And quest should fail if time expires

  @quests @escort
  Scenario: Escort quest with location waypoints
    Given escort quest "Protect the Merchant" exists
    When I define waypoints:
      | sequence | location         | event_on_arrival      |
      | 1        | Town Gate        | escort_starts         |
      | 2        | Crossroads       | ambush_chance: 30%    |
      | 3        | Bridge           | rest_stop             |
      | 4        | Destination Town | quest_complete        |
    Then NPC should move between waypoints
    And events should trigger at each location

  # ==========================================
  # Weather Affects Locations
  # ==========================================

  @weather @effects
  Scenario: Weather affects location properties
    Given location "Open Field" has weather "storm"
    Then location properties should change:
      | property      | effect           |
      | visibility    | reduced to 50%   |
      | movement_speed| reduced by 25%   |
      | danger_level  | increased by 1   |
      | outdoor_npcs  | seek shelter     |

  @weather @regional
  Scenario: Weather varies by region
    Given regions have climate zones:
      | region         | climate    |
      | Northern Peaks | arctic     |
      | Central Plains | temperate  |
      | Southern Desert| arid       |
    When weather simulation runs
    Then each region should have appropriate weather
    And transitions between regions should be gradual

  @weather @forecast
  Scenario: Weather forecast for locations
    Given weather system is active
    When I check weather forecast for "Mountain Pass"
    Then I should see current conditions
    And I should see forecast for next 24 hours
    And severe weather warnings should be highlighted

  @weather @shelter
  Scenario: Locations provide shelter from weather
    Given outdoor weather is "blizzard"
    And location "Cozy Cabin" has shelter property
    When player enters "Cozy Cabin"
    Then weather effects should not apply
    And shelter status should be indicated

  @weather @seasonal
  Scenario: Seasonal weather patterns
    Given location "Mountain Path" is in temperate zone
    Then weather patterns should follow seasons:
      | season | common_weather              |
      | spring | rain, mild                  |
      | summer | sunny, occasional storms    |
      | autumn | fog, rain, wind             |
      | winter | snow, blizzard, cold        |

  @weather @extreme
  Scenario: Extreme weather makes location inaccessible
    Given location "Valley Pass" has active "avalanche"
    When player attempts to enter
    Then access should be blocked
    And message should explain hazard
    And alternative routes should be suggested

  @weather @player-impact
  Scenario: Weather impacts player activities at location
    Given player is at "Open Market" during "heavy rain"
    Then the following should be affected:
      | activity      | impact                    |
      | shopping      | fewer merchants available |
      | combat        | accuracy reduced          |
      | fire_skills   | effectiveness reduced     |
      | lightning     | effectiveness increased   |

  # ==========================================
  # Location Instances and Phases
  # ==========================================

  @instances @personal
  Scenario: Create personal location instance
    Given location "Personal Quarters" supports instancing
    When player claims the location
    Then a personal instance should be created
    And only the player should have access
    And instance state should persist

  @instances @party
  Scenario: Create party instance for dungeon
    Given party of 5 players exists
    And location "Raid Dungeon" supports party instances
    When party leader initiates instance
    Then all party members should enter same instance
    And instance should be isolated from other parties

  @instances @phased
  Scenario: Location phases based on quest progress
    Given location "Burning Village" has phases:
      | phase | quest_state    | appearance                    |
      | 1     | not_started    | peaceful village              |
      | 2     | in_progress    | village under attack          |
      | 3     | completed      | rebuilt village               |
    Then players should see phase matching their progress
    And different players may see different phases

  @instances @reset
  Scenario: Reset location instance
    Given player's instance of "Personal Mine" exists
    When player requests instance reset
    Then resources should respawn
    And enemies should reset
    And player progress items should remain

  # ==========================================
  # Location Access Control
  # ==========================================

  @access @level-gate
  Scenario: Level-gated location access
    Given location "High Level Zone" requires level 50
    When level 30 player attempts to enter
    Then access should be denied
    And level requirement should be displayed

  @access @faction
  Scenario: Faction-based location access
    Given location "Guild Hall" is faction-restricted
    When I configure access:
      | faction        | access_level |
      | guild_members  | full         |
      | allies         | limited      |
      | neutral        | none         |
      | enemies        | hostile      |
    Then access should be enforced based on faction
    And hostile entry should trigger guards

  @access @time-locked
  Scenario: Time-locked location access
    Given location "Night Market" is only accessible at night
    When player attempts to enter during day
    Then access should be denied
    And next available time should be shown

  @access @key-required
  Scenario: Location requires key item
    Given location "Treasury Vault" requires "Master Key"
    When player with key attempts to enter
    Then access should be granted
    And key usage should be logged

  @access @reputation
  Scenario: Reputation-based location access
    Given location "Elite Club" requires reputation 1000 with "Merchants Guild"
    When player with 500 reputation attempts to enter
    Then access should be denied
    And current reputation and requirement should be shown

  # ==========================================
  # Location Analytics and Management
  # ==========================================

  @analytics @traffic
  Scenario: View location traffic analytics
    Given location "Popular Tavern" has visitor tracking
    When I view traffic analytics
    Then I should see visitor counts over time
    And I should see peak hours
    And I should see average visit duration

  @analytics @heatmap
  Scenario: Generate world location heatmap
    Given player movement data is collected
    When I generate location heatmap
    Then I should see visual representation of traffic
    And I should identify popular and unpopular areas

  @management @bulk-edit
  Scenario: Bulk edit location properties
    Given I select 20 locations in "Forest Region"
    When I bulk update property "danger_level" to "medium"
    Then all 20 locations should be updated
    And changes should be logged

  @management @export
  Scenario: Export location data
    Given I want to backup location configuration
    When I export location data for "Northern Region"
    Then I should receive a structured data file
    And file should include all location properties
    And file should include relationships and paths

  @management @import
  Scenario: Import location data from file
    Given I have a location data file from another world
    When I import the location data
    Then new locations should be created
    And identifiers should be regenerated
    And conflicts should be reported

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @not-found
  Scenario: Handle location not found
    Given location "NonExistent Place" does not exist
    When I attempt to navigate to it
    Then I should see error "Location not found"
    And I should remain at current location

  @error-handling @concurrent
  Scenario: Handle concurrent location modifications
    Given two users are editing "Shared Location"
    When both save changes simultaneously
    Then conflict should be detected
    And merge or override options should be presented

  @error-handling @delete-occupied
  Scenario: Prevent deletion of occupied location
    Given location "Busy Market" has active players
    When I attempt to delete the location
    Then deletion should be prevented
    And I should be prompted to relocate occupants first

  @edge-case @max-hierarchy
  Scenario: Handle maximum hierarchy depth
    Given hierarchy depth limit is 10 levels
    When I attempt to create 11th level location
    Then I should see warning about depth limit
    And alternative organization should be suggested

  @edge-case @many-connections
  Scenario: Handle location with many path connections
    Given location "Grand Central" has 50 path connections
    When I view the location
    Then all connections should be accessible
    And performance should not be impacted
    And connections should be paginated if needed

  @edge-case @special-characters
  Scenario: Handle special characters in location names
    Given I create location with name "The Dragon's Lair & Hoard"
    Then the location should be created successfully
    And name should be properly escaped for storage
    And name should display correctly everywhere

  @edge-case @coordinates-overlap
  Scenario: Handle overlapping location coordinates
    Given location "Building A" occupies coordinates (100,100) to (150,150)
    When I create "Building B" at overlapping coordinates (140,140) to (190,190)
    Then I should see overlap warning
    And I should choose to allow or adjust coordinates
