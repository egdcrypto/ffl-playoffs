Feature: Fantasy Football Roster Management (ONE-TIME DRAFT MODEL)
  As a league player
  I want to build my fantasy football roster ONCE before the season
  So that I can compete with my locked roster for all weeks

  CRITICAL RULE: ONE-TIME DRAFT MODEL
  - Build roster ONCE before first game starts
  - Roster PERMANENTLY LOCKED when first game starts
  - NO changes for entire season: no waiver wire, no trades, no weekly adjustments
  - Must live with roster decisions for all configured weeks

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the league uses standard roster configuration:
      | position | slots |
      | QB       | 1     |
      | RB       | 2     |
      | WR       | 2     |
      | TE       | 1     |
      | FLEX     | 1     |
      | K        | 1     |
      | DEF      | 1     |
    And I am authenticated as league player "john_player"

  Scenario: League player builds initial roster
    Given it is before the league start date
    And I have not yet built my roster
    When I select the following NFL players:
      | position | player                 | nfl_team            |
      | QB       | Patrick Mahomes        | Kansas City Chiefs  |
      | RB       | Christian McCaffrey    | San Francisco 49ers |
      | RB       | Saquon Barkley         | Philadelphia Eagles |
      | WR       | Tyreek Hill            | Miami Dolphins      |
      | WR       | CeeDee Lamb            | Dallas Cowboys      |
      | TE       | Travis Kelce           | Kansas City Chiefs  |
      | FLEX     | Stefon Diggs (WR)      | Buffalo Bills       |
      | K        | Justin Tucker          | Baltimore Ravens    |
      | DEF      | San Francisco 49ers    | San Francisco 49ers |
    Then my roster should be saved successfully
    And my roster should have 9 players
    And all position slots should be filled

  Scenario: League player must fill all required roster positions
    Given I am building my roster
    And I have selected:
      | position | player           |
      | QB       | Patrick Mahomes  |
      | RB       | Saquon Barkley   |
    When I attempt to finalize my roster
    Then roster finalization should fail
    And I should receive error "Roster incomplete: Missing WR (2), TE (1), FLEX (1), K (1), DEF (1)"

  Scenario: League player cannot select same NFL player twice in roster
    Given I am building my roster
    And I have selected "Travis Kelce" (TE) for my TE position
    When I attempt to select "Travis Kelce" for my FLEX position
    Then the selection should fail
    And I should receive error "Travis Kelce is already on your roster in position TE"

  Scenario: Multiple league players can select the same NFL player (NO draft restrictions)
    Given league player "player1" has "Patrick Mahomes" as their QB
    And league player "player2" has "Patrick Mahomes" as their QB
    And I am league player "player3"
    When I select "Patrick Mahomes" for my QB position
    Then my selection should be saved successfully
    And all 3 league players have "Patrick Mahomes" on their roster
    And there is NO ownership restriction - unlimited players can select same NFL player
    And this is NOT a draft where players become unavailable after selection

  Scenario: League player views their complete roster
    Given I have built my roster with 9 NFL players
    When I request my roster
    Then I should see my 9 selected NFL players
    And each player should display:
      | player name          |
      | position             |
      | NFL team             |
      | current season stats |
      | points this week     |
      | total points         |

  Scenario: FLEX position accepts RB, WR, or TE
    Given I am building my roster
    And I have not yet filled my FLEX position
    When I select a RB for FLEX
    Then the selection should succeed
    When I select a WR for FLEX
    Then the selection should succeed
    When I select a TE for FLEX
    Then the selection should succeed
    When I attempt to select a QB for FLEX
    Then the selection should fail with "QB not eligible for FLEX"

  Scenario: League player makes roster changes before first game starts
    Given the first game starts at "2025-09-10 13:00:00"
    And the current time is "2025-09-10 10:00:00"
    And I have "Josh Allen" as my QB
    When I drop "Josh Allen" and add "Lamar Jackson" at QB
    Then my roster should be updated
    And my QB should be "Lamar Jackson"

  Scenario: League player CANNOT make roster changes after first game starts (PERMANENT LOCK)
    Given the first game started at "2025-09-10 13:00:00"
    And the current time is "2025-09-10 14:00:00"
    And I have "Josh Allen" as my QB
    When I attempt to drop "Josh Allen" and add "Lamar Jackson"
    Then the change should fail
    And I should receive error "ROSTER_PERMANENTLY_LOCKED"
    And the error message should be "Roster is permanently locked - no changes allowed for entire season"

  Scenario: Permanent roster lock warning before first game
    Given the first game starts at "2025-09-10 13:00:00"
    And the current time is "2025-09-10 11:30:00"
    And I have an incomplete roster
    When I view my roster
    Then I should see a warning "PERMANENT ROSTER LOCK in 1 hour 30 minutes"
    And I should see "Complete your roster before first game - NO changes allowed after lock"
    And I should see "This is a one-time draft model"

  Scenario: Calculate league player's total score from all roster players
    Given I have built my roster
    And my roster includes:
      | position | player           | week_score |
      | QB       | Patrick Mahomes  | 28.5       |
      | RB       | Saquon Barkley   | 22.0       |
      | RB       | Christian McCaffrey | 31.5    |
      | WR       | Tyreek Hill      | 18.0       |
      | WR       | CeeDee Lamb      | 21.5       |
      | TE       | Travis Kelce     | 15.0       |
      | FLEX     | Stefon Diggs     | 12.5       |
      | K        | Justin Tucker    | 9.0        |
      | DEF      | 49ers Defense    | 12.0       |
    When the week scoring is calculated
    Then my total score should be 170.0 (sum of all 9 players)

  Scenario: NFL player on BYE week scores 0 points
    Given I have "Josh Allen" (QB) on my roster
    And the Buffalo Bills have a BYE in week 14
    And we are in NFL week 14
    When weekly scores are calculated
    Then "Josh Allen" should score 0 points for week 14
    And my total score should reflect this 0

  Scenario: NFL player who doesn't play scores 0 points
    Given I have "Travis Kelce" (TE) on my roster
    And "Travis Kelce" is inactive/injured for this week's game
    When weekly scores are calculated
    Then "Travis Kelce" should score 0 points
    And my total score should reflect this 0

  Scenario: View league standings - all league players ranked by total score
    Given the league has 10 league players
    And each league player has built their roster
    And week 1 is complete
    When I view the league standings
    Then I should see all 10 league players ranked by total score
    And each league player should show:
      | rank                          |
      | league player name            |
      | total score                   |
      | week score                    |
      | roster preview (top players)  |

  Scenario: League player cannot exceed position limits
    Given I have 2 RBs on my roster (maximum)
    When I attempt to add a 3rd RB
    Then the addition should fail
    And I should receive error "RB position limit reached (2/2)"
    And I should be prompted to drop an existing RB first

  Scenario: View NFL player game-by-game performance
    Given I have "Patrick Mahomes" on my roster
    And we are in week 5 of the season
    When I view "Patrick Mahomes" details
    Then I should see his game-by-game scores:
      | week | opponent        | points |
      | 1    | @ Detroit       | 28.5   |
      | 2    | vs Jacksonville | 31.0   |
      | 3    | @ Atlanta       | 25.5   |
      | 4    | vs LA Chargers  | 22.0   |
      | 5    | vs New Orleans  | --     |

  Scenario: Filter available NFL players by position when adding to roster
    Given I am adding a player to my QB position
    When I view available players
    Then I should only see QBs
    And I can further filter by:
      | NFL team         |
      | points per game  |
      | total points     |
      | status           |

  Scenario: Filter available NFL players by NFL team
    Given I am adding a player to my roster
    When I filter by NFL team "Kansas City Chiefs"
    Then I should see all Chiefs players
    And they should be grouped by position:
      | Patrick Mahomes    | QB  |
      | Travis Kelce       | TE  |
      | Isiah Pacheco      | RB  |
      | Rashee Rice        | WR  |

  Scenario: Search for NFL players by name
    Given I am adding a player to my roster
    When I search for "Kelce"
    Then I should see:
      | Travis Kelce | TE | Kansas City Chiefs    |
      | Jason Kelce  | C  | Philadelphia Eagles   |

  Scenario: View my roster with real-time score updates
    Given I have built my roster
    And NFL games are in progress
    When I view my roster
    Then I should see real-time score updates for active players
    And each player should show:
      | current game status (LIVE/FINAL/UPCOMING) |
      | live points (updating)                    |
      | opponent                                  |

  Scenario: Roster configuration varies by league
    Given the league admin configures custom roster slots:
      | position | slots |
      | QB       | 2     |
      | RB       | 3     |
      | WR       | 3     |
      | TE       | 2     |
      | FLEX     | 2     |
      | K        | 0     |
      | DEF      | 2     |
    When I build my roster
    Then I must fill:
      | 2 QBs     |
      | 3 RBs     |
      | 3 WRs     |
      | 2 TEs     |
      | 2 FLEX    |
      | 0 Kickers |
      | 2 DEF     |

  Scenario: DEF position selects entire team defense
    Given I am filling my DEF position
    When I view available defenses
    Then I should see all 32 NFL team defenses
    And each defense should display:
      | team name                |
      | points allowed per game  |
      | sacks                    |
      | interceptions            |
      | defensive TDs            |
      | fantasy points           |

  Scenario: Paginate NFL players when building roster
    Given there are 1000+ NFL players available
    When I am adding a WR to my roster
    Then I should see 20 WRs per page (default)
    And I can change page size to 10, 20, 50, or 100
    And I can navigate pages
    And I can sort by:
      | name              |
      | team              |
      | points this week  |
      | total points      |
      | avg points        |

  # Permanent Roster Lock Enforcement

  Scenario: Injured player must remain on locked roster for entire season
    Given my roster was locked on "2025-01-12 13:00:00"
    And I have "Christian McCaffrey" (RB) on my roster
    And we are in week 8
    And "Christian McCaffrey" suffered season-ending injury in week 5
    When I view my roster
    Then "Christian McCaffrey" should still be on my roster
    And "Christian McCaffrey" should show 0 points for weeks 5-17
    And I should see message "Player injured - roster locked, no replacement allowed"
    And I cannot drop or replace "Christian McCaffrey"

  Scenario: League player must accept consequences of draft decisions
    Given my roster was locked on "2025-01-12 13:00:00"
    And I have the following players on my roster:
      | player            | status            | weeks_missed |
      | Player A          | Season-ending IR  | 12           |
      | Player B          | Suspended         | 4            |
      | Player C          | Traded to new team| 0            |
    Then all 3 players must remain on my roster
    And I must accept 0 points for all missed weeks
    And I should see message "ONE-TIME DRAFT model - all roster decisions are final"

  Scenario: No waiver wire system exists
    Given my roster is locked
    And there are high-performing free agent players available
    When I view the waiver wire section
    Then I should see message "Waiver wire not available - this is a one-time draft league"
    And I should not be able to claim any free agents
    And all roster modification features should be disabled

  Scenario: No trade system exists
    Given my roster is locked
    And another league player wants to trade with me
    When I attempt to access the trade interface
    Then I should see message "Trades not available - this is a one-time draft league"
    And I should not be able to propose or accept trades
    And roster is locked for entire season

  Scenario: Roster lock applies to all weeks in league configuration
    Given the league is configured for weeks 15-18 (4 weeks)
    And my roster was locked on "2025-01-12 13:00:00" (before week 15)
    When week 15 completes
    And week 16 starts
    Then my roster should remain unchanged
    When week 17 completes
    And week 18 starts
    Then my roster should remain unchanged
    And I compete with the same 10 players for all 4 weeks
