Feature: NFL Player Data Retrieval via SportsData.io Fantasy API
  As a system
  I want to retrieve NFL player data from SportsData.io Fantasy API
  So that users can search, select, and view individual NFL players for roster building

  Background:
    Given the system is configured with SportsData.io API credentials
    And the API base URL is "https://api.sportsdata.io/v3/nfl"
    And the current NFL season is 2024

  # Get Player By ID

  Scenario: Retrieve individual player by PlayerID
    Given the player "Patrick Mahomes" has PlayerID "14876"
    When the system requests GET "/stats/json/Player/14876"
    Then the API returns HTTP 200 OK
    And the response includes player data:
      | PlayerID      | 14876            |
      | FirstName     | Patrick          |
      | LastName      | Mahomes          |
      | Position      | QB               |
      | Team          | KC               |
      | Number        | 15               |
      | Status        | Active           |
      | Height        | 75               |
      | Weight        | 230              |
      | BirthDate     | 1995-09-17       |
      | College       | Texas Tech       |
      | Experience    | 7                |
    And the player data is stored in the local database

  Scenario: Request player with invalid PlayerID
    When the system requests GET "/stats/json/Player/999999"
    Then the API returns HTTP 404 Not Found
    And the system logs "Player not found: 999999"
    And no player data is stored

  Scenario: Request player with null PlayerID
    When the system requests GET "/stats/json/Player/null"
    Then the request is rejected with error "INVALID_PLAYER_ID"
    And no API call is made

  # Search Players

  Scenario: Search players by name
    When the system searches for players with name "Mahomes"
    Then the API returns a list of matching players:
      | PlayerID | FirstName | LastName | Position | Team |
      | 14876    | Patrick   | Mahomes  | QB       | KC   |
    And results are sorted by relevance
    And the search results are cached for 1 hour

  Scenario: Search players by partial name
    When the system searches for players with name "Pat"
    Then the API returns all players with "Pat" in their name:
      | PlayerID | FirstName | LastName     | Position | Team |
      | 14876    | Patrick   | Mahomes      | QB       | KC   |
      | 12345    | Patrick   | Surtain      | CB       | DEN  |
    And results are case-insensitive

  Scenario: Search players with no matches
    When the system searches for players with name "XYZ123NotReal"
    Then the API returns an empty list
    And the response includes message "No players found"

  Scenario: Search players with special characters
    When the system searches for players with name "O'Brien"
    Then the API handles the apostrophe correctly
    And returns players matching "O'Brien"

  # Get Players by Team

  Scenario: Retrieve all players on a specific team
    Given the system needs roster data for "Kansas City Chiefs"
    When the system requests GET "/stats/json/Players/KC"
    Then the API returns HTTP 200 OK
    And the response includes all players on the KC roster
    And players are grouped by position:
      | QB | 2-3 players    |
      | RB | 4-6 players    |
      | WR | 6-8 players    |
      | TE | 3-4 players    |
      | K  | 1-2 players    |
      | DEF| 15+ players    |
    And the team roster is cached for 24 hours

  Scenario: Request players for invalid team abbreviation
    When the system requests GET "/stats/json/Players/INVALID"
    Then the API returns HTTP 404 Not Found
    And the system logs "Team not found: INVALID"

  Scenario: Request players for team with bye week
    Given "Kansas City Chiefs" has bye week 12
    And the current NFL week is 12
    When the system requests GET "/stats/json/Players/KC"
    Then the API returns all KC players
    And each player includes bye week indicator:
      | ByeWeek | 12 |
    And the UI displays bye week warning

  # Get Players by Position

  Scenario: Retrieve all quarterbacks
    When the system requests all players at position "QB"
    Then the API returns all active NFL quarterbacks
    And results are paginated with default page size 50
    And each player includes:
      | PlayerID        |
      | Name            |
      | Team            |
      | Position        |
      | Status          |
      | ByeWeek         |
    And results are sorted by team alphabetically

  Scenario: Retrieve all available players for a position
    Given a user is building their roster
    And the user needs to fill the RB position
    When the system requests GET "/stats/json/PlayersByAvailable"
    And filters by Position = "RB"
    Then the API returns all active running backs
    And inactive/injured players are excluded
    And results include fantasy-relevant metadata

  Scenario: Filter players by multiple positions (FLEX)
    Given a user is filling a FLEX position (RB/WR/TE eligible)
    When the system requests players with Position IN ["RB", "WR", "TE"]
    Then the API returns all players matching those positions
    And results are sorted by fantasy points (descending)
    And the user can filter further by team or name

  # Get Players by Availability Status

  Scenario: Retrieve only active players
    When the system requests GET "/stats/json/PlayersByAvailable"
    Then the API returns players with Status = "Active"
    And excludes players with Status IN ["Injured", "Suspended", "Inactive", "Retired"]
    And the response includes 1,500+ active players

  Scenario: Retrieve free agent players
    When the system requests GET "/stats/json/PlayersByFreeAgents"
    Then the API returns players not currently on a team roster
    And each player has Team = null or Team = "FA"
    And free agents are available for signing

  Scenario: Retrieve rookie players by draft year
    Given the current season is 2024
    When the system requests GET "/stats/json/PlayersByRookieDraftYear/2024"
    Then the API returns all 2024 NFL Draft picks
    And includes undrafted free agents from 2024
    And each player includes draft information:
      | DraftRound     |
      | DraftPick      |
      | DraftTeam      |
      | College        |

  # Player Search with Filters

  Scenario: Search with position filter
    When the system searches for "Patrick" with Position = "QB"
    Then the API returns only quarterbacks named Patrick
    And excludes players at other positions

  Scenario: Search with team filter
    When the system searches for players on Team = "KC"
    Then the API returns all Kansas City Chiefs players
    And results include all positions

  Scenario: Search with combined filters
    When the system searches with filters:
      | Name     | Smith  |
      | Position | WR     |
      | Team     | PHI    |
    Then the API returns only WRs named Smith on Philadelphia Eagles
    And results match all filter criteria

  # Pagination for Player Search

  Scenario: Paginate player search results with default page size
    Given a search for "Smith" returns 100 players
    When the client requests results without pagination parameters
    Then the response includes 50 players (default page size)
    And pagination metadata shows:
      | page          | 0   |
      | size          | 50  |
      | totalElements | 100 |
      | totalPages    | 2   |
      | hasNext       | true|

  Scenario: Request specific page of player results
    Given a search returns 100 players
    When the client requests page 1 with size 25
    Then the response includes players 26-50
    And pagination shows current page and total pages

  Scenario: Request page beyond available results
    Given a search returns 30 players
    When the client requests page 5 with size 20
    Then the response returns an empty list
    And pagination shows page 5 is beyond available data

  # Player Metadata

  Scenario: Retrieve player with complete metadata
    When the system requests player "Christian McCaffrey"
    Then the response includes comprehensive metadata:
      | PlayerID              | 15487                |
      | Name                  | Christian McCaffrey  |
      | Position              | RB                   |
      | Team                  | SF                   |
      | Number                | 23                   |
      | Height                | 71 inches            |
      | Weight                | 205 lbs              |
      | BirthDate             | 1996-06-07           |
      | College               | Stanford             |
      | Experience            | 7 years              |
      | Status                | Active               |
      | InjuryStatus          | Healthy              |
      | FantasyPosition       | RB                   |
      | DepthChartOrder       | 1                    |
      | ByeWeek               | 9                    |
      | PhotoUrl              | https://...          |
      | LastUpdated           | 2024-09-15T10:30:00Z |

  Scenario: Handle player with injury status
    Given "Saquon Barkley" has InjuryStatus = "Questionable"
    And InjuryBodyPart = "Ankle"
    When the system retrieves player data
    Then the response includes injury information:
      | InjuryStatus        | Questionable |
      | InjuryBodyPart      | Ankle        |
      | InjuryStartDate     | 2024-09-10   |
      | InjuryNotes         | Limited in practice |
    And the UI displays injury warning icon

  # Player Stats Summary

  Scenario: Retrieve player with season stats summary
    Given "Patrick Mahomes" has played 8 games in 2024 season
    When the system requests player data with stats summary
    Then the response includes season aggregates:
      | GamesPlayed       | 8     |
      | PassingYards      | 2,400 |
      | PassingTouchdowns | 20    |
      | Interceptions     | 4     |
      | FantasyPoints     | 196.5 |
      | FantasyPointsPPR  | 196.5 |
      | AveragePoints     | 24.6  |

  # Error Handling

  Scenario: Handle API timeout when retrieving player
    Given the SportsData.io API is experiencing delays
    When the system requests player data
    And the request times out after 10 seconds
    Then the system returns error "API_TIMEOUT"
    And the system retries the request after 5 seconds
    And uses cached player data if available
    And logs the timeout for monitoring

  Scenario: Handle malformed API response
    Given the SportsData.io API returns invalid JSON
    When the system attempts to parse the response
    Then the system catches the parsing error
    And returns error "INVALID_RESPONSE_FORMAT"
    And logs the raw response for debugging
    And does not update local database

  Scenario: Handle missing required fields
    Given the API response is missing "PlayerID" field
    When the system validates the response
    Then the system rejects the data
    And returns error "MISSING_REQUIRED_FIELD"
    And logs which fields are missing

  # Performance Optimization

  Scenario: Batch retrieve multiple players
    Given the system needs data for 10 players
    When the system requests player data
    Then the requests are batched into a single API call
    And all 10 players are returned in one response
    And API call count is minimized

  Scenario: Use cached player data when available
    Given player "Patrick Mahomes" was fetched 10 minutes ago
    And the cache TTL is 1 hour
    When the system requests the same player again
    Then the cached data is returned
    And no API call is made
    And cache hit is recorded in metrics

  Scenario: Refresh stale player data
    Given player data was cached 25 hours ago
    And the cache TTL is 24 hours
    When the system requests the player
    Then the cache is expired
    And a new API call is made
    And the cache is updated with fresh data

  # Data Validation

  Scenario: Validate player position enum
    Given the API returns Position = "QB"
    When the system validates the position
    Then the position is recognized as valid
    And maps to internal Position enum

  Scenario: Reject invalid position value
    Given the API returns Position = "INVALID_POS"
    When the system validates the position
    Then the system rejects the data
    And logs validation error
    And does not store invalid data

  Scenario: Sanitize player names with special characters
    Given the API returns Name = "D'Onta Foreman"
    When the system processes the name
    Then the apostrophe is preserved correctly
    And the name is stored as "D'Onta Foreman"
    And search handles the apostrophe correctly

  # Integration with Roster Building

  Scenario: Retrieve players for roster building UI
    Given a user is building their fantasy roster
    When the user searches for a quarterback
    Then the system returns active QBs from SportsData.io
    And includes fantasy-relevant information:
      | Name              |
      | Team              |
      | ByeWeek           |
      | InjuryStatus      |
      | Season stats      |
      | Projected points  |
    And results are optimized for UI display

  Scenario: Check player eligibility for position
    Given a user is filling the FLEX position
    And "Christian McCaffrey" has Position = "RB"
    When the system checks eligibility
    Then "Christian McCaffrey" is eligible for FLEX
    Because FLEX accepts RB, WR, TE

  Scenario: Prevent selecting same player twice
    Given a user has already selected "Patrick Mahomes" at QB
    When the user tries to add "Patrick Mahomes" at Superflex
    Then the system checks for duplicates
    And prevents duplicate selection
    And displays error "Player already in roster"

  # Real-world Edge Cases

  Scenario: Handle player traded mid-season
    Given "Player X" was on Team "SF" yesterday
    And "Player X" is traded to Team "KC" today
    When the system fetches updated player data
    Then the player Team is updated to "KC"
    And the bye week is updated to KC's bye week
    And users with "Player X" are notified of the change

  Scenario: Handle player status change (Active to Injured Reserve)
    Given "Player Y" has Status = "Active"
    When "Player Y" is placed on Injured Reserve
    And the system fetches updated data
    Then the Status changes to "InjuredReserve"
    And users with "Player Y" are notified
    And projected points are updated to 0

  Scenario: Handle player retirement announcement
    Given "Player Z" is active in the league
    When "Player Z" announces retirement mid-season
    And the system fetches updated data
    Then the Status changes to "Retired"
    And the player is removed from available players list
    And users with "Player Z" in roster are notified
