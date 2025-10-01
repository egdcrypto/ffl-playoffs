# ⚠️ DEPRECATED - LEGACY FEATURE FILE ⚠️
# This feature file represents the OLD team-based survivor pool model.
# The FFL Playoffs application now uses a ROSTER-BASED fantasy football model.
# See player-roster-selection.feature and roster-management.feature for current specifications.

Feature: Team Selection (DEPRECATED - LEGACY MODEL)
  As a player
  I want to select NFL teams for each week
  So that I can compete in the 4-week playoff game

  NOTE: This is the LEGACY team-based survivor pool model.
  Current model uses individual NFL player roster selection.

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the game has 4 weeks configured
    And I am authenticated as player "john_player"

  Scenario: Player successfully selects a team for the current week
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 10:00:00"
    And the team "Kansas City Chiefs" is available
    When I select team "Kansas City Chiefs" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Kansas City Chiefs"
    And the team "Kansas City Chiefs" should be marked as used by me

  Scenario: Player cannot select the same team twice across their own weeks
    Given I selected "Dallas Cowboys" for week 1
    And it is now week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 10:00:00"
    And other players may have also selected "Dallas Cowboys" for their weeks
    When I attempt to select team "Dallas Cowboys" for week 2
    Then the selection should fail
    And I should receive error "You have already selected this team in week 1"
    And my pick for week 2 should remain unset
    But other players can still select "Dallas Cowboys" for any of their weeks

  Scenario: Player updates pick before deadline
    Given it is week 1 of the game
    And I selected "Buffalo Bills" for week 1
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:00:00"
    When I update my week 1 pick to "San Francisco 49ers"
    Then my selection should be updated successfully
    And my pick for week 1 should be "San Francisco 49ers"
    And the team "Buffalo Bills" should no longer be marked as used by me

  Scenario: Player cannot make selection after deadline
    Given it is week 2 of the game
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 13:01:00"
    When I attempt to select team "Miami Dolphins" for week 2
    Then the selection should fail
    And I should receive error "Pick deadline has passed for week 2"

  Scenario: Player cannot modify pick after deadline
    Given it is week 1 of the game
    And I selected "Philadelphia Eagles" for week 1
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 13:30:00"
    When I attempt to update my week 1 pick to "Green Bay Packers"
    Then the update should fail
    And I should receive error "Pick deadline has passed for week 1"
    And my pick for week 1 should remain "Philadelphia Eagles"

  Scenario: Player views all NFL teams for selection
    Given it is week 2 of the game
    And I have selected the following teams:
      | week | team              |
      | 1    | Dallas Cowboys    |
    When I request teams for week 2 selection
    Then I should see all 32 NFL teams
    And "Dallas Cowboys" should be marked as "already used by me"
    And other teams should be marked as "available"
    And all teams should display their current season record
    And all teams should display their upcoming opponent
    And teams used by other players should still be selectable

  Scenario: Player makes selections for all 4 weeks
    Given the game allows advance picks
    And no deadlines have passed
    When I select the following teams:
      | week | team                  |
      | 1    | Kansas City Chiefs    |
      | 2    | Buffalo Bills         |
      | 3    | San Francisco 49ers   |
      | 4    | Dallas Cowboys        |
    Then all 4 selections should be saved successfully
    And I should have 4 teams marked as used

  Scenario: Player cannot select teams for future weeks if advance picks are disabled
    Given it is week 1 of the game
    And the game does not allow advance picks
    When I attempt to select team "Denver Broncos" for week 3
    Then the selection should fail
    And I should receive error "Cannot make selections for future weeks"

  Scenario: Player receives reminder before pick deadline
    Given it is week 2 of the game
    And I have not made a selection for week 2
    And the pick deadline for week 2 is "2025-10-12 13:00:00"
    And the current time is "2025-10-12 11:00:00"
    And reminder notifications are enabled
    Then I should receive a reminder notification
    And the reminder should indicate "2 hours remaining to make your pick"

  Scenario: Player with eliminated team can still pick for remaining weeks
    Given it is week 3 of the game
    And I selected "Tampa Bay Buccaneers" for week 1
    And the "Tampa Bay Buccaneers" lost their game in week 1
    And the "Tampa Bay Buccaneers" are eliminated for me
    When I select team "Baltimore Ravens" for week 3
    Then my selection should be saved successfully
    And my pick for week 3 should be "Baltimore Ravens"

  Scenario: Player views their selection history
    Given I have made the following selections:
      | week | team                  | status      |
      | 1    | Kansas City Chiefs    | WON         |
      | 2    | Buffalo Bills         | LOST        |
      | 3    | San Francisco 49ers   | PENDING     |
    When I request my team selection history
    Then I should receive 3 selections
    And each selection should show the team name, week, and game outcome

  Scenario: Player cannot select a team that doesn't exist
    Given it is week 1 of the game
    When I attempt to select team "Invalid Team Name" for week 1
    Then the selection should fail
    And I should receive error "Team not found"

  Scenario: Player cannot make selection for completed week
    Given week 1 is completed
    And I did not make a selection for week 1
    When I attempt to select team "Atlanta Falcons" for week 1
    Then the selection should fail
    And I should receive error "Cannot make selection for completed week"

  Scenario: Player who misses a week deadline gets zero points
    Given it is week 2 of the game
    And I did not make a selection for week 1
    And week 1 is now completed
    Then my score for week 1 should be 0
    And I should be able to make selections for remaining weeks

  Scenario Outline: Team selection validation across 4 weeks
    Given the game has 4 weeks configured
    And I have made the following selections:
      | week | team   |
      | 1    | <team1> |
      | 2    | <team2> |
      | 3    | <team3> |
    When I attempt to select team "<team4>" for week 4
    Then the selection should <result>
    And I should receive <feedback>

    Examples:
      | team1            | team2             | team3               | team4               | result  | feedback                                        |
      | Chiefs           | Bills             | 49ers               | Cowboys             | succeed | selection saved successfully                    |
      | Chiefs           | Bills             | 49ers               | Chiefs              | fail    | error "Team already selected in week 1"         |
      | Chiefs           | Bills             | 49ers               | Bills               | fail    | error "Team already selected in week 2"         |
      | Chiefs           | Bills             | 49ers               | 49ers               | fail    | error "Team already selected in week 3"         |

  Scenario: Multiple players can independently select the same team
    Given player "player1" selected "Dallas Cowboys" for week 1
    And player "player2" selected "Dallas Cowboys" for week 1
    And player "player3" selected "Dallas Cowboys" for week 1
    And I am player "player4"
    And it is week 1 of the game
    When I select team "Dallas Cowboys" for week 1
    Then my selection should be saved successfully
    And my pick for week 1 should be "Dallas Cowboys"
    And all 4 players have independently selected "Dallas Cowboys"
    And there is no limit on how many players can pick the same team

  Scenario: NOT a draft system - all teams always available to all players
    Given the league has 10 players
    And it is week 2 of the game
    And 5 players have already selected "Kansas City Chiefs" for week 2
    When I view the available teams
    Then I should see all 32 NFL teams listed
    And "Kansas City Chiefs" should be marked as "available"
    And I should be able to select "Kansas City Chiefs" even though 5 others picked it
    And there is NO concept of team availability based on other players' picks
    And each player makes independent selections without affecting others

  Scenario: Player views pick deadline countdown
    Given it is week 1 of the game
    And the pick deadline for week 1 is "2025-10-05 13:00:00"
    And the current time is "2025-10-05 11:30:00"
    When I request the current week information
    Then I should receive deadline information
    And the time remaining should be "1 hour 30 minutes"
    And the deadline status should be "OPEN"

  # Pagination for Team Selection Display

  Scenario: Paginate NFL team list with default page size
    Given there are 32 NFL teams in the system
    And it is week 1 of the game
    When I request the available teams without pagination parameters
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
    And it is week 2 of the game
    When I request available teams with page 1 and size 10
    Then the response includes teams 11-20
    And the pagination metadata shows:
      | page           | 1              |
      | size           | 10             |
      | totalElements  | 32             |
      | totalPages     | 4              |
      | hasNext        | true           |
      | hasPrevious    | true           |

  Scenario: Paginate teams with custom page size
    Given there are 32 NFL teams in the system
    And it is week 1 of the game
    When I request available teams with page 0 and size 50
    Then the response includes all 32 teams
    And the pagination metadata shows:
      | page           | 0              |
      | size           | 50             |
      | totalElements  | 32             |
      | totalPages     | 1              |
      | hasNext        | false          |
      | hasPrevious    | false          |

  Scenario: Paginate team selection history
    Given I have made selections for 15 different weeks across multiple leagues
    When I request my team selection history with page size 10
    Then page 0 contains selections 1-10
    And page 1 contains selections 11-15
    And each response includes total count of 15

  Scenario: Paginate teams by division
    Given I am viewing teams for week 1
    And I filter by division "AFC East"
    When I request teams with page 0 and size 10
    Then the response includes AFC East teams only
    And the pagination metadata reflects filtered total:
      | totalElements  | 4 (AFC East teams) |
      | totalPages     | 1                  |

  Scenario: Paginate teams by conference
    Given I am viewing teams for week 2
    And I filter by conference "NFC"
    When I request teams with page 0 and size 10
    Then the response includes 10 NFC teams
    And the pagination metadata reflects filtered total:
      | totalElements  | 16 (NFC teams) |
      | totalPages     | 2              |

  Scenario: Paginate available vs used teams
    Given I am in week 3 of the game
    And I have already selected 8 teams in previous weeks
    And I filter by "available only"
    When I request teams with page 0 and size 20
    Then the response includes 20 of the 24 remaining available teams
    And the pagination metadata shows:
      | totalElements  | 24 (unused teams) |
      | totalPages     | 2                 |

  Scenario: Pagination includes navigation links
    Given I am viewing available teams for week 1
    When I am on page 1 of 4 with size 10
    Then the response includes navigation links:
      | first    | /api/v1/teams/available?page=0&size=10 |
      | previous | /api/v1/teams/available?page=0&size=10 |
      | self     | /api/v1/teams/available?page=1&size=10 |
      | next     | /api/v1/teams/available?page=2&size=10 |
      | last     | /api/v1/teams/available?page=3&size=10 |

  Scenario: Validate maximum page size for team list
    Given the system has a maximum page size of 100
    When I request teams with page size 200
    Then the request is rejected with error "MAX_PAGE_SIZE_EXCEEDED"
    And the error message suggests "Maximum page size is 100"

  Scenario: Paginate with sorting by team name
    Given there are 32 NFL teams in the system
    When I request teams sorted by "name" ascending with page size 10
    Then page 0 shows the first 10 teams alphabetically
    And page 1 shows teams 11-20 alphabetically
    And pagination metadata includes sort information:
      | sort | name,asc |

  Scenario: Paginate with sorting by win percentage
    Given there are 32 NFL teams in the system
    And each team has a win percentage calculated
    When I request teams sorted by "winPercentage" descending with page size 10
    Then page 0 shows the top 10 teams by win percentage
    And page 1 shows teams ranked 11-20 by win percentage
    And pagination metadata includes sort information:
      | sort | winPercentage,desc |

  Scenario: Request page beyond available teams
    Given there are 32 NFL teams
    When I request page 10 with size 20
    Then the response returns an empty list
    And the pagination metadata shows:
      | page           | 10             |
      | size           | 20             |
      | totalElements  | 32             |
      | totalPages     | 2              |
      | hasNext        | false          |
      | hasPrevious    | true           |

  Scenario: Paginate teams with multiple filters and sorting
    Given I am viewing teams for week 2
    And I filter by conference "AFC"
    And I exclude my previously used teams
    And I have used 3 AFC teams already
    When I request teams sorted by "winPercentage" descending with page 0 and size 10
    Then the response includes 10 available AFC teams
    And teams are sorted by win percentage
    And the pagination metadata shows:
      | totalElements  | 13 (16 AFC - 3 used) |
      | totalPages     | 2                    |
      | sort           | winPercentage,desc   |
