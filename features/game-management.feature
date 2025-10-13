Feature: Game Management and Lifecycle
  As an admin
  I want to manage the complete lifecycle of a game
  So that I can control when games start, progress through weeks, and conclude

  Background:
    Given I am authenticated as an admin
    And I own a league "2025 NFL Playoffs Pool"

  # Game Status Lifecycle

  Scenario: New league starts in DRAFT status
    When the admin creates a new league
    Then the league status should be "DRAFT"
    And players cannot make team selections
    And the league configuration can be modified

  Scenario: Admin activates a league to start the game
    Given the league has the following configuration:
      | startingWeek  | 15 |
      | numberOfWeeks | 4  |
      | minPlayers    | 2  |
    And the league has 8 players
    And the league status is "DRAFT"
    When the admin activates the league
    Then the league status changes to "ACTIVE"
    And week entities are created for NFL weeks 15, 16, 17, 18
    And players can now make team selections
    And critical configuration settings are locked

  Scenario: Cannot activate league without minimum players
    Given the league has 1 player
    And the minimum players required is 2
    When the admin attempts to activate the league
    Then the request is rejected with error "INSUFFICIENT_PLAYERS"
    And the error message is "At least 2 players required to activate league"
    And the league status remains "DRAFT"

  Scenario: Cannot activate league with incomplete configuration
    Given the league has 5 players
    And the league has no scoring rules configured
    When the admin attempts to activate the league
    Then the request is rejected with error "INCOMPLETE_CONFIGURATION"
    And the league status remains "DRAFT"

  Scenario: Admin deactivates an active league
    Given the league status is "ACTIVE"
    And the current week is 2
    When the admin deactivates the league
    Then the league status changes to "INACTIVE"
    And players can no longer make new team selections
    And existing team selections are preserved
    And the admin receives a confirmation message

  Scenario: Admin reactivates an inactive league
    Given the league status is "INACTIVE"
    When the admin reactivates the league
    Then the league status changes to "ACTIVE"
    And players can make team selections again
    And the game continues from the current week

  # Week Progression

  Scenario: Game progresses through weeks automatically
    Given the league starts at NFL week 15 with 4 weeks
    And the league is active
    And today is during NFL week 15
    When the system checks the current game week
    Then the current game week should be 1
    And the current NFL week should be 15
    When NFL week 15 completes
    And today is during NFL week 16
    Then the current game week should be 2
    And the current NFL week should be 16

  Scenario: Admin manually advances to next week
    Given the league is active
    And the current game week is 1
    And all week 1 games have completed
    And all scores have been calculated
    When the admin advances to the next week
    Then the current game week changes to 2
    And week 1 selections are locked
    And week 2 selections are now open
    And players receive a notification about the new week

  Scenario: Cannot manually advance week if games are still in progress
    Given the current game week is 2
    And 3 NFL games are still in progress for week 2
    When the admin attempts to advance to week 3
    Then the request is rejected with error "WEEK_NOT_COMPLETE"
    And the error message is "Cannot advance: 3 games still in progress"

  Scenario: Cannot manually advance week if scores are not calculated
    Given the current game week is 1
    And all week 1 games have completed
    And player scores have not been calculated
    When the admin attempts to advance to week 2
    Then the request is rejected with error "SCORES_NOT_CALCULATED"

  # Game Completion

  Scenario: Game automatically completes after final week
    Given the league has 4 weeks configured
    And the current game week is 4
    And all week 4 games have completed
    And all week 4 scores have been calculated
    When the system checks for game completion
    Then the league status changes to "COMPLETED"
    And final standings are calculated
    And players receive completion notifications
    And winner is announced

  Scenario: Admin manually marks game as completed
    Given the league is active
    And all weeks have finished
    And all scores have been calculated
    When the admin marks the game as completed
    Then the league status changes to "COMPLETED"
    And the final leaderboard is locked
    And no further modifications are allowed

  Scenario: Admin archives a completed game
    Given the league status is "COMPLETED"
    And 30 days have passed since completion
    When the admin archives the league
    Then the league status changes to "ARCHIVED"
    And all game data is preserved for historical viewing
    And no modifications are allowed
    And the league is moved to archived leagues list

  Scenario: Archived game data remains accessible
    Given the league status is "ARCHIVED"
    When the admin requests the league details
    Then the admin can view all historical data:
      | Final standings         |
      | All team selections     |
      | All weekly scores       |
      | Elimination history     |
      | Configuration settings  |
    But the admin cannot modify any data

  # Week Management

  Scenario: View current week information
    Given the league is active
    And the current game week is 2 (NFL week 16)
    When the admin requests current week information
    Then the response includes:
      | gameWeek           | 2                       |
      | nflWeek            | 16                      |
      | pickDeadline       | 2024-12-22 13:00:00 ET  |
      | gamesInProgress    | 0                       |
      | gamesCompleted     | 0                       |
      | scoresCalculated   | false                   |
      | selectionsMade     | 8 of 10 players         |

  Scenario: View all weeks in the game
    Given the league starts at NFL week 15 with 4 weeks
    And the league is active
    When the admin requests all weeks
    Then the response includes 4 week records:
      | gameWeek | nflWeek | status     |
      | 1        | 15      | COMPLETED  |
      | 2        | 16      | ACTIVE     |
      | 3        | 17      | UPCOMING   |
      | 4        | 18      | UPCOMING   |

  Scenario: Lock week after deadline passes
    Given the current game week is 1
    And the pick deadline is "2024-12-15 13:00:00 ET"
    When the deadline passes
    Then week 1 selections are locked
    And players cannot modify week 1 picks
    And the week status changes to "LOCKED"

  # Mid-Game Admin Actions

  Scenario: Admin pauses an active game
    Given the league is active
    And the current game week is 2
    When the admin pauses the league
    Then the league status changes to "PAUSED"
    And all deadlines are suspended
    And players cannot make selections
    And scoring calculations are suspended

  Scenario: Admin resumes a paused game
    Given the league status is "PAUSED"
    When the admin resumes the league
    Then the league status changes to "ACTIVE"
    And deadlines are recalculated based on current date
    And players can make selections again

  Scenario: Admin cancels a game
    Given the league is active
    And the current game week is 1
    When the admin cancels the league with reason "Insufficient participation"
    Then the league status changes to "CANCELLED"
    And players are notified of cancellation with reason
    And all selections are preserved for reference
    And no further actions are allowed

  # Game Statistics and Health

  Scenario: View game health status
    Given the league is active
    When the admin requests game health status
    Then the response includes:
      | totalPlayers              | 10                 |
      | activeSelections          | 9 of 10            |
      | missedSelections          | 1                  |
      | currentWeek               | 2                  |
      | weeksRemaining            | 2                  |
      | dataIntegrationStatus     | HEALTHY            |
      | lastScoreCalculation      | 2024-12-15 23:45   |

  Scenario: Admin receives alert for missing selections
    Given the league is active
    And the current week deadline is in 2 hours
    And 3 players have not made selections
    When the system checks selection status
    Then the admin receives an alert notification
    And the alert lists the 3 players without selections
    And the alert includes time remaining until deadline

  Scenario: Admin receives alert for data integration issues
    Given the league is active
    And NFL data sync has failed for 30 minutes
    When the system checks data integration health
    Then the admin receives a critical alert
    And the alert describes the integration issue
    And the alert recommends actions

  # Multi-League Management

  Scenario: Admin manages multiple concurrent leagues
    Given the admin owns the following leagues:
      | name          | status    | currentWeek | startingNFLWeek |
      | Playoffs 2025 | ACTIVE    | 2           | 15              |
      | Mid-Season    | ACTIVE    | 5           | 8               |
      | Full Season   | DRAFT     | N/A         | 1               |
    When the admin requests their leagues dashboard
    Then the response includes 3 leagues
    And each league shows independent status and progress
    And the admin can switch between league contexts

  Scenario: Admin clones a completed game
    Given the admin owns a completed league "2024 Playoffs"
    And "2024 Playoffs" has final standings and history
    When the admin creates a new league "2025 Playoffs"
    And selects to clone from "2024 Playoffs"
    Then the new league inherits configuration settings
    But the new league starts fresh with:
      | status: DRAFT         |
      | no players            |
      | no team selections    |
      | no scores             |
    And the old league data remains unchanged

  # Edge Cases

  Scenario: Handle NFL season boundary
    Given the league starts at NFL week 17 with 2 weeks
    And the league is active
    When the league reaches NFL week 18 (final week)
    Then the game continues normally for week 18
    And after week 18 completes, the game ends
    And the league cannot extend beyond week 18

  Scenario: Handle league created but never activated
    Given the admin created a league 90 days ago
    And the league status is still "DRAFT"
    And no players have joined
    When the system checks for stale leagues
    Then the league is flagged for admin review
    And the admin receives a notification
    And the admin can choose to delete or activate

  Scenario: Admin deletes a draft league
    Given the league status is "DRAFT"
    And the league has 0 players
    When the admin deletes the league
    Then the league is permanently removed
    And the admin's league list is updated

  Scenario: Cannot delete active or completed league
    Given the league status is "ACTIVE"
    When the admin attempts to delete the league
    Then the request is rejected with error "CANNOT_DELETE_ACTIVE_LEAGUE"
    And the error suggests deactivating or completing first
