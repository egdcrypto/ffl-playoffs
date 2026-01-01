@backend @priority_1 @contests
Feature: Fantasy Football Contests
  As a fantasy football playoffs application
  I want to support multiple contest formats including daily, weekly, season-long, pick'em, prediction, survivor, best ball, and bracket contests
  So that players have diverse and engaging ways to compete during the NFL playoffs

  Background:
    Given the platform is operational
    And NFL playoff data is available
    And the contest management system is active

  # ==================== DAILY FANTASY CONTESTS ====================

  Scenario: Create a daily fantasy contest for a single game slate
    Given an admin "contest_admin" is creating a new contest
    When the admin creates a daily fantasy contest with:
      | Field              | Value                    |
      | name               | Wild Card Saturday DFS   |
      | type               | DAILY_FANTASY            |
      | slate              | SAT_WILD_CARD            |
      | entry_fee          | 25.00                    |
      | max_entries        | 1000                     |
      | salary_cap         | 50000                    |
      | roster_positions   | QB, RB, RB, WR, WR, WR, TE, FLEX, DEF |
    Then the contest is created successfully
    And the contest appears in the available contests list
    And entry opens for players

  Scenario: Enter a daily fantasy contest with valid lineup
    Given a daily fantasy contest "Wild Card Saturday DFS" exists
    And player "john_doe" has an account with sufficient balance
    And the contest has the following salary constraints:
      | Position | Min Salary | Max Salary |
      | QB       | 5000       | 9000       |
      | RB       | 3500       | 8500       |
      | WR       | 3000       | 9500       |
      | TE       | 2500       | 7000       |
      | DEF      | 2000       | 5000       |
    When "john_doe" submits a lineup:
      | Position | Player             | Team    | Salary |
      | QB       | Patrick Mahomes    | Chiefs  | 8500   |
      | RB       | Derrick Henry      | Ravens  | 7200   |
      | RB       | Saquon Barkley     | Eagles  | 8000   |
      | WR       | Tyreek Hill        | Dolphins| 8200   |
      | WR       | CeeDee Lamb        | Cowboys | 7800   |
      | WR       | Amon-Ra St. Brown  | Lions   | 6500   |
      | TE       | Travis Kelce       | Chiefs  | 6800   |
      | FLEX     | James Cook         | Bills   | 5800   |
      | DEF      | San Francisco      | 49ers   | 4200   |
    Then the entry is accepted
    And john_doe's balance is reduced by $25.00
    And the lineup total salary is 63000 which exceeds cap
    And the entry is rejected with error "SALARY_CAP_EXCEEDED"

  Scenario: Validate salary cap in daily fantasy contest
    Given a daily fantasy contest with salary cap of 50000
    And player "jane_doe" is submitting a lineup
    When the lineup total salary is 50500
    Then the lineup is rejected
    And the error message is "Lineup exceeds salary cap by 500"

  Scenario: Allow multiple entries in multi-entry daily contest
    Given a daily fantasy contest "Multi-Entry Showdown" with max 3 entries per player
    And player "bob_player" has submitted 2 entries
    When "bob_player" submits a third entry with a different lineup
    Then the entry is accepted
    And bob_player has 3 active entries in the contest
    When "bob_player" attempts a fourth entry
    Then the entry is rejected with error "MAX_ENTRIES_REACHED"

  Scenario: Lock daily fantasy lineups at game start
    Given a daily fantasy contest "Sunday Showdown" exists
    And the first game starts at 1:00 PM EST
    And player "alice_player" has a submitted lineup
    When the time is 1:01 PM EST
    And "alice_player" attempts to modify their lineup
    Then the modification is rejected
    And the error message is "Lineups are locked after first game starts"

  Scenario: Calculate daily fantasy contest standings
    Given a daily fantasy contest has completed
    And the following lineups and scores exist:
      | Player        | Total Score |
      | john_doe      | 185.5       |
      | jane_doe      | 192.3       |
      | bob_player    | 178.8       |
      | alice_player  | 192.3       |
    When final standings are calculated
    Then standings are ordered by score descending
    And ties are broken by highest single player score
    And prize payouts are calculated based on finishing position

  # ==================== WEEKLY CONTESTS ====================

  Scenario: Create a weekly playoff contest
    Given an admin is configuring a weekly contest
    When the admin creates a weekly contest with:
      | Field              | Value                    |
      | name               | Wild Card Weekly Pool    |
      | type               | WEEKLY                   |
      | week               | WILD_CARD                |
      | entry_fee          | 50.00                    |
      | max_entries        | 500                      |
      | roster_format      | PICK_5                   |
    Then the weekly contest is created
    And players can select 5 NFL players for the week
    And selections are locked at the first game of the week

  Scenario: Submit weekly roster selections
    Given a weekly contest "Divisional Round Weekly" exists
    And the roster format is PICK_5 with no salary cap
    When player "john_doe" submits selections:
      | Player             | Team    |
      | Patrick Mahomes    | Chiefs  |
      | Derrick Henry      | Ravens  |
      | Tyreek Hill        | Dolphins|
      | Travis Kelce       | Chiefs  |
      | San Francisco DEF  | 49ers   |
    Then the selections are accepted
    And john_doe is entered in the weekly contest
    And selections are editable until game lock

  Scenario: Enforce unique player selection in weekly contest
    Given a weekly contest with unique player requirement
    And 50 players have selected Patrick Mahomes
    And the player ownership limit is 40%
    When player "new_player" attempts to select Patrick Mahomes
    Then the selection is allowed (ownership limits are for display only)
    And current Mahomes ownership percentage is displayed as 51%

  Scenario: Calculate weekly contest cumulative scoring
    Given a weekly contest spans 6 NFL playoff games
    And player "jane_doe" has players in 4 of those games
    When all 6 games are complete
    Then jane_doe's score is the sum of her 5 selected players
    And weekly standings are finalized
    And prizes are distributed based on final standings

  Scenario: Display weekly contest progress
    Given a weekly contest is in progress
    And 3 of 6 games are complete
    When player "bob_player" views the leaderboard
    Then partial standings are displayed
    And each entry shows:
      | Points scored so far   |
      | Players yet to play    |
      | Projected final score  |
    And live updates continue as games progress

  # ==================== SEASON-LONG CONTESTS ====================

  Scenario: Create a season-long playoff contest
    Given an admin is setting up the playoff pool
    When the admin creates a season-long contest with:
      | Field              | Value                    |
      | name               | 2025 Playoff Pool        |
      | type               | SEASON_LONG              |
      | duration           | FULL_PLAYOFFS            |
      | entry_fee          | 100.00                   |
      | max_entries        | 200                      |
      | roster_format      | PICK_BEFORE_PLAYOFFS     |
    Then the season-long contest is created
    And entry period opens before Wild Card weekend
    And all selections are locked for the entire playoffs

  Scenario: Submit season-long playoff roster
    Given a season-long contest "2025 Playoff Pool" is open for entry
    And the roster format requires:
      | Position | Count |
      | QB       | 2     |
      | RB       | 3     |
      | WR       | 4     |
      | TE       | 2     |
      | K        | 1     |
      | DEF      | 2     |
    When player "john_doe" submits a complete roster
    Then the roster is validated for completeness
    And all selected players must be on playoff teams
    And the entry is confirmed

  Scenario: Track season-long contest across all playoff rounds
    Given a season-long contest has begun
    And player "jane_doe" has the following roster performance:
      | Round        | Active Players | Points Scored |
      | Wild Card    | 14             | 245.5         |
      | Divisional   | 10             | 198.2         |
      | Conference   | 6              | 142.8         |
      | Super Bowl   | 3              | 85.5          |
    When the Super Bowl completes
    Then jane_doe's total score is 672.0 points
    And eliminated player points are preserved from their active rounds
    And final season-long standings are calculated

  Scenario: Handle eliminated players in season-long contest
    Given player "bob_player" selected Davante Adams (Cowboys)
    And the Cowboys are eliminated in Wild Card round
    When Divisional round begins
    Then Davante Adams contributes 0 points for remaining rounds
    And bob_player's roster shows Adams as "ELIMINATED"
    And Adams's Wild Card points remain in bob_player's total

  Scenario: Display season-long leaderboard with round breakdowns
    Given a season-long contest has completed Conference Championships
    When any player views the leaderboard
    Then each entry shows:
      | Total Points        |
      | Wild Card Points    |
      | Divisional Points   |
      | Conference Points   |
      | Active Players Left |
      | Eliminated Players  |
    And entries are ranked by total points

  # ==================== PICK'EM CONTESTS ====================

  Scenario: Create a pick'em contest for straight-up game picks
    Given an admin is creating a pick'em contest
    When the admin configures:
      | Field              | Value                    |
      | name               | Playoff Pick'em Pool     |
      | type               | PICKEM                   |
      | pick_format        | STRAIGHT_UP              |
      | confidence_points  | false                    |
      | entry_fee          | 20.00                    |
    Then the pick'em contest is created
    And players can pick winners for each playoff game
    And each correct pick is worth 1 point

  Scenario: Create a pick'em contest with confidence points
    Given an admin is creating a confidence pool
    When the admin configures:
      | Field              | Value                    |
      | name               | Confidence Pick'em       |
      | type               | PICKEM                   |
      | pick_format        | CONFIDENCE               |
      | games_this_week    | 6                        |
    Then the contest uses confidence point scoring
    And players assign 1-6 confidence points to their 6 picks
    And each confidence value can only be used once

  Scenario: Submit pick'em selections with confidence points
    Given a confidence pick'em contest for Wild Card weekend
    And there are 6 playoff games
    When player "john_doe" submits picks:
      | Game                   | Pick     | Confidence |
      | Chiefs vs Dolphins     | Chiefs   | 6          |
      | Bills vs Ravens        | Bills    | 4          |
      | Cowboys vs Packers     | Cowboys  | 3          |
      | Eagles vs Giants       | Eagles   | 5          |
      | Lions vs Rams          | Lions    | 2          |
      | 49ers vs Seahawks      | 49ers    | 1          |
    Then the picks are validated
    And all confidence values 1-6 are used exactly once
    And the entry is accepted

  Scenario: Calculate pick'em contest standings
    Given a pick'em contest with confidence points
    And player "jane_doe" made the following picks:
      | Game                   | Pick     | Confidence | Result | Points |
      | Chiefs vs Dolphins     | Chiefs   | 6          | WIN    | 6      |
      | Bills vs Ravens        | Ravens   | 4          | LOSS   | 0      |
      | Cowboys vs Packers     | Cowboys  | 3          | WIN    | 3      |
    When standings are calculated
    Then jane_doe has 9 confidence points
    And standings rank by total confidence points earned
    And tiebreaker is total points scored in designated game

  Scenario: Apply pick'em tiebreaker
    Given a pick'em contest has completed
    And "john_doe" and "jane_doe" both have 18 correct points
    And the tiebreaker game is the Super Bowl
    And john_doe predicted 52 total points
    And jane_doe predicted 48 total points
    And the actual total was 51 points
    When tiebreaker is applied
    Then john_doe wins (52 is closer to 51 than 48)
    And john_doe is ranked higher in standings

  Scenario: Lock pick'em selections before game time
    Given a pick'em contest for Divisional round
    And the first game starts at 4:30 PM EST
    And player "bob_player" has not submitted picks
    When the time is 4:31 PM EST
    Then bob_player can no longer submit picks for that game
    And bob_player receives 0 points for that game
    And bob_player can still pick later games until their start time

  # ==================== PREDICTION CONTESTS ====================

  Scenario: Create a prediction contest with prop bets
    Given an admin is creating a prediction contest
    When the admin configures:
      | Field              | Value                    |
      | name               | Super Bowl Props Pool    |
      | type               | PREDICTION               |
      | prediction_format  | PROP_BETS                |
      | entry_fee          | 25.00                    |
    Then the prediction contest is created
    And admin can add prop bet questions

  Scenario: Add prop bet predictions to contest
    Given a prediction contest "Super Bowl Props Pool" exists
    When the admin adds prop bets:
      | Question                                    | Options               | Points |
      | Who will score the first touchdown?         | KC Offense, KC Defense, SF Offense, SF Defense | 5 |
      | Total passing yards by Mahomes              | Under 275, 275-325, Over 325 | 3 |
      | Will there be a safety?                     | Yes, No               | 2 |
      | Coin toss result                            | Heads, Tails          | 1 |
      | MVP of the game                             | [Player List]         | 10 |
    Then the prop bets are added to the contest
    And players can submit their predictions

  Scenario: Submit predictions for prop bets
    Given a prediction contest with 10 prop bets
    When player "alice_player" submits predictions for all 10 props
    Then the predictions are recorded
    And alice_player cannot modify after lock time
    And predictions are hidden from other players

  Scenario: Score prediction contest results
    Given a prediction contest has all prop results determined
    And player "john_doe" predictions:
      | Prop                          | Prediction  | Correct | Points |
      | First TD scorer               | KC Offense  | Yes     | 5      |
      | Mahomes passing yards         | 275-325     | No      | 0      |
      | Safety in game                | No          | Yes     | 2      |
    When scoring is complete
    Then john_doe has 7 prediction points
    And standings are calculated based on total correct prediction points

  Scenario: Create over/under prediction contest
    Given an admin is creating an over/under contest
    When the admin configures:
      | name               | Playoff Over/Under Challenge |
      | type               | PREDICTION                   |
      | prediction_format  | OVER_UNDER                   |
    Then players predict over or under for each stat line
    And correct predictions earn points

  Scenario: Submit over/under predictions
    Given an over/under prediction contest with questions:
      | Stat Line                                | Line  |
      | Patrick Mahomes Passing Yards            | 285.5 |
      | Derrick Henry Rushing Yards              | 95.5  |
      | Total Points in Chiefs Game              | 48.5  |
    When player "jane_doe" submits:
      | Stat Line                                | Prediction |
      | Patrick Mahomes Passing Yards            | OVER       |
      | Derrick Henry Rushing Yards              | UNDER      |
      | Total Points in Chiefs Game              | OVER       |
    Then the predictions are accepted
    And jane_doe is entered in the contest

  # ==================== SURVIVOR CONTESTS ====================

  Scenario: Create a survivor pool contest
    Given an admin is creating a survivor contest
    When the admin configures:
      | Field              | Value                    |
      | name               | Playoff Survivor Pool    |
      | type               | SURVIVOR                 |
      | format             | PICK_ONE_WINNER          |
      | reuse_teams        | false                    |
      | entry_fee          | 50.00                    |
    Then the survivor contest is created
    And players pick one winning team per week
    And teams cannot be reused once picked

  Scenario: Submit survivor pick for the week
    Given a survivor contest "Playoff Survivor Pool" exists
    And player "john_doe" has not used the Chiefs or Bills yet
    And it is Divisional round week
    When "john_doe" picks the Chiefs to win
    Then the pick is recorded
    And Chiefs are marked as used for john_doe
    And john_doe cannot pick Chiefs in future rounds

  Scenario: Eliminate player from survivor on incorrect pick
    Given player "bob_player" picked the Cowboys to win
    And the Cowboys lose their game
    When survivor results are processed
    Then bob_player is marked as "ELIMINATED"
    And bob_player cannot make picks in future weeks
    And bob_player's elimination round is recorded
    And bob_player can still view contest progress

  Scenario: Survive when picked team wins
    Given player "jane_doe" picked the Chiefs to win
    And the Chiefs win their game
    When survivor results are processed
    Then jane_doe survives to the next round
    And jane_doe must make a new pick next week
    And Chiefs are no longer available for jane_doe

  Scenario: Handle survivor pool with no available teams
    Given player "alice_player" has used 11 of 14 playoff teams
    And only 3 teams remain: Chiefs, Eagles, Lions
    And alice_player has already used Chiefs and Eagles
    When alice_player views pick options
    Then only Lions are available
    And alice_player must pick Lions or be eliminated

  Scenario: Determine survivor pool winner
    Given a survivor contest is in Conference Championship week
    And 3 players remain: john_doe, jane_doe, alice_player
    When john_doe and jane_doe pick correctly, alice_player picks incorrectly
    Then alice_player is eliminated
    And john_doe and jane_doe advance to Super Bowl week
    When both pick correctly in Super Bowl
    Then john_doe and jane_doe are co-winners
    And prize is split between them

  Scenario: Allow multiple strikes in survivor variant
    Given a survivor contest with 2 strikes allowed
    And player "bob_player" has 0 strikes
    When bob_player's pick loses
    Then bob_player receives strike 1
    And bob_player remains in the contest
    When bob_player's next pick also loses
    Then bob_player receives strike 2
    And bob_player is eliminated after 2 strikes

  # ==================== BEST BALL CONTESTS ====================

  Scenario: Create a best ball playoff contest
    Given an admin is creating a best ball contest
    When the admin configures:
      | Field              | Value                    |
      | name               | Playoff Best Ball        |
      | type               | BEST_BALL                |
      | roster_size        | 18                       |
      | starting_lineup    | QB, RB, RB, WR, WR, WR, TE, FLEX |
      | entry_fee          | 30.00                    |
    Then the best ball contest is created
    And players draft or select 18 players
    And optimal lineup is auto-calculated each week

  Scenario: Auto-calculate optimal best ball lineup
    Given player "john_doe" has a best ball roster:
      | Position | Player             | Week Score |
      | QB       | Patrick Mahomes    | 28.5       |
      | QB       | Josh Allen         | 32.0       |
      | RB       | Derrick Henry      | 22.5       |
      | RB       | Saquon Barkley     | 18.0       |
      | RB       | James Cook         | 15.5       |
      | WR       | Tyreek Hill        | 24.0       |
      | WR       | CeeDee Lamb        | 21.5       |
      | WR       | Amon-Ra St. Brown  | 19.0       |
      | WR       | Jaylen Waddle      | 12.5       |
      | TE       | Travis Kelce       | 18.5       |
      | TE       | Mark Andrews       | 14.0       |
    When the week's best ball lineup is calculated
    Then the optimal starting lineup is:
      | Position | Player             | Score |
      | QB       | Josh Allen         | 32.0  |
      | RB       | Derrick Henry      | 22.5  |
      | RB       | Saquon Barkley     | 18.0  |
      | WR       | Tyreek Hill        | 24.0  |
      | WR       | CeeDee Lamb        | 21.5  |
      | WR       | Amon-Ra St. Brown  | 19.0  |
      | TE       | Travis Kelce       | 18.5  |
      | FLEX     | James Cook         | 15.5  |
    And john_doe's week score is 171.0 points

  Scenario: Handle eliminated players in best ball
    Given player "jane_doe" has 3 Cowboys players on her best ball roster
    And the Cowboys are eliminated in Wild Card round
    When calculating best ball lineup for Divisional round
    Then Cowboys players score 0 points
    And remaining active players are used for optimal lineup
    And jane_doe's lineup depth is reduced

  Scenario: Track best ball roster depth
    Given a best ball contest is in Conference Championship
    And player "bob_player" started with 18 players
    And 10 of his players' teams have been eliminated
    When bob_player views roster status
    Then roster shows:
      | Active players         | 8        |
      | Eliminated players     | 10       |
      | Roster depth by position |        |
    And bob_player sees which positions have backup depth

  Scenario: Calculate cumulative best ball standings
    Given a best ball contest across all playoff rounds
    And player "alice_player" has weekly scores:
      | Week          | Optimal Score |
      | Wild Card     | 168.5         |
      | Divisional    | 142.0         |
      | Conference    | 98.5          |
      | Super Bowl    | 45.0          |
    When final standings are calculated
    Then alice_player's total is 454.0 points
    And standings rank by cumulative best ball score

  # ==================== BRACKET CONTESTS ====================

  Scenario: Create a bracket prediction contest
    Given an admin is creating a bracket contest
    When the admin configures:
      | Field              | Value                    |
      | name               | Playoff Bracket Challenge|
      | type               | BRACKET                  |
      | format             | PREDICT_ALL_GAMES        |
      | bonus_multiplier   | BY_ROUND                 |
      | entry_fee          | 15.00                    |
    Then the bracket contest is created
    And players predict all playoff game winners
    And later rounds are worth more points

  Scenario: Submit complete bracket predictions
    Given a bracket contest "Playoff Bracket Challenge" exists
    When player "john_doe" submits bracket predictions:
      | Round        | Game | Prediction |
      | Wild Card    | 1    | Chiefs     |
      | Wild Card    | 2    | Bills      |
      | Wild Card    | 3    | Eagles     |
      | Wild Card    | 4    | Cowboys    |
      | Wild Card    | 5    | Lions      |
      | Wild Card    | 6    | 49ers      |
      | Divisional   | 1    | Chiefs     |
      | Divisional   | 2    | Eagles     |
      | Divisional   | 3    | Lions      |
      | Divisional   | 4    | 49ers      |
      | Conference   | 1    | Chiefs     |
      | Conference   | 2    | 49ers      |
      | Super Bowl   | 1    | Chiefs     |
    Then the bracket is accepted
    And john_doe's champion pick is Chiefs
    And all predictions are locked before Wild Card

  Scenario: Score bracket predictions with round multipliers
    Given a bracket contest with scoring:
      | Round        | Points Per Correct Pick |
      | Wild Card    | 1                       |
      | Divisional   | 2                       |
      | Conference   | 4                       |
      | Super Bowl   | 8                       |
    And player "jane_doe" correctly predicted:
      | Round        | Correct Picks |
      | Wild Card    | 5 of 6        |
      | Divisional   | 3 of 4        |
      | Conference   | 1 of 2        |
      | Super Bowl   | 1 of 1        |
    When bracket scoring is calculated
    Then jane_doe's score is: 5*1 + 3*2 + 1*4 + 1*8 = 23 points

  Scenario: Track bracket survival (correct champion still alive)
    Given player "bob_player" picked Chiefs as champion
    And Chiefs win Wild Card game
    When bracket status is updated
    Then bob_player's champion pick is marked "ALIVE"
    And bob_player still has a chance to earn champion bonus

  Scenario: Eliminate bracket champion picks
    Given player "alice_player" picked Cowboys as champion
    And Cowboys lose in Wild Card round
    When bracket status is updated
    Then alice_player's champion pick is marked "ELIMINATED"
    And alice_player cannot earn champion bonus points
    And alice_player can still earn points for other correct picks

  Scenario: Award champion bonus points
    Given a bracket contest with 10-point champion bonus
    And player "john_doe" correctly predicted Chiefs as champion
    And Chiefs win the Super Bowl
    When final bracket scoring is calculated
    Then john_doe receives 10 bonus points for correct champion
    And john_doe's total includes all round points plus bonus

  Scenario: Display bracket visualization
    Given a bracket contest is in progress
    When any player views the bracket
    Then the display shows:
      | All submitted predictions     |
      | Actual game results           |
      | Correct picks highlighted     |
      | Incorrect picks crossed out   |
      | Pending games in current round|
      | Champion pick status          |

  # ==================== CONTEST PRIZES ====================

  Scenario: Configure prize pool distribution
    Given an admin is configuring a contest prize structure
    When the admin sets prize distribution:
      | Place | Percentage |
      | 1st   | 50%        |
      | 2nd   | 25%        |
      | 3rd   | 15%        |
      | 4th   | 10%        |
    Then the prize structure is saved
    And total distribution equals 100%
    And players can view prize breakdown before entering

  Scenario: Calculate prize pool from entry fees
    Given a contest with $25 entry fee
    And 100 players have entered
    And the platform takes 10% rake
    When prize pool is calculated
    Then gross pool is $2500
    And platform rake is $250
    And net prize pool is $2250
    And prizes are distributed:
      | Place | Prize   |
      | 1st   | $1125   |
      | 2nd   | $562.50 |
      | 3rd   | $337.50 |
      | 4th   | $225    |

  Scenario: Handle prize ties
    Given a contest has completed
    And "john_doe" and "jane_doe" are tied for 2nd place
    And 2nd place prize is $500
    And 3rd place prize is $250
    When prizes are distributed
    Then 2nd and 3rd prizes are combined: $750
    And john_doe receives $375
    And jane_doe receives $375
    And 4th place receives original 4th place prize

  Scenario: Award guaranteed prize pool
    Given a contest with guaranteed $5000 prize pool
    And only 150 entries at $25 each ($3375 after rake)
    When the contest completes
    Then prizes are based on $5000 guarantee
    And the platform covers the $1625 overlay
    And winners receive full guaranteed amounts

  Scenario: Distribute prizes to player accounts
    Given a contest has completed with final standings
    And prize distribution is calculated
    When prizes are awarded
    Then winner balances are credited
    And prize transactions are recorded
    And tax documentation is generated for large prizes
    And winners receive prize notification

  Scenario: Configure weekly prizes in season-long contest
    Given a season-long contest with weekly prizes
    When the admin configures:
      | Prize Type     | Amount Per Week |
      | Weekly Winner  | $100            |
      | Top Scorer     | $50             |
    Then weekly prizes are awarded each round
    And season-long grand prize is separate
    And players can win both weekly and season prizes

  Scenario: Award milestone prizes
    Given a contest with milestone achievements
    And achievements configured:
      | Achievement                    | Prize |
      | First to 200 points           | $25   |
      | Highest single week score     | $50   |
      | Perfect Wild Card predictions | $100  |
    When milestones are achieved
    Then milestone prizes are awarded immediately
    And achievements are displayed on leaderboard

  # ==================== CONTEST MANAGEMENT ====================

  Scenario: Set contest entry period
    Given an admin is creating a contest
    When the admin sets entry period:
      | Open Date   | 2025-01-08 00:00 EST |
      | Close Date  | 2025-01-11 12:00 EST |
    Then the contest opens for entry at the specified time
    And the contest closes entry before first game
    And late entries are rejected after close time

  Scenario: Cancel contest with refunds
    Given a contest "Weekly Pool" has 50 entries
    And entry fee was $25 each
    When the admin cancels the contest with reason "Insufficient entries"
    Then all 50 entries are refunded $25 each
    And refund transactions are recorded
    And players receive cancellation notification
    And the contest is marked as "CANCELLED"

  Scenario: Modify contest before entry opens
    Given a contest is created but entry has not opened
    When the admin modifies:
      | Field       | Old Value | New Value |
      | entry_fee   | $25       | $20       |
      | max_entries | 500       | 750       |
    Then the changes are applied
    And no player notification is required

  Scenario: Restrict contest modifications after entries exist
    Given a contest has 100 existing entries
    When the admin attempts to modify entry_fee
    Then the modification is rejected
    And error message is "Cannot modify entry fee with existing entries"
    And admin can only modify non-financial fields

  Scenario: Pause contest entry
    Given a contest is accepting entries
    And there is a technical issue
    When the admin pauses entry
    Then new entries are blocked
    And existing entries are preserved
    And message "Entry temporarily paused" is displayed
    And admin can resume entry later

  Scenario: View contest dashboard
    Given an admin is managing active contests
    When the admin views the contest dashboard
    Then the display shows:
      | Contest name           |
      | Entry count            |
      | Prize pool             |
      | Status                 |
      | Time until lock        |
      | Current leader         |
    And admin can drill into any contest for details

  Scenario: Export contest results
    Given a contest has completed
    When the admin exports results
    Then a CSV file is generated with:
      | Rank                  |
      | Player username       |
      | Final score           |
      | Prize won             |
      | Entry details         |
    And the export can be downloaded

  Scenario: Handle dispute resolution
    Given a player "john_doe" disputes their contest result
    And the dispute is about scoring error
    When admin reviews the dispute
    Then admin can view:
      | Player's entry details        |
      | Scoring audit trail           |
      | NFL data source records       |
    And admin can adjust score if warranted
    And all adjustments are logged with reason

  Scenario: Archive completed contests
    Given a contest completed 30 days ago
    And all prizes have been distributed
    When the archival job runs
    Then contest data is moved to archive storage
    And contest remains viewable but read-only
    And historical records are preserved
    And active contest performance is not impacted

  # ==================== CONTEST ENTRY VALIDATION ====================

  Scenario: Prevent duplicate entries in single-entry contest
    Given a single-entry contest exists
    And player "john_doe" has already entered
    When "john_doe" attempts to enter again
    Then the entry is rejected
    And error message is "You have already entered this contest"

  Scenario: Validate player eligibility for contest
    Given a contest with eligibility requirements:
      | Requirement          | Value        |
      | Minimum account age  | 7 days       |
      | Email verified       | true         |
      | Location             | US only      |
    When a new player attempts to enter
    And their account is 3 days old
    Then entry is rejected
    And error message is "Account must be at least 7 days old"

  Scenario: Validate sufficient balance for entry
    Given a contest with $50 entry fee
    And player "bob_player" has $35 balance
    When "bob_player" attempts to enter
    Then entry is rejected
    And error message is "Insufficient balance. Need $50, have $35"
    And player is prompted to add funds

  Scenario: Apply promo code to contest entry
    Given a contest with $25 entry fee
    And a valid promo code "PLAYOFF25" for 25% off
    When player "jane_doe" enters with promo code "PLAYOFF25"
    Then entry fee is reduced to $18.75
    And jane_doe's balance is charged $18.75
    And promo code usage is recorded

  Scenario: Validate roster completeness
    Given a contest requiring 9 roster positions
    When player "alice_player" submits with only 8 positions filled
    Then the entry is rejected
    And error message is "Roster incomplete: missing 1 position"
    And the incomplete position is identified

  # ==================== CONTEST NOTIFICATIONS ====================

  Scenario: Notify players of contest opening
    Given a contest is scheduled to open
    And 500 players have enabled contest notifications
    When the contest opens for entry
    Then notification is sent to interested players:
      | type    | PUSH, EMAIL                       |
      | title   | New Contest Available             |
      | body    | Wild Card Weekly Pool is now open |
    And notification links to contest entry page

  Scenario: Send lineup lock reminder
    Given a contest locks in 1 hour
    And player "john_doe" has not submitted an entry
    And john_doe has enabled reminders
    When the 1-hour reminder triggers
    Then john_doe receives notification:
      | title | Entry Reminder                    |
      | body  | Contest locks in 1 hour - submit now |

  Scenario: Notify winner of prize
    Given a contest has completed
    And player "jane_doe" won 1st place and $500
    When prizes are distributed
    Then jane_doe receives notification:
      | title | Congratulations! You Won!         |
      | body  | 1st Place - $500 added to balance |
    And notification includes contest summary

  Scenario: Notify players of contest results
    Given a contest has completed
    When results are finalized
    Then all entrants receive results notification:
      | title | Contest Results: Wild Card Pool |
      | body  | Final standings are in. You placed 15th |
    And notification includes link to full standings

  # ==================== CONTEST ERROR HANDLING ====================

  Scenario: Handle payment processing failure during entry
    Given player "bob_player" is entering a contest
    When payment processing fails due to timeout
    Then the entry is not created
    And bob_player's balance is not charged
    And error message is "Payment processing failed. Please try again."
    And the failure is logged for review

  Scenario: Handle scoring service unavailability
    Given a contest is in progress
    When the NFL data source becomes unavailable
    Then last known scores are displayed
    And "Scores temporarily delayed" message is shown
    And system retries data fetch with exponential backoff
    And contest timing is not affected

  Scenario: Handle concurrent entry submissions
    Given a contest has 1 spot remaining (max_entries = 999, current = 998)
    When players "john_doe" and "jane_doe" submit entries simultaneously
    Then exactly one entry is accepted
    And the other is rejected with "Contest is full"
    And race condition is handled atomically

  Scenario: Recover from contest state corruption
    Given a contest has inconsistent state
    And player count does not match entry records
    When admin runs contest validation
    Then discrepancies are identified
    And admin can reconcile state
    And audit log records the correction
    And players are notified if affected

  Scenario: Handle timezone issues for entry deadlines
    Given a contest locks at "1:00 PM EST"
    And player "alice_player" is in PST timezone
    When alice_player views the contest
    Then lock time is displayed as "10:00 AM PST"
    And all deadline enforcement uses server time (EST)
    And timezone confusion is prevented
