Feature: Individual NFL Player Selection
  As a league player
  I want to select individual NFL players by position
  So that I can compete based on their individual game performances

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 4 weeks configured
    And I am authenticated as league player "john_player"

  # ============================================================================
  # BASIC PLAYER SELECTION SCENARIOS
  # ============================================================================

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

  # ============================================================================
  # POSITION-BASED FILTERING AND DISPLAY
  # ============================================================================

  Scenario: Filter NFL players by position QB
    Given I am selecting a player for week 1
    When I filter by position "QB"
    Then I should see only quarterbacks
    And each QB should display:
      | Field            | Description                    |
      | name             | Player full name               |
      | position         | QB                             |
      | team             | NFL team name                  |
      | passingYards     | Season passing yards           |
      | passingTDs       | Season passing touchdowns      |
      | interceptions    | Season interceptions thrown    |
      | completionPct    | Completion percentage          |
      | rushingYards     | Rushing yards (dual-threat)    |
      | rushingTDs       | Rushing touchdowns             |
      | qbRating         | Passer rating                  |

  Scenario: Filter NFL players by position RB
    Given I am selecting a player for week 1
    When I filter by position "RB"
    Then I should see only running backs
    And each RB should display:
      | Field            | Description                    |
      | name             | Player full name               |
      | position         | RB                             |
      | team             | NFL team name                  |
      | rushingYards     | Season rushing yards           |
      | rushingTDs       | Season rushing touchdowns      |
      | rushingAttempts  | Total rushing attempts         |
      | yardsPerCarry    | Average yards per carry        |
      | receptions       | Receiving receptions           |
      | receivingYards   | Receiving yards                |
      | receivingTDs     | Receiving touchdowns           |

  Scenario: Filter NFL players by position WR
    Given I am selecting a player for week 1
    When I filter by position "WR"
    Then I should see only wide receivers
    And each WR should display:
      | Field            | Description                    |
      | name             | Player full name               |
      | position         | WR                             |
      | team             | NFL team name                  |
      | receptions       | Season receptions              |
      | receivingYards   | Season receiving yards         |
      | receivingTDs     | Season receiving touchdowns    |
      | targets          | Total targets                  |
      | yardsPerReception| Average yards per reception    |
      | catchPercentage  | Catch percentage               |

  Scenario: Filter NFL players by position TE
    Given I am selecting a player for week 1
    When I filter by position "TE"
    Then I should see only tight ends
    And each TE should display:
      | Field            | Description                    |
      | name             | Player full name               |
      | position         | TE                             |
      | team             | NFL team name                  |
      | receptions       | Season receptions              |
      | receivingYards   | Season receiving yards         |
      | receivingTDs     | Season receiving touchdowns    |
      | targets          | Total targets                  |
      | yardsPerReception| Average yards per reception    |

  Scenario: Filter NFL players by position K
    Given I am selecting a player for week 1
    When I filter by position "K"
    Then I should see only kickers
    And each K should display:
      | Field            | Description                    |
      | name             | Player full name               |
      | position         | K                              |
      | team             | NFL team name                  |
      | fieldGoalsMade   | Field goals made               |
      | fieldGoalsAtt    | Field goals attempted          |
      | fgPercentage     | Field goal percentage          |
      | extraPointsMade  | Extra points made              |
      | extraPointsAtt   | Extra points attempted         |
      | longestFG        | Longest field goal             |
      | fg50Plus         | Field goals 50+ yards          |

  Scenario: Filter NFL players by position DEF
    Given I am selecting a player for week 1
    When I filter by position "DEF"
    Then I should see only team defenses
    And each DEF should display:
      | Field            | Description                    |
      | name             | Team defense name              |
      | position         | DEF                            |
      | team             | NFL team name                  |
      | pointsAllowed    | Points allowed per game        |
      | yardsAllowed     | Yards allowed per game         |
      | sacks            | Total sacks                    |
      | interceptions    | Total interceptions            |
      | fumbleRecoveries | Fumbles recovered              |
      | defensiveTDs     | Defensive touchdowns           |
      | safeties         | Safeties                       |

  Scenario: Filter NFL players by team
    Given I am selecting a player for week 1
    When I filter by NFL team "Kansas City Chiefs"
    Then I should see only Chiefs players
    And players should include:
      | Patrick Mahomes  | QB  |
      | Travis Kelce     | TE  |
      | Isiah Pacheco    | RB  |
      | Chiefs Defense   | DEF |

  Scenario: Combined position and team filter
    Given I am selecting a player for week 1
    When I filter by position "WR" and team "Dallas Cowboys"
    Then I should see only Cowboys wide receivers
    And results should include:
      | CeeDee Lamb     | WR | Dallas Cowboys |
      | Brandin Cooks   | WR | Dallas Cowboys |

  # ============================================================================
  # PLAYER USAGE TRACKING
  # ============================================================================

  Scenario: Player usage is tracked per league player
    Given I have made the following selections:
      | week | player           | position |
      | 1    | Patrick Mahomes  | QB       |
      | 2    | Josh Allen       | QB       |
    When I view my player usage
    Then I should see 2 players marked as used:
      | player           | usedInWeek |
      | Patrick Mahomes  | 1          |
      | Josh Allen       | 2          |
    And I should see 2 remaining weeks without selections

  Scenario: Player usage prevents duplicate selection across weeks
    Given I selected "Tyreek Hill" (WR, Miami Dolphins) for week 1
    And I selected "Ja'Marr Chase" (WR, Cincinnati Bengals) for week 2
    When I attempt to select "Tyreek Hill" for week 3
    Then the selection should fail
    And I should receive error "You have already selected this player in week 1"
    And my usage count remains 2 players

  Scenario: Player usage is released when selection is changed
    Given I selected "Lamar Jackson" (QB, Baltimore Ravens) for week 1
    And "Lamar Jackson" is marked as used by me
    When I change my week 1 selection to "Joe Burrow" (QB, Cincinnati Bengals)
    Then "Lamar Jackson" should no longer be marked as used
    And "Joe Burrow" should be marked as used in week 1
    And my total usage count remains 1

  Scenario: Player usage is independent per league
    Given I am in two leagues: "League Alpha" and "League Beta"
    And I selected "Patrick Mahomes" in League Alpha for week 1
    When I make a selection in League Beta for week 1
    Then "Patrick Mahomes" should be available for selection
    And I can select "Patrick Mahomes" in League Beta
    And usage tracking is per-league, not global

  Scenario: View comprehensive usage report
    Given I have made selections for all 4 weeks:
      | week | player              | position | score |
      | 1    | Patrick Mahomes     | QB       | 28.5  |
      | 2    | Christian McCaffrey | RB       | 22.0  |
      | 3    | Tyreek Hill         | WR       | 18.5  |
      | 4    | Travis Kelce        | TE       | 15.0  |
    When I request my usage report
    Then I should see:
      | totalPlayersUsed  | 4                    |
      | remainingWeeks    | 0                    |
      | totalScore        | 84.0                 |
      | averageScore      | 21.0                 |
      | highestScore      | Patrick Mahomes, 28.5|
      | lowestScore       | Travis Kelce, 15.0   |

  Scenario: Usage tracking with unused weeks
    Given I have made selections for weeks 1 and 3 only:
      | week | player           |
      | 1    | Josh Allen       |
      | 3    | CeeDee Lamb      |
    When I view my player usage
    Then I should see:
      | usedPlayers | 2                     |
      | week1       | Josh Allen            |
      | week2       | (no selection)        |
      | week3       | CeeDee Lamb           |
      | week4       | (no selection)        |

  # ============================================================================
  # ADVANCE PICKS AND MULTI-WEEK SELECTION
  # ============================================================================

  Scenario: League player makes selections for all 4 weeks in advance
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

  Scenario: Advance picks can be modified before respective deadlines
    Given the game allows advance picks
    And I have made advance selections:
      | week | player           |
      | 1    | Patrick Mahomes  |
      | 2    | Josh Allen       |
      | 3    | Lamar Jackson    |
      | 4    | Jalen Hurts      |
    And it is currently week 2
    And week 2 deadline has not passed
    When I change my week 3 selection to "Justin Herbert"
    Then the change should be saved successfully
    And my week 3 pick should be "Justin Herbert"
    But I cannot change my week 1 selection (deadline passed)

  Scenario: Advance picks lock at their respective deadlines
    Given the game allows advance picks
    And I selected "Patrick Mahomes" for week 1
    And I selected "Josh Allen" for week 2
    And the week 1 deadline has passed
    And the week 2 deadline has not passed
    When I attempt to change my week 1 selection
    Then the change should fail with "Pick deadline has passed for week 1"
    When I change my week 2 selection to "Lamar Jackson"
    Then the change should succeed

  # ============================================================================
  # SCORING AND GAME PERFORMANCE
  # ============================================================================

  Scenario: NFL player scores points for each game played during the week
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

  Scenario: Score breakdown by statistical category
    Given I selected "Patrick Mahomes" for week 1
    And "Patrick Mahomes" had the following stats:
      | passingYards | 350  |
      | passingTDs   | 3    |
      | interceptions| 1    |
      | rushingYards | 25   |
      | rushingTDs   | 0    |
    When I view my week 1 score details
    Then I should see score breakdown:
      | category       | stats | points |
      | Passing Yards  | 350   | 14.0   |
      | Passing TDs    | 3     | 12.0   |
      | Interceptions  | 1     | -2.0   |
      | Rushing Yards  | 25    | 2.5    |
      | Total          |       | 26.5   |

  # ============================================================================
  # PLAYER STATUS CHANGES AFTER SELECTION
  # ============================================================================

  Scenario: Selected player is injured after selection
    Given I selected "Nick Chubb" (RB, Cleveland Browns) for week 2
    And the pick deadline for week 2 has passed
    When "Nick Chubb" is placed on injured reserve
    Then my selection remains "Nick Chubb" for week 2
    And if "Nick Chubb" does not play, I receive 0 points
    And I cannot change my selection after the deadline

  Scenario: Selected player is traded to another team
    Given I selected "Amari Cooper" (WR, Cleveland Browns) for week 3
    And the pick deadline for week 3 has passed
    When "Amari Cooper" is traded to the Buffalo Bills
    Then my selection remains "Amari Cooper" for week 3
    And "Amari Cooper" now plays for Buffalo Bills
    And points are based on his new team's game performance

  Scenario: Selected player is released/waived
    Given I selected "Ezekiel Elliott" (RB, Dallas Cowboys) for week 2
    And the pick deadline for week 2 has passed
    When "Ezekiel Elliott" is released by Dallas
    Then my selection remains "Ezekiel Elliott" for week 2
    And if not signed by another team, I receive 0 points
    And my selection cannot be changed

  Scenario: Selected player retires mid-season
    Given I selected "Aaron Rodgers" (QB, New York Jets) for week 4
    And the pick deadline for week 4 has passed
    When "Aaron Rodgers" announces retirement
    Then my selection remains "Aaron Rodgers" for week 4
    And I receive 0 points for week 4
    And the selection is locked

  Scenario: Selected player has bye week
    Given I selected "Travis Kelce" for week 2
    And the Kansas City Chiefs have a bye in week 2
    When week 2 completes
    Then "Travis Kelce" receives 0 points (no game played)
    And this is a valid selection (user's strategy choice)
    And a warning was shown during selection about the bye week

  Scenario: Display bye week warning during selection
    Given I am selecting a player for week 2
    And the Kansas City Chiefs have a bye in week 2
    When I view "Travis Kelce" as a selection option
    Then a warning should be displayed: "BYE WEEK - Chiefs do not play in week 2"
    And I can still select "Travis Kelce" if I choose
    And the selection proceeds with acknowledgment

  # ============================================================================
  # DEADLINE MANAGEMENT
  # ============================================================================

  Scenario: League player receives reminder before pick deadline
    Given it is week 2 of the game
    And I have not made a selection for week 2
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 11:00:00"
    And reminder notifications are enabled
    Then I should receive a reminder notification
    And the reminder should indicate "2 hours remaining to make your pick"

  Scenario: League player views pick deadline countdown
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:30:00"
    When I request the current week information
    Then I should receive deadline information
    And the time remaining should be "1 hour 30 minutes"
    And the deadline status should be "OPEN"

  Scenario: Deadline countdown shows urgent status
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 12:45:00"
    When I request the current week information
    Then the time remaining should be "15 minutes"
    And the deadline status should be "URGENT"
    And the UI should show a prominent warning

  Scenario: Deadline status shows closed after passing
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 13:05:00"
    When I request the current week information
    Then the deadline status should be "CLOSED"
    And the UI should indicate "Picks are locked for week 1"

  Scenario: 24-hour reminder notification
    Given the pick deadline for week 2 is in 24 hours
    And I have not made a selection for week 2
    When the notification scheduler runs
    Then I receive a notification with subject "24 hours to make your pick"
    And the notification lists my current selection status

  Scenario: 1-hour urgent reminder notification
    Given the pick deadline for week 2 is in 1 hour
    And I have not made a selection for week 2
    When the notification scheduler runs
    Then I receive an urgent notification
    And the notification subject is "URGENT: 1 hour to make your pick"
    And the notification is marked high priority

  # ============================================================================
  # MULTI-PLAYER SELECTION RULES
  # ============================================================================

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

  Scenario: View how many league players selected each NFL player
    Given it is week 2 of the game
    And the following selections were made for week 2:
      | player          | selectedBy          |
      | Patrick Mahomes | player1, player2    |
      | Josh Allen      | player3             |
      | Travis Kelce    | player1, player3, player4 |
    When I view available players with popularity stats
    Then I should see:
      | player          | timesSelected |
      | Patrick Mahomes | 2             |
      | Josh Allen      | 1             |
      | Travis Kelce    | 3             |
    And this is for informational purposes only
    And it does not affect availability

  # ============================================================================
  # VALIDATION AND ERROR HANDLING
  # ============================================================================

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

  Scenario: Cannot select player from invalid position
    Given I am selecting a player for week 1
    When I attempt to select "John Doe" with position "INVALID"
    Then the selection should fail
    And I should receive error "Invalid position type"

  Scenario: Cannot select player for non-existent week
    Given the game has 4 weeks configured
    When I attempt to select a player for week 5
    Then the selection should fail
    And I should receive error "Week 5 does not exist in this game"

  Scenario: Cannot select player for week 0 or negative week
    When I attempt to select a player for week 0
    Then the selection should fail
    And I should receive error "Invalid week number"
    When I attempt to select a player for week -1
    Then the selection should fail

  Scenario: Concurrent selection attempts are handled correctly
    Given it is week 1 of the game
    And the deadline has not passed
    When I submit two selection requests simultaneously:
      | request1 | Patrick Mahomes |
      | request2 | Josh Allen      |
    Then exactly one selection should be saved
    And the other request should return conflict error
    And my final selection is deterministic

  Scenario Outline: Player selection validation across 4 weeks
    Given the game has 4 weeks configured
    And I have made the following selections:
      | week | player    |
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

  # ============================================================================
  # SEARCH AND DISCOVERY
  # ============================================================================

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
    And results are case-insensitive

  Scenario: Search with no results
    Given I am selecting a player for week 1
    When I search for "ZZZZNONEXISTENT"
    Then I should see an empty result set
    And a message "No players found matching your search"

  Scenario: Search combined with position filter
    Given I am selecting a player for week 1
    When I search for "Hill" and filter by position "WR"
    Then I should see only wide receivers named Hill:
      | Tyreek Hill | WR | Miami Dolphins |
    And I should not see:
      | Taysom Hill | QB/TE | New Orleans Saints |

  Scenario: Autocomplete player search
    Given I am selecting a player for week 1
    When I type "Pat" in the search box
    Then I should see autocomplete suggestions:
      | Patrick Mahomes   | QB | Kansas City Chiefs    |
      | Patrick Surtain   | CB | Denver Broncos        |
    And suggestions update as I type more characters

  # ============================================================================
  # PAGINATION AND SORTING
  # ============================================================================

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
    And there are approximately 64 QBs (32 teams x 2 QBs each)
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
      | totalPages     | 3                   |

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

  Scenario: Sort players by fantasy points
    Given I am viewing QB players for week 1
    When I sort by "fantasyPoints" descending
    Then players are ordered by their season fantasy points
    And the highest scoring players appear first

  Scenario: Sort players by recent performance
    Given I am viewing players for week 1
    When I sort by "lastGamePoints" descending
    Then players are ordered by their most recent game points
    And hot streaking players appear first

  Scenario: Sort players alphabetically
    Given I am viewing players for week 1
    When I sort by "name" ascending
    Then players are ordered A-Z by last name
    And "Allen, Josh" appears before "Mahomes, Patrick"

  # ============================================================================
  # API ENDPOINTS AND RESPONSES
  # ============================================================================

  Scenario: Get available players API returns correct structure
    Given it is week 1 of the game
    When I call GET /api/selections/available-players
    Then the response status is 200
    And the response includes:
      | Field           | Type     |
      | players         | array    |
      | pagination      | object   |
      | usedPlayerIds   | array    |
      | deadline        | datetime |
      | weekNumber      | integer  |

  Scenario: Make selection API validates input
    Given it is week 1 of the game
    When I call POST /api/selections with:
      | playerId   | 12345 |
      | weekNumber | 1     |
    Then the response status is 201
    And the response includes:
      | Field          | Value              |
      | selectionId    | (generated UUID)   |
      | playerId       | 12345              |
      | weekNumber     | 1                  |
      | status         | ACTIVE             |
      | createdAt      | (current time)     |

  Scenario: Get my selections API returns all selections
    Given I have made selections for weeks 1-3
    When I call GET /api/selections/me
    Then the response status is 200
    And the response includes 3 selections
    And each selection includes player details and scores

  Scenario: Update selection API replaces existing selection
    Given I have a selection for week 1
    When I call PUT /api/selections/{selectionId}
    Then the response status is 200
    And the old selection is replaced
    And usage tracking is updated

  Scenario: Delete selection API removes selection
    Given I have a selection for week 1
    And the deadline has not passed
    When I call DELETE /api/selections/{selectionId}
    Then the response status is 204
    And the player is no longer marked as used
    And my week 1 selection is empty

  Scenario: API returns appropriate error codes
    Given it is week 1 of the game
    When I call POST /api/selections with invalid data
    Then the response includes appropriate error code:
      | Scenario                  | Status | Error Code              |
      | Player not found          | 404    | PLAYER_NOT_FOUND        |
      | Deadline passed           | 400    | DEADLINE_PASSED         |
      | Player already used       | 409    | PLAYER_ALREADY_USED     |
      | Invalid week              | 400    | INVALID_WEEK            |
      | Not authenticated         | 401    | UNAUTHORIZED            |
      | Not authorized for league | 403    | FORBIDDEN               |

  # ============================================================================
  # PLAYER STATS AND PROJECTIONS
  # ============================================================================

  Scenario: View player season statistics
    Given I am viewing "Patrick Mahomes" profile
    When I request player details
    Then I should see comprehensive stats:
      | Category        | Value          |
      | Games Played    | 10             |
      | Passing Yards   | 3,250          |
      | Passing TDs     | 25             |
      | Interceptions   | 8              |
      | Rushing Yards   | 185            |
      | Rushing TDs     | 2              |
      | Fantasy Points  | 285.5          |
      | PPG Average     | 28.55          |

  Scenario: View player upcoming matchup
    Given I am viewing "Patrick Mahomes" for week 2 selection
    When I request player details
    Then I should see upcoming matchup:
      | opponent        | Los Angeles Chargers |
      | gameTime        | Sunday 4:25 PM ET    |
      | location        | @ LAC (Away)         |
      | opponentRank    | #15 vs QB            |
      | weatherForecast | 72F, Clear           |

  Scenario: View player game log
    Given I am viewing "Travis Kelce" profile
    When I request player game log
    Then I should see last 5 games:
      | Week | Opponent | Receptions | Yards | TDs | Points |
      | 10   | @ DEN    | 8          | 85    | 1   | 18.5   |
      | 9    | MIA      | 6          | 72    | 0   | 13.2   |
      | 8    | @ LV     | 10         | 105   | 2   | 26.5   |
      | 7    | LAC      | 5          | 45    | 0   | 9.5    |
      | 6    | BYE      | -          | -     | -   | 0.0    |

  Scenario: View player injury status
    Given I am viewing available players
    And "Davante Adams" has injury designation "Questionable"
    When I view "Davante Adams" in the player list
    Then I should see injury status:
      | status      | Questionable       |
      | injury      | Hamstring          |
      | updated     | Wednesday Practice |
      | gameStatus  | Game-time decision |

  # ============================================================================
  # MOBILE AND ACCESSIBILITY
  # ============================================================================

  Scenario: Mobile-optimized player selection interface
    Given I am on a mobile device
    When I view the player selection screen
    Then the interface is optimized for mobile:
      | Feature              | Behavior                    |
      | Player list          | Scrollable cards            |
      | Filters              | Collapsible drawer          |
      | Search               | Sticky search bar           |
      | Selection button     | Large touch target          |
      | Deadline countdown   | Persistent header           |

  Scenario: Screen reader announces player information
    Given I use a screen reader
    When I navigate the player list
    Then each player card is announced with:
      | "Patrick Mahomes, Quarterback, Kansas City Chiefs" |
      | "Season stats: 3250 passing yards, 25 touchdowns"  |
      | "Available for selection"                          |

  Scenario: Keyboard navigation for player selection
    Given I am using keyboard navigation
    When I navigate the player selection screen
    Then I can:
      | Action           | Key          |
      | Move to next     | Tab / Arrow  |
      | Select player    | Enter        |
      | Open filters     | F            |
      | Search           | /            |
      | Close modal      | Escape       |

  # ============================================================================
  # REAL-TIME UPDATES
  # ============================================================================

  Scenario: Real-time score updates during games
    Given I selected "Patrick Mahomes" for week 1
    And the Chiefs game is currently in progress
    When "Patrick Mahomes" throws a touchdown pass
    Then my week 1 score updates in real-time
    And a notification shows "+4 points: Passing TD"

  Scenario: Real-time injury updates
    Given I am viewing available players
    And a game is in progress
    When "Tyreek Hill" leaves the game with an injury
    Then the player list updates to show:
      | Tyreek Hill | WR | In-game injury |
    And a warning is shown if I try to select him

  Scenario: WebSocket connection for live updates
    Given I am on the player selection screen
    When I establish a WebSocket connection
    Then I receive real-time updates for:
      | Event Type        | Data                    |
      | SCORE_UPDATE      | Player scores           |
      | INJURY_UPDATE     | Injury status changes   |
      | GAME_START        | Game kickoffs           |
      | GAME_END          | Final scores            |
      | DEADLINE_WARNING  | Time remaining alerts   |

  # ============================================================================
  # TESTING AND EDGE CASES
  # ============================================================================

  Scenario: Handle timezone differences for deadlines
    Given the pick deadline is "2025-10-05 13:00:00 ET"
    And I am located in Pacific Time (PT)
    When I view the deadline
    Then I see "10:00:00 AM PT" (converted to my timezone)
    And the deadline enforces the correct moment regardless of display

  Scenario: Handle daylight saving time transitions
    Given the pick deadline falls during DST transition
    When the deadline is displayed and enforced
    Then the correct absolute moment is used
    And no ambiguity from clock changes

  Scenario: System handles high traffic during deadline rush
    Given the deadline is in 5 minutes
    And 1000 users are making last-minute selections
    When selections are submitted concurrently
    Then all valid selections are processed
    And the system maintains consistency
    And no selections are lost or duplicated

  Scenario: Recover from failed selection save
    Given I submit a selection
    And the database save fails due to transient error
    When the system retries
    Then my selection is saved successfully
    And I receive confirmation
    And no duplicate selections are created

  Scenario: Handle NFL data feed outage
    Given the NFL stats data feed is unavailable
    When I view available players
    Then I see cached player data (may be stale)
    And a warning indicates "Stats may be outdated"
    And I can still make selections

  Scenario: Simulate selection for testing
    Given the system is in test mode
    When I make a selection with test flag
    Then the selection is recorded in test database
    And no production data is affected
    And test mode is clearly indicated
