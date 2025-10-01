Feature: Team Elimination
  As the system
  I want to eliminate teams that lose their games
  So that they score zero points for all remaining weeks according to game rules

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 4 weeks configured

  Scenario: Team is eliminated when it loses a game
    Given player "john_player" selected "Miami Dolphins" for week 1
    And week 1 games are in progress
    When the "Miami Dolphins" lose their week 1 game
    Then the "Miami Dolphins" should be marked as eliminated for player "john_player"
    And the elimination week should be recorded as week 1
    And the "Miami Dolphins" score for week 1 should be 0

  Scenario: Eliminated team scores zero for all remaining weeks
    Given player "jane_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" lost their week 1 game
    And the "Seattle Seahawks" are eliminated for player "jane_player"
    When week 2 scoring is calculated
    And week 3 scoring is calculated
    And week 4 scoring is calculated
    Then player "jane_player" score for weeks 2, 3, and 4 should be 0

  Scenario: Team that wins is not eliminated
    Given player "bob_player" selected "Buffalo Bills" for week 2
    And week 2 games are in progress
    When the "Buffalo Bills" win their week 2 game with 450 total points
    Then the "Buffalo Bills" should not be marked as eliminated
    And player "bob_player" should receive 450 points for week 2

  Scenario: Multiple players with same eliminated team all get zero
    Given the following players selected "Detroit Lions" for week 1:
      | player      |
      | player1     |
      | player2     |
      | player3     |
    When the "Detroit Lions" lose their week 1 game
    Then the "Detroit Lions" should be eliminated for all 3 players
    And all 3 players should receive 0 points for week 1
    And all 3 players should receive 0 points for remaining weeks

  Scenario: Player with eliminated team can still pick other teams
    Given player "sarah_player" selected "Arizona Cardinals" for week 1
    And the "Arizona Cardinals" lost their week 1 game
    And the "Arizona Cardinals" are eliminated for player "sarah_player"
    When it is week 2 of the game
    And player "sarah_player" selects "Green Bay Packers" for week 2
    Then the selection should be saved successfully
    And the "Green Bay Packers" should not be eliminated

  Scenario: Team elimination status is player-specific
    Given player "tom_player" selected "Atlanta Falcons" for week 1
    And player "jerry_player" selected "Atlanta Falcons" for week 3
    When the "Atlanta Falcons" lose their week 1 game
    Then the "Atlanta Falcons" should be eliminated for player "tom_player"
    And the "Atlanta Falcons" should not be eliminated for player "jerry_player"
    And player "tom_player" receives 0 points for weeks 1, 2, 3, and 4
    And player "jerry_player" can still earn points from "Atlanta Falcons" in week 3

  Scenario: Team that ties is not eliminated
    Given player "mike_player" selected "Cincinnati Bengals" for week 2
    And week 2 games are in progress
    When the "Cincinnati Bengals" tie their week 2 game
    Then the "Cincinnati Bengals" should not be marked as eliminated
    And player "mike_player" should receive points based on team performance

  Scenario: Elimination persists across all remaining weeks
    Given player "lisa_player" has made the following selections:
      | week | team                |
      | 1    | Los Angeles Rams    |
      | 2    | New England Patriots|
      | 3    | Chicago Bears       |
      | 4    | Houston Texans      |
    And the "Los Angeles Rams" lost their week 1 game
    When all 4 weeks are completed
    Then the "Los Angeles Rams" should remain eliminated
    And player "lisa_player" week 1 score should be 0
    And player "lisa_player" week 2 score should be based on "New England Patriots"
    And player "lisa_player" week 3 score should be based on "Chicago Bears"
    And player "lisa_player" week 4 score should be based on "Houston Texans"

  Scenario: Player views their eliminated teams
    Given player "alex_player" has made the following selections:
      | week | team                | outcome |
      | 1    | Denver Broncos      | LOST    |
      | 2    | Carolina Panthers   | WON     |
      | 3    | Jacksonville Jaguars| LOST    |
    When player "alex_player" requests their team status
    Then they should see 2 eliminated teams
    And the eliminated teams should be "Denver Broncos" and "Jacksonville Jaguars"
    And the active teams should be "Carolina Panthers"

  Scenario: Elimination status updates in real-time during games
    Given player "chris_player" selected "Pittsburgh Steelers" for week 1
    And the "Pittsburgh Steelers" game is in progress
    And the "Pittsburgh Steelers" are currently losing
    When the game ends with a "Pittsburgh Steelers" loss
    Then the elimination status should be updated immediately
    And player "chris_player" should be notified of the elimination
    And the leaderboard should reflect the 0 score

  Scenario: System handles bye weeks correctly (teams don't play)
    Given player "nina_player" selected "Las Vegas Raiders" for week 2
    And the "Las Vegas Raiders" have a bye week in week 2
    When week 2 scoring is calculated
    Then the "Las Vegas Raiders" should not be eliminated
    And player "nina_player" should receive 0 points for week 2
    But the team should remain eligible for future scoring

  Scenario: Postponed game does not trigger elimination until played
    Given player "omar_player" selected "Tennessee Titans" for week 1
    And the "Tennessee Titans" game is postponed
    When week 1 scoring deadline passes
    Then the "Tennessee Titans" should not be marked as eliminated
    And player "omar_player" should receive 0 points for week 1 temporarily
    And when the postponed game is played and the team loses
    Then the "Tennessee Titans" should be marked as eliminated

  Scenario: Player receives notification when their team is eliminated
    Given player "penny_player" selected "New York Jets" for week 2
    And notification settings are enabled
    When the "New York Jets" lose their week 2 game
    Then player "penny_player" should receive an elimination notification
    And the notification should indicate "Your week 2 team New York Jets has been eliminated"
    And the notification should explain zero points for remaining weeks

  Scenario Outline: Team elimination rules based on game outcomes
    Given player "test_player" selected "<team>" for week <week>
    When the "<team>" game ends with result "<result>"
    Then the team should be <elimination_status>
    And player "test_player" should receive <points> points

    Examples:
      | team           | week | result | elimination_status | points          |
      | Chiefs         | 1    | WIN    | not eliminated     | calculated      |
      | Bills          | 1    | LOSS   | eliminated         | 0               |
      | 49ers          | 2    | TIE    | not eliminated     | calculated      |
      | Cowboys        | 3    | LOSS   | eliminated         | 0               |
      | Eagles         | 4    | WIN    | not eliminated     | calculated      |

  Scenario: All player teams eliminated results in zero total score
    Given player "unlucky_player" has made the following selections:
      | week | team                | outcome |
      | 1    | Team A              | LOST    |
      | 2    | Team B              | LOST    |
      | 3    | Team C              | LOST    |
      | 4    | Team D              | LOST    |
    When the game is completed
    Then all 4 teams should be eliminated
    And player "unlucky_player" total score should be 0
    And player "unlucky_player" should rank last in the leaderboard
