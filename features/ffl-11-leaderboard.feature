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

  # ============================================
  # PLAYOFF BRACKET TRACKING
  # ============================================

  Scenario: View playoff bracket structure
    Given the game "2025 NFL Playoffs Pool" uses elimination format
    And the bracket has the following structure:
      | round           | teams remaining | eliminated per round |
      | Wild Card       | 14              | 6                    |
      | Divisional      | 8               | 4                    |
      | Conference      | 4               | 2                    |
      | Super Bowl      | 2               | 1                    |
    When I request the playoff bracket
    Then I should see a visual bracket representation
    And each round should show matchups and winners

  Scenario: Track team progression through playoff bracket
    Given the following teams are in the playoffs:
      | conference | seed | team            |
      | AFC        | 1    | Chiefs          |
      | AFC        | 2    | Bills           |
      | AFC        | 3    | Ravens          |
      | NFC        | 1    | 49ers           |
      | NFC        | 2    | Lions           |
      | NFC        | 3    | Eagles          |
    And player "john_player" has selected "Chiefs" for week 1
    When the "Chiefs" win their wild card game
    Then the bracket shows "Chiefs" advancing to Divisional round
    And player "john_player" team status shows "ALIVE"
    And their next opponent is displayed

  Scenario: Bracket reflects player team eliminations
    Given player "jane_player" selected "Cowboys" for week 1
    And the "Cowboys" lose their playoff game
    When I view the playoff bracket
    Then "Cowboys" should be marked as ELIMINATED in the bracket
    And player "jane_player" should see "Cowboys" crossed out
    And their week 1 score is finalized

  Scenario: View bracket with player overlay
    Given the game has 10 active players
    And each player has made team selections
    When I view the bracket with player overlay enabled
    Then each team in the bracket shows player count who selected them
    And clicking a team shows the list of players
    And my selections are highlighted

  Scenario: Bracket updates in real-time during games
    Given the "Chiefs" vs "Dolphins" game is in progress
    And the "Chiefs" are winning 24-17
    When I view the live bracket
    Then the game should show the current score
    And the winning team should be highlighted
    And projected bracket advancement is shown

  Scenario: View conference championship bracket
    Given the playoff bracket has reached Conference Championships
    And remaining teams are:
      | AFC | Chiefs, Bills      |
      | NFC | 49ers, Eagles      |
    When I view the conference championship bracket
    Then I should see AFC Championship: Chiefs vs Bills
    And I should see NFC Championship: 49ers vs Eagles
    And Super Bowl matchup shows "TBD vs TBD"

  Scenario: View Super Bowl matchup and prediction
    Given conference championships are complete
    And Super Bowl matchup is Chiefs vs 49ers
    When I view the Super Bowl bracket
    Then I should see the matchup details
    And I should see date, time, and venue
    And I should see player selections for Super Bowl week

  Scenario: Historical bracket navigation
    Given the 2024 playoffs are complete
    When I view the 2024 playoff bracket
    Then I should see all rounds with winners
    And the Super Bowl champion is highlighted
    And I can see my selections overlaid on the bracket

  # ============================================
  # TEAM PERFORMANCE METRICS
  # ============================================

  Scenario: View detailed team performance metrics
    Given player "bob_player" selected "Chiefs" for week 1
    And the "Chiefs" game is complete
    When I request team performance metrics for "bob_player" week 1
    Then I should see:
      | metric               | value |
      | totalFantasyPoints   | 145.5 |
      | offensiveYards       | 425   |
      | defensiveTakeaways   | 2     |
      | redZoneEfficiency    | 80%   |
      | thirdDownConversion  | 45%   |
      | timeOfPossession     | 32:15 |
      | turnoversCommitted   | 1     |

  Scenario: Compare team performance across weeks
    Given player "alice_player" has made selections for 3 weeks
    When I view her team performance comparison
    Then I should see week-over-week metrics:
      | metric         | week1   | week2   | week3   |
      | fantasyPoints  | 125.5   | 98.2    | 142.8   |
      | teamSelected   | Chiefs  | Bills   | 49ers   |
      | teamResult     | WIN     | LOSS    | WIN     |
      | pointsVsAvg    | +15.2   | -12.1   | +32.5   |

  Scenario: View position-based performance breakdown
    Given my week 1 team "Ravens" has player stats:
      | position | player        | points |
      | QB       | Lamar Jackson | 28.5   |
      | RB1      | Derrick Henry | 22.4   |
      | RB2      | Justice Hill  | 8.2    |
      | WR1      | Zay Flowers   | 18.7   |
      | WR2      | Rashod Bateman| 12.3   |
      | TE       | Mark Andrews  | 15.6   |
      | K        | Justin Tucker | 12.0   |
      | DEF      | Ravens D/ST   | 14.0   |
    When I request my position breakdown
    Then I should see total: 131.7 points
    And I should see each position contribution percentage
    And I should see comparison to league average by position

  Scenario: Track top performing players across league
    Given the week is complete
    When I request top performers
    Then I should see the top 5 scoring teams:
      | rank | player   | team   | score  |
      | 1    | player1  | Chiefs | 152.3  |
      | 2    | player2  | 49ers  | 145.8  |
      | 3    | player3  | Bills  | 138.2  |
      | 4    | player4  | Lions  | 132.5  |
      | 5    | player5  | Ravens | 128.9  |

  Scenario: View underperforming teams analysis
    Given the week is complete
    When I request underperforming teams
    Then I should see teams that scored below projections:
      | team     | projected | actual | difference |
      | Cowboys  | 115.0     | 78.5   | -36.5      |
      | Packers  | 108.0     | 82.3   | -25.7      |
      | Dolphins | 112.0     | 88.5   | -23.5      |

  Scenario: Calculate efficiency metrics
    Given player "mike_player" has played 3 weeks
    When I calculate his efficiency metrics
    Then I should see:
      | metric                    | value |
      | avgPointsPerWin           | 135.2 |
      | avgPointsPerLoss          | 75.8  |
      | winningTeamSelectRate     | 66.7% |
      | optimalSelectionRate      | 33.3% |
      | pointsLeftOnTable         | 45.5  |

  Scenario: View momentum and streak metrics
    Given player "jane_player" has scored above average for 4 consecutive weeks
    When I view her momentum metrics
    Then I should see:
      | currentStreak       | 4 weeks hot      |
      | streakType          | ABOVE_AVERAGE    |
      | avgStreakScore      | 132.5            |
      | rankMovement        | +8 (from 12 to 4)|
      | momentumRating      | HIGH             |

  Scenario: Track consistency score
    Given player "consistent_player" has weekly scores:
      | week | score  |
      | 1    | 105.2  |
      | 2    | 108.5  |
      | 3    | 103.8  |
      | 4    | 107.1  |
    When I calculate consistency metrics
    Then I should see:
      | standardDeviation   | 2.1    |
      | consistencyRating   | A+     |
      | volatilityIndex     | LOW    |
      | predictabilityScore | 95%    |

  # ============================================
  # REAL-TIME UPDATES (WEBSOCKET/SSE)
  # ============================================

  Scenario: Subscribe to real-time leaderboard updates
    Given I am viewing the leaderboard
    And games are in progress
    When I subscribe to real-time updates
    Then I should receive WebSocket connection confirmation
    And updates should be pushed every 30 seconds
    And I should see live score changes without refreshing

  Scenario: Receive live rank change notifications
    Given I am subscribed to leaderboard updates
    And my current rank is 5
    And a scoring update causes me to move to rank 3
    When the update is processed
    Then I should receive a rank change event
    And the event should contain:
      | previousRank | 5           |
      | newRank      | 3           |
      | scoreChange  | +12.5       |
      | trigger      | TD by Chiefs|

  Scenario: Handle concurrent game updates
    Given 4 games are in progress simultaneously
    When multiple scoring events occur within 1 second
    Then all updates should be batched
    And leaderboard should update once with all changes
    And no race conditions should occur

  Scenario: Reconnect after connection loss
    Given I am subscribed to real-time updates
    When my connection drops
    Then the client should attempt reconnection
    And reconnection should use exponential backoff
    And upon reconnection, I should receive current state
    And no updates should be lost

  Scenario: Server-Sent Events as fallback
    Given WebSocket connection fails
    When I request real-time updates
    Then the system should fall back to SSE
    And I should still receive updates
    And update frequency may be reduced to 60 seconds

  Scenario: Throttle rapid updates during high-scoring games
    Given a game has 5 scoring events within 30 seconds
    When processing updates
    Then updates should be throttled to prevent overload
    And maximum 1 update per 10 seconds per client
    And batch updates should aggregate changes

  # ============================================
  # PLAYER ELIMINATION TRACKING
  # ============================================

  Scenario: Track elimination progress
    Given the game uses weekly elimination format
    And we started with 20 players
    And 3 weeks have completed
    When I view elimination tracking
    Then I should see:
      | week | playersEliminated | playersRemaining |
      | 1    | 4                 | 16               |
      | 2    | 4                 | 12               |
      | 3    | 4                 | 8                |

  Scenario: Display elimination danger zone
    Given it is week 3 of the game
    And 4 players will be eliminated
    And the following scores are current:
      | player   | score  | rank |
      | player8  | 85.2   | 8    |
      | player9  | 82.5   | 9    |
      | player10 | 78.3   | 10   |
      | player11 | 72.1   | 11   |
      | player12 | 68.5   | 12   |
    When I view the danger zone
    Then players 9-12 should be highlighted in red
    And points needed to escape should be shown:
      | player9  | needs 2.8 more points |
      | player10 | needs 6.9 more points |

  Scenario: Show elimination cutoff line
    Given 20 players remain and 4 will be eliminated
    When I view the leaderboard
    Then a visual cutoff line appears between rank 16 and 17
    And players below the line are marked as "AT RISK"
    And the line should update in real-time

  Scenario: Track my elimination probability
    Given my current rank is 14 out of 16 remaining players
    And 2 players will be eliminated
    And there are 2 hours left in the week
    When I view my elimination probability
    Then I should see:
      | currentRisk      | HIGH          |
      | pointsBehind     | 8.5           |
      | gamesRemaining   | 2             |
      | survivalOdds     | 35%           |
      | recommendedWatch | Bills vs Chiefs|

  Scenario: View eliminated players history
    Given 8 players have been eliminated over 2 weeks
    When I view elimination history
    Then I should see:
      | week | eliminated | lowestScore | cutoffScore |
      | 1    | player15, player16, player17, player18 | 45.2 | 68.5 |
      | 2    | player11, player12, player13, player14 | 52.8 | 75.2 |
    And each eliminated player shows their final rank

  # ============================================
  # MOBILE AND RESPONSIVE VIEWS
  # ============================================

  Scenario: View mobile-optimized leaderboard
    Given I am on a mobile device
    When I view the leaderboard
    Then I should see a compact view:
      | Rank column (narrow)        |
      | Player name (truncated)     |
      | Score (right-aligned)       |
      | Trend indicator (arrow)     |
    And horizontal scrolling is disabled
    And pull-to-refresh is enabled

  Scenario: Expand player details on mobile
    Given I am viewing the mobile leaderboard
    When I tap on a player row
    Then the row should expand to show:
      | Full player name             |
      | Current team selection       |
      | Week-by-week scores          |
      | Eliminated teams list        |
    And tapping again collapses the row

  Scenario: Mobile bracket view with swipe navigation
    Given I am viewing the playoff bracket on mobile
    When I swipe left and right
    Then I should navigate between playoff rounds
    And current round indicator shows position
    And pinch-to-zoom is enabled for detail view

  Scenario: Tablet-optimized split view
    Given I am on a tablet device
    When I view leaderboard and bracket
    Then leaderboard appears on the left
    And bracket appears on the right
    And both update independently
    And I can collapse either panel

  # ============================================
  # EXPORT AND SHARING
  # ============================================

  Scenario: Export leaderboard as CSV
    Given the current leaderboard has 20 players
    When I export as CSV
    Then I should receive a file containing:
      | rank, playerName, totalScore, week1, week2, week3, teamsEliminated |
    And all 20 player records are included
    And the file is named with league and date

  Scenario: Export leaderboard as PDF
    Given the current leaderboard has 20 players
    When I export as PDF
    Then I should receive a formatted PDF containing:
      | League name and logo         |
      | Current date and week        |
      | Full leaderboard table       |
      | Scoring summary statistics   |
    And the PDF is print-ready

  Scenario: Share leaderboard snapshot to social media
    Given I am the league commissioner
    When I generate a shareable leaderboard image
    Then the system creates a branded image with:
      | Top 10 standings             |
      | Current week indicator       |
      | League name                  |
      | Watermark with app branding  |
    And I receive sharing links for Twitter, Facebook, and Instagram

  Scenario: Generate embeddable leaderboard widget
    Given I am the league commissioner
    When I request an embeddable widget
    Then I receive an iframe embed code
    And the widget shows live standings
    And the widget is read-only
    And custom styling options are provided

  Scenario: Share my performance card
    Given I am player "jane_player"
    When I generate my performance card
    Then I should receive an image containing:
      | My current rank              |
      | Total score                  |
      | Win/loss record              |
      | Best week performance        |
      | Personalized stats           |
    And I can share to social media

  # ============================================
  # HEAD-TO-HEAD COMPARISONS
  # ============================================

  Scenario: Initiate head-to-head comparison
    Given I am player "john_player"
    When I select player "jane_player" for head-to-head comparison
    Then I should see a comparison dashboard

  Scenario: View head-to-head weekly matchup
    Given I am comparing with player "jane_player"
    When I view weekly matchups
    Then I should see:
      | week | myScore | theirScore | winner |
      | 1    | 125.5   | 118.2      | me     |
      | 2    | 98.2    | 132.5      | them   |
      | 3    | 142.8   | 135.2      | me     |
    And overall head-to-head record shows 2-1

  Scenario: Compare team selection patterns
    Given I am comparing with player "jane_player"
    When I view team selection comparison
    Then I should see:
      | category               | me            | them          |
      | mostSelectedConf       | AFC (4 times) | NFC (3 times) |
      | favoriteSeed           | #1 seeds (3x) | #2 seeds (4x) |
      | sharedSelections       | 2 teams       | 2 teams       |
      | avgTeamSeedSelected    | 2.1           | 2.8           |

  Scenario: View all-time head-to-head record
    Given I have played with "jane_player" in 3 different leagues
    When I view all-time head-to-head
    Then I should see:
      | totalMatchups       | 12          |
      | myWins              | 7           |
      | theirWins           | 5           |
      | totalPointsMe       | 1,245.8     |
      | totalPointsThem     | 1,198.2     |
      | avgMarginOfVictory  | 12.5        |

  # ============================================
  # PROJECTIONS AND PREDICTIONS
  # ============================================

  Scenario: View projected final standings
    Given it is week 2 of 4
    And current standings exist
    When I request projected final standings
    Then I should see projected final ranks based on:
      | Current scores               |
      | Historical performance       |
      | Remaining team strength      |
      | Schedule difficulty          |

  Scenario: View win probability for remaining players
    Given 8 players remain with 2 weeks left
    When I view win probabilities
    Then each player shows their chance to win:
      | player1 | 28% |
      | player2 | 22% |
      | player3 | 18% |
      | player4 | 15% |
      | player5 | 8%  |
      | player6 | 5%  |
      | player7 | 3%  |
      | player8 | 1%  |

  Scenario: Calculate optimal remaining path
    Given I have 3 teams eliminated
    And 11 teams available
    And 2 weeks remain
    When I request optimal path analysis
    Then I should see recommended teams ranked by:
      | Expected fantasy points      |
      | Win probability              |
      | Schedule matchup             |
      | Historical playoff performance|

  Scenario: View "What-If" scenarios
    Given I am analyzing my standings
    When I run a "what-if" scenario
    Then I can select different team outcomes
    And see how each outcome affects my rank
    And see points needed to reach specific ranks

  # ============================================
  # COMMISSIONER TOOLS
  # ============================================

  Scenario: Commissioner adjusts player score
    Given I am the league commissioner
    And player "bob_player" has a score of 125.5
    When I adjust their score by +5.0 with reason "Stat correction"
    Then their new score is 130.5
    And an audit log entry is created
    And all players are notified of the adjustment
    And the leaderboard recalculates

  Scenario: Commissioner overrides elimination
    Given player "jane_player" was eliminated in week 2
    And commissioner determines it was an error
    When I reinstate player "jane_player"
    Then their status changes to ACTIVE
    And they can make week 3 selections
    And standings recalculate to include them
    And an audit entry documents the override

  Scenario: Commissioner freezes standings
    Given a dispute is ongoing
    When I freeze the standings
    Then no score updates are processed
    And the leaderboard shows "FROZEN" status
    And players cannot be eliminated during freeze
    And I must manually unfreeze to resume

  Scenario: View commissioner audit log
    Given I am the league commissioner
    When I view the audit log
    Then I should see all commissioner actions:
      | timestamp | action | target | reason |
    And I can filter by action type
    And I can export the audit log

  # ============================================
  # LEADERBOARD CUSTOMIZATION
  # ============================================

  Scenario: Customize leaderboard display columns
    Given I am viewing the leaderboard
    When I customize the display
    Then I can show or hide columns:
      | Column            | Default |
      | Rank              | shown   |
      | Player Name       | shown   |
      | Total Score       | shown   |
      | Weekly Scores     | hidden  |
      | Team Selections   | hidden  |
      | Trend Arrow       | shown   |
      | Eliminated Count  | hidden  |
    And my preferences are saved

  Scenario: Apply leaderboard theme
    Given the league has a custom theme configured
    When I view the leaderboard
    Then league colors are applied
    And team logos use league branding
    And custom headers are displayed

  Scenario: Enable compact vs detailed view
    When I toggle to compact view
    Then I see only rank, name, and score
    When I toggle to detailed view
    Then I see all available columns
    And weekly breakdown is expanded

  # ============================================
  # LEADERBOARD CACHING AND PERFORMANCE
  # ============================================

  Scenario: Leaderboard responds within SLA
    Given the league has 100 players
    When I request the leaderboard
    Then response time should be under 200ms
    And the response should be cached for 30 seconds
    And cache headers should be set appropriately

  Scenario: Cache invalidation on score update
    Given the leaderboard is cached
    When a score update occurs
    Then the cache is invalidated
    And next request fetches fresh data
    And cache is refreshed with new standings

  Scenario: Handle high traffic during game time
    Given 1000 concurrent users request the leaderboard
    When the system is under load
    Then all requests should complete within 500ms
    And rate limiting should apply at 100 req/sec per user
    And the system should not degrade

  # ============================================
  # ERROR HANDLING
  # ============================================

  Scenario: Handle missing score data gracefully
    Given player "john_player" has no score for week 2
    When I view the leaderboard
    Then week 2 score shows "N/A" or 0
    And the player still appears in standings
    And an indicator shows incomplete data

  Scenario: Handle leaderboard request for invalid week
    When I request the leaderboard for week 99
    Then I receive error "INVALID_WEEK"
    And error message says "Week 99 does not exist for this game"
    And HTTP status code is 400

  Scenario: Handle unauthorized leaderboard access
    Given I am not a member of private league "Secret League"
    When I request that league's leaderboard
    Then I receive error "UNAUTHORIZED"
    And HTTP status code is 403
    And no leaderboard data is exposed

  Scenario: Handle leaderboard for non-existent league
    When I request leaderboard for league ID "nonexistent123"
    Then I receive error "LEAGUE_NOT_FOUND"
    And HTTP status code is 404

  Scenario: Graceful degradation when real-time unavailable
    Given the WebSocket service is unavailable
    When I view the leaderboard
    Then I see the last known standings
    And a banner shows "Live updates temporarily unavailable"
    And manual refresh button is displayed
    And polling fallback activates at 5-minute intervals

  # ============================================
  # STANDINGS VALIDATION
  # ============================================

  Scenario Outline: Validate leaderboard response structure
    Given a valid league with players
    When I request the <endpoint> endpoint
    Then the response should contain required fields:
      | field           | type    |
      | standings       | array   |
      | totalPlayers    | integer |
      | lastUpdated     | datetime|
      | currentWeek     | integer |
    And each standing entry contains:
      | playerId        | string  |
      | playerName      | string  |
      | rank            | integer |
      | totalScore      | decimal |

    Examples:
      | endpoint             |
      | overall leaderboard  |
      | weekly leaderboard   |
      | my standings         |

  Scenario Outline: Validate pagination parameters
    Given a league with <playerCount> players
    When I request page <page> with size <pageSize>
    Then I should receive <expectedCount> records
    And totalPages should be <totalPages>

    Examples:
      | playerCount | page | pageSize | expectedCount | totalPages |
      | 100         | 1    | 20       | 20            | 5          |
      | 100         | 5    | 20       | 20            | 5          |
      | 100         | 6    | 20       | 0             | 5          |
      | 45          | 2    | 25       | 20            | 2          |
      | 10          | 1    | 50       | 10            | 1          |

  Scenario Outline: Validate score calculation accuracy
    Given player scores:
      | week1   | week2   | week3   | week4   |
      | <w1>    | <w2>    | <w3>    | <w4>    |
    When I calculate total score
    Then the total should be <total>
    And precision should be to 1 decimal place

    Examples:
      | w1    | w2    | w3    | w4    | total   |
      | 100.0 | 100.0 | 100.0 | 100.0 | 400.0   |
      | 50.5  | 75.3  | 88.9  | 0.0   | 214.7   |
      | 0.0   | 0.0   | 0.0   | 0.0   | 0.0     |
      | 99.99 | 0.01  | 50.0  | 50.0  | 200.0   |

  # ============================================
  # AWARDS AND ACHIEVEMENTS
  # ============================================

  Scenario: Display weekly high scorer award
    Given week 1 is complete
    And player "star_player" had the highest score of 165.8
    When I view the leaderboard
    Then player "star_player" should have a "High Scorer" badge for week 1
    And hovering shows "Week 1 High Score: 165.8 points"

  Scenario: Track achievement unlocks
    Given player "jane_player" has achieved:
      | achievement              | criteria                |
      | Hot Streak               | 3+ weeks above average  |
      | Upset King               | Selected underdog 3x    |
      | Consistency Champion     | Low variance scores     |
    When I view her player card
    Then all earned badges are displayed
    And achievement dates are shown

  Scenario: Leaderboard shows special designations
    Given the following special statuses:
      | player   | status            |
      | player1  | Current Leader    |
      | player2  | Biggest Mover (+5)|
      | player3  | Danger Zone       |
      | player4  | Eliminated        |
    When I view the leaderboard
    Then each player shows appropriate designation icon
    And tooltips explain each designation

  Scenario: View league records
    Given the league has historical data
    When I view league records
    Then I should see:
      | record                  | holder    | value  | date       |
      | Highest Weekly Score    | player1   | 185.5  | Week 2     |
      | Lowest Winning Score    | player8   | 82.3   | Week 4     |
      | Longest Win Streak      | player3   | 4 weeks| 2024       |
      | Most Total Points       | player2   | 425.8  | 2024       |
      | Most Eliminations       | player5   | 0      | Current    |

  # ============================================
  # ACCESSIBILITY
  # ============================================

  Scenario: Screen reader accessibility for leaderboard
    Given I am using a screen reader
    When I navigate the leaderboard
    Then table headers are properly labeled
    And rank changes are announced
    And focus indicators are visible
    And keyboard navigation works correctly

  Scenario: High contrast mode for leaderboard
    Given I have enabled high contrast mode
    When I view the leaderboard
    Then all text meets WCAG AA contrast requirements
    And status indicators use patterns not just colors
    And elimination status is conveyed via text and icon

  Scenario: Leaderboard supports reduced motion
    Given I have enabled reduced motion preference
    When the leaderboard updates
    Then score changes appear without animation
    And rank movements are instant not animated
    And page transitions are simplified
