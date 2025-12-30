Feature: Location Entity Curation
  As a simulation administrator
  I want to manage stadium and location data
  So that simulations include realistic geographic factors

  Background:
    Given NFL stadium data is loaded

  # Stadium Data

  Scenario: Get stadium for team
    When I request stadium for team "KC"
    Then I receive stadium:
      | Name     | GEHA Field at Arrowhead Stadium |
      | Type     | OUTDOOR                         |
      | Surface  | NATURAL_GRASS                   |
      | Capacity | 76416                           |
      | Elevation| 820 ft                          |

  Scenario: List outdoor stadiums
    When I request all outdoor stadiums
    Then I receive stadiums exposed to weather
    And dome stadiums are not included

  Scenario: Identify high altitude venue
    When I check if Denver stadium is high altitude
    Then the result is true
    And elevation is 5280 feet
    And kicking stats should receive altitude modifier

  # Weather Zones

  Scenario: Get weather zone for stadium
    Given Lambeau Field is in weather zone "GREAT_LAKES"
    When I query the weather zone
    Then I receive climate type "CONTINENTAL"
    And snow probability for December is high

  Scenario: Generate weather for outdoor game
    Given a game at Buffalo in December
    When weather is generated
    Then conditions may include:
      | Snow        | 30% chance |
      | Cold        | Average 28F|
      | High winds  | 15% chance |

  Scenario: Dome stadium ignores weather
    Given a game at US Bank Stadium (dome)
    When weather is generated
    Then conditions are always ideal
    And no weather modifiers apply

  # Weather Effects

  Scenario: Rain reduces passing stats
    Given weather conditions:
      | Type        | RAIN      |
      | Intensity   | Moderate  |
      | Wind        | 10 mph    |
    When stat modifiers are calculated
    Then passing stats receive -10% modifier
    And rushing stats are unaffected

  Scenario: Snow has major impact
    Given weather conditions:
      | Type        | HEAVY_SNOW|
      | Temperature | 25F       |
      | Visibility  | 0.5 miles |
    When stat modifiers are calculated
    Then passing stats receive -35% modifier
    And kicking stats receive -25% modifier
    And injury probability increases

  Scenario: Extreme cold affects all stats
    Given weather conditions:
      | Type        | CLEAR     |
      | Temperature | 5F        |
      | Wind chill  | -15F      |
    When stat modifiers are calculated
    Then all offensive stats receive -15% modifier
    And fumble probability increases

  # Travel and Fatigue

  Scenario: Calculate travel distance
    When I calculate distance from Seattle to Miami
    Then distance is approximately 2735 miles
    And fatigue level is "EXTREME"
    And performance modifier is 0.88

  Scenario: Coast-to-coast travel impact
    Given team traveled from LA to NY (2450 miles)
    And they played 3 days after arrival
    When travel fatigue is calculated
    Then all players receive fatigue modifier
    And modifier is approximately -5%

  Scenario: Short travel minimal impact
    Given team traveled from Philadelphia to NY (95 miles)
    When travel fatigue is calculated
    Then fatigue level is "MINIMAL"
    And no performance modifier applies

  Scenario: Time zone change fatigue
    Given team traveled west to east (3 time zones)
    When travel fatigue is calculated
    Then additional modifier for timezone adjustment
    And eastward travel is harder than westward

  # Home Field Advantage

  Scenario: High noise stadium has stronger HFA
    Given Arrowhead Stadium has noise factor 1.2
    When home field advantage is calculated
    Then HFA modifier is higher than average
    And visiting team receives crowd noise penalty

  Scenario: Dome neutralizes weather HFA
    Given outdoor team plays at dome stadium
    When environmental factors are calculated
    Then weather-related advantages don't apply
    And only crowd factors remain

  # Integration

  Scenario: Weather event created from location
    Given a Week 15 game at Green Bay
    When simulation generates weather
    And conditions are HEAVY_SNOW
    Then a weather WorldEvent is created
    And event affects all players in game
    And narrative reflects weather conditions
