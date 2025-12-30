Feature: NFL Player Data Retrieval via SportsData.io Fantasy API
  As a system
  I want to retrieve NFL player data from SportsData.io Fantasy API
  So that users can search, select, and view individual NFL players for roster building

  Background:
    Given the system is configured with SportsData.io API credentials
    And the API base URL is "https://api.sportsdata.io/v3/nfl"
    And the current NFL season is 2024
    And player data caching is enabled

  # ============================================================================
  # GET PLAYER BY ID
  # ============================================================================

  @player-retrieval @by-id
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
    And the response is cached for 1 hour

  @player-retrieval @by-id @error
  Scenario: Request player with invalid PlayerID
    When the system requests GET "/stats/json/Player/999999"
    Then the API returns HTTP 404 Not Found
    And the system logs "Player not found: 999999"
    And no player data is stored
    And the "not found" result is cached for 5 minutes

  @player-retrieval @by-id @validation
  Scenario: Request player with null PlayerID
    When the system requests GET "/stats/json/Player/null"
    Then the request is rejected with error "INVALID_PLAYER_ID"
    And no API call is made
    And error message says "PlayerID must be a positive integer"

  @player-retrieval @by-id @validation
  Scenario: Request player with negative PlayerID
    When the system requests GET "/stats/json/Player/-123"
    Then the request is rejected with error "INVALID_PLAYER_ID"
    And no API call is made
    And validation prevents malformed requests

  @player-retrieval @by-id @validation
  Scenario: Request player with non-numeric PlayerID
    When the system requests GET "/stats/json/Player/abc123"
    Then the request is rejected with error "INVALID_PLAYER_ID"
    And error message includes "PlayerID must be numeric"

  @player-retrieval @batch
  Scenario: Retrieve multiple players by ID in batch
    Given the system needs data for players with IDs [14876, 15487, 18890]
    When the system requests batch player data
    Then a single API call retrieves all 3 players
    And the response includes data for each player
    And all players are cached individually
    And API call count is minimized

  @player-retrieval @batch @partial-failure
  Scenario: Handle partial failure in batch retrieval
    Given the system requests players with IDs [14876, 999999, 15487]
    When the batch request is processed
    Then players 14876 and 15487 are returned successfully
    And player 999999 is marked as not found
    And partial results are returned to the caller
    And not-found IDs are logged

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @player-search @by-name
  Scenario: Search players by exact name
    When the system searches for players with name "Patrick Mahomes"
    Then the API returns exact match first:
      | PlayerID | FirstName | LastName | Position | Team |
      | 14876    | Patrick   | Mahomes  | QB       | KC   |
    And results are sorted by relevance score
    And the search results are cached for 1 hour

  @player-search @by-name
  Scenario: Search players by partial name
    When the system searches for players with name "Pat"
    Then the API returns all players with "Pat" in their name:
      | PlayerID | FirstName | LastName     | Position | Team |
      | 14876    | Patrick   | Mahomes      | QB       | KC   |
      | 12345    | Patrick   | Surtain      | CB       | DEN  |
      | 23456    | Pat       | Freiermuth   | TE       | PIT  |
    And results are case-insensitive
    And first name matches rank higher than last name matches

  @player-search @by-name
  Scenario: Search players by last name only
    When the system searches for players with name "Smith"
    Then the API returns all players with last name "Smith"
    And results are sorted by fantasy relevance (starters first)
    And pagination is available for large result sets

  @player-search @fuzzy
  Scenario: Search players with fuzzy matching
    When the system searches for players with name "Mahommes"
    Then the API returns fuzzy matches including "Mahomes"
    And fuzzy matches have lower relevance score
    And exact matches appear before fuzzy matches
    And Levenshtein distance of 2 or less is acceptable

  @player-search @fuzzy
  Scenario: Search players with common misspellings
    When the system searches for "Jamar Chase"
    Then the API returns "Ja'Marr Chase" as a match
    And handles missing apostrophes gracefully
    And handles double letter variations

  @player-search @autocomplete
  Scenario: Provide autocomplete suggestions while typing
    When the user types "Mah" in the search field
    Then the system returns top 10 autocomplete suggestions:
      | Name            | Position | Team |
      | Patrick Mahomes | QB       | KC   |
      | Roma Mahdi      | RB       | LAR  |
    And suggestions are returned within 100ms
    And suggestions update as user types more characters

  @player-search @autocomplete
  Scenario: Autocomplete with minimum character threshold
    When the user types "Ma" in the search field
    Then the system waits for at least 3 characters
    And returns message "Type at least 3 characters"
    And prevents overly broad searches

  @player-search @empty
  Scenario: Search players with no matches
    When the system searches for players with name "XYZ123NotReal"
    Then the API returns an empty list
    And the response includes message "No players found matching 'XYZ123NotReal'"
    And suggestions are provided: "Try searching by team or position"

  @player-search @special-characters
  Scenario: Search players with apostrophes in name
    When the system searches for players with name "O'Brien"
    Then the API handles the apostrophe correctly
    And returns players matching "O'Brien"
    And apostrophe is properly escaped in API request

  @player-search @special-characters
  Scenario: Search players with hyphens in name
    When the system searches for players with name "Beckham-Jr"
    Then the API returns Odell Beckham Jr.
    And handles hyphenated names correctly
    And matches with or without hyphen

  @player-search @special-characters
  Scenario: Search players with diacritical marks
    When the system searches for players with name "Hernandez"
    Then the API returns players matching with or without accent marks
    And "Hernandez" matches "Hernández"
    And Unicode normalization is applied

  @player-search @injection-prevention
  Scenario: Prevent SQL injection in search
    When the system searches for "Robert'; DROP TABLE players;--"
    Then the input is sanitized before processing
    And special characters are escaped
    And no SQL injection occurs
    And search executes safely

  # ============================================================================
  # GET PLAYERS BY TEAM
  # ============================================================================

  @player-team @roster
  Scenario: Retrieve all players on a specific team
    Given the system needs roster data for "Kansas City Chiefs"
    When the system requests GET "/stats/json/Players/KC"
    Then the API returns HTTP 200 OK
    And the response includes all players on the KC roster
    And players are grouped by position:
      | Position | Count    |
      | QB       | 2-3      |
      | RB       | 4-6      |
      | WR       | 6-8      |
      | TE       | 3-4      |
      | K        | 1-2      |
      | DEF      | 15+      |
    And the team roster is cached for 24 hours

  @player-team @roster
  Scenario: Retrieve team roster with depth chart order
    When the system requests GET "/stats/json/Players/KC" with depth chart
    Then players are ordered by depth chart position:
      | Position | DepthOrder | Player          |
      | QB       | 1          | Patrick Mahomes |
      | QB       | 2          | Blaine Gabbert  |
      | RB       | 1          | Isiah Pacheco   |
      | RB       | 2          | Clyde Edwards   |
    And starters are clearly identified
    And backup information is included

  @player-team @practice-squad
  Scenario: Retrieve team practice squad separately
    When the system requests practice squad for "KC"
    Then the API returns practice squad players only
    And practice squad players have Status = "PracticeSquad"
    And they are separate from active roster
    And practice squad is limited to 16 players

  @player-team @injured-reserve
  Scenario: Retrieve players on injured reserve
    When the system requests injured reserve for "KC"
    Then the API returns players with Status = "InjuredReserve"
    And each player includes:
      | InjuryStatus     | InjuredReserve     |
      | InjuryBodyPart   | Knee               |
      | InjuryStartDate  | 2024-10-01         |
      | ExpectedReturn   | Week 14            |
    And IR players are excluded from fantasy availability

  @player-team @error
  Scenario: Request players for invalid team abbreviation
    When the system requests GET "/stats/json/Players/INVALID"
    Then the API returns HTTP 404 Not Found
    And the system logs "Team not found: INVALID"
    And error message lists valid team abbreviations

  @player-team @bye-week
  Scenario: Request players for team with bye week
    Given "Kansas City Chiefs" has bye week 12
    And the current NFL week is 12
    When the system requests GET "/stats/json/Players/KC"
    Then the API returns all KC players
    And each player includes bye week indicator:
      | ByeWeek      | 12   |
      | OnBye        | true |
    And the UI displays bye week warning
    And projected points for bye week are 0

  @player-team @all-teams
  Scenario: Retrieve all NFL teams with player counts
    When the system requests all NFL teams
    Then the API returns all 32 teams with:
      | Team | FullName              | ActivePlayers | ByeWeek |
      | KC   | Kansas City Chiefs    | 53            | 12      |
      | SF   | San Francisco 49ers   | 53            | 9       |
      | PHI  | Philadelphia Eagles   | 53            | 5       |
    And results are cached for 24 hours

  # ============================================================================
  # GET PLAYERS BY POSITION
  # ============================================================================

  @player-position @filter
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
      | FantasyPoints   |
    And results are sorted by fantasy points (descending)

  @player-position @filter
  Scenario: Retrieve all running backs
    When the system requests all players at position "RB"
    Then the API returns all active NFL running backs
    And includes both primary and backup RBs
    And results indicate starter vs backup status
    And includes receiving RBs and goal-line backs

  @player-position @filter
  Scenario: Retrieve all wide receivers
    When the system requests all players at position "WR"
    Then the API returns all active NFL wide receivers
    And results include depth chart order (WR1, WR2, WR3)
    And includes target share percentage where available

  @player-position @filter
  Scenario: Retrieve all tight ends
    When the system requests all players at position "TE"
    Then the API returns all active NFL tight ends
    And distinguishes receiving TEs from blocking TEs
    And includes snap count percentage

  @player-position @filter
  Scenario: Retrieve all kickers
    When the system requests all players at position "K"
    Then the API returns all NFL kickers
    And results include field goal accuracy
    And results include extra point accuracy
    And kickers are sorted by fantasy points

  @player-position @filter
  Scenario: Retrieve all team defenses
    When the system requests all players at position "DEF"
    Then the API returns all 32 NFL team defenses
    And each defense includes:
      | Team               | KC                  |
      | PointsAllowed      | 18.5                |
      | Sacks              | 3.2                 |
      | Interceptions      | 1.1                 |
      | FumblesRecovered   | 0.5                 |
      | DefensiveTDs       | 0.3                 |
    And defenses are sorted by fantasy points

  @player-position @available
  Scenario: Retrieve all available players for a position
    Given a user is building their roster
    And the user needs to fill the RB position
    When the system requests GET "/stats/json/PlayersByAvailable"
    And filters by Position = "RB"
    Then the API returns all active running backs
    And inactive/injured players are excluded
    And results include fantasy-relevant metadata
    And already-rostered players are marked

  @player-position @flex
  Scenario: Filter players by multiple positions (FLEX)
    Given a user is filling a FLEX position (RB/WR/TE eligible)
    When the system requests players with Position IN ["RB", "WR", "TE"]
    Then the API returns all players matching those positions
    And results are sorted by fantasy points (descending)
    And the user can filter further by team or name
    And total count shows combined position availability

  @player-position @superflex
  Scenario: Filter players for SuperFlex position
    Given a user is filling a SuperFlex position (QB/RB/WR/TE eligible)
    When the system requests players with Position IN ["QB", "RB", "WR", "TE"]
    Then the API returns all skill position players
    And QBs are included in the results
    And results are sorted by projected fantasy points

  @player-position @idp
  Scenario: Retrieve individual defensive players (IDP)
    When the system requests players at position "LB"
    Then the API returns all NFL linebackers
    And includes defensive stats:
      | Tackles         |
      | Sacks           |
      | Interceptions   |
      | ForcedFumbles   |
      | PassesDefended  |
    And IDP scoring is calculated correctly

  # ============================================================================
  # PLAYER AVAILABILITY STATUS
  # ============================================================================

  @player-status @active
  Scenario: Retrieve only active players
    When the system requests GET "/stats/json/PlayersByAvailable"
    Then the API returns players with Status = "Active"
    And excludes players with Status IN:
      | Injured          |
      | InjuredReserve   |
      | Suspended        |
      | Inactive         |
      | Retired          |
      | PracticeSquad    |
    And the response includes 1,500+ active players

  @player-status @free-agents
  Scenario: Retrieve free agent players
    When the system requests GET "/stats/json/PlayersByFreeAgents"
    Then the API returns players not currently on a team roster
    And each player has Team = null or Team = "FA"
    And free agents are sorted by last known fantasy production
    And includes reason for free agency (cut, never signed, etc.)

  @player-status @rookies
  Scenario: Retrieve rookie players by draft year
    Given the current season is 2024
    When the system requests GET "/stats/json/PlayersByRookieDraftYear/2024"
    Then the API returns all 2024 NFL Draft picks
    And includes undrafted free agents from 2024
    And each player includes draft information:
      | DraftRound     | 1          |
      | DraftPick      | 4          |
      | DraftTeam      | ARI        |
      | College        | Ohio State |
    And rookies are marked as "R" in experience field

  @player-status @injured
  Scenario: Retrieve players by injury status
    When the system requests players with InjuryStatus = "Questionable"
    Then the API returns all questionable players
    And each player includes:
      | InjuryStatus      | Questionable       |
      | InjuryBodyPart    | Hamstring          |
      | PracticeStatus    | Limited            |
      | GameStatus        | Questionable       |
    And results are sorted by team

  @player-status @suspended
  Scenario: Retrieve suspended players
    When the system requests players with Status = "Suspended"
    Then the API returns all currently suspended players
    And each player includes:
      | SuspensionReason  | Gambling Policy    |
      | GamesRemaining    | 6                  |
      | EligibleToReturn  | Week 14            |
    And suspended players cannot be selected for roster

  # ============================================================================
  # COMBINED SEARCH FILTERS
  # ============================================================================

  @player-search @combined-filters
  Scenario: Search with position filter
    When the system searches for "Patrick" with Position = "QB"
    Then the API returns only quarterbacks named Patrick
    And excludes players at other positions
    And results are sorted by fantasy points

  @player-search @combined-filters
  Scenario: Search with team filter
    When the system searches for players on Team = "KC"
    Then the API returns all Kansas City Chiefs players
    And results include all positions
    And results are sorted by depth chart order

  @player-search @combined-filters
  Scenario: Search with combined name, position, and team filters
    When the system searches with filters:
      | Name     | Smith  |
      | Position | WR     |
      | Team     | PHI    |
    Then the API returns only WRs named Smith on Philadelphia Eagles
    And results match ALL filter criteria (AND logic)
    And empty result is returned if no matches

  @player-search @combined-filters
  Scenario: Search with status filter
    When the system searches with filters:
      | Position | RB      |
      | Status   | Active  |
    Then the API returns only active running backs
    And excludes injured, suspended, and practice squad players

  @player-search @combined-filters
  Scenario: Search with fantasy points threshold
    When the system searches with filters:
      | Position          | WR    |
      | MinFantasyPoints  | 100   |
    Then the API returns only WRs with 100+ fantasy points this season
    And results are sorted by fantasy points (descending)

  @player-search @combined-filters
  Scenario: Search excluding bye week players
    Given the current NFL week is 10
    When the system searches with filters:
      | Position      | QB    |
      | ExcludeByeWeek| true  |
    Then the API returns QBs not on bye week 10
    And bye week players are filtered out
    And results show only playable QBs this week

  # ============================================================================
  # PAGINATION
  # ============================================================================

  @pagination @default
  Scenario: Paginate player search results with default page size
    Given a search for "Smith" returns 100 players
    When the client requests results without pagination parameters
    Then the response includes 50 players (default page size)
    And pagination metadata shows:
      | page          | 0     |
      | size          | 50    |
      | totalElements | 100   |
      | totalPages    | 2     |
      | hasNext       | true  |
      | hasPrevious   | false |

  @pagination @custom-size
  Scenario: Request specific page size
    Given a search returns 100 players
    When the client requests page 0 with size 25
    Then the response includes exactly 25 players
    And pagination shows totalPages = 4

  @pagination @specific-page
  Scenario: Request specific page of player results
    Given a search returns 100 players
    When the client requests page 1 with size 25
    Then the response includes players 26-50
    And pagination shows:
      | page          | 1    |
      | hasNext       | true |
      | hasPrevious   | true |

  @pagination @last-page
  Scenario: Request last page of results
    Given a search returns 100 players
    When the client requests page 3 with size 25
    Then the response includes players 76-100 (25 players)
    And pagination shows:
      | page          | 3     |
      | hasNext       | false |
      | hasPrevious   | true  |

  @pagination @beyond-results
  Scenario: Request page beyond available results
    Given a search returns 30 players
    When the client requests page 5 with size 20
    Then the response returns an empty list
    And pagination shows:
      | page          | 5     |
      | totalElements | 30    |
      | totalPages    | 2     |
      | hasNext       | false |

  @pagination @invalid-page
  Scenario: Request negative page number
    When the client requests page -1
    Then the request is rejected with error "INVALID_PAGE"
    And error message says "Page number must be non-negative"

  @pagination @invalid-size
  Scenario: Request invalid page size
    When the client requests page 0 with size 0
    Then the request is rejected with error "INVALID_PAGE_SIZE"
    And error message says "Page size must be between 1 and 100"

  @pagination @max-size
  Scenario: Enforce maximum page size
    When the client requests page 0 with size 500
    Then the page size is capped at 100
    And response includes 100 players maximum
    And warning header indicates size was reduced

  @pagination @cursor-based
  Scenario: Support cursor-based pagination for infinite scroll
    Given a search returns many players
    When the client requests first page
    Then the response includes a cursor token
    And cursor = "eyJvZmZzZXQiOjUwfQ=="
    When the client requests next page with cursor
    Then the next 50 players are returned
    And a new cursor is provided for the next page

  @pagination @sorting
  Scenario: Paginate with custom sort order
    When the client requests players sorted by "fantasyPoints" descending
    Then the first page shows highest fantasy point scorers
    And pagination preserves sort order across pages
    And sort parameter is included in response metadata

  @pagination @sorting
  Scenario: Paginate with multiple sort fields
    When the client requests players sorted by:
      | Field          | Direction  |
      | Position       | ASC        |
      | FantasyPoints  | DESC       |
    Then players are sorted by position, then by fantasy points within each position
    And pagination preserves multi-field sort order

  # ============================================================================
  # PLAYER METADATA
  # ============================================================================

  @player-metadata @complete
  Scenario: Retrieve player with complete metadata
    When the system requests player "Christian McCaffrey"
    Then the response includes comprehensive metadata:
      | Field               | Value                |
      | PlayerID            | 15487                |
      | FirstName           | Christian            |
      | LastName            | McCaffrey            |
      | FullName            | Christian McCaffrey  |
      | Position            | RB                   |
      | Team                | SF                   |
      | TeamFullName        | San Francisco 49ers  |
      | Number              | 23                   |
      | Height              | 71                   |
      | Weight              | 205                  |
      | BirthDate           | 1996-06-07           |
      | Age                 | 28                   |
      | College             | Stanford             |
      | Experience          | 7                    |
      | Status              | Active               |
      | InjuryStatus        | Healthy              |
      | FantasyPosition     | RB                   |
      | DepthChartOrder     | 1                    |
      | ByeWeek             | 9                    |
      | PhotoUrl            | https://...          |
      | LastUpdated         | 2024-09-15T10:30:00Z |

  @player-metadata @injury
  Scenario: Handle player with injury status
    Given "Saquon Barkley" has InjuryStatus = "Questionable"
    And InjuryBodyPart = "Ankle"
    When the system retrieves player data
    Then the response includes injury information:
      | InjuryStatus        | Questionable        |
      | InjuryBodyPart      | Ankle               |
      | InjuryStartDate     | 2024-09-10          |
      | InjuryNotes         | Limited in practice |
      | PracticeStatus      | Limited             |
      | GameStatus          | Questionable        |
    And the UI displays injury warning icon
    And projected points are adjusted for injury risk

  @player-metadata @photo
  Scenario: Handle player photo URL
    When the system retrieves player with photo
    Then the PhotoUrl is validated
    And fallback to default avatar if PhotoUrl is null
    And photo is cached locally for performance

  @player-metadata @contract
  Scenario: Include contract information for player
    When the system retrieves player contract details
    Then the response includes:
      | ContractValue       | $75,000,000         |
      | ContractYears       | 4                   |
      | GuaranteedMoney     | $38,000,000         |
      | ContractExpiry      | 2027                |
      | FranchiseTagged     | false               |
    And contract info helps with dynasty leagues

  # ============================================================================
  # PLAYER STATS SUMMARY
  # ============================================================================

  @player-stats @season
  Scenario: Retrieve player with season stats summary
    Given "Patrick Mahomes" has played 8 games in 2024 season
    When the system requests player data with stats summary
    Then the response includes season aggregates:
      | Stat              | Value  |
      | GamesPlayed       | 8      |
      | PassingYards      | 2400   |
      | PassingTouchdowns | 20     |
      | Interceptions     | 4      |
      | PassingAttempts   | 280    |
      | Completions       | 185    |
      | CompletionPct     | 66.1   |
      | QBRating          | 102.5  |
      | FantasyPoints     | 196.5  |
      | FantasyPointsPPR  | 196.5  |
      | AveragePoints     | 24.6   |

  @player-stats @weekly
  Scenario: Retrieve player weekly stats breakdown
    Given "Patrick Mahomes" has played 8 games
    When the system requests weekly stats for player
    Then the response includes stats per week:
      | Week | PassYards | PassTD | INT | FantasyPts |
      | 1    | 305       | 3      | 1   | 26.2       |
      | 2    | 278       | 2      | 0   | 22.1       |
      | 3    | 342       | 4      | 1   | 31.5       |
    And weekly stats are cached separately
    And includes game opponent for each week

  @player-stats @projections
  Scenario: Retrieve player projections
    When the system requests projections for "Patrick Mahomes"
    Then the response includes projected stats:
      | ProjectedPassingYards | 285   |
      | ProjectedPassingTDs   | 2.1   |
      | ProjectedFantasyPts   | 22.5  |
      | ProjectionConfidence  | High  |
    And projections consider matchup difficulty
    And projections are updated daily

  @player-stats @ranking
  Scenario: Retrieve player fantasy ranking
    When the system requests player with fantasy ranking
    Then the response includes:
      | OverallRank        | 5     |
      | PositionRank       | 2     |
      | AverageDraftPos    | 12.5  |
      | ExpertConsensus    | 8     |
    And rankings are updated weekly

  # ============================================================================
  # CACHING
  # ============================================================================

  @caching @hit
  Scenario: Use cached player data when available
    Given player "Patrick Mahomes" was fetched 10 minutes ago
    And the cache TTL is 1 hour
    When the system requests the same player again
    Then the cached data is returned immediately
    And no API call is made
    And cache hit is recorded in metrics
    And response includes header "X-Cache: HIT"

  @caching @miss
  Scenario: Fetch from API on cache miss
    Given player "Justin Jefferson" is not in cache
    When the system requests the player
    Then an API call is made to SportsData.io
    And the response is cached for 1 hour
    And cache miss is recorded in metrics
    And response includes header "X-Cache: MISS"

  @caching @expiry
  Scenario: Refresh stale player data
    Given player data was cached 25 hours ago
    And the cache TTL is 24 hours
    When the system requests the player
    Then the cache is expired
    And a new API call is made
    And the cache is updated with fresh data
    And old cache entry is evicted

  @caching @ttl-by-data-type
  Scenario: Apply different cache TTLs by data type
    Then cache TTLs are configured as:
      | Data Type          | TTL         |
      | Player metadata    | 24 hours    |
      | Team roster        | 24 hours    |
      | Player stats       | 1 hour      |
      | Injury status      | 15 minutes  |
      | Search results     | 1 hour      |
      | Projections        | 6 hours     |
    And each data type expires independently

  @caching @invalidation
  Scenario: Invalidate cache on player update
    Given player "Player X" is cached
    When a trade notification is received for "Player X"
    Then the cache entry for "Player X" is invalidated
    And the team roster cache for old team is invalidated
    And the team roster cache for new team is invalidated
    And next request fetches fresh data

  @caching @warmup
  Scenario: Warm up cache on application startup
    When the application starts
    Then the cache is warmed with:
      | All 32 team rosters        |
      | Top 200 fantasy players    |
      | All team schedules         |
    And startup cache warming completes within 60 seconds
    And initial user requests hit warm cache

  @caching @distributed
  Scenario: Use distributed cache across instances
    Given multiple application instances are running
    When instance 1 caches player data
    Then instance 2 can read the same cached data
    And cache is shared via Redis
    And cache consistency is maintained

  @caching @fallback
  Scenario: Use stale cache on API failure
    Given player data is cached but expired
    And the SportsData.io API is unavailable
    When the system requests the player
    Then the stale cached data is returned
    And response includes header "X-Cache: STALE"
    And user is notified data may be outdated
    And retry is scheduled for when API recovers

  # ============================================================================
  # DATA VALIDATION
  # ============================================================================

  @validation @position-enum
  Scenario: Validate player position enum
    Given the API returns Position = "QB"
    When the system validates the position
    Then the position is recognized as valid
    And maps to internal Position.QB enum

  @validation @position-enum
  Scenario: Reject invalid position value
    Given the API returns Position = "INVALID_POS"
    When the system validates the position
    Then the system rejects the data
    And logs validation error "Invalid position: INVALID_POS"
    And does not store invalid data
    And alerts monitoring system

  @validation @team-abbrev
  Scenario: Validate team abbreviation
    Given the API returns Team = "KC"
    When the system validates the team
    Then the team is recognized as valid (Kansas City Chiefs)
    And maps to internal Team enum

  @validation @team-abbrev
  Scenario: Handle unknown team abbreviation
    Given the API returns Team = "XYZ"
    When the system validates the team
    Then the system logs warning "Unknown team: XYZ"
    And stores the data with Team = "UNKNOWN"
    And flags for manual review

  @validation @required-fields
  Scenario: Validate required fields are present
    Given the API response includes:
      | PlayerID  | 14876   |
      | FirstName | Patrick |
      | LastName  | Mahomes |
      | Position  | QB      |
      | Team      | KC      |
    When the system validates the response
    Then all required fields are present
    And validation passes
    And data is stored successfully

  @validation @required-fields
  Scenario: Reject response missing required field
    Given the API response is missing "PlayerID" field
    When the system validates the response
    Then the system rejects the data
    And returns error "MISSING_REQUIRED_FIELD"
    And logs which fields are missing: ["PlayerID"]
    And no data is stored

  @validation @data-types
  Scenario: Validate data types are correct
    Given the API returns:
      | PlayerID   | 14876   (number)    |
      | FirstName  | Patrick (string)    |
      | Height     | 75      (number)    |
      | BirthDate  | 1995-09-17 (date)   |
    When the system validates data types
    Then all data types are correct
    And parsing succeeds

  @validation @data-types
  Scenario: Handle incorrect data types gracefully
    Given the API returns Height = "seventy-five"
    When the system validates data types
    Then the system logs type mismatch warning
    And attempts to parse or use default value
    And does not fail the entire request

  @validation @sanitization
  Scenario: Sanitize player names with special characters
    Given the API returns Name = "D'Onta Foreman"
    When the system processes the name
    Then the apostrophe is preserved correctly
    And the name is stored as "D'Onta Foreman"
    And search handles the apostrophe correctly
    And XSS prevention is applied for display

  @validation @sanitization
  Scenario: Sanitize HTML in player data
    Given the API returns InjuryNotes = "<script>alert('xss')</script>Ankle sprain"
    When the system processes the data
    Then HTML tags are stripped
    And the value is stored as "Ankle sprain"
    And XSS attack is prevented

  @validation @bounds
  Scenario: Validate numeric bounds
    Given the API returns:
      | Height    | 75    |
      | Weight    | 230   |
      | Age       | 28    |
      | Number    | 15    |
    When the system validates bounds
    Then all values are within acceptable ranges:
      | Height    | 60-90 inches    |
      | Weight    | 150-400 lbs     |
      | Age       | 18-50 years     |
      | Number    | 0-99            |

  @validation @bounds
  Scenario: Handle out-of-bounds values
    Given the API returns Weight = 999
    When the system validates bounds
    Then the system logs "Weight out of bounds: 999"
    And uses null or default value
    And flags data for review

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling @timeout
  Scenario: Handle API timeout when retrieving player
    Given the SportsData.io API is experiencing delays
    When the system requests player data
    And the request times out after 10 seconds
    Then the system returns error "API_TIMEOUT"
    And the system retries the request with exponential backoff
    And uses cached player data if available
    And logs the timeout for monitoring
    And circuit breaker is notified

  @error-handling @timeout
  Scenario: Handle timeout with fallback
    Given the API times out
    And cached data exists for the player
    When timeout occurs
    Then cached data is returned as fallback
    And response indicates data may be stale
    And background refresh is scheduled

  @error-handling @malformed-response
  Scenario: Handle malformed API response
    Given the SportsData.io API returns invalid JSON
    When the system attempts to parse the response
    Then the system catches the parsing error
    And returns error "INVALID_RESPONSE_FORMAT"
    And logs the raw response for debugging
    And does not update local database
    And alerts monitoring system

  @error-handling @rate-limit
  Scenario: Handle API rate limiting
    Given the system has exceeded API rate limit
    When the API returns HTTP 429 Too Many Requests
    Then the system reads Retry-After header
    And queues the request for retry after specified time
    And logs rate limit event
    And adjusts request rate to prevent future limits

  @error-handling @auth-failure
  Scenario: Handle authentication failure
    Given the API key is invalid or expired
    When the API returns HTTP 401 Unauthorized
    Then the system logs critical authentication error
    And alerts ops team immediately
    And stops making API calls
    And uses cached data only
    And requires manual intervention

  @error-handling @server-error
  Scenario: Handle 500 Internal Server Error
    Given the SportsData.io API is experiencing issues
    When the API returns HTTP 500
    Then the system retries with exponential backoff
    And maximum 3 retry attempts
    And uses cached data after retries exhausted
    And logs all retry attempts

  @error-handling @partial-response
  Scenario: Handle partial API response
    Given the API returns truncated JSON due to network issue
    When the system attempts to parse the response
    Then the system detects incomplete response
    And retries the request
    And logs the partial response for debugging

  @error-handling @circuit-breaker
  Scenario: Integrate with circuit breaker
    Given the API has failed 5 consecutive times
    When the circuit breaker opens
    Then all subsequent requests return cached data immediately
    And no API calls are made until circuit closes
    And circuit breaker state is logged

  # ============================================================================
  # PERFORMANCE OPTIMIZATION
  # ============================================================================

  @performance @batch
  Scenario: Batch retrieve multiple players efficiently
    Given the system needs data for 10 players
    When the system requests player data
    Then the requests are batched into a single API call
    And all 10 players are returned in one response
    And API call count is minimized
    And latency is reduced vs individual calls

  @performance @prefetch
  Scenario: Prefetch related player data
    Given the user is viewing "Patrick Mahomes" player page
    When the page loads
    Then the system prefetches:
      | Teammates (KC roster)     |
      | Upcoming opponents        |
      | Similar players at QB     |
    And prefetched data is cached
    And improves subsequent navigation speed

  @performance @lazy-loading
  Scenario: Lazy load player details
    Given a search returns 50 players
    When the results are displayed
    Then only basic info is loaded initially:
      | PlayerID |
      | Name     |
      | Position |
      | Team     |
    And detailed stats are loaded on demand
    And reduces initial payload size

  @performance @compression
  Scenario: Use compression for API responses
    When the system requests player data
    Then the request includes "Accept-Encoding: gzip"
    And the API returns compressed response
    And response size is reduced by 70%+
    And decompression is handled automatically

  @performance @connection-pooling
  Scenario: Use connection pooling for API calls
    Given multiple concurrent requests are made
    Then HTTP connections are reused from pool
    And connection pool size is optimized (10-50)
    And connection health is monitored
    And idle connections are closed after timeout

  # ============================================================================
  # INTEGRATION WITH ROSTER BUILDING
  # ============================================================================

  @roster-integration @search-ui
  Scenario: Retrieve players for roster building UI
    Given a user is building their fantasy roster
    When the user searches for a quarterback
    Then the system returns active QBs from SportsData.io
    And includes fantasy-relevant information:
      | Name              |
      | Team              |
      | ByeWeek           |
      | InjuryStatus      |
      | SeasonStats       |
      | ProjectedPoints   |
      | OwnershipPct      |
    And results are optimized for UI display

  @roster-integration @eligibility
  Scenario: Check player eligibility for position
    Given a user is filling the FLEX position
    And "Christian McCaffrey" has Position = "RB"
    When the system checks eligibility
    Then "Christian McCaffrey" is eligible for FLEX
    Because FLEX accepts RB, WR, TE
    And eligibility is clearly displayed

  @roster-integration @duplicate-check
  Scenario: Prevent selecting same player twice
    Given a user has already selected "Patrick Mahomes" at QB
    When the user tries to add "Patrick Mahomes" at Superflex
    Then the system checks for duplicates
    And prevents duplicate selection
    And displays error "Player already in roster"
    And highlights existing roster spot

  @roster-integration @availability
  Scenario: Show player availability status in search
    Given a user searches for "Christian McCaffrey"
    When the search results are returned
    Then availability indicators are shown:
      | Ownership    | 98.5%      |
      | Trending     | +2.3%      |
      | Availability | Unavailable in most leagues |
    And helps user make informed decisions

  # ============================================================================
  # REAL-WORLD EDGE CASES
  # ============================================================================

  @edge-case @trade
  Scenario: Handle player traded mid-season
    Given "Player X" was on Team "SF" yesterday
    And "Player X" is traded to Team "KC" today
    When the system fetches updated player data
    Then the player Team is updated to "KC"
    And the bye week is updated to KC's bye week
    And the old team cache is invalidated
    And the new team cache is invalidated
    And users with "Player X" are notified of the change

  @edge-case @injury-reserve
  Scenario: Handle player status change (Active to Injured Reserve)
    Given "Player Y" has Status = "Active"
    When "Player Y" is placed on Injured Reserve
    And the system fetches updated data
    Then the Status changes to "InjuredReserve"
    And InjuryStatus shows expected return date
    And users with "Player Y" are notified
    And projected points are updated to 0

  @edge-case @retirement
  Scenario: Handle player retirement announcement
    Given "Player Z" is active in the league
    When "Player Z" announces retirement mid-season
    And the system fetches updated data
    Then the Status changes to "Retired"
    And the player is removed from available players list
    And the player is removed from search results
    And users with "Player Z" in roster are notified

  @edge-case @name-change
  Scenario: Handle player name change
    Given "Player A" legally changes name to "Player B"
    When the system fetches updated data
    Then the player name is updated
    And search works with both old and new name
    And historical data is preserved
    And name aliases are maintained

  @edge-case @team-expansion
  Scenario: Handle new team added to league
    Given a new NFL team "London Monarchs" is added
    When the system fetches team data
    Then the new team is recognized
    And team abbreviation is added to valid list
    And players can be associated with new team

  @edge-case @suspended-reinstatement
  Scenario: Handle player reinstatement from suspension
    Given "Player S" has Status = "Suspended"
    When "Player S" is reinstated
    And the system fetches updated data
    Then the Status changes to "Active"
    And player appears in available players list
    And projections are recalculated
    And fantasy owners are notified

  @edge-case @duplicate-player
  Scenario: Handle duplicate player records
    Given two player records exist for same real player
    When the system detects duplicate
    Then records are flagged for review
    And canonical player ID is determined
    And duplicate is marked as alias
    And searches return correct player

  @edge-case @unicode-names
  Scenario: Handle players with Unicode names
    Given player has name with Unicode characters
    When the system processes the name
    Then Unicode is preserved correctly
    And search handles Unicode input
    And display renders correctly
    And database stores UTF-8 properly

  # ============================================================================
  # DATA SYNCHRONIZATION
  # ============================================================================

  @data-sync @incremental
  Scenario: Incrementally sync player data changes
    Given last sync was 15 minutes ago
    When the system requests updated players
    Then only players changed since last sync are returned
    And uses "IfModifiedSince" header
    And reduces data transfer significantly
    And sync timestamp is updated

  @data-sync @full
  Scenario: Perform full data synchronization
    Given a full sync is scheduled
    When the system performs full sync
    Then all players are fetched and compared
    And changed players are updated
    And deleted players are removed
    And new players are added
    And sync takes < 5 minutes

  @data-sync @webhook
  Scenario: Receive real-time updates via webhook
    Given the system is registered for player update webhooks
    When a player trade occurs
    Then the webhook notification is received
    And the player data is updated immediately
    And cache is invalidated
    And affected users are notified in real-time

  @data-sync @conflict
  Scenario: Handle data sync conflicts
    Given player data was modified locally
    And player data was modified on API
    When sync detects conflict
    Then API data takes precedence (source of truth)
    And local changes are logged for audit
    And conflict is resolved automatically
