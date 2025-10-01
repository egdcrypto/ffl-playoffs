Feature: Player Invitation
  As an admin
  I want to invite players to join the FFL Playoffs game
  So that we can build a competitive league with authorized participants

  Background:
    Given the system is configured with email notification service
    And I am authenticated as an admin user

  Scenario: Admin successfully invites a new player
    Given the game "2025 NFL Playoffs Pool" exists
    When I send an invitation to "john.doe@email.com" with message "Join us for the playoffs!"
    Then the invitation should be created successfully
    And an invitation email should be sent to "john.doe@email.com"
    And the invitation status should be "PENDING"
    And the invitation should have a unique token

  Scenario: Player accepts invitation and creates account
    Given an invitation was sent to "jane.smith@email.com"
    And the invitation token is "abc123token456"
    When the player accepts the invitation with token "abc123token456"
    And provides account details:
      | field      | value             |
      | username   | janesmith         |
      | email      | jane.smith@email.com |
      | firstName  | Jane              |
      | lastName   | Smith             |
    Then a player account should be created
    And the invitation status should be "ACCEPTED"
    And the player should be added to the game
    And the player role should be "PLAYER"

  Scenario: Admin invites multiple players at once
    Given the game "2025 NFL Playoffs Pool" exists
    When I send bulk invitations to:
      | email                  |
      | player1@email.com      |
      | player2@email.com      |
      | player3@email.com      |
    Then 3 invitations should be created
    And invitation emails should be sent to all recipients
    And all invitations should have status "PENDING"

  Scenario: Admin cannot invite player with duplicate email
    Given a player with email "existing@email.com" already exists
    When I send an invitation to "existing@email.com"
    Then the invitation should fail
    And I should receive error "Player with this email already exists"

  Scenario: Admin cannot invite with invalid email format
    Given the game "2025 NFL Playoffs Pool" exists
    When I send an invitation to "invalid-email-format"
    Then the invitation should fail
    And I should receive error "Invalid email address format"

  Scenario: Invitation expires after configured time period
    Given an invitation was sent to "late.player@email.com" on "2025-09-01"
    And the invitation expiration period is 7 days
    When the player attempts to accept the invitation on "2025-09-10"
    Then the acceptance should fail
    And I should receive error "Invitation has expired"
    And the invitation status should be "EXPIRED"

  Scenario: Player cannot use already accepted invitation token
    Given an invitation was sent to "duplicate@email.com"
    And the invitation was already accepted
    When another user attempts to accept the invitation with the same token
    Then the acceptance should fail
    And I should receive error "Invitation has already been used"

  Scenario: Admin can resend invitation
    Given an invitation was sent to "resend@email.com"
    And the invitation status is "PENDING"
    When I resend the invitation to "resend@email.com"
    Then a new invitation email should be sent
    And the invitation token should be regenerated
    And the invitation expiration should be extended

  Scenario: Admin can cancel pending invitation
    Given an invitation was sent to "cancel@email.com"
    And the invitation status is "PENDING"
    When I cancel the invitation for "cancel@email.com"
    Then the invitation status should be "CANCELLED"
    And the invitation token should be invalidated

  Scenario: Admin views all pending invitations
    Given the following invitations exist:
      | email               | status   | sentDate   |
      | pending1@email.com  | PENDING  | 2025-09-25 |
      | pending2@email.com  | PENDING  | 2025-09-26 |
      | accepted@email.com  | ACCEPTED | 2025-09-20 |
      | expired@email.com   | EXPIRED  | 2025-08-01 |
    When I request the list of pending invitations
    Then I should receive 2 invitations
    And the invitations should have status "PENDING"

  Scenario: Non-admin user cannot send invitations
    Given I am authenticated as a regular player
    When I attempt to send an invitation to "newplayer@email.com"
    Then the invitation should fail
    And I should receive error "Unauthorized: Admin privileges required"

  Scenario Outline: Invitation validation rules
    Given the game "2025 NFL Playoffs Pool" exists
    When I send an invitation to "<email>" with message "<message>"
    Then the invitation should <result>
    And I should receive <feedback>

    Examples:
      | email                    | message                      | result  | feedback                                    |
      | valid@email.com          | Welcome to the game!         | succeed | invitation created successfully             |
      |                          | Welcome!                     | fail    | error "Email address is required"           |
      | valid@email.com          |                              | succeed | invitation created successfully             |
      | test@                    | Join us                      | fail    | error "Invalid email address format"        |
      | @domain.com              | Join us                      | fail    | error "Invalid email address format"        |
