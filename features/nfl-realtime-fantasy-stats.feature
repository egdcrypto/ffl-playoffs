Feature: Real-time Fantasy Stats via SportsData.io Fantasy API
  As a fantasy football player
  I want to see live fantasy points updates during NFL games
  So that I can track my roster performance in real-time

  Background:
    Given the system is configured with SportsData.io Fantasy API
    And the API endpoint is "/stats/json/PlayerGameStatsByWeek/{season}/{week}"
    And real-time polling is enabled
    And the current NFL season is 2024

  # Live Fantasy Stats Polling

  Scenario: Poll live fantasy stats during active game
    Given NFL week 15 has games in progress
    And the game "KC vs BUF" has status "InProgress"
    And the polling interval is 30 seconds
    When the system polls GET "/stats/json/PlayerGameStatsByWeek/2024/15"
    Then the API returns HTTP 200 OK
    And the response includes live stats for all players in week 15
    And stats are updated every 20-30 seconds by SportsData.io
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

  # Game Status Detection

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

  # WebSocket Updates to UI

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

  # Stats Breakdown by Player

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
    When the system fetches live DEF stats via "/stats/json/FantasyDefenseByGame/2024/15"
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

  # Stat Corrections and Updates

  Scenario: Handle stat correction during live game
    Given "Player X" was credited with a touchdown
    And the system recorded 6 fantasy points
    When the NFL reviews the play and reverses the call
    And SportsData.io updates the stats
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

  # Performance Optimization

  Scenario: Minimize API calls during high-traffic periods
    Given 1,000 users are viewing live stats
    And 10 games are in progress
    When the system polls SportsData.io
    Then only 1 API call is made per 30 seconds
    And the response is shared across all users
    And database is updated once
    And WebSocket pushes updates to all connected clients

  Scenario: Cache live stats with short TTL
    Given live stats were fetched 15 seconds ago
    And the cache TTL for live stats is 30 seconds
    When a user requests live stats
    Then the cached data is returned
    And no API call is made
    And cache hit is recorded

  Scenario: Fetch only active week stats
    Given the league is configured for weeks 15-18
    And the current week is 15
    When the system polls for live stats
    Then only week 15 stats are fetched
    And weeks 16-18 are not polled (not started yet)
    And API calls are minimized

  # Error Handling During Live Polling

  Scenario: Handle API timeout during live game
    Given real-time polling is active
    When the SportsData.io API times out
    Then the system logs the timeout
    And returns the most recent cached stats
    And retries the request after 60 seconds
    And continues polling if retry succeeds

  Scenario: Handle partial API response
    Given the API returns stats for 50 out of 100 players
    When the system processes the response
    Then the 50 available stats are updated
    And the 50 missing stats are logged
    And a retry is scheduled for missing players
    And users see partial updates

  Scenario: Handle API rate limit during live polling
    Given the system is polling every 30 seconds
    When the API returns HTTP 429 Too Many Requests
    Then the system backs off to 60-second intervals
    And logs the rate limit event
    And reduces polling frequency temporarily
    When the rate limit clears
    Then polling resumes at 30-second intervals

  # Scheduled Polling Windows

  Scenario: Enable polling only during game windows
    Given the current time is Sunday 12:45 PM ET
    And games are scheduled to start at 1:00 PM ET
    When the system checks the schedule
    Then real-time polling is enabled for 1:00 PM - 11:30 PM ET
    And polling is disabled outside game windows
    And resources are conserved during non-game times

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

  # Stat Comparison (Pre-game vs Live vs Final)

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

  # Multi-week Live Stats

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

  # Integration with Scoring Service

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

  # Edge Cases

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
