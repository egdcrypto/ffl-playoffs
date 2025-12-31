@backend @priority_1 @rankings @analytics
Feature: Comprehensive Rankings System
  As a fantasy football playoffs application
  I want to provide detailed player rankings from multiple sources and perspectives
  So that players can make informed roster decisions based on expert analysis

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And ranking data sources are configured
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ==================== EXPERT RANKINGS ====================

  Scenario: Display expert consensus rankings
    Given multiple expert ranking sources are available
    When a user views expert consensus rankings
    Then rankings are displayed with aggregate scores:
      | Rank | Player           | Position | Team | Consensus Score | Expert Agreement |
      | 1    | Patrick Mahomes  | QB       | KC   | 98.5            | 95%              |
      | 2    | Josh Allen       | QB       | BUF  | 97.2            | 92%              |
      | 3    | Lamar Jackson    | QB       | BAL  | 95.8            | 88%              |
      | 4    | Jalen Hurts      | QB       | PHI  | 94.0            | 85%              |
    And rankings are sortable and filterable

  Scenario: View individual expert rankings
    Given expert "Matthew Berry" has published rankings
    When a user views Matthew Berry's rankings
    Then the display shows:
      | Rank | Player           | Expert Notes                        |
      | 1    | Patrick Mahomes  | Elite playoff performer             |
      | 2    | Josh Allen       | Rushing upside in cold weather      |
      | 3    | Saquon Barkley   | Workhorse in playoff scheme         |
    And the expert's credentials and accuracy history are shown

  Scenario: Compare rankings across multiple experts
    Given rankings from 5 different experts are available
    When a user compares expert rankings for quarterbacks
    Then the comparison shows:
      | Player           | Berry | Silva | Karabell | Yates | Clay | Avg Rank |
      | Patrick Mahomes  | 1     | 1     | 2        | 1     | 1    | 1.2      |
      | Josh Allen       | 2     | 3     | 1        | 2     | 2    | 2.0      |
      | Lamar Jackson    | 3     | 2     | 3        | 4     | 3    | 3.0      |
    And variance between experts is highlighted

  Scenario: Display expert ranking confidence
    Given experts provide confidence levels with rankings
    When a user views rankings with confidence
    Then the display shows:
      | Player           | Rank | Confidence | Reasoning                     |
      | Patrick Mahomes  | 1    | Very High  | Consistent elite performance  |
      | Isiah Pacheco    | 15   | Medium     | Role dependent on game script |
      | Rookie WR        | 28   | Low        | Limited playoff experience    |

  Scenario: Track expert ranking accuracy over time
    Given multiple playoff rounds have completed
    When the system analyzes expert accuracy
    Then accuracy metrics are displayed:
      | Expert          | Prediction Accuracy | Top 10 Accuracy | Bust Rate |
      | Matthew Berry   | 78%                 | 82%             | 15%       |
      | Adam Schefter   | 75%                 | 79%             | 18%       |
      | Field Yates     | 80%                 | 85%             | 12%       |
    And users can filter experts by accuracy

  Scenario: Subscribe to expert ranking updates
    Given player "john_doe" follows specific experts
    When an expert updates their rankings
    Then john_doe receives a notification
    And the notification shows key ranking changes
    And john_doe can view the full updated rankings

  Scenario: Display expert hot takes and contrarian picks
    Given experts have rankings that deviate from consensus
    When a user views contrarian expert picks
    Then the display highlights:
      | Expert        | Player         | Expert Rank | Consensus Rank | Difference |
      | Matthew Berry | Isiah Pacheco  | 8           | 18             | +10        |
      | Adam Schefter | Tyreek Hill    | 25          | 12             | -13        |
    And expert reasoning for contrarian picks is shown

  # ==================== POSITION RANKINGS ====================

  Scenario: Display quarterback rankings
    Given QB rankings are available for playoffs
    When a user views QB rankings
    Then rankings show:
      | Rank | Player           | Team | Matchup      | Proj Points | Tier |
      | 1    | Patrick Mahomes  | KC   | vs MIA       | 24.5        | 1    |
      | 2    | Josh Allen       | BUF  | vs PIT       | 23.0        | 1    |
      | 3    | Lamar Jackson    | BAL  | vs HOU       | 22.5        | 1    |
      | 4    | Jalen Hurts      | PHI  | vs TB        | 20.0        | 2    |
    And tier breaks indicate significant dropoffs

  Scenario: Display running back rankings
    Given RB rankings are available for playoffs
    When a user views RB rankings
    Then rankings show:
      | Rank | Player           | Team | Matchup      | Proj Points | Workload |
      | 1    | Saquon Barkley   | PHI  | vs TB        | 18.5        | Bellcow  |
      | 2    | Derrick Henry    | BAL  | vs HOU       | 17.0        | Bellcow  |
      | 3    | Josh Jacobs      | GB   | vs DAL       | 15.5        | Primary  |
    And workload indicators show expected usage

  Scenario: Display wide receiver rankings
    Given WR rankings are available for playoffs
    When a user views WR rankings
    Then rankings show:
      | Rank | Player           | Team | Matchup      | Target Share | Proj Points |
      | 1    | Ja'Marr Chase    | CIN  | vs BAL       | 28%          | 19.5        |
      | 2    | Tyreek Hill      | MIA  | @ KC         | 26%          | 17.0        |
      | 3    | CeeDee Lamb      | DAL  | @ GB         | 27%          | 16.5        |
    And target share trends are displayed

  Scenario: Display tight end rankings
    Given TE rankings are available for playoffs
    When a user views TE rankings
    Then rankings show:
      | Rank | Player           | Team | Matchup      | Red Zone Targets | Proj Points |
      | 1    | Travis Kelce     | KC   | vs MIA       | 4.2              | 14.5        |
      | 2    | Mark Andrews     | BAL  | vs HOU       | 3.8              | 12.0        |
      | 3    | T.J. Hockenson   | MIN  | vs LAR       | 3.5              | 11.0        |
    And TE premium value is indicated

  Scenario: Display kicker rankings
    Given kicker rankings are available for playoffs
    When a user views kicker rankings
    Then rankings show:
      | Rank | Player           | Team | Matchup      | FG Opportunities | Proj Points |
      | 1    | Harrison Butker  | KC   | vs MIA       | 2.5              | 10.5        |
      | 2    | Justin Tucker    | BAL  | vs HOU       | 2.3              | 9.5         |
      | 3    | Jake Elliott     | PHI  | vs TB        | 2.2              | 9.0         |
    And team scoring environment is factored in

  Scenario: Display defense/special teams rankings
    Given DST rankings are available for playoffs
    When a user views DST rankings
    Then rankings show:
      | Rank | Team             | Matchup      | Sack Proj | Turnover Proj | Proj Points |
      | 1    | SF 49ers         | vs GB        | 3.5       | 2.0           | 10.0        |
      | 2    | Dallas Cowboys   | @ GB         | 3.0       | 1.8           | 8.5         |
      | 3    | Baltimore Ravens | vs HOU       | 2.8       | 1.5           | 8.0         |
    And opponent offensive weaknesses are shown

  Scenario: Display flex position rankings
    Given flex rankings combine RB, WR, and TE
    When a user views flex rankings
    Then rankings show combined position rankings:
      | Rank | Player           | Position | Team | Proj Points |
      | 1    | Saquon Barkley   | RB       | PHI  | 18.5        |
      | 2    | Ja'Marr Chase    | WR       | CIN  | 19.5        |
      | 3    | Derrick Henry    | RB       | BAL  | 17.0        |
      | 4    | Tyreek Hill      | WR       | MIA  | 17.0        |
    And position scarcity is indicated

  # ==================== OVERALL RANKINGS ====================

  Scenario: Display overall player rankings across all positions
    Given overall rankings are calculated
    When a user views overall rankings
    Then rankings show value across positions:
      | Rank | Player           | Position | Team | Value Score | Position Rank |
      | 1    | Patrick Mahomes  | QB       | KC   | 100.0       | QB1           |
      | 2    | Josh Allen       | QB       | BUF  | 98.5        | QB2           |
      | 3    | Saquon Barkley   | RB       | PHI  | 95.0        | RB1           |
      | 4    | Ja'Marr Chase    | WR       | CIN  | 94.2        | WR1           |
    And value over replacement is calculated

  Scenario: Calculate value over replacement player (VORP)
    Given position baselines are established
    When VORP is calculated for each player
    Then the display shows:
      | Player           | Position | Proj Points | Baseline | VORP  |
      | Patrick Mahomes  | QB       | 24.5        | 18.0     | +6.5  |
      | Saquon Barkley   | RB       | 18.5        | 10.0     | +8.5  |
      | Ja'Marr Chase    | WR       | 19.5        | 12.0     | +7.5  |
    And VORP helps determine optimal roster construction

  Scenario: Display positional scarcity rankings
    Given position depth varies significantly
    When a user views scarcity-adjusted rankings
    Then rankings reflect positional value:
      | Position | Depth     | Top Tier Count | Scarcity Index |
      | QB       | Deep      | 6              | Low            |
      | RB       | Moderate  | 4              | Medium         |
      | WR       | Deep      | 8              | Low            |
      | TE       | Shallow   | 2              | High           |
    And TE rankings are boosted due to scarcity

  Scenario: Display risk-adjusted overall rankings
    Given injury and volatility data is available
    When risk-adjusted rankings are calculated
    Then the display shows:
      | Rank | Player           | Base Rank | Risk Factor | Risk-Adj Rank |
      | 1    | Saquon Barkley   | 3         | Low         | 1             |
      | 2    | Patrick Mahomes  | 1         | Low         | 2             |
      | 3    | Josh Allen       | 2         | Medium      | 3             |
      | 4    | Isiah Pacheco    | 8         | High        | 10            |

  Scenario: Filter overall rankings by playoff round
    Given different rounds favor different players
    When a user filters rankings for Super Bowl
    Then rankings adjust based on:
      | Factor                         | Impact           |
      | Team advancement probability   | Filters out eliminated |
      | Championship game experience   | Boosts veterans  |
      | Big game performance history   | Adjusts rankings |
    And only Super Bowl-eligible players are shown

  # ==================== DYNASTY RANKINGS ====================

  Scenario: Display dynasty value rankings
    Given dynasty rankings consider long-term value
    When a user views dynasty rankings
    Then rankings show:
      | Rank | Player           | Age | Contract Years | Dynasty Value | Trend   |
      | 1    | Ja'Marr Chase    | 24  | 4              | 98.5          | Rising  |
      | 2    | Justin Jefferson | 25  | 5              | 97.0          | Stable  |
      | 3    | Josh Allen       | 28  | 6              | 95.5          | Stable  |
    And age-adjusted projections are included

  Scenario: Compare redraft vs dynasty rankings
    Given both ranking types are available
    When a user compares rankings
    Then differences are highlighted:
      | Player           | Redraft Rank | Dynasty Rank | Difference | Reason        |
      | Travis Kelce     | 5            | 45           | -40        | Age concern   |
      | Brock Bowers     | 35           | 8            | +27        | Youth upside  |
      | Derrick Henry    | 8            | 55           | -47        | Age/workload  |

  Scenario: Display dynasty rookie rankings
    Given rookie class is evaluated for dynasty
    When a user views dynasty rookie rankings
    Then rankings show:
      | Rank | Player           | Position | Draft Capital | Situation | Dynasty Value |
      | 1    | Caleb Williams   | QB       | 1.01          | Excellent | 95.0          |
      | 2    | Marvin Harrison  | WR       | 1.04          | Good      | 92.5          |
      | 3    | Malik Nabers     | WR       | 1.06          | Excellent | 90.0          |

  Scenario: Track dynasty ranking movement
    Given dynasty rankings change over the season
    When a user views dynasty ranking trends
    Then movement is shown:
      | Player           | Start of Year | Current | Movement | Catalyst           |
      | Puka Nacua       | 45            | 12      | +33      | Breakout season    |
      | Jonathan Taylor  | 8             | 22      | -14      | Injury concerns    |
    And trend charts visualize changes

  Scenario: Display dynasty trade value chart
    Given dynasty values are quantified
    When a user views trade value chart
    Then values enable trade comparison:
      | Player           | Trade Value | Example Trade Equal           |
      | Ja'Marr Chase    | 10,000      | -                             |
      | Travis Kelce     | 4,500       | + 2024 1st + 2nd              |
      | Jaylen Waddle    | 7,000       | + 2024 2nd                    |

  # ==================== WEEKLY RANKINGS ====================

  Scenario: Display weekly rankings for current round
    Given it is Wild Card weekend
    When a user views Wild Card rankings
    Then rankings are tailored to Wild Card matchups:
      | Rank | Player           | Matchup      | Proj Points | Start/Sit  |
      | 1    | Patrick Mahomes  | vs MIA       | 24.5        | Must Start |
      | 2    | Josh Allen       | vs PIT       | 23.0        | Must Start |
      | 3    | Derrick Henry    | vs HOU       | 17.0        | Start      |
    And matchup-specific insights are included

  Scenario: Update weekly rankings throughout the week
    Given rankings evolve as game day approaches
    When rankings are updated on game day
    Then updates reflect:
      | Update Type          | Impact                         |
      | Injury updates       | Players ruled out drop to bottom |
      | Weather changes      | Outdoor game players adjusted  |
      | Line movement        | Game script adjustments        |
      | Inactive lists       | Final confirmations            |

  Scenario: Display start/sit recommendations
    Given weekly rankings include recommendations
    When a user views start/sit guidance
    Then the display shows:
      | Category    | Players                                      |
      | Must Starts | Mahomes, Allen, Barkley, Chase               |
      | Start       | Henry, Hill, Kelce, Lamb                     |
      | Flex Play   | Brown, Waddle, Pacheco                       |
      | Sit         | Questionable injury, bad matchup players     |
      | Must Sit    | Injured, bye week, limited role players      |

  Scenario: Display weekly sleeper rankings
    Given sleeper analysis identifies undervalued players
    When a user views sleeper rankings
    Then sleepers are highlighted:
      | Rank | Player           | Ownership % | Proj Points | Upside Case           |
      | 1    | Rashid Shaheed   | 25%         | 12.5        | Deep threat vs soft D |
      | 2    | Jaylen Warren    | 15%         | 10.0        | Increased touches     |
      | 3    | Jonnu Smith      | 8%          | 9.5         | Red zone target       |

  Scenario: Display weekly bust alert rankings
    Given bust risk analysis identifies overvalued players
    When a user views bust alerts
    Then potential busts are flagged:
      | Player           | Consensus Rank | Bust Risk | Risk Factors              |
      | Tyreek Hill      | 8              | High      | Tough CB matchup          |
      | Derrick Henry    | 6              | Medium    | Stacked boxes expected    |
      | Mark Andrews     | 12             | Medium    | Limited routes run        |

  Scenario: Compare weekly ranking to season average
    Given historical ranking data is available
    When a user views weekly vs season comparison
    Then variance is shown:
      | Player           | Season Avg Rank | This Week Rank | Difference | Reason         |
      | Tyreek Hill      | 5               | 12             | -7         | Bad matchup    |
      | Rashid Shaheed   | 45              | 28             | +17        | Great matchup  |

  # ==================== RANKING SOURCES ====================

  Scenario: Aggregate rankings from multiple sources
    Given the following ranking sources are configured:
      | Source       | Weight | Specialty        |
      | ESPN         | 0.25   | General          |
      | Yahoo        | 0.20   | General          |
      | FantasyPros  | 0.30   | Consensus        |
      | PFF          | 0.15   | Advanced metrics |
      | RotoWire     | 0.10   | News-based       |
    When consensus rankings are calculated
    Then rankings reflect weighted source input
    And source methodology is disclosed

  Scenario: Configure ranking source preferences
    Given the commissioner can customize sources
    When the commissioner adjusts source weights:
      | Source       | New Weight |
      | FantasyPros  | 0.40       |
      | PFF          | 0.25       |
      | ESPN         | 0.20       |
      | Yahoo        | 0.15       |
    Then consensus rankings recalculate
    And the league uses custom weighting

  Scenario: Display source-by-source ranking comparison
    Given multiple sources have ranked players
    When a user views source comparison
    Then the display shows:
      | Player           | ESPN | Yahoo | FantasyPros | PFF | Consensus |
      | Patrick Mahomes  | 1    | 1     | 1           | 2   | 1         |
      | Josh Allen       | 2    | 2     | 2           | 1   | 2         |
      | Lamar Jackson    | 3    | 4     | 3           | 3   | 3         |
    And disagreements are highlighted

  Scenario: Track source accuracy over time
    Given playoff results are recorded
    When source accuracy is analyzed
    Then metrics are shown:
      | Source       | Accuracy % | Best Position | Worst Position |
      | FantasyPros  | 82%        | QB            | TE             |
      | PFF          | 79%        | RB            | K              |
      | ESPN         | 76%        | WR            | DST            |

  Scenario: Import rankings from external source
    Given a new ranking source is available
    When rankings are imported
    Then validation ensures:
      | Check                    | Status |
      | All players mapped       | Pass   |
      | No duplicate ranks       | Pass   |
      | Complete position lists  | Pass   |
    And the source is added to aggregation

  Scenario: Display ranking source update frequency
    Given sources update at different times
    When a user views source freshness
    Then the display shows:
      | Source       | Last Updated        | Update Frequency |
      | FantasyPros  | 2 hours ago         | Hourly           |
      | ESPN         | 6 hours ago         | Every 6 hours    |
      | Yahoo        | 1 day ago           | Daily            |
    And stale sources are flagged

  # ==================== RANKING COMPARISON ====================

  Scenario: Compare two players side by side
    Given a user wants to compare players
    When comparing Patrick Mahomes and Josh Allen
    Then the comparison shows:
      | Metric               | Mahomes | Allen  | Advantage |
      | Consensus Rank       | 1       | 2      | Mahomes   |
      | Projected Points     | 24.5    | 23.0   | Mahomes   |
      | Ceiling              | 35.0    | 38.0   | Allen     |
      | Floor                | 15.0    | 12.0   | Mahomes   |
      | Matchup Rating       | A       | B+     | Mahomes   |
      | Expert Agreement     | 95%     | 88%    | Mahomes   |

  Scenario: Compare players across different positions
    Given position-adjusted comparison is needed
    When comparing Saquon Barkley (RB) to Ja'Marr Chase (WR)
    Then the comparison shows:
      | Metric               | Barkley | Chase  | Context              |
      | Position Rank        | RB1     | WR1    | Both position leaders|
      | VORP                 | +8.5    | +7.5   | Barkley              |
      | Position Scarcity    | Medium  | Low    | RB more scarce       |
      | Overall Value        | 95.0    | 94.2   | Nearly equal         |

  Scenario: Display ranking tier comparisons
    Given players are grouped into tiers
    When a user views tier comparison
    Then tiers are displayed:
      | Tier | Players                              | Tier Value | Gap to Next |
      | 1    | Mahomes, Allen                       | Elite      | 3.5 pts     |
      | 2    | Jackson, Hurts, Stroud               | Strong     | 2.0 pts     |
      | 3    | Love, Goff, Purdy                    | Solid      | 2.5 pts     |
    And tier breaks indicate significant dropoffs

  Scenario: Generate optimal lineup comparison
    Given a user has multiple roster options
    When comparing lineup options
    Then the comparison shows:
      | Lineup Option | Projected Total | Ceiling | Floor | Risk Level |
      | Lineup A      | 142.5           | 185.0   | 105.0 | Medium     |
      | Lineup B      | 138.0           | 195.0   | 95.0  | High       |
      | Lineup C      | 140.0           | 170.0   | 115.0 | Low        |

  Scenario: Compare matchup-specific rankings
    Given matchups affect player value
    When comparing rankings by matchup
    Then the display shows:
      | Player       | vs Team A | vs Team B | vs Team C | Best Matchup |
      | Tyreek Hill  | 15.5      | 18.0      | 22.5      | Team C       |
      | CeeDee Lamb  | 17.0      | 16.5      | 14.0      | Team A       |

  Scenario: Display ranking change comparison over time
    Given rankings change week to week
    When a user compares ranking changes
    Then trends are shown:
      | Player           | 4 Weeks Ago | 2 Weeks Ago | Current | Trend    |
      | Patrick Mahomes  | 1           | 1           | 1       | Stable   |
      | Isiah Pacheco    | 22          | 15          | 10      | Rising   |
      | Tyreek Hill      | 6           | 10          | 14      | Falling  |

  # ==================== CUSTOM RANKINGS ====================

  Scenario: Create custom player rankings
    Given player "john_doe" wants personal rankings
    When john_doe creates custom rankings:
      | Rank | Player           | Notes                    |
      | 1    | Josh Allen       | Rushing upside undervalued |
      | 2    | Patrick Mahomes  | Still elite              |
      | 3    | Lamar Jackson    | Best rushing QB          |
    Then custom rankings are saved
    And custom rankings appear alongside consensus

  Scenario: Adjust rankings with drag-and-drop
    Given player "jane_doe" is viewing rankings
    When jane_doe drags Travis Kelce from rank 5 to rank 3
    Then the custom ranking is updated
    And affected players shift accordingly
    And the change is logged with timestamp

  Scenario: Apply bulk ranking adjustments
    Given player "bob_player" wants quick adjustments
    When bob_player applies modifiers:
      | Modifier               | Value |
      | Chiefs players         | +3    |
      | Players vs MIA defense | +2    |
      | Questionable players   | -5    |
    Then affected player rankings shift
    And modifiers are saved for reuse

  Scenario: Import custom rankings from spreadsheet
    Given player "alice_player" has rankings in CSV
    When alice_player uploads the CSV
    Then custom rankings are imported:
      | Column Required | Description        |
      | player_name     | Player identifier  |
      | rank            | Custom rank number |
      | tier            | Optional tier      |
      | notes           | Optional notes     |
    And validation errors are reported

  Scenario: Share custom rankings with league
    Given player "john_doe" has valuable rankings
    When john_doe shares rankings with the league
    Then other players can view john_doe's rankings
    And rankings show "Created by john_doe"
    And league members can copy to their own

  Scenario: Create ranking templates for scenarios
    Given player "jane_doe" wants scenario-based rankings
    When jane_doe creates templates:
      | Template Name     | Description                   |
      | High Ceiling      | Prioritize upside players     |
      | Safe Floor        | Prioritize consistent players |
      | Contrarian        | Fade popular picks            |
    Then templates are saved for quick application

  Scenario: Reset custom rankings to consensus
    Given player "bob_player" has extensive custom rankings
    When bob_player resets to consensus
    Then all custom rankings are removed
    And consensus rankings are displayed
    And confirmation is required before reset

  # ==================== RANKING HISTORY ====================

  Scenario: Track ranking changes over time
    Given rankings are updated regularly
    When a user views ranking history for Patrick Mahomes
    Then the history shows:
      | Date       | Rank | Change | Reason              |
      | Jan 1      | 1    | -      | Season start        |
      | Jan 8      | 1    | 0      | Consistent          |
      | Jan 15     | 2    | -1     | Minor injury concern|
      | Jan 18     | 1    | +1     | Cleared to play     |

  Scenario: Display ranking volatility metrics
    Given historical ranking data is available
    When volatility is calculated
    Then metrics show:
      | Player           | Avg Rank | Std Dev | Volatility | Classification |
      | Patrick Mahomes  | 1.2      | 0.4     | 0.33       | Very Stable    |
      | Isiah Pacheco    | 14.5     | 4.2     | 0.29       | Moderate       |
      | Rookie WR        | 32.0     | 12.5    | 0.39       | High           |

  Scenario: View historical ranking accuracy
    Given past rankings can be compared to results
    When accuracy analysis is run
    Then the display shows:
      | Round      | Top 10 Accuracy | Top 25 Accuracy | Bust Rate |
      | Wild Card  | 78%             | 72%             | 18%       |
      | Divisional | 82%             | 75%             | 15%       |
    And accuracy trends are visualized

  Scenario: Compare pre-season to playoff rankings
    Given pre-season rankings are archived
    When comparing to current playoff rankings
    Then changes are shown:
      | Player           | Pre-Season | Current | Change | Reason          |
      | Puka Nacua       | 85         | 15      | +70    | Breakout year   |
      | Jonathan Taylor  | 5          | 25      | -20    | Injuries        |
      | Brock Purdy      | 45         | 12      | +33    | Emergence       |

  Scenario: Archive rankings for post-season analysis
    Given the playoffs have concluded
    When ranking archives are generated
    Then archives include:
      | Data Point          | Included |
      | Weekly rankings     | Yes      |
      | Actual results      | Yes      |
      | Accuracy metrics    | Yes      |
      | Source breakdown    | Yes      |

  Scenario: Generate ranking accuracy report
    Given complete season data is available
    When an accuracy report is generated
    Then the report includes:
      | Section                    | Contents                  |
      | Overall Accuracy           | Season-wide metrics       |
      | Position Accuracy          | By position breakdown     |
      | Source Comparison          | Which sources were best   |
      | Biggest Hits and Misses    | Notable predictions       |

  # ==================== RANKING EXPORTS ====================

  Scenario: Export rankings to CSV format
    Given rankings are available
    When a user exports rankings to CSV
    Then the file includes:
      | Column          | Example Value    |
      | rank            | 1                |
      | player_name     | Patrick Mahomes  |
      | position        | QB               |
      | team            | KC               |
      | projected_points| 24.5             |
      | tier            | 1                |
      | consensus_score | 98.5             |
    And the file downloads successfully

  Scenario: Export rankings to PDF format
    Given rankings need printable format
    When a user exports rankings to PDF
    Then the PDF includes:
      | Section                    |
      | Position-by-position lists |
      | Tier breakdowns            |
      | Matchup notes              |
      | Expert highlights          |
    And the PDF is formatted for easy reading

  Scenario: Export rankings to fantasy platform format
    Given integration with external platforms exists
    When a user exports for ESPN/Yahoo import
    Then the export matches platform format:
      | Platform | Format     | Compatible |
      | ESPN     | .csv       | Yes        |
      | Yahoo    | .csv       | Yes        |
      | Sleeper  | .json      | Yes        |
    And import instructions are provided

  Scenario: Schedule automatic ranking exports
    Given player "john_doe" wants regular exports
    When john_doe configures scheduled exports:
      | Setting        | Value              |
      | Frequency      | Weekly (Thursdays) |
      | Format         | CSV                |
      | Delivery       | Email              |
      | Positions      | All                |
    Then exports are sent automatically
    And the schedule can be modified

  Scenario: Export ranking comparison report
    Given multiple ranking sources are configured
    When a user exports a comparison report
    Then the report includes:
      | Section                    |
      | Consensus rankings         |
      | Source-by-source breakdown |
      | Variance analysis          |
      | Historical accuracy        |

  Scenario: Share ranking export link
    Given a user has generated a ranking export
    When the user creates a shareable link
    Then the link provides read-only access
    And the link expires after 7 days
    And access can be revoked

  Scenario: API access for ranking data
    Given a developer needs ranking data
    When accessing the rankings API
    Then endpoints are available:
      | Endpoint                    | Method | Description             |
      | /api/rankings/consensus     | GET    | Consensus rankings      |
      | /api/rankings/position/{pos}| GET    | Position-specific       |
      | /api/rankings/player/{id}   | GET    | Individual player       |
      | /api/rankings/expert/{id}   | GET    | Expert-specific         |
      | /api/rankings/history       | GET    | Historical rankings     |
    And authentication is required
    And rate limiting is enforced

  Scenario: Export rankings for offline draft use
    Given a user needs offline rankings
    When the user downloads offline ranking pack
    Then the download includes:
      | Content                    |
      | All position rankings      |
      | Tier breakdowns            |
      | Cheat sheets               |
      | Sleeper/bust lists         |
    And the pack is viewable offline
    And print-friendly versions are included
