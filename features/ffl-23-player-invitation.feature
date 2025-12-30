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

  # League Capacity and Limits

  Scenario: Admin cannot invite when league is at maximum capacity
    Given the league "league-01" has a maximum of 10 players
    And the league currently has 10 members
    When I send an invitation to "newplayer@email.com" for league "league-01"
    Then the invitation should fail
    And I should receive error "League is at maximum capacity (10 players)"
    And no invitation should be created

  Scenario: Admin can invite when league has space
    Given the league "league-01" has a maximum of 10 players
    And the league currently has 8 members
    And there are 1 pending invitation(s)
    When I send an invitation to "newplayer@email.com" for league "league-01"
    Then the invitation should be created successfully
    And pending invitations count should be 2
    And available slots should show 0 (8 members + 2 pending = 10)

  Scenario: Count pending invitations against league capacity
    Given the league "league-01" has a maximum of 10 players
    And the league currently has 7 members
    And there are 3 pending invitations
    When I send an invitation to "newplayer@email.com" for league "league-01"
    Then the invitation should fail
    And I should receive error "No available slots (7 members + 3 pending invitations = 10)"

  Scenario: Expired invitation frees up capacity slot
    Given the league "league-01" has a maximum of 10 players
    And the league currently has 9 members
    And there is 1 pending invitation that expires
    When the invitation expires
    Then the available slots should increase to 1
    And admin can send a new invitation

  # Waiting List

  Scenario: Add player to waiting list when league is full
    Given the league "league-01" is at maximum capacity
    And waiting list is enabled for the league
    When I add "waitlist@email.com" to the waiting list for league "league-01"
    Then the waiting list entry should be created
    And the player should receive notification about waiting list position
    And the position should be 1

  Scenario: Automatically invite from waiting list when slot opens
    Given the league "league-01" is at maximum capacity
    And "waitlist1@email.com" is first on waiting list
    And "waitlist2@email.com" is second on waiting list
    When a player leaves league "league-01"
    Then an automatic invitation should be sent to "waitlist1@email.com"
    And "waitlist2@email.com" moves to position 1
    And the admin is notified of automatic invitation

  Scenario: View waiting list for a league
    Given the league "league-01" has waiting list entries:
      | email               | position | addedDate   |
      | wait1@email.com     | 1        | 2025-09-01  |
      | wait2@email.com     | 2        | 2025-09-02  |
      | wait3@email.com     | 3        | 2025-09-03  |
    When I request the waiting list for league "league-01"
    Then I should receive 3 entries
    And entries should be sorted by position

  Scenario: Remove player from waiting list
    Given "wait1@email.com" is on the waiting list for league "league-01"
    When I remove "wait1@email.com" from the waiting list
    Then the waiting list entry should be removed
    And remaining players' positions should be updated

  # Invitation Links

  Scenario: Generate shareable invitation link for league
    Given the league "league-01" exists and I am the owner
    When I generate a shareable invitation link for league "league-01"
    Then a unique invitation link should be created
    And the link should contain the league identifier
    And the link should have configurable usage limits
    And the link should have expiration date

  Scenario: Player joins via shareable link
    Given a shareable link exists for league "league-01"
    And the link allows 5 uses
    And 3 players have already used the link
    When a new player uses the shareable link
    And authenticates via Google OAuth
    Then the player should be added to league "league-01"
    And the remaining uses should be 1
    And the player should receive welcome notification

  Scenario: Shareable link exhausted
    Given a shareable link exists for league "league-01"
    And the link allows 5 uses
    And 5 players have already used the link
    When a new player attempts to use the shareable link
    Then the request should fail
    And the player should see "This invitation link has reached its usage limit"
    And the player should be offered to join waiting list

  Scenario: Disable shareable link
    Given a shareable link exists for league "league-01"
    When I disable the shareable link
    Then the link should be invalidated
    And attempts to use the link should fail
    And the error should be "This invitation link has been disabled"

  # Invitation Templates

  Scenario: Create invitation template
    Given I am an admin for league "league-01"
    When I create an invitation template:
      | name       | Welcome Template              |
      | subject    | Join our Fantasy League!      |
      | body       | You're invited to compete...  |
      | leagueId   | league-01                     |
    Then the template should be saved
    And available for future invitations

  Scenario: Send invitation using template
    Given an invitation template "Welcome Template" exists for league "league-01"
    When I send an invitation to "player@email.com" using template "Welcome Template"
    Then the invitation email should use the template content
    And the league name should be automatically included
    And personalization tokens should be replaced

  Scenario: Update invitation template
    Given an invitation template "Welcome Template" exists
    When I update the template body to "New welcome message..."
    Then the template should be updated
    And future invitations should use new content
    And past invitations are not affected

  # Invitation Analytics

  Scenario: Track invitation open rates
    Given I sent 10 invitations for league "league-01"
    And 7 recipients opened the email
    When I request invitation analytics for league "league-01"
    Then the open rate should be 70%
    And I should see which recipients opened the email
    And open timestamps should be recorded

  Scenario: Track invitation acceptance rates
    Given I sent 10 invitations for league "league-01"
    And 5 invitations were accepted
    And 2 invitations expired
    And 3 invitations are still pending
    When I request invitation analytics for league "league-01"
    Then the acceptance rate should be 50%
    And the expiration rate should be 20%
    And the pending rate should be 30%

  Scenario: View invitation funnel
    Given invitations were sent for league "league-01"
    When I view the invitation funnel
    Then I should see:
      | Stage       | Count | Percentage |
      | Sent        | 100   | 100%       |
      | Opened      | 75    | 75%        |
      | Clicked     | 50    | 50%        |
      | Accepted    | 40    | 40%        |

  Scenario: Export invitation report
    Given invitations exist for league "league-01"
    When I export the invitation report
    Then a CSV file should be generated
    And it should include all invitation data
    And it should include analytics data

  # Reminder System

  Scenario: Send automatic reminder for pending invitations
    Given an invitation was sent to "pending@email.com" 3 days ago
    And the invitation is still pending
    And reminder is configured for 3 days after initial invitation
    When the reminder job runs
    Then a reminder email should be sent to "pending@email.com"
    And the reminder count should be incremented
    And the reminder timestamp should be recorded

  Scenario: Limit number of reminders
    Given an invitation has received 2 reminders (maximum configured)
    When the reminder job runs
    Then no additional reminder should be sent
    And the invitation should be flagged as "reminder_limit_reached"

  Scenario: Admin manually sends reminder
    Given an invitation was sent to "pending@email.com" for league "league-01"
    When I manually send a reminder
    Then a reminder email should be sent immediately
    And the reminder count should be incremented
    And the action should be logged

  Scenario: Configure reminder schedule
    Given I am configuring invitations for league "league-01"
    When I set reminder schedule:
      | first_reminder  | 3 days after invitation  |
      | second_reminder | 5 days after invitation  |
      | max_reminders   | 2                        |
    Then the reminder schedule should be saved
    And future invitations should follow this schedule

  # Role-Based Invitations

  Scenario: Invite player with co-admin role
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "coadmin@email.com" for league "league-01" with role "CO_ADMIN"
    Then the invitation should be created with role "CO_ADMIN"
    When the player accepts the invitation
    Then the player should have CO_ADMIN privileges in league "league-01"
    And can manage other players but not league settings

  Scenario: Invite player with commissioner role
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "commish@email.com" for league "league-01" with role "COMMISSIONER"
    Then the invitation should be created with role "COMMISSIONER"
    When the player accepts the invitation
    Then the player should have COMMISSIONER privileges
    And can manage scoring disputes and settings

  Scenario: Default role is PLAYER
    Given the league "league-01" exists and I am the owner
    When I send an invitation to "player@email.com" for league "league-01" without specifying role
    Then the invitation should default to role "PLAYER"

  # Referral System

  Scenario: Track referral source
    Given a player "referrer@email.com" is a member of league "league-01"
    When the player shares their referral link
    And "newplayer@email.com" joins via the referral link
    Then the referral should be tracked
    And "referrer@email.com" should be credited
    And referral analytics should be updated

  Scenario: Award referral bonus
    Given referral bonuses are enabled for league "league-01"
    And bonus is "priority draft position"
    When "referrer@email.com" successfully refers 3 new players
    Then "referrer@email.com" should receive the referral bonus
    And the bonus should be applied to next draft

  # Bulk Operations

  Scenario: Import invitations from CSV
    Given I have a CSV file with player emails:
      | email               | customMessage              |
      | player1@email.com   | Welcome Player 1!          |
      | player2@email.com   | Welcome Player 2!          |
      | player3@email.com   | Welcome Player 3!          |
    When I import the CSV for league "league-01"
    Then 3 invitations should be created
    And each should have the custom message from CSV
    And invalid rows should be reported

  Scenario: Validate CSV before import
    Given I have a CSV file with some invalid entries:
      | email               | valid   |
      | valid@email.com     | yes     |
      | invalid-email       | no      |
      | duplicate@email.com | yes     |
      | duplicate@email.com | no      |
    When I validate the CSV for league "league-01"
    Then validation report should show:
      | valid_entries    | 2 |
      | invalid_emails   | 1 |
      | duplicates       | 1 |

  Scenario: Cancel all pending invitations
    Given 5 pending invitations exist for league "league-01"
    When I cancel all pending invitations for league "league-01"
    Then all 5 invitations should have status "CANCELLED"
    And a confirmation message should be displayed
    And the action should be logged

  # Mobile Deep Links

  Scenario: Invitation link opens in mobile app
    Given an invitation email is sent
    And the recipient has the mobile app installed
    When the recipient clicks the invitation link on mobile
    Then the app should open directly
    And navigate to the invitation acceptance screen
    And pre-fill relevant information

  Scenario: Invitation link fallback for web
    Given an invitation email is sent
    And the recipient does not have the mobile app
    When the recipient clicks the invitation link
    Then the web browser should open
    And redirect to the web invitation page
    And offer option to download mobile app

  # Notification Preferences

  Scenario: Admin configures invitation notification settings
    Given I am configuring league "league-01"
    When I set notification preferences:
      | notify_on_acceptance | true  |
      | notify_on_decline    | true  |
      | notify_on_expiration | false |
      | daily_digest         | true  |
    Then notifications should follow these preferences

  Scenario: Player receives invitation via multiple channels
    Given a player has registered email and phone
    When an invitation is sent with multi-channel delivery
    Then the player should receive email notification
    And the player should receive SMS notification
    And both should contain the invitation link

  # Security

  Scenario: Rate limit invitation sending
    Given I have sent 50 invitations in the last hour
    And the rate limit is 50 per hour
    When I attempt to send another invitation
    Then the request should be rate limited
    And I should receive error "Rate limit exceeded. Please try again later."
    And the next allowed time should be displayed

  Scenario: Detect and block spam invitations
    Given I attempt to send 100 invitations in 5 minutes
    When the system detects unusual activity
    Then my account should be temporarily restricted
    And the security team should be notified
    And I should receive warning about suspicious activity

  Scenario: Validate invitation token integrity
    Given an invitation token "abc123" was issued
    When someone attempts to modify the token to "abc124"
    Then the modified token should be rejected
    And the error should be "Invalid invitation token"
    And the attempt should be logged

  Scenario: Prevent invitation forwarding abuse
    Given an invitation was sent to "intended@email.com"
    When someone else tries to accept with email "attacker@email.com"
    Then the acceptance should fail
    And the email mismatch should be logged
    And the intended recipient should be notified of the attempt

  # Integration with League Lifecycle

  Scenario: Cannot invite after league draft has started
    Given the league "league-01" draft is in progress
    When I attempt to send an invitation
    Then the invitation should fail
    And I should receive error "Cannot invite players after draft has started"

  Scenario: Cannot invite after league season has started
    Given the league "league-01" season has started
    When I attempt to send an invitation
    Then the invitation should fail
    And I should receive error "Cannot invite players after season has started"

  Scenario: Invitation valid only before league lock date
    Given the league "league-01" locks on "2025-09-15"
    And current date is "2025-09-14"
    When I send an invitation
    Then the invitation should include warning "League locks tomorrow - player must join by then"

  # Declined Invitations

  Scenario: Player explicitly declines invitation
    Given an invitation was sent to "decliner@email.com" for league "league-01"
    When the player clicks "Decline" in the invitation
    Then the invitation status should be "DECLINED"
    And the admin should be notified
    And the slot should be freed up
    And the player can provide optional decline reason

  Scenario: Track decline reasons
    Given 10 invitations were declined for league "league-01"
    And reasons provided:
      | reason              | count |
      | Not interested      | 4     |
      | Schedule conflict   | 3     |
      | Other commitment    | 2     |
      | No reason given     | 1     |
    When I view decline analytics
    Then I should see the breakdown of reasons

  # Invitation Status Workflow

  Scenario Outline: Invitation status transitions
    Given an invitation with status "<current_status>"
    When the action "<action>" is performed
    Then the status should become "<new_status>"
    And the transition should be <allowed>

    Examples:
      | current_status | action     | new_status | allowed  |
      | PENDING        | accept     | ACCEPTED   | yes      |
      | PENDING        | decline    | DECLINED   | yes      |
      | PENDING        | cancel     | CANCELLED  | yes      |
      | PENDING        | expire     | EXPIRED    | yes      |
      | ACCEPTED       | cancel     | ACCEPTED   | no       |
      | DECLINED       | accept     | DECLINED   | no       |
      | EXPIRED        | accept     | EXPIRED    | no       |
      | CANCELLED      | resend     | PENDING    | yes      |

  # Email Deliverability

  Scenario: Handle email bounce
    Given an invitation is sent to "bounce@invalid-domain.com"
    When the email bounces
    Then the invitation status should be updated to "BOUNCED"
    And the admin should be notified of the bounce
    And the email should be flagged as undeliverable

  Scenario: Handle spam complaint
    Given an invitation is sent
    And the recipient marks it as spam
    When the spam complaint is received
    Then the system should log the complaint
    And the email should be added to suppression list
    And future invitations to that address should be blocked

  Scenario: Verify email before sending
    Given I am sending an invitation to "verify@email.com"
    When email verification is enabled
    Then the system should verify the email exists
    And warn if verification fails
    And allow override with confirmation
