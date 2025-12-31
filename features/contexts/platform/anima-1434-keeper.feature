@keeper @platform
Feature: Keeper
  As a fantasy football league
  I need comprehensive keeper functionality
  So that owners can retain players across seasons

  Background:
    Given the keeper system is operational
    And keeper rules are configured for the league

  # ==================== Keeper Selection ====================

  @keeper-selection @select-keepers
  Scenario: Select players as keepers
    Given a team owner has eligible players from last season
    When they access the keeper selection page
    Then they should see their roster with keeper eligibility
    And they can select players to keep

  @keeper-selection @select-keepers
  Scenario: Select multiple keepers within limits
    Given a league allows 3 keepers per team
    And an owner has 5 eligible players
    When they select 3 players as keepers
    Then the selections should be accepted
    And remaining eligible players should be released to the draft pool

  @keeper-selection @select-keepers
  Scenario: Prevent exceeding keeper limits
    Given a league allows 2 keepers per team
    When an owner attempts to select 3 keepers
    Then the third selection should be rejected
    And an error message should indicate the limit

  @keeper-selection @keeper-deadline
  Scenario: Display keeper selection deadline
    Given keeper selections are open
    When an owner views the keeper page
    Then the deadline for selections should be displayed
    And countdown timer should show remaining time

  @keeper-selection @keeper-deadline
  Scenario: Lock selections after deadline
    Given the keeper deadline has passed
    When an owner attempts to modify keepers
    Then changes should be prevented
    And a message should indicate the deadline has passed

  @keeper-selection @keeper-eligibility
  Scenario: Display player eligibility status
    Given an owner is viewing their roster
    When keeper selection is active
    Then each player should show eligibility status
      | status      | description                    |
      | eligible    | Can be kept                    |
      | ineligible  | Cannot be kept (rule violation)|
      | expiring    | Final year of keeper status    |
      | new         | First year keeper eligible     |

  @keeper-selection @keeper-limits
  Scenario: Enforce position-based keeper limits
    Given a league has position limits for keepers
      | position | limit |
      | QB       | 1     |
      | RB       | 2     |
      | WR       | 2     |
      | TE       | 1     |
    When an owner selects keepers
    Then position limits should be enforced

  @keeper-selection @keeper-limits
  Scenario: Allow flexible keeper limits
    Given a league allows any position combination
    When an owner selects 3 WRs as keepers
    Then the selection should be accepted
    And no position restriction errors should occur

  @keeper-selection @keeper-confirmation
  Scenario: Confirm keeper selections
    Given an owner has selected their keepers
    When they submit their selections
    Then a confirmation dialog should appear
    And they must confirm before selections are finalized

  @keeper-selection @keeper-confirmation
  Scenario: Receive confirmation notification
    Given an owner confirms keeper selections
    When selections are finalized
    Then they should receive a confirmation email
    And the league should be notified of the submission

  # ==================== Keeper Rules ====================

  @keeper-rules @keeper-cost
  Scenario: Display keeper cost for each player
    Given keepers have associated costs
    When an owner views eligible players
    Then the cost to keep each player should be displayed
      | player        | acquired_round | keeper_cost |
      | Patrick Mahomes | 3             | Round 2     |
      | Josh Allen      | 5             | Round 4     |
      | Undrafted FA    | N/A           | Round 10    |

  @keeper-rules @keeper-cost
  Scenario: Calculate keeper cost based on acquisition
    Given a player was acquired through different methods
    When keeper cost is calculated
    Then the cost should reflect acquisition method
      | acquisition_method | cost_calculation           |
      | draft              | draft round minus 1        |
      | free_agent         | last round of draft        |
      | trade              | original draft round minus 1|
      | waiver             | designated waiver round    |

  @keeper-rules @round-penalty
  Scenario: Apply round penalty for consecutive years
    Given a player was kept in previous seasons
    When calculating this year's cost
    Then round penalty should be applied
      | years_kept | penalty |
      | 1          | 1 round |
      | 2          | 2 rounds|
      | 3          | 3 rounds|

  @keeper-rules @round-penalty
  Scenario: Cap keeper cost at first round
    Given a player's keeper cost with penalties exceeds round 1
    When the cost is calculated
    Then the cost should be capped at round 1
    And the player remains keepable

  @keeper-rules @keeper-duration
  Scenario: Limit keeper duration
    Given a league limits keepers to 3 years
    When a player has been kept for 3 years
    Then they should become ineligible for next season
    And they must enter the draft pool

  @keeper-rules @keeper-duration
  Scenario: Track keeper years remaining
    Given a player is selected as keeper
    When viewing keeper details
    Then years remaining should be displayed
    And expiration year should be shown

  @keeper-rules @keeper-restrictions
  Scenario: Restrict first-round picks from keeper eligibility
    Given a league prohibits keeping first-round picks
    When an owner views their first-round pick
    Then the player should be marked ineligible
    And restriction reason should be displayed

  @keeper-rules @keeper-restrictions
  Scenario: Restrict players acquired after trade deadline
    Given a player was acquired after the keeper trade deadline
    When evaluating keeper eligibility
    Then the player should be ineligible for keeping
    And acquisition date should be shown

  @keeper-rules @keeper-exceptions
  Scenario: Allow commissioner exceptions
    Given a player is normally ineligible
    When the commissioner grants an exception
    Then the player should become keeper eligible
    And the exception should be documented

  @keeper-rules @keeper-exceptions
  Scenario: Handle injury exceptions
    Given a keeper player suffered a season-ending injury
    When the owner requests an exception
    Then they may receive a replacement keeper slot
    And the original keeper rules are preserved

  # ==================== Keeper Management ====================

  @keeper-management @view-keepers
  Scenario: View current keeper selections
    Given an owner has selected keepers
    When they access the keeper management page
    Then all selected keepers should be displayed
    And keeper details should be shown
      | detail          | displayed |
      | player_name     | yes       |
      | position        | yes       |
      | keeper_cost     | yes       |
      | years_remaining | yes       |

  @keeper-management @view-keepers
  Scenario: View league-wide keeper selections
    Given keeper selections are public
    When viewing the league keeper summary
    Then all teams' keepers should be visible
    And draft implications should be shown

  @keeper-management @modify-keepers
  Scenario: Modify keeper selection before deadline
    Given the keeper deadline has not passed
    When an owner changes a keeper selection
    Then the modification should be saved
    And previous selection should be released

  @keeper-management @modify-keepers
  Scenario: Swap keepers within selection
    Given an owner has selected their keepers
    When they want to swap one keeper for another
    Then the swap should be processed atomically
    And both changes should be recorded

  @keeper-management @release-keeper
  Scenario: Release a keeper to draft pool
    Given an owner has a selected keeper
    When they choose to release the player
    Then the player should return to the draft pool
    And the keeper slot should become available

  @keeper-management @release-keeper
  Scenario: Confirm keeper release
    Given an owner is releasing a keeper
    When they initiate the release
    Then a confirmation should be required
    And the consequences should be displayed

  @keeper-management @keeper-history
  Scenario: View keeper history for a player
    Given a player has been kept multiple times
    When viewing the player's keeper history
    Then all keeper records should be displayed
      | season | team           | cost    |
      | 2024   | Thunder Hawks  | Round 4 |
      | 2023   | Thunder Hawks  | Round 5 |
      | 2022   | Storm Chasers  | Round 6 |

  @keeper-management @keeper-history
  Scenario: View team keeper history
    Given a team has kept players over multiple seasons
    When viewing the team's keeper history
    Then all historical keepers should be listed
    And outcomes should be tracked

  @keeper-management @keeper-notes
  Scenario: Add notes to keeper selection
    Given an owner is selecting a keeper
    When they add a note to the selection
    Then the note should be saved with the keeper
    And visible in keeper management

  @keeper-management @keeper-notes
  Scenario: View commissioner notes on keepers
    Given the commissioner has added notes about keeper rules
    When an owner views keeper information
    Then commissioner notes should be displayed
    And rule clarifications should be visible

  # ==================== Draft Pick Cost ====================

  @draft-pick-cost @pick-sacrifice
  Scenario: Sacrifice draft pick for keeper
    Given a keeper costs a 3rd round pick
    When the owner confirms the keeper
    Then their 3rd round pick should be forfeited
    And draft board should reflect the sacrifice

  @draft-pick-cost @pick-sacrifice
  Scenario: Handle multiple keepers in same round
    Given two keepers would both cost a 4th round pick
    When the owner selects both
    Then one should cost 4th round
    And the other should escalate to 3rd round

  @draft-pick-cost @round-escalation
  Scenario: Escalate keeper cost for conflicts
    Given a keeper conflicts with another keeper's round
    When resolving the conflict
    Then the later-selected keeper should escalate
    And the owner should be notified of the change

  @draft-pick-cost @round-escalation
  Scenario: Prevent escalation beyond first round
    Given keeper escalation would exceed round 1
    When evaluating the keeper
    Then a warning should be displayed
    And alternative options should be suggested

  @draft-pick-cost @auction-value-increase
  Scenario: Calculate auction keeper cost
    Given a league uses auction draft format
    When a keeper's auction value is calculated
    Then the value should increase from acquisition price
      | acquisition_price | keeper_cost |
      | $5                | $10         |
      | $15               | $20         |
      | $30               | $35         |

  @draft-pick-cost @auction-value-increase
  Scenario: Cap auction keeper value
    Given a keeper's value would exceed salary cap percentage
    When the value is calculated
    Then it should be capped at the maximum allowed
    And the owner should be notified

  @draft-pick-cost @cost-calculation
  Scenario: Calculate total keeper cost impact
    Given an owner has selected multiple keepers
    When viewing the cost summary
    Then total draft capital used should be displayed
    And remaining draft picks should be shown

  @draft-pick-cost @cost-calculation
  Scenario: Compare keeper value to cost
    Given a keeper has an associated cost
    When evaluating the keeper decision
    Then projected value should be compared to cost
    And value surplus/deficit should be displayed

  @draft-pick-cost @value-tracking
  Scenario: Track keeper value over seasons
    Given a player has been kept multiple seasons
    When viewing keeper value history
    Then value at each keeper decision should be shown
    And ROI should be calculated

  @draft-pick-cost @value-tracking
  Scenario: Project future keeper value
    Given a keeper has years remaining
    When projecting future value
    Then estimated value should be calculated
    And cost trajectory should be displayed

  # ==================== Keeper Eligibility ====================

  @keeper-eligibility @eligible-players
  Scenario: Identify eligible players
    Given an owner's roster from last season
    When evaluating keeper eligibility
    Then players meeting all criteria should be eligible
      | criteria            | requirement              |
      | roster_status       | on final roster          |
      | acquisition_method  | valid acquisition        |
      | keeper_years        | within duration limit    |
      | round_restriction   | meets round requirements |

  @keeper-eligibility @eligible-players
  Scenario: Display eligibility reasons
    Given a player is keeper eligible
    When viewing eligibility details
    Then the reasons for eligibility should be shown
    And relevant rules should be referenced

  @keeper-eligibility @ineligible-players
  Scenario: Identify ineligible players
    Given certain players cannot be kept
    When viewing the roster
    Then ineligible players should be clearly marked
    And ineligibility reasons should be displayed

  @keeper-eligibility @ineligible-players
  Scenario: Explain ineligibility reasons
    Given a player is ineligible
    When viewing their status
    Then specific reasons should be provided
      | reason              | description                    |
      | first_round_pick    | First round picks not keepable |
      | max_years_reached   | Kept maximum allowed years     |
      | late_acquisition    | Acquired after deadline        |
      | dropped_player      | Was dropped during season      |

  @keeper-eligibility @eligibility-rules
  Scenario: Apply league-specific eligibility rules
    Given a league has custom eligibility rules
    When evaluating players
    Then custom rules should be applied
    And standard rules should be modified accordingly

  @keeper-eligibility @eligibility-rules
  Scenario: Handle rule conflicts
    Given multiple eligibility rules apply
    When a conflict exists
    Then the more restrictive rule should apply
    And the conflict should be documented

  @keeper-eligibility @waiver-keepers
  Scenario: Determine waiver wire keeper eligibility
    Given a player was acquired via waivers
    When evaluating keeper eligibility
    Then waiver-specific rules should apply
    And keeper cost should reflect waiver acquisition

  @keeper-eligibility @waiver-keepers
  Scenario: Set waiver keeper round cost
    Given a waiver acquisition is keeper eligible
    When calculating keeper cost
    Then the designated waiver round should be used
    And any penalties should be applied

  @keeper-eligibility @trade-keepers
  Scenario: Maintain keeper rights through trades
    Given a player with keeper rights is traded
    When the trade is completed
    Then keeper rights should transfer to new owner
    And original acquisition cost should be preserved

  @keeper-eligibility @trade-keepers
  Scenario: Track original keeper cost after trade
    Given a traded player has keeper eligibility
    When viewing keeper details
    Then original draft position should be shown
    And trade history should be available

  # ==================== Multi-Year Keepers ====================

  @multi-year-keepers @contract-length
  Scenario: Assign keeper contract length
    Given a player is selected as keeper
    When the contract is created
    Then a contract length should be assigned
      | contract_type | length   |
      | standard      | 1 year   |
      | extended      | 2-3 years|
      | franchise     | 1 year   |

  @multi-year-keepers @contract-length
  Scenario: Display contract years remaining
    Given a keeper has a multi-year contract
    When viewing keeper details
    Then years remaining should be displayed
    And contract expiration should be shown

  @multi-year-keepers @contract-extension
  Scenario: Extend keeper contract
    Given a keeper's contract is expiring
    When the owner requests an extension
    Then extension options should be presented
    And cost implications should be shown

  @multi-year-keepers @contract-extension
  Scenario: Calculate extension cost
    Given a contract extension is requested
    When calculating the cost
    Then the extension premium should be applied
    And future year costs should be displayed

  @multi-year-keepers @franchise-tags
  Scenario: Apply franchise tag to player
    Given a league allows franchise tags
    When an owner uses their franchise tag
    Then the player should be kept at premium cost
    And franchise tag should be consumed for the season

  @multi-year-keepers @franchise-tags
  Scenario: Limit franchise tag usage
    Given a player has been franchise tagged before
    When evaluating franchise tag eligibility
    Then tag limits should be enforced
      | times_tagged | eligibility  | cost_multiplier |
      | 0            | eligible     | 1.2x            |
      | 1            | eligible     | 1.44x           |
      | 2            | ineligible   | N/A             |

  @multi-year-keepers @long-term-keepers
  Scenario: Manage dynasty-style long-term keepers
    Given a dynasty league with extended keeper periods
    When managing long-term keepers
    Then multi-year commitments should be tracked
    And salary cap implications should be shown

  @multi-year-keepers @long-term-keepers
  Scenario: Project long-term keeper costs
    Given a keeper has a 3-year contract
    When viewing cost projections
    Then costs for each year should be displayed
    And total contract value should be calculated

  @multi-year-keepers @keeper-expiration
  Scenario: Handle keeper contract expiration
    Given a keeper's contract is expiring
    When the final year is reached
    Then the owner should be notified
    And options for the expiring player should be presented

  @multi-year-keepers @keeper-expiration
  Scenario: Return expired keeper to draft pool
    Given a keeper contract has expired
    When the new season begins
    Then the player should enter the draft pool
    And they should be available to all teams

  # ==================== Keeper Trades ====================

  @keeper-trades @trade-keepers
  Scenario: Trade a keeper-eligible player
    Given an owner wants to trade a keeper-eligible player
    When proposing the trade
    Then keeper rights should be included in the trade
    And receiving team should see keeper details

  @keeper-trades @trade-keepers
  Scenario: Display keeper information in trade
    Given a trade includes keeper-eligible players
    When reviewing the trade
    Then keeper costs should be displayed
    And years remaining should be shown

  @keeper-trades @trade-picks
  Scenario: Trade draft picks for keeper rights
    Given a team wants keeper rights to a player
    When proposing a trade with picks
    Then pick values should be compared to keeper value
    And trade fairness should be evaluated

  @keeper-trades @trade-picks
  Scenario: Include future picks in keeper trades
    Given keeper trades can include future picks
    When adding future picks to a trade
    Then the picks should be validated
    And future year implications should be shown

  @keeper-trades @keeper-rights
  Scenario: Transfer keeper rights in trade
    Given a trade is accepted
    When keeper rights are transferred
    Then the new owner should inherit all keeper details
    And the trade should be recorded in keeper history

  @keeper-trades @keeper-rights
  Scenario: Preserve keeper cost after trade
    Given a player with established keeper cost is traded
    When the trade completes
    Then the original keeper cost should be preserved
    And the new owner should pay that cost to keep

  @keeper-trades @future-considerations
  Scenario: Trade keeper rights for future considerations
    Given a team wants to acquire keeper rights
    When proposing a conditional trade
    Then future conditions should be specified
    And completion criteria should be clear

  @keeper-trades @future-considerations
  Scenario: Complete future consideration trade
    Given a conditional keeper trade was made
    When the condition is met
    Then the trade should automatically complete
    And both parties should be notified

  @keeper-trades @trade-validation
  Scenario: Validate keeper trade legality
    Given a keeper trade is proposed
    When validating the trade
    Then keeper rule compliance should be checked
    And illegal trades should be blocked

  @keeper-trades @trade-validation
  Scenario: Warn about keeper implications
    Given a trade affects keeper eligibility
    When reviewing the trade
    Then warnings should be displayed
    And keeper impact should be explained

  # ==================== Keeper Reports ====================

  @keeper-reports @keeper-summary
  Scenario: Generate team keeper summary
    Given an owner has keeper-eligible players
    When generating a keeper summary
    Then all options should be displayed
    And cost-benefit analysis should be included

  @keeper-reports @keeper-summary
  Scenario: Export keeper summary
    Given a keeper summary is generated
    When the owner exports the report
    Then it should be available in multiple formats
    And all relevant details should be included

  @keeper-reports @league-keepers
  Scenario: View league-wide keeper report
    Given multiple teams have made keeper selections
    When viewing the league keeper report
    Then all team keepers should be displayed
    And draft pool impact should be shown

  @keeper-reports @league-keepers
  Scenario: Compare keeper strategies across league
    Given all teams have made keeper decisions
    When analyzing league keepers
    Then strategy comparisons should be available
    And competitive implications should be shown

  @keeper-reports @keeper-values
  Scenario: Calculate keeper values
    Given players have keeper costs
    When calculating keeper values
    Then value over cost should be computed
    And rankings should be generated

  @keeper-reports @keeper-values
  Scenario: Compare keeper value to ADP
    Given keeper costs are established
    When comparing to average draft position
    Then value differential should be calculated
    And recommendations should be provided

  @keeper-reports @keeper-rankings
  Scenario: Generate keeper value rankings
    Given multiple keeper options exist
    When generating rankings
    Then players should be ranked by value
    And position scarcity should be considered

  @keeper-reports @keeper-rankings
  Scenario: Customize keeper ranking criteria
    Given ranking preferences vary
    When customizing rankings
    Then weighting factors should be adjustable
    And custom rankings should be generated

  @keeper-reports @keeper-analysis
  Scenario: Analyze keeper decisions
    Given historical keeper data exists
    When analyzing past decisions
    Then success rates should be calculated
    And lessons learned should be identified

  @keeper-reports @keeper-analysis
  Scenario: Project keeper impact on season
    Given keeper selections are made
    When projecting season impact
    Then team strength should be estimated
    And competitive analysis should be provided

  # ==================== Keeper Deadlines ====================

  @keeper-deadlines @deadline-notifications
  Scenario: Send deadline reminder notifications
    Given the keeper deadline is approaching
    When reminder period begins
    Then notifications should be sent
      | days_before | notification_type |
      | 7           | email             |
      | 3           | email + push      |
      | 1           | email + push + SMS|

  @keeper-deadlines @deadline-notifications
  Scenario: Notify uncommitted owners
    Given some owners haven't submitted keepers
    When the deadline approaches
    Then uncommitted owners should receive reminders
    And submission status should be tracked

  @keeper-deadlines @deadline-enforcement
  Scenario: Enforce keeper deadline strictly
    Given the keeper deadline has passed
    When an owner attempts to submit
    Then the submission should be rejected
    And the deadline policy should be displayed

  @keeper-deadlines @deadline-enforcement
  Scenario: Auto-submit default keepers at deadline
    Given an owner hasn't submitted by deadline
    When the deadline passes
    Then default keeper selections should be applied
    And the owner should be notified

  @keeper-deadlines @late-keeper-handling
  Scenario: Handle late keeper requests
    Given an owner missed the deadline
    When they request to submit late
    Then the request should go to the commissioner
    And late submission policy should apply

  @keeper-deadlines @late-keeper-handling
  Scenario: Apply late submission penalties
    Given late submissions are allowed with penalty
    When a late submission is accepted
    Then the appropriate penalty should be applied
    And the submission should be recorded

  @keeper-deadlines @deadline-extensions
  Scenario: Request deadline extension
    Given an owner needs more time
    When they request an extension
    Then the commissioner should be notified
    And extension options should be presented

  @keeper-deadlines @deadline-extensions
  Scenario: Grant league-wide deadline extension
    Given multiple owners need more time
    When the commissioner extends the deadline
    Then all owners should be notified
    And the new deadline should be enforced

  @keeper-deadlines @commissioner-override
  Scenario: Commissioner overrides deadline
    Given special circumstances exist
    When the commissioner overrides the deadline
    Then the action should be logged
    And affected owners should be notified

  @keeper-deadlines @commissioner-override
  Scenario: Commissioner modifies keeper selections
    Given an error in keeper selection occurred
    When the commissioner corrects the selection
    Then the change should be documented
    And all parties should be notified

  # ==================== Dynasty Features ====================

  @dynasty @dynasty-rosters
  Scenario: Manage dynasty roster
    Given a dynasty league with expanded rosters
    When managing the roster
    Then all roster spots should be visible
    And keeper implications should be clear

  @dynasty @dynasty-rosters
  Scenario: Configure dynasty roster limits
    Given dynasty leagues have different roster sizes
    When configuring roster limits
    Then expanded limits should be supported
      | roster_type    | size  |
      | active         | 25    |
      | taxi_squad     | 5     |
      | IR             | 3     |
      | total          | 33    |

  @dynasty @taxi-squad
  Scenario: Manage taxi squad players
    Given a dynasty league has taxi squad
    When assigning players to taxi squad
    Then eligibility rules should be enforced
    And taxi squad players should be keeper eligible

  @dynasty @taxi-squad
  Scenario: Promote player from taxi squad
    Given a player is on the taxi squad
    When promoting to active roster
    Then the promotion should be processed
    And roster limits should be verified

  @dynasty @ir-keepers
  Scenario: Keep players on injured reserve
    Given a player is on IR
    When evaluating keeper eligibility
    Then IR status should not affect eligibility
    And the player should be keepable

  @dynasty @ir-keepers
  Scenario: Handle IR keeper costs
    Given an IR player is kept
    When calculating keeper cost
    Then standard cost rules should apply
    And IR designation should be maintained

  @dynasty @prospect-keepers
  Scenario: Keep rookie prospects
    Given a rookie prospect is on the roster
    When evaluating keeper status
    Then prospect rules should apply
    And development timeline should be considered

  @dynasty @prospect-keepers
  Scenario: Track prospect development
    Given a prospect is being kept
    When tracking their development
    Then progress should be documented
    And breakout potential should be evaluated

  @dynasty @developmental-players
  Scenario: Assign developmental status
    Given a young player shows potential
    When assigning developmental status
    Then special keeper rules should apply
    And development tracking should begin

  @dynasty @developmental-players
  Scenario: Graduate from developmental status
    Given a developmental player has matured
    When they graduate to regular status
    Then standard keeper rules should apply
    And developmental history should be preserved
