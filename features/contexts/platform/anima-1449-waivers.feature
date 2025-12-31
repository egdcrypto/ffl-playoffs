@waivers @platform
Feature: Waivers
  As a fantasy football league
  I need comprehensive waiver wire functionality
  So that owners can acquire available players through a fair priority-based system

  Background:
    Given the waiver system is operational
    And waiver rules are configured for the league

  # ==================== Waiver Priority System ====================

  @priority @rolling-waivers
  Scenario: Apply rolling waiver priority
    Given rolling waivers are enabled
    When an owner successfully claims a player
    Then their priority should move to the end
    And other owners should move up in priority
    And the new order should be saved

  @priority @rolling-waivers
  Scenario: Display current waiver priority
    Given waiver priority exists
    When viewing the priority list
    Then all teams should be shown in order
    And current position should be highlighted
    And last successful claim should be noted

  @priority @reverse-standings
  Scenario: Set priority by reverse standings
    Given reverse standings priority is configured
    When the standings update
    Then waiver priority should reflect reverse order
    And worst team should have first priority
    And best team should have last priority

  @priority @reverse-standings
  Scenario: Update priority after standings change
    Given standings have changed
    When priority is recalculated
    Then new standings order should apply
    And teams should be reordered accordingly
    And owners should be notified of changes

  @priority @weekly-reset
  Scenario: Reset priority weekly
    Given weekly reset is enabled
    When the reset period occurs
    Then priority should reset to original order
    And all teams should start fresh
    And the reset should be logged

  @priority @weekly-reset
  Scenario: Configure reset timing
    Given reset settings are available
    When configuring reset timing
    Then options should include
      | reset_timing       | description                |
      | tuesday_morning    | after Monday night game    |
      | wednesday_morning  | mid-week reset             |
      | never              | maintain rolling all season|

  @priority @tracking-display
  Scenario: Track priority changes over time
    Given priority history is maintained
    When viewing priority tracking
    Then historical changes should be visible
    And claim-by-claim changes should show
    And trends should be identifiable

  @priority @tracking-display
  Scenario: Display priority impact preview
    Given an owner is considering a claim
    When previewing priority impact
    Then post-claim priority should be shown
    And the cost of using priority should be clear
    And strategic implications should be noted

  # ==================== FAAB Bidding ====================

  @faab @budget-management
  Scenario: Manage FAAB budget
    Given FAAB is enabled for the league
    When viewing budget status
    Then total budget should be displayed
    And spent amount should be shown
    And remaining balance should be calculated

  @faab @budget-management
  Scenario: Configure initial FAAB budget
    Given league settings are accessible
    When setting FAAB budget
    Then starting budget should be configurable
    And all teams should receive equal budget
    And the amount should be saved

  @faab @blind-bidding
  Scenario: Submit blind FAAB bid
    Given a player is on waivers
    When submitting a bid
    Then the bid amount should be hidden from others
    And the bid should be recorded
    And confirmation should be provided

  @faab @blind-bidding
  Scenario: Modify bid before processing
    Given a bid has been submitted
    When modifying the bid
    Then the new amount should replace the old
    And bid history should be maintained
    And modification deadline should apply

  @faab @bid-processing
  Scenario: Process FAAB bids
    Given the waiver period ends
    When processing bids
    Then highest bidder should win
    And winning bid should be deducted from budget
    And player should be assigned to winner

  @faab @bid-processing
  Scenario: Handle FAAB bid ties
    Given two owners submit identical bids
    When processing the tie
    Then tiebreaker rules should apply
      | tiebreaker_type    | resolution                 |
      | waiver_priority    | higher priority wins       |
      | reverse_standings  | worse record wins          |
      | coin_flip          | random selection           |

  @faab @budget-tracking
  Scenario: Track FAAB spending
    Given FAAB transactions occur
    When viewing spending history
    Then all bids should be logged
    And winning and losing bids should show
    And running balance should be calculated

  @faab @budget-tracking
  Scenario: Display league FAAB standings
    Given all teams have FAAB budgets
    When viewing FAAB standings
    Then remaining budgets should be ranked
    And spending totals should show
    And budget efficiency should be calculated

  # ==================== Waiver Claim Processing ====================

  @claims @submission
  Scenario: Submit waiver claim
    Given a player is available on waivers
    When submitting a claim
    Then the claim should be recorded
    And the player should be marked as claimed
    And the owner should see confirmation

  @claims @submission
  Scenario: Submit claim with player to drop
    Given roster is full
    When submitting a claim with a drop
    Then both add and drop should be recorded
    And the claim should be contingent on both
    And roster legality should be validated

  @claims @processing-windows
  Scenario: Process claims during window
    Given the processing window arrives
    When claims are processed
    Then claims should be evaluated in priority order
    And successful claims should be executed
    And rosters should update immediately

  @claims @processing-windows
  Scenario: Configure processing windows
    Given processing settings are available
    When configuring windows
    Then options should include
      | window_type        | timing                     |
      | daily              | every day at specified time|
      | twice_weekly       | Wed and Sun                |
      | weekly             | once per week              |
      | continuous         | immediate processing       |

  @claims @results
  Scenario: View claim results
    Given claims have been processed
    When viewing results
    Then successful claims should be shown
    And failed claims should be listed
    And reasons for failure should be provided

  @claims @results
  Scenario: Receive claim results notification
    Given claims were submitted
    When processing completes
    Then owners should be notified
    And results should be summarized
    And next steps should be suggested

  @claims @failed-claims
  Scenario: Handle failed waiver claims
    Given a claim fails
    When viewing the failure
    Then the reason should be displayed
      | failure_reason      | explanation                |
      | outbid              | higher bid won             |
      | priority_loss       | lower priority             |
      | player_claimed      | another owner claimed first|
      | roster_issue        | roster validation failed   |

  @claims @failed-claims
  Scenario: Retry failed claim
    Given a claim has failed
    When the player is still available
    Then a new claim should be submittable
    And the original claim should be archived
    And retry should be streamlined

  # ==================== Waiver Periods ====================

  @periods @weekly-windows
  Scenario: Enforce weekly waiver windows
    Given weekly windows are configured
    When a window is active
    Then claims should be accepted
    And processing should occur at window close
    And next window should be scheduled

  @periods @weekly-windows
  Scenario: Display waiver window countdown
    Given a window is active
    When viewing the countdown
    Then time remaining should be displayed
    And deadline should be prominent
    And timezone should be shown

  @periods @game-day-waivers
  Scenario: Apply game-day waiver rules
    Given game-day rules are configured
    When game time approaches
    Then players should lock appropriately
    And waiver periods should adjust
    And availability should update

  @periods @game-day-waivers
  Scenario: Handle Thursday night game waivers
    Given Thursday night games exist
    When Thursday approaches
    Then affected players should lock early
    And waiver processing should accommodate
    And owners should be warned

  @periods @continuous-waivers
  Scenario: Enable continuous waivers
    Given continuous waivers are configured
    When a claim is submitted
    Then processing should occur immediately
    And no waiting period should apply
    And results should be instant

  @periods @continuous-waivers
  Scenario: Configure continuous waiver settings
    Given continuous settings are available
    When configuring options
    Then settings should include
      | setting             | options                    |
      | processing_delay    | immediate, 1hr, 4hr        |
      | priority_type       | FAAB only, priority only   |
      | free_agent_delay    | 0, 12, 24 hours            |

  @periods @lockout-periods
  Scenario: Enforce lockout periods
    Given lockout rules exist
    When a lockout is active
    Then claims should be blocked
    And the lockout reason should display
    And unlock time should be shown

  @periods @lockout-periods
  Scenario: Configure lockout periods
    Given lockout settings are available
    When configuring lockouts
    Then lockout options should include
      | lockout_type        | timing                     |
      | game_start          | locks at kickoff           |
      | weekly_period       | Sunday AM to Tuesday       |
      | playoff_roster      | playoff roster locks       |

  # ==================== Claim Management ====================

  @management @add-drop-claims
  Scenario: Create add/drop claim
    Given an owner wants to add and drop
    When creating the claim
    Then the player to add should be selected
    And the player to drop should be specified
    And the claim should be linked

  @management @add-drop-claims
  Scenario: Validate add/drop legality
    Given an add/drop claim is submitted
    When validating the claim
    Then post-transaction roster should be legal
    And position requirements should be met
    And any violations should be flagged

  @management @multiple-claims
  Scenario: Submit multiple claims
    Given an owner wants multiple claims
    When submitting multiple claims
    Then each claim should be recorded
    And claims should be ordered by preference
    And processing should respect order

  @management @multiple-claims
  Scenario: Set claim priority order
    Given multiple claims exist
    When ordering claims
    Then drag-and-drop reordering should work
    And priority numbers should update
    And the order should be saved

  @management @claim-prioritization
  Scenario: Prioritize claims by preference
    Given claims are ordered
    When processing occurs
    Then highest priority claim should process first
    And subsequent claims should adjust
    And contingent drops should be handled

  @management @claim-prioritization
  Scenario: Handle contingent claim chains
    Given claims share drop players
    When processing the chain
    Then successful claims should remove drops
    And failed claims should preserve drops
    And chain should be processed in order

  @management @claim-cancellation
  Scenario: Cancel pending claim
    Given a claim is pending
    When cancelling the claim
    Then the claim should be removed
    And the player should be re-available
    And confirmation should be provided

  @management @claim-cancellation
  Scenario: Cancel all pending claims
    Given multiple claims are pending
    When cancelling all claims
    Then all claims should be removed
    And the owner should confirm the action
    And the cancellation should be logged

  # ==================== Free Agent Pickup ====================

  @free-agents @immediate-adds
  Scenario: Add free agent immediately
    Given a player is a free agent
    When adding the player
    Then the add should process immediately
    And the roster should update
    And no waiver period should apply

  @free-agents @immediate-adds
  Scenario: Add free agent with drop
    Given roster is full
    When adding a free agent with drop
    Then both transactions should process
    And roster should remain legal
    And confirmation should be shown

  @free-agents @post-waiver
  Scenario: Acquire player after waiver period
    Given a player cleared waivers
    When the player becomes a free agent
    Then immediate pickup should be available
    And waiver priority should not apply
    And first-come-first-served should apply

  @free-agents @post-waiver
  Scenario: Track waiver-to-free-agent transition
    Given players clear waivers
    When transitioning to free agent
    Then the transition should be logged
    And availability should update
    And owners should be notified optionally

  @free-agents @roster-requirements
  Scenario: Validate roster spot for free agent
    Given a free agent pickup is attempted
    When validating the transaction
    Then roster space should be verified
    And position limits should be checked
    And errors should block if invalid

  @free-agents @roster-requirements
  Scenario: Suggest drops for free agent add
    Given roster is full
    When viewing add options
    Then droppable players should be suggested
    And drop recommendations should be made
    And one-click add/drop should be available

  # ==================== Waiver Wire Display ====================

  @display @available-players
  Scenario: Display available players list
    Given players are on waivers
    When viewing the waiver wire
    Then available players should be listed
    And waiver status should be shown
    And add buttons should be accessible

  @display @available-players
  Scenario: Show player waiver details
    Given a player is on waivers
    When viewing player details
    Then waiver clear time should be shown
    And current claims should be indicated
    And player stats should be accessible

  @display @filtering
  Scenario: Filter waiver wire by position
    Given the waiver wire is displayed
    When filtering by position
    Then only selected positions should show
    And filter should be toggleable
    And multiple positions should be selectable

  @display @filtering
  Scenario: Apply multiple filters
    Given filter options exist
    When applying multiple filters
    Then filters should stack
    And results should narrow
    And clear all option should be available

  @display @sorting
  Scenario: Sort waiver wire by stats
    Given players have various stats
    When sorting by a stat
    Then players should reorder by that stat
    And sort direction should be toggleable
    And current sort should be indicated

  @display @sorting
  Scenario: Sort by multiple criteria
    Given multiple sort options exist
    When applying secondary sort
    Then primary sort should apply first
    And secondary should break ties
    And sort order should be clear

  @display @ownership
  Scenario: Display ownership percentages
    Given ownership data is available
    When viewing the waiver wire
    Then ownership percentage should show
    And trending ownership should be highlighted
    And league-specific ownership should be noted

  @display @ownership
  Scenario: Filter by ownership status
    Given ownership filter is available
    When filtering by ownership
    Then options should include
      | ownership_filter    | description                |
      | unowned             | 0% ownership               |
      | low_owned           | under 25% owned            |
      | trending_up         | increasing ownership       |
      | widely_available    | under 50% owned            |

  # ==================== Waiver Notifications ====================

  @notifications @claim-results
  Scenario: Send claim results alerts
    Given claims have been processed
    When results are available
    Then owners should be notified
    And successful claims should be highlighted
    And failed claims should be explained

  @notifications @claim-results
  Scenario: Configure result notification preferences
    Given notification settings are available
    When configuring preferences
    Then channels should be selectable
      | channel             | configurable               |
      | email               | yes                        |
      | push                | yes                        |
      | in_app              | always on                  |
      | sms                 | if available               |

  @notifications @outbid
  Scenario: Notify when outbid on FAAB claim
    Given FAAB bidding occurred
    When an owner is outbid
    Then they should be notified
    And the winning bid should be revealed
    And rebid option should be offered

  @notifications @outbid
  Scenario: Show outbid details
    Given an outbid notification is received
    When viewing details
    Then winning bid amount should show
    And winner should be identified
    And player status should be updated

  @notifications @processing-reminders
  Scenario: Send processing reminders
    Given processing time approaches
    When reminder threshold is reached
    Then owners with no claims should be reminded
    And upcoming deadline should be emphasized
    And quick action links should be included

  @notifications @processing-reminders
  Scenario: Configure reminder timing
    Given reminder settings exist
    When configuring timing
    Then options should include
      | reminder_timing     | before_processing          |
      | early               | 24 hours                   |
      | standard            | 4 hours                    |
      | last_minute         | 1 hour                     |

  @notifications @budget-warnings
  Scenario: Warn of low FAAB budget
    Given FAAB is enabled
    When budget falls below threshold
    Then a warning should be sent
    And remaining budget should be shown
    And spending advice should be offered

  @notifications @budget-warnings
  Scenario: Configure budget warning thresholds
    Given warning settings are available
    When setting thresholds
    Then percentage thresholds should be configurable
    And dollar amount thresholds should be available
    And notification frequency should be settable

  # ==================== Waiver Rules Engine ====================

  @rules @roster-validation
  Scenario: Validate roster legality for claims
    Given a claim is submitted
    When validating roster legality
    Then post-claim roster should be checked
    And all rules should be evaluated
    And violations should block the claim

  @rules @roster-validation
  Scenario: Display roster validation errors
    Given validation fails
    When displaying errors
    Then specific violations should be listed
    And correction suggestions should be made
    And alternative actions should be offered

  @rules @position-limits
  Scenario: Enforce position limits
    Given position limits are configured
    When a claim would violate limits
    Then the claim should be blocked
    And the limit should be displayed
    And a drop should be required

  @rules @position-limits
  Scenario: Configure position limits
    Given position settings are available
    When configuring limits
    Then max per position should be settable
    And min per position should be settable
    And flex positions should be considered

  @rules @ir-eligibility
  Scenario: Check IR eligibility for claims
    Given IR rules exist
    When a claim affects IR
    Then IR eligibility should be verified
    And ineligible moves should be blocked
    And IR spot requirements should be checked

  @rules @ir-eligibility
  Scenario: Handle IR-to-active transitions
    Given a player returns from IR
    When processing related claims
    Then IR spot should be vacated
    And roster space should be verified
    And contingent claims should adjust

  @rules @transaction-limits
  Scenario: Enforce transaction limits
    Given weekly/season limits exist
    When a claim would exceed limits
    Then the claim should be blocked
    And current count should be displayed
    And limit reset timing should be shown

  @rules @transaction-limits
  Scenario: Track transaction counts
    Given transactions are limited
    When viewing transaction status
    Then current count should be displayed
    And remaining transactions should show
    And historical usage should be visible

  # ==================== Waiver History ====================

  @history @transaction-log
  Scenario: View transaction log
    Given transactions have occurred
    When viewing the log
    Then all transactions should be listed
    And details should be accessible
    And filtering should be available

  @history @transaction-log
  Scenario: Filter transaction history
    Given extensive history exists
    When filtering transactions
    Then filters should include
      | filter_type         | options                    |
      | team                | specific team              |
      | transaction_type    | add, drop, claim, trade    |
      | date_range          | from/to dates              |
      | player              | specific player            |

  @history @claim-history
  Scenario: View claim history
    Given waiver claims have occurred
    When viewing claim history
    Then all claims should be listed
    And successful and failed should be shown
    And bid amounts should be visible for FAAB

  @history @claim-history
  Scenario: Analyze claim success rate
    Given claim history exists
    When analyzing success rates
    Then win percentage should be calculated
    And average bid should be shown
    And trends should be identified

  @history @faab-spending
  Scenario: Track FAAB spending history
    Given FAAB transactions occurred
    When viewing spending history
    Then all bids should be logged
    And running balance should show
    And spending patterns should be visible

  @history @faab-spending
  Scenario: Compare FAAB spending across league
    Given all teams have FAAB history
    When comparing spending
    Then team-by-team comparison should show
    And spending efficiency should be calculated
    And remaining budgets should be ranked

  @history @trend-analysis
  Scenario: Analyze waiver trends
    Given historical data exists
    When analyzing trends
    Then popular pickups should be identified
    And successful strategies should be noted
    And league patterns should be shown

  @history @trend-analysis
  Scenario: View league-wide waiver activity
    Given league activity is tracked
    When viewing activity
    Then busiest waiver periods should show
    And most active owners should be ranked
    And transaction volume should be charted

  # ==================== Waiver Interface ====================

  @interface @claim-builder
  Scenario: Use waiver claim builder
    Given the claim builder is accessed
    When building a claim
    Then player selection should be intuitive
    And drop selection should be streamlined
    And FAAB entry should be simple

  @interface @claim-builder
  Scenario: Preview claim before submission
    Given a claim is constructed
    When previewing the claim
    Then all details should be shown
    And roster impact should be displayed
    And confirmation should be required

  @interface @mobile-waivers
  Scenario: Submit claims from mobile
    Given mobile access is available
    When using mobile waiver interface
    Then all features should be accessible
    And touch interactions should work
    And responsive design should apply

  @interface @mobile-waivers
  Scenario: Receive mobile waiver notifications
    Given mobile notifications are enabled
    When waiver events occur
    Then push notifications should arrive
    And quick actions should be available
    And deep linking should work

  @interface @quick-claims
  Scenario: Use quick claim feature
    Given quick claims are enabled
    When viewing a player
    Then one-click claim should be available
    And default settings should apply
    And confirmation should be optional

  @interface @quick-claims
  Scenario: Configure quick claim defaults
    Given quick claim settings exist
    When configuring defaults
    Then default FAAB bid should be settable
    And default drop should be configurable
    And confirmation preference should be saved

  @interface @batch-claims
  Scenario: Submit batch claims
    Given multiple claims are desired
    When using batch claim feature
    Then multiple players should be selectable
    And priority ordering should be set
    And all claims should submit together

  @interface @batch-claims
  Scenario: Manage batch claim order
    Given batch claims are submitted
    When managing the order
    Then drag-and-drop should work
    And priority should auto-update
    And changes should save immediately
