Feature: Real-time Fantasy Stats via nflreadpy
  As a fantasy football player
  I want to see live fantasy points updates during NFL games
  So that I can track my roster performance in real-time

  Background:
    Given the system is configured with nflreadpy library
    And player game stats are sourced from nflreadpy's weekly data module
    And real-time polling is enabled
    And the current NFL season is 2024
    And WebSocket connections are available for real-time updates

  # =============================================================================
  # LIVE FANTASY STATS POLLING - BASIC OPERATIONS
  # =============================================================================

  Scenario: Poll live fantasy stats during active game
    Given NFL week 15 has games in progress
    And the game "KC vs BUF" has status "InProgress"
    And the polling interval is 30 seconds
    When the system queries nflreadpy for week 15 player stats
    Then the library returns stats data successfully
    And the response includes live stats for all players in week 15
    And stats are refreshed from nflreadpy's data source
    And the system polls every 30 seconds

  Scenario: Receive real-time player game stats
    Given "Patrick Mahomes" is playing in a live game
    When the system polls for live stats
    Then the response includes current game statistics:
      | PlayerID              | 14876    |
      | Name                  | Patrick Mahomes |
      | Team                  | KC       |
      | Opponent              | BUF      |
      | GameKey               | 15401    |
      | Week                  | 15       |
      | PassingYards          | 225      |
      | PassingTouchdowns     | 2        |
      | Interceptions         | 0        |
      | RushingYards          | 18       |
      | FantasyPoints         | 18.72    |
      | FantasyPointsPPR      | 18.72    |
      | Updated               | 2024-12-15T15:32:10Z |
    And stats reflect the current state of the game

  Scenario: Calculate custom PPR scores from live stats
    Given the league has custom PPR scoring rules:
      | Passing yards per point | 25  |
      | Passing TD             | 4   |
      | Interception           | -2  |
      | Rushing yards per point| 10  |
    And "Patrick Mahomes" has live stats:
      | PassingYards       | 225 |
      | PassingTouchdowns  | 2   |
      | Interceptions      | 0   |
      | RushingYards       | 18  |
    When the system calculates custom fantasy points
    Then the calculation is:
      | Stat               | Calculation | Points |
      | Passing yards      | 225/25      | 9.0    |
      | Passing TDs        | 2 × 4       | 8.0    |
      | Rushing yards      | 18/10       | 1.8    |
    And the total custom fantasy points is 18.8

  Scenario: Update roster total in real-time
    Given a player has a complete roster with 9 NFL players
    And 5 players are playing in live games
    And 4 players have completed games
    When the system polls for live stats
    Then live player stats are updated
    And completed player stats remain unchanged
    And the roster total is recalculated
    And the new total is stored in the database
    And the leaderboard is updated

  # =============================================================================
  # LIVE POLLING - CONFIGURATION AND STATE MANAGEMENT
  # =============================================================================

  Scenario: Configure polling interval based on game phase
    Given the system supports adaptive polling intervals
    When games are in different phases:
      | Game Phase            | Polling Interval |
      | Pre-game (15 min)     | 60 seconds       |
      | 1st Quarter           | 30 seconds       |
      | 2nd Quarter           | 30 seconds       |
      | Halftime              | 120 seconds      |
      | 3rd Quarter           | 30 seconds       |
      | 4th Quarter           | 20 seconds       |
      | Overtime              | 15 seconds       |
      | Final                 | Polling stops    |
    Then the system adjusts polling frequency per game phase
    And resources are optimized based on game activity

  Scenario: Polling state transitions correctly
    Given no games are currently in progress
    And polling is in "Idle" state
    When a game transitions to "InProgress"
    Then polling state changes to "Active"
    And the first poll is executed immediately
    And subsequent polls follow the configured interval
    When all games complete
    Then polling state changes to "Idle"
    And polling resources are released

  Scenario: Polling service starts up correctly
    Given the polling service is starting
    When the service initializes
    Then it loads the current week from configuration
    And identifies all games for the current week
    And determines which games are in progress
    And begins polling only for active games
    And logs "Polling service started for week 15"

  Scenario: Polling service graceful shutdown
    Given polling is active for 3 games
    When the service receives shutdown signal
    Then current poll operation completes
    And no new polls are initiated
    And all in-flight requests are allowed to complete (30 second timeout)
    And final stats are persisted to database
    And WebSocket clients are notified of service shutdown
    And logs "Polling service shutdown complete"

  Scenario: Resume polling after service restart
    Given polling was interrupted during a live game
    And the last poll timestamp was 2 minutes ago
    When the service restarts
    Then it detects the gap in polling
    And immediately polls for current stats
    And resumes normal polling interval
    And logs the polling gap for monitoring

  # =============================================================================
  # LIVE POLLING - CONCURRENT OPERATIONS
  # =============================================================================

  Scenario: Poll multiple concurrent games efficiently
    Given 8 games are in progress simultaneously
    When the polling cycle executes
    Then a single batch request is made to nflreadpy
    And stats for all 8 games are returned in one response
    And the response is parsed and distributed per game
    And database writes are batched for efficiency
    And total polling time is under 5 seconds

  Scenario: Handle overlapping poll requests
    Given a poll is in progress taking longer than expected
    When the next scheduled poll time arrives
    Then the new poll is queued (not dropped)
    And the in-progress poll completes
    And the queued poll executes immediately after
    And no poll cycles are skipped

  Scenario: Prioritize critical game polling
    Given it's a playoff week
    And some games have elimination implications
    When polling executes
    Then critical games are polled first
    And less critical games follow
    And all games receive updates within the interval

  Scenario: Isolate polling failures per game
    Given 5 games are in progress
    And game "KC vs BUF" has a data retrieval error
    When polling executes
    Then stats for the other 4 games are updated normally
    And the error for "KC vs BUF" is logged
    And a retry is scheduled for "KC vs BUF"
    And users are notified of partial data

  # =============================================================================
  # GAME STATUS DETECTION - BASIC
  # =============================================================================

  Scenario: Detect live games automatically
    Given NFL week 15 has 14 scheduled games
    And the current time is Sunday 1:05 PM ET
    When the system checks game statuses
    Then the system identifies games with status "InProgress"
    And counts 10 games currently live
    And enables real-time polling for those games
    And skips polling for completed and scheduled games

  Scenario: Detect when all games complete
    Given real-time polling is active
    And 5 games are in progress
    When the last game changes to status "Final"
    Then the system detects all games are complete
    And real-time polling is automatically stopped
    And a final stats refresh is performed
    And the system logs "Real-time polling stopped for week 15"

  Scenario: Handle game in overtime
    Given a game has status "InProgress"
    And the game is tied at the end of regulation
    When the game enters overtime
    Then the status remains "InProgress"
    And the Quarter field shows "OT"
    And real-time polling continues
    And overtime stats are included in totals

  Scenario: Handle game delayed or postponed
    Given a game has status "Scheduled" for 1:00 PM ET
    And weather delays the start
    When the game status changes to "Delayed"
    Then the system continues checking for status updates
    And polling does not start until status is "InProgress"
    And users are notified of the delay

  # =============================================================================
  # GAME STATUS DETECTION - COMPREHENSIVE STATUSES
  # =============================================================================

  Scenario: Handle all possible game statuses
    Given the system monitors game statuses
    When games transition through various statuses:
      | Status          | Polling Action           | User Notification        |
      | Scheduled       | No polling               | None                     |
      | Pregame         | Prepare for polling      | "Game starting soon"     |
      | InProgress      | Active polling           | "Game in progress"       |
      | Halftime        | Reduced polling          | "Halftime"               |
      | Delayed         | Status check only        | "Game delayed"           |
      | Suspended       | Status check only        | "Game suspended"         |
      | Postponed       | No polling               | "Game postponed"         |
      | Canceled        | No polling               | "Game canceled"          |
      | Final           | One final poll           | "Game final"             |
      | FinalOvertime   | One final poll           | "Game final (OT)"        |
    Then the system handles each status appropriately
    And users receive relevant notifications

  Scenario: Detect game status transitions in order
    Given a game with ID "15401" is scheduled
    When the game progresses through status changes:
      | Time          | Status        |
      | 12:30 PM      | Scheduled     |
      | 12:45 PM      | Pregame       |
      | 1:00 PM       | InProgress    |
      | 2:00 PM       | Halftime      |
      | 2:20 PM       | InProgress    |
      | 4:05 PM       | Final         |
    Then each transition is recorded
    And polling adjusts at each transition
    And the game timeline is logged for audit

  Scenario: Handle unexpected status transition
    Given a game has status "InProgress"
    When the status unexpectedly changes to "Scheduled"
    Then the system logs an anomaly
    And an alert is sent to administrators
    And the system continues with best-effort polling
    And the anomaly is investigated

  Scenario: Handle double-header games
    Given two games are scheduled at the same venue
    And Game 1 runs long
    When Game 2 start is delayed
    Then Game 2 status shows "Delayed"
    And estimated start time is updated
    And polling prepares for delayed start
    And users tracking Game 2 are notified

  # =============================================================================
  # GAME STATUS DETECTION - SPECIAL GAMES
  # =============================================================================

  Scenario: Handle Thursday Night Football
    Given Thursday Night Football starts at 8:15 PM ET
    When the system detects a Thursday game
    Then polling is enabled for Thursday 8:00 PM - 11:30 PM ET
    And no polling occurs during the day
    And Sunday/Monday polling schedules remain unchanged

  Scenario: Handle Monday Night Football
    Given Monday Night Football starts at 8:15 PM ET
    When the system detects a Monday game
    Then polling is enabled for Monday 8:00 PM - 11:30 PM ET
    And all other day polling is disabled for that week

  Scenario: Handle Saturday playoff games
    Given NFL playoff Saturday has 2 games
    And games are scheduled at 4:30 PM and 8:00 PM ET
    When the system detects Saturday games
    Then polling is enabled for Saturday 4:15 PM - 11:30 PM ET
    And both games are monitored concurrently
    And higher polling priority due to playoff implications

  Scenario: Handle International Series game in London
    Given a game is scheduled in London at 9:30 AM ET
    When the system detects the London game
    Then polling is enabled starting 9:15 AM ET
    And time zone differences are handled correctly
    And game completes by approximately 1:00 PM ET
    And afternoon games are monitored separately

  Scenario: Handle International Series game in Germany
    Given a game is scheduled in Germany at 9:30 AM ET
    When the system detects the Frankfurt/Munich game
    Then polling follows London game pattern
    And the game is properly categorized as international

  Scenario: Handle Christmas Day games
    Given Christmas Day has NFL games scheduled
    And games are at 1:00 PM, 4:30 PM, and 8:15 PM ET
    When the system detects Christmas games
    Then polling is enabled for all three game windows
    And holiday scheduling does not affect polling logic

  Scenario: Handle flex scheduling changes
    Given a game was originally scheduled for 4:25 PM ET
    And the NFL flexes the game to 8:20 PM ET
    When the schedule change is detected
    Then polling schedule is updated automatically
    And users are notified of the time change
    And original time slot shows "Flexed to primetime"

  # =============================================================================
  # WEBSOCKET UPDATES - BASIC PUSH
  # =============================================================================

  Scenario: Push live stats to connected clients via WebSocket
    Given a user is viewing their roster on the UI
    And the user has an active WebSocket connection
    When live stats are updated for a player in their roster
    Then the system fires a "StatsUpdatedEvent"
    And the WebSocket pushes the update to the client
    And the UI updates the player's score without page refresh
    And the roster total is recalculated on the UI

  Scenario: Broadcast leaderboard updates via WebSocket
    Given 50 users are viewing the leaderboard
    And all have active WebSocket connections
    When live stats cause leaderboard ranking changes
    Then the system broadcasts leaderboard update to all clients
    And each client updates their leaderboard view
    And rank changes are highlighted in the UI
    And updates are throttled to once every 30 seconds

  Scenario: Handle WebSocket disconnection gracefully
    Given a user's WebSocket connection drops
    When live stats are updated
    Then the update is not sent to the disconnected user
    When the user reconnects
    Then the system sends the latest stats snapshot
    And the UI syncs to current state

  # =============================================================================
  # WEBSOCKET UPDATES - CONNECTION MANAGEMENT
  # =============================================================================

  Scenario: Establish WebSocket connection on page load
    Given a user navigates to the live stats page
    When the page loads
    Then a WebSocket connection is initiated
    And the connection includes authentication token
    And the server validates the token
    And the connection is established within 3 seconds
    And the user receives initial stats snapshot

  Scenario: Handle WebSocket authentication
    Given a user attempts WebSocket connection
    When the connection request is received:
      | Auth Token   | Expected Result      |
      | Valid        | Connection accepted  |
      | Expired      | Connection rejected  |
      | Invalid      | Connection rejected  |
      | Missing      | Connection rejected  |
    Then authentication is enforced for all connections
    And rejected connections receive appropriate error codes

  Scenario: Maintain WebSocket connection with heartbeats
    Given a WebSocket connection is established
    When 30 seconds pass without activity
    Then the client sends a ping message
    And the server responds with pong
    And the connection remains active
    And connection health is logged

  Scenario: Reconnect WebSocket after network interruption
    Given a user has an active WebSocket connection
    When the network connection drops briefly
    Then the client detects the disconnection
    And the client attempts reconnection with exponential backoff:
      | Attempt | Delay         |
      | 1       | 1 second      |
      | 2       | 2 seconds     |
      | 3       | 4 seconds     |
      | 4       | 8 seconds     |
      | 5       | 16 seconds    |
    And the maximum retry count is 10
    And the user sees "Reconnecting..." indicator
    When reconnection succeeds
    Then the user receives missed updates
    And the indicator shows "Connected"

  Scenario: Handle maximum WebSocket connections per user
    Given a user has 3 active WebSocket connections (multiple tabs)
    When the user opens a 4th tab
    Then the 4th connection is allowed
    And all 4 connections receive updates
    But when the user opens a 6th connection
    Then the oldest connection is gracefully closed
    And the user is limited to 5 concurrent connections

  Scenario: Clean up stale WebSocket connections
    Given a WebSocket connection hasn't received heartbeat for 2 minutes
    When the server detects the stale connection
    Then the connection is marked as stale
    And a final ping is sent
    If no response within 10 seconds
    Then the connection is terminated
    And resources are released

  # =============================================================================
  # WEBSOCKET UPDATES - SUBSCRIPTIONS
  # =============================================================================

  Scenario: Subscribe to specific player updates
    Given a user has players in their roster:
      | PlayerID | Player Name      |
      | 14876    | Patrick Mahomes  |
      | 15487    | Christian McCaffrey |
      | 16392    | Tyreek Hill      |
    When the user establishes WebSocket connection
    Then the user is automatically subscribed to updates for:
      | PlayerID | 14876 |
      | PlayerID | 15487 |
      | PlayerID | 16392 |
    And updates for other players are not sent

  Scenario: Subscribe to leaderboard updates
    Given a user is viewing the league leaderboard
    When the user subscribes to leaderboard channel
    Then the user receives updates when:
      | Event Type          | Notification        |
      | Rank change         | Updated rankings    |
      | Score update        | Updated scores      |
      | Player eliminated   | Elimination notice  |
    And updates are batched every 30 seconds

  Scenario: Subscribe to game status updates
    Given a user's roster has players in game "KC vs BUF"
    When the user subscribes to game status
    Then the user receives notifications for:
      | Status Change     | Notification            |
      | Game starts       | "KC vs BUF has started" |
      | Quarter change    | "End of Q1: KC 7, BUF 3"|
      | Halftime          | "Halftime: KC 14, BUF 10"|
      | Game ends         | "Final: KC 31, BUF 24"  |

  Scenario: Unsubscribe from channels
    Given a user is subscribed to player updates
    When the user navigates away from live stats page
    Then the client sends unsubscribe message
    And the server removes user from subscription lists
    And no further updates are sent
    And the WebSocket connection may be closed

  Scenario: Manage subscriptions across leagues
    Given a user is a member of 3 leagues
    And each league has different rosters
    When the user views a specific league
    Then subscriptions are limited to that league's players
    When the user switches to another league
    Then old subscriptions are removed
    And new subscriptions are added for the new league

  # =============================================================================
  # WEBSOCKET UPDATES - MESSAGE HANDLING
  # =============================================================================

  Scenario: Deliver messages in order
    Given stats are updated rapidly during a game
    When multiple updates occur within 1 second:
      | Sequence | Update                    |
      | 1        | Mahomes pass +15 yards    |
      | 2        | Mahomes TD pass           |
      | 3        | Kelce reception +8 yards  |
    Then messages are delivered in sequence order
    And the client processes updates in order
    And no updates are lost or duplicated

  Scenario: Handle message delivery failure
    Given a WebSocket message fails to deliver
    When the server detects delivery failure
    Then the message is queued for retry
    And up to 3 retry attempts are made
    If all retries fail
    Then the message is dropped
    And the failure is logged
    And the user will receive next successful update

  Scenario: Compress large update payloads
    Given an update contains stats for 50 players
    When the message is prepared for delivery
    Then the payload is compressed using gzip
    And the message size is reduced by approximately 70%
    And the client decompresses the message
    And stats are processed normally

  Scenario: Throttle high-frequency updates
    Given a game has rapid stat changes
    And 20 updates occur within 10 seconds
    When updates are sent to clients
    Then updates are batched into 2 messages (every 5 seconds)
    And client receives consolidated updates
    And no individual stat change is lost

  Scenario: Handle backpressure from slow clients
    Given a client is processing messages slowly
    When the message queue exceeds 100 messages
    Then older messages are dropped (keeping newest)
    And the server logs the backpressure event
    And the client receives a "sync required" message
    And the client can request full state refresh

  # =============================================================================
  # STAT CALCULATIONS - POSITION-SPECIFIC
  # =============================================================================

  Scenario: Retrieve live fantasy stats for specific player
    Given "Christian McCaffrey" has PlayerID "15487"
    And "Christian McCaffrey" is playing in a live game
    When the system requests stats for PlayerID "15487" in week 15
    Then the response includes live running back stats:
      | RushingAttempts       | 18  |
      | RushingYards          | 98  |
      | RushingTouchdowns     | 1   |
      | Receptions            | 5   |
      | ReceivingYards        | 42  |
      | ReceivingTouchdowns   | 0   |
      | FumblesLost           | 0   |
      | TwoPointConversions   | 0   |
      | FantasyPointsPPR      | 25.0|
    And stats are updated every 30 seconds

  Scenario: Retrieve live stats for quarterback
    Given "Josh Allen" is playing in a live game
    When the system fetches live QB stats
    Then the response includes:
      | PassingYards          | 310 |
      | PassingTouchdowns     | 3   |
      | PassingCompletions    | 25  |
      | PassingAttempts       | 35  |
      | Interceptions         | 1   |
      | RushingYards          | 42  |
      | RushingTouchdowns     | 1   |
      | FumblesLost           | 0   |
      | FantasyPointsPPR      | 32.6|

  Scenario: Retrieve live stats for wide receiver
    Given "Tyreek Hill" is playing in a live game
    When the system fetches live WR stats
    Then the response includes:
      | Receptions            | 8   |
      | Targets               | 12  |
      | ReceivingYards        | 135 |
      | ReceivingTouchdowns   | 2   |
      | RushingAttempts       | 1   |
      | RushingYards          | 15  |
      | FumblesLost           | 0   |
      | FantasyPointsPPR      | 33.0|

  Scenario: Retrieve live stats for tight end
    Given "Travis Kelce" is playing in a live game
    When the system fetches live TE stats
    Then the response includes:
      | Receptions            | 6   |
      | ReceivingYards        | 78  |
      | ReceivingTouchdowns   | 1   |
      | TwoPointConversions   | 1   |
      | FumblesLost           | 0   |
      | FantasyPointsPPR      | 21.8|

  Scenario: Retrieve live stats for kicker
    Given "Harrison Butker" is playing in a live game
    When the system fetches live K stats
    Then the response includes:
      | FieldGoalsMade0_39    | 2   |
      | FieldGoalsAttempts0_39| 2   |
      | FieldGoalsMade40_49   | 1   |
      | FieldGoalsAttempts40_49| 1  |
      | FieldGoalsMade50Plus  | 0   |
      | FieldGoalsAttempts50Plus| 1 |
      | ExtraPointsMade       | 3   |
      | ExtraPointsAttempts   | 3   |
      | FantasyPoints         | 12.0|

  Scenario: Retrieve live defensive stats
    Given "Kansas City Chiefs" defense is playing
    When the system fetches live DEF stats from nflreadpy for week 15
    Then the response includes:
      | Team                  | KC  |
      | Sacks                 | 3.0 |
      | Interceptions         | 1   |
      | FumbleRecoveries      | 0   |
      | Safeties              | 0   |
      | DefensiveTouchdowns   | 1   |
      | SpecialTeamsTouchdowns| 0   |
      | PointsAllowed         | 10  |
      | YardsAllowed          | 250 |
      | FantasyPoints         | 17.0|

  # =============================================================================
  # STAT CALCULATIONS - BONUS SCORING
  # =============================================================================

  Scenario: Calculate 100-yard rushing bonus
    Given the league awards +3 points for 100+ rushing yards
    And "Derrick Henry" has live stats:
      | RushingYards | 98 |
    When "Derrick Henry" rushes for 5 more yards
    And rushing yards reach 103
    Then the 100-yard rushing bonus is applied
    And +3 points are added to fantasy total
    And the bonus is displayed separately in UI

  Scenario: Calculate 100-yard receiving bonus
    Given the league awards +3 points for 100+ receiving yards
    And "Justin Jefferson" has live stats:
      | ReceivingYards | 95 |
    When "Justin Jefferson" catches a 12-yard pass
    And receiving yards reach 107
    Then the 100-yard receiving bonus is applied
    And +3 points are added to fantasy total

  Scenario: Calculate 300-yard passing bonus
    Given the league awards +2 points for 300+ passing yards
    And "Joe Burrow" has live stats:
      | PassingYards | 285 |
    When "Joe Burrow" completes a 20-yard pass
    And passing yards reach 305
    Then the 300-yard passing bonus is applied
    And +2 points are added to fantasy total

  Scenario: Calculate 400-yard passing bonus stacking
    Given the league awards +2 points for 300+ and +3 points for 400+ passing
    And "Joe Burrow" passes for 412 yards
    When the system calculates bonuses
    Then both 300-yard (+2) and 400-yard (+3) bonuses are applied
    And total bonus is +5 points

  Scenario: Calculate long touchdown bonus
    Given the league awards +2 points for TD passes/runs of 40+ yards
    And "Jalen Hurts" throws a 52-yard TD pass
    When the system calculates the play
    Then the standard 4-point TD is awarded
    And the +2 long TD bonus is applied
    And total for the play is 6 points

  Scenario: Calculate multiple bonuses on single play
    Given the league has multiple bonus rules
    And "Ja'Marr Chase" catches a 75-yard TD reception
    And it brings his receiving total to 142 yards
    When the system calculates the play
    Then the following are applied:
      | Scoring Component        | Points |
      | 75 receiving yards       | 7.5    |
      | Reception (PPR)          | 1.0    |
      | Receiving TD             | 6.0    |
      | Long TD bonus (40+)      | 2.0    |
      | 100-yard receiving bonus | 3.0    |
    And total fantasy points increase by 19.5

  Scenario: Remove bonus when stat falls below threshold
    Given "Player X" had 101 rushing yards and the 100-yard bonus
    When a stat correction reduces rushing yards to 98
    Then the 100-yard bonus is removed
    And fantasy points are reduced by 3
    And the leaderboard is updated

  # =============================================================================
  # STAT CALCULATIONS - FRACTIONAL SCORING
  # =============================================================================

  Scenario: Calculate fractional points for rushing yards
    Given the league uses fractional scoring (1 point per 10 yards)
    And "Nick Chubb" has 87 rushing yards
    When the system calculates points
    Then rushing points are 8.7 (87 / 10)
    And the score is displayed to one decimal place

  Scenario: Calculate fractional points for receiving yards
    Given the league uses fractional scoring (1 point per 10 yards)
    And "Stefon Diggs" has 113 receiving yards
    When the system calculates points
    Then receiving points are 11.3 (113 / 10)

  Scenario: Calculate fractional points for passing yards
    Given the league uses fractional scoring (1 point per 25 yards)
    And "Patrick Mahomes" has 287 passing yards
    When the system calculates points
    Then passing points are 11.48 (287 / 25)
    And the score is displayed to two decimal places

  Scenario: Handle decimal rounding consistently
    Given multiple calculations with fractional results
    When the system aggregates scores:
      | Category       | Yards | Points (raw)   |
      | Passing        | 287   | 11.48          |
      | Rushing        | 23    | 2.3            |
    Then individual components use 2 decimal precision
    And total is rounded to 2 decimals: 13.78
    And rounding is consistent across all calculations

  Scenario: Calculate half-PPR scoring
    Given the league uses 0.5 PPR scoring
    And "Davante Adams" has 7 receptions for 85 yards
    When the system calculates points
    Then reception points are 3.5 (7 × 0.5)
    And receiving yard points are 8.5 (85 / 10)
    And total receiving points are 12.0

  # =============================================================================
  # STAT CALCULATIONS - VALIDATION AND AUDITING
  # =============================================================================

  Scenario: Validate incoming stat values
    Given live stats are received from nflreadpy
    When the system validates the data:
      | Stat            | Valid Range     | Invalid Action      |
      | PassingYards    | 0-800           | Log and cap at max  |
      | RushingYards    | -10 to 400      | Log and cap at max  |
      | Receptions      | 0-25            | Log and cap at max  |
      | Touchdowns      | 0-6 per type    | Log and cap at max  |
      | FantasyPoints   | -10 to 80       | Recalculate         |
    Then invalid values are logged for review
    And reasonable caps are applied
    And users see corrected values

  Scenario: Audit trail for score calculations
    Given "Player X" has stats updated
    When the system calculates fantasy points
    Then an audit record is created:
      | Field           | Value                 |
      | playerId        | player-123            |
      | weekId          | 15                    |
      | timestamp       | 2024-12-15T15:32:10Z  |
      | previousScore   | 12.5                  |
      | newScore        | 18.7                  |
      | statsSnapshot   | {PassingYards: 225...}|
      | calculation     | Formula applied       |
    And audit records are immutable

  Scenario: Detect anomalous score changes
    Given "Player X" has 10 fantasy points
    When stats update shows 50 fantasy points (+40 change)
    Then the system flags the anomalous change
    And the update is held for review
    And an alert is sent to administrators
    And the previous score is retained until verified

  Scenario: Reconcile stats between polls
    Given stats at poll N show 150 passing yards
    And stats at poll N+1 show 145 passing yards (decrease)
    When the system detects a stat decrease
    Then the decrease is logged as potential correction
    And the new value (145) is accepted
    And fantasy points are recalculated
    And users are notified of correction

  # =============================================================================
  # STAT CORRECTIONS AND UPDATES
  # =============================================================================

  Scenario: Handle stat correction during live game
    Given "Player X" was credited with a touchdown
    And the system recorded 6 fantasy points
    When the NFL reviews the play and reverses the call
    And nflreadpy reflects the updated stats
    Then the system polls and receives updated stats
    And the touchdown is removed (0 touchdowns)
    And fantasy points are recalculated
    And the leaderboard is updated
    And users are notified of the stat correction

  Scenario: Handle play under review
    Given a touchdown is under official review
    When the system polls for stats
    Then the play may not yet be reflected in stats
    And the system continues polling
    When the review is complete and upheld
    Then the touchdown is included in next poll
    And stats are updated accordingly

  Scenario: Handle official NFL stat corrections
    Given week 15 games have completed
    And stats are marked as "Final"
    When the NFL issues official stat corrections on Tuesday
    Then the system detects the corrections
    And affected player stats are updated
    And fantasy points are recalculated
    And leaderboard positions may change
    And affected users are notified
    And audit records show the correction

  Scenario: Handle retroactive stat changes
    Given a fumble recovery was credited to "Player A"
    And week 15 was finalized 3 days ago
    When the NFL credits the fumble to "Player B" instead
    Then the system applies the correction
    And "Player A" loses fumble recovery points
    And "Player B" gains fumble recovery points
    And both players' totals are updated
    And leaderboard is recalculated

  # =============================================================================
  # PERFORMANCE OPTIMIZATION
  # =============================================================================

  Scenario: Minimize data queries during high-traffic periods
    Given 1,000 users are viewing live stats
    And 10 games are in progress
    When the system polls nflreadpy
    Then only 1 data query is made per 30 seconds
    And the response is shared across all users
    And database is updated once
    And WebSocket pushes updates to all connected clients

  Scenario: Cache live stats with short TTL
    Given live stats were fetched 15 seconds ago
    And the cache TTL for live stats is 30 seconds
    When a user requests live stats
    Then the cached data is returned
    And no nflreadpy query is made
    And cache hit is recorded

  Scenario: Fetch only active week stats
    Given the league is configured for weeks 15-18
    And the current week is 15
    When the system polls for live stats
    Then only week 15 stats are fetched
    And weeks 16-18 are not polled (not started yet)
    And data queries are minimized

  Scenario: Optimize database writes during live games
    Given 10 games are in progress
    And 500 players have stat updates
    When the system writes to the database
    Then updates are batched into bulk operations
    And a single batch write is executed
    And database connection pool is not exhausted
    And write latency is under 500ms

  Scenario: Lazy load historical stats
    Given a user views a player's stats
    When the user scrolls to view previous weeks
    Then historical stats are loaded on demand
    And only requested weeks are fetched
    And current live stats are prioritized

  # =============================================================================
  # ERROR HANDLING DURING LIVE POLLING
  # =============================================================================

  Scenario: Handle timeout during live game
    Given real-time polling is active
    When the nflreadpy data query times out
    Then the system logs the timeout
    And returns the most recent cached stats
    And retries the request after 60 seconds
    And continues polling if retry succeeds

  Scenario: Handle partial data response
    Given nflreadpy returns stats for 50 out of 100 players
    When the system processes the response
    Then the 50 available stats are updated
    And the 50 missing stats are logged
    And a retry is scheduled for missing players
    And users see partial updates

  Scenario: Handle rate limit during live polling
    Given the system is polling every 30 seconds
    When nflreadpy encounters rate limiting or data access issues
    Then the system backs off to 60-second intervals
    And logs the rate limit event
    And reduces polling frequency temporarily
    When the rate limit clears
    Then polling resumes at 30-second intervals

  Scenario: Handle complete data source failure
    Given the nflreadpy data source is completely unavailable
    When the system attempts to poll
    Then the system enters "degraded mode"
    And users see "Live stats temporarily unavailable"
    And cached data from last successful poll is displayed
    And the system retries every 5 minutes
    And administrators are alerted
    When the data source recovers
    Then polling resumes immediately
    And users are notified "Live stats restored"

  Scenario: Handle malformed data from source
    Given nflreadpy returns data with unexpected format
    When the system attempts to parse the response
    Then parsing errors are caught
    And the malformed data is logged
    And unaffected player data is still processed
    And an alert is sent for investigation

  Scenario: Handle network partition
    Given the polling service loses connectivity to nflreadpy
    When the partition is detected
    Then the service continues with cached data
    And health checks monitor connectivity
    When connectivity is restored
    Then a full sync is performed
    And any missed updates are reconciled

  # =============================================================================
  # SCHEDULED POLLING WINDOWS
  # =============================================================================

  Scenario: Enable polling only during game windows
    Given the current time is Sunday 12:45 PM ET
    And games are scheduled to start at 1:00 PM ET
    When the system checks the schedule
    Then real-time polling is enabled for 1:00 PM - 11:30 PM ET
    And polling is disabled outside game windows
    And resources are conserved during non-game times

  Scenario: Calculate game windows dynamically
    Given week 15 has the following game schedule:
      | Day       | First Game | Last Game (approx end) |
      | Thursday  | 8:15 PM    | 11:30 PM               |
      | Sunday    | 1:00 PM    | 11:30 PM               |
      | Monday    | 8:15 PM    | 11:30 PM               |
    When the system calculates polling windows
    Then three separate windows are created
    And each window has 15-minute buffer before first game
    And each window extends 15 minutes after expected end
    And polling is only active during these windows

  Scenario: Extend polling window for overtime games
    Given the scheduled polling window ends at 11:30 PM ET
    And a game goes into overtime at 11:15 PM ET
    When the system detects overtime
    Then the polling window is automatically extended
    And polling continues until game completes
    And the window can extend up to 1:00 AM ET

  Scenario: Handle early game completions
    Given all Sunday games complete by 10:00 PM ET
    When the last game ends
    Then a final poll is executed
    And polling is stopped early
    And resources are released
    And the scheduled window for Monday remains unchanged

  # =============================================================================
  # STAT COMPARISON
  # =============================================================================

  Scenario: Compare projected stats to live stats
    Given "Patrick Mahomes" has projected fantasy points of 22.5
    And the game is in progress
    When the system fetches live stats
    And "Patrick Mahomes" has 18.8 live fantasy points
    Then the UI displays:
      | Projected | 22.5  |
      | Current   | 18.8  |
      | Diff      | -3.7  |
    And shows "Below projection" indicator

  Scenario: Compare live stats to final stats
    Given "Patrick Mahomes" had 18.8 live fantasy points
    And the game is now final
    When the system fetches final stats
    And "Patrick Mahomes" has 23.5 final fantasy points
    Then the live stats are replaced with final stats
    And the database is updated with final values
    And the leaderboard shows final scores

  Scenario: Track pace projections during game
    Given "Davante Adams" has 8 points after 1 quarter
    When the system calculates pace projection
    Then the projected final is approximately 32 points (8 × 4)
    And the projection adjusts as the game progresses
    And halftime adjusts to 2× multiplier
    And pace projections are shown to users

  Scenario: Compare performance to season average
    Given "CeeDee Lamb" averages 18.5 PPR points per game
    And "CeeDee Lamb" has 22.3 live fantasy points
    When the comparison is displayed
    Then the UI shows:
      | Season Average | 18.5   |
      | Current        | 22.3   |
      | vs Average     | +3.8   |
    And shows "Above average" indicator

  # =============================================================================
  # MULTI-WEEK LIVE STATS
  # =============================================================================

  Scenario: Fetch live stats only for current week
    Given the league covers weeks 15-18
    And the current week is 16
    When the system polls for live stats
    Then only week 16 stats are fetched
    And week 15 stats remain final (no changes)
    And weeks 17-18 have no stats yet

  Scenario: Handle overlapping games across weeks
    Given week 15 ends with Monday Night Football
    And week 16 starts with Thursday Night Football (same week)
    When both games are live simultaneously
    Then the system polls stats for both weeks
    And correctly attributes stats to the appropriate week
    And each league player sees their relevant week's stats

  Scenario: Transition from one week to the next
    Given week 15 Monday Night Football has just ended
    And week 16 begins in 3 days
    When week 15 officially closes
    Then all week 15 stats are marked as final
    And week 16 becomes the active polling week
    And rosters are prepared for week 16

  Scenario: Handle bye week players correctly
    Given "Player X" has a bye in week 15
    When live stats are polled for week 15
    Then "Player X" is not included in poll requests
    And "Player X" shows 0 points for the week
    And roster totals exclude bye week player from projections

  # =============================================================================
  # INTEGRATION WITH SCORING SERVICE
  # =============================================================================

  Scenario: Trigger scoring recalculation on live stats update
    Given live stats are updated for "Patrick Mahomes"
    When the system receives the update
    Then the ScoringService is invoked
    And custom PPR scores are calculated using league rules
    And scores are stored in the database
    And a "ScoreUpdatedEvent" is fired
    And the leaderboard is updated

  Scenario: Aggregate roster scores in real-time
    Given a player's roster has 9 NFL players
    And 3 players are in live games
    When live stats are updated
    Then each player's score is recalculated
    And the 9 scores are summed for roster total
    And the roster total is updated in real-time
    And the player's rank may change on the leaderboard

  Scenario: Apply league-specific scoring rules during calculation
    Given League A uses standard scoring
    And League B uses PPR scoring with bonuses
    When the same player stats are received
    Then League A score is calculated with standard rules
    And League B score is calculated with PPR + bonus rules
    And each league shows different point totals for same player

  Scenario: Handle scoring rule changes mid-season
    Given the league commissioner updates a scoring rule
    And games are in progress
    When the rule change is saved
    Then all scores for the current week are recalculated
    And the leaderboard is updated with new totals
    And users are notified of the scoring change

  # =============================================================================
  # EDGE CASES
  # =============================================================================

  Scenario: Handle player ejected from game
    Given "Player X" has 10 fantasy points
    When "Player X" is ejected in the 3rd quarter
    Then the player's stats freeze at the time of ejection
    And no further stats are accumulated
    And the fantasy points remain at 10
    And users are notified of the ejection

  Scenario: Handle player injured during game
    Given "Player Y" has 8 fantasy points
    When "Player Y" leaves the game with an injury
    Then the player's stats freeze
    And no further stats are accumulated unless they return
    If the player returns to the game
    Then stats resume accumulating
    And fantasy points update normally

  Scenario: Handle garbage time stats
    Given a game is a blowout with final score 45-10
    And "Backup QB" enters in the 4th quarter
    When the system fetches live stats
    Then "Backup QB" stats are included
    And counted toward fantasy points
    And not excluded as "garbage time"
    Because the system counts all official NFL stats

  Scenario: Handle player with zero stats
    Given "Player Z" is active but does not touch the ball
    When the game completes
    Then the player's stats are all zero
    And fantasy points are 0.0
    And the player is included in the weekly results with 0 points

  Scenario: Handle player traded mid-game (hypothetical)
    Given "Player X" was somehow traded during a game
    When stats are received for both teams
    Then stats are combined for the player
    And fantasy points reflect total contribution
    And a note is displayed about the unusual situation

  Scenario: Handle stat split between teams after trade
    Given "Player X" was traded between weeks
    And played for Team A in week 14 and Team B in week 15
    When week 15 stats are fetched
    Then only Team B stats are included for week 15
    And week 14 stats remain with Team A attribution

  Scenario: Handle negative fantasy points
    Given "Terrible QB" throws 5 interceptions
    And has -2 rushing yards
    And the league scoring allows negative points
    When the system calculates fantasy points
    Then the total may be negative (e.g., -8.2)
    And negative points are displayed correctly
    And roster totals account for negative contributions

  Scenario: Handle stat discrepancies between sources
    Given nflreadpy shows 250 passing yards
    And official NFL app shows 248 passing yards
    When the discrepancy is detected
    Then the system uses nflreadpy as source of truth
    And the discrepancy is logged for investigation
    And users see nflreadpy values until reconciliation

  Scenario: Handle duplicate player entries
    Given nflreadpy returns two entries for the same player
    When the system processes the response
    Then duplicates are detected by PlayerID
    And only the most recent entry is used
    And the duplicate is logged for investigation

  Scenario: Handle player with multiple positions
    Given "Taysom Hill" is listed as TE but plays QB snaps
    When stats include both TE and QB production
    Then all stats are attributed to the player
    And scoring uses the player's designated position (TE)
    And fantasy points reflect all contributions

  # =============================================================================
  # MONITORING AND OBSERVABILITY
  # =============================================================================

  Scenario: Track polling health metrics
    Given the polling service is running
    When health metrics are collected:
      | Metric                  | Description                    |
      | poll_success_rate       | % of successful polls          |
      | poll_latency_ms         | Time to complete poll          |
      | cache_hit_rate          | % of requests served from cache|
      | websocket_connections   | Active WebSocket connections   |
      | message_queue_depth     | Pending WebSocket messages     |
    Then metrics are exported to monitoring system
    And dashboards display real-time health
    And alerts trigger on threshold breaches

  Scenario: Log polling cycle details
    Given a polling cycle completes
    When the cycle is logged
    Then the log entry includes:
      | Field              | Value                    |
      | cycleId            | uuid                     |
      | startTime          | timestamp                |
      | duration_ms        | 1250                     |
      | gamesPolled        | 8                        |
      | playersUpdated     | 312                      |
      | cacheHits          | 45                       |
      | cacheMisses        | 3                        |
      | websocketsPushed   | 1523                     |
    And logs are searchable for troubleshooting

  Scenario: Alert on polling failures
    Given the system is configured with alerting rules
    When polling fails 3 consecutive times
    Then an alert is triggered:
      | Severity | Critical                       |
      | Title    | Live stats polling failing     |
      | Details  | Last 3 polls failed            |
      | Action   | Investigate immediately        |
    And the on-call engineer is notified

  Scenario: Track WebSocket connection metrics
    Given WebSocket connections are being monitored
    When metrics are collected:
      | Metric                    | Description                  |
      | connections_total         | Total active connections     |
      | connections_by_user       | Connections per user         |
      | messages_sent_total       | Total messages pushed        |
      | messages_failed           | Failed message deliveries    |
      | avg_message_latency_ms    | Time from event to delivery  |
    Then metrics enable capacity planning
    And anomalies are detected automatically
