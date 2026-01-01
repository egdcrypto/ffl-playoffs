@rookie-drafts @dynasty @drafting
Feature: Rookie Drafts
  As a dynasty fantasy football league manager
  I want to conduct rookie-only drafts
  So that I can add incoming NFL talent to my roster each year

  Background:
    Given the fantasy football platform is available
    And the user is authenticated
    And a dynasty league with rookie drafts exists

  # --------------------------------------------------------------------------
  # Rookie-Only Player Pool
  # --------------------------------------------------------------------------
  @rookie-player-pool @player-eligibility
  Scenario: Display rookie-only player pool for draft
    Given a rookie draft is scheduled for the league
    And the current NFL rookie class has been imported
    When the user views the rookie draft player pool
    Then only players from the current NFL rookie class should be displayed
    And veteran players should not be available for selection
    And the pool should include all draft-eligible rookies

  @rookie-player-pool @filtering
  Scenario: Filter rookie pool by position
    Given the rookie draft player pool is displayed
    When the user filters by position "QB"
    Then only rookie quarterbacks should be shown
    And the filter should display the count of matching players

  @rookie-player-pool @filtering
  Scenario: Filter rookie pool by NFL team
    Given the rookie draft player pool is displayed
    When the user filters by NFL team "Kansas City Chiefs"
    Then only rookies drafted by the Chiefs should be displayed
    And the landing spot information should be shown

  @rookie-player-pool @sorting
  Scenario: Sort rookie pool by ADP
    Given the rookie draft player pool is displayed
    When the user sorts by "Rookie ADP"
    Then players should be ordered by their rookie average draft position
    And ADP values should be clearly displayed

  @rookie-player-pool @sorting
  Scenario: Sort rookie pool by NFL draft position
    Given the rookie draft player pool is displayed
    When the user sorts by "NFL Draft Position"
    Then players should be ordered by their actual NFL draft selection
    And undrafted free agents should appear at the bottom

  @rookie-player-pool @search
  Scenario: Search for specific rookie by name
    Given the rookie draft player pool is displayed
    When the user searches for "Marvin Harrison"
    Then matching rookie players should be displayed
    And the search should support partial name matching

  @rookie-player-pool @import
  Scenario: Import rookie class after NFL Draft
    Given the NFL Draft has been completed
    And the platform admin initiates rookie import
    When the rookie class is imported
    Then all drafted rookies should be added to the pool
    And their NFL team and draft position should be recorded
    And undrafted free agents should be flagged appropriately

  @rookie-player-pool @updates
  Scenario: Update rookie pool with undrafted free agent signings
    Given the rookie draft pool has been imported
    And an undrafted free agent signs with an NFL team
    When the pool is updated
    Then the player's NFL team should be reflected
    And their status should change from "UDFA" to "Signed"

  @rookie-player-pool @projections
  Scenario: Display rookie projections
    Given the rookie draft player pool is displayed
    When the user views a rookie's profile
    Then projected stats for their first season should be shown
    And the projection source should be indicated
    And confidence intervals should be displayed

  @rookie-player-pool @combine-data
  Scenario: Show NFL Combine metrics for rookies
    Given the rookie draft player pool is displayed
    When the user views combine data
    Then measurables like 40-yard dash and vertical jump should be shown
    And athletic scores and percentiles should be displayed
    And players without combine data should be indicated

  # --------------------------------------------------------------------------
  # NFL Draft Order Integration
  # --------------------------------------------------------------------------
  @nfl-draft-integration @real-time
  Scenario: Real-time updates during NFL Draft
    Given the NFL Draft is in progress
    And the rookie draft pool is being viewed
    When an NFL team selects a player
    Then the player's NFL team should update immediately
    And their draft slot should be recorded
    And a notification should be displayed

  @nfl-draft-integration @landing-spots
  Scenario: Display rookie landing spot analysis
    Given rookies have been drafted to NFL teams
    When the user views landing spot analysis
    Then depth chart position should be displayed
    And opportunity metrics should be calculated
    And team offensive/defensive rankings should be shown

  @nfl-draft-integration @capital
  Scenario: Track draft capital invested in rookies
    Given the NFL Draft has concluded
    When the user views draft capital analysis
    Then the draft pick used for each rookie should be shown
    And round value should be calculated
    And trade-up or trade-down history should be displayed

  @nfl-draft-integration @team-needs
  Scenario: Show NFL team needs before draft
    Given the NFL Draft is upcoming
    When the user views team needs analysis
    Then positional needs for each NFL team should be displayed
    And projected landing spots should be calculated
    And mock draft predictions should be shown

  @nfl-draft-integration @picks-by-team
  Scenario: View all picks by NFL team
    Given the NFL Draft has concluded
    When the user filters by "New York Giants"
    Then all rookies selected by the Giants should be displayed
    And their draft positions should be shown
    And the team's total draft capital spent should be calculated

  @nfl-draft-integration @trades
  Scenario: Track NFL Draft day trades
    Given the NFL Draft is in progress
    When a team trades up or down
    Then the trade details should be recorded
    And affected pick positions should be updated
    And rookie valuations may be adjusted

  @nfl-draft-integration @historical
  Scenario: Compare to historical draft classes
    Given the current rookie class is available
    When the user views historical comparisons
    Then similar players from past drafts should be suggested
    And historical hit rates by position and round should be shown
    And class strength comparisons should be displayed

  # --------------------------------------------------------------------------
  # Rookie Rankings
  # --------------------------------------------------------------------------
  @rookie-rankings @consensus
  Scenario: Display consensus rookie rankings
    Given multiple ranking sources are available
    When the user views consensus rookie rankings
    Then an aggregated ranking should be displayed
    And the ranking sources should be listed
    And variance across sources should be indicated

  @rookie-rankings @positional
  Scenario: View positional rookie rankings
    Given consensus rankings are available
    When the user selects "Running Back Rankings"
    Then only rookie running backs should be ranked
    And tier breaks should be clearly indicated
    And positional scarcity should be noted

  @rookie-rankings @tiers
  Scenario: Display rookie tier rankings
    Given rookie rankings are available
    When the user views tier-based rankings
    Then players should be grouped into tiers
    And tier boundaries should be clearly marked
    And tier descriptions should explain value differences

  @rookie-rankings @custom
  Scenario: Create custom rookie rankings
    Given the user wants personalized rankings
    When the user creates custom rookie rankings
    Then they should be able to drag and drop players
    And their rankings should be saved for draft reference
    And they should be able to share rankings with others

  @rookie-rankings @updates
  Scenario: Track ranking changes over time
    Given rookie rankings have been recorded over time
    When the user views ranking trends
    Then rising and falling players should be highlighted
    And week-over-week changes should be displayed
    And significant movers should be flagged

  @rookie-rankings @expert
  Scenario: Filter rankings by expert source
    Given multiple expert rankings are available
    When the user selects a specific expert
    Then only that expert's rankings should be displayed
    And the expert's track record should be shown
    And their methodology should be described

  @rookie-rankings @dynasty-value
  Scenario: Display dynasty rookie values
    Given rookie rankings and dynasty trade calculators are available
    When the user views dynasty values
    Then trade value equivalents should be shown
    And pick value comparisons should be displayed
    And value relative to veterans should be indicated

  @rookie-rankings @sleepers
  Scenario: Identify rookie sleepers
    Given rookie ADP data is available
    When the user views sleeper candidates
    Then players ranked higher than their ADP should be flagged
    And value opportunities should be highlighted
    And late-round targets should be suggested

  # --------------------------------------------------------------------------
  # Draft Pick Trading
  # --------------------------------------------------------------------------
  @pick-trading @future-picks
  Scenario: Trade future rookie picks
    Given teams have future rookie draft picks
    When a manager proposes trading a future first-round pick
    Then the pick's projected value should be displayed
    And the trade should be validated for fairness
    And future pick ownership should be updated upon acceptance

  @pick-trading @current-picks
  Scenario: Trade picks during rookie draft
    Given the rookie draft is in progress
    And a manager wants to trade up
    When they propose a pick swap
    Then the draft order should be updated immediately
    And all managers should be notified of the trade
    And the draft should pause briefly if needed

  @pick-trading @pick-value
  Scenario: Display pick value chart
    Given rookie pick trading is being considered
    When the user views the pick value chart
    Then relative values for each pick should be shown
    And historical hit rates by pick should be displayed
    And trade calculator suggestions should be provided

  @pick-trading @conditional
  Scenario: Create conditional pick trades
    Given a trade involves conditional picks
    When the conditions are specified
    Then the conditions should be clearly documented
    And the pick should be marked as conditional
    And resolution criteria should be defined

  @pick-trading @multi-year
  Scenario: Trade picks across multiple years
    Given future draft picks are tradeable
    When a manager trades 2025 and 2026 picks
    Then both years' draft orders should be updated
    And pick ownership should be tracked for each year
    And trade history should span multiple seasons

  @pick-trading @restrictions
  Scenario: Enforce pick trading restrictions
    Given the league has pick trading rules
    When a manager attempts to trade their only remaining pick
    Then the trade should be blocked if it violates rules
    And a clear explanation should be provided
    And alternative trade structures should be suggested

  @pick-trading @valuation
  Scenario: Calculate pick trade fairness
    Given picks are being traded
    When the trade analyzer evaluates the deal
    Then pick values based on position should be calculated
    And team strength adjustments should be applied
    And a fairness score should be displayed

  @pick-trading @history
  Scenario: View pick trade history
    Given picks have been traded in the past
    When the user views pick trade history
    Then all historical pick trades should be displayed
    And outcomes of those trades should be shown
    And trade success rates should be calculated

  # --------------------------------------------------------------------------
  # Taxi Squad Placement
  # --------------------------------------------------------------------------
  @taxi-squad @rookie-placement
  Scenario: Place rookie on taxi squad after draft
    Given a manager has drafted a rookie
    And the league allows taxi squad placement
    When the manager places the rookie on the taxi squad
    Then the player should be moved to the taxi squad
    And the roster spot should be freed
    And the player should be ineligible for starting lineups

  @taxi-squad @eligibility
  Scenario: Enforce taxi squad eligibility rules
    Given the league limits taxi squad to first-year players
    When a manager attempts to add a second-year player
    Then the action should be blocked
    And eligibility rules should be explained
    And valid alternatives should be suggested

  @taxi-squad @promotion
  Scenario: Promote player from taxi squad
    Given a rookie is on the taxi squad
    When the manager promotes them to the active roster
    Then the player should be moved to the active roster
    And the taxi squad spot should be freed
    And the roster should be validated for space

  @taxi-squad @time-limits
  Scenario: Enforce taxi squad time limits
    Given a player has been on the taxi squad for the maximum allowed time
    When the deadline approaches
    Then the manager should be notified
    And forced promotion or release should be required
    And the deadline should be clearly displayed

  @taxi-squad @size-limits
  Scenario: Enforce taxi squad size limits
    Given the taxi squad is at maximum capacity
    When the manager attempts to add another player
    Then the action should be blocked
    And current taxi squad members should be displayed
    And a swap option should be offered

  @taxi-squad @protection
  Scenario: Protect taxi squad players from waivers
    Given a player is on the taxi squad
    When waivers are processed
    Then taxi squad players should not be claimable
    And their protected status should be displayed
    And protection rules should be enforced

  @taxi-squad @stats
  Scenario: Track taxi squad player development
    Given players are on the taxi squad
    When the user views taxi squad analytics
    Then NFL performance stats should be tracked
    And development trajectory should be projected
    And promotion recommendations should be made

  @taxi-squad @draft-and-stash
  Scenario: Draft directly to taxi squad
    Given the rookie draft is in progress
    And taxi squad placement is allowed during draft
    When the manager drafts a player
    Then an option to place directly on taxi should appear
    And the roster should remain compliant
    And the selection should be confirmed

  # --------------------------------------------------------------------------
  # Rookie Draft Order Determination
  # --------------------------------------------------------------------------
  @draft-order @standings-based
  Scenario: Determine draft order by standings
    Given the previous season has concluded
    And draft order is based on inverse standings
    When draft order is calculated
    Then the worst team should pick first
    And the champion should pick last
    And all positions should be assigned

  @draft-order @lottery
  Scenario: Conduct draft lottery for top picks
    Given the league uses a lottery for draft order
    And the lottery odds are set
    When the lottery is conducted
    Then random selection should determine top picks
    And lottery results should be recorded
    And all managers should be notified

  @draft-order @potential-points
  Scenario: Use potential points for draft order
    Given the league uses potential points for order
    When draft order is calculated
    Then teams are ranked by maximum possible points
    And tanking is discouraged
    And order should reflect true team strength

  @draft-order @playoff-bracket
  Scenario: Determine order by playoff results
    Given playoffs have concluded
    When draft order is set
    Then consolation bracket results should determine order
    And playoff teams should pick later
    And the order should reflect final standings

  @draft-order @custom
  Scenario: Manually set draft order
    Given the commissioner wants to set custom order
    When they configure draft order manually
    Then they should be able to assign each position
    And the order should be validated
    And all managers should be notified of the order

  @draft-order @randomization
  Scenario: Randomize entire draft order
    Given the league uses random draft order
    When the randomization is triggered
    Then all positions should be randomly assigned
    And the randomization should be verifiable
    And results should be final and recorded

  @draft-order @snake-vs-linear
  Scenario: Choose between snake and linear formats
    Given draft order has been determined
    When the commissioner selects draft format
    Then snake or linear order should be applied
    And second-round order should reflect the choice
    And all rounds should follow the selected pattern

  @draft-order @compensation
  Scenario: Award compensatory picks
    Given a team lost significant free agents
    When compensatory picks are calculated
    Then additional picks should be awarded
    And pick positions should be determined by loss value
    And compensatory picks should be clearly marked

  # --------------------------------------------------------------------------
  # Multi-Round Rookie Drafts
  # --------------------------------------------------------------------------
  @multi-round @configuration
  Scenario: Configure number of rookie draft rounds
    Given the commissioner is setting up the rookie draft
    When they configure the number of rounds
    Then rounds from 1 to 5 should be selectable
    And total picks should be calculated
    And the configuration should be saved

  @multi-round @deep-drafts
  Scenario: Conduct deep multi-round rookie draft
    Given a 5-round rookie draft is configured
    When the draft is conducted
    Then all 5 rounds should be completable
    And deep sleepers should be available
    And rosters should accommodate all picks

  @multi-round @round-timers
  Scenario: Set different timers per round
    Given multi-round draft is configured
    When different round timers are set
    Then later rounds can have shorter timers
    And early rounds can have longer timers
    And timer changes should be announced

  @multi-round @round-breaks
  Scenario: Schedule breaks between rounds
    Given a long rookie draft is planned
    When breaks are configured between rounds
    Then the draft should pause at specified points
    And resume time should be clearly communicated
    And all managers should be notified

  @multi-round @pick-tracking
  Scenario: Track picks across all rounds
    Given a multi-round draft is in progress
    When picks are made
    Then all picks should be recorded by round
    And draft history should show round information
    And pick ownership should be tracked throughout

  @multi-round @round-by-round-analysis
  Scenario: Analyze draft by round
    Given a multi-round draft has concluded
    When the user views round analysis
    Then value by round should be calculated
    And position distribution by round should be shown
    And round-specific insights should be provided

  @multi-round @supplemental
  Scenario: Conduct supplemental rookie draft
    Given the main rookie draft has concluded
    And new rookies become available
    When a supplemental draft is held
    Then only newly available rookies should be draftable
    And separate draft order should be used
    And picks should be tracked separately

  @multi-round @early-exit
  Scenario: Allow early draft completion
    Given remaining players have low value
    When all managers agree to end early
    Then the draft can be concluded
    And remaining players go to waivers
    And the early end should be recorded

  # --------------------------------------------------------------------------
  # Rookie Draft Timing
  # --------------------------------------------------------------------------
  @timing @scheduling
  Scenario: Schedule rookie draft date and time
    Given the commissioner is planning the rookie draft
    When they set the date and time
    Then the draft should be scheduled
    And all managers should be notified
    And calendar invites should be available

  @timing @nfl-draft-sync
  Scenario: Schedule draft relative to NFL Draft
    Given the rookie draft timing depends on NFL Draft
    When the commissioner sets "2 weeks after NFL Draft"
    Then the date should auto-calculate
    And adjustments should occur if NFL Draft moves
    And the relative timing should be maintained

  @timing @pick-clock
  Scenario: Configure pick clock duration
    Given the rookie draft timing is being set
    When the commissioner sets pick timer to 4 hours
    Then each pick should have a 4-hour window
    And the clock should start after previous pick
    And auto-pick should trigger on timeout

  @timing @pause
  Scenario: Pause rookie draft for holidays
    Given the rookie draft is in progress
    And a holiday is approaching
    When the commissioner pauses the draft
    Then the pick clock should stop
    And managers should be notified
    And the resume time should be scheduled

  @timing @night-pause
  Scenario: Implement overnight draft pause
    Given the draft has overnight pause enabled
    When the clock reaches 11 PM local time
    Then picks should be paused until morning
    And the pause should be clearly indicated
    And the draft should resume at the scheduled time

  @timing @weekend-hours
  Scenario: Adjust timing for weekend availability
    Given the draft spans a weekend
    When weekend hours are configured
    Then pick times may differ on weekends
    And all managers should be aware of the schedule
    And notifications should reflect timing changes

  @timing @deadline
  Scenario: Set overall draft deadline
    Given the rookie draft is slow-paced
    When a final deadline is set
    Then the draft must complete by that date
    And warnings should appear as deadline approaches
    And auto-pick should handle remaining picks if needed

  @timing @reminders
  Scenario: Send pick reminders
    Given a manager is on the clock
    When a configurable time threshold is reached
    Then reminder notifications should be sent
    And escalating urgency should be indicated
    And the remaining time should be displayed

  # --------------------------------------------------------------------------
  # Devy Player Integration
  # --------------------------------------------------------------------------
  @devy @college-players
  Scenario: Include college players in devy drafts
    Given the league supports devy players
    And devy drafting is enabled
    When the devy draft pool is displayed
    Then college players should be available
    And their eligibility year should be shown
    And college stats should be displayed

  @devy @eligibility-tracking
  Scenario: Track devy player eligibility
    Given devy players have been drafted
    When their NFL Draft eligibility arrives
    Then managers should be notified
    And the player's status should update
    And they should move to rookie pool when drafted

  @devy @rights-ownership
  Scenario: Maintain devy player rights
    Given a manager has drafted a devy player
    When the player is still in college
    Then ownership rights should be maintained
    And the player should appear on devy roster
    And protection from other managers should be enforced

  @devy @promotion-to-rookie
  Scenario: Promote devy player to rookie status
    Given a devy player has been drafted by an NFL team
    When their status is updated
    Then they should move from devy to rookie roster
    And their dynasty value should be recalculated
    And roster compliance should be verified

  @devy @transfer-portal
  Scenario: Track transfer portal activity
    Given devy players may transfer schools
    When a transfer occurs
    Then the player's school should update
    And projected draft stock may change
    And managers should be notified

  @devy @injury-tracking
  Scenario: Track devy player injuries
    Given a devy player is injured in college
    When the injury is reported
    Then the player's status should update
    And projected timeline should be indicated
    And dynasty value impact should be shown

  @devy @combine-projection
  Scenario: Project devy player combine performance
    Given devy players are approaching the NFL Combine
    When projections are requested
    Then expected measurables should be displayed
    And comparison to NFL standards should be shown
    And draft stock projections should be provided

  @devy @separate-draft
  Scenario: Conduct separate devy draft
    Given the league holds an annual devy draft
    When the devy draft is conducted
    Then only college players should be available
    And picks should be recorded separately
    And devy rosters should be updated

  # --------------------------------------------------------------------------
  # Rookie Draft League Settings
  # --------------------------------------------------------------------------
  @settings @draft-configuration
  Scenario: Configure rookie draft format
    Given the commissioner is in league settings
    When they configure rookie draft settings
    Then draft type should be selectable
    And number of rounds should be configurable
    And timer settings should be adjustable

  @settings @roster-limits
  Scenario: Set post-draft roster limits
    Given rookie drafts add players to rosters
    When roster limits are configured
    Then maximum roster size should be enforced
    And required cuts should be calculated
    And cut deadlines should be set

  @settings @pick-trading-rules
  Scenario: Configure pick trading rules
    Given the commissioner is managing settings
    When pick trading rules are set
    Then tradeable years should be defined
    And minimum pick retention should be enforced
    And trade deadline for picks should be set

  @settings @taxi-rules
  Scenario: Configure taxi squad rules
    Given the league uses taxi squads
    When taxi settings are configured
    Then squad size should be set
    And eligibility rules should be defined
    And time limits should be established

  @settings @auto-pick
  Scenario: Configure auto-pick behavior
    Given managers may miss picks
    When auto-pick settings are configured
    Then default ranking source should be selected
    And pick notification before auto-pick should be set
    And auto-pick logging should be enabled

  @settings @draft-order-method
  Scenario: Select draft order determination method
    Given the commissioner is configuring draft order
    When the method is selected
    Then standings-based or lottery options should be available
    And custom configurations should be possible
    And the method should be saved and displayed

  @settings @pick-clock-options
  Scenario: Configure pick clock options
    Given timing settings are being configured
    When pick clock options are set
    Then duration per pick should be configurable
    And overnight pause should be toggleable
    And weekend adjustments should be available

  @settings @notification-preferences
  Scenario: Set draft notification preferences
    Given managers want timely notifications
    When notification settings are configured
    Then on-the-clock alerts should be toggleable
    And pick made notifications should be configurable
    And reminder frequency should be adjustable

  # --------------------------------------------------------------------------
  # Error Handling
  # --------------------------------------------------------------------------
  @error-handling @draft-errors
  Scenario: Handle attempt to draft already-selected player
    Given the rookie draft is in progress
    And a player has been selected
    When another manager attempts to draft the same player
    Then an error message should be displayed
    And the pick should not be processed
    And the available player pool should refresh

  @error-handling @invalid-pick
  Scenario: Handle pick on ineligible player
    Given a player is not in the rookie pool
    When a manager attempts to draft them
    Then the pick should be rejected
    And an explanation should be provided
    And valid alternatives should be suggested

  @error-handling @roster-violation
  Scenario: Handle pick that would violate roster limits
    Given a manager's roster is at maximum capacity
    When they attempt to make a draft pick
    Then a warning should be displayed
    And cut requirements should be explained
    And the pick can proceed with pending cuts

  @error-handling @connection-loss
  Scenario: Handle connection loss during draft
    Given a manager loses internet connection during their pick
    When the connection is restored
    Then draft state should be synchronized
    And any missed time should be accounted for
    And the pick can be completed if time remains

  @error-handling @trade-during-draft
  Scenario: Handle trade conflicts during draft
    Given picks are being traded during the draft
    When a conflict arises
    Then the issue should be clearly identified
    And resolution options should be provided
    And draft integrity should be maintained

  @error-handling @timer-malfunction
  Scenario: Handle pick timer malfunction
    Given the pick timer experiences an error
    When the issue is detected
    Then the timer should be paused
    And the commissioner should be notified
    And manual intervention should be available

  @error-handling @import-failure
  Scenario: Handle rookie class import failure
    Given the rookie class import encounters an error
    When the failure occurs
    Then partial imports should be rolled back
    And the error should be logged
    And manual import options should be available

  @error-handling @concurrent-access
  Scenario: Handle concurrent draft access
    Given multiple managers access the draft simultaneously
    When picks are made rapidly
    Then race conditions should be prevented
    And pick order should be maintained
    And all managers should see consistent state

  # --------------------------------------------------------------------------
  # Accessibility
  # --------------------------------------------------------------------------
  @accessibility @screen-reader
  Scenario: Navigate rookie draft with screen reader
    Given a user is using a screen reader
    When they access the rookie draft interface
    Then all draft elements should have proper labels
    And pick announcements should be read aloud
    And timer status should be conveyed accessibly

  @accessibility @keyboard
  Scenario: Complete draft pick using keyboard only
    Given a user navigates using only the keyboard
    When they are on the clock
    Then they should be able to search players with keyboard
    And player selection should be keyboard accessible
    And pick confirmation should be keyboard operable

  @accessibility @color-contrast
  Scenario: Display draft board with proper contrast
    Given a user has visual impairments
    When they view the draft board
    Then color contrast should meet WCAG standards
    And important information should not rely on color alone
    And text should be readable at various sizes

  @accessibility @mobile
  Scenario: Participate in draft from mobile device
    Given a user is drafting from a mobile device
    When they access the draft
    Then the interface should be touch-friendly
    And all functions should be accessible
    And the experience should be optimized for mobile

  @accessibility @reduced-motion
  Scenario: Accommodate reduced motion preferences
    Given a user prefers reduced motion
    When draft animations occur
    Then animations should be minimized or disabled
    And essential information should still be conveyed
    And the experience should remain functional

  @accessibility @zoom
  Scenario: Support browser zoom for draft interface
    Given a user needs to zoom the interface
    When they zoom to 200%
    Then all draft elements should remain usable
    And no information should be cut off
    And the layout should adapt appropriately

  @accessibility @focus-indicators
  Scenario: Display clear focus indicators
    Given a user is navigating the draft interface
    When elements receive focus
    Then focus indicators should be clearly visible
    And the current position should be obvious
    And focus should move logically through the interface

  @accessibility @timeout-extensions
  Scenario: Request pick time extension for accessibility
    Given a user needs additional time due to accessibility needs
    When they request a time extension
    Then additional time should be granted
    And the extension should not disadvantage other managers
    And the accommodation should be documented

  # --------------------------------------------------------------------------
  # Performance
  # --------------------------------------------------------------------------
  @performance @draft-load
  Scenario: Load rookie draft interface quickly
    Given a user accesses the rookie draft
    When the page loads
    Then the initial view should render within 2 seconds
    And the player pool should load within 3 seconds
    And the interface should be interactive immediately

  @performance @real-time-updates
  Scenario: Deliver pick updates in real-time
    Given the draft is in progress with multiple managers
    When a pick is made
    Then all other managers should see the update within 1 second
    And no manual refresh should be required
    And the experience should feel instantaneous

  @performance @large-leagues
  Scenario: Handle large league rookie drafts
    Given a league has 16 or more teams
    When the rookie draft is conducted
    Then performance should remain smooth
    And all picks should be processed efficiently
    And no timeouts should occur

  @performance @search-speed
  Scenario: Search player pool quickly
    Given a manager is searching the player pool
    When they type a search query
    Then results should appear within 500 milliseconds
    And search should be responsive while typing
    And filtering should not cause lag

  @performance @concurrent-users
  Scenario: Support many concurrent draft users
    Given multiple drafts are occurring simultaneously
    When all users are active
    Then system performance should remain stable
    And each draft should function independently
    And no cross-draft interference should occur

  @performance @mobile-optimization
  Scenario: Optimize performance on mobile devices
    Given a user is drafting from a mobile device
    When they interact with the draft
    Then response times should be comparable to desktop
    And battery usage should be reasonable
    And data usage should be minimized

  @performance @timer-accuracy
  Scenario: Maintain accurate pick timers
    Given pick timers are running
    When time elapses
    Then timer accuracy should be within 1 second
    And timers should not drift over long drafts
    And all managers should see synchronized timers

  @performance @draft-history
  Scenario: Load draft history efficiently
    Given a multi-year league has extensive draft history
    When a user views historical drafts
    Then history should load within 3 seconds
    And pagination should be efficient
    And filters should respond quickly
