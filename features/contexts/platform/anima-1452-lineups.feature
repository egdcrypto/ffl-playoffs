@lineups @platform
Feature: Lineups
  As a fantasy football league
  I need comprehensive lineup management functionality
  So that owners can set optimal starting lineups each week

  Background:
    Given the lineup system is operational
    And lineup rules are configured for the league

  # ==================== Lineup Setting ====================

  @setting @starting-lineup
  Scenario: Set starting lineup
    Given an owner has a roster
    When setting the starting lineup
    Then players can be assigned to starting slots
    And the lineup should be validated
    And the lineup should be saved

  @setting @starting-lineup
  Scenario: Select starter from bench
    Given a player is on the bench
    When moving to starting lineup
    Then the player should move to appropriate slot
    And eligibility should be verified
    And the change should be confirmed

  @setting @bench-decisions
  Scenario: Move player to bench
    Given a player is in the starting lineup
    When benching the player
    Then the player should move to bench
    And the starting slot should be vacated
    And a replacement should be suggested

  @setting @bench-decisions
  Scenario: Swap starter with bench player
    Given both starter and bench player exist
    When swapping players
    Then the players should exchange positions
    And eligibility should be validated
    And the swap should complete

  @setting @flex-assignments
  Scenario: Assign player to flex slot
    Given a flex-eligible player exists
    When assigning to flex
    Then eligibility should be verified
    And the player should occupy the flex slot
    And alternatives should remain available

  @setting @flex-assignments
  Scenario: Display flex slot options
    Given a flex slot is empty
    When viewing options
    Then all eligible players should be shown
    And projections should be displayed
    And recommendations should be made

  @setting @position-assignments
  Scenario: Assign player to position slot
    Given a player has position eligibility
    When assigning to a slot
    Then the position should be validated
    And the assignment should complete
    And conflicts should be prevented

  @setting @position-assignments
  Scenario: Handle multi-position eligibility
    Given a player has multiple position eligibility
    When choosing a slot
    Then all eligible slots should be shown
    And the best slot should be suggested
    And the owner should make the final choice

  # ==================== Lineup Optimization ====================

  @optimization @auto-optimize
  Scenario: Auto-optimize lineup
    Given lineup optimization is requested
    When running optimization
    Then the highest-projected lineup should be calculated
    And players should be optimally placed
    And the result should be presented

  @optimization @auto-optimize
  Scenario: Apply optimized lineup
    Given optimization is complete
    When applying the lineup
    Then the lineup should update
    And changes should be summarized
    And confirmation should be provided

  @optimization @projected-comparison
  Scenario: Compare projected points
    Given multiple lineup configurations exist
    When comparing projections
    Then side-by-side comparisons should show
    And point differentials should be calculated
    And the best option should be highlighted

  @optimization @projected-comparison
  Scenario: View projection sources
    Given projections are displayed
    When viewing sources
    Then multiple sources should be available
    And consensus projections should show
    And variance should be indicated

  @optimization @matchup-suggestions
  Scenario: Receive matchup-based suggestions
    Given matchup data is available
    When viewing suggestions
    Then favorable matchups should be highlighted
    And unfavorable matchups should be flagged
    And start/sit advice should be provided

  @optimization @matchup-suggestions
  Scenario: Analyze defensive matchups
    Given opponent defense data exists
    When analyzing matchups
    Then position-by-position breakdown should show
    And exploitable weaknesses should be highlighted
    And strategic recommendations should be made

  @optimization @start-sit-advice
  Scenario: Access start/sit advice
    Given expert advice is available
    When viewing start/sit advice
    Then recommendations should be displayed
    And reasoning should be provided
    And confidence levels should be shown

  @optimization @start-sit-advice
  Scenario: Compare expert recommendations
    Given multiple experts exist
    When comparing advice
    Then expert-by-expert comparison should show
    And consensus should be calculated
    And track records should be accessible

  # ==================== Lineup Locks ====================

  @locks @game-time-locks
  Scenario: Apply game-time locks
    Given games are about to start
    When game time arrives
    Then affected players should lock
    And lineup changes should be blocked
    And lock status should display

  @locks @game-time-locks
  Scenario: Display game-time countdown
    Given a game is approaching
    When viewing lock countdown
    Then time until lock should display
    And countdown should update in real-time
    And warnings should appear near lock time

  @locks @individual-locks
  Scenario: Lock individual player
    Given a player's game has started
    When the game begins
    Then that player should lock
    And other players should remain editable
    And lock status should be clear

  @locks @individual-locks
  Scenario: Display locked vs unlocked players
    Given some games have started
    When viewing lineup
    Then locked players should be indicated
    And unlocked players should be editable
    And visual distinction should be clear

  @locks @weekly-deadlines
  Scenario: Apply weekly lock deadline
    Given weekly locks are configured
    When the deadline arrives
    Then the entire lineup should lock
    And no changes should be allowed
    And unlock time should be shown

  @locks @weekly-deadlines
  Scenario: Configure weekly lock timing
    Given lock settings are available
    When configuring deadlines
    Then options should include
      | lock_option       | timing                  |
      | first_game        | first game of week      |
      | thursday_night    | Thursday kickoff        |
      | sunday_morning    | Sunday 1PM kickoff      |
      | custom            | specific date/time      |

  @locks @lock-status-display
  Scenario: Display comprehensive lock status
    Given lineup has various lock states
    When viewing lock status
    Then each player's lock status should show
    And times should be displayed
    And actionable items should be clear

  @locks @lock-status-display
  Scenario: Filter by lock status
    Given lock filtering is available
    When filtering by status
    Then options should include locked and unlocked
    And results should update
    And counts should display

  # ==================== Start/Sit Decisions ====================

  @start-sit @comparison-tools
  Scenario: Compare players for start/sit
    Given two players are being compared
    When running comparison
    Then stats should be side-by-side
    And projections should be compared
    And matchups should be analyzed

  @start-sit @comparison-tools
  Scenario: Use advanced comparison metrics
    Given advanced metrics are available
    When using advanced comparison
    Then the following should be included
      | metric              | description             |
      | target_share        | percentage of targets   |
      | red_zone_usage      | goal-line opportunities |
      | snap_percentage     | playing time            |
      | route_participation | route running rate      |

  @start-sit @expert-rankings
  Scenario: View expert rankings
    Given expert rankings exist
    When viewing rankings
    Then position-specific rankings should show
    And expert sources should be identified
    And consensus rankings should be available

  @start-sit @expert-rankings
  Scenario: Track ranking changes
    Given rankings change over time
    When viewing rank changes
    Then movement should be indicated
    And reasons should be noted
    And trends should be visible

  @start-sit @matchup-analysis
  Scenario: Analyze player matchup
    Given matchup data exists
    When analyzing a player's matchup
    Then opponent strength should display
    And historical performance should show
    And favorable/unfavorable rating should be given

  @start-sit @matchup-analysis
  Scenario: Compare matchups across positions
    Given multiple players need decisions
    When comparing matchups
    Then all matchups should be comparable
    And relative advantage should show
    And prioritization should be suggested

  @start-sit @weather-considerations
  Scenario: Consider weather in decisions
    Given weather data is available
    When viewing start/sit advice
    Then weather conditions should be shown
    And impact on performance should be noted
    And adjustments should be suggested

  @start-sit @weather-considerations
  Scenario: Display weather alerts
    Given severe weather is expected
    When viewing affected games
    Then weather alerts should display
    And impacted players should be flagged
    And contingency advice should be provided

  # ==================== Lineup Alerts ====================

  @alerts @inactive-warnings
  Scenario: Warn of inactive starters
    Given a starter is inactive
    When viewing lineup
    Then an inactive warning should display
    And the player should be flagged
    And replacement suggestions should be made

  @alerts @inactive-warnings
  Scenario: Configure inactive alert settings
    Given alert settings are available
    When configuring alerts
    Then notification timing should be settable
    And channels should be selectable
    And frequency should be configurable

  @alerts @game-time-decisions
  Scenario: Alert on game-time decisions
    Given a player is a GTD
    When the decision is pending
    Then a GTD alert should display
    And status should be monitored
    And updates should be pushed

  @alerts @game-time-decisions
  Scenario: Track GTD status updates
    Given GTD players are being monitored
    When status changes
    Then owner should be notified immediately
    And lineup impact should be assessed
    And action recommendations should be made

  @alerts @injury-updates
  Scenario: Send injury update alerts
    Given an injury occurs
    When the update is available
    Then the owner should be notified
    And impact should be explained
    And alternatives should be suggested

  @alerts @injury-updates
  Scenario: Display injury severity
    Given injury information exists
    When viewing injury details
    Then severity should be indicated
    And expected return should show
    And lineup implications should be noted

  @alerts @bye-week-reminders
  Scenario: Remind of bye week players
    Given starters have bye weeks
    When bye week approaches
    Then reminders should be sent
    And affected players should be listed
    And replacement suggestions should be made

  @alerts @bye-week-reminders
  Scenario: Display bye week schedule
    Given bye data is available
    When viewing schedule
    Then upcoming byes should show
    And affected weeks should be highlighted
    And planning tools should be accessible

  # ==================== Weekly Lineup Management ====================

  @weekly @week-by-week-view
  Scenario: View lineup by week
    Given multiple weeks exist
    When selecting a week
    Then that week's lineup should display
    And navigation should be intuitive
    And week status should be clear

  @weekly @week-by-week-view
  Scenario: Navigate between weeks
    Given multi-week navigation exists
    When navigating weeks
    Then previous and next should be accessible
    And current week should be highlighted
    And future weeks should be editable

  @weekly @copy-previous
  Scenario: Copy previous week's lineup
    Given a previous lineup exists
    When copying lineup
    Then the lineup should be duplicated
    And conflicts should be identified
    And adjustments should be allowed

  @weekly @copy-previous
  Scenario: Handle copy conflicts
    Given copied lineup has issues
    When conflicts are detected
    Then specific conflicts should be listed
    And resolution should be guided
    And one-click fixes should be offered

  @weekly @bulk-actions
  Scenario: Apply bulk lineup actions
    Given multiple changes are needed
    When using bulk actions
    Then multiple changes should process together
    And validation should occur
    And confirmation should be required

  @weekly @bulk-actions
  Scenario: Revert bulk changes
    Given bulk changes were made
    When reverting changes
    Then changes should be undone
    And previous state should restore
    And confirmation should be provided

  @weekly @schedule-display
  Scenario: Display game schedule
    Given games are scheduled
    When viewing the schedule
    Then all games should be shown
    And kickoff times should display
    And relevant players should be noted

  @weekly @schedule-display
  Scenario: Filter schedule by team/player
    Given schedule filtering exists
    When filtering schedule
    Then results should narrow appropriately
    And relevant games should highlight
    And player context should be shown

  # ==================== Lineup Projections ====================

  @projections @projected-points
  Scenario: Display projected points
    Given projections are available
    When viewing lineup
    Then projected points should display per player
    And total lineup projection should show
    And source should be identified

  @projections @projected-points
  Scenario: Compare projection sources
    Given multiple projection sources exist
    When comparing sources
    Then source-by-source values should show
    And consensus should be calculated
    And variance should be highlighted

  @projections @ceiling-floor
  Scenario: Display ceiling and floor projections
    Given range projections exist
    When viewing player projections
    Then ceiling should be shown
    And floor should be shown
    And expected range should be clear

  @projections @ceiling-floor
  Scenario: Use ceiling/floor for decisions
    Given ceiling/floor data is available
    When making start/sit decisions
    Then range should be factored
    And risk levels should be indicated
    And strategic advice should reflect range

  @projections @boom-bust
  Scenario: Indicate boom/bust potential
    Given boom/bust analysis exists
    When viewing players
    Then boom potential should be indicated
    And bust risk should be shown
    And volatility should be rated

  @projections @boom-bust
  Scenario: Filter by boom/bust profile
    Given boom/bust filtering exists
    When filtering players
    Then options should include
      | profile         | description             |
      | safe_floor      | consistent performers   |
      | high_ceiling    | upside plays            |
      | boom_or_bust    | volatile players        |
      | balanced        | moderate range          |

  @projections @confidence-ratings
  Scenario: Display projection confidence
    Given confidence ratings exist
    When viewing projections
    Then confidence level should display
    And factors should be explained
    And reliability should be indicated

  @projections @confidence-ratings
  Scenario: Sort by confidence level
    Given confidence data is available
    When sorting by confidence
    Then high-confidence projections should show first
    And confidence thresholds should be clear
    And decision confidence should improve

  # ==================== Flex Position Management ====================

  @flex @eligibility
  Scenario: Display flex eligibility
    Given flex rules are configured
    When viewing flex options
    Then eligible positions should be shown
    And eligible players should be listed
    And ineligible players should be excluded

  @flex @eligibility
  Scenario: Configure flex eligibility rules
    Given flex settings are available
    When configuring eligibility
    Then options should include
      | flex_type       | eligible_positions      |
      | standard        | RB, WR, TE              |
      | superflex       | QB, RB, WR, TE          |
      | rec_flex        | WR, TE                  |
      | idp_flex        | DL, LB, DB              |

  @flex @optimal-selection
  Scenario: Suggest optimal flex selection
    Given flex optimization is available
    When requesting suggestion
    Then the highest-projected eligible player should be suggested
    And alternatives should be shown
    And reasoning should be provided

  @flex @optimal-selection
  Scenario: Compare flex options
    Given multiple flex-eligible players exist
    When comparing options
    Then side-by-side comparison should show
    And projections should be displayed
    And matchup factors should be included

  @flex @scarcity-analysis
  Scenario: Analyze position scarcity for flex
    Given position scarcity data exists
    When analyzing flex decision
    Then scarcity should factor into advice
    And replacement value should be shown
    And strategic implications should be noted

  @flex @scarcity-analysis
  Scenario: Display scarcity impact
    Given scarcity analysis is complete
    When viewing impact
    Then position depth should be shown
    And flex value should be calculated
    And optimal strategy should be suggested

  @flex @recommendations
  Scenario: Receive flex recommendations
    Given recommendation engine is active
    When requesting recommendations
    Then data-driven suggestions should appear
    And reasoning should be transparent
    And confidence should be indicated

  @flex @recommendations
  Scenario: Customize recommendation factors
    Given recommendation settings exist
    When customizing factors
    Then weighting should be adjustable
    And factors should be selectable
    And preferences should save

  # ==================== Lineup History ====================

  @history @historical-lineups
  Scenario: View historical lineups
    Given past lineups are archived
    When viewing historical lineups
    Then lineups from any week should be viewable
    And the state at that time should be accurate
    And navigation should be intuitive

  @history @historical-lineups
  Scenario: Compare lineups across weeks
    Given multi-week history exists
    When comparing lineups
    Then week-by-week comparison should show
    And changes should be highlighted
    And patterns should be visible

  @history @points-tracking
  Scenario: Track points scored by lineup
    Given points are recorded
    When viewing points history
    Then points per player per week should show
    And totals should be calculated
    And performance should be charted

  @history @points-tracking
  Scenario: Analyze scoring trends
    Given scoring history exists
    When analyzing trends
    Then patterns should be identified
    And high/low weeks should be highlighted
    And insights should be generated

  @history @optimal-comparison
  Scenario: Compare to optimal lineup
    Given optimal lineups can be calculated
    When comparing actual to optimal
    Then point differential should show
    And missed opportunities should be identified
    And improvement areas should be highlighted

  @history @optimal-comparison
  Scenario: Calculate season-long optimal points
    Given full season data exists
    When calculating optimal
    Then maximum possible points should be shown
    And actual vs optimal should be compared
    And efficiency rating should be calculated

  @history @regrets-analysis
  Scenario: Analyze lineup regrets
    Given suboptimal decisions were made
    When analyzing regrets
    Then impactful wrong decisions should be listed
    And point cost should be calculated
    And learning opportunities should be noted

  @history @regrets-analysis
  Scenario: Track decision success rate
    Given decision history exists
    When tracking success
    Then start/sit decision accuracy should show
    And patterns should be identified
    And improvement areas should be suggested

  # ==================== Multi-Week Lineup Planning ====================

  @planning @future-weeks
  Scenario: Plan future week lineups
    Given future weeks are accessible
    When planning ahead
    Then tentative lineups should be settable
    And projections should be available
    And adjustments should be allowed

  @planning @future-weeks
  Scenario: Set preliminary lineups
    Given future planning is enabled
    When setting preliminary lineup
    Then the lineup should be saved as tentative
    And reminders should be scheduled
    And updates should be allowed

  @planning @bye-week-preparation
  Scenario: Prepare for bye weeks
    Given bye week data is known
    When planning for byes
    Then affected weeks should be identified
    And replacement options should be shown
    And contingency plans should be suggested

  @planning @bye-week-preparation
  Scenario: Create bye week contingencies
    Given bye planning is active
    When creating contingencies
    Then backup players should be identified
    And acquisition targets should be suggested
    And timeline should be established

  @planning @schedule-decisions
  Scenario: Make schedule-based decisions
    Given schedule data is available
    When planning multi-week
    Then matchup quality should be considered
    And streaming options should be identified
    And optimal timing should be suggested

  @planning @schedule-decisions
  Scenario: Identify favorable matchup weeks
    Given schedule analysis is complete
    When viewing matchup calendar
    Then favorable weeks should be highlighted
    And unfavorable weeks should be flagged
    And planning advice should be provided

  @planning @playoff-planning
  Scenario: Plan for playoff lineups
    Given playoff probability exists
    When planning for playoffs
    Then playoff schedule should be considered
    And matchup advantages should be identified
    And roster optimization should be suggested

  @planning @playoff-planning
  Scenario: Optimize roster for playoffs
    Given playoff planning is active
    When optimizing roster
    Then playoff schedule should factor in
    And handcuff strategies should be suggested
    And depth considerations should be noted

  # ==================== Lineup Interface ====================

  @interface @lineup-view
  Scenario: Display comprehensive lineup view
    Given a lineup exists
    When viewing lineup
    Then all positions should be visible
    And player details should be accessible
    And actions should be intuitive

  @interface @lineup-view
  Scenario: Customize lineup display
    Given customization options exist
    When customizing display
    Then layout should be adjustable
    And information density should be selectable
    And preferences should save

  @interface @mobile-lineup
  Scenario: Set lineup on mobile
    Given mobile access is available
    When setting lineup on mobile
    Then interface should be responsive
    And all features should work
    And touch interactions should be smooth

  @interface @mobile-lineup
  Scenario: Receive mobile lineup reminders
    Given mobile notifications are enabled
    When lineup needs attention
    Then push notifications should arrive
    And quick actions should be available
    And deep linking should work

  @interface @drag-drop
  Scenario: Use drag-and-drop for lineup
    Given drag-and-drop is enabled
    When dragging a player
    Then valid slots should highlight
    And the move should be intuitive
    And dropping should complete the action

  @interface @drag-drop
  Scenario: Handle invalid drag-drop moves
    Given an invalid move is attempted
    When dropping on invalid slot
    Then the move should be prevented
    And feedback should explain why
    And valid alternatives should be shown
