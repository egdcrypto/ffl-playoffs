Feature: Team Selection
  As a player
  I want to select NFL teams for each week
  So that I can compete in the 4-week playoff game

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 4 weeks configured
    And I am authenticated as player "john_player"

  Scenario: Player successfully selects a team for the current week
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 10:00:00"
    And the team "Kansas City Chiefs" is available
    When I select team "Kansas City Chiefs" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Kansas City Chiefs"
    And the team "Kansas City Chiefs" should be marked as used by me

  Scenario: Player cannot select the same team twice
    Given I selected "Dallas Cowboys" for week 1
    And it is now week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 10:00:00"
    When I attempt to select team "Dallas Cowboys" for week 2
    Then the selection should fail
    And I should receive error "You have already selected this team in a previous week"
    And my pick for week 2 should remain unset

  Scenario: Player updates pick before deadline
    Given it is week 1 of the game
    And I selected "Buffalo Bills" for week 1
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:00:00"
    When I update my week 1 pick to "San Francisco 49ers"
    Then my selection should be updated successfully
    And my pick for week 1 should be "San Francisco 49ers"
    And the team "Buffalo Bills" should no longer be marked as used by me

  Scenario: Player cannot make selection after deadline
    Given it is week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 13:01:00"
    When I attempt to select team "Miami Dolphins" for week 2
    Then the selection should fail
    And I should receive error "Pick deadline has passed for week 2"

  Scenario: Player cannot modify pick after deadline
    Given it is week 1 of the game
    And I selected "Philadelphia Eagles" for week 1
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 13:30:00"
    When I attempt to update my week 1 pick to "Green Bay Packers"
    Then the update should fail
    And I should receive error "Pick deadline has passed for week 1"
    And my pick for week 1 should remain "Philadelphia Eagles"

  Scenario: Player views available teams for selection
    Given it is week 2 of the game
    And I have selected the following teams:
      | week | team              |
      | 1    | Dallas Cowboys    |
    When I request available teams for week 2
    Then I should receive a list of 31 teams
    And the list should not include "Dallas Cowboys"
    And all teams should have their current season record
    And all teams should have their upcoming opponent

  Scenario: Player makes selections for all 4 weeks
    Given the game allows advance picks
    And no deadlines have passed
    When I select the following teams:
      | week | team                  |
      | 1    | Kansas City Chiefs    |
      | 2    | Buffalo Bills         |
      | 3    | San Francisco 49ers   |
      | 4    | Dallas Cowboys        |
    Then all 4 selections should be saved successfully
    And I should have 4 teams marked as used

  Scenario: Player cannot select teams for future weeks if advance picks are disabled
    Given it is week 1 of the game
    And the game does not allow advance picks
    When I attempt to select team "Denver Broncos" for week 3
    Then the selection should fail
    And I should receive error "Cannot make selections for future weeks"

  Scenario: Player receives reminder before pick deadline
    Given it is week 2 of the game
    And I have not made a selection for week 2
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 11:00:00"
    And reminder notifications are enabled
    Then I should receive a reminder notification
    And the reminder should indicate "2 hours remaining to make your pick"

  Scenario: Player with eliminated team can still pick for remaining weeks
    Given it is week 3 of the game
    And I selected "Tampa Bay Buccaneers" for week 1
    And the "Tampa Bay Buccaneers" lost their game in week 1
    And the "Tampa Bay Buccaneers" are eliminated for me
    When I select team "Baltimore Ravens" for week 3
    Then my selection should be saved successfully
    And my pick for week 3 should be "Baltimore Ravens"

  Scenario: Player views their selection history
    Given I have made the following selections:
      | week | team                  | status      |
      | 1    | Kansas City Chiefs    | WON         |
      | 2    | Buffalo Bills         | LOST        |
      | 3    | San Francisco 49ers   | PENDING     |
    When I request my team selection history
    Then I should receive 3 selections
    And each selection should show the team name, week, and game outcome

  Scenario: Player cannot select a team that doesn't exist
    Given it is week 1 of the game
    When I attempt to select team "Invalid Team Name" for week 1
    Then the selection should fail
    And I should receive error "Team not found"

  Scenario: Player cannot make selection for completed week
    Given week 1 is completed
    And I did not make a selection for week 1
    When I attempt to select team "Atlanta Falcons" for week 1
    Then the selection should fail
    And I should receive error "Cannot make selection for completed week"

  Scenario: Player who misses a week deadline gets zero points
    Given it is week 2 of the game
    And I did not make a selection for week 1
    And week 1 is now completed
    Then my score for week 1 should be 0
    And I should be able to make selections for remaining weeks

  Scenario Outline: Team selection validation across 4 weeks
    Given the game has 4 weeks configured
    And I have made the following selections:
      | week | team   |
      | 1    | <team1> |
      | 2    | <team2> |
      | 3    | <team3> |
    When I attempt to select team "<team4>" for week 4
    Then the selection should <result>
    And I should receive <feedback>

    Examples:
      | team1            | team2             | team3               | team4               | result  | feedback                                        |
      | Chiefs           | Bills             | 49ers               | Cowboys             | succeed | selection saved successfully                    |
      | Chiefs           | Bills             | 49ers               | Chiefs              | fail    | error "Team already selected in week 1"         |
      | Chiefs           | Bills             | 49ers               | Bills               | fail    | error "Team already selected in week 2"         |
      | Chiefs           | Bills             | 49ers               | 49ers               | fail    | error "Team already selected in week 3"         |

  Scenario: Multiple players can select the same team
    Given player "player1" selected "Dallas Cowboys" for week 1
    And I am player "player2"
    And it is week 1 of the game
    When I select team "Dallas Cowboys" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Dallas Cowboys"

  Scenario: Player views pick deadline countdown
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:30:00"
    When I request the current week information
    Then I should receive deadline information
    And the time remaining should be "1 hour 30 minutes"
    And the deadline status should be "OPEN"
