@waiver-wire @free-agency
Feature: Waiver Wire
  As a fantasy football manager
  I want to claim players from the waiver wire
  So that I can improve my roster with available free agents

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the waiver system is configured

  # ============================================================================
  # WAIVER PRIORITY ORDERING
  # ============================================================================

  @happy-path @priority
  Scenario: View current waiver priority order
    Given the league uses "reverse standings" waiver priority
    And the current standings are:
      | Team              | Wins | Losses | Waiver Priority |
      | Last Place Larry  | 2    | 10     | 1               |
      | Struggling Steve  | 4    | 8      | 2               |
      | Average Andy      | 6    | 6      | 3               |
      | Winning Wendy     | 10   | 2      | 4               |
    When I view the waiver priority order
    Then I should see "Last Place Larry" with priority 1
    And I should see "Winning Wendy" with priority 4

  @happy-path @priority
  Scenario: Waiver priority resets weekly based on standings
    Given the league uses "rolling" waiver priority
    And "Team Alpha" had priority 3 last week
    And "Team Alpha" won their matchup this week
    When the weekly waiver priority is recalculated
    Then "Team Alpha" should have a lower priority than teams that lost

  @happy-path @priority
  Scenario: Waiver priority moves to last after successful claim
    Given the league uses "move to last" waiver priority
    And "Team Alpha" has waiver priority 1
    And "Team Beta" has waiver priority 2
    When "Team Alpha" successfully claims a player
    Then "Team Alpha" should have the lowest waiver priority
    And "Team Beta" should have waiver priority 1

  @happy-path @priority
  Scenario: Waiver priority based on FAAB remaining
    Given the league uses "FAAB tiebreaker" waiver priority
    And "Team Alpha" has $50 FAAB remaining
    And "Team Beta" has $75 FAAB remaining
    When two claims have equal bids
    Then "Team Beta" should win the tiebreaker due to higher remaining FAAB

  @happy-path @priority
  Scenario: Commissioner manually adjusts waiver priority
    Given I am the league commissioner
    And "Team Alpha" has waiver priority 5
    When I manually set "Team Alpha" waiver priority to 1
    Then "Team Alpha" should have waiver priority 1
    And all other team priorities should shift accordingly
    And an audit log entry should be created

  # ============================================================================
  # CLAIM SUBMISSION
  # ============================================================================

  @happy-path @claim-submission
  Scenario: Submit a waiver claim for a free agent
    Given player "Patrick Mahomes" is on waivers
    And I have an open roster spot
    When I submit a waiver claim for "Patrick Mahomes"
    Then the claim should be recorded with my waiver priority
    And I should see a confirmation message
    And "Patrick Mahomes" should show as "Claim Pending" in my view

  @happy-path @claim-submission
  Scenario: Submit a waiver claim with a player to drop
    Given player "Josh Allen" is on waivers
    And I have no open roster spots
    And I have player "Backup QB" on my roster
    When I submit a waiver claim for "Josh Allen" dropping "Backup QB"
    Then the claim should include the drop transaction
    And "Josh Allen" should show as "Claim Pending"
    And "Backup QB" should show as "Conditional Drop"

  @happy-path @claim-submission
  Scenario: Submit multiple waiver claims with priority ranking
    Given multiple players are on waivers:
      | Player Name      |
      | Patrick Mahomes  |
      | Josh Allen       |
      | Lamar Jackson    |
    When I submit prioritized waiver claims:
      | Priority | Player          | Drop Player |
      | 1        | Patrick Mahomes | Backup QB   |
      | 2        | Josh Allen      | Backup QB   |
      | 3        | Lamar Jackson   | Backup QB   |
    Then my claims should be processed in priority order
    And only one claim should succeed if using the same drop player

  @happy-path @claim-submission
  Scenario: Reorder pending waiver claims
    Given I have pending waiver claims:
      | Priority | Player          |
      | 1        | Patrick Mahomes |
      | 2        | Josh Allen      |
    When I reorder my claims to put "Josh Allen" first
    Then "Josh Allen" should have priority 1
    And "Patrick Mahomes" should have priority 2

  @happy-path @claim-submission
  Scenario: Cancel a pending waiver claim
    Given I have a pending claim for "Patrick Mahomes"
    When I cancel the waiver claim
    Then the claim should be removed from the queue
    And "Patrick Mahomes" should no longer show as "Claim Pending"

  @validation @claim-submission
  Scenario: Cannot submit claim for player already rostered
    Given player "Patrick Mahomes" is on "Team Beta" roster
    When I attempt to submit a waiver claim for "Patrick Mahomes"
    Then I should see an error "Player is not available on waivers"
    And no claim should be recorded

  @validation @claim-submission
  Scenario: Cannot submit duplicate claim for same player
    Given I have a pending claim for "Patrick Mahomes"
    When I attempt to submit another claim for "Patrick Mahomes"
    Then I should see an error "You already have a pending claim for this player"

  # ============================================================================
  # PROCESSING WINDOWS
  # ============================================================================

  @happy-path @processing
  Scenario: Waiver claims process at scheduled time
    Given the waiver processing time is "Wednesday 12:00 AM EST"
    And pending claims exist in the queue
    When the processing time is reached
    Then all pending claims should be processed
    And successful claims should complete roster transactions
    And claim results should be recorded

  @happy-path @processing
  Scenario: View waiver processing countdown
    Given the next waiver processing is in 18 hours
    When I view the waiver wire page
    Then I should see "Waivers Process In: 18:00:00"
    And the countdown should update in real-time

  @happy-path @processing
  Scenario: Multiple processing windows per week
    Given the league has waiver processing on:
      | Day       | Time        |
      | Wednesday | 12:00 AM    |
      | Saturday  | 12:00 AM    |
    And a claim is submitted on Thursday
    When I view my pending claims
    Then I should see "Processes: Saturday 12:00 AM"

  @happy-path @processing
  Scenario: Claims submitted after cutoff wait for next window
    Given the waiver cutoff is 2 hours before processing
    And the next processing is in 1 hour
    When I submit a waiver claim
    Then the claim should be queued for the following processing window
    And I should see a message about the late submission

  @edge-case @processing
  Scenario: No claims to process in window
    Given no pending waiver claims exist
    When the processing time is reached
    Then the system should log "No claims to process"
    And the waiver period should advance to next window

  # ============================================================================
  # FAAB BIDDING
  # ============================================================================

  @happy-path @faab
  Scenario: Submit FAAB bid for a player
    Given the league uses FAAB bidding
    And I have $100 FAAB budget remaining
    And player "Patrick Mahomes" is on waivers
    When I submit a bid of $25 for "Patrick Mahomes"
    Then my FAAB claim should be recorded
    And I should see "$75 remaining budget" after successful claim

  @happy-path @faab
  Scenario: Highest FAAB bid wins the player
    Given the league uses FAAB bidding
    And pending bids exist for "Patrick Mahomes":
      | Team       | Bid Amount |
      | Team Alpha | $25        |
      | Team Beta  | $40        |
      | Team Gamma | $30        |
    When waivers are processed
    Then "Team Beta" should win "Patrick Mahomes"
    And "Team Beta" FAAB should be reduced by $40
    And losing bidders should retain their FAAB

  @happy-path @faab
  Scenario: Submit $0 FAAB bid
    Given the league allows $0 bids
    And player "Backup RB" is on waivers
    When I submit a bid of $0 for "Backup RB"
    Then my $0 claim should be recorded
    And I should win if no other bids are placed

  @happy-path @faab
  Scenario: Modify FAAB bid before processing
    Given I have a pending bid of $25 for "Patrick Mahomes"
    When I modify my bid to $35
    Then my updated bid should be $35
    And the previous bid amount should be replaced

  @validation @faab
  Scenario: Cannot bid more than remaining FAAB
    Given I have $50 FAAB budget remaining
    When I attempt to bid $75 for "Patrick Mahomes"
    Then I should see an error "Insufficient FAAB budget"
    And my pending claims should show total committed FAAB

  @validation @faab
  Scenario: Total pending bids cannot exceed FAAB budget
    Given I have $50 FAAB budget remaining
    And I have a pending bid of $30
    When I attempt to add another bid of $30
    Then I should see an error "Total bids exceed available budget"

  @happy-path @faab
  Scenario: FAAB tiebreaker goes to waiver priority
    Given pending bids exist for "Patrick Mahomes":
      | Team       | Bid Amount | Waiver Priority |
      | Team Alpha | $25        | 3               |
      | Team Beta  | $25        | 1               |
    When waivers are processed
    Then "Team Beta" should win due to higher waiver priority

  @happy-path @faab
  Scenario: View FAAB transaction history
    Given my team has made FAAB transactions this season
    When I view my FAAB history
    Then I should see all past bids with:
      | Player Acquired | Amount Paid | Date       |
      | Josh Allen      | $35         | Week 3     |
      | Derrick Henry   | $20         | Week 5     |
    And I should see my remaining budget

  # ============================================================================
  # RESULTS NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive notification for successful waiver claim
    Given I have a pending claim for "Patrick Mahomes"
    When waivers process and my claim succeeds
    Then I should receive a notification "Waiver Claim Successful: Patrick Mahomes"
    And the notification should include transaction details

  @happy-path @notifications
  Scenario: Receive notification for failed waiver claim
    Given I have a pending claim for "Patrick Mahomes"
    And another team has higher waiver priority
    When waivers process and my claim fails
    Then I should receive a notification "Waiver Claim Failed: Patrick Mahomes"
    And the notification should explain "Claimed by higher priority team"

  @happy-path @notifications
  Scenario: Receive email digest of waiver results
    Given I have email notifications enabled
    And I have multiple pending claims
    When waivers are processed
    Then I should receive an email with all claim results
    And the email should show my updated roster

  @happy-path @notifications
  Scenario: Push notification for waiver results
    Given I have push notifications enabled on mobile
    When my waiver claim is processed
    Then I should receive a push notification with the result

  @happy-path @notifications
  Scenario: View league-wide waiver transaction log
    When I view the league transaction log
    Then I should see all successful waiver claims
    And each entry should show:
      | Team | Player Added | Player Dropped | FAAB Spent | Date |

  # ============================================================================
  # CLAIM CONFLICTS
  # ============================================================================

  @happy-path @conflicts
  Scenario: Higher priority team wins conflicting claim
    Given "Team Alpha" has waiver priority 1
    And "Team Beta" has waiver priority 2
    And both teams have claims for "Patrick Mahomes"
    When waivers are processed
    Then "Team Alpha" should receive "Patrick Mahomes"
    And "Team Beta" claim should fail

  @happy-path @conflicts
  Scenario: Secondary claim processed after primary fails
    Given I have prioritized claims:
      | Priority | Player          |
      | 1        | Patrick Mahomes |
      | 2        | Josh Allen      |
    And my claim for "Patrick Mahomes" fails
    When waivers are processed
    Then my claim for "Josh Allen" should be processed
    And I should receive "Josh Allen" if available

  @edge-case @conflicts
  Scenario: Conditional drop becomes unavailable
    Given I have a claim for "Patrick Mahomes" dropping "Backup QB"
    And another team claims "Backup QB" via trade before processing
    When waivers are processed
    Then my claim should fail due to invalid drop
    And I should receive an error notification

  @edge-case @conflicts
  Scenario: Player becomes ineligible during waiver period
    Given I have a claim for "Patrick Mahomes"
    And "Patrick Mahomes" is placed on IR before processing
    When waivers are processed
    Then my claim should still process if IR slot available
    Or my claim should fail if no valid roster spot exists

  # ============================================================================
  # WAIVER SCHEDULES
  # ============================================================================

  @happy-path @schedules
  Scenario: Standard weekly waiver schedule
    Given the league uses "standard" waiver schedule
    When I view the waiver calendar
    Then I should see:
      | Period Start | Period End | Processing Time   |
      | Sunday       | Tuesday    | Wednesday 12:00 AM |

  @happy-path @schedules
  Scenario: Daily waiver processing schedule
    Given the league uses "daily" waiver processing
    When I view the waiver schedule
    Then I should see processing every day at the configured time

  @happy-path @schedules
  Scenario: Playoffs have different waiver schedule
    Given the season is in playoffs
    And playoff waiver processing is "daily"
    When I view the waiver schedule
    Then I should see the playoff waiver schedule
    And regular season schedule should not apply

  @happy-path @schedules
  Scenario: View waiver period blackout times
    Given games are scheduled for Thursday night
    When I view the waiver schedule
    Then I should see players locked during game times
    And I should see when those players become available

  # ============================================================================
  # PLAYER ELIGIBILITY
  # ============================================================================

  @happy-path @eligibility
  Scenario: Recently dropped player on waivers
    Given "Patrick Mahomes" was dropped by "Team Alpha"
    And the waiver period is 2 days
    When I view "Patrick Mahomes" status
    Then I should see "On Waivers until [date/time]"
    And I should be able to submit a claim

  @happy-path @eligibility
  Scenario: Player clears waivers becomes free agent
    Given "Backup QB" has been on waivers for 2 days
    And no claims were submitted
    When the waiver period expires
    Then "Backup QB" should become a free agent
    And I should be able to add without waiver claim

  @happy-path @eligibility
  Scenario: Player locked during game
    Given "Patrick Mahomes" game starts at 1:00 PM
    And the current time is 1:30 PM
    When I attempt to claim "Patrick Mahomes"
    Then I should see "Player locked - game in progress"
    And I should see when the player becomes available

  @validation @eligibility
  Scenario: Cannot claim player on injured reserve
    Given "Injured Player" is on NFL injured reserve
    And I have no IR slots available
    When I attempt to claim "Injured Player"
    Then I should see "Cannot claim - no IR slot available"

  @happy-path @eligibility
  Scenario: Claim IR-eligible player to IR slot
    Given "Injured Player" is on NFL injured reserve
    And I have an open IR slot
    When I submit a claim for "Injured Player" to IR
    Then the claim should be recorded for my IR slot

  # ============================================================================
  # ROSTER VALIDATION
  # ============================================================================

  @validation @roster
  Scenario: Validate roster spot available for claim
    Given my roster is:
      | Position | Players |
      | QB       | 2/2     |
      | RB       | 4/4     |
      | WR       | 4/4     |
    And "Patrick Mahomes" is a QB
    When I attempt to claim "Patrick Mahomes" without dropping
    Then I should see "No roster spot available for QB"

  @validation @roster
  Scenario: Validate position eligibility for claim
    Given I need a WR
    And "Patrick Mahomes" is QB only
    When I search for WR on waivers
    Then "Patrick Mahomes" should not appear in results

  @happy-path @roster
  Scenario: Claim player with multiple position eligibility
    Given "Cordarrelle Patterson" is RB/WR eligible
    And I have an open WR spot but no RB spots
    When I claim "Cordarrelle Patterson"
    Then I should be able to add him to my WR slot

  @validation @roster
  Scenario: Validate drop player is not in starting lineup for current week
    Given "Starting RB" is in my starting lineup for this week
    And games have already started
    When I attempt to submit a claim dropping "Starting RB"
    Then I should see "Cannot drop player in active lineup"

  @happy-path @roster
  Scenario: Preview roster after waiver claim
    Given I am submitting a claim for "Patrick Mahomes"
    When I view the roster preview
    Then I should see my projected roster with "Patrick Mahomes"
    And I should see any position conflicts highlighted

  # ============================================================================
  # CLAIM HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View my waiver claim history
    When I view my waiver history
    Then I should see all my past claims with:
      | Player          | Result    | Date    | FAAB   |
      | Patrick Mahomes | Won       | Week 3  | $35    |
      | Josh Allen      | Lost      | Week 4  | $25    |
      | Lamar Jackson   | Cancelled | Week 5  | -      |

  @happy-path @history
  Scenario: View league waiver claim history
    When I view the league waiver history
    Then I should see all successful claims for the season
    And I should be able to filter by team or week

  @happy-path @history
  Scenario: Export waiver history to CSV
    Given I am the league commissioner
    When I export waiver history
    Then I should receive a CSV file with all transactions
    And the file should include FAAB amounts if applicable

  @happy-path @history
  Scenario: View waiver activity trends
    When I view waiver analytics
    Then I should see most claimed players
    And I should see most active teams
    And I should see average FAAB spending

  # ============================================================================
  # CONTINUOUS WAIVERS
  # ============================================================================

  @happy-path @continuous
  Scenario: Continuous waivers process claims immediately
    Given the league uses "continuous" waivers
    And no waiver period is required
    When I submit a claim for "Patrick Mahomes"
    Then the claim should process immediately
    And "Patrick Mahomes" should be on my roster

  @happy-path @continuous
  Scenario: Continuous waivers with priority ordering
    Given the league uses "continuous" waivers with priority
    When two managers submit claims simultaneously
    Then the higher priority manager should win
    And the claim should process in order received for ties

  @happy-path @continuous
  Scenario: Continuous waivers blocked during games
    Given the league uses "continuous" waivers
    And "Patrick Mahomes" game is in progress
    When I attempt to claim "Patrick Mahomes"
    Then I should see "Player locked until game ends"

  # ============================================================================
  # GAME-TIME WAIVERS
  # ============================================================================

  @happy-path @game-time
  Scenario: Player goes on waivers at game time
    Given "Patrick Mahomes" is a free agent
    And his game starts at 1:00 PM
    When the game kicks off
    Then "Patrick Mahomes" should move to waivers
    And he should remain on waivers until next processing

  @happy-path @game-time
  Scenario: Dropped player immediately on waivers during game window
    Given games are currently in progress
    When I drop "Backup QB"
    Then "Backup QB" should go on waivers immediately
    And the waiver period should start from drop time

  @happy-path @game-time
  Scenario: Free agent pickup blocked near game time
    Given "Patrick Mahomes" game starts in 30 minutes
    And the roster lock period is 1 hour before games
    When I attempt to add "Patrick Mahomes"
    Then I should see "Player locked - game starting soon"

  @edge-case @game-time
  Scenario: Postponed game affects waiver status
    Given "Patrick Mahomes" was locked for a 1:00 PM game
    And the game is postponed to Monday
    When the postponement is announced
    Then "Patrick Mahomes" should become available
    And he should lock again before the rescheduled game

  # ============================================================================
  # WAIVER SETTINGS CONFIGURATION
  # ============================================================================

  @commissioner @settings
  Scenario: Configure waiver type
    Given I am the league commissioner
    When I configure waiver settings
    Then I should be able to choose:
      | Waiver Type        |
      | Standard           |
      | FAAB               |
      | Continuous         |
      | None (Free Agency) |

  @commissioner @settings
  Scenario: Configure waiver processing schedule
    Given I am the league commissioner
    When I set waiver processing to "Wednesday and Saturday at 10:00 AM"
    Then waivers should process on those days
    And all league members should see the updated schedule

  @commissioner @settings
  Scenario: Configure waiver priority system
    Given I am the league commissioner
    When I configure priority settings
    Then I should be able to choose:
      | Priority Type           |
      | Reverse Standings       |
      | Rolling (Move to Last)  |
      | FAAB Only               |
      | Weekly Reset            |

  @commissioner @settings
  Scenario: Configure FAAB budget
    Given I am the league commissioner
    And the league uses FAAB
    When I set the season FAAB budget to $200
    Then all teams should have $200 FAAB to start
    And the setting should apply to new seasons

  @commissioner @settings
  Scenario: Configure waiver period duration
    Given I am the league commissioner
    When I set the waiver period to 1 day
    Then dropped players should be on waivers for 1 day
    And the change should apply to future drops

  @commissioner @settings
  Scenario: Configure minimum FAAB bid
    Given I am the league commissioner
    When I set minimum FAAB bid to $1
    Then $0 bids should not be allowed
    And managers should see the minimum bid requirement

  @commissioner @settings
  Scenario: Enable/disable blind bidding
    Given I am the league commissioner
    When I enable blind FAAB bidding
    Then managers should not see other teams' bids
    And bid amounts should only be revealed after processing

  @commissioner @settings
  Scenario: Configure trade deadline impact on waivers
    Given the trade deadline has passed
    When I view waiver settings
    Then I should see option to restrict waiver activity post-deadline
    And eliminated teams may have different waiver rules

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Submit waiver claim on mobile device
    Given I am using a mobile device
    When I navigate to the waiver wire
    Then I should see a mobile-optimized claim interface
    And I should be able to submit claims with touch gestures

  @mobile @responsive
  Scenario: Reorder waiver priorities on mobile
    Given I am using a mobile device
    And I have multiple pending claims
    When I drag to reorder my claim priorities
    Then the priorities should update smoothly
    And I should receive haptic feedback on reorder

  @mobile @responsive
  Scenario: View waiver countdown on mobile
    Given I am using a mobile device
    When I view the waiver wire
    Then I should see the processing countdown prominently displayed
    And I should be able to set a reminder notification

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for waiver wire
    Given I am using a screen reader
    When I navigate the waiver wire
    Then all interactive elements should be labeled
    And waiver status should be announced
    And claim submission should provide audio confirmation

  @accessibility @a11y
  Scenario: Keyboard navigation for waiver claims
    Given I am using keyboard navigation
    When I submit a waiver claim
    Then I should be able to complete the flow using only keyboard
    And focus should be managed appropriately

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle waiver processing failure
    Given waivers are being processed
    And a system error occurs mid-processing
    When the error is detected
    Then processing should rollback incomplete transactions
    And commissioners should be notified
    And processing should retry automatically

  @error @resilience
  Scenario: Handle network error during claim submission
    Given I am submitting a waiver claim
    And network connectivity is lost
    When the submission fails
    Then I should see "Unable to submit claim - please try again"
    And my draft claim should be preserved locally

  @error @resilience
  Scenario: Handle concurrent claim modifications
    Given I have a pending claim open in two browser tabs
    When I modify the claim in both tabs simultaneously
    Then one modification should succeed
    And the other should show "Claim was modified - please refresh"

  @error @validation
  Scenario: Invalid FAAB amount format
    Given I am submitting a FAAB bid
    When I enter "twenty-five" as the bid amount
    Then I should see "Please enter a valid number"
    And the submit button should be disabled

  @error @validation
  Scenario: Waiver claim deadline passed
    Given the waiver processing is imminent
    When I attempt to submit a claim after the cutoff
    Then I should see "Waiver deadline has passed"
    And I should see when the next waiver period opens
