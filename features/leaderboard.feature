Feature: Leaderboard and Standings
  As a player
  I want to view real-time standings and leaderboards
  So that I can track my performance and compete with others

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 10 players
    And the game has 4 weeks configured

  # Real-Time Standings

  Scenario: View current week leaderboard
    Given it is week 2 of the game
    And week 2 games are in progress
    And the following players have week 2 scores:
      | player      | team selected      | current score |
      | player1     | Kansas City Chiefs | 45.5          |
      | player2     | Buffalo Bills      | 38.2          |
      | player3     | San Francisco 49ers| 52.3          |
      | player4     | Dallas Cowboys     | 28.7          |
    When I request the week 2 leaderboard
    Then the standings should be ordered by score descending:
      | rank | player   | score |
      | 1    | player3  | 52.3  |
      | 2    | player1  | 45.5  |
      | 3    | player2  | 38.2  |
      | 4    | player4  | 28.7  |

  # Pagination

  Scenario: Paginate leaderboard with many players
    Given the league has 100 players
    When I request the leaderboard with page size 20
    Then I should receive 20 player records
    And the response includes pagination metadata:
      | totalItems    | 100 |
      | totalPages    | 5   |
      | currentPage   | 1   |
      | pageSize      | 20  |
      | hasNextPage   | true  |
      | hasPreviousPage | false |

  Scenario: Navigate to specific leaderboard page
    Given the league has 100 players
    When I request leaderboard page 3 with page size 20
    Then I should receive players ranked 41-60
    And the pagination metadata shows:
      | currentPage   | 3   |
      | totalPages    | 5   |
      | hasNextPage   | true  |
      | hasPreviousPage | true |

  Scenario: Change leaderboard page size
    Given the league has 100 players
    When I request the leaderboard with page size 50
    Then I should receive 50 player records
    And the response shows totalPages as 2

  Scenario: Last page of leaderboard
    Given the league has 100 players
    When I request leaderboard page 5 with page size 20
    Then I should receive players ranked 81-100
    And hasNextPage is false
    And hasPreviousPage is true

  Scenario: View overall cumulative leaderboard
    Given it is week 3 of the game
    And the following players have cumulative scores:
      | player   | week1 | week2 | week3 | total  |
      | player1  | 45.5  | 52.0  | 38.5  | 136.0  |
      | player2  | 38.2  | 48.5  | 55.2  | 141.9  |
      | player3  | 52.3  | 35.0  | 42.8  | 130.1  |
      | player4  | 28.7  | 0.0   | 0.0   | 28.7   |
    When I request the overall leaderboard
    Then the standings should be:
      | rank | player   | total  |
      | 1    | player2  | 141.9  |
      | 2    | player1  | 136.0  |
      | 3    | player3  | 130.1  |
      | 4    | player4  | 28.7   |

  Scenario: Leaderboard updates in real-time as games complete
    Given it is week 1 of the game
    And player "john_player" selected "Miami Dolphins"
    And the "Miami Dolphins" game is in progress
    And the current score is 25.5 points
    When the "Miami Dolphins" score a touchdown
    Then player "john_player" score increases by 6 points
    And the leaderboard updates immediately
    And player "john_player" new rank is recalculated

  Scenario: Leaderboard shows live score updates during games
    Given multiple games are in progress
    And live scoring is enabled
    When I view the leaderboard
    Then I should see live score indicators for active games
    And scores should update every 60 seconds
    And the refresh timestamp should be displayed

  # Standings Details

  Scenario: View detailed standings with team information
    Given it is week 2 of the game
    When I request detailed standings
    Then each player entry should include:
      | Player name                      |
      | Current week team                |
      | Current week score               |
      | Overall total score              |
      | Rank                             |
      | Eliminated teams count           |
      | Remaining eligible teams         |

  Scenario: Standings show team elimination status
    Given the following player selections and results:
      | player   | week1 team      | week1 result | week2 team       | week2 result |
      | player1  | Chiefs          | WIN          | Bills            | WIN          |
      | player2  | Cowboys         | LOSS         | 49ers            | WIN          |
      | player3  | Dolphins        | LOSS         | Packers          | LOSS         |
    When I view the standings
    Then the standings should show elimination status:
      | player   | eliminated teams    | active teams       |
      | player1  | 0                   | Chiefs, Bills      |
      | player2  | Cowboys (Week 1)    | 49ers              |
      | player3  | Dolphins (Week 1), Packers (Week 2) | 0 |

  Scenario: View my position in the standings
    Given I am player "john_player"
    And there are 20 players in the league
    And I am ranked 8th overall
    When I request my standings position
    Then I should see:
      | myRank           | 8                     |
      | totalPlayers     | 20                    |
      | myScore          | 142.5                 |
      | pointsFromLeader | -25.3                 |
      | pointsToNext     | 3.2                   |
      | playersAhead     | player7: 145.7        |
      | playersBehind    | player9: 138.5        |

  # Historical Data and Trends

  Scenario: View weekly score trends
    Given the game has completed 3 weeks
    And I am player "jane_player"
    And my weekly scores are:
      | week | score | rank |
      | 1    | 55.2  | 2    |
      | 2    | 38.5  | 8    |
      | 3    | 62.8  | 1    |
    When I request my score trends
    Then I should see a weekly breakdown
    And the trend should show performance over time
    And I should see week-over-week rank changes

  Scenario: View historical game results
    Given a completed game "2024 Playoffs" exists
    When I request historical results for "2024 Playoffs"
    Then I should see:
      | Final leaderboard              |
      | Winner                         |
      | My final rank                  |
      | My team selections all weeks   |
      | My weekly scores               |
      | Eliminated teams history       |

  Scenario: View player performance history across multiple games
    Given I have participated in 3 completed games
    And my results are:
      | game          | rank | total score | teams eliminated |
      | 2023 Playoffs | 3    | 185.5       | 1                |
      | 2024 Mid      | 1    | 225.8       | 0                |
      | 2024 Playoffs | 5    | 168.2       | 2                |
    When I request my performance history
    Then I should see all 3 games
    And I should see overall statistics:
      | averageRank        | 3.0   |
      | gamesWon           | 1     |
      | topThreeFinishes   | 2     |
      | averageScore       | 193.2 |

  # Score Breakdown

  Scenario: View detailed points breakdown by week
    Given I am player "bob_player"
    And my week 1 team "Chiefs" scored:
      | category          | points |
      | Passing Yards     | 14.0   |
      | Rushing Yards     | 12.5   |
      | Receiving Yards   | 28.0   |
      | Receptions        | 22.0   |
      | Touchdowns        | 24.0   |
      | Field Goals       | 9.0    |
      | Extra Points      | 4.0    |
      | Defensive/ST      | 12.0   |
    When I request my week 1 breakdown
    Then I should see all scoring categories
    And the total should be 125.5 points
    And I can compare each category to league average

  Scenario: View league-wide scoring statistics
    Given the game has completed week 1
    When I request league statistics
    Then I should see:
      | highestWeeklyScore      | 145.8 by player3      |
      | lowestWeeklyScore       | 0.0 by player7        |
      | averageWeeklyScore      | 85.3                  |
      | mostSelectedTeam        | Chiefs (5 players)    |
      | mostEliminatedTeam      | Cowboys (3 players)   |

  # Filtering and Sorting

  Scenario: Filter leaderboard by week
    Given the game has completed 2 weeks
    When I filter the leaderboard by week 1
    Then I should see only week 1 scores
    And rankings should be based on week 1 performance only

  Scenario: Sort leaderboard by different criteria
    When I sort the leaderboard by "most eliminated teams"
    Then players with most eliminations should appear first
    When I sort by "fewest eliminated teams"
    Then players with no eliminations should appear first
    When I sort by "highest single week score"
    Then players ranked by their best weekly performance

  Scenario: View standings filtered by active players only
    Given 2 players have been removed from the league
    When I filter standings to show "active players only"
    Then the leaderboard shows 8 active players
    And removed players are excluded

  # Ties and Ranking

  Scenario: Handle tied scores in standings
    Given the following players have the same total score:
      | player   | total | week1 | week2 | week3 |
      | player1  | 150.0 | 50.0  | 55.0  | 45.0  |
      | player2  | 150.0 | 48.0  | 52.0  | 50.0  |
    When I view the leaderboard
    Then both players should have the same rank
    And the tiebreaker should be highest single week score
    And player1 ranks higher (week2: 55.0 > 52.0)

  Scenario: Display tied rank notation
    Given 3 players are tied at 125.5 points
    And they are ranked 2nd, 2nd, 2nd
    When I view the leaderboard
    Then I should see:
      | rank | player   | score  |
      | 1    | player1  | 145.8  |
      | T-2  | player2  | 125.5  |
      | T-2  | player3  | 125.5  |
      | T-2  | player4  | 125.5  |
      | 5    | player5  | 118.2  |

  # Notifications and Alerts

  Scenario: Player receives rank change notification
    Given I am ranked 5th overall
    And my rank has improved from 8th to 5th
    When week 2 scoring completes
    Then I should receive a notification
    And the notification says "You moved up 3 positions to rank 5!"

  Scenario: Player notified when falling in rankings
    Given I was ranked 2nd overall
    And after week 3 I am ranked 6th
    When the leaderboard updates
    Then I should receive a notification
    And the notification says "Your rank changed from 2nd to 6th"
    And the notification suggests checking my eliminated teams

  # Privacy and Visibility

  Scenario: Private league standings visible only to members
    Given the league is set to "PRIVATE"
    And I am a member of the league
    When I request the leaderboard
    Then I should see all player standings
    When a non-member requests the leaderboard
    Then the request is rejected with error "UNAUTHORIZED"

  Scenario: Public league standings visible to anyone
    Given the league is set to "PUBLIC"
    When anyone requests the leaderboard
    Then they should see the standings
    But detailed player information is limited
    And only player names and scores are shown

  Scenario: Anonymous viewing of public leaderboards
    Given the league is public
    And I am not authenticated
    When I view the public leaderboard URL
    Then I should see rankings and scores
    But I cannot see detailed breakdowns
    And I cannot see team selection details

  # Winner Determination

  Scenario: Determine winner after game completes
    Given all 4 weeks have completed
    And the final standings are:
      | rank | player   | total  |
      | 1    | player1  | 385.5  |
      | 2    | player2  | 368.2  |
      | 3    | player3  | 352.8  |
    When the game is marked as completed
    Then player1 is declared the winner
    And all players receive winner announcement
    And the winner receives a congratulations notification

  Scenario: Declare co-winners for tied scores
    Given all weeks have completed
    And 2 players are tied for first place
    And the tiebreaker criteria are equal
    When the game is completed
    Then both players are declared co-winners
    And the announcement recognizes both winners

  # Comparison and Analytics

  Scenario: Compare my performance to another player
    Given I am player "john_player"
    When I compare myself to player "jane_player"
    Then I should see a side-by-side comparison:
      | metric              | john_player | jane_player |
      | Overall Rank        | 3           | 5           |
      | Total Score         | 285.5       | 265.2       |
      | Teams Eliminated    | 1           | 2           |
      | Best Week           | Week 2: 95  | Week 1: 88  |
      | Worst Week          | Week 3: 45  | Week 4: 32  |
      | Average Weekly      | 71.4        | 66.3        |

  Scenario: View my position relative to league average
    Given the league average score is 250.0
    And my total score is 285.5
    When I view my statistics
    Then I should see:
      | differenceFromAverage | +35.5          |
      | percentile            | Top 30%        |
      | aboveAveragePlayers   | 3              |
      | belowAveragePlayers   | 7              |
