Feature: Player Invitation (League-Scoped)
  As an admin
  I want to invite players to join specific leagues I own
  So that we can build competitive leagues with authorized participants

  Background:
    Given the system is configured with email notification service
    And I am authenticated as an admin user with ID "admin-001"
    And I own the following leagues:
      | leagueId  | leagueName                |
      | league-01 | 2025 NFL Playoffs Pool    |
      | league-02 | Championship Challenge    |

  Scenario: Admin successfully invites a new player to a specific league
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "john.doe@email.com" for league "league-01" with message "Join our playoffs pool!"
    Then the invitation should be created successfully
    And an invitation email should be sent to "john.doe@email.com"
    And the invitation should contain the league name "2025 NFL Playoffs Pool"
    And the invitation status should be "PENDING"
    And the invitation should have a unique token
    And the invitation leagueId should be "league-01"

  Scenario: Player accepts invitation and creates account for specific league
    Given an invitation was sent to "jane.smith@email.com" for league "league-01"
    And the invitation token is "abc123token456"
    When the player accepts the invitation with token "abc123token456"
    And authenticates via Google OAuth with email "jane.smith@email.com"
    Then a player account should be created with role "PLAYER"
    And the invitation status should be "ACCEPTED"
    And a LeaguePlayer junction record should be created linking:
      | userId     | leagueId  | role   |
      | user-jane  | league-01 | PLAYER |
    And the player should be a member of league "league-01"
    And the player should NOT be a member of any other leagues

  Scenario: Player accepts invitation to join second league (multi-league membership)
    Given a player account exists for "multi@email.com" with userId "user-multi"
    And the player is already a member of league "league-01"
    And an invitation was sent to "multi@email.com" for league "league-02"
    When the player accepts the invitation for league "league-02"
    Then the invitation status should be "ACCEPTED"
    And a LeaguePlayer junction record should be created for league "league-02"
    And the player should be a member of both leagues:
      | leagueId  | leagueName                |
      | league-01 | 2025 NFL Playoffs Pool    |
      | league-02 | Championship Challenge    |
    And the player should have separate roster for each league

  Scenario: Admin invites multiple players to same league
    Given the league "league-01" exists and I am the owner
    When I send bulk invitations for league "league-01" to:
      | email                  |
      | player1@email.com      |
      | player2@email.com      |
      | player3@email.com      |
    Then 3 invitations should be created
    And invitation emails should be sent to all recipients
    And all invitations should have status "PENDING"
    And all invitations should have leagueId "league-01"

  Scenario: Admin cannot invite player to league they don't own
    Given a league "league-other" exists owned by different admin "admin-002"
    When I attempt to send an invitation to "player@email.com" for league "league-other"
    Then the invitation should fail
    And I should receive error "Unauthorized: You can only invite players to leagues you own"

  Scenario: Admin cannot invite player who is already a league member
    Given the league "league-01" exists and I am the owner
    And a player "existing@email.com" is already a member of league "league-01"
    When I send an invitation to "existing@email.com" for league "league-01"
    Then the invitation should fail
    And I should receive error "Player is already a member of this league"

  Scenario: Admin can invite same player to different league
    Given a player "multi@email.com" is a member of league "league-01"
    And the league "league-02" exists and I am the owner
    And the player is NOT a member of league "league-02"
    When I send an invitation to "multi@email.com" for league "league-02"
    Then the invitation should be created successfully
    And an invitation email should be sent to "multi@email.com"
    And the invitation leagueId should be "league-02"

  Scenario: Admin cannot invite with invalid email format
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "invalid-email-format" for league "league-01"
    Then the invitation should fail
    And I should receive error "Invalid email address format"

  Scenario: Invitation expires after configured time period
    Given an invitation was sent to "late.player@email.com" for league "league-01" on "2025-09-01"
    And the invitation expiration period is 7 days
    When the player attempts to accept the invitation on "2025-09-10"
    Then the acceptance should fail
    And I should receive error "Invitation has expired"
    And the invitation status should be "EXPIRED"

  Scenario: Player cannot use already accepted invitation token
    Given an invitation was sent to "duplicate@email.com" for league "league-01"
    And the invitation was already accepted
    When another user attempts to accept the invitation with the same token
    Then the acceptance should fail
    And I should receive error "Invitation has already been used"

  Scenario: Admin can resend invitation to their league
    Given an invitation was sent to "resend@email.com" for league "league-01"
    And the invitation status is "PENDING"
    When I resend the invitation to "resend@email.com" for league "league-01"
    Then a new invitation email should be sent
    And the invitation token should be regenerated
    And the invitation expiration should be extended
    And the invitation leagueId should still be "league-01"

  Scenario: Admin can cancel pending invitation for their league
    Given an invitation was sent to "cancel@email.com" for league "league-01"
    And the invitation status is "PENDING"
    When I cancel the invitation for "cancel@email.com" in league "league-01"
    Then the invitation status should be "CANCELLED"
    And the invitation token should be invalidated

  Scenario: Admin views all pending invitations for their leagues only
    Given the following invitations exist for my leagues:
      | email               | leagueId  | status   | sentDate   |
      | pending1@email.com  | league-01 | PENDING  | 2025-09-25 |
      | pending2@email.com  | league-02 | PENDING  | 2025-09-26 |
      | accepted@email.com  | league-01 | ACCEPTED | 2025-09-20 |
      | expired@email.com   | league-01 | EXPIRED  | 2025-08-01 |
    And invitations exist for other admin's leagues that I should NOT see
    When I request the list of pending invitations
    Then I should receive 2 invitations
    And the invitations should have status "PENDING"
    And all invitations should be for leagues I own

  Scenario: Admin views pending invitations filtered by specific league
    Given the following invitations exist:
      | email               | leagueId  | status   |
      | pending1@email.com  | league-01 | PENDING  |
      | pending2@email.com  | league-02 | PENDING  |
      | pending3@email.com  | league-01 | PENDING  |
    When I request pending invitations for league "league-01"
    Then I should receive 2 invitations
    And all invitations should have leagueId "league-01"

  Scenario: Non-admin user cannot send invitations
    Given I am authenticated as a regular player
    When I attempt to send an invitation to "newplayer@email.com" for league "league-01"
    Then the invitation should fail
    And I should receive error "Unauthorized: Admin privileges required"

  Scenario: Email matching validation on invitation acceptance
    Given an invitation was sent to "alice@email.com" for league "league-01"
    When the player accepts the invitation but authenticates via Google OAuth with email "bob@email.com"
    Then the acceptance should fail
    And I should receive error "Email does not match invitation"
    And the invitation status should remain "PENDING"

  Scenario Outline: Invitation validation rules for league-scoped invitations
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "<email>" for league "league-01" with message "<message>"
    Then the invitation should <result>
    And I should receive <feedback>

    Examples:
      | email                    | message                      | result  | feedback                                    |
      | valid@email.com          | Welcome to our league!       | succeed | invitation created successfully             |
      |                          | Welcome!                     | fail    | error "Email address is required"           |
      | valid@email.com          |                              | succeed | invitation created successfully             |
      | test@                    | Join us                      | fail    | error "Invalid email address format"        |
      | @domain.com              | Join us                      | fail    | error "Invalid email address format"        |
