Feature: Player Roster Selection and Draft System (ONE-TIME DRAFT MODEL)
  As a league player
  I want to build my roster by drafting individual NFL players ONCE before the season
  So that I can compete with my locked roster for the entire season

  CRITICAL RULE: This is a ONE-TIME DRAFT MODEL
  - Rosters are built ONCE before the first game starts
  - Once the first game starts, rosters are PERMANENTLY LOCKED
  - NO changes allowed after lock: no waiver wire, no trades, no weekly adjustments
  - League players compete with their locked rosters for all configured weeks

  Background:
    Given the league "2025 Playoffs League" exists
    And the league has the following roster configuration:
      | position   | count | eligiblePositions      |
      | QB         | 1     | QB                     |
      | RB         | 2     | RB                     |
      | WR         | 2     | WR                     |
      | TE         | 1     | TE                     |
      | K          | 1     | K                      |
      | DEF        | 1     | DEF                    |
      | FLEX       | 1     | RB,WR,TE               |
      | SUPERFLEX  | 1     | QB,RB,WR,TE            |
    And the league has 12 league players
    And I am authenticated as league player "john_player"
    And the following NFL players exist:
      | id  | name              | position | team |
      | 101 | Patrick Mahomes   | QB       | KC   |
      | 102 | Josh Allen        | QB       | BUF  |
      | 103 | Christian McCaffrey| RB      | SF   |
      | 104 | Derrick Henry     | RB       | BAL  |
      | 105 | Tyreek Hill       | WR       | MIA  |
      | 106 | CeeDee Lamb       | WR       | DAL  |
      | 107 | Travis Kelce      | TE       | KC   |
      | 108 | Justin Tucker     | K        | BAL  |
      | 109 | SF 49ers Defense  | DEF      | SF   |

  # Basic Draft Scenarios

  Scenario: League player successfully drafts NFL player to standard position
    Given my roster is empty
    When I draft NFL player "Patrick Mahomes" (id: 101) to position "QB"
    Then the draft should succeed
    And my roster should have "Patrick Mahomes" in position "QB"
    And "Patrick Mahomes" remains available to all other league players
    And my roster completion should be "1/10"

  Scenario: League player drafts multiple NFL players to fill roster
    Given my roster is empty
    When I draft the following NFL players:
      | nflPlayerId | position   |
      | 101         | QB         |
      | 103         | RB         |
      | 104         | RB         |
      | 105         | WR         |
      | 106         | WR         |
    Then all drafts should succeed
    And my roster completion should be "5/10"
    And I should have 5 roster slots remaining

  Scenario: League player cannot draft NFL player to incompatible position
    Given my roster is empty
    When I attempt to draft NFL player "Patrick Mahomes" (id: 101) to position "RB"
    Then the draft should fail
    And I should receive error "POSITION_MISMATCH"
    And the error message should be "Patrick Mahomes (QB) cannot be drafted to RB position"
    And my roster should remain empty

  # FLEX Position Scenarios

  Scenario: League player drafts Running Back to FLEX position
    Given my roster is empty
    And I have already drafted:
      | nflPlayerId | position |
      | 103         | RB       |
      | 104         | RB       |
    When I draft NFL player "Derrick Henry" (id: 110) to position "FLEX"
    And "Derrick Henry" has position "RB"
    Then the draft should succeed
    And my roster should have "Derrick Henry" in position "FLEX"

  Scenario: League player drafts Wide Receiver to FLEX position
    Given my roster is empty
    When I draft NFL player "Tyreek Hill" (id: 105) to position "FLEX"
    And "Tyreek Hill" has position "WR"
    Then the draft should succeed
    And my roster should have "Tyreek Hill" in position "FLEX"

  Scenario: League player drafts Tight End to FLEX position
    Given my roster is empty
    When I draft NFL player "Travis Kelce" (id: 107) to position "FLEX"
    And "Travis Kelce" has position "TE"
    Then the draft should succeed
    And my roster should have "Travis Kelce" in position "FLEX"

  Scenario: League player cannot draft Quarterback to FLEX position
    Given my roster is empty
    When I attempt to draft NFL player "Patrick Mahomes" (id: 101) to position "FLEX"
    Then the draft should fail
    And I should receive error "POSITION_NOT_ELIGIBLE_FOR_FLEX"
    And the error message should be "QB is not eligible for FLEX position (accepts: RB, WR, TE)"

  Scenario: League player cannot draft Kicker to FLEX position
    Given my roster is empty
    When I attempt to draft NFL player "Justin Tucker" (id: 108) to position "FLEX"
    Then the draft should fail
    And I should receive error "POSITION_NOT_ELIGIBLE_FOR_FLEX"
    And the error message should be "K is not eligible for FLEX position (accepts: RB, WR, TE)"

  # SUPERFLEX Position Scenarios

  Scenario: League player drafts Quarterback to SUPERFLEX position
    Given my roster is empty
    And I have already drafted:
      | nflPlayerId | position |
      | 101         | QB       |
    When I draft NFL player "Josh Allen" (id: 102) to position "SUPERFLEX"
    And "Josh Allen" has position "QB"
    Then the draft should succeed
    And my roster should have "Josh Allen" in position "SUPERFLEX"

  Scenario: League player drafts Running Back to SUPERFLEX position
    Given my roster is empty
    When I draft NFL player "Christian McCaffrey" (id: 103) to position "SUPERFLEX"
    Then the draft should succeed
    And my roster should have "Christian McCaffrey" in position "SUPERFLEX"

  Scenario: League player drafts Wide Receiver to SUPERFLEX position
    Given my roster is empty
    When I draft NFL player "CeeDee Lamb" (id: 106) to position "SUPERFLEX"
    Then the draft should succeed
    And my roster should have "CeeDee Lamb" in position "SUPERFLEX"

  Scenario: League player drafts Tight End to SUPERFLEX position
    Given my roster is empty
    When I draft NFL player "Travis Kelce" (id: 107) to position "SUPERFLEX"
    Then the draft should succeed
    And my roster should have "Travis Kelce" in position "SUPERFLEX"

  Scenario: League player cannot draft Kicker to SUPERFLEX position
    Given my roster is empty
    When I attempt to draft NFL player "Justin Tucker" (id: 108) to position "SUPERFLEX"
    Then the draft should fail
    And I should receive error "POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX"
    And the error message should be "K is not eligible for SUPERFLEX position (accepts: QB, RB, WR, TE)"

  Scenario: League player cannot draft Defense to SUPERFLEX position
    Given my roster is empty
    When I attempt to draft NFL player "SF 49ers Defense" (id: 109) to position "SUPERFLEX"
    Then the draft should fail
    And I should receive error "POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX"
    And the error message should be "DEF is not eligible for SUPERFLEX position (accepts: QB, RB, WR, TE)"

  # Duplicate Player Prevention

  Scenario: League player cannot draft same NFL player twice to different positions
    Given I have already drafted "Travis Kelce" (id: 107) to position "TE"
    When I attempt to draft "Travis Kelce" (id: 107) to position "FLEX"
    Then the draft should fail
    And I should receive error "PLAYER_ALREADY_DRAFTED"
    And the error message should be "You have already drafted Travis Kelce to position TE"
    And my TE position should still have "Travis Kelce"
    And my FLEX position should be empty

  Scenario: League player cannot draft same NFL player twice to same position
    Given I have already drafted "Christian McCaffrey" (id: 103) to first RB slot
    When I attempt to draft "Christian McCaffrey" (id: 103) to second RB slot
    Then the draft should fail
    And I should receive error "PLAYER_ALREADY_DRAFTED"
    And the error message should be "You have already drafted Christian McCaffrey to position RB"

  Scenario: Different league players can draft different NFL players
    Given league player "player1" drafted "Patrick Mahomes" (id: 101)
    And I am league player "player2"
    When I draft NFL player "Josh Allen" (id: 102) to position "QB"
    Then the draft should succeed
    And my roster should have "Josh Allen" in position "QB"
    And "player1" should still have "Patrick Mahomes"
    And "player2" should have "Josh Allen"

  # No Ownership Model - Multiple League Players Can Select Same NFL Player

  Scenario: Multiple league players can draft the same NFL player (no ownership model)
    Given all NFL players are available
    When league player "player1" drafts "Patrick Mahomes" (id: 101) to position "QB"
    Then the draft should succeed
    And league player "player1" roster should have "Patrick Mahomes"
    When league player "player2" drafts "Patrick Mahomes" (id: 101) to position "SUPERFLEX"
    Then the draft should succeed
    And league player "player2" roster should have "Patrick Mahomes"
    And "Patrick Mahomes" should be available to all other league members
    And there is NO exclusive ownership of NFL players

  Scenario: League player views ALL NFL players filtered by position (no availability filtering)
    Given league player "player1" has drafted:
      | nflPlayerId | name            | position |
      | 101         | Patrick Mahomes | QB       |
    And league player "player2" has drafted:
      | nflPlayerId | name            | position |
      | 101         | Patrick Mahomes | QB       |
    When I request NFL players for position "QB"
    Then I should see ALL QB players including "Patrick Mahomes"
    And I should see ALL QB players including "Josh Allen"
    And all players should be marked as "AVAILABLE" regardless of who drafted them
    And the UI should show that other league members have selected these players (for informational purposes only)

  Scenario: League player views ALL NFL players for FLEX position (no ownership restrictions)
    Given league player "player1" has drafted:
      | nflPlayerId | name                 | position |
      | 103         | Christian McCaffrey  | RB       |
    And league player "player2" has drafted:
      | nflPlayerId | name                 | position |
      | 105         | Tyreek Hill          | WR       |
    And league player "player3" has drafted:
      | nflPlayerId | name                 | position |
      | 107         | Travis Kelce         | TE       |
    When I request NFL players for position "FLEX"
    Then I should see ALL RB players including "Christian McCaffrey"
    And I should see ALL WR players including "Tyreek Hill"
    And I should see ALL TE players including "Travis Kelce"
    And I should NOT see QB players
    And I should NOT see K players
    And I should NOT see DEF players
    And all FLEX-eligible players remain available to all league members

  # Roster Validation

  Scenario: League player cannot exceed position limit
    Given I have already drafted 2 Running Backs:
      | nflPlayerId | position |
      | 103         | RB       |
      | 104         | RB       |
    And the league allows maximum 2 RB positions
    When I attempt to draft NFL player "Jahmyr Gibbs" (id: 120) to position "RB"
    Then the draft should fail
    And I should receive error "POSITION_LIMIT_EXCEEDED"
    And the error message should be "RB position slots are full (2/2)"

  Scenario: League player can fill FLEX after filling standard RB positions
    Given I have already drafted 2 Running Backs:
      | nflPlayerId | position |
      | 103         | RB       |
      | 104         | RB       |
    When I draft NFL player "Jahmyr Gibbs" (id: 120, RB) to position "FLEX"
    Then the draft should succeed
    And my FLEX position should have "Jahmyr Gibbs"
    And my RB positions should remain full

  Scenario: League player validates roster is complete before league starts
    Given the league has not started
    And I have drafted 9 out of 10 required positions
    When I request roster validation
    Then the validation should fail
    And I should receive message "Roster incomplete: 1 position remaining"
    And I should see "SUPERFLEX position is empty"

  Scenario: League player has complete roster
    Given I have drafted the following complete roster:
      | position   | nflPlayerId | name                |
      | QB         | 101         | Patrick Mahomes     |
      | RB         | 103         | Christian McCaffrey |
      | RB         | 104         | Derrick Henry       |
      | WR         | 105         | Tyreek Hill         |
      | WR         | 106         | CeeDee Lamb         |
      | TE         | 107         | Travis Kelce        |
      | K          | 108         | Justin Tucker       |
      | DEF        | 109         | SF 49ers Defense    |
      | FLEX       | 110         | A.J. Brown (WR)     |
      | SUPERFLEX  | 102         | Josh Allen (QB)     |
    When I request roster validation
    Then the validation should succeed
    And I should receive message "Roster is complete (10/10)"
    And my roster status should be "READY"

  # Draft Order Scenarios

  Scenario: Snake draft order - Round 1 forward, Round 2 backward
    Given the league uses "SNAKE" draft order
    And there are 4 league players: player1, player2, player3, player4
    And it is round 1 of the draft
    Then the draft order should be: player1, player2, player3, player4
    When round 2 begins
    Then the draft order should be: player4, player3, player2, player1

  Scenario: Linear draft order - Same order every round
    Given the league uses "LINEAR" draft order
    And there are 4 league players: player1, player2, player3, player4
    And it is round 1 of the draft
    Then the draft order should be: player1, player2, player3, player4
    When round 2 begins
    Then the draft order should be: player1, player2, player3, player4

  Scenario: League player drafts out of turn in snake draft
    Given the league uses "SNAKE" draft order
    And it is "player2"'s turn to draft
    And I am "player3"
    When I attempt to draft NFL player "Patrick Mahomes" (id: 101)
    Then the draft should fail
    And I should receive error "NOT_YOUR_TURN"
    And the error message should be "It is player2's turn to draft"

  Scenario: League player auto-pick when draft time expires
    Given the league has a 90-second draft timer
    And it is my turn to draft
    And I have not made a selection
    When 90 seconds elapse
    Then the system should auto-draft the highest-ranked available NFL player
    And the auto-drafted player should fill my most critical empty position
    And I should receive notification "Auto-drafted [player] to [position] due to timeout"

  Scenario: League player views current draft status
    Given the league is in active draft mode
    And 45 picks have been made
    And there are 12 league players
    And each roster requires 10 players
    When I request draft status
    Then I should see:
      | totalPicks        | 45                |
      | totalPicksNeeded  | 120               |
      | currentRound      | 4                 |
      | pickInRound       | 9                 |
      | onTheClock        | player9           |
      | nextUp            | player10, player11|

  # Dropping/Replacing Players (ONLY BEFORE ROSTER LOCK)

  Scenario: League player drops NFL player before first game starts
    Given the first game starts at "2025-01-12 13:00:00 ET"
    And the current time is "2025-01-12 10:00:00 ET"
    And I have drafted "Christian McCaffrey" (id: 103) to position "RB"
    When I drop "Christian McCaffrey" from my roster
    Then the drop should succeed
    And "Christian McCaffrey" should be removed from my roster
    And "Christian McCaffrey" remains available to all league players
    And my RB position should have 1 empty slot

  Scenario: League player CANNOT drop NFL player after first game starts (PERMANENT LOCK)
    Given the first game started at "2025-01-12 13:00:00 ET"
    And the current time is "2025-01-12 13:01:00 ET"
    And I have drafted "Christian McCaffrey" (id: 103) to position "RB"
    When I attempt to drop "Christian McCaffrey" from my roster
    Then the drop should fail
    And I should receive error "ROSTER_PERMANENTLY_LOCKED"
    And the error message should be "Roster is permanently locked - no changes allowed after first game starts"
    And "Christian McCaffrey" remains on my roster for the entire season

  Scenario: League player replaces NFL player before first game starts
    Given the first game starts at "2025-01-12 13:00:00 ET"
    And the current time is "2025-01-12 10:00:00 ET"
    And I have drafted "Travis Kelce" (id: 107) to position "TE"
    And "George Kittle" (id: 115) is available
    When I replace "Travis Kelce" with "George Kittle" in position "TE"
    Then the replacement should succeed
    And my TE position should have "George Kittle"
    And "Travis Kelce" remains available to all other league players
    And "George Kittle" remains available to all other league players

  # Roster Lock and Deadline (PERMANENT LOCK - NO CHANGES FOR ENTIRE SEASON)

  Scenario: Roster PERMANENTLY locks when first game starts
    Given the first game of the season starts at "2025-01-12 13:00:00 ET"
    And I have a complete roster
    And the current time is "2025-01-12 12:59:59 ET"
    When I attempt to draft another NFL player
    Then the draft should succeed
    When the current time becomes "2025-01-12 13:00:00 ET"
    And I attempt to make any roster changes
    Then the changes should fail
    And I should receive error "ROSTER_PERMANENTLY_LOCKED"
    And the error message should be "Roster is permanently locked for the entire season - no changes allowed"

  Scenario: League player with incomplete roster at first game start (LOCKED FOREVER)
    Given the first game starts at "2025-01-12 13:00:00 ET"
    And I have only drafted 7 out of 10 required players
    And the current time becomes "2025-01-12 13:00:00 ET"
    Then my roster should be permanently locked
    And my roster status should be "INCOMPLETE_LOCKED"
    And I should receive warning "Your roster is incomplete and permanently locked - you will receive 0 points for empty positions for all weeks"

  Scenario: NO roster changes allowed for entire season after lock
    Given the first game started at "2025-01-12 13:00:00 ET"
    And we are now in week 10 of the season
    And I have "Christian McCaffrey" on my roster
    And "Christian McCaffrey" is injured and will miss remaining games
    When I attempt to replace "Christian McCaffrey"
    Then the change should fail
    And I should receive error "ROSTER_PERMANENTLY_LOCKED"
    And the error message should be "No roster changes allowed - this is a one-time draft model"
    And I must keep "Christian McCaffrey" on my roster despite injury

  Scenario: League player warned about permanent roster lock before first game
    Given the first game starts at "2025-01-12 13:00:00 ET"
    And the current time is "2025-01-12 11:00:00 ET"
    When I view my roster
    Then I should see a prominent warning "PERMANENT ROSTER LOCK in 2 hours"
    And I should see "After first game starts, NO changes allowed for entire season"
    And I should see "Complete and finalize your roster now"

  Scenario: All roster modification endpoints disabled after lock
    Given the first game started at "2025-01-12 13:00:00 ET"
    When I attempt to access any roster modification endpoint:
      | /api/v1/player/roster/draft        |
      | /api/v1/player/roster/drop         |
      | /api/v1/player/roster/replace      |
      | /api/v1/player/roster/trade        |
    Then all requests should return HTTP 403 Forbidden
    And error message should be "ROSTER_PERMANENTLY_LOCKED"

  # Multiple RB/WR Slot Scenarios

  Scenario: League player fills first RB slot, then second RB slot
    Given my roster is empty
    When I draft "Christian McCaffrey" (id: 103) to position "RB"
    Then the draft should succeed
    And "Christian McCaffrey" should occupy RB slot 1
    When I draft "Derrick Henry" (id: 104) to position "RB"
    Then the draft should succeed
    And "Derrick Henry" should occupy RB slot 2
    And I should have 0 RB slots remaining

  Scenario: League player views roster with multiple slots per position
    Given I have drafted:
      | position | slot | nflPlayer           |
      | RB       | 1    | Christian McCaffrey |
      | RB       | 2    | Derrick Henry       |
      | WR       | 1    | Tyreek Hill         |
      | WR       | 2    | CeeDee Lamb         |
    When I view my roster
    Then I should see positions displayed as:
      | position | players                              |
      | RB (2)   | Christian McCaffrey, Derrick Henry   |
      | WR (2)   | Tyreek Hill, CeeDee Lamb             |

  # Edge Cases and Validations

  Scenario: League player attempts to draft non-existent NFL player
    Given NFL player with id 99999 does not exist
    When I attempt to draft NFL player with id 99999 to position "QB"
    Then the draft should fail
    And I should receive error "PLAYER_NOT_FOUND"
    And the error message should be "NFL player with id 99999 not found"

  Scenario: League player attempts to draft to non-existent position
    Given my roster configuration does not include "WR3" position
    When I attempt to draft NFL player "Tyreek Hill" (id: 105) to position "WR3"
    Then the draft should fail
    And I should receive error "POSITION_NOT_IN_CONFIGURATION"
    And the error message should be "Position WR3 is not configured for this league"

  Scenario: League player attempts to draft inactive NFL player
    Given NFL player "Andrew Luck" (id: 200) has status "RETIRED"
    When I attempt to draft "Andrew Luck" (id: 200) to position "QB"
    Then the draft should fail
    And I should receive error "PLAYER_INACTIVE"
    And the error message should be "Andrew Luck is not active (status: RETIRED)"

  Scenario: League player attempts to draft injured NFL player on IR
    Given NFL player "Aaron Rodgers" (id: 201) has status "INJURED_RESERVE"
    And the league allows drafting IR players
    When I draft "Aaron Rodgers" (id: 201) to position "QB"
    Then the draft should succeed
    And I should receive warning "Aaron Rodgers is on Injured Reserve"
    And "Aaron Rodgers" should be marked with IR designation

  Scenario Outline: Position eligibility validation matrix
    Given NFL player "<player>" has position "<nflPosition>"
    When I attempt to draft this player to roster position "<rosterPosition>"
    Then the draft should <result>

    Examples:
      | player          | nflPosition | rosterPosition | result  |
      | Patrick Mahomes | QB          | QB             | succeed |
      | Patrick Mahomes | QB          | SUPERFLEX      | succeed |
      | Patrick Mahomes | QB          | FLEX           | fail    |
      | Patrick Mahomes | QB          | RB             | fail    |
      | Derrick Henry   | RB          | RB             | succeed |
      | Derrick Henry   | RB          | FLEX           | succeed |
      | Derrick Henry   | RB          | SUPERFLEX      | succeed |
      | Derrick Henry   | RB          | QB             | fail    |
      | Tyreek Hill     | WR          | WR             | succeed |
      | Tyreek Hill     | WR          | FLEX           | succeed |
      | Tyreek Hill     | WR          | SUPERFLEX      | succeed |
      | Tyreek Hill     | WR          | TE             | fail    |
      | Travis Kelce    | TE          | TE             | succeed |
      | Travis Kelce    | TE          | FLEX           | succeed |
      | Travis Kelce    | TE          | SUPERFLEX      | succeed |
      | Travis Kelce    | TE          | WR             | fail    |
      | Justin Tucker   | K           | K              | succeed |
      | Justin Tucker   | K           | FLEX           | fail    |
      | Justin Tucker   | K           | SUPERFLEX      | fail    |
      | SF 49ers        | DEF         | DEF            | succeed |
      | SF 49ers        | DEF         | FLEX           | fail    |
      | SF 49ers        | DEF         | SUPERFLEX      | fail    |
