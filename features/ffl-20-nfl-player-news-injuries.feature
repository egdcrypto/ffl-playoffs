Feature: NFL Player News and Injuries via nflreadpy
  As a fantasy football player
  I want to view real-time player news and injury updates
  So that I can make informed roster decisions

  Background:
    Given the system is configured with nflreadpy library
    And injury data is sourced from nflreadpy's injury module
    And news updates are fetched every 15 minutes

  # Player News Retrieval

  Scenario: Retrieve latest NFL news
    When the system queries nflreadpy for latest news
    Then the library returns news data successfully
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
    When the system queries nflreadpy for injury data
    Then the library returns injury data successfully
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

  Scenario: Handle timeout when fetching news
    Given the nflreadpy data fetch is slow
    When the news fetch times out after 10 seconds
    Then the system logs the timeout
    And returns cached news from last successful fetch
    And displays "Last updated: 30 minutes ago"
    And retries after 5 minutes

  Scenario: Handle missing injury data
    Given the nflreadpy response is missing InjuryStatus field
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
    And nflreadpy is queried for fresh data
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

  # Injured Reserve (IR) Designations

  Scenario: Handle Injured Reserve designation
    Given "Player A" is placed on Injured Reserve
    When the IR transaction is processed
    Then the player's status is set to "IR"
    And the player is marked as out for minimum 4 games
    And the system calculates earliest return date
    And notifies roster owners:
      """
      ⚠️ Player A has been placed on Injured Reserve.
      Earliest return: Week 12 (November 24, 2024)
      Consider moving to IR slot if available.
      """

  Scenario: Track player returning from IR
    Given "Player B" has been on IR since Week 5
    And the current week is Week 10
    When the team activates "Player B" from IR
    Then the player's status changes from "IR" to "Active"
    And the return date is recorded
    And roster owners are notified of return
    And the player becomes eligible for starting lineup

  Scenario: Handle IR-designated to return (IR-DTR)
    Given "Player C" is on IR-Designated to Return
    When the 21-day practice window opens
    Then the system tracks the 21-day window countdown
    And displays "Practice Window: Day 5 of 21"
    And alerts owner when window is about to expire
    And tracks practice participation during window

  Scenario: Season-ending IR designation
    Given "Player D" suffers a significant injury
    When the player is placed on season-ending IR
    Then the player's status is set to "IR (Season)"
    And projected points for remaining weeks are 0.0
    And the system suggests permanent replacement
    And removes player from weekly lineup considerations

  # Physically Unable to Perform (PUP) List

  Scenario: Handle PUP list designation (preseason)
    Given "Player E" is on the PUP list
    And the season has not started
    When roster owners view their team
    Then the player is marked with "PUP" indicator
    And the earliest activation date is shown
    And projected Week 1 availability is "Unlikely"

  Scenario: Track PUP list activation
    Given "Player F" has been on PUP list
    When the team activates the player from PUP
    Then the player becomes practice eligible
    And the 21-day activation window begins
    And roster owners are notified of impending return
    And practice reports are closely monitored

  # Non-Football Injury (NFI) List

  Scenario: Handle Non-Football Injury designation
    Given "Player G" is on NFI list
    When roster owners view their team
    Then the player is marked with "NFI" indicator
    And the system tracks recovery timeline
    And shows different rules than standard injury

  # Expected Return Dates

  Scenario: Display estimated return timeline
    Given "Player H" has a Grade 2 MCL sprain
    When the injury is classified
    Then the system estimates recovery time: "4-6 weeks"
    And calculates estimated return week: "Week 14"
    And displays timeline with confidence level
    And updates as new information becomes available

  Scenario: Track return date changes
    Given "Player I" was expected to return Week 12
    When the medical update indicates setback
    Then the estimated return is pushed to Week 15
    And roster owners are notified of delayed return
    And the change is logged in injury history

  Scenario: Player returns earlier than expected
    Given "Player J" was expected to return Week 14
    When the player is activated in Week 12
    Then the system updates status immediately
    And sends positive news notification
    And recommends adding back to starting lineup

  # Injury Risk Scoring

  Scenario: Calculate injury risk score for player
    Given "Player K" has:
      | Injuries last 2 seasons | 3       |
      | Games missed last year  | 5       |
      | Current age             | 29      |
      | Position                | RB      |
      | Workload last season    | Heavy   |
    When the system calculates injury risk
    Then the injury risk score is "High Risk"
    And the risk score is displayed on player profile
    And factors contributing to risk are shown

  Scenario: Display injury-prone player warning
    Given "Player L" has injury risk score > 70
    When a user considers drafting or trading for the player
    Then a warning is displayed: "⚠️ Injury-prone: 3 significant injuries in last 2 years"
    And the warning includes games missed statistics
    And shows comparison to position average

  Scenario: Recommend handcuff for injury-prone player
    Given "Player M" is a starting RB with high injury risk
    When the system analyzes roster
    Then the system recommends handcuff: "Consider rostering backup RB"
    And shows the backup's projected value if starter misses time
    And calculates "insurance value" for handcuff

  # Snap Count Tracking

  Scenario: Track snap count after injury return
    Given "Player N" returned from hamstring injury
    When Week 1 post-injury ends
    Then the system tracks snap count percentage:
      | Week       | Snap % |
      | Pre-injury | 85%    |
      | Return     | 45%    |
    And displays "Snap count limited - easing back in"
    And projects gradual increase in workload

  Scenario: Alert on concerning snap count drop
    Given "Player O" typically plays 90% of snaps
    When the latest game shows only 40% snap count
    And no injury was reported pre-game
    Then the system flags potential "unreported injury"
    And monitors news for updates
    And alerts roster owners to watch Wednesday practice report

  Scenario: Track snap count trend over multiple weeks
    Given "Player P" is returning from injury
    When snap counts over 4 weeks are:
      | Week 1 | 30% |
      | Week 2 | 50% |
      | Week 3 | 70% |
      | Week 4 | 85% |
    Then the system shows "Workload increasing - on track for full snap count"
    And projects return to full workload by Week 5
    And adjusts fantasy projections accordingly

  # Practice Squad and Injury Designations

  Scenario: Track practice squad player with injury
    Given "Player Q" is on practice squad
    When the player is designated with injury
    Then the player is not eligible for game-day activation
    And roster owners are notified if elevated previously
    And tracks separately from active roster injuries

  # Multi-Source News Aggregation

  Scenario: Aggregate news from multiple sources
    Given news about "Player R" is published by:
      | Source       | Time     |
      | ESPN         | 10:00 AM |
      | NFL.com      | 10:05 AM |
      | Team Website | 10:02 AM |
    When the system aggregates the news
    Then duplicates are detected and merged
    And the earliest source is credited
    And the most detailed report is prioritized
    And users see one consolidated news item

  Scenario: Prioritize official team sources
    Given a beat reporter tweets injury speculation
    And the official team account confirms the injury
    When both are displayed
    Then the official team source is marked as "Verified"
    And prioritized above speculation
    And the user can see both with credibility labels

  # Fantasy Impact Calculator

  Scenario: Calculate fantasy impact of injury
    Given "Player S" is ruled out for Week 10
    And the player averages 18.5 PPG
    When the system calculates fantasy impact
    Then the roster owner's projected weekly score drops by 18.5
    And the league standings projection is recalculated
    And recommendations are provided for replacement

  Scenario: Calculate injury impact on opponent's team
    Given "Player T" on opponent's team is ruled out
    When the matchup is analyzed
    Then the user sees "Opponent injury advantage: +15.2 projected points"
    And matchup win probability is recalculated
    And displayed on matchup preview

  Scenario: Calculate cumulative injury impact on season
    Given a team has multiple injured players:
      | Player | Status | Avg PPG |
      | RB1    | Out    | 18.5    |
      | WR2    | Doubtful| 12.3   |
      | TE1    | Questionable | 9.8 |
    When the system calculates cumulative impact
    Then the total potential loss is "40.6 points"
    And playoff probability impact is shown
    And season outlook is recalculated

  # Historical Injury Patterns

  Scenario: Analyze recurrence risk for soft tissue injury
    Given "Player U" has hamstring strain
    And the player had a hamstring injury 8 months ago
    When the system analyzes injury history
    Then recurrence risk is flagged as "Elevated"
    And the message shows "Same injury area - 30% higher recurrence rate"
    And recommends monitoring practice reports closely

  Scenario: Display position-specific injury patterns
    Given the user is researching RB injuries
    When viewing injury statistics
    Then the system shows position-specific data:
      | Injury Type   | RB Average | League Average |
      | Soft tissue   | 45%        | 35%            |
      | Ankle/Foot    | 25%        | 20%            |
      | Concussion    | 10%        | 12%            |
    And helps users understand position injury risks

  # Weather and Field Condition Impact

  Scenario: Alert for weather-related injury risk
    Given "Player V" is recovering from knee injury
    And the upcoming game has wet/cold conditions
    When the game conditions are analyzed
    Then the system flags "Increased risk on wet turf"
    And displays weather advisory
    And notes knee injuries are sensitive to cold

  Scenario: Track turf-related injuries
    Given a game is played on artificial turf
    And multiple players are injured during the game
    When the system tracks injury data
    Then turf-related injury statistics are updated
    And displayed for future games on that field
    And factored into injury risk assessments

  # Combine and Physical Metrics

  Scenario: Track post-injury athletic testing
    Given "Player W" is returning from ACL surgery
    When post-surgery testing shows:
      | Metric     | Pre-Injury | Post-Injury | Recovery % |
      | 40-yard    | 4.45s      | 4.52s       | 98.5%      |
      | Vertical   | 38"        | 35"         | 92.1%      |
      | Shuttle    | 4.10s      | 4.25s       | 96.5%      |
    Then the system displays "Physical recovery: 95.7%"
    And projects return to full capability timeline
    And updates fantasy projections accordingly

  # Injury Report Deadlines

  Scenario: Alert for Friday injury report deadline
    Given it is Friday at 3:30 PM ET
    And the official injury report is due at 4:00 PM ET
    When the injury report is published
    Then the system immediately processes all updates
    And sends push notifications for status changes
    And updates all affected user rosters
    And refreshes projected scores

  Scenario: Track injury report submission for all teams
    Given it is Friday at 4:30 PM ET
    When the system checks injury reports
    Then the system verifies all 32 teams have submitted
    And flags any missing reports
    And displays "All teams reported" confirmation
    And allows final roster decisions

  # Bye Week and Injury Overlap

  Scenario: Alert for post-bye injury risk
    Given "Player X" was injured before bye week
    And the bye week allowed recovery time
    When the team returns from bye
    Then the system checks for practice report updates
    And provides "Post-bye outlook" assessment
    And tracks whether extra rest helped recovery

  Scenario: Display injury and bye week combined impact
    Given a user's roster has:
      | Player | Status    | Week Status |
      | RB1    | Healthy   | BYE         |
      | WR1    | Out       | Playing     |
      | TE1    | Questionable | Playing  |
    When viewing weekly roster
    Then combined unavailability is clearly shown
    And total projected loss is calculated
    And backup recommendations account for both

  # Player Load Management

  Scenario: Detect load management vs injury
    Given "Veteran Player Y" sits out practice
    And no injury is reported
    And player is over 30 years old
    When the system analyzes the situation
    Then it flags as potential "Veteran rest day"
    And indicates player still expected to play Sunday
    And distinguishes from actual injury concern

  Scenario: Track workload and injury correlation
    Given "Player Z" had high snap count in Week 8
    When Week 9 injury report shows soft tissue injury
    Then the system correlates workload to injury
    And displays "Heavy workload may have contributed"
    And updates future workload risk assessments

  # International Games and Travel

  Scenario: Track injury impact from international game
    Given a team plays in London
    When the team returns and practices resume
    Then the system monitors for travel-related issues
    And flags any unusual injury reports post-travel
    And accounts for jet lag in practice participation

  # Notification Preferences

  Scenario: Configure injury alert preferences
    Given a user wants to customize notifications
    When the user configures preferences:
      | Alert Type           | Setting  |
      | Push for Out status  | Enabled  |
      | Push for Questionable| Enabled  |
      | Email daily digest   | Enabled  |
      | SMS for game-time    | Disabled |
    Then notifications follow user preferences
    And quiet hours are respected
    And only critical alerts bypass quiet hours

  Scenario: Escalate critical injury alerts
    Given a user's starting QB is ruled out 30 minutes before game
    And user has quiet hours enabled
    When the critical injury is detected
    Then the alert bypasses quiet hours
    And is marked as "Critical - Immediate Action Required"
    And provides backup options with one-tap swap

  # Data Validation

  Scenario Outline: Validate injury status values
    Given a player has injury status "<Status>"
    When the status is processed
    Then the status is classified as "<Classification>"
    And the projected points multiplier is <Multiplier>

    Examples:
      | Status          | Classification | Multiplier |
      | Out             | Inactive       | 0.0        |
      | Doubtful        | Likely Inactive| 0.2        |
      | Questionable    | Uncertain      | 0.7        |
      | Probable        | Likely Active  | 0.95       |
      | Healthy         | Active         | 1.0        |
      | IR              | Inactive       | 0.0        |
      | PUP             | Inactive       | 0.0        |
      | NFI             | Inactive       | 0.0        |
      | Suspended       | Inactive       | 0.0        |

  # API and Integration

  Scenario: Handle nflreadpy library update
    Given a new version of nflreadpy is released
    When the system detects API changes
    Then compatibility is verified automatically
    And any breaking changes are logged
    And fallback to previous version if needed
    And administrators are notified

  Scenario: Monitor nflreadpy rate limits
    Given the system is fetching news frequently
    When approaching rate limits
    Then fetch frequency is automatically reduced
    And critical updates are prioritized
    And rate limit status is displayed in admin dashboard
