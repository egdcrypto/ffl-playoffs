Feature: Individual NFL Player Selection
  As a league player
  I want to select individual NFL players by position
  So that I can compete based on their individual game performances

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 4 weeks configured
    And I am authenticated as league player "john_player"

  Scenario: League player successfully selects an NFL player for current week
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 10:00:00"
    And NFL player "Patrick Mahomes" (QB, Kansas City Chiefs) is available
    When I select NFL player "Patrick Mahomes" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Patrick Mahomes, QB"
    And "Patrick Mahomes" should be marked as used by me

  Scenario: League player cannot select the same NFL player twice across their own weeks
    Given I selected "Travis Kelce" (TE, Kansas City Chiefs) for week 1
    And it is now week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 10:00:00"
    And other league players may have also selected "Travis Kelce" for their weeks
    When I attempt to select NFL player "Travis Kelce" for week 2
    Then the selection should fail
    And I should receive error "You have already selected this player in week 1"
    And my pick for week 2 should remain unset
    But other league players can still select "Travis Kelce" for any of their weeks

  Scenario: League player updates pick before deadline
    Given it is week 1 of the game
    And I selected "Josh Allen" (QB, Buffalo Bills) for week 1
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:00:00"
    When I update my week 1 pick to "Jalen Hurts" (QB, Philadelphia Eagles)
    Then my selection should be updated successfully
    And my pick for week 1 should be "Jalen Hurts, QB"
    And "Josh Allen" should no longer be marked as used by me

  Scenario: League player cannot make selection after deadline
    Given it is week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 13:01:00"
    When I attempt to select NFL player "Christian McCaffrey" (RB) for week 2
    Then the selection should fail
    And I should receive error "Pick deadline has passed for week 2"

  Scenario: League player views all NFL players with position filters
    Given it is week 2 of the game
    And I have selected the following NFL players:
      | week | player           | position | team                |
      | 1    | Patrick Mahomes  | QB       | Kansas City Chiefs  |
    When I request NFL players for week 2 selection
    Then I should see NFL players from all 32 teams
    And I can filter by position: QB, RB, WR, TE, K, DEF
    And "Patrick Mahomes" should be marked as "already used by me"
    And other players should be marked as "available"
    And all players should display their current season stats
    And all players should display their upcoming opponent
    And players used by other league players should still be selectable

  Scenario: Filter NFL players by position
    Given I am selecting a player for week 1
    When I filter by position "QB"
    Then I should see only quarterbacks
    And each QB should display:
      | name            |
      | position (QB)   |
      | team            |
      | passing yards   |
      | touchdowns      |
      | completion %    |

  Scenario: Filter NFL players by position WR
    Given I am selecting a player for week 1
    When I filter by position "WR"
    Then I should see only wide receivers
    And each WR should display:
      | name            |
      | position (WR)   |
      | team            |
      | receptions      |
      | receiving yards |
      | touchdowns      |

  Scenario: Filter NFL players by team
    Given I am selecting a player for week 1
    When I filter by NFL team "Kansas City Chiefs"
    Then I should see only Chiefs players
    And players should include:
      | Patrick Mahomes  | QB |
      | Travis Kelce     | TE |
      | Isiah Pacheco    | RB |

  Scenario: League player makes selections for all 4 weeks
    Given the game allows advance picks
    And no deadlines have passed
    When I select the following NFL players:
      | week | player              | position |
      | 1    | Patrick Mahomes     | QB       |
      | 2    | Christian McCaffrey | RB       |
      | 3    | Tyreek Hill         | WR       |
      | 4    | Travis Kelce        | TE       |
    Then all 4 selections should be saved successfully
    And I should have 4 NFL players marked as used

  Scenario: League player cannot select players for future weeks if advance picks disabled
    Given it is week 1 of the game
    And the game does not allow advance picks
    When I attempt to select NFL player "CeeDee Lamb" (WR) for week 3
    Then the selection should fail
    And I should receive error "Cannot make selections for future weeks"

  Scenario: League player receives reminder before pick deadline
    Given it is week 2 of the game
    And I have not made a selection for week 2
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 11:00:00"
    And reminder notifications are enabled
    Then I should receive a reminder notification
    And the reminder should indicate "2 hours remaining to make your pick"

  Scenario: NFL player scores points for EACH GAME played during the week
    Given I selected "Patrick Mahomes" (QB) for week 1
    And NFL week 15 spans December 14-18, 2024
    And "Patrick Mahomes" plays 1 game during NFL week 15
    And the Kansas City Chiefs play on Sunday December 15, 2024
    When the game completes
    Then "Patrick Mahomes" receives points for that 1 game
    And his week 1 score is calculated from the single game performance

  Scenario: NFL player scores cumulative points across multiple games in a week
    Given I selected "Travis Kelce" (TE) for week 1
    And the Kansas City Chiefs have 2 games in NFL week 15
    And "Travis Kelce" plays in both games
    When both games complete
    Then "Travis Kelce" receives points for game 1
    And "Travis Kelce" receives points for game 2
    And his week 1 total score is the SUM of both games

  Scenario: League player views their selection history with game-by-game scores
    Given I have made the following selections:
      | week | player           | position | games_played | total_score |
      | 1    | Patrick Mahomes  | QB       | 1            | 28.5        |
      | 2    | Josh Allen       | QB       | 1            | 32.0        |
      | 3    | CeeDee Lamb      | WR       | 1            | 18.5        |
    When I request my player selection history
    Then I should receive 3 selections
    And each selection should show:
      | player name     |
      | position        |
      | NFL team        |
      | games played    |
      | score per game  |
      | total score     |

  Scenario: League player cannot select a player that doesn't exist
    Given it is week 1 of the game
    When I attempt to select NFL player "Invalid Player Name" for week 1
    Then the selection should fail
    And I should receive error "NFL player not found"

  Scenario: League player cannot make selection for completed week
    Given week 1 is completed
    And I did not make a selection for week 1
    When I attempt to select NFL player "Saquon Barkley" (RB) for week 1
    Then the selection should fail
    And I should receive error "Cannot make selection for completed week"

  Scenario: League player who misses a week deadline gets zero points
    Given it is week 2 of the game
    And I did not make a selection for week 1
    And week 1 is now completed
    Then my score for week 1 should be 0
    And I should be able to make selections for remaining weeks

  Scenario Outline: Player selection validation across 4 weeks
    Given the game has 4 weeks configured
    And I have made the following selections:
      | week | player   |
      | 1    | <player1> |
      | 2    | <player2> |
      | 3    | <player3> |
    When I attempt to select NFL player "<player4>" for week 4
    Then the selection should <result>
    And I should receive <feedback>

    Examples:
      | player1         | player2          | player3       | player4         | result  | feedback                                        |
      | Patrick Mahomes | Josh Allen       | Jalen Hurts   | Lamar Jackson   | succeed | selection saved successfully                    |
      | Patrick Mahomes | Josh Allen       | Jalen Hurts   | Patrick Mahomes | fail    | error "Player already selected in week 1"       |
      | Patrick Mahomes | Josh Allen       | Jalen Hurts   | Josh Allen      | fail    | error "Player already selected in week 2"       |
      | Patrick Mahomes | Josh Allen       | Jalen Hurts   | Jalen Hurts     | fail    | error "Player already selected in week 3"       |

  Scenario: Multiple league players can independently select the same NFL player
    Given league player "player1" selected "Patrick Mahomes" for week 1
    And league player "player2" selected "Patrick Mahomes" for week 1
    And league player "player3" selected "Patrick Mahomes" for week 1
    And I am league player "player4"
    And it is week 1 of the game
    When I select NFL player "Patrick Mahomes" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Patrick Mahomes, QB"
    And all 4 league players have independently selected "Patrick Mahomes"
    And there is no limit on how many league players can pick the same NFL player

  Scenario: NOT a draft system - all NFL players always available to all league players
    Given the league has 10 players
    And it is week 2 of the game
    And 5 league players have already selected "Travis Kelce" for week 2
    When I view the available NFL players
    Then I should see all NFL players from all 32 teams
    And "Travis Kelce" should be marked as "available"
    And I should be able to select "Travis Kelce" even though 5 others picked him
    And there is NO concept of player availability based on other league players' picks
    And each league player makes independent selections without affecting others

  Scenario: League player views pick deadline countdown
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:30:00"
    When I request the current week information
    Then I should receive deadline information
    And the time remaining should be "1 hour 30 minutes"
    And the deadline status should be "OPEN"

  # Pagination for NFL Player Selection Display

  Scenario: Paginate NFL player list with default page size
    Given there are 1000+ NFL players in the system
    And it is week 1 of the game
    When I request the available NFL players without pagination parameters
    Then the response includes 20 players (default page size)
    And the response includes pagination metadata:
      | page           | 0              |
      | size           | 20             |
      | totalElements  | 1000+          |
      | totalPages     | 50+            |
      | hasNext        | true           |
      | hasPrevious    | false          |

  Scenario: Paginate NFL players by position filter
    Given I am viewing players for week 1
    And I filter by position "QB"
    And there are approximately 64 QBs (32 teams × 2 QBs each)
    When I request players with page 0 and size 20
    Then the response includes 20 QBs
    And the pagination metadata reflects filtered total:
      | totalElements  | 64 (QBs only) |
      | totalPages     | 4             |

  Scenario: Paginate NFL players by team filter
    Given I am viewing players for week 1
    And I filter by NFL team "Kansas City Chiefs"
    When I request players with page 0 and size 20
    Then the response includes Chiefs players only
    And the pagination metadata shows:
      | totalElements  | ~53 (Chiefs roster) |
      | totalPages     | 3                    |

  Scenario: Paginate player selection history
    Given I have made selections for 15 different weeks across multiple leagues
    When I request my player selection history with page size 10
    Then page 0 contains selections 1-10
    And page 1 contains selections 11-15
    And each response includes total count of 15

  Scenario: Paginate with sorting by player stats
    Given there are 1000+ NFL players
    When I request players sorted by "passingYards" descending with page size 20
    Then page 0 shows the top 20 players by passing yards
    And pagination metadata includes sort information:
      | sort | passingYards,desc |

  Scenario: Search NFL players by name
    Given I am selecting a player for week 1
    When I search for "Mahomes"
    Then I should see:
      | Patrick Mahomes | QB | Kansas City Chiefs |
    And other "Mahomes" players if they exist

  Scenario: Search NFL players by partial name
    Given I am selecting a player for week 1
    When I search for "Kel"
    Then I should see players with names containing "Kel":
      | Travis Kelce  | TE | Kansas City Chiefs    |
      | Jason Kelce   | C  | Philadelphia Eagles   |
