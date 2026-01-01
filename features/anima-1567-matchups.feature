@matchups
Feature: Matchups
  As a fantasy football team owner
  I want to view and track my weekly matchups
  So that I can compete against opponents and track my performance

  # Weekly Matchups Scenarios
  @weekly-matchups
  Scenario: View current week matchup
    Given the fantasy season is active
    When I view my current week matchup
    Then I should see my opponent
    And I should see both team rosters
    And I should see current scores

  @weekly-matchups
  Scenario: View weekly opponent assignment
    Given the schedule has been generated
    When I view my schedule
    Then I should see my opponent for each week
    And matchups should be clearly displayed
    And I should be able to navigate between weeks

  @weekly-matchups
  Scenario: View matchup scheduling
    Given I am a league member
    When I view the full schedule
    Then I should see all matchups for all weeks
    And schedule should be organized by week
    And my matchups should be highlighted

  @weekly-matchups
  Scenario: Handle bye week in matchups
    Given the league has bye weeks
    When I am on a bye week
    Then my matchup should show bye status
    And I should not have an opponent
    And standings should account for bye

  @weekly-matchups
  Scenario: View upcoming matchups
    Given the season is in progress
    When I view upcoming matchups
    Then I should see future opponents
    And I should see opponent team strength
    And I should be able to prepare strategy

  @weekly-matchups
  Scenario: View matchup countdown
    Given my matchup is upcoming
    When I view matchup details
    Then I should see countdown to first game
    And time should be in my timezone
    And I should see lineup lock times

  @weekly-matchups
  Scenario: View all league matchups for week
    Given a week is in progress
    When I view league matchups
    Then I should see all pairings
    And I should see live scores
    And close matchups should be highlighted

  @weekly-matchups
  Scenario: Handle multi-week matchups
    Given the league uses multi-week matchups
    When I view my matchup
    Then I should see combined scoring period
    And both weeks should be tracked
    And running total should display

  # Matchup Display Scenarios
  @matchup-display
  Scenario: View matchup preview
    Given my matchup has not started
    When I view the matchup preview
    Then I should see projected scores
    And I should see lineup comparisons
    And I should see key player matchups

  @matchup-display
  Scenario: View live matchup
    Given games are in progress
    When I view my live matchup
    Then I should see real-time scores
    And scores should update automatically
    And I should see which players are playing

  @matchup-display
  Scenario: View player-by-player comparison
    Given I am viewing a matchup
    When I view player comparison
    Then I should see side-by-side positions
    And I should see projected vs actual
    And I should see advantage indicators

  @matchup-display
  Scenario: Display matchup scores
    Given matchup has scoring
    When I view score display
    Then scores should be prominent
    And decimal places should be consistent
    And leader should be clearly indicated

  @matchup-display
  Scenario: View matchup on mobile
    Given I am using mobile device
    When I view my matchup
    Then display should be optimized for mobile
    And all information should be accessible
    And scrolling should be smooth

  @matchup-display
  Scenario: View completed matchup
    Given a matchup has concluded
    When I view the completed matchup
    Then final scores should be displayed
    And winner should be indicated
    And I should see scoring breakdown

  @matchup-display
  Scenario: Share matchup view
    Given I am viewing a matchup
    When I share the matchup
    Then shareable link should be generated
    And preview should look good
    And recipients should be able to view

  @matchup-display
  Scenario: View matchup in dark mode
    Given dark mode is enabled
    When I view matchups
    Then display should use dark theme
    And all elements should be visible
    And contrast should be appropriate

  # Matchup Projections Scenarios
  @matchup-projections
  Scenario: View win probability
    Given I am viewing my matchup
    When I view win probability
    Then percentage should display
    And probability should update with scoring
    And I should see probability trend

  @matchup-projections
  Scenario: View projected final scores
    Given matchup is upcoming
    When I view projections
    Then I should see projected totals
    And projections should be based on rankings
    And I should see projection range

  @matchup-projections
  Scenario: View player projections in matchup
    Given I am viewing matchup details
    When I view player projections
    Then each player should have projection
    And projections should sum to team total
    And I should see projection confidence

  @matchup-projections
  Scenario: View matchup analysis
    Given I want to analyze my matchup
    When I access matchup analysis
    Then I should see strengths and weaknesses
    And I should see key factors
    And I should see recommendations

  @matchup-projections
  Scenario: Update projections during games
    Given games are in progress
    When projections update
    Then remaining projections should adjust
    And actual scores should replace projections
    And win probability should recalculate

  @matchup-projections
  Scenario: Compare projection sources
    Given multiple projection sources exist
    When I compare sources
    Then I should see different projections
    And I should see source accuracy
    And I should be able to select preferred source

  @matchup-projections
  Scenario: View projection accuracy history
    Given I have past matchups
    When I view projection accuracy
    Then I should see how accurate projections were
    And I should see trends over time
    And I should see by-player accuracy

  @matchup-projections
  Scenario: Get lineup suggestions from projections
    Given I am setting my lineup
    When I view projection-based suggestions
    Then I should see optimal lineup
    And I should see projected improvement
    And I should be able to apply suggestions

  # Playoff Matchups Scenarios
  @playoff-matchups
  Scenario: Generate playoff bracket
    Given regular season has ended
    When playoffs begin
    Then bracket should be generated
    And seeding should follow rules
    And bracket should be viewable

  @playoff-matchups
  Scenario: Apply seeding rules
    Given standings are finalized
    When seeding is determined
    Then seeds should follow configured rules
    And tiebreakers should be applied
    And seeds should be displayed correctly

  @playoff-matchups
  Scenario: View wildcard matchups
    Given wildcard round exists
    When I view wildcard matchups
    Then wildcard teams should be shown
    And matchups should be correct
    And advancement paths should be clear

  @playoff-matchups
  Scenario: View championship game
    Given championship week has arrived
    When I view championship matchup
    Then finalist teams should be shown
    And stakes should be highlighted
    And championship trophy should display

  @playoff-matchups
  Scenario: Advance through playoff rounds
    Given a playoff round has concluded
    When winners advance
    Then bracket should update
    And next round matchups should show
    And eliminated teams should be marked

  @playoff-matchups
  Scenario: Handle playoff bye weeks
    Given top seeds have byes
    When bye round occurs
    Then bye teams should be shown as waiting
    And bracket should reflect byes
    And next opponents should be TBD

  @playoff-matchups
  Scenario: View playoff matchup history
    Given playoffs have occurred in past
    When I view playoff history
    Then I should see past playoff matchups
    And champions should be highlighted
    And I should see playoff performance

  @playoff-matchups
  Scenario: Simulate playoff scenarios
    Given playoffs are upcoming
    When I simulate scenarios
    Then I should see different outcomes
    And I should see my playoff chances
    And simulations should be accurate

  # Matchup History Scenarios
  @matchup-history
  Scenario: View historical head-to-head record
    Given I have played an opponent before
    When I view head-to-head history
    Then I should see all-time record
    And I should see past matchup scores
    And I should see win/loss breakdown

  @matchup-history
  Scenario: Track rivalries
    Given I have frequent opponents
    When I view rivalries
    Then closest rivalries should be highlighted
    And rivalry records should display
    And rivalry intensity should be indicated

  @matchup-history
  Scenario: View all-time matchup stats
    Given history exists
    When I view all-time stats
    Then I should see total games played
    And I should see aggregate scores
    And I should see best and worst matchups

  @matchup-history
  Scenario: Compare matchup performance over time
    Given I have matchup history
    When I compare over time
    Then I should see performance trends
    And I should see improvement or decline
    And I should see key turning points

  @matchup-history
  Scenario: View record against each opponent
    Given league has multiple seasons
    When I view opponent records
    Then I should see record vs each team
    And records should be sortable
    And dominating and struggling matchups should show

  @matchup-history
  Scenario: Search matchup history
    Given extensive history exists
    When I search history
    Then I should find by opponent
    And I should find by season
    And I should find by score range

  @matchup-history
  Scenario: Export matchup history
    Given I want to export data
    When I export matchup history
    Then export should be generated
    And all data should be included
    And format should be selectable

  @matchup-history
  Scenario: View memorable matchups
    Given notable matchups have occurred
    When I view memorable matchups
    Then highest scoring should show
    And closest games should show
    And upsets should be noted

  # Matchup Scheduling Scenarios
  @matchup-scheduling
  Scenario: Generate league schedule
    Given I am a commissioner
    And league setup is complete
    When I generate the schedule
    Then schedule should be created
    And all teams should play correct games
    And schedule should be balanced

  @matchup-scheduling
  Scenario: Create balanced scheduling
    Given schedule is being generated
    When balance is applied
    Then each team plays others fairly
    And home/away balance should exist if applicable
    And no team should have unfair advantages

  @matchup-scheduling
  Scenario: Configure divisional matchups
    Given league has divisions
    When scheduling divisional play
    Then division opponents should play more often
    And cross-division play should occur
    And division settings should be respected

  @matchup-scheduling
  Scenario: Handle cross-division play
    Given league has divisions
    When cross-division games are scheduled
    Then all teams should play some cross-division
    And balance should be maintained
    And schedule should be fair

  @matchup-scheduling
  Scenario: Regenerate schedule
    Given schedule needs changes
    When commissioner regenerates schedule
    Then new schedule should be created
    And league should be notified
    And changes should be documented

  @matchup-scheduling
  Scenario: View schedule grid
    Given schedule exists
    When I view schedule grid
    Then full season should be visible
    And all matchups should be shown
    And navigation should be easy

  @matchup-scheduling
  Scenario: Handle odd number of teams
    Given league has odd team count
    When schedule is generated
    Then bye weeks should be included
    And byes should be distributed fairly
    And each team gets equal byes

  @matchup-scheduling
  Scenario: Export schedule
    Given schedule is complete
    When I export schedule
    Then export should include all weeks
    And format should be shareable
    And calendar integration should be available

  # Matchup Notifications Scenarios
  @matchup-notifications
  Scenario: Receive matchup alerts
    Given I have matchup alerts enabled
    When my matchup starts
    Then I should receive notification
    And opponent should be identified
    And link to matchup should be included

  @matchup-notifications
  Scenario: Receive opponent updates
    Given my opponent makes changes
    And I have opponent alerts enabled
    When opponent updates lineup
    Then I should be notified
    And changes should be summarized
    And I should see impact

  @matchup-notifications
  Scenario: Receive game-time notifications
    Given player games are starting
    When game time arrives
    Then I should receive notification
    And my players in game should be listed
    And opponent players should show

  @matchup-notifications
  Scenario: Receive result notifications
    Given matchup has concluded
    When final scores are calculated
    Then I should receive result notification
    And win or loss should be clear
    And final score should be shown

  @matchup-notifications
  Scenario: Configure matchup notification preferences
    Given I am in settings
    When I configure matchup notifications
    Then I should set notification types
    And I should set methods
    And preferences should save

  @matchup-notifications
  Scenario: Receive close game alerts
    Given matchup is very close
    When margin is within threshold
    Then I should receive close game alert
    And current scores should show
    And key players remaining should be identified

  @matchup-notifications
  Scenario: Receive weekly matchup reminder
    Given new week is starting
    When reminder is triggered
    Then I should receive weekly reminder
    And opponent should be shown
    And lineup lock time should be included

  @matchup-notifications
  Scenario: Receive playoff matchup notification
    Given playoffs have started
    When my playoff matchup is set
    Then I should receive special notification
    And playoff stakes should be highlighted
    And matchup details should be included

  # Matchup Stats Scenarios
  @matchup-stats
  Scenario: View points for and against
    Given season has progressed
    When I view my stats
    Then I should see total points for
    And I should see total points against
    And I should see averages

  @matchup-stats
  Scenario: View matchup margins
    Given matchups have concluded
    When I view margins
    Then I should see margin for each matchup
    And average margin should calculate
    And close games should be identified

  @matchup-stats
  Scenario: Track winning and losing streaks
    Given I have matchup history
    When I view streaks
    Then current streak should display
    And longest streaks should show
    And streak against specific opponents should show

  @matchup-stats
  Scenario: View performance trends
    Given season is progressing
    When I view trends
    Then I should see scoring trends
    And I should see win rate over time
    And I should see momentum indicators

  @matchup-stats
  Scenario: Compare stats to league average
    Given league has stats
    When I compare to league
    Then I should see percentile rankings
    And I should see above or below average
    And comparison should be insightful

  @matchup-stats
  Scenario: View best and worst performances
    Given I have matchup history
    When I view performance extremes
    Then highest scoring game should show
    And lowest scoring game should show
    And biggest win and loss should show

  @matchup-stats
  Scenario: Track schedule strength
    Given opponents vary in strength
    When I view schedule strength
    Then opponent strength should be calculated
    And strength of schedule should display
    And remaining schedule difficulty should show

  @matchup-stats
  Scenario: View luck factor analysis
    Given wins and points exist
    When I view luck analysis
    Then expected wins should calculate
    And actual vs expected should compare
    And luck rating should display

  # Consolation Matchups Scenarios
  @consolation-matchups
  Scenario: Generate consolation bracket
    Given playoffs have begun
    And some teams did not make playoffs
    When consolation bracket is created
    Then non-playoff teams should be seeded
    And consolation matchups should be set
    And bracket should be viewable

  @consolation-matchups
  Scenario: Play toilet bowl matchup
    Given toilet bowl is enabled
    When lowest teams compete
    Then toilet bowl matchup should be tracked
    And loser suffers consequences
    And matchup should be visible

  @consolation-matchups
  Scenario: Play third place game
    Given semi-final losers exist
    When third place game is played
    Then matchup should be tracked
    And third place should be determined
    And standings should reflect result

  @consolation-matchups
  Scenario: Track non-playoff matchups
    Given teams are eliminated
    When they continue playing
    Then consolation matchups should show
    And standings should update
    And engagement should continue

  @consolation-matchups
  Scenario: View consolation bracket progress
    Given consolation bracket is active
    When I view bracket
    Then progress should be visible
    And winners should advance
    And final standings should project

  @consolation-matchups
  Scenario: Configure consolation settings
    Given I am a commissioner
    When I configure consolation
    Then I should enable or disable consolation
    And I should set consolation format
    And settings should apply

  @consolation-matchups
  Scenario: Award consolation prizes
    Given consolation bracket completes
    When winners are determined
    Then consolation awards should be given
    And standings should reflect placement
    And prizes should be distributed

  @consolation-matchups
  Scenario: Maintain engagement in consolation
    Given I am in consolation
    When I view my matchup
    Then matchup should feel important
    And stats should still track
    And I should have reasons to compete

  # Matchup Settings Scenarios
  @matchup-settings
  Scenario: Configure matchup length
    Given I am a commissioner
    When I configure matchup settings
    Then I should set matchup length
    And weekly or multi-week should be options
    And settings should validate

  @matchup-settings
  Scenario: Configure playoff format
    Given I am setting up playoffs
    When I configure playoff format
    Then I should set number of teams
    And I should set playoff weeks
    And format should be saved

  @matchup-settings
  Scenario: Configure tiebreaker rules
    Given tiebreakers are needed
    When I configure tiebreakers
    Then I should set primary tiebreaker
    And I should set secondary tiebreakers
    And rules should be clear

  @matchup-settings
  Scenario: Configure division settings
    Given league uses divisions
    When I configure divisions
    Then I should create divisions
    And I should assign teams
    And division play settings should be set

  @matchup-settings
  Scenario: View current matchup settings
    Given settings are configured
    When I view settings
    Then all matchup settings should display
    And settings should be understandable
    And I should see how they affect play

  @matchup-settings
  Scenario: Change settings mid-season
    Given season is in progress
    When commissioner changes settings
    Then changes should apply appropriately
    And league should be notified
    And historical data should be preserved

  @matchup-settings
  Scenario: Reset matchup settings
    Given settings have been customized
    When I reset to defaults
    Then default settings should apply
    And confirmation should be required
    And league should be notified

  @matchup-settings
  Scenario: Copy settings from previous season
    Given previous season exists
    When I copy settings
    Then previous settings should apply
    And I should be able to modify
    And copying should be seamless

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle missing opponent data
    Given opponent data is unavailable
    When matchup loads
    Then graceful handling should occur
    And available data should display
    And error should be noted

  @error-handling
  Scenario: Handle scheduling conflicts
    Given schedule has conflicts
    When conflicts are detected
    Then conflicts should be identified
    And resolution should be suggested
    And commissioner should be notified

  @error-handling
  Scenario: Handle scoring delays in matchup
    Given scoring is delayed
    When matchup is viewed
    Then delay should be communicated
    And last known scores should show
    And estimated resolution should display

  @error-handling
  Scenario: Handle playoff seeding errors
    Given seeding calculation has issues
    When error is detected
    Then error should be logged
    And fallback seeding should apply
    And commissioner should review

  @error-handling
  Scenario: Handle tie in standings
    Given standings are tied
    When tiebreaker fails
    Then secondary tiebreakers should apply
    And if still tied, random selection may occur
    And tie resolution should be documented

  @error-handling
  Scenario: Handle bracket generation failure
    Given bracket generation fails
    When failure occurs
    Then error should be shown
    And manual bracket option should exist
    And system should retry

  @error-handling
  Scenario: Handle matchup data sync issues
    Given matchup data is out of sync
    When sync issues occur
    Then refresh should be available
    And data should reconcile
    And users should see accurate data

  @error-handling
  Scenario: Handle projection service unavailability
    Given projection service is down
    When matchup is viewed
    Then projections should show as unavailable
    And historical projections may display
    And functionality should continue

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate matchups with keyboard
    Given I am viewing matchups
    When I navigate with keyboard
    Then all matchup features should be accessible
    And focus should be visible
    And actions should be executable

  @accessibility
  Scenario: Screen reader announces matchup details
    Given I am using a screen reader
    When I view a matchup
    Then teams should be announced
    And scores should be read clearly
    And status should be communicated

  @accessibility
  Scenario: High contrast matchup display
    Given high contrast mode is enabled
    When I view matchups
    Then all elements should be visible
    And teams should be distinguishable
    And scores should be readable

  @accessibility
  Scenario: Accessible playoff bracket
    Given playoff bracket is displayed
    When I navigate bracket
    Then bracket should be accessible
    And relationships should be clear
    And advancement should be understandable

  @accessibility
  Scenario: Live updates are accessible
    Given matchup is updating live
    When updates occur
    Then updates should be announced
    And focus should not be disrupted
    And new data should be accessible

  @accessibility
  Scenario: Matchup comparison is accessible
    Given I am comparing matchups
    When I use comparison features
    Then comparisons should be navigable
    And differences should be announced
    And all data should be accessible

  @accessibility
  Scenario: Mobile matchup accessibility
    Given I am on mobile with accessibility
    When I view matchups
    Then all features should work
    And touch targets should be adequate
    And VoiceOver or TalkBack should work

  @accessibility
  Scenario: Matchup notifications are accessible
    Given I receive matchup notifications
    When notification arrives
    Then notification should be announced
    And content should be accessible
    And actions should be executable

  # Performance Scenarios
  @performance
  Scenario: Matchup page loads quickly
    Given I am viewing a matchup
    When page loads
    Then page should load within 2 seconds
    And scores should display promptly
    And player data should appear quickly

  @performance
  Scenario: Live matchup updates efficiently
    Given games are in progress
    When scores update
    Then updates should appear within seconds
    And page should not lag
    And battery should not drain excessively

  @performance
  Scenario: Bracket display performs well
    Given large playoff bracket exists
    When bracket is viewed
    Then bracket should render quickly
    And navigation should be smooth
    And no visual glitches should occur

  @performance
  Scenario: Matchup history loads efficiently
    Given extensive history exists
    When history is loaded
    Then initial results should appear quickly
    And pagination should be smooth
    And search should be fast

  @performance
  Scenario: Schedule generation is fast
    Given schedule needs generation
    When generation runs
    Then schedule should complete quickly
    And progress should be shown if long
    And result should be accurate

  @performance
  Scenario: Projections calculate quickly
    Given projections are requested
    When calculations run
    Then projections should appear quickly
    And updates should be smooth
    And no perceptible delay should exist

  @performance
  Scenario: Handle many simultaneous viewers
    Given popular matchup is occurring
    When many users view
    Then system should remain responsive
    And all users should get accurate data
    And no degradation should occur

  @performance
  Scenario: Mobile matchup performance
    Given I am on mobile
    When I view matchups
    Then performance should be acceptable
    And data usage should be efficient
    And battery impact should be minimal
