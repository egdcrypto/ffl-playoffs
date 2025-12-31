@backend @priority_1 @contests
Feature: Contests System
  As a fantasy football playoffs application
  I want to offer various contest types including daily fantasy, weekly contests, season-long contests, pick'em, survivor pools, confidence pools, bracket challenges, and prop contests
  So that users can participate in diverse competitive formats and win prizes

  Background:
    Given the platform is operational
    And user authentication is enabled
    And the NFL playoff schedule is configured
    And contest creation is enabled for the current season

  # ==================== DAILY FANTASY CONTESTS ====================

  Scenario: Create a daily fantasy contest for a single game slate
    Given an admin creates a daily fantasy contest:
      | Field           | Value                          |
      | name            | Wild Card Saturday DFS         |
      | type            | DAILY_FANTASY                  |
      | slate           | 2025-01-11 (Saturday games)    |
      | entry_fee       | 10.00                          |
      | max_entries     | 1000                           |
      | salary_cap      | 50000                          |
      | roster_format   | QB, RB, RB, WR, WR, WR, TE, FLEX, DST |
    When the contest is published
    Then the contest appears in the daily fantasy lobby
    And users can view contest details and prize structure
    And the contest status is "OPEN"

  Scenario: User enters a daily fantasy contest with valid lineup
    Given daily fantasy contest "Wild Card Saturday DFS" is open for entries
    And user "john_doe" has sufficient account balance of $15.00
    When john_doe submits a lineup:
      | Position | Player              | Salary |
      | QB       | Patrick Mahomes     | 9500   |
      | RB       | Derrick Henry       | 8000   |
      | RB       | Josh Jacobs         | 6500   |
      | WR       | Tyreek Hill         | 8500   |
      | WR       | CeeDee Lamb         | 7500   |
      | WR       | Jaylen Waddle       | 5500   |
      | TE       | Travis Kelce        | 7000   |
      | FLEX     | Rashee Rice         | 4500   |
      | DST      | Kansas City Chiefs  | 3000   |
    Then the total salary is 50000
    And the lineup is valid under salary cap
    And $10.00 is deducted from john_doe's account
    And john_doe's entry is confirmed with confirmation number

  Scenario: Reject daily fantasy lineup exceeding salary cap
    Given daily fantasy contest "Wild Card Saturday DFS" is open
    And user "jane_doe" attempts to submit a lineup totaling $52,500
    When jane_doe submits the invalid lineup
    Then the entry is rejected with error "SALARY_CAP_EXCEEDED"
    And the error message is "Lineup total ($52,500) exceeds salary cap ($50,000)"
    And no entry fee is charged

  Scenario: Score daily fantasy contest after games complete
    Given daily fantasy contest "Wild Card Saturday DFS" has 500 entries
    And all Saturday games have completed
    And player statistics are finalized
    When the contest scoring runs
    Then each lineup is scored based on PPR scoring rules
    And lineups are ranked by total points
    And the contest status changes to "COMPLETED"
    And prizes are calculated based on payout structure

  Scenario: Award prizes for daily fantasy contest
    Given daily fantasy contest "Wild Card Saturday DFS" is scored
    And the prize pool is $4,500 (90% of $5,000 entry fees)
    And the payout structure is top 10%:
      | Finish      | Payout    |
      | 1st         | $1,000    |
      | 2nd         | $500      |
      | 3rd         | $300      |
      | 4th-5th     | $200      |
      | 6th-10th    | $100      |
      | 11th-50th   | $40       |
    When prizes are distributed
    Then winning users receive payouts to their account balance
    And payout notifications are sent to winners
    And contest financial records are updated

  Scenario: Allow multiple entries in a multi-entry daily contest
    Given daily fantasy contest "Wild Card GPP" allows up to 3 entries per user
    And user "bob_player" has account balance of $50.00
    When bob_player submits 3 different lineups
    Then all 3 entries are accepted
    And $30.00 is deducted from bob_player's account
    And each entry has a unique entry ID

  Scenario: Late swap lineup changes before player locks
    Given user "john_doe" has entered daily fantasy contest
    And Patrick Mahomes is in john_doe's lineup at QB
    And the Chiefs game has not started
    And Josh Allen's game has not started
    When john_doe swaps Mahomes for Allen before game lock
    Then the swap is accepted
    And the updated lineup is saved
    And john_doe receives confirmation of the change

  Scenario: Block lineup changes after player game starts
    Given user "jane_doe" has Derrick Henry in her lineup
    And the Ravens game has already started
    When jane_doe attempts to swap Henry for another player
    Then the swap is rejected with error "PLAYER_LOCKED"
    And the error message is "Derrick Henry is locked - game in progress"

  # ==================== WEEKLY CONTESTS ====================

  Scenario: Create a weekly playoff contest
    Given an admin creates a weekly contest:
      | Field           | Value                          |
      | name            | Wild Card Weekend Challenge    |
      | type            | WEEKLY                         |
      | week            | Wild Card                      |
      | entry_fee       | 25.00                          |
      | max_entries     | 500                            |
      | roster_slots    | 8                              |
    When the contest is published
    Then the contest spans all Wild Card round games
    And users can enter until the first game kicks off
    And the contest status is "OPEN"

  Scenario: User enters weekly contest with roster selection
    Given weekly contest "Wild Card Weekend Challenge" is open
    And user "alice_player" selects a roster:
      | Position | Player              |
      | QB       | Lamar Jackson       |
      | RB       | Saquon Barkley      |
      | RB       | Jahmyr Gibbs        |
      | WR       | Ja'Marr Chase       |
      | WR       | Justin Jefferson    |
      | TE       | George Kittle       |
      | FLEX     | Amon-Ra St. Brown   |
      | K        | Justin Tucker       |
    When alice_player submits the roster
    Then the entry is accepted
    And $25.00 is deducted from alice_player's account
    And the roster is locked for the week

  Scenario: Score weekly contest across multiple games
    Given weekly contest "Wild Card Weekend Challenge" has 300 entries
    And all Wild Card games have completed
    When weekly scoring is calculated
    Then each roster is scored across all games played
    And players whose teams had a bye contribute 0 points
    And final rankings are determined
    And prizes are awarded based on final standings

  Scenario: Handle roster player whose team is eliminated mid-week
    Given user "john_doe" has a player from an eliminated team
    And the player's team lost on Saturday
    When Sunday games are scored
    Then the eliminated player contributes only Saturday's points
    And the roster is not penalized for the elimination
    And scoring continues normally for remaining players

  # ==================== SEASON-LONG CONTESTS ====================

  Scenario: Create season-long playoff contest
    Given an admin creates a season-long contest:
      | Field           | Value                          |
      | name            | Playoff Championship 2025      |
      | type            | SEASON_LONG                    |
      | entry_fee       | 100.00                         |
      | max_entries     | 200                            |
      | rounds          | Wild Card, Divisional, Conference, Super Bowl |
      | roster_changes  | WEEKLY_UPDATES                 |
    When the contest is published
    Then users can enter before Wild Card round
    And the contest spans the entire playoff period
    And weekly roster update windows are configured

  Scenario: User submits initial roster for season-long contest
    Given season-long contest "Playoff Championship 2025" is open
    And user "john_doe" selects an initial roster
    When john_doe submits the roster
    Then the roster is saved for Wild Card round
    And john_doe can update the roster before each subsequent round
    And cumulative scoring begins from Wild Card

  Scenario: User updates roster between playoff rounds
    Given user "jane_doe" is in season-long contest
    And Wild Card round has completed
    And the roster update window is open for Divisional round
    When jane_doe updates her roster:
      | Change      | Out Player    | In Player       |
      | Swap        | Josh Allen    | Patrick Mahomes |
      | Swap        | Derrick Henry | Saquon Barkley  |
    Then the roster changes are saved
    And jane_doe's new roster is active for Divisional round
    And Wild Card points are preserved

  Scenario: Calculate season-long standings after each round
    Given season-long contest has completed Wild Card round
    And the following scores exist:
      | User         | Wild Card |
      | john_doe     | 145.5     |
      | jane_doe     | 152.3     |
      | bob_player   | 138.7     |
    When standings are calculated
    Then cumulative rankings are displayed
    And users see their round-by-round breakdown
    And projected final standings are shown

  Scenario: Determine season-long contest winner after Super Bowl
    Given season-long contest "Playoff Championship 2025"
    And all playoff rounds are complete
    And final standings are:
      | Rank | User       | Total Points |
      | 1    | jane_doe   | 612.5        |
      | 2    | john_doe   | 598.2        |
      | 3    | bob_player | 575.8        |
    When the contest is finalized
    Then jane_doe wins the grand prize
    And all prize payouts are distributed
    And contest status is "COMPLETED"
    And final leaderboard is frozen

  Scenario: Block roster updates after round deadline
    Given Divisional round roster deadline has passed
    And user "bob_player" attempts to update his roster
    When bob_player submits roster changes
    Then the changes are rejected with error "DEADLINE_PASSED"
    And bob_player's previous roster remains active

  # ==================== PICK'EM CONTESTS ====================

  Scenario: Create pick'em contest for playoff round
    Given an admin creates a pick'em contest:
      | Field           | Value                          |
      | name            | Wild Card Pick'em              |
      | type            | PICKEM                         |
      | round           | Wild Card                      |
      | entry_fee       | 5.00                           |
      | scoring         | STRAIGHT_UP                    |
      | games           | All 6 Wild Card games          |
    When the contest is published
    Then the contest lists all Wild Card matchups
    And users can pick winners for each game
    And the contest status is "OPEN"

  Scenario: User submits pick'em selections
    Given pick'em contest "Wild Card Pick'em" is open
    And user "john_doe" makes picks:
      | Game                   | Pick         |
      | Texans vs Chargers     | Texans       |
      | Steelers vs Bills      | Bills        |
      | Packers vs Eagles      | Eagles       |
      | Broncos vs Ravens      | Ravens       |
      | Commanders vs Buccaneers | Commanders |
      | Vikings vs Rams        | Vikings      |
    When john_doe submits the picks
    Then all 6 picks are recorded
    And $5.00 is deducted from john_doe's account
    And john_doe receives confirmation

  Scenario: Score pick'em contest after games complete
    Given pick'em contest "Wild Card Pick'em" has 200 entries
    And all Wild Card games have completed with results:
      | Game                   | Winner       |
      | Texans vs Chargers     | Texans       |
      | Steelers vs Bills      | Bills        |
      | Packers vs Eagles      | Eagles       |
      | Broncos vs Ravens      | Ravens       |
      | Commanders vs Buccaneers | Buccaneers |
      | Vikings vs Rams        | Rams         |
    When picks are scored
    Then users receive 1 point per correct pick
    And john_doe has 4 correct picks (4 points)
    And rankings are determined by total correct picks

  Scenario: Handle pick'em tiebreaker with point differential
    Given pick'em contest has a tiebreaker question:
      | Question                             | Type   |
      | Total points scored in final game?   | NUMBER |
    And john_doe predicted 47 total points
    And jane_doe predicted 52 total points
    And actual total points were 49
    When tiebreaker is applied
    Then john_doe is closer (2 points off)
    And jane_doe is further (3 points off)
    And john_doe wins the tiebreaker

  Scenario: Pick'em with point spreads
    Given pick'em contest uses spread-based scoring:
      | Game                   | Spread        |
      | Texans vs Chargers     | Texans -3.5   |
      | Steelers vs Bills      | Bills -10     |
    And user "bob_player" picks Texans and Steelers
    And Texans win by 7 (covers) and Steelers lose
    When spread picks are scored
    Then bob_player gets 1 point for Texans (covered spread)
    And bob_player gets 0 points for Steelers (did not cover)

  # ==================== SURVIVOR POOLS ====================

  Scenario: Create survivor pool contest
    Given an admin creates a survivor pool:
      | Field           | Value                          |
      | name            | Playoff Survivor 2025          |
      | type            | SURVIVOR                        |
      | entry_fee       | 50.00                          |
      | max_entries     | 100                            |
      | elimination     | SINGLE_LOSS                    |
      | team_reuse      | NOT_ALLOWED                    |
    When the contest is published
    Then the contest status is "OPEN"
    And rules indicate one loss eliminates
    And users cannot reuse picked teams

  Scenario: User makes survivor pool pick
    Given survivor pool "Playoff Survivor 2025" is open
    And user "jane_doe" has not picked the Chiefs this season
    When jane_doe picks the Chiefs to win Wild Card game
    Then the pick is recorded
    And Chiefs are marked as used by jane_doe
    And jane_doe cannot pick Chiefs in future rounds

  Scenario: User survives after correct survivor pick
    Given user "john_doe" picked the Ravens in Wild Card
    And the Ravens win their game
    When survivor results are processed
    Then john_doe is marked as "ALIVE"
    And john_doe advances to Divisional round
    And john_doe must pick again next round

  Scenario: User eliminated after incorrect survivor pick
    Given user "bob_player" picked the Steelers in Wild Card
    And the Steelers lose their game
    When survivor results are processed
    Then bob_player is marked as "ELIMINATED"
    And bob_player cannot make future picks
    And bob_player can still view pool standings

  Scenario: Determine survivor pool winner by last player standing
    Given survivor pool has progressed through Conference round
    And only 3 players remain:
      | User         | Status  |
      | john_doe     | ALIVE   |
      | jane_doe     | ALIVE   |
      | bob_player   | ALIVE   |
    And all 3 pick the Chiefs for Conference Championship
    And the Chiefs lose
    When results are processed
    Then all 3 players are eliminated simultaneously
    And the prize is split among all 3
    And the contest status is "COMPLETED"

  Scenario: Block survivor pick for already-used team
    Given user "alice_player" picked the Eagles in Wild Card
    And the Eagles won
    When alice_player attempts to pick Eagles for Divisional
    Then the pick is rejected with error "TEAM_ALREADY_USED"
    And alice_player must select a different team

  Scenario: Handle survivor with strike system
    Given survivor pool allows 1 strike before elimination
    And user "john_doe" has 0 strikes
    And john_doe's pick loses
    When results are processed
    Then john_doe receives 1 strike
    And john_doe is still "ALIVE"
    And john_doe's next loss will eliminate him

  # ==================== CONFIDENCE POOLS ====================

  Scenario: Create confidence pool contest
    Given an admin creates a confidence pool:
      | Field           | Value                          |
      | name            | Wild Card Confidence            |
      | type            | CONFIDENCE                      |
      | entry_fee       | 20.00                          |
      | games           | 6 Wild Card games              |
      | point_range     | 1-6                            |
    When the contest is published
    Then users must pick all 6 games
    And users assign confidence points 1-6 (each used once)
    And the contest status is "OPEN"

  Scenario: User submits confidence pool picks
    Given confidence pool "Wild Card Confidence" is open
    And user "john_doe" assigns picks and points:
      | Game                   | Pick    | Confidence |
      | Texans vs Chargers     | Texans  | 3          |
      | Steelers vs Bills      | Bills   | 6          |
      | Packers vs Eagles      | Eagles  | 5          |
      | Broncos vs Ravens      | Ravens  | 4          |
      | Commanders vs Buccaneers | Commanders | 1     |
      | Vikings vs Rams        | Vikings | 2          |
    When john_doe submits the picks
    Then all confidence values 1-6 are used exactly once
    And $20.00 is deducted from john_doe's account
    And picks are locked

  Scenario: Reject confidence picks with duplicate point values
    Given user "jane_doe" attempts to submit:
      | Game                   | Pick    | Confidence |
      | Texans vs Chargers     | Texans  | 6          |
      | Steelers vs Bills      | Bills   | 6          |
    When jane_doe submits invalid picks
    Then the submission is rejected with error "DUPLICATE_CONFIDENCE"
    And the error message is "Confidence value 6 used more than once"

  Scenario: Score confidence pool with weighted points
    Given confidence pool has 50 entries
    And games complete with results:
      | Game                   | Winner       |
      | Steelers vs Bills      | Bills        |
      | Packers vs Eagles      | Packers      |
    And john_doe picked Bills (6) and Eagles (5)
    When scoring is calculated
    Then john_doe earns 6 points for Bills (correct)
    And john_doe earns 0 points for Eagles (incorrect)
    And john_doe's total includes weighted points from all games

  Scenario: Display confidence pool leaderboard
    Given confidence pool scoring is complete
    And final standings are:
      | Rank | User       | Points | Correct Picks |
      | 1    | jane_doe   | 18     | 5/6           |
      | 2    | john_doe   | 15     | 4/6           |
      | 3    | bob_player | 12     | 4/6           |
    When the leaderboard is displayed
    Then users see their rank and total points
    And individual game breakdowns are visible
    And prizes are awarded based on rankings

  # ==================== BRACKET CHALLENGES ====================

  Scenario: Create bracket challenge contest
    Given an admin creates a bracket challenge:
      | Field           | Value                          |
      | name            | Playoff Bracket Challenge 2025 |
      | type            | BRACKET                         |
      | entry_fee       | 15.00                          |
      | scoring         | PROGRESSIVE                    |
      | rounds          | Wild Card, Divisional, Conference, Super Bowl |
    When the contest is published
    Then users can pick winners for entire playoff bracket
    And point values increase each round
    And the contest status is "OPEN"

  Scenario: User submits complete bracket predictions
    Given bracket challenge is open
    And user "john_doe" predicts:
      | Round       | Winners                                     |
      | Wild Card   | Texans, Bills, Eagles, Ravens, Bucs, Rams   |
      | Divisional  | Chiefs, Lions, Eagles, Ravens               |
      | Conference  | Chiefs, Eagles                              |
      | Super Bowl  | Chiefs                                       |
    When john_doe submits the bracket
    Then all predictions are recorded
    And $15.00 is deducted from john_doe's account
    And the bracket is locked before Wild Card kickoff

  Scenario: Score bracket with progressive point values
    Given bracket challenge uses progressive scoring:
      | Round       | Points Per Correct |
      | Wild Card   | 1                  |
      | Divisional  | 2                  |
      | Conference  | 4                  |
      | Super Bowl  | 8                  |
    And john_doe predicted Chiefs to win Super Bowl
    And Chiefs win the Super Bowl
    When bracket is scored
    Then john_doe earns 8 points for Super Bowl winner
    And total points include all correct picks across rounds

  Scenario: Track bracket elimination status
    Given user "bob_player" picked the Dolphins to win Super Bowl
    And the Dolphins lost in Wild Card round
    When Wild Card results are processed
    Then bob_player's Super Bowl pick is marked "ELIMINATED"
    And bob_player can earn maximum of 7 points (no SB bonus possible)
    And bob_player's bracket shows eliminated predictions in red

  Scenario: Calculate best possible remaining score
    Given Divisional round is complete
    And user "jane_doe" has current bracket stats:
      | Metric                   | Value |
      | Points Earned           | 8     |
      | Remaining Correct Picks | 2     |
      | Best Possible Score     | 20    |
    When jane_doe views bracket
    Then current score and maximum possible are shown
    And jane_doe sees she can still earn Conference (4) + Super Bowl (8) = 12 more points

  Scenario: Award bonus for perfect bracket round
    Given bracket challenge awards bonus for perfect rounds
    And user "alice_player" correctly picked all 6 Wild Card winners
    When Wild Card scoring is processed
    Then alice_player earns 6 base points
    And alice_player earns 3 bonus points for perfect round
    And total Wild Card score is 9 points

  # ==================== PROP CONTESTS ====================

  Scenario: Create prop contest for Super Bowl
    Given an admin creates a prop contest:
      | Field           | Value                          |
      | name            | Super Bowl Prop Challenge       |
      | type            | PROP                            |
      | entry_fee       | 10.00                          |
      | props_count     | 20                              |
      | categories      | Player, Game, Novelty           |
    When the contest is published
    Then 20 prop questions are available
    And users can submit answers before Super Bowl kickoff
    And the contest status is "OPEN"

  Scenario: User submits prop contest answers
    Given prop contest "Super Bowl Prop Challenge" is open
    And user "john_doe" answers props:
      | Prop                                      | Answer           |
      | Super Bowl MVP                            | Patrick Mahomes  |
      | First team to score                       | Chiefs           |
      | Total points (over/under 47.5)            | Over             |
      | Longest touchdown (over/under 35.5 yards) | Under            |
      | Will there be a safety?                   | No               |
    When john_doe submits 20 prop answers
    Then all answers are recorded
    And $10.00 is deducted from john_doe's account
    And answers are locked at kickoff

  Scenario: Score prop contest with varying point values
    Given prop contest has weighted props:
      | Prop                   | Points If Correct |
      | Super Bowl MVP         | 5                 |
      | First team to score    | 2                 |
      | Over/Under Total       | 1                 |
    And john_doe correctly picked MVP and first scorer
    When prop scoring is calculated
    Then john_doe earns 5 + 2 = 7 points from those props
    And total score includes all correct prop answers

  Scenario: Handle props requiring live game resolution
    Given prop "First scoring play type" options are:
      | Touchdown | Field Goal | Safety |
    And the first score is a field goal
    When live scoring updates
    Then users who picked "Field Goal" earn points
    And prop is marked "RESOLVED"
    And real-time leaderboard updates

  Scenario: Resolve conditional props
    Given prop "Patrick Mahomes passing yards" has options:
      | Under 250 | 250-299 | 300-349 | 350+ |
    And Mahomes throws for 312 yards
    When props are resolved
    Then correct answer is "300-349"
    And users with that answer earn points

  # ==================== CONTEST ENTRY ====================

  Scenario: User views available contests in lobby
    Given multiple contests are open:
      | Contest                       | Type     | Entry Fee |
      | Wild Card Saturday DFS        | DAILY    | $10       |
      | Playoff Survivor 2025         | SURVIVOR | $50       |
      | Wild Card Pick'em             | PICKEM   | $5        |
    When user "john_doe" views the contest lobby
    Then all open contests are displayed
    And each contest shows type, fee, prize pool, and entries
    And john_doe can filter by contest type

  Scenario: User registers for a contest
    Given user "jane_doe" is authenticated
    And contest "Wild Card Pick'em" is open
    And jane_doe has sufficient balance
    When jane_doe clicks "Enter Contest"
    Then jane_doe is taken to the entry form
    And contest rules are displayed
    And jane_doe can submit her entry

  Scenario: Reject entry for insufficient account balance
    Given user "bob_player" has account balance of $5.00
    And contest "Playoff Survivor 2025" requires $50 entry fee
    When bob_player attempts to enter
    Then entry is rejected with error "INSUFFICIENT_BALANCE"
    And bob_player is prompted to add funds
    And no entry is created

  Scenario: Reject entry after contest deadline
    Given contest "Wild Card Pick'em" deadline has passed
    And user "alice_player" attempts to enter
    When alice_player submits entry
    Then entry is rejected with error "DEADLINE_PASSED"
    And the error message indicates the contest is closed

  Scenario: Enforce maximum entries per user
    Given contest "Wild Card DFS" allows max 5 entries per user
    And user "john_doe" already has 5 entries
    When john_doe attempts to submit a 6th entry
    Then entry is rejected with error "MAX_ENTRIES_REACHED"
    And john_doe is informed of the limit

  Scenario: Enforce contest capacity limits
    Given contest "Exclusive Pool" has max 50 entries
    And 50 entries are already submitted
    When user "new_user" attempts to enter
    Then entry is rejected with error "CONTEST_FULL"
    And new_user can join a waitlist

  Scenario: User withdraws entry before deadline
    Given user "jane_doe" entered contest "Wild Card Pick'em"
    And the entry deadline has not passed
    And no games have started
    When jane_doe requests to withdraw
    Then the entry is cancelled
    And $5.00 is refunded to jane_doe's account
    And jane_doe receives withdrawal confirmation

  Scenario: Block entry withdrawal after games start
    Given user "bob_player" entered contest
    And games have already started
    When bob_player attempts to withdraw
    Then withdrawal is rejected with error "GAMES_STARTED"
    And the error message is "Cannot withdraw after games have begun"

  Scenario: Apply promo code to contest entry
    Given user "john_doe" has promo code "PLAYOFFS25" for 25% off
    And contest entry fee is $20.00
    When john_doe applies the promo code
    Then entry fee is discounted to $15.00
    And promo code is marked as used
    And john_doe's balance is charged $15.00

  # ==================== CONTEST PAYOUTS ====================

  Scenario: Calculate prize pool from entry fees
    Given contest "Wild Card DFS" has:
      | Total Entries | 500        |
      | Entry Fee     | $10        |
      | Rake          | 10%        |
    When prize pool is calculated
    Then gross pool is $5,000
    And rake is $500
    And net prize pool is $4,500

  Scenario: Distribute payouts using flat structure
    Given contest uses flat payout structure:
      | Position  | Payout  |
      | 1st       | $500    |
      | 2nd       | $300    |
      | 3rd       | $200    |
    And contest is complete
    When payouts are processed
    Then 1st place receives $500
    And 2nd place receives $300
    And 3rd place receives $200

  Scenario: Distribute payouts using percentage structure
    Given contest prize pool is $10,000
    And payout structure is percentage-based:
      | Position  | Percentage |
      | 1st       | 30%        |
      | 2nd       | 20%        |
      | 3rd       | 15%        |
      | 4th-5th   | 10%        |
      | 6th-10th  | 3%         |
    When payouts are calculated
    Then 1st place receives $3,000
    And 2nd place receives $2,000
    And 3rd place receives $1,500
    And positions 4th-5th each receive $1,000
    And positions 6th-10th each receive $300

  Scenario: Handle payout ties with prize splitting
    Given contest results show:
      | Position | User       | Score |
      | 1st      | john_doe   | 185.5 |
      | 2nd      | jane_doe   | 172.0 |
      | 2nd      | bob_player | 172.0 |
    And 2nd place payout is $300
    And 3rd place payout is $200
    When payouts are processed for tied positions
    Then john_doe receives 1st place payout
    And jane_doe and bob_player split 2nd + 3rd payouts
    And each receives ($300 + $200) / 2 = $250

  Scenario: Process payout to user account balance
    Given user "jane_doe" won $500 in contest
    And jane_doe's current balance is $50
    When payout is processed
    Then jane_doe's balance increases to $550
    And transaction record is created
    And jane_doe receives payout notification

  Scenario: Process user withdrawal request
    Given user "john_doe" has balance of $1,000
    And john_doe requests withdrawal of $500
    And john_doe's payment method is verified
    When withdrawal is processed
    Then $500 is sent to john_doe's payment method
    And john_doe's balance is reduced to $500
    And withdrawal confirmation is sent

  Scenario: Apply minimum balance for withdrawal
    Given minimum withdrawal amount is $25
    And user "bob_player" has balance of $20
    When bob_player attempts to withdraw $20
    Then withdrawal is rejected with error "MINIMUM_NOT_MET"
    And bob_player is informed of $25 minimum

  Scenario: Generate payout report for contest
    Given contest "Playoff Championship 2025" is complete
    When admin requests payout report
    Then report includes:
      | User         | Position | Payout  | Status      |
      | jane_doe     | 1st      | $1,000  | COMPLETED   |
      | john_doe     | 2nd      | $500    | COMPLETED   |
      | bob_player   | 3rd      | $250    | PENDING     |
    And total payouts match prize pool
    And report is exportable

  Scenario: Handle unclaimed prize after expiration
    Given user "inactive_user" won $100
    And prize claim deadline is 30 days
    And 30 days have passed without claim
    When prize expiration is processed
    Then prize is marked "EXPIRED"
    And funds return to platform treasury
    And admin is notified of unclaimed prize

  Scenario: Cancel contest with full refunds
    Given contest "Special Event Pool" has 50 entries
    And each entry was $25
    And the contest must be cancelled due to NFL schedule change
    When admin cancels the contest
    Then all 50 entries receive $25 refund
    And users are notified of cancellation
    And contest status is "CANCELLED"

  Scenario: Delay payout pending verification
    Given user "new_user" won $5,000 (large prize)
    And platform policy requires verification for prizes over $1,000
    When payout is initiated
    Then payout status is "PENDING_VERIFICATION"
    And new_user is notified to complete verification
    And payout is released after verification

  # ==================== CONTEST NOTIFICATIONS ====================

  Scenario: Send contest entry confirmation
    Given user "john_doe" enters a contest
    When entry is successful
    Then john_doe receives email confirmation
    And confirmation includes contest details and entry ID
    And push notification is sent if enabled

  Scenario: Send contest result notification
    Given contest "Wild Card Pick'em" is complete
    And user "jane_doe" finished in 3rd place
    When results are finalized
    Then jane_doe receives notification of 3rd place finish
    And notification includes prize amount won
    And leaderboard link is provided

  Scenario: Send contest deadline reminder
    Given contest "Bracket Challenge" deadline is in 2 hours
    And user "bob_player" started entry but did not submit
    When reminder job runs
    Then bob_player receives reminder notification
    And notification includes deadline time
    And direct link to complete entry is provided

  Scenario: Notify users of live scoring updates
    Given contest "Wild Card DFS" is in progress
    And user "alice_player" has enabled live notifications
    When alice_player moves into top 10
    Then alice_player receives notification
    And notification shows current rank and score
    And notification links to live leaderboard
