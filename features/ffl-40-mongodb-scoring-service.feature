@backend @scoring @mongodb @priority-critical
Feature: FFL-40: MongoDB-Based Scoring Service Implementation
  As a fantasy football platform
  I want to implement a comprehensive scoring service using MongoDB
  So that player scores are calculated, ranked, and stored with full audit trails

  Background:
    Given the application uses MongoDB for document storage
    And the ScoringService is defined in the domain layer
    And scoring rules are configurable per league
    And the NFL playoff season is active

  # ========================================
  # SECTION 1: SERVICE IMPLEMENTATION
  # ========================================

  @service @implementation @priority-critical
  Scenario: Create ScoringServiceImpl with MongoDB persistence
    Given the ScoringService interface is defined in domain/service
    When I create the MongoDB-based implementation
    Then ScoringServiceImpl should be in infrastructure/adapter/persistence
    And the class should be annotated with @Service
    And the class should implement ScoringService interface
    And the class should inject MongoTemplate for queries
    And the class should inject ScoringFormulaRepository

  @service @interface @priority-critical
  Scenario: Define ScoringService interface methods
    Given scoring operations need to be defined
    Then the ScoringService interface should have:
      | method                                    | return type           | description                    |
      | calculatePlayerScore(playerId, week)      | PlayerScore           | Calculate single player score  |
      | calculateRosterScore(rosterId, week)      | RosterScore           | Calculate entire roster score  |
      | calculateLeagueScores(leagueId, week)     | List<LeagueScore>     | Calculate all scores in league |
      | rankPlayers(leagueId, week)               | List<RankedPlayer>    | Rank players by score          |
      | getEliminatedPlayers(leagueId, week)      | List<EliminatedPlayer>| Get eliminated players         |
      | getScoreBreakdown(rosterId, week)         | ScoreBreakdown        | Detailed score breakdown       |
      | recalculateScores(leagueId, week)         | void                  | Recalculate after stat correction |

  @service @dependency @priority-high
  Scenario: Inject required dependencies
    Given ScoringServiceImpl needs external data
    When I configure dependency injection
    Then the service should inject:
      | dependency                 | purpose                           |
      | MongoTemplate              | Flexible MongoDB queries          |
      | ScoringFormulaRepository   | Get league scoring rules          |
      | NFLPlayerRepository        | Get player information            |
      | RosterRepository           | Get roster compositions           |
      | TeamSelectionRepository    | Get weekly team selections        |
      | ScoreAuditRepository       | Store audit trail                 |

  # ========================================
  # SECTION 2: SCORING CONFIGURATION
  # ========================================

  @config @formula @priority-critical
  Scenario: Store scoring formula in MongoDB
    Given scoring formulas are league-specific
    When I create a ScoringFormula document
    Then the document should contain:
      | field                   | type          | description                      |
      | _id                     | ObjectId      | Unique formula identifier        |
      | leagueId                | String        | Associated league                |
      | name                    | String        | Formula name (e.g., "Standard")  |
      | passingRules            | Object        | Passing touchdown, yards rules   |
      | rushingRules            | Object        | Rushing touchdown, yards rules   |
      | receivingRules          | Object        | Receiving TD, yards, PPR rules   |
      | defensiveRules          | Object        | Sacks, interceptions, etc.       |
      | kickingRules            | Object        | Field goals by distance          |
      | bonusRules              | Object        | Performance bonuses              |
      | isActive                | Boolean       | Whether formula is active        |
      | createdAt               | DateTime      | Creation timestamp               |
      | updatedAt               | DateTime      | Last update timestamp            |

  @config @passing @priority-high
  Scenario: Configure passing scoring rules
    Given a league uses custom passing scoring
    When I configure passing rules
    Then the passingRules object should contain:
      | field                  | type    | default | description                |
      | pointsPerPassingYard   | Double  | 0.04    | Points per passing yard    |
      | pointsPerPassingTD     | Double  | 4.0     | Points per passing TD      |
      | pointsPerInterception  | Double  | -2.0    | Points per INT thrown      |
      | pointsPer300YardBonus  | Double  | 3.0     | Bonus for 300+ yards       |
      | pointsPer400YardBonus  | Double  | 5.0     | Bonus for 400+ yards       |

  @config @rushing @priority-high
  Scenario: Configure rushing scoring rules
    Given a league uses custom rushing scoring
    When I configure rushing rules
    Then the rushingRules object should contain:
      | field                  | type    | default | description                |
      | pointsPerRushingYard   | Double  | 0.1     | Points per rushing yard    |
      | pointsPerRushingTD     | Double  | 6.0     | Points per rushing TD      |
      | pointsPerFumble        | Double  | -2.0    | Points per fumble lost     |
      | pointsPer100YardBonus  | Double  | 3.0     | Bonus for 100+ yards       |
      | pointsPer200YardBonus  | Double  | 5.0     | Bonus for 200+ yards       |

  @config @receiving @priority-high
  Scenario: Configure receiving scoring rules with PPR
    Given a league uses PPR (Points Per Reception) scoring
    When I configure receiving rules
    Then the receivingRules object should contain:
      | field                  | type    | default | description                |
      | pointsPerReception     | Double  | 1.0     | PPR points per catch       |
      | pointsPerReceivingYard | Double  | 0.1     | Points per receiving yard  |
      | pointsPerReceivingTD   | Double  | 6.0     | Points per receiving TD    |
      | pointsPer100YardBonus  | Double  | 3.0     | Bonus for 100+ yards       |

  @config @defensive @priority-high
  Scenario: Configure defensive scoring rules
    Given a league scores defensive players
    When I configure defensive rules
    Then the defensiveRules object should contain:
      | field                  | type    | default | description                |
      | pointsPerSack          | Double  | 1.0     | Points per sack            |
      | pointsPerInterception  | Double  | 2.0     | Points per INT             |
      | pointsPerFumbleRecovery| Double  | 2.0     | Points per fumble recovery |
      | pointsPerDefensiveTD   | Double  | 6.0     | Points per defensive TD    |
      | pointsPerSafety        | Double  | 2.0     | Points per safety          |
      | pointsPerPassDefended  | Double  | 0.5     | Points per pass defended   |

  @config @kicking @priority-high
  Scenario: Configure kicking scoring rules by distance
    Given field goals are scored by distance
    When I configure kicking rules
    Then the kickingRules object should contain:
      | field                  | type    | default | description                |
      | pointsPerExtraPoint    | Double  | 1.0     | Points per XP made         |
      | pointsPerFG0to39       | Double  | 3.0     | FG 0-39 yards              |
      | pointsPerFG40to49      | Double  | 4.0     | FG 40-49 yards             |
      | pointsPerFG50to59      | Double  | 5.0     | FG 50-59 yards             |
      | pointsPerFG60Plus      | Double  | 6.0     | FG 60+ yards               |
      | pointsPerMissedFG      | Double  | -1.0    | Points per missed FG       |

  # ========================================
  # SECTION 3: SCORE CALCULATION
  # ========================================

  @calculation @player @priority-critical
  Scenario: Calculate individual player score
    Given player "Patrick Mahomes" has week 18 stats:
      | stat              | value |
      | passingYards      | 325   |
      | passingTDs        | 3     |
      | interceptions     | 1     |
      | rushingYards      | 22    |
    And the league uses standard scoring
    When I calculate the player score
    Then the score should be calculated as:
      | component         | calculation           | points |
      | Passing Yards     | 325 * 0.04            | 13.00  |
      | Passing TDs       | 3 * 4.0               | 12.00  |
      | Interceptions     | 1 * -2.0              | -2.00  |
      | Rushing Yards     | 22 * 0.1              | 2.20   |
      | 300 Yard Bonus    | 1 * 3.0               | 3.00   |
      | Total             |                       | 28.20  |

  @calculation @roster @priority-critical
  Scenario: Calculate roster total score
    Given a roster has players:
      | position | player           | score  |
      | QB       | Patrick Mahomes  | 28.20  |
      | RB       | Travis Etienne   | 18.50  |
      | RB       | Raheem Mostert   | 12.30  |
      | WR       | Tyreek Hill      | 22.40  |
      | WR       | Davante Adams    | 15.80  |
      | TE       | Travis Kelce     | 16.90  |
      | FLEX     | Deebo Samuel     | 14.20  |
      | K        | Harrison Butker  | 11.00  |
      | DEF      | Chiefs           | 8.00   |
    When I calculate the roster score
    Then the total roster score should be 147.30
    And each player's contribution should be tracked

  @calculation @realtime @priority-high
  Scenario: Calculate scores during live games
    Given NFL games are in progress
    And player stats are being updated in real-time
    When score calculation is triggered
    Then scores should be calculated from current stats
    And scores should update as stats change
    And partial game scores should be marked as "in_progress"
    And final scores should be marked as "final"

  @calculation @batch @priority-high
  Scenario: Calculate all league scores for a week
    Given league "Super Bowl League" has 12 active rosters
    And week 18 games are complete
    When I calculate league scores for week 18
    Then all 12 roster scores should be calculated
    And scores should be stored in MongoDB
    And calculation should complete within 5 seconds
    And each score should have correct breakdown

  @calculation @error @priority-medium
  Scenario: Handle missing player stats gracefully
    Given a roster contains player "John Doe"
    And player "John Doe" has no stats for week 18
    When I calculate the roster score
    Then the player should receive 0 points
    And the calculation should not fail
    And a warning should be logged
    And the missing stats should be noted in the breakdown

  # ========================================
  # SECTION 4: RANKING SYSTEM
  # ========================================

  @ranking @weekly @priority-critical
  Scenario: Rank players within a league by weekly score
    Given league "Playoff Pool" has roster scores for week 18:
      | roster_owner    | score  |
      | Alice           | 147.30 |
      | Bob             | 142.50 |
      | Charlie         | 138.20 |
      | Diana           | 155.80 |
      | Eve             | 129.40 |
    When I rank players for week 18
    Then the rankings should be:
      | rank | roster_owner | score  |
      | 1    | Diana        | 155.80 |
      | 2    | Alice        | 147.30 |
      | 3    | Bob          | 142.50 |
      | 4    | Charlie      | 138.20 |
      | 5    | Eve          | 129.40 |

  @ranking @tiebreaker @priority-high
  Scenario: Handle tied scores with tiebreaker rules
    Given two players have identical scores of 142.50
    When I apply tiebreaker rules
    Then tiebreaker should be applied in order:
      | priority | tiebreaker                    |
      | 1        | Higher QB score               |
      | 2        | Higher total receiving yards  |
      | 3        | Higher total rushing yards    |
      | 4        | Earlier roster submission time|
    And the tie should be broken deterministically

  @ranking @cumulative @priority-high
  Scenario: Calculate cumulative rankings across weeks
    Given the playoffs span weeks 18-22
    And scores exist for weeks 18-19
    When I calculate cumulative rankings
    Then total scores should be summed across weeks
    And rankings should reflect cumulative performance
    And weekly rank history should be preserved

  @ranking @movement @priority-medium
  Scenario: Track ranking movement between weeks
    Given player rankings exist for weeks 18 and 19
    When I compare rankings between weeks
    Then rank movement should be calculated:
      | player  | week18_rank | week19_rank | movement |
      | Alice   | 3           | 1           | +2       |
      | Bob     | 1           | 2           | -1       |
      | Charlie | 2           | 4           | -2       |

  # ========================================
  # SECTION 5: ELIMINATION RULES
  # ========================================

  @elimination @rules @priority-critical
  Scenario: Configure elimination rules per week
    Given elimination is progressive through playoffs
    When I configure elimination rules
    Then the rules should specify:
      | week | eliminated_count | remaining_players |
      | 18   | 2                | 10                |
      | 19   | 2                | 8                 |
      | 20   | 2                | 6                 |
      | 21   | 2                | 4                 |
      | 22   | 3                | 1 (winner)        |

  @elimination @determination @priority-critical
  Scenario: Determine eliminated players after week
    Given week 18 scores have been finalized
    And the elimination count for week 18 is 2
    When I determine eliminated players
    Then the 2 lowest-scoring players should be marked eliminated
    And their status should change to "ELIMINATED"
    And they should not be able to submit rosters for future weeks
    And elimination notification should be triggered

  @elimination @protection @priority-high
  Scenario: Handle elimination protection (if configured)
    Given a league has "survival token" feature enabled
    And player "Eve" has 1 survival token remaining
    And "Eve" would be eliminated in week 18
    When elimination is processed
    Then "Eve" can use survival token to avoid elimination
    And the next lowest scorer is eliminated instead
    And "Eve's" token count decreases to 0

  @elimination @validation @priority-high
  Scenario: Prevent eliminated players from participating
    Given player "Frank" was eliminated in week 18
    When "Frank" attempts to submit a roster for week 19
    Then the submission should be rejected
    And error "PLAYER_ELIMINATED" should be returned
    And the roster should not be saved

  @elimination @history @priority-medium
  Scenario: Track elimination history
    Given eliminations have occurred across multiple weeks
    When I query elimination history for a league
    Then the history should show:
      | week | eliminated_players  | reason           |
      | 18   | Frank, Grace        | Lowest scores    |
      | 19   | Henry, Ivy          | Lowest scores    |
    And each elimination should have timestamp and final score

  # ========================================
  # SECTION 6: AUDIT TRAIL
  # ========================================

  @audit @score @priority-critical
  Scenario: Store score calculation audit trail
    Given a score is calculated for roster "roster-123"
    When the calculation completes
    Then an audit document should be created with:
      | field               | value                              |
      | auditId             | unique identifier                  |
      | rosterId            | roster-123                         |
      | week                | 18                                 |
      | season              | 2024                               |
      | calculatedScore     | 147.30                             |
      | calculationTime     | ISO 8601 timestamp                 |
      | scoringFormulaId    | formula used                       |
      | playerBreakdowns    | array of player score details     |
      | statsSnapshot       | copy of stats used                 |
      | version             | audit schema version               |

  @audit @breakdown @priority-high
  Scenario: Store detailed player score breakdowns
    Given a player score is calculated
    When I store the breakdown
    Then each player breakdown should contain:
      | field               | description                        |
      | playerId            | NFL player ID                      |
      | playerName          | Player's name                      |
      | position            | Player's position                  |
      | statsUsed           | Stats at calculation time          |
      | pointsByCategory    | Points per stat category           |
      | bonusesApplied      | Any bonuses triggered              |
      | totalPoints         | Player's total points              |

  @audit @recalculation @priority-high
  Scenario: Audit score recalculations
    Given scores were recalculated due to stat correction
    When the recalculation completes
    Then a new audit record should be created
    And the record should reference the original calculation
    And the delta between old and new scores should be stored
    And the reason for recalculation should be documented

  @audit @query @priority-medium
  Scenario: Query audit history for a roster
    Given multiple score calculations exist for roster "roster-123"
    When I query the audit history
    Then all calculation records should be returned
    And records should be sorted by timestamp descending
    And I can compare scores across calculations

  @audit @immutability @priority-high
  Scenario: Ensure audit records are immutable
    Given an audit record exists for a calculation
    When I attempt to modify the audit record
    Then the modification should be rejected
    And the original record should remain unchanged
    And audit records should be append-only

  @audit @retention @priority-medium
  Scenario: Configure audit retention policy
    Given audit records accumulate over time
    When I configure retention policy
    Then audit records should be retained for at least 1 year
    And older records can be archived to cold storage
    And summary data should be preserved indefinitely

  # ========================================
  # SECTION 7: PERFORMANCE & RELIABILITY
  # ========================================

  @performance @calculation @priority-high
  Scenario: Score calculation performance requirements
    Given a league has 100 rosters
    When I calculate all scores for a week
    Then calculation should complete within 10 seconds
    And each roster calculation should average < 100ms
    And MongoDB queries should be optimized with indexes

  @performance @index @priority-high
  Scenario: Create MongoDB indexes for scoring queries
    Given scoring queries need optimization
    When I create indexes
    Then the following indexes should exist:
      | collection          | index                              |
      | scores              | { rosterId: 1, week: 1, season: 1 }|
      | scores              | { leagueId: 1, week: 1 }           |
      | scoring_formulas    | { leagueId: 1, isActive: 1 }       |
      | score_audits        | { rosterId: 1, calculationTime: -1}|

  @reliability @retry @priority-medium
  Scenario: Retry failed score calculations
    Given a score calculation fails due to transient error
    When the retry mechanism activates
    Then the calculation should retry up to 3 times
    And exponential backoff should be applied
    And failed calculations should be logged
    And alerts should be triggered after max retries

  @reliability @consistency @priority-high
  Scenario: Ensure score consistency across calculations
    Given the same roster and stats
    When I calculate the score multiple times
    Then the score should be identical each time
    And the calculation should be deterministic
    And no floating point precision issues should occur
