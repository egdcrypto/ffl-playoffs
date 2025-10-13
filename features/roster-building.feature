Feature: Roster Building with Individual NFL Player Selection
  As a league player
  I want to select individual NFL players by position to build my roster
  So that I can compete with my personalized team throughout the season

  Background:
    Given a league "Championship 2024" exists with roster configuration:
      | Position   | Count | Eligible Positions    |
      | QB         | 1     | QB                    |
      | RB         | 2     | RB                    |
      | WR         | 2     | WR                    |
      | TE         | 1     | TE                    |
      | FLEX       | 1     | RB, WR, TE            |
      | K          | 1     | K                     |
      | DEF        | 1     | DEF                   |
    And the league total roster size is 9 positions
    And a PLAYER user is a member of the league
    And the roster lock deadline has not passed

  Scenario: Player selects NFL quarterback for QB position
    Given the player has an empty roster
    And an NFL player "Patrick Mahomes" exists with position QB
    When the player selects "Patrick Mahomes" for the QB roster slot
    Then a RosterSelection is created linking "Patrick Mahomes" to the QB slot
    And the roster now has 1 of 9 positions filled
    And the QB position shows "Patrick Mahomes (QB - KC)"

  Scenario: Player selects running backs for RB positions
    Given the roster requires 2 RB positions
    And NFL players exist: "Christian McCaffrey" (RB) and "Derrick Henry" (RB)
    When the player selects "Christian McCaffrey" for RB slot 1
    And the player selects "Derrick Henry" for RB slot 2
    Then both RB positions are filled
    And the roster shows both running backs

  Scenario: Player selects NFL player for FLEX position
    Given the FLEX position accepts RB, WR, or TE
    And an NFL player "Travis Kelce" exists with position TE
    When the player selects "Travis Kelce" for the FLEX roster slot
    Then the FLEX position is filled with a TE
    And the selection is valid

  Scenario: Player attempts to select ineligible position for slot
    Given the QB position only accepts QB players
    And an NFL player "Christian McCaffrey" exists with position RB
    When the player attempts to select "Christian McCaffrey" for the QB slot
    Then the selection is rejected with error "POSITION_MISMATCH"
    And the QB slot remains empty
    And the player is shown eligible positions: QB

  Scenario: Player selects kicker for K position
    Given an NFL player "Justin Tucker" exists with position K
    When the player selects "Justin Tucker" for the K roster slot
    Then the K position is filled
    And the roster shows "Justin Tucker (K - BAL)"

  Scenario: Player selects team defense for DEF position
    Given an NFL team defense "San Francisco 49ers" exists with position DEF
    When the player selects "San Francisco 49ers" for the DEF roster slot
    Then the DEF position is filled
    And the roster shows "San Francisco 49ers (DEF)"

  Scenario: Player searches for NFL players by name
    Given 500 NFL players exist in the database
    When the player searches for "Mahomes"
    Then the system returns players matching "Mahomes"
    And the results include "Patrick Mahomes (QB - KC)"
    And the results are paginated with 25 players per page

  Scenario: Player filters NFL players by position
    Given 32 NFL quarterbacks exist
    When the player filters by position QB
    Then the system returns all quarterbacks
    And the results are sorted alphabetically by last name

  Scenario: Player filters NFL players by NFL team
    Given multiple players belong to "Kansas City Chiefs"
    When the player filters by NFL team "Kansas City Chiefs"
    Then the system returns all Chiefs players
    And the results include positions: QB, RB, WR, TE, K, DEF

  Scenario: Player views NFL player statistics
    Given an NFL player "Patrick Mahomes" exists
    And the player has game-by-game stats for weeks 1-10
    When the player views "Patrick Mahomes" details
    Then the system shows passing yards, TDs, INTs for each week
    And the system shows season totals and averages
    And the system shows fantasy points per week

  Scenario: Player edits roster before lock deadline
    Given the player has "Patrick Mahomes" selected for QB
    And the roster lock deadline is in 2 days
    And an NFL player "Josh Allen" exists with position QB
    When the player replaces "Patrick Mahomes" with "Josh Allen" for QB
    Then the roster is updated
    And the QB position now shows "Josh Allen (QB - BUF)"
    And "Patrick Mahomes" is removed from the roster

  Scenario: Player completes full roster before lock
    Given the player needs to fill all 9 roster positions
    When the player selects valid NFL players for all positions:
      | Position | Player                  |
      | QB       | Patrick Mahomes         |
      | RB       | Christian McCaffrey     |
      | RB       | Derrick Henry           |
      | WR       | Tyreek Hill             |
      | WR       | CeeDee Lamb             |
      | TE       | Travis Kelce            |
      | FLEX     | Cooper Kupp (WR)        |
      | K        | Justin Tucker           |
      | DEF      | San Francisco 49ers     |
    Then all 9 roster positions are filled
    And the roster status is "COMPLETE"
    And the roster is ready for lock at deadline

  Scenario: Player validates roster before lock
    Given the player has filled 8 of 9 roster positions
    And the K position is empty
    When the player attempts to validate their roster
    Then the validation fails with error "ROSTER_INCOMPLETE"
    And the system shows missing position: K
    And the roster cannot be locked

  Scenario: Player cannot select same NFL player twice
    Given the player has "Travis Kelce" selected for TE
    When the player attempts to select "Travis Kelce" for FLEX
    Then the selection is rejected with error "PLAYER_ALREADY_SELECTED"
    And the system shows "Travis Kelce is already in your roster at TE"

  Scenario: Multiple league players can select the same NFL player
    Given two league players exist: Player A and Player B
    And an NFL player "Patrick Mahomes" exists
    When Player A selects "Patrick Mahomes" for QB
    And Player B selects "Patrick Mahomes" for QB
    Then both selections are successful
    And both players have "Patrick Mahomes" in their rosters
    And NFL players are not "drafted" - unlimited availability

  Scenario: Player views current roster with all selections
    Given the player has a complete roster
    When the player views their roster
    Then the system displays all 9 positions with selected NFL players
    And each position shows: player name, NFL position, NFL team, jersey number
    And the system shows roster completion status: 9/9 filled

  Scenario: Roster selection for league with Superflex position
    Given a league has roster configuration with 1 Superflex position
    And the Superflex position accepts QB, RB, WR, or TE
    And an NFL player "Josh Allen" exists with position QB
    When the player selects "Josh Allen" for the Superflex slot
    Then the Superflex position is filled with a QB
    And the selection is valid
