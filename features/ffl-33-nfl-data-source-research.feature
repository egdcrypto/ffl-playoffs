# @ref: https://github.com/nflverse/nflreadpy
# @ref: docs/NFL_DATA_INTEGRATION_PROPOSAL.md
@spike @research @nfl-data
Feature: NFL Data Source Research
  As a development team
  We need to evaluate free NFL data sources
  So that we can select the best provider for player stats, schedules, and scores

  Background:
    Given the application requires NFL data for
      | Data Type       | Purpose                                    |
      | Player profiles | Name, position, team, status               |
      | Player stats    | Weekly passing, rushing, receiving, etc.   |
      | Game schedules  | Weekly matchups and start times            |
      | Live scores     | Real-time game scores during games         |
      | Fantasy points  | Calculated fantasy scoring per player      |
      | Injury reports  | Player injury status and updates           |

  # ============================================================================
  # API EVALUATION CRITERIA
  # ============================================================================

  @evaluation @criteria
  Scenario: Define mandatory evaluation criteria for all data sources
    Given we need to evaluate NFL data sources systematically
    Then each data source must be evaluated against these mandatory criteria
      | Category           | Criterion                  | Weight | Description                                      |
      | Data Quality       | Accuracy                   | High   | Data matches official NFL statistics             |
      | Data Quality       | Completeness               | High   | All required data types available                |
      | Data Quality       | Freshness                  | High   | Update latency during live games                 |
      | Reliability        | Uptime SLA                 | High   | Guaranteed availability percentage               |
      | Reliability        | Error rate                 | Medium | Historical API error frequency                   |
      | Reliability        | Redundancy                 | Medium | Backup/failover capabilities                     |
      | Cost               | Free tier limits           | High   | Requests and features in free plan               |
      | Cost               | Paid tier pricing          | Medium | Cost for production-level usage                  |
      | Cost               | Overage charges            | Medium | Cost for exceeding limits                        |
      | Technical          | Rate limits                | High   | Requests per second/minute/hour/day              |
      | Technical          | Authentication             | Medium | API key, OAuth, or other auth methods            |
      | Technical          | Documentation quality      | Medium | Clarity and completeness of API docs             |
      | Legal              | Terms of service           | High   | Usage restrictions and requirements              |
      | Legal              | Data attribution           | Medium | Required credits or logos                        |
      | Legal              | Commercial use             | High   | Permission for commercial applications           |

  @evaluation @criteria
  Scenario: Define fantasy-specific evaluation criteria
    Given our application calculates fantasy football scores
    Then each data source must also be evaluated for fantasy-specific criteria
      | Criterion                      | Required | Description                                      |
      | PPR scoring data               | Yes      | Reception count for PPR calculations             |
      | Defensive player stats         | Yes      | Individual defensive player statistics           |
      | Kicker stats                   | Yes      | Field goals, extra points by distance            |
      | Team defense stats             | Yes      | Points allowed, yards allowed, turnovers         |
      | Two-point conversions          | Yes      | Two-point conversion attempts and successes      |
      | Fumbles lost                   | Yes      | Differentiate fumbles vs fumbles lost            |
      | Return touchdowns              | Yes      | Punt and kick return TDs                         |
      | Weekly stat breakdown          | Yes      | Stats available per week, not just season totals |
      | Historical data availability  | Desired  | Access to previous seasons                       |
      | Injury designation             | Desired  | OUT, DOUBTFUL, QUESTIONABLE, PROBABLE            |

  @evaluation @criteria
  Scenario: Define data latency requirements for live scoring
    Given fantasy players need real-time score updates during games
    Then the data source must meet these latency requirements
      | Data Type              | Max Latency    | Priority | Notes                                  |
      | Score changes          | 30 seconds     | Critical | TD, FG, Safety must be near real-time  |
      | Player stat updates    | 60 seconds     | High     | Rushing, passing, receiving yards      |
      | Injury updates         | 5 minutes      | Medium   | In-game injury notifications           |
      | Game status changes    | 30 seconds     | High     | Quarter, time remaining, possession    |
      | Final scores           | 2 minutes      | High     | Game completion notification           |

  # ============================================================================
  # ESPN API EVALUATION
  # ============================================================================

  @evaluation @espn
  Scenario: Evaluate ESPN API data coverage
    Given ESPN API is a candidate data source
    When we evaluate the API for data coverage
    Then we should document data availability
      | Data Type              | Available | Endpoint                              | Notes                    |
      | Player profiles        | TBD       | /athletes                             | Name, position, team     |
      | Player photos          | TBD       | /athletes/{id}/image                  | Headshot images          |
      | Player stats           | TBD       | /athletes/{id}/statistics             | Career and season stats  |
      | Weekly stats           | TBD       | /athletes/{id}/statistics/week/{week} | Per-week breakdown       |
      | Team rosters           | TBD       | /teams/{id}/roster                    | Current roster           |
      | Game schedules         | TBD       | /scoreboard                           | Weekly matchups          |
      | Live scores            | TBD       | /scoreboard                           | Real-time scores         |
      | Play-by-play           | TBD       | /games/{id}/plays                     | Detailed game events     |
      | Injury reports         | TBD       | /injuries                             | Injury designations      |
      | News                   | TBD       | /news                                 | Player and team news     |

  @evaluation @espn
  Scenario: Evaluate ESPN API technical specifications
    Given ESPN API is a candidate data source
    When we evaluate the API for technical specifications
    Then we should document
      | Specification          | Value     | Notes                                            |
      | Base URL               | TBD       | API endpoint base                                |
      | Authentication         | TBD       | API key, OAuth, public                           |
      | Rate limit per second  | TBD       | Requests per second allowed                      |
      | Rate limit per day     | TBD       | Daily request quota                              |
      | Response format        | TBD       | JSON, XML, or other                              |
      | Pagination support     | TBD       | How large datasets are handled                   |
      | Webhook support        | TBD       | Push notifications for updates                   |
      | SDK availability       | TBD       | Official client libraries                        |
      | Sandbox environment    | TBD       | Testing environment available                    |

  @evaluation @espn
  Scenario: Evaluate ESPN API reliability and support
    Given ESPN API is a candidate data source
    When we evaluate the API for reliability
    Then we should document
      | Criterion              | Assessment | Notes                                            |
      | Documented uptime SLA  | TBD        | Guaranteed availability percentage               |
      | Status page            | TBD        | Real-time API status monitoring                  |
      | Historical reliability | TBD        | Known outage history                             |
      | Support channels       | TBD        | Email, forum, chat support options               |
      | Response time SLA      | TBD        | Expected response times                          |
      | Maintenance windows    | TBD        | Scheduled downtime practices                     |

  @evaluation @espn
  Scenario: Evaluate ESPN API legal and licensing
    Given ESPN API is a candidate data source
    When we evaluate the API for legal requirements
    Then we should document
      | Requirement            | Status    | Notes                                            |
      | Terms of Service URL   | TBD       | Link to full terms                               |
      | Commercial use allowed | TBD       | Permission for commercial apps                   |
      | Attribution required   | TBD       | Credit or logo requirements                      |
      | Data resale prohibited | TBD       | Restrictions on reselling data                   |
      | API key requirements   | TBD       | How to obtain and manage keys                    |
      | Usage monitoring       | TBD       | How ESPN tracks API usage                        |

  @evaluation @espn
  Scenario: Test ESPN API fantasy data quality
    Given ESPN API is a candidate data source
    When we test the API with sample requests
    Then we should verify fantasy-relevant data fields
      | Data Element           | Present   | Accuracy  | Notes                                  |
      | Passing yards          | TBD       | TBD       | Compare with official NFL stats        |
      | Rushing yards          | TBD       | TBD       | Compare with official NFL stats        |
      | Receiving yards        | TBD       | TBD       | Compare with official NFL stats        |
      | Receptions             | TBD       | TBD       | Critical for PPR scoring               |
      | Touchdowns by type     | TBD       | TBD       | Passing, rushing, receiving TDs        |
      | Interceptions          | TBD       | TBD       | For QB scoring                         |
      | Fumbles lost           | TBD       | TBD       | Deduction for turnovers                |
      | Two-point conversions  | TBD       | TBD       | Bonus points                           |
      | Field goals by range   | TBD       | TBD       | Distance-based kicker scoring          |

  # ============================================================================
  # SPORTSDATA.IO API EVALUATION
  # ============================================================================

  @evaluation @sportsdataio
  Scenario: Evaluate SportsData.io API data coverage
    Given SportsData.io API is a candidate data source
    When we evaluate the API for data coverage
    Then we should document data availability
      | Data Type              | Available | Endpoint                              | Notes                    |
      | Player profiles        | TBD       | /players                              | Comprehensive player data|
      | Player photos          | TBD       | Included in player data               | High-res headshots       |
      | Player stats           | TBD       | /PlayerSeasonStats                    | Season statistics        |
      | Weekly stats           | TBD       | /PlayerGameStats/{season}/{week}      | Per-week breakdown       |
      | Team rosters           | TBD       | /Players/{team}                       | Current roster           |
      | Game schedules         | TBD       | /Scores/{season}                      | Full season schedule     |
      | Live scores            | TBD       | /ScoresByWeek/{season}/{week}         | Real-time scores         |
      | Play-by-play           | TBD       | /PlayByPlay/{gameId}                  | Detailed game events     |
      | Injury reports         | TBD       | /Injuries/{season}/{week}             | Injury designations      |
      | News                   | TBD       | /News                                 | Rotowire news feed       |
      | Fantasy points         | TBD       | /FantasyPlayers                       | Pre-calculated fantasy   |
      | DFS salaries           | TBD       | /DfsSlates                            | DraftKings/FanDuel       |

  @evaluation @sportsdataio
  Scenario: Evaluate SportsData.io API technical specifications
    Given SportsData.io API is a candidate data source
    When we evaluate the API for technical specifications
    Then we should document
      | Specification          | Value     | Notes                                            |
      | Base URL               | TBD       | api.sportsdata.io/v3/nfl                         |
      | Authentication         | TBD       | Ocp-Apim-Subscription-Key header                 |
      | Rate limit per second  | TBD       | Based on subscription tier                       |
      | Rate limit per day     | TBD       | Based on subscription tier                       |
      | Response format        | TBD       | JSON and XML supported                           |
      | Pagination support     | TBD       | Limited, most endpoints return full data         |
      | Webhook support        | TBD       | Push notifications available                     |
      | SDK availability       | TBD       | Official wrappers in multiple languages          |
      | Sandbox environment    | TBD       | Trial tier with sample data                      |

  @evaluation @sportsdataio
  Scenario: Evaluate SportsData.io API pricing tiers
    Given SportsData.io API is a candidate data source
    When we evaluate the API pricing structure
    Then we should document tier details
      | Tier         | Monthly Cost | Requests/Month | Features                                 |
      | Free Trial   | TBD          | TBD            | Limited access, sample data              |
      | Developer    | TBD          | TBD            | Basic stats, schedules, scores           |
      | Standard     | TBD          | TBD            | Full stats, projections, news            |
      | Premium      | TBD          | TBD            | Real-time, play-by-play, odds            |
      | Enterprise   | TBD          | TBD            | Custom limits, dedicated support         |
    And we should calculate estimated production costs
      | Usage Scenario         | Requests/Day | Monthly Cost | Notes                            |
      | Development            | TBD          | TBD          | Testing and development          |
      | Soft launch (100 users)| TBD          | TBD          | Initial user base                |
      | Growth (1000 users)    | TBD          | TBD          | Moderate user base               |
      | Scale (10000 users)    | TBD          | TBD          | Large user base                  |

  @evaluation @sportsdataio
  Scenario: Evaluate SportsData.io API reliability and support
    Given SportsData.io API is a candidate data source
    When we evaluate the API for reliability
    Then we should document
      | Criterion              | Assessment | Notes                                            |
      | Documented uptime SLA  | TBD        | 99.9% typical for enterprise                     |
      | Status page            | TBD        | status.sportsdata.io                             |
      | Historical reliability | TBD        | Established provider since 2008                  |
      | Support channels       | TBD        | Email, documentation, developer forum            |
      | Response time SLA      | TBD        | Typical response latency                         |
      | Maintenance windows    | TBD        | Scheduled downtime practices                     |

  @evaluation @sportsdataio
  Scenario: Test SportsData.io API fantasy data quality
    Given SportsData.io API is a candidate data source
    When we test the API with sample requests
    Then we should verify fantasy-relevant data fields
      | Data Element           | Present   | Accuracy  | Notes                                  |
      | FantasyPoints          | TBD       | TBD       | Pre-calculated fantasy points          |
      | FantasyPointsPPR       | TBD       | TBD       | PPR fantasy points                     |
      | PassingYards           | TBD       | TBD       | Official NFL stat match                |
      | RushingYards           | TBD       | TBD       | Official NFL stat match                |
      | ReceivingYards         | TBD       | TBD       | Official NFL stat match                |
      | Receptions             | TBD       | TBD       | Critical for PPR scoring               |
      | Touchdowns             | TBD       | TBD       | Broken down by type                    |
      | FumblesLost            | TBD       | TBD       | Deduction tracking                     |
      | FieldGoalsMade         | TBD       | TBD       | With distance breakdown                |
      | DefensiveStats         | TBD       | TBD       | Team and individual defense            |

  # ============================================================================
  # API-FOOTBALL EVALUATION
  # ============================================================================

  @evaluation @api-football
  Scenario: Evaluate API-Football data coverage for NFL
    Given API-Football is a candidate data source
    When we evaluate the API for NFL data coverage
    Then we should document data availability
      | Data Type              | Available | Endpoint                              | Notes                    |
      | Player profiles        | TBD       | /players                              | Player information       |
      | Player photos          | TBD       | Included in player data               | Headshot availability    |
      | Player stats           | TBD       | /players/statistics                   | Season statistics        |
      | Weekly stats           | TBD       | TBD                                   | Per-week breakdown       |
      | Team rosters           | TBD       | /players/squads                       | Current roster           |
      | Game schedules         | TBD       | /games                                | Fixtures and schedules   |
      | Live scores            | TBD       | /games                                | Real-time scores         |
      | Play-by-play           | TBD       | TBD                                   | Detailed game events     |
      | Injury reports         | TBD       | /injuries                             | Injury information       |
      | Fantasy points         | TBD       | TBD                                   | Pre-calculated fantasy   |
    And we should note that API-Football primarily covers soccer
      | Consideration                      | Impact                                           |
      | Primary sport coverage             | Soccer/Football (European) is main focus         |
      | NFL coverage depth                 | May be limited compared to dedicated NFL APIs    |
      | American football endpoints        | Verify availability for NFL specifically         |

  @evaluation @api-football
  Scenario: Evaluate API-Football technical specifications
    Given API-Football is a candidate data source
    When we evaluate the API for technical specifications
    Then we should document
      | Specification          | Value     | Notes                                            |
      | Base URL               | TBD       | v1.american-football.api-sports.io              |
      | Authentication         | TBD       | X-RapidAPI-Key header                            |
      | Rate limit per second  | TBD       | Based on RapidAPI subscription                   |
      | Rate limit per day     | TBD       | Based on RapidAPI subscription                   |
      | Response format        | TBD       | JSON format                                      |
      | Pagination support     | TBD       | Pagination parameters available                  |
      | Webhook support        | TBD       | Push notification capability                     |
      | SDK availability       | TBD       | RapidAPI code snippets                           |
      | Sandbox environment    | TBD       | Free tier for testing                            |

  @evaluation @api-football
  Scenario: Evaluate API-Football pricing through RapidAPI
    Given API-Football is a candidate data source
    When we evaluate the API pricing through RapidAPI
    Then we should document tier details
      | Tier         | Monthly Cost | Requests/Day | Requests/Month | Features               |
      | Free         | TBD          | TBD          | TBD            | Limited access         |
      | Basic        | TBD          | TBD          | TBD            | Core features          |
      | Pro          | TBD          | TBD          | TBD            | Full access            |
      | Ultra        | TBD          | TBD          | TBD            | Maximum limits         |
      | Mega         | TBD          | TBD          | TBD            | Enterprise level       |

  @evaluation @api-football
  Scenario: Evaluate API-Football NFL-specific limitations
    Given API-Football is a candidate data source
    When we evaluate NFL-specific coverage
    Then we should document potential limitations
      | Area                   | Concern                                | Mitigation                        |
      | Fantasy data           | May not include pre-calculated points  | Would need to calculate ourselves |
      | Historical data        | NFL historical depth unknown           | Test with past season requests    |
      | Real-time latency      | NFL update frequency unknown           | Test during live games            |
      | PPR statistics         | Reception data availability            | Verify receptions endpoint        |
      | Kicker details         | Field goal distance breakdown          | Test kicker stat endpoints        |
      | Defensive players      | Individual defensive stats             | Test IDP data availability        |

  # ============================================================================
  # ADDITIONAL DATA SOURCES TO CONSIDER
  # ============================================================================

  @evaluation @nflverse
  Scenario: Evaluate NFLverse/nflreadpy as data source
    Given NFLverse provides open-source NFL data
    When we evaluate it for our requirements
    Then we should document
      | Criterion              | Assessment | Notes                                            |
      | Data coverage          | TBD        | Play-by-play, player stats, historical data      |
      | Real-time availability | TBD        | Data typically updated after games complete      |
      | Cost                   | TBD        | Free and open source                             |
      | Python integration     | TBD        | nflreadpy library available                      |
      | Java integration       | TBD        | Would need custom implementation                 |
      | Commercial use         | TBD        | MIT license typically allows commercial use      |
      | Reliability            | TBD        | Community maintained, no SLA                     |
      | Fantasy points         | TBD        | May need to calculate from raw stats             |

  @evaluation @nfl-official
  Scenario: Evaluate official NFL data sources
    Given NFL provides official APIs and data
    When we evaluate official sources
    Then we should document
      | Source                 | Assessment | Notes                                            |
      | NFL.com API            | TBD        | Official but may have usage restrictions         |
      | NFL Fantasy API        | TBD        | Powers NFL Fantasy app                           |
      | NFL Data License       | TBD        | Official licensing program                       |
      | NextGenStats           | TBD        | Advanced metrics (separate licensing)            |
    And we should document access requirements
      | Requirement            | Status     | Notes                                            |
      | Partner agreement      | TBD        | May require formal partnership                   |
      | Usage restrictions     | TBD        | Commercial use limitations                       |
      | Cost                   | TBD        | Licensing fees if applicable                     |

  # ============================================================================
  # DATA SOURCE COMPARISON AND SELECTION
  # ============================================================================

  @recommendation @comparison
  Scenario: Create weighted comparison matrix for all data sources
    Given we have evaluated all candidate data sources
    When we create a weighted comparison matrix
    Then each source should be scored against criteria
      | Criterion                | Weight | ESPN | SportsData.io | API-Football | NFLverse |
      | Data completeness        | 20%    | TBD  | TBD           | TBD          | TBD      |
      | Fantasy data quality     | 20%    | TBD  | TBD           | TBD          | TBD      |
      | Real-time latency        | 15%    | TBD  | TBD           | TBD          | TBD      |
      | Reliability/uptime       | 15%    | TBD  | TBD           | TBD          | TBD      |
      | Cost effectiveness       | 10%    | TBD  | TBD           | TBD          | TBD      |
      | Ease of integration      | 10%    | TBD  | TBD           | TBD          | TBD      |
      | Documentation quality    | 5%     | TBD  | TBD           | TBD          | TBD      |
      | Legal/commercial terms   | 5%     | TBD  | TBD           | TBD          | TBD      |
    And we should calculate a weighted total score for each source
    And we should rank the sources by score

  @recommendation @comparison
  Scenario: Document strengths and weaknesses of each source
    Given we have evaluated all candidate data sources
    Then we should document pros and cons for each
      | Source         | Strengths                                    | Weaknesses                                   |
      | ESPN           | TBD                                          | TBD                                          |
      | SportsData.io  | TBD                                          | TBD                                          |
      | API-Football   | TBD                                          | TBD                                          |
      | NFLverse       | TBD                                          | TBD                                          |
    And we should identify which source is best for each use case
      | Use Case                 | Best Source | Rationale                                    |
      | Real-time scoring        | TBD         | TBD                                          |
      | Historical analysis      | TBD         | TBD                                          |
      | Player profiles          | TBD         | TBD                                          |
      | Schedule management      | TBD         | TBD                                          |
      | Injury tracking          | TBD         | TBD                                          |

  @recommendation @selection
  Scenario: Select primary and fallback data sources
    Given we have evaluated all candidate data sources
    When we compare them against our requirements
    Then we should recommend a primary data source
      | Decision             | Source         | Rationale                                        |
      | Primary source       | TBD            | TBD                                              |
    And we should recommend a fallback data source
      | Decision             | Source         | Rationale                                        |
      | Fallback source      | TBD            | TBD                                              |
    And we should document the selection rationale
      | Consideration        | Primary Choice Impact | Fallback Choice Impact                   |
      | Cost                 | TBD                   | TBD                                      |
      | Reliability          | TBD                   | TBD                                      |
      | Feature coverage     | TBD                   | TBD                                      |
      | Integration effort   | TBD                   | TBD                                      |
    And we should update docs/NFL_DATA_INTEGRATION_PROPOSAL.md

  @recommendation @hybrid
  Scenario: Evaluate hybrid approach using multiple sources
    Given different sources may excel at different data types
    When we evaluate a hybrid integration approach
    Then we should document potential combinations
      | Data Type              | Primary Source | Fallback Source | Rationale                      |
      | Real-time scores       | TBD            | TBD             | TBD                            |
      | Player stats           | TBD            | TBD             | TBD                            |
      | Historical data        | TBD            | TBD             | TBD                            |
      | Fantasy projections    | TBD            | TBD             | TBD                            |
      | Injury reports         | TBD            | TBD             | TBD                            |
    And we should assess the complexity of hybrid approach
      | Factor                 | Complexity    | Mitigation                                   |
      | Data normalization     | TBD           | Common domain model for all sources          |
      | Failover logic         | TBD           | Circuit breaker pattern                      |
      | Cost management        | TBD           | Usage monitoring and alerting                |
      | Data consistency       | TBD           | Reconciliation processes                     |

  # ============================================================================
  # RISK ASSESSMENT
  # ============================================================================

  @recommendation @risk
  Scenario: Assess risks of each data source choice
    Given data source selection impacts application reliability
    When we assess risks for each option
    Then we should document risk factors
      | Source         | Risk Type        | Likelihood | Impact | Mitigation                        |
      | ESPN           | API deprecation  | TBD        | High   | Monitor for announcements         |
      | ESPN           | Rate limiting    | TBD        | Medium | Implement caching                 |
      | SportsData.io  | Cost increase    | TBD        | Medium | Budget for increases              |
      | SportsData.io  | Vendor lock-in   | TBD        | Medium | Abstraction layer                 |
      | API-Football   | NFL coverage gap | TBD        | High   | Test thoroughly before commit     |
      | API-Football   | Latency issues   | TBD        | Medium | Fallback to other source          |
      | NFLverse       | Update delays    | TBD        | Medium | Not suitable for real-time        |
      | NFLverse       | Maintenance risk | TBD        | Low    | Fork and maintain if needed       |

  @recommendation @risk
  Scenario: Define contingency plans for data source failures
    Given API dependencies can fail unexpectedly
    When we plan for contingencies
    Then we should document fallback strategies
      | Failure Scenario                   | Detection Method                 | Fallback Action                        |
      | Primary API returns errors         | Circuit breaker opens            | Switch to fallback source              |
      | Primary API exceeds rate limit     | 429 response code                | Queue requests, use cached data        |
      | Primary API returns stale data     | Timestamp comparison             | Alert and investigate                  |
      | Primary API data format changes    | Schema validation fails          | Fall back, alert for investigation     |
      | Primary API goes offline           | Health check fails               | Automatic failover to backup           |
      | Both primary and fallback fail     | All health checks fail           | Show cached data with warning          |
    And we should define recovery procedures
      | Recovery Step                      | Responsible Party                | SLA                                    |
      | Detect failure                     | Automated monitoring             | < 1 minute                             |
      | Switch to fallback                 | Automated failover               | < 30 seconds                           |
      | Notify team                        | Alerting system                  | < 5 minutes                            |
      | Investigate root cause             | On-call engineer                 | < 30 minutes                           |
      | Restore primary                    | Engineering team                 | ASAP after resolution                  |

  # ============================================================================
  # INTEGRATION ARCHITECTURE
  # ============================================================================

  @recommendation @architecture
  Scenario: Define data source abstraction layer
    Given we may need to switch data sources in the future
    When we design the integration architecture
    Then we should use the ports and adapters pattern
      | Component                  | Purpose                                             |
      | NFLDataPort (interface)    | Define contract for NFL data retrieval              |
      | ESPNAdapter                | ESPN-specific implementation                        |
      | SportsDataIOAdapter        | SportsData.io-specific implementation               |
      | APIFootballAdapter         | API-Football-specific implementation                |
      | NFLverseAdapter            | NFLverse-specific implementation                    |
    And adapters should implement common data models
      | Domain Model               | Purpose                                             |
      | NFLPlayer                  | Unified player representation                       |
      | NFLGame                    | Unified game/schedule representation                |
      | NFLPlayerStats             | Unified stats representation                        |
      | NFLTeam                    | Unified team representation                         |
    And the architecture should support
      | Capability                 | Implementation                                      |
      | Source switching           | Configuration-driven adapter selection              |
      | Fallback                   | Circuit breaker with automatic failover             |
      | Caching                    | Redis cache layer for all adapters                  |
      | Rate limiting              | Token bucket per source                             |
      | Monitoring                 | Metrics per adapter                                 |

  @recommendation @architecture
  Scenario: Define data synchronization strategy
    Given external APIs have rate limits and costs
    When we design the synchronization strategy
    Then we should document the sync approach
      | Data Type              | Sync Frequency    | Trigger                      | Storage            |
      | Player roster          | Daily             | Scheduled job                | MongoDB            |
      | Weekly schedule        | Weekly            | Season start + weekly        | MongoDB            |
      | Live scores            | Every 30 seconds  | During game windows          | Redis cache        |
      | Player stats           | Hourly            | During game windows          | MongoDB            |
      | Final stats            | Post-game         | Game completion webhook      | MongoDB            |
      | Injury updates         | Every 4 hours     | Scheduled job                | MongoDB            |
    And we should define cache TTL policies
      | Data Type              | Cache TTL         | Invalidation Trigger                     |
      | Player profiles        | 24 hours          | Manual refresh or roster changes         |
      | Game schedules         | 1 hour            | Week transition                          |
      | Live scores            | 30 seconds        | Next API poll                            |
      | Player stats           | 5 minutes         | Next stat update                         |
      | Historical data        | 7 days            | Stat corrections                         |

  # ============================================================================
  # SPIKE COMPLETION CRITERIA
  # ============================================================================

  @acceptance @documentation
  Scenario: Spike completion criteria
    Given the spike research is complete
    Then the following artifacts should exist
      | Artifact                                    | Location                              |
      | Data source comparison matrix               | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |
      | Recommended primary source                  | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |
      | Recommended fallback source                 | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |
      | API key requirements documented             | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |
      | Rate limiting strategy                      | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |
      | Cost estimate for production                | docs/NFL_DATA_INTEGRATION_PROPOSAL.md |

  @acceptance @documentation
  Scenario: Document detailed API integration findings
    Given the spike research is complete
    Then the documentation should include for each evaluated API
      | Section                                     | Content                               |
      | Authentication setup                        | How to obtain and configure API keys  |
      | Request examples                            | Sample curl/code for key endpoints    |
      | Response schemas                            | JSON structure for main data types    |
      | Error handling                              | Error codes and meanings              |
      | Rate limit handling                         | How to detect and handle limits       |
      | Gotchas and quirks                          | Non-obvious behaviors discovered      |

  @acceptance @documentation
  Scenario: Provide cost analysis in documentation
    Given the spike research is complete
    Then the cost analysis should include
      | Analysis Component                          | Detail                                          |
      | Monthly cost by tier                        | Breakdown for each pricing tier                 |
      | Projected usage by user count              | Requests needed for 100, 1000, 10000 users     |
      | Cost comparison chart                       | Visual comparison of all sources                |
      | Break-even analysis                         | When paid tier becomes necessary                |
      | Budget recommendation                       | Suggested monthly budget allocation             |
      | Cost optimization strategies                | Ways to minimize API costs                      |

  @acceptance @documentation
  Scenario: Document implementation recommendations
    Given the spike research is complete
    Then the implementation recommendations should include
      | Recommendation                              | Rationale                                       |
      | Primary data source                         | Why this source was selected                    |
      | Fallback data source                        | Why this source was selected as backup          |
      | Integration architecture                    | High-level architecture diagram                 |
      | Implementation phases                       | Suggested order of implementation               |
      | Technical debt considerations               | Known limitations to address later              |
      | Future enhancements                         | Potential improvements post-MVP                 |

  @acceptance @artifacts
  Scenario: Create proof-of-concept code samples
    Given the spike research is complete
    Then we should provide working code samples
      | Sample                                      | Purpose                                         |
      | Primary API client                          | Basic client for recommended source             |
      | Authentication wrapper                      | API key management                              |
      | Rate limit handler                          | Token bucket implementation                     |
      | Data model mapping                          | API response to domain model                    |
      | Error handling                              | Retry and circuit breaker logic                 |
    And the samples should follow project conventions
      | Convention                                  | Implementation                                  |
      | Hexagonal architecture                      | Port interfaces with adapter implementations    |
      | Logging                                     | Slf4j with appropriate log levels               |
      | Testing                                     | Unit tests for core logic                       |
      | Configuration                               | Externalized via Spring properties              |

  @acceptance @decision
  Scenario: Record architecture decision
    Given the spike research is complete
    Then we should create an Architecture Decision Record (ADR)
      | ADR Section                                 | Content                                         |
      | Title                                       | NFL Data Source Selection                       |
      | Status                                      | Proposed/Accepted after review                  |
      | Context                                     | Why we needed to evaluate data sources          |
      | Decision                                    | Which source(s) we selected                     |
      | Consequences                                | Implications of this decision                   |
      | Alternatives considered                     | Other options we evaluated                      |
    And the ADR should be stored at
      | Location                                    |
      | docs/adr/ADR-XXX-nfl-data-source.md         |

  # ============================================================================
  # TIMELINE AND NEXT STEPS
  # ============================================================================

  @acceptance @planning
  Scenario: Define next steps after spike completion
    Given the spike research is complete
    When we plan implementation work
    Then we should create follow-up tickets
      | Ticket                                      | Description                                     |
      | NFL Data Port Interface                     | Create NFLDataPort interface                    |
      | Primary Adapter Implementation              | Implement adapter for selected primary source   |
      | Fallback Adapter Implementation             | Implement adapter for selected fallback source  |
      | Data Sync Service                           | Implement scheduled data synchronization        |
      | Caching Layer                               | Implement Redis caching for NFL data            |
      | Rate Limiting                               | Implement rate limiting for API calls           |
      | Circuit Breaker                             | Implement resilience patterns                   |
      | Monitoring Dashboard                        | Create Grafana dashboard for NFL data           |
    And tickets should be prioritized based on dependencies
      | Priority | Ticket                                      | Depends On                      |
      | 1        | NFL Data Port Interface                     | None                            |
      | 2        | Primary Adapter Implementation              | NFL Data Port Interface         |
      | 3        | Data Sync Service                           | Primary Adapter Implementation  |
      | 4        | Caching Layer                               | Data Sync Service               |
      | 5        | Fallback Adapter Implementation             | NFL Data Port Interface         |
      | 6        | Circuit Breaker                             | Primary and Fallback Adapters   |
      | 7        | Rate Limiting                               | Circuit Breaker                 |
      | 8        | Monitoring Dashboard                        | All above                       |

  @acceptance @review
  Scenario: Spike review and approval
    Given the spike research is complete
    And all documentation has been created
    Then the spike should be reviewed by
      | Reviewer                                    | Focus Area                                      |
      | Tech Lead                                   | Technical approach and architecture             |
      | Product Owner                               | Feature completeness and cost                   |
      | Security                                    | API key management and data handling            |
    And the spike is complete when
      | Criteria                                    | Status                                          |
      | Primary source selected                     | Documented and approved                         |
      | Fallback source selected                    | Documented and approved                         |
      | Cost estimate approved                      | Within budget                                   |
      | Architecture approved                       | Reviewed by tech lead                           |
      | Follow-up tickets created                   | Backlog populated                               |
