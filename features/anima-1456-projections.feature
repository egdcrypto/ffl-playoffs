@backend @priority_1 @projections @analytics
Feature: Comprehensive Projections System
  As a fantasy football playoffs application
  I want to provide accurate player and team projections from multiple sources
  So that players can make informed roster decisions and analyze expected outcomes

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has projection settings configured
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)
    And projection data sources are available

  # ==================== WEEKLY PROJECTIONS ====================

  Scenario: Generate weekly player projections for upcoming round
    Given it is the week before Wild Card round
    And projection sources have published updated data
    When the system generates Wild Card projections
    Then projections are available for all NFL playoff players:
      | Player           | Position | Projected Points | Projection Source |
      | Patrick Mahomes  | QB       | 22.5             | Consensus         |
      | Josh Allen       | QB       | 24.0             | Consensus         |
      | Derrick Henry    | RB       | 16.5             | Consensus         |
      | Saquon Barkley   | RB       | 18.0             | Consensus         |
    And projections are timestamped with generation date
    And projections are available via API

  Scenario: Display weekly projections for roster selection
    Given player "john_doe" is making roster selections for Divisional round
    And weekly projections are available
    When john_doe views available players
    Then each player shows their projected points for the week
    And players are sortable by projected points
    And projection confidence level is displayed

  Scenario: Update weekly projections as game day approaches
    Given Wild Card round is 3 days away
    And initial projections were generated 5 days ago
    When new projection data becomes available
    Then projections are refreshed with updated values
    And projection change from previous values is shown
    And timestamp reflects the latest update

  Scenario: Handle projections for players on bye teams
    Given the Chiefs have a first-round bye
    And player "jane_doe" wants to view Chiefs players
    When jane_doe views Patrick Mahomes projection for Wild Card
    Then the projection shows 0 points for Wild Card
    And the status shows "BYE - Not playing this round"
    And Divisional round projections are available

  Scenario: Display projections for all roster positions
    Given player "bob_player" is viewing projections
    When bob_player filters by position
    Then projections are available for:
      | Position | Players Available | Top Projected |
      | QB       | 14                | Josh Allen    |
      | RB       | 28                | Saquon Barkley|
      | WR       | 42                | Ja'Marr Chase |
      | TE       | 14                | Travis Kelce  |
      | K        | 14                | Harrison Butker|
      | DEF      | 14                | SF 49ers      |

  Scenario: Calculate projected roster total
    Given player "alice_player" has selected a roster:
      | Position | Player           | Projected Points |
      | QB       | Patrick Mahomes  | 22.5             |
      | RB       | Derrick Henry    | 16.5             |
      | RB       | Josh Jacobs      | 12.0             |
      | WR       | Tyreek Hill      | 15.5             |
      | WR       | CeeDee Lamb      | 14.0             |
      | TE       | Travis Kelce     | 12.5             |
      | FLEX     | A.J. Brown       | 13.5             |
      | K        | Harrison Butker  | 8.5              |
      | DEF      | SF 49ers         | 7.0              |
    When the projected roster total is calculated
    Then the total projected points is 122.0
    And the projection is displayed on the roster page

  Scenario: Compare weekly projections to actual results
    Given Wild Card round has completed
    And projections were generated before the round
    When the system compares projections to actual scores
    Then accuracy metrics are calculated:
      | Player           | Projected | Actual | Difference | Accuracy % |
      | Patrick Mahomes  | 22.5      | 28.5   | +6.0       | 79.0%      |
      | Derrick Henry    | 16.5      | 22.0   | +5.5       | 75.0%      |
      | Tyreek Hill      | 15.5      | 12.0   | -3.5       | 77.4%      |
    And overall projection accuracy is calculated

  # ==================== SEASON-LONG PROJECTIONS ====================

  Scenario: Generate season-long playoff projections
    Given the playoffs are about to begin
    When the system generates season-long projections
    Then cumulative projections are available for all 4 rounds:
      | Player           | Wild Card | Divisional | Conference | Super Bowl | Total |
      | Patrick Mahomes  | 22.5      | 24.0       | 25.5       | 28.0       | 100.0 |
      | Josh Allen       | 24.0      | 22.0       | 23.5       | 26.0       | 95.5  |
    And projections account for potential elimination

  Scenario: Adjust season-long projections for team advancement probability
    Given the system tracks team win probabilities
    And the Chiefs have 85% chance to advance past Wild Card
    When season-long projections are calculated for Chiefs players
    Then Divisional round projection is weighted by advancement probability
    And the calculation shows: Divisional Proj = Base Proj * 0.85
    And cumulative projections reflect conditional probabilities

  Scenario: Update season-long projections after each round
    Given Wild Card round has completed
    And several teams have been eliminated
    When season-long projections are recalculated
    Then eliminated team players show 0 for remaining rounds
    And advancing team players show updated projections
    And overall playoff projections are refreshed

  Scenario: Display remaining season projection value
    Given it is Divisional round
    And player "john_doe" is viewing roster options
    When john_doe views player projections
    Then each player shows:
      | Metric                    | Value          |
      | This Week Projection      | 18.5           |
      | Remaining Playoff Value   | 52.0           |
      | Rounds Remaining          | 3              |
      | Team Advancement Odds     | 65%            |

  Scenario: Project total playoff points for fantasy players
    Given season-long projections are available
    When the system calculates fantasy player totals
    Then each fantasy player has a projected playoff total
    And rankings show projected final standings
    And the projection is updated after each round

  Scenario: Compare season-long projection sources
    Given multiple projection sources are available
    When the system aggregates season-long projections
    Then comparison shows:
      | Player           | ESPN   | Yahoo  | FantasyPros | Consensus |
      | Patrick Mahomes  | 98.5   | 102.0  | 100.5       | 100.3     |
      | Josh Allen       | 94.0   | 96.5   | 95.0        | 95.2      |
    And users can select their preferred source

  # ==================== PROJECTION SOURCES ====================

  Scenario: Aggregate projections from multiple sources
    Given the following projection sources are configured:
      | Source       | Weight | Status  |
      | ESPN         | 0.25   | Active  |
      | Yahoo        | 0.25   | Active  |
      | FantasyPros  | 0.30   | Active  |
      | NFL.com      | 0.20   | Active  |
    When consensus projections are calculated
    Then projections are weighted by source weight
    And the consensus projection is the weighted average
    And individual source projections are available for comparison

  Scenario: Configure projection source preferences
    Given the commissioner is configuring projection settings
    When the commissioner sets source preferences:
      | Source       | Enabled | Custom Weight |
      | ESPN         | true    | 0.30          |
      | Yahoo        | true    | 0.20          |
      | FantasyPros  | true    | 0.35          |
      | NFL.com      | false   | 0.00          |
      | Custom       | true    | 0.15          |
    Then the league uses customized projection weights
    And disabled sources are excluded from consensus

  Scenario: Display source-by-source projection comparison
    Given player "jane_doe" wants detailed projection data
    When jane_doe views projections for Patrick Mahomes
    Then the display shows:
      | Source       | Projection | Variance from Consensus |
      | ESPN         | 23.0       | +0.5                    |
      | Yahoo        | 21.5       | -1.0                    |
      | FantasyPros  | 22.5       | 0.0                     |
      | Consensus    | 22.5       | -                       |

  Scenario: Handle projection source unavailability
    Given ESPN projections are temporarily unavailable
    When the system generates consensus projections
    Then remaining sources are used with adjusted weights
    And a warning indicates "ESPN data unavailable"
    And the system continues with available sources

  Scenario: Track projection source accuracy over time
    Given multiple playoff rounds have completed
    When the system analyzes source accuracy
    Then accuracy metrics are calculated per source:
      | Source       | Avg Error | Accuracy % | Best At     |
      | ESPN         | 3.2 pts   | 78%        | QBs         |
      | Yahoo        | 3.8 pts   | 74%        | RBs         |
      | FantasyPros  | 2.9 pts   | 81%        | Overall     |
    And users can view historical accuracy trends

  Scenario: Import projections from external data feed
    Given a projection data feed is configured
    When new projection data is received
    Then player projections are updated
    And the import timestamp is recorded
    And validation ensures data integrity

  Scenario: Validate projection data quality
    Given new projection data is imported
    When the system validates the data
    Then validation checks include:
      | Check                          | Status |
      | All playoff players included   | Pass   |
      | No negative projections        | Pass   |
      | Reasonable value range         | Pass   |
      | Position data matches          | Pass   |
    And invalid data is flagged for review

  # ==================== CUSTOM PROJECTIONS ====================

  Scenario: Allow users to create custom projections
    Given player "bob_player" wants to override consensus projections
    When bob_player creates custom projections:
      | Player           | Custom Projection | Reason                    |
      | Patrick Mahomes  | 28.0              | Expected shootout game    |
      | Travis Kelce     | 18.0              | Revenge game motivation   |
    Then custom projections are saved for bob_player
    And custom projections appear alongside consensus

  Scenario: Use custom projections for roster analysis
    Given player "alice_player" has custom projections saved
    When alice_player views projected roster totals
    Then the option to use custom projections is available
    And toggling shows both consensus and custom totals
    And the difference is highlighted

  Scenario: Share custom projections within league
    Given player "john_doe" has created valuable custom projections
    When john_doe shares their projections with the league
    Then other players can view john_doe's custom projections
    And attribution shows "Custom by john_doe"
    And league members can copy projections to their own

  Scenario: Import custom projections from spreadsheet
    Given player "jane_doe" has projection data in a CSV file
    When jane_doe uploads the CSV with format:
      | Column      | Required |
      | player_name | Yes      |
      | position    | Yes      |
      | projection  | Yes      |
      | notes       | No       |
    Then custom projections are imported
    And validation errors are reported
    And successfully imported projections are saved

  Scenario: Adjust custom projection with percentage modifier
    Given player "bob_player" wants quick adjustments
    When bob_player applies a +10% modifier to Chiefs players
    Then all Chiefs player projections increase by 10%
    And the adjustment is logged as "bulk modifier"
    And original values are preserved for reference

  Scenario: Reset custom projections to consensus
    Given player "alice_player" has multiple custom projections
    When alice_player resets projections to consensus
    Then all custom projections are removed
    And consensus projections are displayed
    And a confirmation is required before reset

  Scenario: Create projection templates for scenarios
    Given player "john_doe" wants to save projection scenarios
    When john_doe creates templates:
      | Template Name     | Description                      |
      | High Scoring      | Optimistic projections +15%      |
      | Conservative      | Pessimistic projections -10%     |
      | Weather Adjusted  | Account for outdoor conditions   |
    Then templates are saved for quick application
    And templates can be shared with league

  # ==================== PROJECTION CATEGORIES ====================

  Scenario: Display projections by stat category
    Given detailed projection breakdowns are available
    When a user views projection categories for Patrick Mahomes
    Then the breakdown shows:
      | Category          | Projected Value | Projected Points |
      | Passing Yards     | 285             | 11.4             |
      | Passing TDs       | 2.5             | 10.0             |
      | Interceptions     | 0.5             | -1.0             |
      | Rushing Yards     | 22              | 2.2              |
      | Rushing TDs       | 0.2             | 1.2              |
      | TOTAL             | -               | 23.8             |

  Scenario: Project receiving categories for skill players
    Given projections include receiving breakdowns
    When a user views projections for Tyreek Hill
    Then the breakdown shows:
      | Category          | Projected Value | Projected Points |
      | Receptions        | 7               | 7.0 (PPR)        |
      | Receiving Yards   | 95              | 9.5              |
      | Receiving TDs     | 0.8             | 4.8              |
      | Targets           | 10              | (info only)      |
      | TOTAL             | -               | 21.3             |

  Scenario: Project rushing categories for running backs
    Given projections include rushing breakdowns
    When a user views projections for Derrick Henry
    Then the breakdown shows:
      | Category          | Projected Value | Projected Points |
      | Rushing Attempts  | 22              | (info only)      |
      | Rushing Yards     | 105             | 10.5             |
      | Rushing TDs       | 1.0             | 6.0              |
      | Receptions        | 2               | 2.0 (PPR)        |
      | Receiving Yards   | 15              | 1.5              |
      | TOTAL             | -               | 20.0             |

  Scenario: Project kicker categories
    Given projections include kicker breakdowns
    When a user views projections for Harrison Butker
    Then the breakdown shows:
      | Category          | Projected Value | Projected Points |
      | Field Goals Made  | 2.0             | 7.0              |
      | FG 40-49 yards    | 0.8             | (included above) |
      | FG 50+ yards      | 0.3             | (included above) |
      | Extra Points Made | 3.5             | 3.5              |
      | TOTAL             | -               | 10.5             |

  Scenario: Project defense/special teams categories
    Given projections include defensive breakdowns
    When a user views projections for SF 49ers defense
    Then the breakdown shows:
      | Category          | Projected Value | Projected Points |
      | Sacks             | 3.0             | 3.0              |
      | Interceptions     | 1.2             | 2.4              |
      | Fumble Recoveries | 0.5             | 1.0              |
      | Defensive TDs     | 0.1             | 0.6              |
      | Points Allowed    | 18              | 1.0              |
      | TOTAL             | -               | 8.0              |

  Scenario: Compare category projections to league averages
    Given category projections are available
    When comparing a player to position average
    Then the comparison shows:
      | Category       | Player Proj | Position Avg | Difference |
      | Passing Yards  | 285         | 245          | +40        |
      | Passing TDs    | 2.5         | 1.8          | +0.7       |
      | Rush Yards     | 22          | 18           | +4         |
    And above-average categories are highlighted

  # ==================== PROJECTION CONFIDENCE ====================

  Scenario: Display projection confidence levels
    Given projections include confidence metrics
    When a user views player projections
    Then confidence levels are displayed:
      | Player           | Projection | Confidence | Range (Low-High) |
      | Patrick Mahomes  | 22.5       | High       | 18.0 - 27.0      |
      | Isiah Pacheco    | 12.0       | Medium     | 6.0 - 18.0       |
      | Rookie WR        | 8.5        | Low        | 2.0 - 15.0       |

  Scenario: Calculate confidence based on historical consistency
    Given player performance history is available
    When confidence is calculated for Derrick Henry
    Then confidence factors include:
      | Factor                    | Score | Weight |
      | Week-to-week consistency  | 85%   | 0.30   |
      | Projection source agreement | 90% | 0.25   |
      | Matchup predictability    | 75%   | 0.25   |
      | Injury/uncertainty factors| 95%   | 0.20   |
    And overall confidence is "High" (87%)

  Scenario: Display projection floor and ceiling
    Given projections include range estimates
    When a user views Patrick Mahomes projection
    Then the range shows:
      | Metric     | Value |
      | Floor      | 15.0  |
      | Projection | 22.5  |
      | Ceiling    | 32.0  |
    And a visual chart displays the distribution

  Scenario: Low confidence warning for volatile players
    Given a player has high projection variance
    When the projection is displayed
    Then a warning icon indicates "High variance player"
    And the tooltip explains the uncertainty factors
    And alternative player suggestions are shown

  Scenario: Factor weather into confidence levels
    Given a game is scheduled for outdoor stadium
    And weather forecast shows high winds and rain
    When projections are adjusted for weather
    Then passing-heavy players show reduced confidence
    And a weather impact indicator is displayed
    And projection range widens for affected players

  Scenario: Track prediction confidence accuracy
    Given the season has multiple completed rounds
    When the system analyzes confidence predictions
    Then accuracy is measured:
      | Confidence Level | Predictions | Within Range | Accuracy |
      | High             | 50          | 45           | 90%      |
      | Medium           | 75          | 56           | 75%      |
      | Low              | 25          | 15           | 60%      |

  Scenario: Use confidence in roster recommendations
    Given player "jane_doe" wants roster advice
    When the system generates recommendations
    Then high-confidence projections are preferred
    And volatile players are flagged for review
    And risk tolerance settings affect recommendations

  # ==================== MATCHUP-BASED PROJECTIONS ====================

  Scenario: Adjust projections based on opponent defense
    Given the Chiefs play the Dolphins
    And Dolphins rank 28th against the pass
    When matchup-adjusted projections are calculated
    Then Patrick Mahomes projection increases:
      | Base Projection | Matchup Adjustment | Adjusted Projection |
      | 22.5            | +3.0               | 25.5                |
    And the adjustment reason is displayed

  Scenario: Display defensive matchup ratings
    Given matchup analysis is available
    When a user views WR projections against Cowboys
    Then the display shows:
      | Defensive Metric               | Cowboys Rank | Impact        |
      | Points allowed to WRs          | 5th (tough)  | -2.5 pts avg  |
      | Yards allowed to WRs           | 8th          | -15 yds avg   |
      | TDs allowed to WRs             | 3rd          | -0.3 TDs avg  |
    And WR projections reflect the tough matchup

  Scenario: Compare player projection across different matchups
    Given a player could face different opponents in future rounds
    When viewing matchup-based projections
    Then the comparison shows:
      | Round       | Opponent | Defensive Rank | Projection |
      | Wild Card   | Dolphins | 28th vs Pass   | 25.5       |
      | Divisional  | Bills    | 10th vs Pass   | 21.0       |
      | Conference  | Ravens   | 5th vs Pass    | 18.5       |

  Scenario: Factor home/away into matchup projections
    Given road teams historically score fewer points
    When projections are calculated for away team players
    Then a road adjustment is applied:
      | Venue       | Adjustment |
      | Home        | +0.5 pts   |
      | Away        | -0.5 pts   |
      | Neutral     | 0.0 pts    |
    And dome vs outdoor factors are included

  Scenario: Adjust for division rivalry matchups
    Given Bills vs Dolphins is a division rivalry
    When projections account for rivalry factors
    Then defensive intensity adjustment is applied
    And historical rivalry scoring trends are factored
    And the matchup is flagged as "rivalry game"

  Scenario: Project game script impact on players
    Given the Chiefs are heavy favorites (-10.5)
    When game script projections are calculated
    Then:
      | Impact                          | Projection Change |
      | Expected positive game script   | +RB attempts      |
      | Reduced passing in 4th quarter  | -QB ceiling       |
      | Increased garbage time (opp)    | +opponent WR      |
    And game script factors are shown in projection details

  Scenario: Display strength of schedule for playoffs
    Given playoff matchups are known or projected
    When a user views strength of schedule
    Then the analysis shows:
      | Team     | Wild Card | Divisional | Conference | Overall SOS |
      | Chiefs   | Easy      | Medium     | Hard       | Medium      |
      | Bills    | Medium    | Hard       | Medium     | Hard        |
    And SOS affects season-long player projections

  # ==================== INJURY-ADJUSTED PROJECTIONS ====================

  Scenario: Reduce projection for questionable player
    Given Travis Kelce is listed as "Questionable" with knee injury
    When projections are adjusted for injury status
    Then Kelce's projection is reduced:
      | Status      | Probability | Adjusted Projection |
      | Healthy     | 65%         | 14.5 (full)        |
      | Limited     | 25%         | 9.0 (reduced)      |
      | Out         | 10%         | 0.0                |
      | Expected    | -           | 12.5               |

  Scenario: Zero projection for player ruled out
    Given Davante Adams is listed as "Out" with hamstring injury
    When projections are calculated
    Then Adams projection is 0 points
    And the status shows "OUT - Will not play"
    And backup player projections are increased

  Scenario: Boost backup player projection when starter is out
    Given Derrick Henry is ruled out
    And Gus Edwards is the backup RB
    When projections are adjusted
    Then Edwards projection increases:
      | Base Projection | Workload Boost | Adjusted Projection |
      | 6.0             | +8.5           | 14.5                |
    And the adjustment is labeled "starter out boost"

  Scenario: Display injury report integration
    Given injury reports are updated daily
    When a user views player projections
    Then injury status is prominently displayed:
      | Player          | Status       | Injury      | Practice Status |
      | Travis Kelce    | Questionable | Knee        | Limited         |
      | Tyreek Hill     | Probable     | Ankle       | Full            |
      | Davante Adams   | Out          | Hamstring   | DNP             |

  Scenario: Track injury status changes
    Given player "john_doe" is monitoring injured players
    When an injury status changes from Questionable to Out
    Then john_doe receives a notification
    And projections are immediately updated
    And roster recommendations are refreshed

  Scenario: Factor injury history into projections
    Given a player has recurring injury concerns
    When projections account for durability
    Then confidence level is reduced
    And projection range is widened
    And injury risk indicator is displayed

  Scenario: Adjust projections for offensive line injuries
    Given the Chiefs starting left tackle is out
    When projections account for O-line impact
    Then QB projection may decrease slightly
    And RB projection may decrease for inside runs
    And the adjustment is labeled "O-line impact"

  Scenario: Handle game-time decision uncertainty
    Given Patrick Mahomes is a game-time decision
    When projections are displayed before game day
    Then two scenarios are shown:
      | Scenario     | Projection | Probability |
      | Mahomes plays| 24.5       | 70%         |
      | Backup starts| 12.0       | 30%         |
    And expected value projection is 20.8

  # ==================== PROJECTION HISTORY ====================

  Scenario: Track projection changes over time
    Given projections are updated daily before game day
    When a user views projection history for Patrick Mahomes
    Then the history shows:
      | Date       | Projection | Change | Reason              |
      | Mon Jan 6  | 22.0       | -      | Initial projection  |
      | Wed Jan 8  | 23.5       | +1.5   | Improved matchup    |
      | Fri Jan 10 | 22.5       | -1.0   | Weather concerns    |
      | Sat Jan 11 | 24.0       | +1.5   | OL starter returns  |

  Scenario: View historical projection accuracy for a player
    Given a player has been projected in previous games
    When viewing their projection history
    Then accuracy is shown:
      | Game          | Projected | Actual | Accuracy |
      | Week 18       | 22.5      | 28.0   | 80.4%    |
      | Wild Card     | 24.0      | 22.5   | 93.8%    |
      | Divisional    | 23.0      | 25.5   | 90.2%    |
    And average accuracy is calculated

  Scenario: Compare projection evolution to other players
    Given multiple players are being monitored
    When viewing projection trends
    Then charts show:
      | Trend Analysis                              |
      | Projection movement over past 7 days        |
      | Comparison to position average movement     |
      | Volatility indicator                        |

  Scenario: Archive projections for post-season analysis
    Given the playoffs have concluded
    When projection archives are generated
    Then all projections are stored with:
      | Data Point            | Included |
      | Initial projection    | Yes      |
      | Final projection      | Yes      |
      | Actual result         | Yes      |
      | Source breakdown      | Yes      |
      | Adjustment history    | Yes      |

  Scenario: Analyze projection trends by source
    Given multiple rounds have completed
    When source accuracy is analyzed
    Then trends show:
      | Source       | Early Week Accuracy | Game Day Accuracy | Trend    |
      | ESPN         | 72%                 | 78%               | Improves |
      | FantasyPros  | 80%                 | 82%               | Stable   |
      | Custom       | 65%                 | 70%               | Improves |

  Scenario: Review projection decisions for past matchups
    Given player "jane_doe" wants to analyze past decisions
    When jane_doe views their projection history
    Then the analysis shows:
      | Round      | Started Player | Proj | Actual | Bench Player | Proj | Actual |
      | Wild Card  | Hill           | 18.5 | 12.0   | Brown        | 15.0 | 22.0   |
      | Divisional | Kelce          | 14.0 | 16.5   | Goedert      | 10.0 | 8.5    |
    And decision quality metrics are calculated

  # ==================== PROJECTION EXPORTS ====================

  Scenario: Export projections to CSV format
    Given projections are available for Wild Card round
    When a user exports projections to CSV
    Then the file includes:
      | Column             | Example Value    |
      | player_name        | Patrick Mahomes  |
      | position           | QB               |
      | team               | KC               |
      | opponent           | MIA              |
      | projection         | 22.5             |
      | floor              | 15.0             |
      | ceiling            | 32.0             |
      | confidence         | High             |
    And the file downloads successfully

  Scenario: Export projections to JSON format
    Given projections need to be consumed by external tools
    When a user exports projections to JSON
    Then the JSON structure includes:
      | Field              | Type             |
      | players            | Array            |
      | generated_at       | ISO timestamp    |
      | source             | String           |
      | league_settings    | Object           |
    And the API endpoint returns valid JSON

  Scenario: Export projection comparison report
    Given multiple projection sources are configured
    When a user exports a comparison report
    Then the report includes:
      | Section                      |
      | Consensus projections        |
      | Source-by-source breakdown   |
      | Variance analysis            |
      | Historical accuracy          |
    And the report is available in PDF format

  Scenario: Schedule automatic projection exports
    Given player "bob_player" wants regular projection updates
    When bob_player configures scheduled exports:
      | Setting        | Value              |
      | Frequency      | Daily              |
      | Format         | CSV                |
      | Delivery       | Email              |
      | Time           | 6:00 AM            |
    Then exports are sent automatically
    And the schedule can be modified or cancelled

  Scenario: Export projections with custom filters
    Given a user wants specific projection data
    When the user exports with filters:
      | Filter         | Value              |
      | Positions      | QB, RB, WR         |
      | Teams          | KC, BUF, SF        |
      | Min Projection | 10.0               |
    Then only matching players are included
    And filter settings are shown in export header

  Scenario: Share projection export link
    Given a user has generated a projection export
    When the user creates a shareable link
    Then the link provides read-only access
    And the link expires after 7 days
    And access can be revoked

  Scenario: Export projection history to spreadsheet
    Given projection history spans multiple updates
    When a user exports history to Excel
    Then the spreadsheet includes:
      | Sheet                | Contents                    |
      | Current Projections  | Latest projections          |
      | History              | Daily projection changes    |
      | Accuracy             | Projection vs actual        |
      | Charts               | Visual trend analysis       |

  Scenario: API access for projection data
    Given a developer needs projection data
    When accessing the projections API
    Then endpoints are available:
      | Endpoint                      | Method | Description              |
      | /api/projections/weekly       | GET    | Current week projections |
      | /api/projections/season       | GET    | Season-long projections  |
      | /api/projections/player/{id}  | GET    | Individual player data   |
      | /api/projections/history      | GET    | Historical projections   |
    And authentication is required
    And rate limiting is enforced

  Scenario: Export projections for offline use
    Given a user needs projections without internet
    When the user downloads offline projection pack
    Then the download includes:
      | Content                       |
      | All player projections        |
      | Position rankings             |
      | Matchup analysis              |
      | Injury impact data            |
    And the pack is viewable offline
    And last sync date is displayed
