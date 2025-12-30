Feature: NFL Game Schedules via SportsData.io
  As a system
  I want to retrieve NFL game schedules from SportsData.io
  So that I can track when games occur and enable real-time stat polling

  Background:
    Given the system is configured with SportsData.io API
    And the API endpoint is "/scores/json/Schedules/{season}"
    And the current NFL season is 2024

  # =============================================================================
  # RETRIEVE FULL SEASON SCHEDULE
  # =============================================================================

  Scenario: Fetch complete NFL season schedule
    When the system requests GET "/scores/json/Schedules/2024"
    Then the API returns HTTP 200 OK
    And the response includes all games for 2024 season
    And games span weeks 1-18 (regular season + playoffs)
    And each game includes:
      | GameKey         |
      | Season          |
      | Week            |
      | Date            |
      | HomeTeam        |
      | AwayTeam        |
      | StadiumID       |
      | Channel         |
      | Status          |
      | GlobalGameID    |
      | GlobalHomeTeamID|
      | GlobalAwayTeamID|

  Scenario: Filter schedule by specific week
    Given the league is configured for weeks 15-18
    When the system requests schedule for week 15
    Then the response includes only week 15 games
    And typically includes 14-16 games
    And games are sorted by date/time

  Scenario: Filter schedule by league weeks
    Given the league covers NFL weeks 15, 16, 17, 18
    When the system fetches the schedule
    Then only weeks 15-18 are retrieved
    And weeks 1-14 are excluded
    And weeks 19+ (playoffs) are excluded if not configured

  Scenario: Parse SportsData.io schedule response format
    When the system receives schedule response
    Then the JSON is parsed into game entities:
      | Field          | Type      | Example                    |
      | GameKey        | String    | "202415001"                |
      | Season         | Integer   | 2024                       |
      | SeasonType     | Integer   | 1 (regular) or 2 (postseason) |
      | Week           | Integer   | 15                         |
      | Date           | DateTime  | "2024-12-15T18:00:00"      |
      | HomeTeam       | String    | "KC"                       |
      | AwayTeam       | String    | "BUF"                      |
      | HomeScore      | Integer   | null or 31                 |
      | AwayScore      | Integer   | null or 27                 |
      | Status         | String    | "Scheduled"                |

  Scenario: Handle preseason schedule separately
    When the system requests preseason schedule
    Then weeks -4 through -1 (or labeled PRE1-PRE4) are returned
    And these games are separate from regular season
    And preseason stats do not affect fantasy leagues

  # =============================================================================
  # GAME STATUS TRACKING
  # =============================================================================

  Scenario: Retrieve scheduled game details
    Given a game is scheduled for Sunday 1:00 PM ET
    When the system fetches the game details
    Then the game status is "Scheduled"
    And the game includes:
      | Date        | 2024-12-15T13:00:00Z |
      | HomeTeam    | KC                   |
      | AwayTeam    | BUF                  |
      | Channel     | CBS                  |
      | Stadium     | Arrowhead Stadium    |
      | Status      | Scheduled            |
      | HomeScore   | null                 |
      | AwayScore   | null                 |

  Scenario: Detect when game starts
    Given a game status was "Scheduled"
    And the scheduled time has passed
    When the system polls the schedule
    Then the game status changes to "InProgress"
    And the Quarter field shows "1"
    And HomeScore and AwayScore start updating
    And real-time stats polling begins

  Scenario: Detect when game completes
    Given a game has status "InProgress"
    And the 4th quarter ends
    When the system polls the schedule
    Then the game status changes to "Final"
    And the final scores are recorded:
      | HomeScore | 31 |
      | AwayScore | 27 |
    And real-time polling stops for this game
    And final stats are fetched

  Scenario: Handle overtime games
    Given a game is tied at end of regulation
    When the system polls the schedule
    Then the game status remains "InProgress"
    And the Quarter field shows "OT"
    And real-time polling continues
    When overtime ends
    Then the status changes to "Final" or "FinalOvertime"
    And the winner is determined

  Scenario: Handle double overtime playoff games
    Given a playoff game is tied after first overtime
    When the system polls the schedule
    Then the game status remains "InProgress"
    And the Quarter field shows "OT2"
    And polling continues until a winner is determined

  # =============================================================================
  # GAME STATUS ENUMERATION
  # =============================================================================

  Scenario: Recognize all possible game statuses
    Given the system processes game schedule updates
    Then the following statuses are supported:
      | Scheduled     | Game not started yet        |
      | InProgress    | Game currently being played |
      | Halftime      | Between 2nd and 3rd quarter |
      | Final         | Game completed              |
      | FinalOvertime | Game completed in OT        |
      | Suspended     | Game temporarily stopped    |
      | Postponed     | Game rescheduled            |
      | Canceled      | Game canceled               |
      | Delayed       | Start time delayed          |

  Scenario: Map SportsData.io status to internal status
    Given SportsData.io uses specific status codes
    When the system receives status updates
    Then statuses are mapped correctly:
      | SportsData Status | Internal Status |
      | Scheduled         | SCHEDULED       |
      | InProgress        | IN_PROGRESS     |
      | Final             | FINAL           |
      | F/OT              | FINAL_OT        |
      | Suspended         | SUSPENDED       |
      | Postponed         | POSTPONED       |
      | Canceled          | CANCELED        |

  Scenario: Handle unknown game status
    Given the API returns an unexpected status "WeatherDelay"
    When the system processes the response
    Then the status is logged as unrecognized
    And the game is marked with status "UNKNOWN"
    And an alert is sent to system administrators
    And the game is excluded from active polling

  Scenario: Status transitions are validated
    Given a game has status "Scheduled"
    When an update shows status "Final" (skipping InProgress)
    Then the system logs the unusual transition
    But accepts the final status as authoritative
    And fetches any missed in-game stats

  # =============================================================================
  # WEEK SCHEDULE RETRIEVAL
  # =============================================================================

  Scenario: Get schedule for specific NFL week
    When the system requests GET "/scores/json/ScoresByWeek/2024/15"
    Then the API returns all games for week 15
    And includes live scores if games are in progress
    And includes final scores for completed games
    And includes schedule info for upcoming games

  Scenario: Get current week's schedule
    Given the current NFL week is 15
    When the system requests the current week's schedule
    Then week 15 games are returned
    And the system uses the current week automatically
    And no week parameter needs to be specified

  Scenario: Determine current NFL week automatically
    Given the current date is December 15, 2024
    When the system calculates the current NFL week
    Then the system determines it is week 15
    And uses NFL season calendar to determine week boundaries
    And handles week transitions at Tuesday midnight ET

  Scenario: Handle week during bye weeks
    Given it is NFL week 12
    And 6 teams have byes in week 12
    When the system fetches week 12 schedule
    Then only 13 games are returned (instead of 16)
    And bye week teams have no games listed

  # =============================================================================
  # GAME TIME TRACKING
  # =============================================================================

  Scenario: Track game time remaining
    Given a game is in progress
    When the system fetches game details
    Then the response includes:
      | Quarter          | 2              |
      | TimeRemaining    | 08:32          |
      | Possession       | KC             |
      | Down             | 2              |
      | Distance         | 7              |
      | YardLine         | BUF 35         |
    And time updates every 30 seconds during polling

  Scenario: Handle halftime
    Given a game reaches halftime
    When the system polls the schedule
    Then the status shows "Halftime"
    And Quarter shows "Half"
    And TimeRemaining shows "00:00"
    And stats polling continues at reduced frequency
    When the 3rd quarter starts
    Then status returns to "InProgress"

  Scenario: Track quarter transitions
    Given a game is in the 1st quarter
    When the quarter ends
    Then the system detects Quarter change to "2"
    And TimeRemaining resets to "15:00"
    And the transition is logged

  Scenario: Handle two-minute warning
    Given a game has 2:00 remaining in the 2nd or 4th quarter
    When the system polls the schedule
    Then the TwoMinuteWarning field may be true
    And polling frequency increases for critical moments

  # =============================================================================
  # SCHEDULE CHANGES AND UPDATES
  # =============================================================================

  Scenario: Handle game postponement
    Given a game is scheduled for Sunday 1:00 PM
    And severe weather is forecasted
    When the NFL postpones the game to Monday 7:00 PM
    And the system fetches updated schedule
    Then the game Date is updated to Monday
    And the game Status is "Postponed"
    And all users are notified of the change
    And fantasy scoring is adjusted accordingly

  Scenario: Handle game cancellation
    Given a game is scheduled
    When the NFL cancels the game entirely
    And the system fetches updated schedule
    Then the game Status is "Canceled"
    And all users are notified
    And fantasy points for that game are set to 0
    And players in that game receive 0 points

  Scenario: Handle flexed game time
    Given a Sunday 1:00 PM game is scheduled
    When the NFL flexes it to Sunday Night Football (8:20 PM)
    And the system fetches updated schedule
    Then the game Date/Time is updated
    And the Channel changes to "NBC"
    And users are notified of the time change
    And roster lock times are adjusted

  Scenario: Detect schedule changes via polling
    Given the system caches the schedule
    When the system polls for updates every 5 minutes
    And a game time has changed
    Then the change is detected by comparing to cached data
    And an event is triggered for schedule change
    And affected users receive notifications

  Scenario: Handle game moved to different day
    Given a game is scheduled for Sunday
    When the game is moved to Saturday due to weather
    Then the game Date changes to Saturday
    And the Channel may change
    And roster locks are adjusted to new time
    And notifications are sent to affected users

  Scenario: Handle venue change
    Given a game is scheduled at Highmark Stadium (Buffalo)
    When the venue is changed to Ford Field (Detroit) due to weather
    Then the StadiumID is updated
    And Stadium name changes to "Ford Field"
    And City/State changes accordingly
    And weather considerations change (dome vs outdoor)

  # =============================================================================
  # BYE WEEKS
  # =============================================================================

  Scenario: Identify teams on bye week
    Given NFL week 12 is active
    When the system fetches the schedule for week 12
    Then teams not playing in week 12 are identified as having a bye
    And typically 4-6 teams have byes per week
    And players on bye week teams have 0 projected points

  Scenario: Warn users about bye week players
    Given "Patrick Mahomes" team "KC" has bye week 10
    And a user has Patrick Mahomes in their lineup
    When the user views their roster for week 10
    Then the system displays "BYE" indicator
    And projects 0 fantasy points
    And suggests benching or replacing

  Scenario: Build bye week schedule for all teams
    Given the 2024 NFL season bye week schedule
    When the system initializes season data
    Then bye weeks are stored for all 32 teams:
      | Team | Bye Week |
      | KC   | 6        |
      | BUF  | 12       |
      | SF   | 9        |
      | DAL  | 7        |
    And bye week data is available for roster validation

  Scenario: Validate roster has no bye week players starting
    Given a user's roster has a player on bye week
    When the user attempts to submit their lineup
    Then a warning is displayed: "Player X is on bye week"
    And the user can override the warning
    Or the user can replace the player

  Scenario: Auto-suggest replacement for bye week player
    Given a user has "Josh Allen" (BUF) starting at QB
    And BUF has a bye in week 12
    When the user views week 12 roster
    Then the system suggests available QBs not on bye
    And ranks suggestions by projected points

  Scenario: Bye week affects player availability in draft
    Given a league draft occurs during week 5
    And certain teams have bye week 5
    Then players on bye week 5 are still draftable
    But a bye week indicator is shown
    And projected week 5 points show 0

  Scenario: Display bye week calendar
    When a user views the bye week calendar
    Then all 18 weeks are displayed
    And each week shows which teams have byes
    And the user can plan roster moves in advance

  Scenario: Count active games for week considering byes
    Given week 12 has 6 teams on bye
    When the system counts games for week 12
    Then 13 games are counted (32 teams - 6 byes = 26 teams = 13 games)
    And this affects polling resource allocation

  # =============================================================================
  # PLAYOFF SCHEDULE
  # =============================================================================

  Scenario: Retrieve playoff schedule
    Given the regular season has ended (week 18 complete)
    When the system requests playoff schedule
    Then weeks 19-22 (Wild Card, Divisional, Conference, Super Bowl) are returned
    And only playoff teams' games are included
    And eliminated teams have no games

  Scenario: Handle league configured for playoffs
    Given a league is configured for weeks 15-18 (playoffs)
    And week 18 is Wild Card weekend
    When the system fetches schedule
    Then Wild Card games (week 19) are included
    And only playoff teams are relevant
    And eliminated teams are excluded

  Scenario: Identify Wild Card round games
    Given it is playoff week 19 (Wild Card)
    When the system fetches the schedule
    Then 6 Wild Card games are returned (3 per conference)
    And games are spread across Saturday and Sunday
    And Monday may have 1 game

  Scenario: Identify Divisional round games
    Given it is playoff week 20 (Divisional)
    When the system fetches the schedule
    Then 4 Divisional games are returned (2 per conference)
    And games are on Saturday and Sunday
    And higher seeds host

  Scenario: Identify Conference Championship games
    Given it is playoff week 21 (Conference)
    When the system fetches the schedule
    Then 2 Conference Championship games are returned
    And AFC Championship and NFC Championship
    And both games are on Sunday

  Scenario: Identify Super Bowl
    Given it is playoff week 22 (Super Bowl)
    When the system fetches the schedule
    Then 1 Super Bowl game is returned
    And venue is predetermined (neutral site)
    And game time is Sunday evening

  Scenario: Track playoff bracket progression
    Given Wild Card round is complete
    When the system updates playoff schedule
    Then advancing teams are shown in next round
    And matchups are determined by seeding
    And eliminated teams are marked as such

  # =============================================================================
  # STADIUM AND VENUE INFORMATION
  # =============================================================================

  Scenario: Retrieve stadium details for game
    When the system fetches game details
    Then stadium information is included:
      | StadiumID        | 15               |
      | Stadium          | Arrowhead Stadium|
      | City             | Kansas City      |
      | State            | MO               |
      | Country          | USA              |
      | Capacity         | 76416            |
      | PlayingSurface   | Grass            |
      | Type             | Outdoor          |
    And venue details help with player analysis

  Scenario: Identify dome vs outdoor games
    Given weather affects outdoor game performance
    When the system retrieves game stadium info
    Then the Type field indicates:
      | Outdoor    | Weather impacts play   |
      | Dome       | No weather impact      |
      | RetractableDome | Dome may be open/closed |
    And weather data is fetched for outdoor games

  Scenario: Classify all NFL stadiums by type
    Given the system maintains stadium database
    Then stadiums are classified:
      | Stadium             | Type            |
      | AT&T Stadium        | RetractableDome |
      | Mercedes-Benz Stadium| RetractableDome|
      | SoFi Stadium        | Outdoor (open)  |
      | Caesars Superdome   | Dome            |
      | Lambeau Field       | Outdoor         |
      | Highmark Stadium    | Outdoor         |

  Scenario: Identify playing surface type
    When the system retrieves stadium details
    Then the PlayingSurface indicates:
      | Grass       | Natural grass surface    |
      | FieldTurf   | Artificial turf          |
      | A-Turf      | Alternative artificial   |
    And surface type may affect injury risk

  # =============================================================================
  # WEATHER DATA FOR OUTDOOR GAMES
  # =============================================================================

  Scenario: Retrieve weather forecast for outdoor game
    Given a game is at an outdoor stadium
    And the game is scheduled for Sunday 1:00 PM
    When the system fetches weather data
    Then the forecast includes:
      | Temperature      | 28             |
      | FeelsLike        | 18             |
      | WindSpeed        | 15             |
      | WindDirection    | NW             |
      | Humidity         | 65             |
      | Precipitation    | 20             |
      | Conditions       | Partly Cloudy  |
    And weather warnings are shown if extreme

  Scenario: Warn about extreme weather conditions
    Given a game has forecasted temperature of 5 degrees F
    And wind speed of 30 mph (wind chill -15 F)
    When users view their roster
    Then the system displays weather warning
    And notes "Extreme cold may impact passing game"
    And suggests considering weather-proof players (RBs)

  Scenario: Skip weather fetch for dome games
    Given a game is at Caesars Superdome (dome)
    When the system processes the game
    Then no weather API call is made
    And weather conditions are marked as "N/A - Dome"
    And no weather warnings are displayed

  Scenario: Weather impacts game-day decisions
    Given a game has 40 mph wind gusts forecasted
    When the system displays weather info
    Then the system warns:
      | "High winds may reduce passing accuracy" |
      | "Consider starting RBs over WRs"         |
      | "Kicker accuracy may be affected"        |
    And links to weather-adjusted projections

  Scenario: Weather data updates as game approaches
    Given a game is 3 days away
    When the system fetches weather
    Then a forecast is provided with lower confidence
    And weather is re-fetched daily as game approaches
    And final weather check occurs 2 hours before game

  Scenario: Handle precipitation forecasts
    Given a game has 80% chance of rain
    When the system displays weather
    Then a rain indicator is shown
    And the system warns about wet ball handling
    And fumble risk may increase

  Scenario: Handle snow game scenarios
    Given a game has snow in the forecast
    And temperature is below freezing
    When the system displays weather
    Then a snow indicator is shown
    And passing game efficiency warnings are displayed
    And running game may be favored

  Scenario: Extreme heat warning
    Given a game has temperature of 95 degrees with high humidity
    When the system displays weather
    Then a heat advisory is shown
    And player fatigue concerns are noted
    And hydration breaks may affect game flow

  # =============================================================================
  # TIMEZONE HANDLING
  # =============================================================================

  Scenario: Store all game times in UTC
    Given a game is scheduled for 1:00 PM Eastern Time
    When the system stores the game time
    Then the time is stored as UTC: "2024-12-15T18:00:00Z"
    And no timezone ambiguity exists in the database

  Scenario: Display game times in user's local timezone
    Given a game is stored as "2024-12-15T18:00:00Z" (1:00 PM ET)
    And the user's timezone is "America/Los_Angeles" (Pacific)
    When the user views the game schedule
    Then the game time displays as "10:00 AM PT"
    And the user sees their local time

  Scenario: Handle timezone display for all US timezones
    Given a game is at 1:00 PM ET (18:00 UTC)
    When users in different timezones view the game
    Then times are displayed correctly:
      | Timezone                | Display Time  |
      | America/New_York (ET)   | 1:00 PM ET    |
      | America/Chicago (CT)    | 12:00 PM CT   |
      | America/Denver (MT)     | 11:00 AM MT   |
      | America/Los_Angeles (PT)| 10:00 AM PT   |
      | America/Anchorage (AKT) | 9:00 AM AKT   |
      | Pacific/Honolulu (HST)  | 8:00 AM HST   |

  Scenario: Handle daylight saving time transitions
    Given a game is scheduled for November 3, 2024 (DST ends)
    And the game is at 1:00 PM ET
    When DST ends at 2:00 AM that morning
    Then the UTC time remains unchanged
    And display times adjust for standard time
    And no game time confusion occurs

  Scenario: Handle timezone for international users
    Given a user is in timezone "Europe/London"
    And a game is at 1:00 PM ET (18:00 UTC)
    When the user views the schedule
    Then the game time displays as "6:00 PM GMT"
    And includes "next day" indicator if applicable

  Scenario: Handle London game timezone display
    Given a game is in London at 2:30 PM GMT
    And the user is in "America/New_York" timezone
    When the user views the schedule
    Then the game time displays as "9:30 AM ET"
    And a "London Game" indicator is shown

  Scenario: Default to Eastern Time for NFL schedule display
    Given a user has not set their timezone preference
    When the user views the schedule
    Then times are displayed in Eastern Time by default
    And a prompt suggests setting preferred timezone

  Scenario: Handle Arizona (no DST) timezone
    Given a user is in "America/Phoenix"
    And Arizona does not observe DST
    When DST is active elsewhere
    Then Arizona times are calculated correctly
    And no DST adjustment is applied for Arizona users

  Scenario: Timezone abbreviation display
    Given game times are displayed
    Then timezone abbreviations are accurate:
      | EST/EDT for Eastern  |
      | CST/CDT for Central  |
      | MST/MDT for Mountain |
      | PST/PDT for Pacific  |
    And abbreviations change with DST status

  Scenario: Relative time display for upcoming games
    Given a game starts in 2 hours
    When the user views the schedule
    Then "Starts in 2 hours" is displayed in addition to exact time
    And countdown updates in real-time

  # =============================================================================
  # ROSTER LOCKS BASED ON GAME SCHEDULE
  # =============================================================================

  Scenario: Lock players when their game starts
    Given a user has "Patrick Mahomes" in their roster
    And Mahomes' game is scheduled for 1:00 PM ET
    When the time reaches 1:00 PM ET
    Then Patrick Mahomes is locked
    And cannot be edited or removed
    And roster lock is based on individual player's game time

  Scenario: Handle roster lock for multiple game times
    Given a user has players in Thursday, Sunday, and Monday games
    When Thursday game starts at 8:15 PM
    Then only Thursday players are locked
    And Sunday/Monday players remain editable
    When Sunday 1 PM games start
    Then Sunday 1 PM players are locked
    And Monday players still editable
    When Monday game starts
    Then all players are locked

  Scenario: Progressive roster lock by game kickoff
    Given a user has the following roster:
      | Player          | Team | Game Time      |
      | Travis Kelce    | KC   | Thu 8:15 PM ET |
      | Josh Allen      | BUF  | Sun 1:00 PM ET |
      | Davante Adams   | LV   | Sun 4:25 PM ET |
      | Saquon Barkley  | NYG  | Mon 8:15 PM ET |
    When Thursday 8:15 PM arrives
    Then only Travis Kelce is locked
    When Sunday 1:00 PM arrives
    Then Travis Kelce and Josh Allen are locked
    When Sunday 4:25 PM arrives
    Then Travis Kelce, Josh Allen, and Davante Adams are locked
    When Monday 8:15 PM arrives
    Then all 4 players are locked

  Scenario: Display lock status for each player
    Given a user views their roster during Sunday games
    When some games have started and others have not
    Then each player shows lock status:
      | Patrick Mahomes | Locked - Game in progress  |
      | Josh Allen      | Locks in 2 hours           |
      | Davante Adams   | Locks in 5 hours           |
    And countdown timers show time until lock

  Scenario: Prevent roster changes after lock
    Given a player's game has started
    When the user attempts to bench or drop the player
    Then the action is blocked
    And the message says "Player locked - game in progress"
    And no roster changes are allowed for locked players

  Scenario: Allow changes to unlocked players
    Given a user has Thursday players locked
    And Sunday/Monday players still unlocked
    When the user edits Sunday lineup
    Then the edit is allowed
    And Sunday players can be swapped or benched

  Scenario: Lock buffer time before game
    Given the league is configured with 5-minute lock buffer
    And a game starts at 1:00 PM ET
    When the time is 12:55 PM ET
    Then players in that game are locked (5 min early)
    And this prevents last-second issues

  Scenario: Handle late scratches after lock
    Given a player is locked because game started
    And the player is declared out after kickoff (injury)
    When the system detects the late scratch
    Then the player remains locked (no changes allowed)
    And the player scores 0 points
    And the user is notified of the late scratch

  Scenario: Lock all players for weekly deadline leagues
    Given a league uses weekly deadline (not per-game lock)
    And the deadline is Sunday 1:00 PM ET
    When Sunday 1:00 PM arrives
    Then ALL players on the roster are locked
    And even Monday Night Football players are locked
    And no changes allowed until next week

  Scenario: Roster lock respects game postponement
    Given a game is postponed from Sunday to Monday
    When the user views their roster on Sunday
    Then players in the postponed game remain unlocked
    And players lock when the Monday game starts

  Scenario: Roster lock handles game cancellation
    Given a game is cancelled after roster lock deadline
    When the cancellation is detected
    Then players from cancelled game remain locked
    But score 0 fantasy points
    And no retroactive unlocking occurs

  Scenario: Display all lock times for week
    When a user views the weekly schedule
    Then all game kickoff times are shown
    And lock times are calculated for each game
    And a summary shows "Next lock: Sun 1:00 PM (8 games)"

  # =============================================================================
  # SCHEDULE INTEGRATION WITH LIVE STATS
  # =============================================================================

  Scenario: Use schedule to trigger live stats polling
    Given the system monitors the schedule
    When a game status changes from "Scheduled" to "InProgress"
    Then the system automatically starts live stats polling
    And polls every 30 seconds for that game
    When all games for the week change to "Final"
    Then live stats polling stops automatically
    And resources are conserved

  Scenario: Detect games starting soon
    Given a game is scheduled to start in 15 minutes
    When the system checks the schedule
    Then the system prepares for live polling
    And pre-fetches player data for both teams
    And warms up caches
    And ensures API rate limits are available

  Scenario: Prioritize polling for games with user interest
    Given 10 games are in progress
    And users have players in 6 of those games
    When the system allocates polling resources
    Then games with user players are polled more frequently
    And games with no user players are polled less often

  Scenario: Handle multiple simultaneous games
    Given 10 games start at 1:00 PM ET
    When all games kick off
    Then the system polls all 10 games
    And staggers requests to avoid rate limits
    And maintains near-real-time updates for all

  Scenario: Reduce polling frequency for blowout games
    Given a game has a 35-point lead in the 4th quarter
    When the system assesses polling priority
    Then polling frequency is reduced for blowout games
    And resources shift to closer games
    And final stats are still captured

  # =============================================================================
  # HISTORICAL SCHEDULE DATA
  # =============================================================================

  Scenario: Retrieve past week's schedule
    Given the current week is 16
    When the system requests week 15 schedule
    Then all week 15 games are returned with final scores
    And game status is "Final" for all games
    And this data is used for historical analysis

  Scenario: Backfill schedule for new league
    Given a new league is created mid-season
    And the league starts at week 15
    When the league is activated
    Then the system fetches schedule for weeks 15-18 only
    And does not fetch weeks 1-14 (not needed)
    And API calls are minimized

  Scenario: Archive completed season schedules
    Given the 2023 season has completed
    When the 2024 season begins
    Then 2023 schedule data is archived
    And available for historical reference
    And not included in active polling

  # =============================================================================
  # MULTI-WEEK SCHEDULE VIEW
  # =============================================================================

  Scenario: Retrieve schedule for multiple weeks
    Given a league covers weeks 15-18
    When an admin views the full league schedule
    Then the system fetches schedules for all 4 weeks
    And displays games grouped by week
    And highlights key matchups

  Scenario: Display full league schedule calendar
    Given a league has 4 weeks configured
    When the admin views the schedule
    Then a calendar view shows all weeks
    And game counts per day are displayed
    And bye teams are indicated

  # =============================================================================
  # SCHEDULE CACHING
  # =============================================================================

  Scenario: Cache schedule with appropriate TTL
    Given the schedule for week 15 was fetched
    And no games are in progress
    When a user requests the schedule again
    Then the cached schedule is returned (TTL 1 hour)
    And no API call is made
    When a game is in progress
    Then the cache TTL is reduced to 5 minutes
    And schedule is refreshed more frequently

  Scenario: Invalidate schedule cache on updates
    Given the schedule is cached
    When the NFL announces a time change
    And the system detects the schedule update
    Then the cache is immediately invalidated
    And fresh schedule data is fetched
    And users are notified of changes

  Scenario: Cache schedule per week
    Given week 15 schedule is cached
    And week 16 schedule is requested
    Then week 16 is fetched (cache miss)
    And week 15 cache remains valid
    And each week is cached independently

  Scenario: Cache warm-up on system start
    When the system starts or restarts
    Then schedule for current and upcoming weeks is pre-fetched
    And cache is warmed with fresh data
    And initial user requests are fast

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  Scenario: Handle API timeout when fetching schedule
    Given the SportsData.io API is slow
    When the schedule fetch times out after 10 seconds
    Then the system logs the timeout
    And returns cached schedule if available
    And displays "Last updated: 30 minutes ago"
    And retries after 5 minutes

  Scenario: Handle missing schedule data
    Given the API response is missing game times
    When the system processes the response
    Then the system logs the missing data
    And uses default values or estimates
    And retries the fetch after 15 minutes

  Scenario: Handle invalid week number
    When the system requests schedule for week 99
    Then the API returns HTTP 400 Bad Request
    And the system logs the invalid request
    And returns error "INVALID_WEEK_NUMBER"

  Scenario: Handle API rate limiting
    Given the API rate limit is exceeded
    When the system receives HTTP 429 Too Many Requests
    Then the system backs off exponentially
    And retries after the rate limit reset time
    And logs the rate limit event

  Scenario: Handle partial API response
    Given the API returns only 10 of 16 games
    When the system processes the response
    Then the partial data is accepted
    And missing games are logged
    And a retry is scheduled for complete data

  Scenario: Handle API authentication failure
    Given the API key is expired or invalid
    When the system receives HTTP 401 Unauthorized
    Then the system alerts administrators
    And does not retry with same credentials
    And users see "Schedule temporarily unavailable"

  Scenario: Handle network connectivity issues
    Given network connectivity to SportsData.io is lost
    When the system attempts to fetch schedule
    Then the request fails with connection error
    And cached data is used if available
    And the system retries with backoff

  # =============================================================================
  # SCHEDULE DISPLAY IN UI
  # =============================================================================

  Scenario: Display weekly schedule to users
    Given a user views the league schedule page
    When the schedule for week 15 is loaded
    Then games are displayed in chronological order
    And each game shows:
      | Teams (Home vs Away) |
      | Date and Time        |
      | TV Channel           |
      | Stadium              |
      | Status               |
      | Current/Final Score  |
    And live games are highlighted

  Scenario: Show user's players in schedule
    Given a user has 9 players in their roster
    When the user views the week 15 schedule
    Then games featuring the user's players are highlighted
    And user's player names are shown with team logos
    And helps user track their players' games

  Scenario: Filter schedule by day
    Given a user views week 15 schedule
    When the user filters by "Sunday"
    Then only Sunday games are displayed
    And Thursday/Monday games are hidden

  Scenario: Search schedule by team
    Given a user wants to find Chiefs games
    When the user searches for "KC" or "Chiefs"
    Then all Chiefs games are highlighted
    And results include home and away games

  # =============================================================================
  # INTERNATIONAL GAMES
  # =============================================================================

  Scenario: Handle London/International games
    Given a game is scheduled in London
    When the system fetches the schedule
    Then the game time is in GMT/BST
    And converted to user's local timezone
    And typically played at 9:30 AM ET
    And stadium is in London (e.g., Wembley Stadium)

  Scenario: Handle Germany games
    Given a game is scheduled in Munich, Germany
    When the system fetches the schedule
    Then the game details include:
      | City    | Munich              |
      | Country | Germany             |
      | Time    | 9:30 AM ET (typical)|
    And timezone conversion is accurate

  Scenario: Handle Mexico City games
    Given a game is scheduled in Mexico City
    When the system fetches the schedule
    Then venue shows Estadio Azteca
    And time is typically 4:00 PM local (6:00 PM ET)
    And timezone is America/Mexico_City

  Scenario: Mark international games distinctly
    When a user views the schedule
    Then international games are marked with:
      | London game flag         |
      | International series badge |
      | Stadium country          |
    And users understand the unusual game time

  # =============================================================================
  # PRIMETIME GAMES
  # =============================================================================

  Scenario: Identify Thursday Night Football
    Given week 15 includes Thursday Night Football
    When the system fetches the schedule
    Then the Thursday game is identified
    And scheduled for 8:15 PM ET
    And on Amazon Prime Video
    And marked as "Primetime"

  Scenario: Identify Sunday Night Football
    Given week 15 includes Sunday Night Football
    When the system fetches the schedule
    Then the SNF game is identified
    And scheduled for 8:20 PM ET
    And on NBC
    And typically features top teams

  Scenario: Identify Monday Night Football
    Given week 15 includes Monday Night Football
    When the system fetches the schedule
    Then the MNF game is identified
    And scheduled for 8:15 PM ET
    And on ESPN/ABC
    And may be double-header early in season

  Scenario: Handle Monday Night Football doubleheader
    Given early season week with MNF doubleheader
    When the system fetches the schedule
    Then 2 Monday games are returned
    And first game at 7:15 PM ET
    And second game at 8:30 PM ET

  Scenario: Handle Saturday games in late season
    Given week 16 or 17 includes Saturday games
    When the system fetches the schedule
    Then Saturday games are identified
    And typically multiple games on Saturday
    And NFL Network or Amazon coverage

  Scenario: Identify Black Friday game
    Given Thanksgiving week includes Black Friday game
    When the system fetches the schedule
    Then Friday game is identified
    And scheduled for afternoon kickoff
    And on Amazon Prime Video

  # =============================================================================
  # SCHEDULE NOTIFICATIONS
  # =============================================================================

  Scenario: Notify users of upcoming games
    Given a user has notification preferences set
    When their player's game is 1 hour away
    Then a push notification is sent
    And includes game time and opponent
    And reminds to set lineup if not finalized

  Scenario: Notify users of schedule changes
    Given a game time changes (flex or postponement)
    When the system detects the change
    Then affected users are notified
    And notification includes old and new time
    And roster lock time update is mentioned

  Scenario: Notify users of game start
    Given a user's players are in a starting game
    When the game kicks off
    Then a notification is sent: "Game started: KC vs BUF"
    And user knows to watch for live scoring

  Scenario: Notify users of game completion
    Given a user's players were in a game
    When the game ends
    Then a notification is sent with final score
    And includes summary of fantasy points earned

  # =============================================================================
  # API RATE LIMITING
  # =============================================================================

  Scenario: Manage SportsData.io API rate limits
    Given the API has a limit of 1000 calls per day
    When the system tracks API usage
    Then calls are counted throughout the day
    And warnings are issued at 80% capacity
    And critical operations are prioritized at 95%

  Scenario: Distribute API calls throughout day
    Given games are only on weekends
    When no games are active (weekday)
    Then schedule polling is reduced to once per hour
    And rate limit budget is preserved for game days

  Scenario: Handle burst of API needs
    Given 10 games kick off simultaneously
    When live stats are needed for all 10
    Then requests are staggered over 30 seconds
    And no rate limit violations occur
    And all games receive updates

  # =============================================================================
  # SCHEDULE EXPORT
  # =============================================================================

  Scenario: Export schedule to calendar
    Given a user wants to track their players' games
    When the user requests calendar export
    Then the system generates an iCal file
    And includes all games featuring user's players
    And user can import to Google Calendar, Outlook, etc.

  Scenario: Export full league schedule
    When an admin exports the league schedule
    Then a file is generated with all weeks
    And includes game times, teams, venues
    And available as CSV or iCal format

  Scenario: Subscribe to live calendar feed
    When a user subscribes to calendar feed
    Then a URL is provided for calendar app
    And calendar auto-updates with schedule changes
    And includes game times in user's timezone

  # =============================================================================
  # ADMIN SCHEDULE CONTROLS
  # =============================================================================

  Scenario: Admin views schedule sync status
    When an admin views the schedule dashboard
    Then the last sync time is displayed
    And sync health status is shown
    And any errors are highlighted

  Scenario: Admin triggers manual schedule refresh
    Given the admin suspects schedule is stale
    When the admin clicks "Refresh Schedule"
    Then the system fetches fresh schedule data
    And cache is invalidated
    And new data is displayed

  Scenario: Admin views schedule change history
    When an admin views schedule audit log
    Then all schedule changes are listed
    And includes timestamp and change details
    And helps troubleshoot user complaints

  # =============================================================================
  # MOBILE AND ACCESSIBILITY
  # =============================================================================

  Scenario: Schedule displays correctly on mobile
    When a user views schedule on mobile device
    Then games are displayed in mobile-friendly format
    And game cards stack vertically
    And tap targets are appropriately sized

  Scenario: Schedule is accessible to screen readers
    When a screen reader accesses the schedule
    Then games are announced with team names
    And times are spoken clearly
    And navigation is logical

  Scenario: Schedule supports offline viewing
    Given the user viewed schedule recently
    When the user goes offline
    Then cached schedule is available
    And "Last updated" timestamp is shown
    And stale data warning appears

  # =============================================================================
  # EDGE CASES
  # =============================================================================

  Scenario: Handle NFL lockout or strike
    Given an NFL lockout suspends games
    When the system fetches schedule
    Then games may show as "Postponed" or "Canceled"
    And system handles empty schedule gracefully
    And notifies users of league-wide situation

  Scenario: Handle COVID-like game disruptions
    Given multiple games are affected by illness outbreak
    When games are rescheduled throughout the week
    Then the system tracks all changes
    And notifications are sent for each change
    And roster locks adjust dynamically

  Scenario: Handle season start date changes
    Given the NFL changes week 1 start date
    When the system initializes for new season
    Then the new start date is recognized
    And all week calculations adjust accordingly

  Scenario: Handle 18-game season edge cases
    Given the NFL expanded to 18 games
    When the system handles week 18
    Then week 18 is recognized as final regular season week
    And playoff weeks are 19-22 (not 18-21)
