Feature: NFL Game Schedules via SportsData.io
  As a system
  I want to retrieve NFL game schedules from SportsData.io
  So that I can track when games occur and enable real-time stat polling

  Background:
    Given the system is configured with SportsData.io API
    And the API endpoint is "/scores/json/Schedules/{season}"
    And the current NFL season is 2024

  # Retrieve Full Season Schedule

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

  # Game Status Tracking

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
    Then the status changes to "Final"
    And the winner is determined

  # Game Status Enumeration

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

  # Week Schedule Retrieval

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

  # Game Time Tracking

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

  # Schedule Changes and Updates

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
    And real-time polling schedule is adjusted

  # Bye Weeks

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

  # Playoff Schedule

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

  # Stadium and Venue Information

  Scenario: Retrieve stadium details for game
    When the system fetches game details
    Then stadium information is included:
      | StadiumID        | 15             |
      | Stadium          | Arrowhead Stadium |
      | City             | Kansas City    |
      | State            | MO             |
      | Country          | USA            |
      | Capacity         | 76,416         |
      | PlayingSurface   | Grass          |
      | Type             | Outdoor        |
    And venue details help with player analysis

  Scenario: Identify dome vs outdoor games
    Given weather affects outdoor game performance
    When the system retrieves game stadium info
    Then the Type field indicates:
      | Outdoor    | Weather impacts play  |
      | Dome       | No weather impact     |
      | Retractable| Dome may be open/closed|
    And weather data is fetched for outdoor games

  # Weather Data for Outdoor Games

  Scenario: Retrieve weather forecast for outdoor game
    Given a game is at an outdoor stadium
    And the game is scheduled for Sunday 1:00 PM
    When the system fetches weather data
    Then the forecast includes:
      | Temperature      | 28°F           |
      | WindSpeed        | 15 mph         |
      | WindDirection    | NW             |
      | Humidity         | 65%            |
      | Precipitation    | 20% chance     |
      | Conditions       | Partly Cloudy  |
    And weather warnings are shown if extreme

  Scenario: Warn about extreme weather conditions
    Given a game has forecasted temperature of 5°F
    And wind speed of 30 mph (wind chill -15°F)
    When users view their roster
    Then the system displays weather warning
    And notes "Extreme cold may impact passing game"
    And suggests considering weather-proof players (RBs)

  # Schedule Integration with Live Stats

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

  # Historical Schedule Data

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

  # Multi-week Schedule View

  Scenario: Retrieve schedule for multiple weeks
    Given a league covers weeks 15-18
    When an admin views the full league schedule
    Then the system fetches schedules for all 4 weeks
    And displays games grouped by week
    And highlights key matchups

  # Schedule Caching

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

  # Error Handling

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

  # Schedule Display in UI

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

  # International Games

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

  # Primetime Games

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
    And roster locks extended until Monday

  # Schedule-based Roster Lock

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
    And progressive roster lock by game time

  # Schedule Export

  Scenario: Export schedule to calendar
    Given a user wants to track their players' games
    When the user requests calendar export
    Then the system generates an iCal file
    And includes all games featuring user's players
    And user can import to Google Calendar, Outlook, etc.
