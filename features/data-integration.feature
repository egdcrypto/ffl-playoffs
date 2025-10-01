Feature: Data Integration with External NFL Data Sources
  As the system
  I want to integrate with external NFL data sources
  So that I can provide accurate, real-time game data and scores

  Background:
    Given the system is configured with NFL data API credentials
    And the game "2025 NFL Playoffs Pool" is active
    And the league starts at NFL week 15 with 4 weeks

  # NFL Schedule Integration

  Scenario: Fetch NFL game schedule for league weeks
    Given the league covers NFL weeks 15, 16, 17, 18
    When the system fetches the NFL schedule
    Then the schedule for weeks 15-18 should be retrieved
    And each game should include:
      | homeTeam         |
      | awayTeam         |
      | gameDateTime     |
      | venue            |
      | nflWeekNumber    |
    And schedules for weeks 1-14 should NOT be fetched
    And schedules for weeks beyond 18 should NOT be fetched

  Scenario: Update game schedules when NFL makes changes
    Given the NFL schedule was fetched yesterday
    And an NFL game in week 16 has been rescheduled
    When the system performs a schedule refresh
    Then the updated game date and time are retrieved
    And the GameResult entity is updated with new schedule
    And players are notified of the schedule change

  Scenario: Handle bye weeks in schedule
    Given the league includes NFL week 14
    And "Team A" has a bye week in week 14
    When the schedule is fetched for week 14
    Then "Team A" should be marked as having a bye
    And no game should be scheduled for "Team A"
    And players who selected "Team A" are notified

  # Live Game Data Synchronization

  Scenario: Fetch live game scores during games
    Given NFL week 15 games are in progress
    And the data refresh interval is 2 minutes
    When the system fetches live game data
    Then current scores for all week 15 games are retrieved
    And the data includes:
      | homeTeamScore      |
      | awayTeamScore      |
      | quarter            |
      | timeRemaining      |
      | gameStatus         |
    And the data is refreshed every 2 minutes

  Scenario: Update player statistics in real-time
    Given player "john_player" selected "Kansas City Chiefs" for week 15
    And the "Kansas City Chiefs" game is in progress
    When live statistics are fetched
    Then the system retrieves:
      | passingYards     |
      | rushingYards     |
      | receivingYards   |
      | receptions       |
      | touchdowns       |
      | fieldGoals       |
      | defensiveStats   |
    And player scores are recalculated
    And the leaderboard is updated

  Scenario: Data sync respects league-specific NFL weeks
    Given league "Playoffs League" covers NFL weeks 15-18
    And league "Mid-Season League" covers NFL weeks 8-13
    When data synchronization runs
    Then "Playoffs League" fetches data only for weeks 15-18
    And "Mid-Season League" fetches data only for weeks 8-13
    And no overlap or unnecessary data is fetched

  # Game Result Finalization

  Scenario: Finalize game results when games complete
    Given a game between "Buffalo Bills" and "Miami Dolphins" is in progress
    And the game clock reaches 0:00 in the 4th quarter
    When the game status changes to "FINAL"
    Then the system fetches final statistics
    And the GameResult is marked as FINAL
    And the win/loss status is recorded
    And elimination logic is triggered
    And final scores are calculated

  Scenario: Handle overtime games
    Given a game is tied at the end of regulation
    When the game goes into overtime
    Then the system continues fetching live data
    And the game status is "OVERTIME"
    When overtime completes
    Then final statistics include overtime performance
    And the winner is determined correctly

  Scenario: Capture detailed field goal data for scoring
    Given a game includes field goal attempts
    When game statistics are fetched
    Then each field goal should include:
      | distance        |
      | made/missed     |
      | quarter         |
      | kicker          |
    And field goals are categorized by distance:
      | 0-39 yards      |
      | 40-49 yards     |
      | 50+ yards       |
    And the correct points are awarded based on league configuration

  # Defensive Statistics Integration

  Scenario: Fetch comprehensive defensive statistics
    Given a game has completed
    When defensive statistics are fetched
    Then the system retrieves:
      | sacks                    |
      | interceptions            |
      | fumbleRecoveries         |
      | safeties                 |
      | defensiveTouchdowns      |
      | pointsAllowed            |
      | totalYardsAllowed        |
      | passingYardsAllowed      |
      | rushingYardsAllowed      |
    And statistics are broken down by team

  Scenario: Calculate points allowed tiers from game data
    Given the "Pittsburgh Steelers" allowed 10 points in their game
    And the league has standard points allowed tiers configured
    When defensive scoring is calculated
    Then the "Pittsburgh Steelers" defense receives 7 fantasy points for points allowed (1-6 tier)

  Scenario: Calculate yards allowed tiers from game data
    Given the "New England Patriots" allowed 285 total yards
    And the league has standard yards allowed tiers configured
    When defensive scoring is calculated
    Then the "New England Patriots" defense receives 5 fantasy points for yards allowed (200-299 tier)

  # Error Handling and Reliability

  Scenario: Handle API timeout gracefully
    Given the NFL data API is experiencing delays
    When a data fetch request times out after 30 seconds
    Then the system logs the timeout error
    And the system retries the request after 5 minutes
    And the system uses cached data if available
    And admins are notified if timeout persists

  Scenario: Handle API rate limiting
    Given the NFL data API has a rate limit of 100 requests per minute
    When the system approaches the rate limit
    Then requests are queued and throttled
    And the system ensures it stays within limits
    And critical data (live scores) is prioritized

  Scenario: Handle missing or incomplete data
    Given the NFL data API returns incomplete statistics
    And passing yards are missing for a game
    When the system processes the data
    Then the system marks the score as "PENDING"
    And the system retries fetching after 15 minutes
    And players are notified of the delay

  Scenario: Fallback to secondary data source
    Given the primary NFL data API is unavailable
    And a secondary data source is configured
    When the system detects primary source failure
    Then the system switches to the secondary source
    And data fetching continues without interruption
    And admins are notified of the switch

  # Data Validation

  Scenario: Validate fetched data for consistency
    Given game data is fetched from the API
    When the system processes the data
    Then the system validates:
      | Scores are non-negative         |
      | Team names match expected values|
      | Game status is valid enum       |
      | Statistics are within reasonable ranges |
    And invalid data is rejected
    And errors are logged for review

  Scenario: Detect and handle stat corrections
    Given final game statistics were imported yesterday
    And the NFL issues a stat correction today
    When the system detects the correction
    Then the GameResult is updated with corrected stats
    And player scores are recalculated
    And the leaderboard is updated
    And affected players are notified

  # Near Real-Time Synchronization

  Scenario: Configure data refresh intervals
    Given the admin configures data refresh settings
    When the admin sets live game refresh to 90 seconds
    And sets completed game refresh to 5 minutes
    Then the system uses 90-second intervals for in-progress games
    And uses 5-minute intervals to check for stat corrections

  Scenario: Adaptive refresh based on game status
    Given a game is scheduled to start at 1:00 PM ET
    And the current time is 11:00 AM ET
    When the system checks game status
    Then the refresh interval is 30 minutes (pre-game)
    When the game starts
    Then the refresh interval changes to 90 seconds (live)
    When the game ends
    Then the refresh interval changes to 5 minutes (post-game)
    After 24 hours
    Then the refresh stops (final)

  # Historical Data Import

  Scenario: Import historical game data for completed weeks
    Given a new league is created mid-season
    And the league starts at NFL week 15
    And NFL weeks 1-14 have already completed
    When the league is activated
    Then the system does NOT import weeks 1-14 data
    And only data for weeks 15-18 is monitored

  Scenario: Backfill data for postponed games
    Given a game was postponed from week 15 to week 16
    And week 15 scoring was calculated without the postponed game
    When the postponed game is played in week 16
    Then the system fetches the game results
    And week 15 scores are recalculated
    And affected players' scores are updated
    And the leaderboard is updated retroactively

  # Team and Player Data

  Scenario: Fetch NFL team information
    Given the system needs to populate team data
    When the system fetches team information
    Then all 32 NFL teams are retrieved
    And each team includes:
      | teamName         |
      | abbreviation     |
      | city             |
      | conference       |
      | division         |
      | logoUrl          |
    And team data is cached for the season
    And no pagination is needed (only 32 teams)

  Scenario: Update team records and standings
    Given the season is in progress
    When the system fetches team standings
    Then each team's record is updated:
      | wins             |
      | losses           |
      | ties             |
      | winPercentage    |
    And standings are displayed to players for team selection

  # Pagination for Data Retrieval

  Scenario: Paginate NFL team list with default page size
    Given there are 32 NFL teams in the system
    When the client requests the team list without pagination parameters
    Then the response includes 20 teams (default page size)
    And the response includes pagination metadata:
      | page           | 0              |
      | size           | 20             |
      | totalElements  | 32             |
      | totalPages     | 2              |
      | hasNext        | true           |
      | hasPrevious    | false          |

  Scenario: Request specific page of NFL teams
    Given there are 32 NFL teams in the system
    When the client requests page 1 with size 10
    Then the response includes teams 11-20
    And the pagination metadata shows:
      | page           | 1              |
      | size           | 10             |
      | totalElements  | 32             |
      | totalPages     | 4              |
      | hasNext        | true           |
      | hasPrevious    | true           |

  Scenario: Configure custom page size
    Given the client wants to see more items per page
    When the client requests page 0 with size 50
    Then the response includes all 32 teams
    And the pagination metadata shows:
      | page           | 0              |
      | size           | 50             |
      | totalElements  | 32             |
      | totalPages     | 1              |
      | hasNext        | false          |
      | hasPrevious    | false          |

  Scenario: Paginate game results for a league week
    Given NFL week 15 has 16 games scheduled
    When the client requests game results with page size 5
    Then page 0 contains games 1-5
    And page 1 contains games 6-10
    And page 2 contains games 11-15
    And page 3 contains game 16
    And each response includes total count of 16

  Scenario: Paginate leaderboard with many players
    Given a league has 100 players
    When the client requests the leaderboard with page size 25
    Then page 0 shows ranks 1-25
    And page 1 shows ranks 26-50
    And page 2 shows ranks 51-75
    And page 3 shows ranks 76-100
    And pagination links are provided for next/previous pages

  Scenario: Request page beyond available data
    Given there are 32 NFL teams
    When the client requests page 10 with size 20
    Then the response returns an empty list
    And the pagination metadata shows:
      | page           | 10             |
      | size           | 20             |
      | totalElements  | 32             |
      | totalPages     | 2              |
      | hasNext        | false          |
      | hasPrevious    | true           |

  Scenario: Pagination with filtering
    Given there are 32 NFL teams
    And the client filters by conference "AFC"
    When the client requests page 0 with size 10
    Then the response includes 10 AFC teams
    And the pagination metadata reflects filtered total:
      | totalElements  | 16 (AFC teams) |
      | totalPages     | 2              |

  Scenario: Pagination includes navigation links
    Given a paginated API response for teams
    When the client is on page 1 of 4
    Then the response includes navigation links:
      | first    | /api/v1/teams?page=0&size=10       |
      | previous | /api/v1/teams?page=0&size=10       |
      | self     | /api/v1/teams?page=1&size=10       |
      | next     | /api/v1/teams?page=2&size=10       |
      | last     | /api/v1/teams?page=3&size=10       |

  Scenario: Validate page size limits
    Given the system has a maximum page size of 100
    When the client requests a page size of 200
    Then the request is rejected with error "MAX_PAGE_SIZE_EXCEEDED"
    And the error message suggests "Maximum page size is 100"

  Scenario: Paginate with sorting
    Given a list of NFL teams
    When the client requests teams sorted by "winPercentage" descending with page size 10
    Then page 0 shows the top 10 teams by win percentage
    And page 1 shows teams ranked 11-20
    And pagination metadata includes sort information:
      | sort | winPercentage,desc |

  # Data Monitoring and Health

  Scenario: Monitor data integration health
    Given the system has data health monitoring enabled
    When data fetches are successful
    Then the health status is "HEALTHY"
    And the last successful sync timestamp is recorded
    When 3 consecutive data fetches fail
    Then the health status changes to "DEGRADED"
    And admins receive an alert
    When 10 consecutive fetches fail
    Then the health status changes to "CRITICAL"
    And critical alerts are sent

  Scenario: View data integration statistics
    Given the admin requests integration statistics
    Then the admin should see:
      | totalAPIRequests         | 1,523           |
      | successfulRequests       | 1,518           |
      | failedRequests           | 5               |
      | averageResponseTime      | 245ms           |
      | lastSyncTimestamp        | 2025-01-05 14:23|
      | dataFreshness            | 2 minutes       |
      | uptime                   | 99.7%           |

  # Webhook Integration (Optional)

  Scenario: Receive real-time updates via webhook
    Given the NFL data provider supports webhooks
    And the system is configured to receive webhook events
    When a game score changes
    Then the data provider sends a webhook notification
    And the system processes the update immediately
    And player scores are updated without polling delay

  Scenario: Validate webhook authenticity
    Given a webhook is received from an external source
    When the system processes the webhook
    Then the system validates the signature
    And the system verifies the sender is the NFL data provider
    And only authenticated webhooks are processed
    And unauthorized webhooks are rejected and logged
