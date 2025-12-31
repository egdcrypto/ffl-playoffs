@nfl-schedule @ANIMA-1336
Feature: NFL Schedule
  As a fantasy football application user
  I want comprehensive NFL schedule functionality
  So that I can track games, plan my lineup, and stay informed about matchups

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # GAME SCHEDULES - HAPPY PATH
  # ============================================================================

  @happy-path @game-schedules
  Scenario: View current week schedule
    Given it is the regular season
    When I view the current week's schedule
    Then I should see all games for the week
    And games should be organized by day
    And I should see matchup information

  @happy-path @game-schedules
  Scenario: View full season schedule
    Given I want to see the entire season
    When I view the full schedule
    Then I should see all 18 weeks
    And I should navigate between weeks
    And I should see game counts per week

  @happy-path @game-schedules
  Scenario: View team-specific schedule
    Given I want a specific team's schedule
    When I select an NFL team
    Then I should see their full season schedule
    And I should see home and away games
    And I should see opponent information

  @happy-path @game-schedules
  Scenario: View schedule by week
    Given I want a specific week
    When I select a week number
    Then I should see all games that week
    And I should see dates and times
    And I should see broadcast information

  @happy-path @game-schedules
  Scenario: View past game results
    Given games have been played
    When I view past weeks
    Then I should see final scores
    And I should see game outcomes
    And I should see key statistics

  @happy-path @game-schedules
  Scenario: View upcoming games
    Given I want to see future games
    When I view upcoming schedule
    Then I should see scheduled games
    And times should be in my timezone
    And I should see days until game

  # ============================================================================
  # KICKOFF TIMES
  # ============================================================================

  @happy-path @kickoff-times
  Scenario: View kickoff time in local timezone
    Given I have my timezone set
    When I view game times
    Then times should display in my timezone
    And I should see timezone indicator
    And times should be accurate

  @happy-path @kickoff-times
  Scenario: View all kickoff slots
    Given games are scheduled
    When I view the schedule
    Then I should see 1pm ET games
    And I should see 4pm ET games
    And I should see primetime games

  @happy-path @kickoff-times
  Scenario: View international game times
    Given there are international games
    When I view those games
    Then I should see adjusted kickoff times
    And I should see location information
    And times should be clear

  @happy-path @kickoff-times
  Scenario: Receive kickoff reminders
    Given I want game reminders
    When I enable kickoff notifications
    Then I should receive reminders before games
    And I should customize reminder timing
    And reminders should be accurate

  @happy-path @kickoff-times
  Scenario: View countdown to kickoff
    Given a game is approaching
    When I view the game details
    Then I should see time until kickoff
    And countdown should update
    And I should plan accordingly

  @happy-path @kickoff-times
  Scenario: Handle flexible scheduling
    Given NFL uses flexible scheduling
    When games are flexed
    Then I should see updated times
    And I should be notified of changes
    And the schedule should reflect changes

  # ============================================================================
  # TV BROADCASTS
  # ============================================================================

  @happy-path @tv-broadcasts
  Scenario: View broadcast network
    Given games have broadcast assignments
    When I view a game
    Then I should see the broadcast network
    And I should see CBS, FOX, NBC, ESPN, etc.
    And I should plan viewing accordingly

  @happy-path @tv-broadcasts
  Scenario: View streaming options
    Given streaming is available
    When I check game broadcasts
    Then I should see streaming platforms
    And I should see NFL+, Prime, etc.
    And I should access streams

  @happy-path @tv-broadcasts
  Scenario: View local broadcast information
    Given I want local coverage
    When I view games in my market
    Then I should see local affiliates
    And I should see channel numbers
    And I should find my local game

  @happy-path @tv-broadcasts
  Scenario: View national broadcast games
    Given national games are scheduled
    When I view the schedule
    Then national games should be highlighted
    And I should see broadcast details
    And I should see announcer information

  @happy-path @tv-broadcasts
  Scenario: View RedZone coverage
    Given NFL RedZone is available
    When I check Sunday coverage
    Then I should see RedZone information
    And I should see covered games
    And I should know coverage hours

  @happy-path @tv-broadcasts
  Scenario: Check game blackout status
    Given blackout rules may apply
    When I check a local game
    Then I should see blackout information
    And I should see alternatives
    And blackouts should be explained

  # ============================================================================
  # BYE WEEKS
  # ============================================================================

  @happy-path @bye-weeks
  Scenario: View team bye weeks
    Given teams have bye weeks
    When I view bye week schedule
    Then I should see all team byes
    And byes should be organized by week
    And I should plan roster accordingly

  @happy-path @bye-weeks
  Scenario: View my players' bye weeks
    Given I have rostered players
    When I check bye weeks
    Then I should see my players' byes
    And I should see conflicts
    And I should plan coverage

  @happy-path @bye-weeks
  Scenario: View bye week by team
    Given I want a specific team's bye
    When I check that team
    Then I should see their bye week
    And I should see the week number
    And I should see the date range

  @happy-path @bye-weeks
  Scenario: Get bye week alerts
    Given my players have upcoming byes
    When bye week approaches
    Then I should receive alerts
    And I should be reminded to find coverage
    And alerts should be timely

  @happy-path @bye-weeks
  Scenario: View teams on bye this week
    Given it is a game week
    When I check current bye teams
    Then I should see teams on bye
    And I should see their players affected
    And I should adjust my lineup

  @happy-path @bye-weeks
  Scenario: Plan around bye weeks
    Given I am managing my roster
    When I view bye week impact
    Then I should see affected weeks
    And I should see roster gaps
    And I should plan acquisitions

  # ============================================================================
  # GAME RESULTS
  # ============================================================================

  @happy-path @game-results
  Scenario: View final score
    Given a game has ended
    When I view the game
    Then I should see the final score
    And I should see the winner
    And I should see overtime if applicable

  @happy-path @game-results
  Scenario: View game summary
    Given a game is complete
    When I view game details
    Then I should see scoring summary
    And I should see key plays
    And I should see game highlights

  @happy-path @game-results
  Scenario: View box score
    Given I want detailed results
    When I view the box score
    Then I should see team statistics
    And I should see player statistics
    And I should see quarter-by-quarter

  @happy-path @game-results
  Scenario: View fantasy-relevant results
    Given I play fantasy football
    When I view game results
    Then I should see fantasy scoring
    And I should see top performers
    And I should see my players' results

  @happy-path @game-results
  Scenario: View historical results
    Given I want past game results
    When I view previous weeks
    Then I should see all results
    And I should filter by team
    And history should be complete

  @happy-path @game-results
  Scenario: Compare game results
    Given multiple games occurred
    When I compare results
    Then I should see side-by-side outcomes
    And I should see trends
    And comparisons should be useful

  # ============================================================================
  # SCORE UPDATES
  # ============================================================================

  @happy-path @score-updates
  Scenario: View live scores
    Given games are in progress
    When I view live scores
    Then I should see current scores
    And scores should update in real-time
    And I should see game status

  @happy-path @score-updates
  Scenario: View score ticker
    Given I want quick score updates
    When I view the score ticker
    Then I should see all active games
    And scores should scroll or update
    And I should access game details

  @happy-path @score-updates
  Scenario: Receive score notifications
    Given I enabled score alerts
    When scoring occurs
    Then I should receive notifications
    And I should see scoring details
    And notifications should be timely

  @happy-path @score-updates
  Scenario: View quarter/half updates
    Given a game is in progress
    When quarters or halves end
    Then I should see updated scores
    And I should see time remaining
    And quarter breaks should be noted

  @happy-path @score-updates
  Scenario: View scoring plays
    Given I want scoring details
    When I view scoring plays
    Then I should see each score
    And I should see who scored
    And I should see play descriptions

  @happy-path @score-updates
  Scenario: Track red zone updates
    Given teams are in the red zone
    When I monitor games
    Then I should see red zone alerts
    And I should see scoring opportunities
    And updates should be immediate

  # ============================================================================
  # STADIUM INFORMATION
  # ============================================================================

  @happy-path @stadium-information
  Scenario: View stadium details
    Given a game is scheduled
    When I view stadium info
    Then I should see stadium name
    And I should see location
    And I should see capacity

  @happy-path @stadium-information
  Scenario: View stadium type
    Given I want venue information
    When I check stadium type
    Then I should see indoor/outdoor
    And I should see dome/retractable
    And I should see surface type

  @happy-path @stadium-information
  Scenario: View stadium for away games
    Given a team is playing away
    When I view their schedule
    Then I should see visiting stadium
    And I should see travel distance
    And I should factor in travel

  @happy-path @stadium-information
  Scenario: View neutral site games
    Given a game is at neutral site
    When I view game details
    Then I should see neutral location
    And I should see venue information
    And I should understand the context

  @happy-path @stadium-information
  Scenario: View international venue
    Given a game is international
    When I view venue details
    Then I should see international stadium
    And I should see country/city
    And I should see special considerations

  @happy-path @stadium-information
  Scenario: View stadium altitude
    Given altitude may affect play
    When I check Denver games
    Then I should see altitude information
    And I should understand impact
    And I should factor into analysis

  # ============================================================================
  # WEATHER CONDITIONS
  # ============================================================================

  @happy-path @weather-conditions
  Scenario: View game weather forecast
    Given a game is outdoors
    When I view weather forecast
    Then I should see temperature
    And I should see precipitation chance
    And I should see wind conditions

  @happy-path @weather-conditions
  Scenario: View weather impact on fantasy
    Given weather may affect play
    When I assess weather impact
    Then I should see fantasy implications
    And I should see affected players
    And I should adjust expectations

  @happy-path @weather-conditions
  Scenario: View dome game conditions
    Given a game is indoors
    When I check conditions
    Then I should see controlled environment
    And weather should not be a factor
    And I should know it's indoor

  @happy-path @weather-conditions
  Scenario: View severe weather alerts
    Given severe weather is possible
    When alerts are issued
    Then I should see weather warnings
    And I should see potential delays
    And I should monitor updates

  @happy-path @weather-conditions
  Scenario: Track weather updates
    Given game time approaches
    When weather updates occur
    Then I should see updated forecasts
    And I should see changing conditions
    And I should adjust if needed

  @happy-path @weather-conditions
  Scenario: View wind impact on kickers
    Given wind affects kicking
    When I view kicker matchups
    Then I should see wind speed
    And I should see wind direction
    And I should assess field goal impact

  @happy-path @weather-conditions
  Scenario: View precipitation impact
    Given rain or snow is expected
    When I view affected games
    Then I should see precipitation type
    And I should see intensity forecast
    And I should understand passing impact

  # ============================================================================
  # PRIMETIME GAMES
  # ============================================================================

  @happy-path @primetime-games
  Scenario: View Thursday Night Football
    Given it is Thursday
    When I view TNF schedule
    Then I should see the Thursday game
    And I should see broadcast info
    And I should see kickoff time

  @happy-path @primetime-games
  Scenario: View Sunday Night Football
    Given it is Sunday evening
    When I view SNF schedule
    Then I should see the Sunday night game
    And I should see NBC broadcast
    And I should see primetime coverage

  @happy-path @primetime-games
  Scenario: View Monday Night Football
    Given it is Monday
    When I view MNF schedule
    Then I should see Monday game(s)
    And I should see ESPN broadcast
    And I should see kickoff time

  @happy-path @primetime-games
  Scenario: View Saturday games
    Given it is late season Saturday
    When I view Saturday schedule
    Then I should see Saturday games
    And I should see broadcast information
    And I should see kickoff times

  @happy-path @primetime-games
  Scenario: View holiday games
    Given there is a holiday
    When I view holiday schedule
    Then I should see Thanksgiving games
    And I should see Christmas games
    And I should see special scheduling

  @happy-path @primetime-games
  Scenario: Track flex scheduling changes
    Given games can be flexed
    When flex decisions are made
    Then I should see updated primetime
    And I should see which games moved
    And I should understand the changes

  # ============================================================================
  # PLAYOFF SCHEDULE
  # ============================================================================

  @happy-path @playoff-schedule
  Scenario: View playoff bracket
    Given playoffs are approaching
    When I view playoff schedule
    Then I should see the bracket
    And I should see matchups
    And I should see seeding

  @happy-path @playoff-schedule
  Scenario: View Wild Card weekend
    Given it is Wild Card week
    When I view Wild Card games
    Then I should see all Wild Card matchups
    And I should see times and broadcasts
    And I should see stadium locations

  @happy-path @playoff-schedule
  Scenario: View Divisional round
    Given it is Divisional round
    When I view Divisional games
    Then I should see four games
    And I should see matchups and times
    And I should see venues

  @happy-path @playoff-schedule
  Scenario: View Conference championships
    Given it is Championship week
    When I view championship games
    Then I should see AFC/NFC matchups
    And I should see game details
    And I should see Super Bowl implications

  @happy-path @playoff-schedule
  Scenario: View Super Bowl information
    Given the Super Bowl is scheduled
    When I view Super Bowl details
    Then I should see the matchup
    And I should see date and location
    And I should see broadcast information

  @happy-path @playoff-schedule
  Scenario: Track playoff scenarios
    Given playoff positioning matters
    When I view scenarios
    Then I should see clinching scenarios
    And I should see elimination scenarios
    And I should understand implications

  # ============================================================================
  # SCHEDULE SYNCHRONIZATION
  # ============================================================================

  @happy-path @schedule-sync
  Scenario: Sync schedule to calendar
    Given I want calendar integration
    When I sync to my calendar
    Then games should appear in calendar
    And I should select which games
    And calendar should update

  @happy-path @schedule-sync
  Scenario: Sync with Google Calendar
    Given I use Google Calendar
    When I connect and sync
    Then games should appear in Google
    And updates should sync
    And I should manage the connection

  @happy-path @schedule-sync
  Scenario: Sync with Apple Calendar
    Given I use Apple Calendar
    When I sync the schedule
    Then games should appear on my devices
    And sync should be automatic
    And I should configure preferences

  @happy-path @schedule-sync
  Scenario: Sync team schedule only
    Given I want specific teams
    When I choose teams to sync
    Then only those games should sync
    And I should add or remove teams
    And sync should reflect choices

  @happy-path @schedule-sync
  Scenario: Handle schedule changes
    Given the schedule changes
    When updates occur
    Then my calendar should update
    And I should see changes
    And sync should be automatic

  @happy-path @schedule-sync
  Scenario: Remove calendar sync
    Given I want to stop syncing
    When I disconnect calendar
    Then games should be removed
    And the connection should end
    And I should re-connect later

  # ============================================================================
  # MATCHUP ANALYSIS
  # ============================================================================

  @happy-path @matchup-analysis
  Scenario: View upcoming matchup preview
    Given a game is scheduled
    When I view matchup preview
    Then I should see team comparisons
    And I should see key players
    And I should see betting lines

  @happy-path @matchup-analysis
  Scenario: View head-to-head history
    Given teams have played before
    When I view history
    Then I should see previous matchups
    And I should see recent results
    And I should see historical trends

  @happy-path @matchup-analysis
  Scenario: View key matchups
    Given the game has storylines
    When I view key matchups
    Then I should see player matchups
    And I should see strength vs weakness
    And I should see fantasy implications

  @happy-path @matchup-analysis
  Scenario: View injury report impact
    Given injuries affect matchups
    When I view injury context
    Then I should see injured players
    And I should see matchup impact
    And analysis should adjust

  @happy-path @matchup-analysis
  Scenario: View betting information
    Given betting lines are available
    When I view game odds
    Then I should see point spread
    And I should see over/under
    And I should see moneyline

  # ============================================================================
  # SCHEDULE NOTIFICATIONS
  # ============================================================================

  @happy-path @schedule-notifications
  Scenario: Receive game day notifications
    Given it is game day
    When games approach
    Then I should receive notifications
    And I should see game info
    And notifications should be timely

  @happy-path @schedule-notifications
  Scenario: Receive schedule change notifications
    Given the schedule changes
    When changes are announced
    Then I should be notified
    And I should see what changed
    And I should update plans

  @happy-path @schedule-notifications
  Scenario: Receive flex scheduling notifications
    Given a game is flexed
    When flex is announced
    Then I should receive notification
    And I should see new time
    And I should see reason

  @happy-path @schedule-notifications
  Scenario: Customize schedule notifications
    Given I want specific notifications
    When I set preferences
    Then I should choose notification types
    And I should set timing
    And preferences should persist

  @happy-path @schedule-notifications
  Scenario: Receive my team notifications
    Given I follow specific teams
    When their games approach
    Then I should receive team-specific alerts
    And alerts should be personalized
    And I should manage team preferences

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Schedule data unavailable
    Given I try to view schedule
    When data is unavailable
    Then I should see error message
    And I should see cached data if available
    And I should retry later

  @error
  Scenario: Live scores connection lost
    Given I am viewing live scores
    When connection is lost
    Then I should see connection error
    And I should see last known scores
    And I should retry connection

  @error
  Scenario: Calendar sync fails
    Given I try to sync calendar
    When sync fails
    Then I should see error message
    And I should troubleshoot
    And I should retry

  @error
  Scenario: Weather data unavailable
    Given I want weather info
    When weather data is unavailable
    Then I should see appropriate message
    And other game info should display
    And I should check later

  @error
  Scenario: Invalid week selection
    Given I try to view a week
    When the week is invalid
    Then I should see error
    And I should select valid week
    And valid options should show

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View schedule on mobile
    Given I am using the mobile app
    When I view the schedule
    Then schedule should be mobile-optimized
    And I should scroll through games
    And navigation should be easy

  @mobile
  Scenario: View live scores on mobile
    Given I am on mobile
    When I check live scores
    Then scores should update on mobile
    And display should be compact
    And I should access game details

  @mobile
  Scenario: Receive notifications on mobile
    Given I have mobile notifications enabled
    When schedule events occur
    Then I should receive push notifications
    And notifications should be actionable
    And I should tap to view details

  @mobile
  Scenario: Sync calendar from mobile
    Given I am on mobile
    When I sync to calendar
    Then sync should work on mobile
    And I should see confirmation
    And calendar app should update

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate schedule with keyboard
    Given I am using keyboard navigation
    When I browse the schedule
    Then I should navigate with keyboard
    And I should access all games
    And focus should be visible

  @accessibility
  Scenario: Screen reader schedule access
    Given I am using a screen reader
    When I view the schedule
    Then game info should be announced
    And times should be read correctly
    And structure should be clear

  @accessibility
  Scenario: High contrast schedule display
    Given I have high contrast enabled
    When I view the schedule
    Then games should be visible
    And scores should be readable
    And times should be clear

  @accessibility
  Scenario: Schedule with reduced motion
    Given I have reduced motion enabled
    When I view live updates
    Then updates should not animate excessively
    And transitions should be simple
    And functionality should work
