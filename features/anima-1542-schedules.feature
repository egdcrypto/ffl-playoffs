@schedules
Feature: Schedules
  As a fantasy football manager
  I want comprehensive schedule functionality
  So that I can plan for matchups and track the season timeline

  Background:
    Given I am a registered user
    And I am logged into the platform
    And I am a member of a fantasy football league

  # --------------------------------------------------------------------------
  # League Schedule Generation Scenarios
  # --------------------------------------------------------------------------
  @schedule-generation
  Scenario: Generate random league schedule
    Given I am a commissioner setting up the league
    When I generate a random schedule
    Then a complete schedule should be created
    And all teams should have equal matchups
    And the schedule should be balanced

  @schedule-generation
  Scenario: Create balanced scheduling
    Given balanced matchups are important
    When I generate a balanced schedule
    Then home and away should be distributed
    And division matchups should be balanced
    And no team should have unfair advantages

  @schedule-generation
  Scenario: Configure rivalry weeks
    Given rivalries enhance competition
    When I set up rivalry weeks
    Then I can designate specific matchups as rivalries
    And rivalry weeks should be clearly marked
    And I can schedule when rivalries occur

  @schedule-generation
  Scenario: Regenerate schedule before season
    Given I may want to try again
    When I regenerate the schedule
    Then a new schedule should be created
    And the old schedule should be replaced
    And confirmation should be required

  @schedule-generation
  Scenario: Preview generated schedule
    Given I want to review before finalizing
    When I preview the schedule
    Then I should see the full schedule
    And I can approve or regenerate
    And fairness metrics should display

  @schedule-generation
  Scenario: Lock schedule for the season
    Given the season is about to start
    When I lock the schedule
    Then the schedule should be finalized
    And changes should require special action
    And league should be notified

  @schedule-generation
  Scenario: Use custom schedule template
    Given I have specific scheduling needs
    When I apply a custom template
    Then the template should be applied
    And I can modify from the template
    And template source should be noted

  @schedule-generation
  Scenario: Handle odd number of teams
    Given leagues may have odd team counts
    When I generate schedule with odd teams
    Then bye weeks should be assigned fairly
    And each team should have equal byes
    And the schedule should still be complete

  # --------------------------------------------------------------------------
  # Schedule Types Scenarios
  # --------------------------------------------------------------------------
  @schedule-types
  Scenario: Configure round robin schedule
    Given I want everyone to play everyone
    When I select round robin scheduling
    Then each team should play each other team
    And matchups should be distributed evenly
    And the required weeks should calculate

  @schedule-types
  Scenario: Set up divisional play
    Given my league has divisions
    When I configure divisional scheduling
    Then division opponents should play more often
    And cross-division matchups should be fair
    And division schedule should be clear

  @schedule-types
  Scenario: Configure cross-division matchups
    Given cross-division balance matters
    When I set cross-division rules
    Then cross-division matchups should occur
    And frequency should be configurable
    And balance should be maintained

  @schedule-types
  Scenario: Set up double header weeks
    Given some weeks have double matchups
    When I configure double headers
    Then double header weeks should be set
    And both matchups should display
    And scoring should handle both

  @schedule-types
  Scenario: Configure partial round robin
    Given full round robin may not fit
    When I set partial round robin
    Then teams should play subset of opponents
    And matchup selection should be fair
    And the system should explain gaps

  @schedule-types
  Scenario: View schedule type comparison
    Given I want to understand options
    When I compare schedule types
    Then I should see type differences
    And pros and cons should list
    And recommendations should provide

  @schedule-types
  Scenario: Handle schedule type transitions
    Given schedule type might change
    When schedule type changes mid-setup
    Then existing settings should adapt
    And conflicts should be flagged
    And smooth transition should occur

  @schedule-types
  Scenario: Configure all-play format
    Given some leagues use all-play
    When I set up all-play format
    Then each team plays all others each week
    And record should calculate against all
    And standings should reflect format

  # --------------------------------------------------------------------------
  # Playoff Schedule Scenarios
  # --------------------------------------------------------------------------
  @playoff-schedule
  Scenario: Set up playoff bracket
    Given playoffs conclude the season
    When I configure playoffs
    Then playoff bracket should be created
    And number of teams should be configurable
    And bracket structure should be clear

  @playoff-schedule
  Scenario: Assign playoff bye weeks
    Given top seeds deserve byes
    When I configure bye assignments
    Then bye weeks should assign to top seeds
    And number of byes should be configurable
    And bye impact should be clear

  @playoff-schedule
  Scenario: Configure reseeding options
    Given reseeding affects matchups
    When I set reseeding rules
    Then reseeding should apply between rounds
    And rules should be clearly documented
    And bracket should update accordingly

  @playoff-schedule
  Scenario: Set playoff matchup lengths
    Given playoffs can span multiple weeks
    When I configure matchup lengths
    Then I can set single or multi-week matchups
    And scoring should accumulate correctly
    And calendar should reflect length

  @playoff-schedule
  Scenario: Configure consolation bracket
    Given non-playoff teams continue
    When I set up consolation
    Then consolation bracket should be created
    And eliminated teams should slot in
    And consolation schedule should generate

  @playoff-schedule
  Scenario: View playoff schedule preview
    Given playoffs should be understood
    When I preview playoff schedule
    Then I should see potential brackets
    And timing should be clear
    And scenarios should be modeled

  @playoff-schedule
  Scenario: Handle playoff schedule conflicts
    Given NFL playoffs may conflict
    When conflicts are detected
    Then I should be notified
    And resolution options should present
    And schedule should accommodate

  @playoff-schedule
  Scenario: Configure championship week
    Given the championship is special
    When I configure championship week
    Then championship settings should apply
    And the week should be highlighted
    And special rules can apply

  # --------------------------------------------------------------------------
  # Regular Season Schedule Scenarios
  # --------------------------------------------------------------------------
  @regular-season
  Scenario: Configure week numbering
    Given weeks need clear labeling
    When I set week numbering
    Then weeks should be numbered sequentially
    And numbering should match NFL weeks optionally
    And week labels should be clear

  @regular-season
  Scenario: Set season start and end dates
    Given seasons have specific timeframes
    When I configure season dates
    Then start date should be set
    And end date should be set
    And duration should calculate

  @regular-season
  Scenario: Configure season length
    Given season length varies
    When I set season length
    Then number of regular season weeks should set
    And schedule should fit within length
    And playoffs should fit after

  @regular-season
  Scenario: View regular season timeline
    Given I want to see the full picture
    When I view season timeline
    Then I should see all weeks laid out
    And key dates should be marked
    And current position should indicate

  @regular-season
  Scenario: Handle mid-season bye weeks
    Given some leagues have mid-season byes
    When I configure league bye weeks
    Then bye weeks should be set
    And they should be league-wide
    And no matchups should occur those weeks

  @regular-season
  Scenario: Configure trade deadline in schedule
    Given trade deadline is schedule-related
    When I set trade deadline
    Then deadline should appear on schedule
    And deadline should be enforced
    And league should be notified approaching deadline

  @regular-season
  Scenario: View remaining schedule
    Given I want to see what's left
    When I view remaining schedule
    Then I should see future weeks only
    And countdown should display
    And key matchups should highlight

  @regular-season
  Scenario: Configure schedule for shortened season
    Given seasons may be shortened
    When I set up shortened season
    Then schedule should fit reduced timeframe
    And playoffs should still fit
    And balance should be maintained

  # --------------------------------------------------------------------------
  # Schedule Viewing Scenarios
  # --------------------------------------------------------------------------
  @schedule-viewing
  Scenario: View schedule in calendar format
    Given calendars are intuitive
    When I view calendar view
    Then I should see month/week calendar
    And matchups should appear on dates
    And I can navigate through months

  @schedule-viewing
  Scenario: View schedule in list format
    Given lists show details
    When I view list format
    Then I should see matchups listed
    And dates and times should display
    And I can filter and sort

  @schedule-viewing
  Scenario: View opponent's schedule
    Given knowing opponent schedule helps
    When I view an opponent's schedule
    Then I should see their matchups
    And their difficulty should assess
    And comparison to mine should show

  @schedule-viewing
  Scenario: View my team's schedule
    Given I care about my matchups
    When I view my schedule
    Then I should see all my matchups
    And opponents should be clearly listed
    And key matchups should highlight

  @schedule-viewing
  Scenario: View league-wide schedule
    Given I want to see all matchups
    When I view full league schedule
    Then I should see all matchups
    And I can filter by week or team
    And the view should be comprehensive

  @schedule-viewing
  Scenario: View schedule by week
    Given weekly view is common
    When I view a specific week
    Then I should see all matchups for that week
    And dates and times should display
    And I can navigate between weeks

  @schedule-viewing
  Scenario: View head-to-head schedule history
    Given past matchups matter
    When I view history with an opponent
    Then I should see past matchups
    And results should display
    And trends should be visible

  @schedule-viewing
  Scenario: Print schedule
    Given I may want physical copy
    When I print the schedule
    Then print layout should be optimized
    And all relevant info should include
    And formatting should be clean

  # --------------------------------------------------------------------------
  # Schedule Modifications Scenarios
  # --------------------------------------------------------------------------
  @schedule-modifications
  Scenario: Commissioner edits schedule
    Given commissioners have control
    When I edit the schedule as commissioner
    Then I should be able to change matchups
    And changes should save
    And league should be notified

  @schedule-modifications
  Scenario: Swap matchup opponents
    Given matchup swaps may be needed
    When I swap opponents between matchups
    Then the swap should process
    And both matchups should update
    And integrity should maintain

  @schedule-modifications
  Scenario: Schedule makeup games
    Given postponements may occur
    When I schedule a makeup game
    Then the makeup should be added
    And timing should be set
    And both teams should be notified

  @schedule-modifications
  Scenario: Cancel a scheduled matchup
    Given matchups may need cancellation
    When I cancel a matchup
    Then the matchup should be removed
    And standings impact should handle
    And confirmation should be required

  @schedule-modifications
  Scenario: Add extra matchup week
    Given additional weeks may be needed
    When I add a week to schedule
    Then new week should be added
    And matchups can be assigned
    And season timeline should adjust

  @schedule-modifications
  Scenario: Remove a scheduled week
    Given weeks may need removal
    When I remove a week
    Then the week should be removed
    And affected matchups should handle
    And subsequent weeks should adjust

  @schedule-modifications
  Scenario: View schedule modification history
    Given changes should be tracked
    When I view modification history
    Then I should see all changes
    And who made changes should show
    And timestamps should display

  @schedule-modifications
  Scenario: Undo schedule modification
    Given mistakes happen
    When I undo a change
    Then the change should revert
    And previous state should restore
    And undo should be available temporarily

  # --------------------------------------------------------------------------
  # NFL Schedule Integration Scenarios
  # --------------------------------------------------------------------------
  @nfl-integration
  Scenario: View real NFL game times
    Given NFL games have specific times
    When I view schedule with game times
    Then I should see actual game times
    And timezone should be correct
    And updates should be current

  @nfl-integration
  Scenario: Track Thursday Night Football
    Given TNF starts the week
    When TNF games are scheduled
    Then TNF should be clearly marked
    And lineup deadlines should adjust
    And affected players should highlight

  @nfl-integration
  Scenario: Track Sunday games schedule
    Given Sunday is main game day
    When I view Sunday schedule
    Then I should see all Sunday games
    And early and late windows should separate
    And times should be accurate

  @nfl-integration
  Scenario: Track Monday Night Football
    Given MNF ends the week
    When MNF is scheduled
    Then MNF should be clearly marked
    And fantasy implications should note
    And timing should be accurate

  @nfl-integration
  Scenario: Sync NFL bye weeks
    Given NFL byes affect fantasy
    When I view bye week schedule
    Then I should see which NFL teams are on bye
    And my affected players should highlight
    And bye weeks should sync with NFL

  @nfl-integration
  Scenario: Handle NFL schedule changes
    Given NFL may flex games
    When NFL schedule changes occur
    Then fantasy schedule should update
    And notifications should send
    And changes should be clear

  @nfl-integration
  Scenario: View international game times
    Given some games are overseas
    When international games occur
    Then times should reflect correct timezone
    And early start should be noted
    And affected players should highlight

  @nfl-integration
  Scenario: Track NFL playoff schedule
    Given NFL playoffs affect fantasy
    When NFL playoffs are scheduled
    Then playoff schedule should display
    And fantasy playoff implications should show
    And timing should be clear

  # --------------------------------------------------------------------------
  # Schedule Alerts Scenarios
  # --------------------------------------------------------------------------
  @schedule-alerts
  Scenario: Receive upcoming matchup reminders
    Given I want to prepare for matchups
    When my matchup is approaching
    Then I should receive reminders
    And reminder timing should be configurable
    And matchup details should include

  @schedule-alerts
  Scenario: Receive lineup deadline alerts
    Given deadlines are critical
    When lineup deadline approaches
    Then I should receive alerts
    And time remaining should show
    And I can set reminder preferences

  @schedule-alerts
  Scenario: Receive game start notifications
    Given game starts matter
    When games are about to start
    Then I should receive notifications
    And affected players should list
    And I can configure notification timing

  @schedule-alerts
  Scenario: Configure alert preferences
    Given I want control over alerts
    When I configure preferences
    Then I can choose alert types
    And I can set timing
    And I can choose delivery method

  @schedule-alerts
  Scenario: Receive schedule change alerts
    Given changes affect planning
    When schedule changes occur
    Then I should be notified
    And the change should explain
    And impact should be clear

  @schedule-alerts
  Scenario: Receive bye week alerts
    Given byes require roster adjustments
    When bye week approaches
    Then I should receive alerts
    And affected players should list
    And alternatives should suggest

  @schedule-alerts
  Scenario: Receive playoff qualification alerts
    Given playoff clinching is exciting
    When I clinch or am eliminated
    Then I should receive notification
    And the scenario should explain
    And next steps should suggest

  @schedule-alerts
  Scenario: Mute alerts for specific periods
    Given I may want quiet time
    When I mute alerts
    Then alerts should suppress
    And mute duration should be configurable
    And I can unmute anytime

  # --------------------------------------------------------------------------
  # Schedule Exports Scenarios
  # --------------------------------------------------------------------------
  @schedule-exports
  Scenario: Download schedule as file
    Given I want offline access
    When I download the schedule
    Then I should receive a downloadable file
    And format should be selectable
    And data should be complete

  @schedule-exports
  Scenario: Sync schedule with calendar app
    Given calendar integration is convenient
    When I sync with my calendar
    Then matchups should appear in my calendar
    And sync should update automatically
    And I can choose which events sync

  @schedule-exports
  Scenario: Export to iCal format
    Given iCal is widely supported
    When I export to iCal
    Then I should receive .ics file
    And events should be properly formatted
    And reminders should include

  @schedule-exports
  Scenario: Subscribe to calendar feed
    Given subscription keeps calendar current
    When I subscribe to schedule feed
    Then my calendar should stay updated
    And new events should sync
    And changes should reflect

  @schedule-exports
  Scenario: Export schedule as spreadsheet
    Given spreadsheets are useful
    When I export to spreadsheet
    Then I should receive CSV or Excel file
    And all data should include
    And format should be usable

  @schedule-exports
  Scenario: Share schedule with league
    Given sharing is helpful
    When I share the schedule
    Then league members should have access
    And sharing method should be configurable
    And permissions should be appropriate

  @schedule-exports
  Scenario: Print schedule in various formats
    Given different print needs exist
    When I print the schedule
    Then I can choose print format
    And layout should be optimized
    And print quality should be good

  @schedule-exports
  Scenario: Export schedule to other platforms
    Given cross-platform use is common
    When I export for other platforms
    Then format should be compatible
    And data should transfer correctly
    And instructions should provide

  # --------------------------------------------------------------------------
  # Schedule Analysis Scenarios
  # --------------------------------------------------------------------------
  @schedule-analysis
  Scenario: View strength of schedule
    Given schedule difficulty varies
    When I view strength of schedule
    Then I should see SOS rating
    And ranking among league should show
    And methodology should explain

  @schedule-analysis
  Scenario: Analyze remaining schedule difficulty
    Given future schedule matters
    When I analyze remaining schedule
    Then I should see remaining SOS
    And comparison to others should show
    And implications should note

  @schedule-analysis
  Scenario: View schedule fairness metrics
    Given fairness is important
    When I view fairness analysis
    Then I should see fairness metrics
    And any imbalances should flag
    And comparison to ideal should show

  @schedule-analysis
  Scenario: Compare schedule to other teams
    Given relative schedule matters
    When I compare my schedule to others
    Then I should see comparison
    And advantages and disadvantages should highlight
    And key differences should note

  @schedule-analysis
  Scenario: Analyze historical schedule luck
    Given past results show luck
    When I analyze schedule luck
    Then I should see how schedule affected results
    And expected vs actual record should compare
    And luck factor should calculate

  @schedule-analysis
  Scenario: View schedule heat map
    Given visualization helps understanding
    When I view schedule heat map
    Then I should see difficulty visualized
    And color coding should be clear
    And I can identify tough stretches

  @schedule-analysis
  Scenario: Project playoff implications
    Given schedule affects playoff chances
    When I view playoff projections
    Then schedule impact should factor
    And simulation should consider matchups
    And probability should display

  @schedule-analysis
  Scenario: Generate schedule analysis report
    Given comprehensive analysis is valuable
    When I generate a report
    Then I should receive detailed analysis
    And all metrics should include
    And I can export the report

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle schedule data unavailable
    Given schedule service may have issues
    When schedule data is unavailable
    Then I should see an appropriate error
    And cached schedule should display
    And I should know when to retry

  @error-handling
  Scenario: Handle schedule generation failures
    Given generation may fail
    When schedule generation fails
    Then I should see error message
    And retry should be available
    And alternative options should suggest

  @error-handling
  Scenario: Handle calendar sync failures
    Given sync may fail
    When calendar sync fails
    Then I should be notified
    And manual sync should be possible
    And error details should show

  @error-handling
  Scenario: Handle NFL data fetch failures
    Given NFL data comes externally
    When NFL data fails to load
    Then I should see indication
    And cached data should use
    And retry should be automatic

  @error-handling
  Scenario: Handle schedule modification conflicts
    Given concurrent edits may occur
    When modification conflicts happen
    Then I should be notified
    And resolution options should present
    And no data should be lost

  @error-handling
  Scenario: Handle export generation failures
    Given exports may fail
    When export fails
    Then I should see failure reason
    And retry should be available
    And alternative formats should suggest

  @error-handling
  Scenario: Handle invalid schedule configurations
    Given invalid settings may be entered
    When invalid configuration is submitted
    Then validation error should display
    And valid options should show
    And correction should be possible

  @error-handling
  Scenario: Handle timezone conversion errors
    Given timezones are complex
    When timezone issues occur
    Then reasonable defaults should apply
    And times should be reasonable
    And manual correction should be possible

  @error-handling
  Scenario: Handle schedule constraint violations
    Given constraints must be met
    When constraints are violated
    Then I should see violation details
    And resolution should be suggested
    And generation should not proceed

  @error-handling
  Scenario: Handle notification delivery failures
    Given notifications may fail
    When notification fails
    Then failure should be logged
    And retry should occur
    And I can view missed alerts

  @error-handling
  Scenario: Handle concurrent schedule access
    Given multiple users may access
    When concurrent access occurs
    Then data should remain consistent
    And changes should not conflict
    And users should be informed

  @error-handling
  Scenario: Handle iCal parsing errors
    Given iCal format is specific
    When parsing errors occur
    Then I should see error details
    And alternative export should offer
    And format issues should explain

  @error-handling
  Scenario: Handle schedule rollback failures
    Given rollback may fail
    When undo fails
    Then I should see error message
    And current state should preserve
    And manual correction should be possible

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate schedule with keyboard only
    Given I rely on keyboard navigation
    When I use schedule without a mouse
    Then I should access all features
    And focus indicators should be clear
    And shortcuts should be available

  @accessibility
  Scenario: Use schedule with screen reader
    Given I use a screen reader
    When I access schedule information
    Then all content should be announced
    And dates should be clear
    And matchups should be understandable

  @accessibility
  Scenario: View schedule in high contrast mode
    Given I need high contrast visuals
    When I enable high contrast mode
    Then all elements should be visible
    And dates should be readable
    And matchups should be distinguishable

  @accessibility
  Scenario: Access schedule on mobile devices
    Given I access schedule on a phone
    When I use schedule on mobile
    Then the interface should be responsive
    And touch targets should be adequate
    And all features should work

  @accessibility
  Scenario: Customize schedule display font size
    Given I need larger text
    When I increase font size
    Then all schedule text should scale
    And calendar should remain usable
    And layout should adapt

  @accessibility
  Scenario: Use schedule calendar accessibly
    Given calendars must be accessible
    When I navigate the calendar
    Then calendar should be keyboard navigable
    And dates should be announced
    And current date should be indicated

  @accessibility
  Scenario: Access schedule with reduced motion
    Given I am sensitive to motion
    When I have reduced motion enabled
    Then animations should minimize
    And transitions should be simple
    And functionality should preserve

  @accessibility
  Scenario: Print schedule with accessible formatting
    Given printed schedules must be usable
    When I print schedule
    Then print layout should be accessible
    And contrast should be sufficient
    And all info should be included

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load schedule page quickly
    Given I open schedule
    When the page loads
    Then it should load within 1 second
    And schedule should display immediately
    And additional data should load progressively

  @performance
  Scenario: Navigate between weeks quickly
    Given I browse the schedule
    When I switch weeks
    Then navigation should be instant
    And data should cache appropriately
    And transitions should be smooth

  @performance
  Scenario: Generate schedule efficiently
    Given generation involves calculations
    When I generate a schedule
    Then it should complete within 3 seconds
    And progress should indicate if longer
    And results should be complete

  @performance
  Scenario: Sync calendar efficiently
    Given sync should be fast
    When calendar sync occurs
    Then it should complete promptly
    And no UI blocking should occur
    And bandwidth should be optimized

  @performance
  Scenario: Load NFL schedule data quickly
    Given NFL data is fetched
    When NFL data loads
    Then it should appear within 2 seconds
    And cached data should serve when possible
    And updates should be incremental

  @performance
  Scenario: Export schedule quickly
    Given exports should be responsive
    When I export schedule
    Then export should complete promptly
    And progress should indicate
    And browser should remain responsive

  @performance
  Scenario: Handle large league schedules
    Given large leagues have more data
    When viewing large league schedule
    Then performance should remain acceptable
    And pagination should be used if needed
    And memory should be managed

  @performance
  Scenario: Cache schedule appropriately
    Given I may revisit schedule
    When I access cached schedule
    Then cached data should load instantly
    And cache freshness should indicate
    And updates should sync when available
