@schedules @anima-1379
Feature: Schedules
  As a fantasy football user
  I want comprehensive scheduling and calendar functionality
  So that I can track NFL games and fantasy matchups

  Background:
    Given I am a logged-in user
    And the schedule system is available

  # ============================================================================
  # NFL SCHEDULE
  # ============================================================================

  @happy-path @nfl-schedule
  Scenario: View game schedule
    Given it is NFL season
    When I view the NFL schedule
    Then I should see all games
    And games should be organized by week

  @happy-path @nfl-schedule
  Scenario: View weekly matchups
    Given I select a week
    When I view weekly matchups
    Then I should see all games for that week
    And matchups should show teams and times

  @happy-path @nfl-schedule
  Scenario: View bye weeks
    Given teams have bye weeks
    When I view bye week schedule
    Then I should see which teams are on bye
    And bye weeks should be by week number

  @happy-path @nfl-schedule
  Scenario: View game times
    Given games are scheduled
    When I view game times
    Then I should see kickoff times
    And times should be in my timezone

  @happy-path @nfl-schedule
  Scenario: View venue information
    Given games have venues
    When I view game details
    Then I should see venue information
    And stadium details should be shown

  @happy-path @nfl-schedule
  Scenario: View primetime games
    Given primetime games exist
    When I filter for primetime
    Then I should see SNF, MNF, TNF games
    And broadcast info should be shown

  @happy-path @nfl-schedule
  Scenario: View team schedule
    Given I select a team
    When I view their schedule
    Then I should see all their games
    And home/away should be indicated

  @happy-path @nfl-schedule
  Scenario: View current week schedule
    Given it is during the season
    When I view current week
    Then I should see this week's games
    And current week should be highlighted

  @happy-path @nfl-schedule
  Scenario: View full season schedule
    Given the season is scheduled
    When I view full schedule
    Then I should see all 18 weeks
    And I can navigate between weeks

  @mobile @nfl-schedule
  Scenario: View schedule on mobile
    Given I am on a mobile device
    When I view the schedule
    Then schedule should be mobile-friendly
    And I should be able to scroll easily

  # ============================================================================
  # LEAGUE SCHEDULE
  # ============================================================================

  @happy-path @league-schedule
  Scenario: View fantasy matchups
    Given I am in a league
    When I view fantasy matchups
    Then I should see my matchup schedule
    And opponent for each week should be shown

  @happy-path @league-schedule
  Scenario: View playoff schedule
    Given playoffs are scheduled
    When I view playoff schedule
    Then I should see playoff weeks
    And bracket structure should be clear

  @happy-path @league-schedule
  Scenario: View regular season schedule
    Given regular season is active
    When I view regular season schedule
    Then I should see all regular season matchups
    And record should be tracked

  @happy-path @league-schedule
  Scenario: View schedule in different views
    Given schedule views are available
    When I switch schedule views
    Then I should see list, grid, or calendar view
    And my preference should be saved

  @happy-path @league-schedule
  Scenario: View opponent schedule
    Given I have an opponent this week
    When I view their schedule
    Then I should see their matchup history
    And strength of schedule should be shown

  @happy-path @league-schedule
  Scenario: View league-wide schedule
    Given I am in a league
    When I view all league matchups
    Then I should see every matchup
    And matchups should be by week

  @happy-path @league-schedule
  Scenario: View remaining schedule
    Given we are mid-season
    When I view remaining schedule
    Then I should see future matchups
    And difficulty should be indicated

  @happy-path @league-schedule
  Scenario: View schedule strength
    Given schedules vary in difficulty
    When I analyze schedule strength
    Then I should see strength rankings
    And remaining strength should be shown

  @happy-path @league-schedule
  Scenario: View divisional matchups
    Given league has divisions
    When I view divisional schedule
    Then I should see in-division games
    And divisional record should be tracked

  @happy-path @league-schedule
  Scenario: Print league schedule
    Given I want a printed schedule
    When I print the schedule
    Then a printable version should open
    And formatting should be clean

  # ============================================================================
  # CALENDAR VIEW
  # ============================================================================

  @happy-path @calendar-view
  Scenario: View calendar integration
    Given calendar view is available
    When I view calendar
    Then I should see schedule in calendar format
    And events should be on correct dates

  @happy-path @calendar-view
  Scenario: View schedule display
    Given I am viewing calendar
    Then games should be displayed as events
    And fantasy matchups should be shown

  @happy-path @calendar-view
  Scenario: View event calendar
    Given events are scheduled
    When I view event calendar
    Then I should see all events
    And I can click for details

  @happy-path @calendar-view
  Scenario: Navigate by date
    Given I am in calendar view
    When I navigate to a date
    Then I should see that day's schedule
    And navigation should be smooth

  @happy-path @calendar-view
  Scenario: View monthly calendar
    Given I want monthly view
    When I select month view
    Then I should see full month
    And game days should be marked

  @happy-path @calendar-view
  Scenario: View weekly calendar
    Given I want weekly view
    When I select week view
    Then I should see the full week
    And each day's games should be visible

  @happy-path @calendar-view
  Scenario: View daily calendar
    Given I want daily view
    When I select day view
    Then I should see that day's schedule
    And games should be timed

  @happy-path @calendar-view
  Scenario: Toggle event types
    Given multiple event types exist
    When I toggle event types
    Then I should filter what's displayed
    And I can show/hide NFL or fantasy

  @happy-path @calendar-view
  Scenario: View color-coded events
    Given events have types
    Then events should be color-coded
    And legend should be available

  @happy-path @calendar-view
  Scenario: View today's schedule
    Given it is a game day
    When I view today
    Then today's games should be highlighted
    And countdown to games should be shown

  # ============================================================================
  # GAME TIMES
  # ============================================================================

  @happy-path @game-times
  Scenario: View kickoff times
    Given games are scheduled
    When I view game times
    Then I should see exact kickoff times
    And times should be accurate

  @happy-path @game-times
  Scenario: Handle timezone display
    Given I have a timezone set
    When I view game times
    Then times should be in my timezone
    And timezone should be indicated

  @happy-path @game-times
  Scenario: Convert time zones
    Given I want another timezone
    When I convert timezone
    Then I should see converted time
    And multiple timezones can be shown

  @happy-path @game-times
  Scenario: View game day information
    Given it is game day
    When I view game info
    Then I should see all game day details
    And start times should be prominent

  @happy-path @game-times
  Scenario: View lineup lock times
    Given lineups lock at game time
    When I view lock times
    Then I should see when lineups lock
    And countdown should be shown

  @happy-path @game-times
  Scenario: View international game times
    Given international games exist
    When I view international games
    Then times should be adjusted
    And location should be noted

  @happy-path @game-times
  Scenario: Set timezone preference
    Given I want to set my timezone
    When I set timezone preference
    Then my preference should be saved
    And all times should adjust

  @happy-path @game-times
  Scenario: View countdown to kickoff
    Given a game is approaching
    When I view countdown
    Then I should see time until kickoff
    And countdown should update live

  @happy-path @game-times
  Scenario: View flex schedule changes
    Given flex scheduling occurs
    When games are flexed
    Then I should see updated times
    And changes should be highlighted

  @happy-path @game-times
  Scenario: View early vs late games
    Given games have different windows
    When I view time slots
    Then I should see early and late games
    And windows should be clear

  # ============================================================================
  # BYE WEEKS
  # ============================================================================

  @happy-path @bye-weeks
  Scenario: Track bye weeks
    Given teams have bye weeks
    When I view bye week tracker
    Then I should see all bye weeks
    And bye weeks should be by team

  @happy-path @bye-weeks
  Scenario: Receive roster alerts for byes
    Given my players have bye weeks
    When bye week approaches
    Then I should receive alerts
    And affected players should be listed

  @happy-path @bye-weeks
  Scenario: Plan for bye weeks
    Given I want to plan ahead
    When I view bye week planning
    Then I should see upcoming byes
    And roster impact should be shown

  @happy-path @bye-weeks
  Scenario: Analyze schedule impact
    Given bye weeks affect roster
    When I analyze impact
    Then I should see which weeks are tough
    And recommendations should be provided

  @happy-path @bye-weeks
  Scenario: View bye week summary
    Given I am viewing bye weeks
    Then I should see summary view
    And all teams organized by week

  @happy-path @bye-weeks
  Scenario: Filter roster by bye week
    Given I have rostered players
    When I filter by bye week
    Then I should see players on bye
    And I can plan replacements

  @happy-path @bye-weeks
  Scenario: View common bye weeks
    Given multiple players share bye weeks
    When I view common byes
    Then I should see conflicts
    And problematic weeks should be flagged

  @happy-path @bye-weeks
  Scenario: Get bye week fill-in suggestions
    Given a player is on bye
    When I need a replacement
    Then I should see suggestions
    And waiver options should be shown

  @happy-path @bye-weeks
  Scenario: View bye week countdown
    Given bye weeks are coming
    When I view countdown
    Then I should see days until bye
    And preparation reminders should appear

  @happy-path @bye-weeks
  Scenario: Export bye week schedule
    Given I want bye week data
    When I export bye weeks
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # SCHEDULE ALERTS
  # ============================================================================

  @happy-path @schedule-alerts
  Scenario: Receive game reminders
    Given I have reminders enabled
    When game time approaches
    Then I should receive reminder
    And reminder should be timely

  @happy-path @schedule-alerts
  Scenario: Receive lineup lock alerts
    Given lineups are due
    When lock time approaches
    Then I should receive lock alert
    And I should set my lineup

  @happy-path @schedule-alerts
  Scenario: Receive schedule change alerts
    Given a game is rescheduled
    When schedule changes
    Then I should be notified
    And new time should be shown

  @happy-path @schedule-alerts
  Scenario: Receive weather updates
    Given weather affects games
    When weather alerts are issued
    Then I should be notified
    And fantasy impact should be noted

  @happy-path @schedule-alerts
  Scenario: Configure alert timing
    Given I want custom timing
    When I configure alert timing
    Then I should set when to receive alerts
    And preferences should be saved

  @happy-path @schedule-alerts
  Scenario: Receive matchup reminder
    Given I have a fantasy matchup
    When matchup starts
    Then I should receive reminder
    And I can view matchup

  @happy-path @schedule-alerts
  Scenario: Disable schedule alerts
    Given I receive too many alerts
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  @happy-path @schedule-alerts
  Scenario: View alert history
    Given I have received alerts
    When I view alert history
    Then I should see past alerts
    And history should be searchable

  @happy-path @schedule-alerts
  Scenario: Set team-specific alerts
    Given I follow specific teams
    When I set team alerts
    Then I should get alerts for those teams
    And I can customize per team

  @happy-path @schedule-alerts
  Scenario: Receive playoff schedule alerts
    Given playoffs are coming
    When playoff schedule is set
    Then I should be notified
    And dates should be clear

  # ============================================================================
  # SCHEDULE SYNC
  # ============================================================================

  @happy-path @schedule-sync
  Scenario: Sync to calendar app
    Given I use a calendar app
    When I sync schedule
    Then events should sync
    And calendar should update

  @happy-path @schedule-sync
  Scenario: Export to calendar
    Given I want to export
    When I export schedule
    Then I should receive calendar file
    And I can import to any calendar

  @happy-path @schedule-sync
  Scenario: Sync to Google Calendar
    Given I use Google Calendar
    When I connect Google Calendar
    Then schedule should sync
    And updates should be automatic

  @happy-path @schedule-sync
  Scenario: Sync to Apple Calendar
    Given I use Apple Calendar
    When I connect Apple Calendar
    Then schedule should sync
    And updates should be automatic

  @happy-path @schedule-sync
  Scenario: Export iCal format
    Given I want iCal file
    When I export as iCal
    Then I should receive .ics file
    And file should be valid

  @happy-path @schedule-sync
  Scenario: Configure sync options
    Given I have sync connected
    When I configure sync options
    Then I should choose what to sync
    And preferences should be saved

  @happy-path @schedule-sync
  Scenario: Disconnect calendar sync
    Given I have sync connected
    When I disconnect sync
    Then sync should stop
    And I can reconnect later

  @happy-path @schedule-sync
  Scenario: Sync fantasy matchups only
    Given I want fantasy events only
    When I configure sync
    Then only fantasy events should sync
    And NFL games should be excluded

  @happy-path @schedule-sync
  Scenario: View sync status
    Given I have sync enabled
    When I check sync status
    Then I should see sync health
    And last sync time should be shown

  @happy-path @schedule-sync
  Scenario: Force manual sync
    Given sync may be outdated
    When I force sync
    Then sync should run immediately
    And confirmation should appear

  # ============================================================================
  # PLAYOFF SCHEDULE
  # ============================================================================

  @happy-path @playoff-schedule
  Scenario: View playoff brackets
    Given playoffs are scheduled
    When I view playoff bracket
    Then I should see bracket structure
    And matchups should be clear

  @happy-path @playoff-schedule
  Scenario: View playoff dates
    Given playoff weeks are set
    When I view playoff dates
    Then I should see each round's dates
    And timeline should be visible

  @happy-path @playoff-schedule
  Scenario: View championship week
    Given championship is scheduled
    When I view championship week
    Then I should see championship details
    And matchup should be highlighted

  @happy-path @playoff-schedule
  Scenario: View consolation games
    Given consolation games exist
    When I view consolation bracket
    Then I should see consolation matchups
    And schedule should be clear

  @happy-path @playoff-schedule
  Scenario: View playoff seeding preview
    Given playoffs approach
    When I view seeding preview
    Then I should see projected seeds
    And clinching scenarios should be shown

  @happy-path @playoff-schedule
  Scenario: View path to championship
    Given I am in playoffs
    When I view my path
    Then I should see potential matchups
    And each round should be shown

  @happy-path @playoff-schedule
  Scenario: View playoff schedule by week
    Given playoffs span weeks
    When I view by week
    Then I should see each week's games
    And rounds should be labeled

  @happy-path @playoff-schedule
  Scenario: View wild card schedule
    Given wild card games exist
    When I view wild card week
    Then I should see wild card matchups
    And advancing teams should be tracked

  @happy-path @playoff-schedule
  Scenario: View third place game
    Given third place game exists
    When I view third place matchup
    Then I should see the matchup
    And it should be scheduled correctly

  @happy-path @playoff-schedule
  Scenario: Print playoff bracket
    Given I want printed bracket
    When I print bracket
    Then printable bracket should open
    And format should be clean

  # ============================================================================
  # SCHEDULE SEARCH
  # ============================================================================

  @happy-path @schedule-search
  Scenario: Find specific games
    Given I want a specific game
    When I search for the game
    Then I should find matching results
    And search should be fast

  @happy-path @schedule-search
  Scenario: Filter schedule by team
    Given I want team-specific games
    When I filter by team
    Then I should see that team's games
    And filter should be clearable

  @happy-path @schedule-search
  Scenario: Filter schedule by week
    Given I want specific week
    When I filter by week
    Then I should see that week's games
    And week selection should be easy

  @happy-path @schedule-search
  Scenario: Search by date range
    Given I want games in a range
    When I search by date range
    Then I should see games in that range
    And dates should be selectable

  @happy-path @schedule-search
  Scenario: Filter by game type
    Given different game types exist
    When I filter by type
    Then I should see matching games
    And type options should be clear

  @happy-path @schedule-search
  Scenario: Search upcoming games
    Given I want future games
    When I search upcoming
    Then I should see future games only
    And past games should be excluded

  @happy-path @schedule-search
  Scenario: Search past games
    Given I want historical games
    When I search past games
    Then I should see past games
    And results should be included

  @happy-path @schedule-search
  Scenario: Use advanced schedule search
    Given I need specific results
    When I use advanced search
    Then I should combine multiple filters
    And results should be precise

  @happy-path @schedule-search
  Scenario: Save schedule search
    Given I want to repeat a search
    When I save the search
    Then search should be saved
    And I can run it again

  @happy-path @schedule-search
  Scenario: View search results
    Given I searched the schedule
    When I view results
    Then results should be organized
    And I can sort and filter further

  # ============================================================================
  # SCHEDULE HISTORY
  # ============================================================================

  @happy-path @schedule-history
  Scenario: View past schedules
    Given past seasons exist
    When I view schedule history
    Then I should see past schedules
    And I can select any season

  @happy-path @schedule-history
  Scenario: View historical matchups
    Given historical data exists
    When I view past matchups
    Then I should see historical games
    And results should be shown

  @happy-path @schedule-history
  Scenario: View season archives
    Given archives are available
    When I access archives
    Then I should see archived seasons
    And I can browse any season

  @happy-path @schedule-history
  Scenario: View game results
    Given games have been played
    When I view game results
    Then I should see final scores
    And box scores should be available

  @happy-path @schedule-history
  Scenario: Compare schedules across seasons
    Given multiple seasons exist
    When I compare schedules
    Then I should see differences
    And changes should be highlighted

  @happy-path @schedule-history
  Scenario: View league history schedule
    Given league has history
    When I view league schedule history
    Then I should see past fantasy matchups
    And results should be shown

  @happy-path @schedule-history
  Scenario: Export schedule history
    Given I want historical data
    When I export history
    Then I should receive export file
    And data should be comprehensive

  @happy-path @schedule-history
  Scenario: View memorable games
    Given notable games occurred
    When I view memorable games
    Then I should see highlighted games
    And significance should be explained

  @happy-path @schedule-history
  Scenario: View head-to-head history
    Given I have played opponent before
    When I view H2H history
    Then I should see our matchup history
    And all-time record should be shown

  @happy-path @schedule-history
  Scenario: View franchise records by schedule
    Given records exist
    When I view records
    Then I should see best/worst by schedule
    And records should be interesting
