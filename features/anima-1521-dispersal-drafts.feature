@dispersal-drafts @dynasty @league-management
Feature: Dispersal Drafts
  As a dynasty fantasy football league commissioner
  I want to conduct dispersal drafts when teams become orphaned
  So that new owners can fairly acquire players from abandoned rosters

  Background:
    Given the fantasy football platform is available
    And the user is authenticated
    And a dynasty league with orphan teams exists

  # --------------------------------------------------------------------------
  # Orphan Team Redistribution
  # --------------------------------------------------------------------------
  @orphan-redistribution @team-management
  Scenario: Identify orphan teams for dispersal
    Given one or more teams have been abandoned
    When the commissioner initiates dispersal process
    Then orphan teams should be identified
    And their rosters should be marked for dispersal
    And the process should be documented

  @orphan-redistribution @multi-team
  Scenario: Handle multiple orphan teams simultaneously
    Given three teams have been abandoned
    When dispersal is initiated
    Then all orphan team rosters should be combined
    And a unified dispersal pool should be created
    And the process should accommodate multiple teams

  @orphan-redistribution @partial-season
  Scenario: Manage mid-season orphan dispersal
    Given a team is abandoned during the season
    When dispersal is required
    Then season timing should be considered
    And appropriate procedures should apply
    And league continuity should be maintained

  @orphan-redistribution @notification
  Scenario: Notify league of orphan team situation
    Given a team has been identified as orphan
    When the notification is sent
    Then all managers should be informed
    And the dispersal timeline should be communicated
    And new owner recruitment should begin

  @orphan-redistribution @roster-freeze
  Scenario: Freeze orphan team rosters
    Given a team is identified for dispersal
    When the freeze is activated
    Then roster moves should be blocked
    And trades should be prohibited
    And the roster should be preserved for dispersal

  @orphan-redistribution @asset-inventory
  Scenario: Inventory all orphan team assets
    Given orphan teams have been identified
    When assets are inventoried
    Then all players should be listed
    And draft picks should be cataloged
    And FAAB or salary should be documented

  @orphan-redistribution @timeline
  Scenario: Establish dispersal timeline
    Given orphan teams need redistribution
    When the timeline is set
    Then key dates should be established
    And deadlines should be communicated
    And the process should proceed on schedule

  @orphan-redistribution @documentation
  Scenario: Document dispersal process
    Given the dispersal is being conducted
    When documentation is maintained
    Then all decisions should be recorded
    And the process should be transparent
    And historical records should be preserved

  # --------------------------------------------------------------------------
  # Dispersal Pool Creation
  # --------------------------------------------------------------------------
  @pool-creation @player-aggregation
  Scenario: Aggregate players from orphan teams
    Given multiple orphan teams have players
    When the pool is created
    Then all players should be combined into one pool
    And player ownership history should be noted
    And the pool should be comprehensive

  @pool-creation @pick-aggregation
  Scenario: Include draft picks in dispersal pool
    Given orphan teams own draft picks
    When the pool is created
    Then all future picks should be included
    And pick years and rounds should be documented
    And pick values should be estimated

  @pool-creation @faab-inclusion
  Scenario: Include FAAB budget in dispersal
    Given orphan teams have remaining FAAB
    When the pool is created
    Then FAAB should be part of the dispersal
    And distribution method should be determined
    And budget allocation should be fair

  @pool-creation @salary-cap-assets
  Scenario: Handle salary cap assets in dispersal
    Given the league uses salary caps
    When orphan team assets are pooled
    Then player contracts should be included
    And salary implications should be calculated
    And cap management should be considered

  @pool-creation @taxi-squad
  Scenario: Include taxi squad players in pool
    Given orphan teams have taxi squad players
    When the pool is created
    Then taxi players should be included
    And their status should be noted
    And all roster types should be represented

  @pool-creation @ir-players
  Scenario: Handle IR players in dispersal pool
    Given orphan teams have injured players
    When the pool is created
    Then IR players should be included
    And injury status should be displayed
    And their value should be considered

  @pool-creation @pool-display
  Scenario: Display complete dispersal pool
    Given the pool has been created
    When managers view the pool
    Then all assets should be visible
    And sorting and filtering should be available
    And comprehensive information should be shown

  @pool-creation @pool-valuation
  Scenario: Calculate pool asset values
    Given the dispersal pool is complete
    When valuations are calculated
    Then player values should be estimated
    And pick values should be shown
    And total pool value should be displayed

  # --------------------------------------------------------------------------
  # New Owner Drafting
  # --------------------------------------------------------------------------
  @new-owner @drafting-rights
  Scenario: Grant drafting rights to new owners
    Given new owners have been recruited
    When they join the league
    Then they should receive dispersal draft rights
    And their participation should be enabled
    And they should have access to the pool

  @new-owner @selection-process
  Scenario: Conduct dispersal draft for new owners
    Given new owners are ready to draft
    When the dispersal draft begins
    Then they should select from the pool
    And selections should be exclusive
    And rosters should be built progressively

  @new-owner @roster-building
  Scenario: Build complete roster through dispersal
    Given new owners are drafting
    When the draft continues
    Then they should fill all roster spots
    And position requirements should be met
    And complete rosters should result

  @new-owner @pick-acquisition
  Scenario: Acquire draft picks in dispersal
    Given draft picks are in the pool
    When a new owner selects a pick
    Then pick ownership should transfer
    And future drafts should reflect ownership
    And pick tracking should update

  @new-owner @faab-allocation
  Scenario: Allocate FAAB to new owners
    Given FAAB is part of the dispersal
    When allocation occurs
    Then new owners should receive fair shares
    And the method should be transparent
    And budgets should be updated

  @new-owner @strategy-guidance
  Scenario: Provide dispersal strategy guidance
    Given new owners may be inexperienced
    When guidance is available
    Then strategy tips should be provided
    And pool analysis should be offered
    And informed decisions should be enabled

  @new-owner @onboarding
  Scenario: Onboard new owners to the league
    Given new owners join via dispersal
    When onboarding occurs
    Then league rules should be shared
    And history should be provided
    And integration should be smooth

  @new-owner @equal-opportunity
  Scenario: Ensure equal drafting opportunity
    Given multiple new owners are drafting
    When the process proceeds
    Then opportunities should be balanced
    And no owner should have unfair advantage
    And the process should be equitable

  # --------------------------------------------------------------------------
  # Dispersal Draft Order
  # --------------------------------------------------------------------------
  @draft-order @lottery
  Scenario: Determine order by lottery
    Given new owners need draft order
    When a lottery is conducted
    Then order should be randomly assigned
    And the lottery should be verifiable
    And results should be final

  @draft-order @reverse-standings
  Scenario: Use reverse standings for new owners
    Given standings can inform order
    When reverse standings are applied
    Then orphan teams' standings determine position
    And worse teams yield better picks
    And the method should be documented

  @draft-order @snake-format
  Scenario: Apply snake format to dispersal
    Given snake format is selected
    When the draft proceeds
    Then order should reverse each round
    And pick value should balance
    And the format should be clear

  @draft-order @linear-format
  Scenario: Apply linear format to dispersal
    Given linear format is selected
    When the draft proceeds
    Then order should remain consistent
    And first pick maintains advantage
    And the format should be understood

  @draft-order @auction-format
  Scenario: Use auction format for dispersal
    Given auction format is preferred
    When the dispersal draft occurs
    Then new owners should bid on players
    And budgets should be managed
    And highest bidders should win

  @draft-order @predetermined
  Scenario: Use predetermined draft order
    Given the commissioner sets order
    When order is established
    Then the predetermined order should apply
    And all parties should be informed
    And the order should be final

  @draft-order @negotiated
  Scenario: Allow new owners to negotiate order
    Given new owners want to determine order
    When negotiation occurs
    Then they may agree on positions
    And trades of position may occur
    And the final order should be confirmed

  @draft-order @weighted-lottery
  Scenario: Use weighted lottery for order
    Given some positions should be more likely
    When weighted lottery is used
    Then weights should influence results
    And the weighting should be fair
    And results should be accepted

  # --------------------------------------------------------------------------
  # Combined Roster Pools
  # --------------------------------------------------------------------------
  @combined-pool @multi-team-merger
  Scenario: Merge multiple orphan rosters
    Given multiple teams are being dispersed
    When rosters are merged
    Then a single pool should result
    And duplicate positions should be handled
    And the merge should be complete

  @combined-pool @player-rankings
  Scenario: Rank players in combined pool
    Given the combined pool is ready
    When rankings are applied
    Then players should be ordered by value
    And rankings should be displayed
    And sorting should be flexible

  @combined-pool @position-distribution
  Scenario: Analyze position distribution in pool
    Given the pool contains various positions
    When analysis is performed
    Then position counts should be displayed
    And scarcity should be identified
    And strategy should be informed

  @combined-pool @value-tiers
  Scenario: Display value tiers in combined pool
    Given players have different values
    When tiers are shown
    Then tier breaks should be visible
    And value groupings should be clear
    And selection strategy should be aided

  @combined-pool @search-filter
  Scenario: Search and filter combined pool
    Given the pool contains many players
    When search and filter are used
    Then specific players should be findable
    And filters should narrow results
    And the interface should be efficient

  @combined-pool @comparison-tools
  Scenario: Compare players in pool
    Given multiple players are of interest
    When comparison is requested
    Then side-by-side comparison should display
    And key metrics should be shown
    And decisions should be informed

  @combined-pool @pool-integrity
  Scenario: Maintain pool integrity during draft
    Given the draft is in progress
    When selections are made
    Then the pool should update correctly
    And selected players should be removed
    And remaining options should be clear

  @combined-pool @historical-data
  Scenario: Show player historical data in pool
    Given players have fantasy history
    When history is displayed
    Then past performance should be shown
    And trends should be visible
    And projections should be available

  # --------------------------------------------------------------------------
  # Dispersal Pick Allocation
  # --------------------------------------------------------------------------
  @pick-allocation @equal-distribution
  Scenario: Distribute picks equally among new owners
    Given orphan teams had draft picks
    When allocation occurs
    Then picks should be distributed evenly
    And any remainders should be handled fairly
    And all owners should receive picks

  @pick-allocation @draft-method
  Scenario: Draft picks as part of dispersal
    Given picks are in the dispersal pool
    When new owners select picks
    Then picks should be draftable like players
    And pick values should guide decisions
    And ownership should transfer on selection

  @pick-allocation @separate-phase
  Scenario: Conduct separate pick allocation phase
    Given picks are allocated separately
    When the pick phase occurs
    Then only picks should be selected
    And player drafting should be separate
    And phases should be distinct

  @pick-allocation @value-based
  Scenario: Allocate picks based on value balancing
    Given picks have different values
    When value-based allocation occurs
    Then high-value picks should balance rosters
    And total value should be equitable
    And the method should be transparent

  @pick-allocation @conditional-picks
  Scenario: Handle conditional picks in allocation
    Given some picks have conditions
    When allocation occurs
    Then conditions should be preserved
    And resolution should be tracked
    And ownership should be clear

  @pick-allocation @pick-trading-post
  Scenario: Allow pick trading after allocation
    Given picks have been allocated
    When trading is permitted
    Then new owners can trade picks
    And standard trading rules should apply
    And ownership should update

  @pick-allocation @multi-year
  Scenario: Allocate picks across multiple years
    Given picks span several years
    When allocation occurs
    Then all years should be included
    And future value should be considered
    And complete allocation should result

  @pick-allocation @pick-visibility
  Scenario: Display pick allocation results
    Given allocation is complete
    When results are displayed
    Then each owner's picks should be shown
    And pick details should be visible
    And the allocation should be confirmed

  # --------------------------------------------------------------------------
  # Partial Dispersal Drafts
  # --------------------------------------------------------------------------
  @partial-dispersal @single-team
  Scenario: Conduct dispersal for single orphan team
    Given only one team is orphaned
    When dispersal is needed
    Then a single-team dispersal should occur
    And the process should be streamlined
    And one new owner should be recruited

  @partial-dispersal @existing-owners
  Scenario: Allow existing owners in partial dispersal
    Given a partial dispersal is occurring
    When existing owners participate
    Then they may draft from the pool
    And league-wide participation should be permitted
    And fairness should be maintained

  @partial-dispersal @split-assets
  Scenario: Split assets between new and existing owners
    Given assets are being dispersed
    When split allocation occurs
    Then new owners may get priority
    And existing owners may participate later
    And the split should be fair

  @partial-dispersal @protected-players
  Scenario: Protect certain players from dispersal
    Given some players should be protected
    When protection is applied
    Then protected players should be excluded
    And the remainder should be dispersed
    And protection rules should be clear

  @partial-dispersal @lottery-for-existing
  Scenario: Conduct lottery for existing owner participation
    Given existing owners want pool access
    When a lottery determines eligibility
    Then lottery results should enable participation
    And selected owners can draft
    And the process should be fair

  @partial-dispersal @supplemental-dispersal
  Scenario: Conduct supplemental dispersal rounds
    Given initial dispersal is complete
    When additional rounds are needed
    Then supplemental rounds should occur
    And remaining assets should be distributed
    And full distribution should result

  @partial-dispersal @waiver-fallback
  Scenario: Move remaining players to waivers
    Given dispersal draft concludes
    When players remain undrafted
    Then they should move to waiver wire
    And standard waiver rules should apply
    And no players should be lost

  @partial-dispersal @commissioner-discretion
  Scenario: Apply commissioner discretion in partial dispersal
    Given unusual circumstances arise
    When commissioner judgment is needed
    Then fair decisions should be made
    And decisions should be documented
    And all parties should be informed

  # --------------------------------------------------------------------------
  # Dispersal Draft Formats
  # --------------------------------------------------------------------------
  @draft-format @standard-snake
  Scenario: Conduct standard snake dispersal
    Given snake format is configured
    When the dispersal draft occurs
    Then serpentine order should apply
    And rounds should alternate direction
    And the format should be familiar

  @draft-format @auction
  Scenario: Conduct auction dispersal draft
    Given auction format is selected
    When new owners bid
    Then highest bidder should win each player
    And budget management should be required
    And all players should be auctioned

  @draft-format @slow-draft
  Scenario: Conduct slow dispersal draft
    Given slow format is preferred
    When the draft proceeds
    Then extended pick times should apply
    And the draft may span days
    And asynchronous participation should be allowed

  @draft-format @live-draft
  Scenario: Conduct live dispersal draft
    Given live format is scheduled
    When all owners are present
    Then real-time drafting should occur
    And pick timers should be enforced
    And immediate decisions should be required

  @draft-format @hybrid
  Scenario: Use hybrid dispersal format
    Given different phases need different formats
    When hybrid approach is used
    Then format should vary by phase
    And transitions should be clear
    And all formats should be supported

  @draft-format @pick-clock
  Scenario: Configure pick clock for dispersal
    Given timing needs to be set
    When pick clock is configured
    Then pick duration should be enforced
    And timeouts should trigger auto-pick
    And timing should be appropriate

  @draft-format @breaks
  Scenario: Schedule breaks during dispersal
    Given the draft is lengthy
    When breaks are scheduled
    Then the draft should pause at set times
    And resume should be coordinated
    And all participants should be informed

  @draft-format @commissioner-facilitation
  Scenario: Enable commissioner-facilitated dispersal
    Given commissioner oversight is needed
    When they facilitate the draft
    Then they should manage the process
    And picks should be confirmed
    And issues should be resolved

  # --------------------------------------------------------------------------
  # Replacement Owner Integration
  # --------------------------------------------------------------------------
  @replacement-owner @recruitment
  Scenario: Recruit replacement owners
    Given owners are needed for orphan teams
    When recruitment occurs
    Then prospective owners should be identified
    And vetting should occur
    And suitable candidates should be selected

  @replacement-owner @vetting
  Scenario: Vet prospective replacement owners
    Given candidates have expressed interest
    When vetting occurs
    Then commitment level should be assessed
    And experience should be evaluated
    And fit with the league should be determined

  @replacement-owner @fee-requirements
  Scenario: Collect fees from replacement owners
    Given the league requires buy-in
    When fees are due
    Then payment should be collected
    And payment confirmation should be required
    And participation should depend on payment

  @replacement-owner @rule-acceptance
  Scenario: Require acceptance of league rules
    Given the league has established rules
    When new owners join
    Then they should acknowledge the rules
    And agreement should be recorded
    And compliance should be expected

  @replacement-owner @platform-setup
  Scenario: Set up platform access for new owners
    Given new owners have been accepted
    When platform setup occurs
    Then accounts should be created
    And permissions should be granted
    And access should be verified

  @replacement-owner @communication
  Scenario: Establish communication with new owners
    Given new owners are joining
    When communication channels are set up
    Then they should have access to league chat
    And contact information should be shared
    And integration should be facilitated

  @replacement-owner @history-review
  Scenario: Provide league history to new owners
    Given the league has history
    When review is provided
    Then key events should be shared
    And standings history should be available
    And context should be given

  @replacement-owner @mentorship
  Scenario: Offer mentorship to new dynasty owners
    Given new owners may need guidance
    When mentorship is offered
    Then experienced owners should assist
    And questions should be answered
    And successful integration should result

  # --------------------------------------------------------------------------
  # Dispersal Draft League Settings
  # --------------------------------------------------------------------------
  @settings @dispersal-trigger
  Scenario: Configure dispersal trigger conditions
    Given the commissioner manages settings
    When trigger conditions are set
    Then orphan thresholds should be defined
    And automatic detection should be enabled
    And manual triggering should be available

  @settings @format-selection
  Scenario: Select dispersal draft format
    Given format options are available
    When format is selected
    Then the chosen format should be saved
    And future dispersals should use it
    And the setting should be adjustable

  @settings @order-method
  Scenario: Configure draft order determination
    Given order methods are available
    When method is selected
    Then the method should be applied
    And documentation should be updated
    And all dispersals should follow it

  @settings @pool-rules
  Scenario: Configure dispersal pool rules
    Given pool configuration is needed
    When rules are set
    Then included assets should be defined
    And exclusions should be specified
    And rules should be enforced

  @settings @timing-preferences
  Scenario: Set dispersal timing preferences
    Given timing is configurable
    When preferences are set
    Then dispersal windows should be defined
    And notification timing should be set
    And schedules should be maintained

  @settings @participation-rules
  Scenario: Configure participation eligibility
    Given participation rules are needed
    When rules are set
    Then eligible participants should be defined
    And restrictions should be enforced
    And fairness should be ensured

  @settings @pick-allocation-method
  Scenario: Select pick allocation method
    Given methods are available
    When method is chosen
    Then the selected method should apply
    And documentation should be updated
    And consistency should be maintained

  @settings @notification-config
  Scenario: Configure dispersal notifications
    Given notifications are needed
    When configuration occurs
    Then notification types should be set
    And delivery preferences should be chosen
    And managers should receive appropriate alerts

  # --------------------------------------------------------------------------
  # Error Handling
  # --------------------------------------------------------------------------
  @error-handling @duplicate-selection
  Scenario: Handle duplicate player selection
    Given a player has been drafted
    When another owner attempts to select them
    Then the selection should be rejected
    And an error message should display
    And the available pool should refresh

  @error-handling @invalid-participant
  Scenario: Handle invalid participant attempt
    Given participation rules are in place
    When an ineligible owner attempts to participate
    Then participation should be blocked
    And the reason should be explained
    And proper participants should continue

  @error-handling @pool-sync-issues
  Scenario: Handle pool synchronization errors
    Given multiple users view the pool
    When sync issues occur
    Then the authoritative state should be restored
    And all clients should update
    And no selections should be lost

  @error-handling @connection-loss
  Scenario: Handle connection loss during dispersal
    Given a participant loses connection
    When their turn arrives
    Then appropriate timeout should apply
    And auto-pick may trigger
    And reconnection should restore access

  @error-handling @roster-violation
  Scenario: Handle roster limit violations
    Given a selection would exceed limits
    When the pick is attempted
    Then the violation should be flagged
    And the pick may be blocked
    And alternatives should be suggested

  @error-handling @pick-allocation-error
  Scenario: Handle pick allocation errors
    Given pick allocation encounters issues
    When errors are detected
    Then the issue should be identified
    And correction should be possible
    And the process should complete correctly

  @error-handling @owner-dropout
  Scenario: Handle new owner dropout during dispersal
    Given a new owner withdraws during draft
    When dropout is detected
    Then their selections should be handled
    And a replacement may be sought
    And the process should continue

  @error-handling @data-integrity
  Scenario: Maintain data integrity throughout dispersal
    Given the dispersal involves many transactions
    When the process completes
    Then all data should be consistent
    And no assets should be lost
    And records should be accurate

  # --------------------------------------------------------------------------
  # Accessibility
  # --------------------------------------------------------------------------
  @accessibility @screen-reader
  Scenario: Navigate dispersal draft with screen reader
    Given a user uses a screen reader
    When they access the dispersal draft
    Then all elements should be labeled
    And selections should be announced
    And navigation should be logical

  @accessibility @keyboard
  Scenario: Complete dispersal draft using keyboard
    Given a user navigates by keyboard
    When they participate in the draft
    Then all actions should be accessible
    And focus should be visible
    And shortcuts should be available

  @accessibility @color-contrast
  Scenario: Display dispersal interface with proper contrast
    Given a user has visual needs
    When they view the interface
    Then contrast should meet WCAG standards
    And color should not be the only indicator
    And text should be readable

  @accessibility @mobile
  Scenario: Participate in dispersal from mobile
    Given a user is on a mobile device
    When they access the dispersal draft
    Then the interface should be responsive
    And all functions should work
    And the experience should be optimized

  @accessibility @zoom
  Scenario: Support browser zoom for dispersal
    Given a user needs larger text
    When they zoom the browser
    Then the interface should remain usable
    And no content should be lost
    And layout should adapt

  @accessibility @reduced-motion
  Scenario: Accommodate reduced motion preferences
    Given a user prefers reduced motion
    When animations occur
    Then motion should be minimized
    And functionality should be preserved
    And preferences should be respected

  @accessibility @focus-management
  Scenario: Manage focus during dispersal draft
    Given focus changes during the draft
    When updates occur
    Then focus should move logically
    And users should not lose position
    And the experience should be smooth

  @accessibility @time-accommodations
  Scenario: Provide time accommodations
    Given a user needs additional time
    When accommodation is requested
    Then extra time should be granted
    And fairness should be maintained
    And the process should continue

  # --------------------------------------------------------------------------
  # Performance
  # --------------------------------------------------------------------------
  @performance @load-time
  Scenario: Load dispersal draft quickly
    Given a user accesses the dispersal draft
    When the page loads
    Then the interface should render within 2 seconds
    And the pool should load within 3 seconds
    And responsiveness should be immediate

  @performance @real-time-updates
  Scenario: Deliver selections in real-time
    Given multiple users are drafting
    When a selection is made
    Then all users should see it within 1 second
    And no refresh should be required
    And the experience should be seamless

  @performance @large-pools
  Scenario: Handle large dispersal pools efficiently
    Given multiple rosters are combined
    When the pool is displayed
    Then performance should remain smooth
    And scrolling should be efficient
    And search should be responsive

  @performance @concurrent-users
  Scenario: Support all participants simultaneously
    Given all draft participants are active
    When the draft proceeds
    Then the system should handle the load
    And performance should remain stable
    And no crashes should occur

  @performance @search-speed
  Scenario: Search pool quickly
    Given a participant searches for a player
    When they type
    Then results should appear within 500ms
    And search should be responsive
    And filtering should not lag

  @performance @mobile-optimization
  Scenario: Optimize for mobile performance
    Given users participate on mobile
    When they interact with the draft
    Then performance should be acceptable
    And battery usage should be reasonable
    And data usage should be efficient

  @performance @draft-completion
  Scenario: Process dispersal completion efficiently
    Given the dispersal draft concludes
    When finalization occurs
    Then processing should complete quickly
    And rosters should update immediately
    And the league should be ready to proceed

  @performance @history-access
  Scenario: Access dispersal history efficiently
    Given historical dispersals exist
    When history is viewed
    Then loading should be efficient
    And records should be accessible
    And navigation should be smooth
