Feature: Week Management and NFL Week Mapping
  As the system
  I want to manage game weeks and map them to NFL weeks
  So that leagues can start at any NFL week and track progress correctly

  Background:
    Given I am authenticated as an admin
    And I own a league "2025 NFL Playoffs Pool"

  # Week Entity Creation

  Scenario: Create week entities when league is activated
    Given the league has startingWeek=15 and numberOfWeeks=4
    And the league status is "DRAFT"
    When the admin activates the league
    Then 4 week entities should be created
    And week entities should have the following mapping:
      | weekId | gameWeekNumber | nflWeekNumber | status   |
      | 1      | 1              | 15            | UPCOMING |
      | 2      | 2              | 16            | UPCOMING |
      | 3      | 3              | 17            | UPCOMING |
      | 4      | 4              | 18            | UPCOMING |

  Scenario: Create weeks for mid-season league
    Given the league has startingWeek=8 and numberOfWeeks=6
    When the league is activated
    Then 6 week entities should be created
    And the week mapping should be:
      | gameWeekNumber | nflWeekNumber |
      | 1              | 8             |
      | 2              | 9             |
      | 3              | 10            |
      | 4              | 11            |
      | 5              | 12            |
      | 6              | 13            |

  Scenario: Create weeks for full-season league
    Given the league has startingWeek=1 and numberOfWeeks=17
    When the league is activated
    Then 17 week entities should be created
    And game week 1 maps to NFL week 1
    And game week 17 maps to NFL week 17

  # Week Status Management

  Scenario: Week progresses from UPCOMING to ACTIVE
    Given the league has 4 weeks created
    And all weeks have status "UPCOMING"
    And the league is activated
    When the current date reaches the start of NFL week 15
    Then week 1 (NFL week 15) status changes to "ACTIVE"
    And the pick deadline for week 1 is displayed
    And players can make selections for week 1

  Scenario: Week progresses from ACTIVE to LOCKED after deadline
    Given week 1 (NFL week 15) has status "ACTIVE"
    And the pick deadline is "2024-12-15 13:00:00 ET"
    When the deadline passes
    Then week 1 status changes to "LOCKED"
    And no further selections can be made for week 1
    And NFL games for week 15 are in progress

  Scenario: Week progresses from LOCKED to COMPLETED after games finish
    Given week 1 (NFL week 15) has status "LOCKED"
    And all NFL week 15 games have finished
    When the final game completes
    And all scores are calculated
    Then week 1 status changes to "COMPLETED"
    And week 1 scores are finalized
    And week 2 (NFL week 16) status changes to "ACTIVE"

  Scenario: Week status lifecycle
    Given a week entity exists
    Then the week progresses through statuses:
      | status     | description                           |
      | UPCOMING   | Week has not started yet              |
      | ACTIVE     | Selections open, before deadline      |
      | LOCKED     | Deadline passed, games in progress    |
      | COMPLETED  | All games finished, scores calculated |

  # Pick Deadline Management

  Scenario: Set default pick deadline for each week
    Given the league covers NFL weeks 15-18
    When week entities are created
    Then default pick deadlines are set to Sunday 1PM ET:
      | nflWeekNumber | pickDeadline          |
      | 15            | 2024-12-15 13:00:00   |
      | 16            | 2024-12-22 13:00:00   |
      | 17            | 2024-12-29 13:00:00   |
      | 18            | 2025-01-05 13:00:00   |

  Scenario: Admin configures custom pick deadlines per week
    Given week entities exist for NFL weeks 15-18
    When the admin sets custom deadlines:
      | nflWeekNumber | customDeadline        |
      | 15            | 2024-12-15 12:00:00   |
      | 16            | 2024-12-22 14:30:00   |
      | 17            | 2024-12-29 11:00:00   |
      | 18            | 2025-01-05 13:00:00   |
    Then the pick deadlines are updated accordingly
    And players are notified of the custom deadlines

  Scenario: Prevent deadline changes after week becomes active
    Given week 1 (NFL week 15) has status "ACTIVE"
    When the admin attempts to change the pick deadline
    Then the request is rejected with error "CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE"

  # Current Week Determination

  Scenario: Determine current game week based on NFL week
    Given the league starts at NFL week 15 with 4 weeks
    And today is during NFL week 16
    When the system determines the current game week
    Then the current game week should be 2
    And the current NFL week should be 16

  Scenario: Determine current week when multiple leagues are active
    Given the admin owns two leagues:
      | league          | startingWeek | numberOfWeeks | current NFL week | expected game week |
      | Playoffs League | 15           | 4             | 16               | 2                  |
      | Mid-Season      | 8            | 6             | 16               | N/A (completed)    |
    When the system determines current weeks
    Then "Playoffs League" current game week is 2
    And "Mid-Season" league status is "COMPLETED"

  # Week Query and Retrieval

  Scenario: Retrieve week by game week number
    Given the league has 4 weeks configured
    When I request week by gameWeekNumber=2
    Then I should receive the week entity
    And the week should have nflWeekNumber=16
    And the week should include:
      | pickDeadline      |
      | status            |
      | gamesScheduled    |
      | gamesCompleted    |

  Scenario: Retrieve week by NFL week number
    Given the league starts at NFL week 15
    When I request week by nflWeekNumber=17
    Then I should receive the week entity for game week 3
    And the gameWeekNumber should be 3

  Scenario: Retrieve all weeks for a league
    Given the league has 4 weeks
    When I request all weeks
    Then I should receive 4 week entities
    And they should be ordered by gameWeekNumber ascending

  Scenario: Retrieve current week
    Given the league is active
    And today is during NFL week 16
    When I request the current week
    Then I should receive the week entity for game week 2
    And the status should be "ACTIVE" or "LOCKED"

  # Week Validation

  Scenario: Validate NFL week is within league range
    Given the league covers NFL weeks 15-18
    When I query for NFL week 14
    Then the system returns null (week not in league range)
    When I query for NFL week 16
    Then the system returns the corresponding week entity

  Scenario: Prevent duplicate week creation
    Given week entities already exist for the league
    When the system attempts to create weeks again
    Then the operation is rejected with error "WEEKS_ALREADY_EXIST"

  # Week and Team Selection Integration

  Scenario: Players select teams for specific NFL weeks
    Given the league starts at NFL week 15
    And game week 1 maps to NFL week 15
    When player "john_player" selects "Kansas City Chiefs" for game week 1
    Then the TeamSelection should reference:
      | gameWeekNumber | 1  |
      | nflWeekNumber  | 15 |
      | team           | Kansas City Chiefs |

  Scenario: Team selections are validated against correct NFL week
    Given game week 2 maps to NFL week 16
    And player "jane_player" already selected "Dallas Cowboys" in game week 1 (NFL week 15)
    When player "jane_player" attempts to select "Dallas Cowboys" for game week 2 (NFL week 16)
    Then the request is rejected with error "TEAM_ALREADY_SELECTED"
    And the error specifies the team was selected in game week 1

  # Week and Scoring Integration

  Scenario: Calculate scores based on NFL week games
    Given game week 1 maps to NFL week 15
    And player "bob_player" selected "Buffalo Bills" for game week 1
    When all NFL week 15 games complete
    Then the system fetches statistics for NFL week 15
    And calculates scores for game week 1
    And player "bob_player" receives points based on "Buffalo Bills" performance in NFL week 15

  Scenario: Scores are scoped to correct NFL week
    Given the league covers NFL weeks 15-18
    And a player selected different teams each week
    When scoring is calculated
    Then each week's score is based solely on that NFL week's games
    And week 1 score uses NFL week 15 game data
    And week 2 score uses NFL week 16 game data

  # Week Metadata

  Scenario: Week includes game schedule metadata
    Given game week 1 maps to NFL week 15
    When I retrieve week 1 details
    Then the week should include:
      | totalNFLGames        | 16                    |
      | gamesCompleted       | 0                     |
      | gamesInProgress      | 0                     |
      | firstGameStart       | 2024-12-15 13:00:00   |
      | lastGameEnd          | 2024-12-15 20:30:00   |

  Scenario: Week includes player selection statistics
    Given game week 1 has 10 players in the league
    And 8 players have made selections
    When I retrieve week 1 details
    Then the week should include:
      | totalPlayers           | 10 |
      | selectionsMade         | 8  |
      | selectionsPending      | 2  |
      | mostSelectedTeam       | Kansas City Chiefs (3) |

  # Edge Cases

  Scenario: Handle league starting at NFL week 1
    Given the league has startingWeek=1 and numberOfWeeks=4
    When week entities are created
    Then game week 1 maps to NFL week 1
    And game week 4 maps to NFL week 4

  Scenario: Handle league ending at NFL week 18
    Given the league has startingWeek=15 and numberOfWeeks=4
    When week entities are created
    Then game week 4 maps to NFL week 18
    And there is no game week 5 (cannot exceed NFL week 18)

  Scenario: Handle single-week league
    Given the league has startingWeek=10 and numberOfWeeks=1
    When the league is activated
    Then only 1 week entity is created
    And game week 1 maps to NFL week 10
    And the league completes after NFL week 10

  # Week Time Tracking

  Scenario: Track week start and end times
    Given game week 1 maps to NFL week 15
    When NFL week 15 begins
    Then the week startDate is set to the first game kickoff
    When all NFL week 15 games complete
    Then the week endDate is set to the last game final

  Scenario: Calculate time remaining until deadline
    Given game week 1 pick deadline is "2024-12-15 13:00:00"
    And the current time is "2024-12-15 11:30:00"
    When I request week 1 details
    Then the timeUntilDeadline should be "1 hour 30 minutes"
    And the deadlineStatus should be "OPEN"

  Scenario: Deadline status after deadline passes
    Given game week 1 pick deadline is "2024-12-15 13:00:00"
    And the current time is "2024-12-15 13:01:00"
    When I request week 1 details
    Then the deadlineStatus should be "CLOSED"
    And selections are no longer accepted

  # Notifications

  Scenario: Send week start notifications
    Given game week 2 is about to start
    And the pick deadline is in 3 days
    When the system checks for upcoming weeks
    Then all players receive a "Week 2 starting soon" notification
    And the notification includes the pick deadline
    And the notification includes teams already selected

  Scenario: Send deadline reminder notifications
    Given game week 1 pick deadline is in 2 hours
    And 3 players have not made selections
    When the reminder job runs
    Then those 3 players receive deadline reminder notifications
    And players who have made selections do not receive reminders

  Scenario: Send week completion notifications
    Given all game week 1 games have completed
    And all scores have been calculated
    When week 1 status changes to "COMPLETED"
    Then all players receive week 1 results notification
    And the notification includes their score for the week
    And the notification includes their updated rank
