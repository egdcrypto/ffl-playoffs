@backend @priority_1 @live-scoring @real-time
Feature: Live Score Updates
  As a fantasy football playoffs application
  I want to provide real-time score updates to players
  So that they can track their playoff performance as games unfold

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league uses PPR scoring configuration
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)
    And real-time scoring is enabled for the league
    And the scoring polling service is running

  # ==================== REAL-TIME SCORE POLLING ====================

  Scenario: Poll NFL data source for live player statistics
    Given it is Wild Card weekend
    And NFL playoff games are in progress
    And the polling interval is configured for 30 seconds
    When the scoring service polls the NFL data source
    Then player statistics are retrieved for all active games
    And stats include passing, rushing, receiving, and defensive metrics
    And the poll timestamp is recorded
    And the next poll is scheduled for 30 seconds later

  Scenario: Update individual player scores during live game
    Given player "john_doe" has Patrick Mahomes at QB in their roster
    And the "Chiefs vs Dolphins" game is in progress
    And Patrick Mahomes currently has:
      | Stat              | Value |
      | Passing Yards     | 225   |
      | Passing TDs       | 2     |
      | Interceptions     | 0     |
      | Rushing Yards     | 18    |
    When the scoring service polls for live stats
    And Patrick Mahomes throws a 45-yard touchdown pass
    And the next poll returns updated stats:
      | Stat              | Value |
      | Passing Yards     | 270   |
      | Passing TDs       | 3     |
      | Interceptions     | 0     |
      | Rushing Yards     | 18    |
    Then john_doe's QB score increases from 18.0 to 22.8 points
    And john_doe's total roster score is recalculated
    And the score update timestamp is recorded

  Scenario: Aggregate scores across multiple simultaneous games
    Given player "jane_doe" has players in 3 different playoff games:
      | Position | Player          | Game Status  |
      | QB       | Josh Allen      | In Progress  |
      | RB       | Derrick Henry   | Final        |
      | WR       | Tyreek Hill     | In Progress  |
      | WR       | Ja'Marr Chase   | In Progress  |
      | TE       | Travis Kelce    | Final        |
    And completed games have final scores locked
    When the scoring service polls for live stats
    Then only in-progress game stats are updated
    And completed game stats remain unchanged
    And jane_doe's total score reflects both live and final stats
    And the breakdown shows which scores are live vs final

  Scenario: Detect game completion and finalize player scores
    Given the "Chiefs vs Dolphins" game has status "In Progress"
    And player "bob_player" has Chiefs players in their roster
    And their current live score is 85.5 points
    When the game status changes to "Final"
    And the scoring service polls for stats
    Then bob_player's score for Chiefs players is marked as "FINAL"
    And no further updates are made for those players
    And the final score is persisted to the database
    And a "GameCompletedEvent" is fired

  Scenario: Handle polling during overtime
    Given the "Bills vs Ravens" game is tied at end of regulation
    And the game enters overtime with status "In Progress (OT)"
    And player scores reflect regulation stats
    When the scoring service polls during overtime
    Then overtime statistics are included in player totals
    And no special multipliers are applied to OT stats
    And polling continues until game reaches "Final" status

  Scenario: Poll multiple games with staggered start times
    Given the Wild Card schedule has:
      | Game                | Start Time | Status      |
      | Chiefs vs Dolphins  | 1:00 PM    | In Progress |
      | Bills vs Ravens     | 4:30 PM    | Scheduled   |
      | Cowboys vs Packers  | 8:15 PM    | Scheduled   |
    When the scoring service polls at 2:30 PM
    Then only "Chiefs vs Dolphins" stats are polled
    And "Bills vs Ravens" polling starts at 4:30 PM
    And "Cowboys vs Packers" polling starts at 8:15 PM
    And resources are conserved by not polling unstarted games

  Scenario: Batch update multiple player scores efficiently
    Given 100 players have rosters with Chiefs players
    And the Chiefs game is in progress
    When the scoring service receives updated Chiefs player stats
    Then all 100 player roster scores are recalculated in batch
    And database updates are performed in a single transaction
    And leaderboard rankings are updated once after batch completes
    And WebSocket updates are sent after batch processing

  Scenario: Handle polling backpressure during high activity
    Given all 6 Wild Card games are in progress simultaneously
    And 500 users are active in the league
    When the scoring service polls all games
    Then polling completes within the 30-second interval
    And if processing takes longer than 25 seconds
    Then the next poll is delayed to prevent overlap
    And a warning is logged for performance monitoring
    And no duplicate score updates are created

  # ==================== WEBSOCKET UPDATES ====================

  Scenario: Establish WebSocket connection for live updates
    Given player "john_doe" opens the live scoring page
    When the client initiates a WebSocket connection
    Then the server establishes the connection on "/ws/live-scores"
    And the connection is authenticated with john_doe's session
    And the client subscribes to john_doe's roster updates
    And a confirmation message is sent to the client
    And the connection is added to the active connections pool

  Scenario: Push real-time score updates via WebSocket
    Given player "john_doe" has an active WebSocket connection
    And john_doe is subscribed to roster score updates
    When the scoring service updates john_doe's roster score
    Then a WebSocket message is pushed to john_doe:
      | messageType       | SCORE_UPDATE              |
      | playerId          | john_doe                  |
      | rosterScore       | 125.5                     |
      | previousScore     | 118.2                     |
      | scoreDelta        | +7.3                      |
      | updatedPositions  | ["QB", "WR1"]             |
      | timestamp         | 2025-01-11T14:32:15Z      |
    And the message is delivered within 500ms of the update

  Scenario: Broadcast detailed position-level score updates
    Given player "jane_doe" is viewing their roster breakdown
    And jane_doe has an active WebSocket connection
    When Patrick Mahomes scores a touchdown
    And the scoring service calculates new QB score
    Then a position-detail message is pushed:
      | messageType       | POSITION_UPDATE           |
      | position          | QB                        |
      | nflPlayer         | Patrick Mahomes           |
      | previousScore     | 18.0                      |
      | newScore          | 24.0                      |
      | statUpdate        | "+1 Passing TD"           |
      | gameInfo          | "KC 21 - MIA 14 (3Q 8:42)"|

  Scenario: Push leaderboard rank change notifications
    Given player "bob_player" is ranked 5th on the leaderboard
    And bob_player has an active WebSocket connection
    When bob_player's score increases
    And bob_player moves to 3rd place
    Then a rank change message is pushed:
      | messageType       | RANK_CHANGE               |
      | playerId          | bob_player                |
      | previousRank      | 5                         |
      | newRank           | 3                         |
      | rankDelta         | +2                        |
      | leaderName        | jane_doe                  |
      | pointsBehindLeader| 8.5                       |

  Scenario: Handle multiple WebSocket subscriptions per user
    Given player "john_doe" has 3 browser tabs open
    And each tab establishes a separate WebSocket connection
    When a score update occurs for john_doe
    Then the update is pushed to all 3 connections
    And message deduplication is handled on the client
    And server tracks all active connections per user

  Scenario: Reconnect WebSocket after connection drop
    Given player "jane_doe" has an active WebSocket connection
    When the connection drops due to network issues
    Then the client attempts to reconnect automatically
    And the server accepts the new connection
    And the client receives the latest score snapshot
    And any missed updates during disconnect are reconciled
    And the connection resumes normal update delivery

  Scenario: Throttle WebSocket updates during high frequency changes
    Given a game has rapid scoring activity
    And 10 score changes occur within 5 seconds
    When updates are pushed to connected clients
    Then updates are throttled to maximum 1 per second
    And only the latest cumulative state is sent
    And intermediate states are skipped to reduce bandwidth
    And clients see current totals without message flooding

  Scenario: Gracefully handle WebSocket connection limit
    Given the server has 10,000 active WebSocket connections
    And the connection limit is 12,000
    When a new client attempts to connect
    Then the connection is accepted if under limit
    And connection pool metrics are logged
    When the pool reaches 11,500 connections
    Then a warning alert is triggered
    And connection health checks are increased in frequency

  Scenario: Close WebSocket connections for inactive users
    Given player "inactive_user" has a WebSocket connection
    And no activity has occurred for 30 minutes
    When the idle timeout is reached
    Then the server sends a "CONNECTION_CLOSING" message
    And the WebSocket connection is closed
    And server resources are freed
    And the client can reconnect if they become active

  # ==================== PUSH NOTIFICATIONS ====================

  Scenario: Send push notification for significant score milestone
    Given player "john_doe" has enabled push notifications
    And john_doe's roster score was 100 points
    When john_doe's score crosses 150 points
    Then a push notification is sent:
      | title             | Score Milestone!              |
      | body              | Your roster just hit 150 points! |
      | data.currentScore | 150.3                         |
      | data.milestone    | 150                           |
    And the notification is delivered to john_doe's registered devices

  Scenario: Send push notification for rank improvement
    Given player "jane_doe" has enabled push notifications
    And jane_doe is subscribed to rank change alerts
    And jane_doe was ranked 10th
    When jane_doe moves into the top 3
    Then a push notification is sent:
      | title             | You're in the Top 3!          |
      | body              | You moved up to 3rd place     |
      | data.previousRank | 10                            |
      | data.newRank      | 3                             |

  Scenario: Send push notification when player's NFL team scores
    Given player "bob_player" has enabled game-time notifications
    And bob_player has Travis Kelce in their roster
    When Travis Kelce scores a receiving touchdown
    Then a push notification is sent:
      | title             | Kelce Touchdown!              |
      | body              | Travis Kelce TD! +6 pts       |
      | data.nflPlayer    | Travis Kelce                  |
      | data.points       | 6                             |
      | data.playType     | RECEIVING_TD                  |

  Scenario: Send push notification for matchup lead change
    Given player "john_doe" is in a playoff matchup against "jane_doe"
    And john_doe has enabled matchup notifications
    And john_doe was trailing by 5 points
    When john_doe takes the lead
    Then a push notification is sent:
      | title             | You Took the Lead!            |
      | body              | You're now ahead by 2.5 pts   |
      | data.opponent     | jane_doe                      |
      | data.yourScore    | 142.5                         |
      | data.theirScore   | 140.0                         |

  Scenario: Send push notification when matchup is decided
    Given player "alice_player" is in a matchup against "bob_player"
    And alice_player's margin of victory is now insurmountable
    And bob_player has no more players in live games
    When the system detects matchup is clinched
    Then alice_player receives notification:
      | title             | Matchup Won!                  |
      | body              | You've clinched the win vs bob_player |
    And bob_player receives notification:
      | title             | Matchup Complete              |
      | body              | alice_player has won this round |

  Scenario: Batch push notifications to prevent spam
    Given player "john_doe" would receive 5 notifications in 2 minutes
    And notification batching is enabled
    When multiple score events occur rapidly
    Then notifications are batched into a single summary:
      | title             | Scoring Update                |
      | body              | 5 scoring plays! +18.5 total pts |
      | data.playCount    | 5                             |
      | data.totalDelta   | 18.5                          |
    And individual notifications are suppressed

  Scenario: Respect user notification preferences
    Given player "jane_doe" has configured notifications:
      | preference                    | enabled |
      | Score milestones             | true    |
      | Rank changes                 | true    |
      | Individual player TDs        | false   |
      | Matchup lead changes         | true    |
      | Game completion              | true    |
    When jane_doe's QB scores a touchdown
    Then no push notification is sent for the TD
    When jane_doe's rank changes
    Then a rank change notification is sent
    And notification preferences are respected

  Scenario: Handle push notification delivery failure
    Given player "bob_player" has a registered device token
    When a push notification is sent
    And the delivery fails with "INVALID_TOKEN"
    Then the failed token is marked as invalid
    And the token is removed from bob_player's registered devices
    And an email is sent suggesting re-enabling notifications
    And future pushes skip the invalid token

  Scenario: Send quiet hours push notifications after games
    Given player "john_doe" has quiet hours set for 11 PM - 7 AM
    And a late game ends at 11:30 PM
    When john_doe's final score is calculated
    Then the notification is queued for delivery at 7 AM
    And the notification includes summary of overnight results
    And critical alerts (game cancellation) bypass quiet hours

  # ==================== LIVE LEADERBOARD REFRESH ====================

  Scenario: Update leaderboard rankings in real-time
    Given the current leaderboard standings are:
      | Rank | Player        | Score  |
      | 1    | jane_doe      | 152.3  |
      | 2    | john_doe      | 145.5  |
      | 3    | bob_player    | 138.7  |
    And games are in progress
    When bob_player's score increases to 155.0
    Then the leaderboard is immediately recalculated:
      | Rank | Player        | Score  |
      | 1    | bob_player    | 155.0  |
      | 2    | jane_doe      | 152.3  |
      | 3    | john_doe      | 145.5  |
    And all connected clients receive the updated leaderboard

  Scenario: Show live score indicators on leaderboard
    Given the leaderboard is displayed to users
    And some players have live games in progress
    When the leaderboard is rendered
    Then players with live scores show a "LIVE" indicator
    And players with finalized scores show "FINAL"
    And the indicator pulses for recent score changes
    And each player row shows time of last update

  Scenario: Display score delta since last refresh
    Given player "john_doe" is viewing the leaderboard
    And john_doe last viewed 10 minutes ago
    When john_doe refreshes the leaderboard
    Then each player shows their score change:
      | Player        | Score  | Delta  |
      | jane_doe      | 158.3  | +6.0   |
      | bob_player    | 142.5  | +3.8   |
      | john_doe      | 145.5  | +0.0   |
    And positive deltas are highlighted in green
    And negative deltas are highlighted in red

  Scenario: Animate leaderboard rank changes
    Given player "alice_player" is viewing the leaderboard
    And bob_player is ranked 5th
    When bob_player's score increases dramatically
    And bob_player moves to 2nd place
    Then the leaderboard animates the rank change
    And bob_player's row slides up the list
    And passed players slide down
    And animation completes within 500ms

  Scenario: Show projected final leaderboard
    Given it is halftime of the last game
    And the current leaderboard shows live scores
    When a user requests projected standings
    Then the system calculates projected final scores
    And shows current standings with projection:
      | Rank | Player      | Current | Projected | Proj Rank |
      | 1    | jane_doe    | 152.3   | 175.0     | 1         |
      | 2    | john_doe    | 145.5   | 180.5     | 2 (projected) |
    And projections are based on remaining player projections

  Scenario: Filter leaderboard to show matchup opponents
    Given player "john_doe" is in a matchup against "jane_doe"
    When john_doe filters to "My Matchup"
    Then only john_doe and jane_doe are displayed
    And head-to-head comparison is shown
    And live score updates continue for both players
    And current matchup status is displayed (leading/trailing)

  Scenario: Paginate live leaderboard efficiently
    Given the league has 500 players
    And the leaderboard is paginated with 25 players per page
    When a user views page 3 (ranks 51-75)
    Then only players 51-75 are rendered
    And live updates are filtered to visible players
    And total standings metadata is provided
    And page navigation is responsive

  Scenario: Persist leaderboard state for disconnected users
    Given player "john_doe" loses internet connection
    And 10 minutes of scoring activity occurs
    When john_doe reconnects
    Then the leaderboard shows current standings
    And john_doe's position is updated
    And a summary of changes is displayed
    And missed live updates are reconciled

  # ==================== ERROR HANDLING ====================

  Scenario: Handle NFL data source timeout
    Given the scoring service is polling for live stats
    When the NFL data source times out after 10 seconds
    Then the service logs the timeout error
    And the most recent cached stats are used
    And a retry is scheduled in 60 seconds
    And users see a "Data delayed" indicator
    And the system does not crash or stop polling

  Scenario: Handle NFL data source returning partial data
    Given a poll expects stats for 100 players
    When the data source returns only 75 player stats
    Then the 75 available stats are processed
    And missing players are flagged for retry
    And partial update is applied to the database
    And affected users see "Partial data" indicator
    And a warning is logged with missing player IDs

  Scenario: Handle malformed data from NFL source
    Given the scoring service polls for stats
    When the data source returns malformed JSON
    Then the service catches the parsing exception
    And the error is logged with response details
    And cached data is preserved
    And retry is attempted after 60 seconds
    And an alert is sent to operations team

  Scenario: Handle database write failure during score update
    Given a batch of 50 score updates is ready
    When the database write fails due to connection error
    Then the batch is queued for retry
    And in-memory scores are preserved
    And WebSocket updates are paused
    And retry attempts with exponential backoff
    And after 3 failures, an alert is triggered
    And users see "Saving scores..." indicator

  Scenario: Handle WebSocket server overload
    Given 15,000 WebSocket connections are active
    When the server CPU exceeds 90%
    Then update frequency is reduced to 1 per 60 seconds
    And non-critical updates are queued
    And connection health checks are reduced
    And horizontal scaling is triggered if available
    And users see "High traffic - updates may be delayed"

  Scenario: Handle scoring calculation error
    Given player "john_doe" has a roster being scored
    When a division-by-zero error occurs in calculation
    Then the error is caught and logged
    And john_doe's previous valid score is preserved
    And the affected player is flagged for manual review
    And other players' scores continue processing
    And operations team is alerted

  Scenario: Handle stale cache data
    Given cached stats are 5 minutes old
    And cache TTL is 30 seconds
    When the data source is unavailable
    And a user requests live scores
    Then stale cached data is returned with warning
    And "Last updated 5 min ago" is displayed
    And background refresh continues attempting
    And users can manually request refresh

  Scenario: Handle NFL game postponement mid-game
    Given the "Chiefs vs Dolphins" game is in progress
    And players have accumulated stats
    When the game is postponed due to weather
    Then current stats are frozen at postponement time
    And scores are marked as "SUSPENDED"
    And no further polling for that game
    And users are notified of the postponement
    And when game resumes, polling resumes

  Scenario: Recover from complete service restart
    Given the scoring service crashes
    And 5 minutes pass before restart
    When the service restarts
    Then it loads last known state from database
    And reconnects to all active games
    And resumes polling immediately
    And reconciles any missed score changes
    And WebSocket connections are re-established
    And no score data is lost

  Scenario: Handle rate limiting from NFL data source
    Given the scoring service is polling every 30 seconds
    When the data source returns HTTP 429 (Too Many Requests)
    Then the service backs off to 120-second intervals
    And logs the rate limit event
    And gradually reduces polling frequency
    When the rate limit clears
    Then polling resumes at normal 30-second intervals
    And a recovery message is logged

  Scenario: Handle inconsistent data between polls
    Given poll at T1 shows "Patrick Mahomes: 300 passing yards"
    When poll at T2 shows "Patrick Mahomes: 285 passing yards"
    And stat correction is detected
    Then the newer data is accepted as authoritative
    And affected player scores are recalculated
    And a "Stat Correction" event is logged
    And users are notified of the correction
    And historical audit trail is maintained

  Scenario: Handle duplicate score update events
    Given a network glitch causes duplicate delivery
    And the same score update is received twice
    When processing the updates
    Then the duplicate is detected via idempotency key
    And only the first update is applied
    And the duplicate is discarded
    And no double-counting occurs
    And debug log records the duplicate

  # ==================== INTEGRATION AND END-TO-END ====================

  Scenario: Full live scoring flow from NFL play to user screen
    Given player "john_doe" is watching live scores
    And john_doe has Josh Allen at QB
    And john_doe has an active WebSocket connection
    When Josh Allen throws a 25-yard touchdown pass
    And the NFL data source updates within 10 seconds
    And the scoring service polls and receives the update
    And PPR scoring calculates +5.0 points (4 TD + 1 passing yard)
    And the database is updated with new score
    And a WebSocket message is pushed to john_doe
    Then john_doe sees the updated score within 45 seconds of the play
    And the leaderboard reflects the new ranking
    And if john_doe moved up, a push notification is sent

  Scenario: Maintain data consistency across system components
    Given a score update occurs
    When the update propagates through the system
    Then the database score matches the calculated score
    And the cached score matches the database score
    And the WebSocket-pushed score matches the cache
    And the leaderboard ranking matches the score order
    And all components are eventually consistent within 5 seconds

  Scenario: Handle end-of-game scoring rush
    Given 4 games are about to end simultaneously
    And each game has 2-minute warning
    And rapid scoring occurs across all games
    When all games reach "Final" status within 10 minutes
    Then all player scores are finalized
    And final scores are persisted to database
    And matchup results are calculated
    And leaderboard is updated with final standings
    And all push notifications are delivered
    And the system remains stable under load
