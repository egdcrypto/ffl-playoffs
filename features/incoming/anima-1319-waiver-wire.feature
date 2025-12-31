@waiver-wire @waivers @transactions
Feature: Waiver Wire
  As a fantasy football manager
  I want to manage waiver claims and free agent pickups
  So that I can add players to improve my roster throughout the season

  Background:
    Given a fantasy football league exists
    And the league has active members with rosters
    And waiver wire functionality is enabled

  # ==========================================
  # WAIVER PRIORITY SYSTEM
  # ==========================================

  @priority @happy-path
  Scenario: View my waiver priority
    Given waiver priority is used in my league
    When I check my waiver priority
    Then I see my current position in the waiver order
    And I understand when it resets

  @priority @order
  Scenario: View league waiver order
    Given I want to see everyone's priority
    When I view the waiver order
    Then I see all teams ranked by priority
    And current order is displayed

  @priority @inverse
  Scenario: Inverse standings waiver order
    Given league uses inverse standings priority
    When standings change
    Then waiver priority adjusts inversely
    And worst teams get top priority

  @priority @rolling
  Scenario: Rolling waiver priority
    Given league uses rolling waivers
    When a team makes a successful claim
    Then that team moves to the bottom
    And others move up

  @priority @weekly-reset
  Scenario: Weekly waiver priority reset
    Given league resets priority weekly
    When the week ends
    Then priority resets to inverse standings
    And all teams get fresh order

  @priority @never-reset
  Scenario: Never reset waiver priority
    Given league never resets priority
    When claims are made
    Then priority only changes via claims
    And order persists all season

  # ==========================================
  # FAAB BIDDING
  # ==========================================

  @faab @happy-path
  Scenario: Place FAAB bid on player
    Given my league uses FAAB
    And I have remaining budget
    When I place a bid on a player
    Then my bid is recorded
    And I am in contention for the player

  @faab @budget
  Scenario: View remaining FAAB budget
    Given I have used some FAAB
    When I check my budget
    Then I see remaining dollars
    And spent amount is shown

  @faab @blind-bid
  Scenario: Submit blind bid
    Given FAAB is blind bidding
    When I submit my bid
    Then others cannot see my bid amount
    And bids are secret until processed

  @faab @maximum
  Scenario: Bid maximum FAAB
    Given I want a player badly
    When I bid my entire remaining budget
    Then the max bid is accepted
    And I would have $0 remaining if won

  @faab @minimum
  Scenario: Place minimum bid
    Given I want to save budget
    When I place $0 or $1 bid
    Then minimum bid is accepted
    And I conserve budget

  @faab @modify
  Scenario: Modify FAAB bid before processing
    Given I have a pending bid
    When I modify the bid amount
    Then my bid is updated
    And new amount is saved

  @faab @cancel
  Scenario: Cancel FAAB bid
    Given I have a pending bid
    When I cancel the bid
    Then my bid is withdrawn
    And I am no longer in contention

  @faab @tiebreaker
  Scenario: Resolve FAAB tie with priority
    Given two teams bid the same amount
    When processing occurs
    Then priority determines winner
    And higher priority wins

  # ==========================================
  # WAIVER CLAIM PROCESSING
  # ==========================================

  @processing @happy-path
  Scenario: Process waiver claims
    Given waiver claims have been submitted
    When the processing time arrives
    Then claims are processed in order
    And successful claims update rosters

  @processing @time
  Scenario: View waiver processing time
    Given waivers process at a set time
    When I check processing schedule
    Then I see when waivers run
    And countdown is displayed

  @processing @results
  Scenario: View waiver processing results
    Given waivers have processed
    When I check results
    Then I see which claims succeeded
    And which failed with reasons

  @processing @notification
  Scenario: Receive processing notification
    Given I had pending claims
    When processing completes
    Then I receive notification
    And results are included

  @processing @priority-order
  Scenario: Process claims by priority
    Given multiple claims exist for a player
    When processing occurs
    Then highest priority claim wins
    And others fail

  @processing @faab-order
  Scenario: Process FAAB claims by bid
    Given multiple FAAB bids exist
    When processing occurs
    Then highest bid wins
    And winner pays their bid

  # ==========================================
  # WAIVER PERIODS
  # ==========================================

  @period @happy-path
  Scenario: Player on waivers during period
    Given a player is dropped
    When the waiver period begins
    Then player cannot be freely added
    And claims must be submitted

  @period @duration
  Scenario: Configure waiver period duration
    Given I am the commissioner
    When I set waiver period length
    Then dropped players wait that long
    And setting is saved

  @period @clear
  Scenario: Player clears waivers
    Given waiver period has passed
    And no claims were made
    When player clears waivers
    Then they become a free agent
    And can be added immediately

  @period @game-time
  Scenario: Game-time waivers
    Given a player's game has started
    When someone tries to add them
    Then they are on waivers until games end
    And normal waiver rules apply

  @period @weekly
  Scenario: Weekly waiver period
    Given league has weekly waiver periods
    When claims are submitted
    Then they process at week's end
    And timing is consistent

  # ==========================================
  # FREE AGENT PICKUPS
  # ==========================================

  @free-agent @happy-path
  Scenario: Add free agent to roster
    Given a player is a free agent
    And I have roster space
    When I add the free agent
    Then they are added to my roster
    And transaction is recorded

  @free-agent @drop
  Scenario: Add free agent with drop
    Given my roster is full
    When I add a free agent and drop a player
    Then swap is executed
    And dropped player goes to waivers

  @free-agent @immediate
  Scenario: Immediate free agent pickup
    Given free agent pickups are instant
    When I add a free agent
    Then they are immediately on my roster
    And no waiting period

  @free-agent @browse
  Scenario: Browse available free agents
    Given free agents are available
    When I browse free agents
    Then I see all unowned players
    And I can filter and sort

  @free-agent @search
  Scenario: Search for free agent
    Given I want a specific player
    When I search for them
    Then I find the player
    And their status is shown

  # ==========================================
  # CLAIM CONFLICTS RESOLUTION
  # ==========================================

  @conflicts @same-player
  Scenario: Resolve multiple claims for same player
    Given multiple teams claim the same player
    When claims are processed
    Then priority/FAAB determines winner
    And others receive failure notice

  @conflicts @conditional
  Scenario: Process conditional claims
    Given I have ordered claim priorities
    When my first claim fails
    Then my next claim is processed
    And I may still get a player

  @conflicts @roster-space
  Scenario: Handle roster space conflicts
    Given my claim would exceed roster limit
    When processing occurs
    Then claim fails for roster space
    And I am notified

  @conflicts @duplicate
  Scenario: Prevent duplicate claims
    Given I already claimed a player
    When I try to claim again
    Then duplicate is prevented
    And existing claim remains

  # ==========================================
  # WAIVER ORDER RESET RULES
  # ==========================================

  @reset @standings
  Scenario: Reset order based on standings
    Given reset is based on standings
    When reset trigger occurs
    Then order matches inverse standings
    And all teams get new priority

  @reset @manual
  Scenario: Commissioner manually resets order
    Given I am the commissioner
    When I manually reset waiver order
    Then order is reset
    And reason can be noted

  @reset @schedule
  Scenario: Scheduled waiver order reset
    Given reset is scheduled
    When schedule time arrives
    Then order resets automatically
    And league is notified

  @reset @preserve
  Scenario: Preserve unused priority
    Given team hasn't made claims
    When reset occurs
    Then their priority is preserved
    And active teams move down

  # ==========================================
  # CONTINUOUS WAIVERS
  # ==========================================

  @continuous @happy-path
  Scenario: Continuous waiver processing
    Given league uses continuous waivers
    When claims are submitted
    Then they process on a rolling basis
    And multiple processing times exist

  @continuous @daily
  Scenario: Daily waiver processing
    Given waivers process daily
    When the daily time arrives
    Then all pending claims process
    And results are available

  @continuous @multiple
  Scenario: Multiple processing times per day
    Given league has multiple waiver runs
    When each time arrives
    Then claims submitted before are processed
    And quick turnaround exists

  @continuous @real-time
  Scenario: Near real-time processing
    Given league wants fast processing
    When claims are submitted
    Then they process quickly
    And delays are minimal

  # ==========================================
  # GAME-TIME WAIVERS
  # ==========================================

  @game-time @lock
  Scenario: Player locks at game time
    Given a player's game is about to start
    When game time arrives
    Then player goes on waivers
    And cannot be freely added

  @game-time @unlock
  Scenario: Players unlock after games
    Given players are locked during games
    When games complete
    Then players can be added again
    And normal rules apply

  @game-time @claim
  Scenario: Claim player during games
    Given player is locked in-game
    When I submit a claim
    Then claim is queued for after games
    And will process later

  @game-time @drop
  Scenario: Drop locked player
    Given my player's game has started
    When I try to drop them
    Then drop may be blocked or delayed
    And depends on league settings

  # ==========================================
  # INJURED RESERVE MOVES
  # ==========================================

  @ir @move-to @happy-path
  Scenario: Move player to IR
    Given my player is IR-eligible
    When I move them to IR slot
    Then they occupy IR slot
    And roster spot is freed

  @ir @eligible
  Scenario: Check IR eligibility
    Given I want to IR a player
    When I check eligibility
    Then I see if they qualify
    And designation is shown

  @ir @pickup
  Scenario: Pick up player while using IR
    Given I have a player on IR
    And IR spot is occupied
    When I pick up a player
    Then roster math works correctly
    And IR usage is considered

  @ir @return
  Scenario: Activate player from IR
    Given my IR player is healthy
    When I activate them
    Then they move to active roster
    And IR slot is freed

  @ir @ineligible
  Scenario: Handle IR-ineligible player on IR
    Given a player on my IR is no longer eligible
    When roster rules are checked
    Then I must make a move
    And am notified of issue

  # ==========================================
  # PRACTICE SQUAD MANAGEMENT
  # ==========================================

  @practice-squad @happy-path
  Scenario: Add player to practice squad
    Given my league has practice squad
    When I add a player to practice squad
    Then they occupy a PS slot
    And are not on active roster

  @practice-squad @promote
  Scenario: Promote from practice squad
    Given I have a PS player
    When I promote them to active roster
    Then they move to roster
    And PS slot is freed

  @practice-squad @demote
  Scenario: Demote to practice squad
    Given I want to demote a player
    When I move them to practice squad
    Then they move to PS
    And roster spot is freed

  @practice-squad @poach
  Scenario: Poach practice squad player
    Given another team has PS players
    When I claim their PS player
    Then claim is processed
    And I may acquire them

  @practice-squad @protect
  Scenario: Protect practice squad players
    Given I want to protect PS players
    When I designate protection
    Then protected players cannot be poached
    And protection limits apply

  # ==========================================
  # WAIVER WIRE REPORTS
  # ==========================================

  @reports @activity @happy-path
  Scenario: View waiver activity report
    Given waiver activity has occurred
    When I view the report
    Then I see all transactions
    And activity is summarized

  @reports @weekly
  Scenario: View weekly waiver summary
    Given the week has activity
    When I view weekly summary
    Then I see week's transactions
    And trends are highlighted

  @reports @team
  Scenario: View team waiver activity
    Given a team has made moves
    When I view their activity
    Then I see their transactions
    And frequency is shown

  @reports @budget
  Scenario: View FAAB spending report
    Given FAAB has been spent
    When I view spending report
    Then I see league-wide spending
    And budgets remaining are shown

  @reports @successful
  Scenario: View successful claims
    Given claims have processed
    When I view successful claims
    Then I see who was added
    And by which teams

  # ==========================================
  # TRENDING PLAYERS
  # ==========================================

  @trending @adds @happy-path
  Scenario: View trending adds
    Given players are being added
    When I view trending adds
    Then I see most-added players
    And add percentage is shown

  @trending @drops
  Scenario: View trending drops
    Given players are being dropped
    When I view trending drops
    Then I see most-dropped players
    And drop percentage is shown

  @trending @roster-percentage
  Scenario: View roster ownership percentage
    Given ownership is tracked
    When I view ownership
    Then I see percentage owned
    And changes are highlighted

  @trending @breakout
  Scenario: View breakout candidates
    Given some players are emerging
    When I view breakouts
    Then I see rising players
    And momentum is indicated

  @trending @buy-low
  Scenario: View buy-low candidates
    Given some players are undervalued
    When I view buy-low candidates
    Then I see struggling players
    And upside potential is noted

  # ==========================================
  # LEAGUE WAIVER SETTINGS
  # ==========================================

  @settings @configure @happy-path
  Scenario: Configure waiver settings
    Given I am the commissioner
    When I access waiver settings
    Then I can configure all options
    And settings are saved

  @settings @type
  Scenario: Select waiver type
    Given I am the commissioner
    When I select waiver type
    Then I choose priority or FAAB
    And type is applied

  @settings @budget
  Scenario: Set FAAB budget
    Given league uses FAAB
    When I set the budget
    Then each team gets that amount
    And budget is established

  @settings @processing
  Scenario: Configure processing schedule
    Given I am the commissioner
    When I set processing times
    Then waivers run at those times
    And schedule is published

  @settings @period
  Scenario: Set waiver claim period
    Given I am the commissioner
    When I set the waiver period
    Then players wait that long on waivers
    And period is enforced

  @settings @limits
  Scenario: Set transaction limits
    Given I am the commissioner
    When I set transaction limits
    Then teams are limited
    And limits are enforced

  # ==========================================
  # CLAIM QUEUE MANAGEMENT
  # ==========================================

  @queue @add @happy-path
  Scenario: Add claim to queue
    Given I want multiple players
    When I add claims to my queue
    Then claims are ordered by priority
    And I can adjust order

  @queue @reorder
  Scenario: Reorder claim queue
    Given I have queued claims
    When I reorder them
    Then new order is saved
    And processing follows order

  @queue @remove
  Scenario: Remove claim from queue
    Given I have claims in queue
    When I remove one
    Then it is removed from queue
    And other claims remain

  @queue @view
  Scenario: View my claim queue
    Given I have pending claims
    When I view my queue
    Then I see all claims ordered
    And can manage them

  @queue @conditional
  Scenario: Set conditional claims
    Given I want backup options
    When I set claim conditions
    Then secondary claims process if primary fails
    And I maximize chances

  # ==========================================
  # DROP RULES
  # ==========================================

  @drop @immediate
  Scenario: Drop player immediately
    Given I can drop players immediately
    When I drop a player
    Then they are removed from roster
    And go to waivers

  @drop @restrictions
  Scenario: Enforce drop restrictions
    Given drop restrictions exist
    When I try to drop a restricted player
    Then drop is blocked
    And restriction is explained

  @drop @undroppable
  Scenario: Handle undroppable players
    Given a player is on the undroppable list
    When I try to drop them
    Then drop is prevented
    And reason is shown

  @drop @recent-add
  Scenario: Restrict dropping recently added players
    Given I just added a player
    When I try to drop them immediately
    Then restriction may apply
    And waiting period is shown

  # ==========================================
  # MOBILE WAIVER EXPERIENCE
  # ==========================================

  @mobile @happy-path
  Scenario: Manage waivers on mobile
    Given I am using the mobile app
    When I access waivers
    Then interface is mobile-optimized
    And all features work

  @mobile @claim
  Scenario: Submit waiver claim on mobile
    Given I am on mobile
    When I submit a claim
    Then claim is processed correctly
    And confirmation is received

  @mobile @notifications
  Scenario: Receive waiver notifications on mobile
    Given I have mobile app
    When waiver events occur
    Then I receive push notifications
    And can act quickly

  @mobile @quick-add
  Scenario: Quick add from mobile
    Given I see an available player
    When I quick add them
    Then add is streamlined
    And minimal taps required

  # ==========================================
  # WAIVER WIRE ASSISTANT
  # ==========================================

  @assistant @recommendations
  Scenario: Get waiver wire recommendations
    Given I want pickup advice
    When I view recommendations
    Then I see suggested adds
    And reasoning is provided

  @assistant @priorities
  Scenario: Get recommended priorities
    Given I need to prioritize claims
    When I ask for help
    Then I see recommended order
    And value analysis is included

  @assistant @drops
  Scenario: Get drop recommendations
    Given I need to drop someone
    When I view drop suggestions
    Then I see who to drop
    And impact is assessed

  @assistant @faab
  Scenario: Get FAAB bid suggestions
    Given I use FAAB
    When I ask for bid advice
    Then I see recommended amounts
    And budget considerations are shown

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle claim for owned player
    Given player was just added by someone
    When my claim processes
    Then claim fails gracefully
    And I am notified

  @error-handling
  Scenario: Handle insufficient FAAB
    Given I bid more than I have
    When I try to submit
    Then bid is rejected
    And budget is shown

  @error-handling
  Scenario: Handle roster limit exceeded
    Given adding would exceed limits
    When claim processes
    Then claim fails for space
    And I must drop first

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Manage waivers with screen reader
    Given I am using a screen reader
    When I access waiver features
    Then all elements are labeled
    And workflow is accessible

  @accessibility
  Scenario: View waivers with high contrast
    Given I have high contrast enabled
    When I view waiver screens
    Then all elements are visible
    And status is clear

  @accessibility
  Scenario: Navigate waivers with keyboard
    Given I use keyboard navigation
    When I manage waivers
    Then all actions are accessible
    And focus indicators are clear
