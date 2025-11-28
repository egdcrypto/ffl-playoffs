Feature: NFL Player News and Injuries via SportsData.io
  As a fantasy football player
  I want to view real-time player news and injury updates
  So that I can make informed roster decisions

  Background:
    Given the system is configured with SportsData.io API
    And the API endpoint is "/stats/json/News"
    And news updates are fetched every 15 minutes

  # Player News Retrieval

  Scenario: Retrieve latest NFL news
    When the system requests GET "/stats/json/News"
    Then the API returns HTTP 200 OK
    And the response includes latest NFL news items
    And each news item contains:
      | NewsID         |
      | Source         |
      | Updated        |
      | TimeAgo        |
      | Title          |
      | Content        |
      | Url            |
      | PlayerID       |
      | Team           |
      | Categories     |

  Scenario: Retrieve news for specific player
    Given "Patrick Mahomes" has PlayerID "14876"
    When the system requests news for PlayerID "14876"
    Then the API returns all news related to Patrick Mahomes
    And news is sorted by most recent first
    And includes sources like ESPN, NFL.com, team websites

  Scenario: Retrieve news for specific team
    Given the system needs news for "Kansas City Chiefs"
    When the system requests news for Team "KC"
    Then the API returns all KC team news
    And includes player-specific news for KC players
    And includes team-level news (coaching, trades, etc.)

  # Injury Status Updates

  Scenario: Retrieve current injury report
    When the system requests GET "/stats/json/Injuries"
    Then the API returns HTTP 200 OK
    And the response includes all current injuries
    And each injury record contains:
      | PlayerID           |
      | Name               |
      | Position           |
      | Team               |
      | Number             |
      | InjuryStatus       |
      | InjuryBodyPart     |
      | InjuryStartDate    |
      | InjuryNotes        |
      | Updated            |

  Scenario: Check injury status for specific player
    Given "Saquon Barkley" has PlayerID "19800"
    When the system checks injury status for PlayerID "19800"
    Then the response includes current injury information:
      | InjuryStatus    | Questionable |
      | InjuryBodyPart  | Ankle        |
      | InjuryStartDate | 2024-12-10   |
      | InjuryNotes     | Limited in practice Wednesday |
    And the system stores this in the database
    And users with Saquon Barkley in roster are notified

  Scenario: Track injury status changes
    Given "Player X" was "Healthy" yesterday
    When the injury report is updated
    And "Player X" is now "Questionable"
    Then the system detects the status change
    And creates a PlayerInjuryStatusChangedEvent
    And notifies all users with Player X in their roster
    And updates the player's status in the database

  # Injury Status Levels

  Scenario: Handle "Out" injury designation
    Given "Player A" has InjuryStatus "Out"
    When roster owners view their lineup
    Then Player A is marked with a red "OUT" indicator
    And projected points show 0.0
    And system suggests replacing Player A

  Scenario: Handle "Doubtful" injury designation
    Given "Player B" has InjuryStatus "Doubtful"
    When roster owners view their lineup
    Then Player B is marked with an orange "D" indicator
    And projected points are reduced by 80%
    And system warns about high risk

  Scenario: Handle "Questionable" injury designation
    Given "Player C" has InjuryStatus "Questionable"
    When roster owners view their lineup
    Then Player C is marked with a yellow "Q" indicator
    And projected points are reduced by 30%
    And system provides latest practice updates

  Scenario: Handle "Probable" or "Healthy" status
    Given "Player D" has InjuryStatus "Healthy"
    When roster owners view their lineup
    Then no injury indicator is shown
    And projected points are full value
    And player is expected to play

  # Practice Participation Tracking

  Scenario: Track player practice participation
    Given "Player X" is listed as Questionable
    When practice reports are updated
    Then the system tracks participation:
      | Wednesday  | Limited        |
      | Thursday   | Limited        |
      | Friday     | Full           |
    And shows positive trend toward playing
    And injury probability is recalculated

  Scenario: Track non-participation in practice
    Given "Player Y" is listed as Questionable
    When practice reports show:
      | Wednesday  | Did not practice |
      | Thursday   | Did not practice |
      | Friday     | Did not practice |
    Then the system flags high risk of missing game
    And notifies roster owners to find replacement
    And reduces projected points to 0.0

  # Game-Time Decisions

  Scenario: Handle game-time decision status
    Given "Player Z" has InjuryStatus "Questionable"
    And the game starts in 2 hours
    And no updated status has been provided
    Then the system marks as "Game-Time Decision"
    And notifies roster owners to monitor closely
    And suggests having a backup plan

  Scenario: Update player status just before game
    Given "Player Z" was "Questionable" 1 hour ago
    And the game starts in 15 minutes
    When the injury report is updated to "Active"
    Then the system immediately updates the status
    And sends push notifications to roster owners
    And removes injury designation
    And restores full projected points

  Scenario: Player ruled out just before game
    Given "Player Z" was "Questionable" 1 hour ago
    And the game starts in 15 minutes
    When the injury report is updated to "Out"
    Then the system immediately updates the status
    And sends urgent push notifications
    And sets projected points to 0.0
    And displays "INACTIVE" for the game

  # News Categories and Filtering

  Scenario: Filter news by category
    When the user requests news with category "Injury"
    Then only injury-related news is returned
    And excludes other categories (Transactions, Rumors, etc.)

  Scenario: Filter news by recency
    When the user requests news from the last 24 hours
    Then only news items with Updated within 24 hours are returned
    And older news is excluded

  Scenario: Filter news by relevance to user's roster
    Given a user has 9 players in their roster
    When the user requests "My Players News"
    Then only news for the user's 9 players is returned
    And sorted by recency
    And injury news is prioritized

  # Notifications and Alerts

  Scenario: Send injury alert to affected users
    Given 50 users have "Christian McCaffrey" in their roster
    When Christian McCaffrey's status changes to "Out"
    Then the system identifies all 50 affected users
    And sends push notifications to each
    And sends email alerts
    And displays alert banner in UI

  Scenario: Send breaking news alert
    Given "Star Player" has major news (trade, retirement, etc.)
    When the news is published
    And the system detects high-impact keywords
    Then push notifications are sent to all users
    And news is highlighted on home page
    And users can click to read full details

  Scenario: Aggregate daily injury report
    Given it is 10:00 AM ET on a weekday
    When the system compiles the daily injury report
    Then all status updates from the last 24 hours are aggregated
    And sent to all active users via email digest
    And includes practice participation updates
    And lists all status changes (Out, Questionable, etc.)

  # Integration with Roster Management

  Scenario: Show injury status in roster view
    Given a user views their roster
    When the roster is loaded
    Then each player's injury status is displayed
    And injury icons are color-coded:
      | Out        | Red    |
      | Doubtful   | Orange |
      | Questionable| Yellow|
      | Healthy    | Green  |
    And users can click for detailed injury information

  Scenario: Warn when starting injured player
    Given a user has "Player X" with status "Out"
    When the roster is locked
    And Player X is in the starting lineup
    Then the system displays warning:
      "Warning: Player X is OUT and will score 0 points"
    And suggests moving to bench if possible
    And requires user confirmation to proceed

  Scenario: Suggest replacement for injured player
    Given "Player A" at RB position is "Out"
    And the user has a healthy RB on the bench
    When the user views their roster
    Then the system suggests: "Move Bench RB to starter"
    And provides one-click swap functionality
    And shows projected point difference

  # Historical Injury Data

  Scenario: View player injury history
    Given the user views "Player X" profile
    When the user clicks "Injury History"
    Then the system displays past injuries:
      | Date       | Injury      | Status | Games Missed |
      | 2024-11-15 | Hamstring   | Out    | 2            |
      | 2024-09-20 | Ankle       | Questionable | 0       |
      | 2023-12-03 | Concussion  | Out    | 1            |
    And helps assess injury risk

  # Injury Impact on Scoring

  Scenario: Player injured during game receives partial points
    Given "Player Y" has 12 fantasy points
    When Player Y is injured in the 3rd quarter
    And does not return to the game
    Then the player's fantasy points remain at 12
    And no further points are earned
    And injury status is updated to "Injured"

  Scenario: Player returns from injury same game
    Given "Player Z" left game with injury
    And had 8 fantasy points before leaving
    When Player Z returns in the 4th quarter
    And scores an additional 5 fantasy points
    Then the total fantasy points are 13
    And injury status is updated to "Returned"

  # Error Handling

  Scenario: Handle API timeout when fetching news
    Given the SportsData.io API is slow
    When the news fetch times out after 10 seconds
    Then the system logs the timeout
    And returns cached news from last successful fetch
    And displays "Last updated: 30 minutes ago"
    And retries after 5 minutes

  Scenario: Handle missing injury data
    Given the API response is missing InjuryStatus field
    When the system processes the response
    Then the system defaults to "Unknown"
    And logs the missing data
    And does not overwrite existing status
    And retries fetch after 15 minutes

  Scenario: Handle conflicting injury reports
    Given Source A reports Player X as "Out"
    And Source B reports Player X as "Questionable"
    When the system receives both reports
    Then the system uses the official NFL injury report as source of truth
    And logs the conflict for review
    And displays the official designation

  # Caching Strategy for News

  Scenario: Cache news with short TTL
    Given news was fetched 10 minutes ago
    And the cache TTL is 15 minutes
    When a user requests news
    Then the cached news is returned
    And no API call is made
    And cache hit is recorded

  Scenario: Refresh news cache on TTL expiration
    Given news was cached 16 minutes ago
    And the cache TTL is 15 minutes
    When a user requests news
    Then the cache is expired
    And a new API call is made
    And the cache is updated with fresh news
    And the updated timestamp is shown

  Scenario: Invalidate cache on breaking news
    Given news is cached with 10 minutes remaining
    When a high-impact news event occurs (major injury, trade)
    Then the cache is immediately invalidated
    And fresh news is fetched
    And all users receive push notifications
    And the cache TTL is reset

  # Scheduled News Fetches

  Scenario: Fetch news every 15 minutes during season
    Given the NFL season is active
    When the scheduled job runs
    Then news is fetched every 15 minutes
    And new items are identified
    And relevant users are notified
    And the database is updated

  Scenario: Fetch injury reports daily at 4 PM ET
    Given it is Wednesday during the season
    When the time is 4:00 PM ET
    Then the official injury report is published by NFL
    And the system fetches the updated report
    And processes all status changes
    And sends notifications to affected users
    And updates all player records

  Scenario: Reduce fetch frequency in off-season
    Given the NFL season is over
    When the system checks the season status
    Then news fetch frequency is reduced to once per day
    And injury fetches are paused
    And resources are conserved

  # Multi-language News Support

  Scenario: Retrieve news in user's preferred language
    Given a user has language preference "Spanish"
    When the user requests news
    Then the system fetches news in Spanish if available
    And falls back to English if Spanish not available
    And displays language indicator

  # News Sentiment Analysis

  Scenario: Analyze news sentiment for player outlook
    Given news item states "Player X cleared for full practice"
    When the system analyzes the sentiment
    Then the sentiment is classified as "Positive"
    And the player outlook is "Improving"
    And displayed with green upward arrow

  Scenario: Detect negative news sentiment
    Given news item states "Player Y re-injures hamstring"
    When the system analyzes the sentiment
    Then the sentiment is classified as "Negative"
    And the player outlook is "Declining"
    And displayed with red downward arrow

  # Beat Reporter Tracking

  Scenario: Track credible beat reporters
    Given beat reporter "Adam Schefter" posts injury update
    When the system fetches news from verified sources
    Then the update is marked as "High Credibility"
    And prioritized in news feed
    And tagged with reporter name

  Scenario: Filter out unreliable sources
    Given a news source has low credibility score
    When the system fetches news
    Then news from unreliable sources is filtered out
    And only verified sources are displayed
    And users see accurate information
