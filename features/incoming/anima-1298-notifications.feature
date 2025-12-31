@notifications @alerts
Feature: Notifications
  As a fantasy football manager
  I want to receive timely notifications about league activity
  So that I can stay informed and take action when needed

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And I have notification permissions enabled

  # ============================================================================
  # PUSH NOTIFICATIONS
  # ============================================================================

  @happy-path @push
  Scenario: Receive push notification on mobile device
    Given I have push notifications enabled on my mobile device
    When a notification-worthy event occurs
    Then I should receive a push notification
    And the notification should appear in my device's notification center

  @happy-path @push
  Scenario: Tap push notification to open app
    Given I received a push notification about a trade offer
    When I tap the notification
    Then the app should open
    And I should be taken directly to the trade offer

  @happy-path @push
  Scenario: Push notification with action buttons
    Given I receive a trade offer notification
    When I view the notification
    Then I should see "View" and "Dismiss" action buttons
    And tapping "View" should open the trade details

  @happy-path @push
  Scenario: Rich push notification with preview
    Given I receive a score update notification
    When I long-press the notification
    Then I should see an expanded preview
    And I should see my current score and opponent's score

  @happy-path @push
  Scenario: Push notification badge count
    Given I have 3 unread notifications
    When I view my device home screen
    Then the app icon should show a badge with "3"
    And the badge should update when I read notifications

  @validation @push
  Scenario: Push notifications require permission
    Given I have not granted push notification permission
    When a notification event occurs
    Then I should not receive a push notification
    And I should see an in-app prompt to enable push

  @happy-path @push
  Scenario: Receive push notification on web browser
    Given I have browser push notifications enabled
    When a notification-worthy event occurs
    Then I should receive a browser push notification
    And clicking should open the relevant page

  # ============================================================================
  # EMAIL NOTIFICATIONS
  # ============================================================================

  @happy-path @email
  Scenario: Receive email notification for trade offer
    Given I have email notifications enabled for trades
    When I receive a trade offer
    Then I should receive an email notification
    And the email should contain trade details
    And the email should have action links

  @happy-path @email
  Scenario: Receive weekly digest email
    Given I have weekly digest enabled
    When Sunday arrives
    Then I should receive a weekly digest email
    And the digest should summarize:
      | Content           |
      | Week's Results    |
      | Standings Update  |
      | Upcoming Matchup  |
      | Key Player News   |

  @happy-path @email
  Scenario: Receive draft reminder email
    Given the draft is scheduled for tomorrow
    When the 24-hour reminder triggers
    Then I should receive an email reminder
    And the email should include draft time and link

  @happy-path @email
  Scenario: Email notification with unsubscribe link
    Given I received a notification email
    When I view the email
    Then I should see an unsubscribe link
    And clicking it should update my email preferences

  @happy-path @email
  Scenario: Configure email notification frequency
    When I set email frequency to "Daily Digest"
    Then I should receive one email per day
    And it should consolidate all notifications

  @validation @email
  Scenario: Verify email before sending notifications
    Given my email is not verified
    When a notification event occurs
    Then I should not receive email notifications
    And I should see a prompt to verify my email

  @happy-path @email
  Scenario: HTML and plain text email versions
    Given I receive an email notification
    Then the email should have HTML formatting
    And a plain text fallback should be available

  # ============================================================================
  # IN-APP ALERTS
  # ============================================================================

  @happy-path @in-app
  Scenario: View in-app notification center
    Given I have unread notifications
    When I tap the notification bell icon
    Then I should see my notification center
    And I should see notifications sorted by date

  @happy-path @in-app
  Scenario: Unread notification indicator
    Given I have 5 unread notifications
    When I view the app header
    Then I should see a badge showing "5" on the notification icon
    And the badge should be visually prominent

  @happy-path @in-app
  Scenario: Mark notification as read
    Given I have an unread notification
    When I tap on the notification
    Then the notification should be marked as read
    And the unread count should decrease

  @happy-path @in-app
  Scenario: Mark all notifications as read
    Given I have multiple unread notifications
    When I tap "Mark All as Read"
    Then all notifications should be marked as read
    And the unread count should be zero

  @happy-path @in-app
  Scenario: In-app toast notification
    Given I am actively using the app
    When a score update occurs
    Then I should see a toast notification at the top
    And the toast should auto-dismiss after 5 seconds
    And I should be able to dismiss it manually

  @happy-path @in-app
  Scenario: Notification groups by type
    Given I have multiple notifications
    When I view my notification center
    Then I should see notifications grouped:
      | Group      | Notifications          |
      | Trades     | Trade offers, results  |
      | Scores     | Score updates, wins    |
      | Waivers    | Claims, results        |
      | League     | Announcements, chat    |

  @happy-path @in-app
  Scenario: Delete notification
    Given I have a notification I no longer need
    When I swipe left on the notification
    Then I should see a delete option
    And tapping delete should remove the notification

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @preferences
  Scenario: View notification preferences
    When I view my notification settings
    Then I should see all notification categories
    And I should see toggles for each notification type
    And I should see channel options (push, email, in-app)

  @happy-path @preferences
  Scenario: Configure notifications by category
    When I configure notification preferences
    Then I should be able to set each category:
      | Category        | Push | Email | In-App |
      | Score Updates   | On   | Off   | On     |
      | Trade Offers    | On   | On    | On     |
      | Waiver Results  | On   | On    | On     |
      | Draft Reminders | On   | On    | On     |
      | Injury Alerts   | On   | Off   | On     |

  @happy-path @preferences
  Scenario: Configure quiet hours
    When I set quiet hours from 10 PM to 7 AM
    Then I should not receive push notifications during quiet hours
    And notifications should queue for morning delivery
    And urgent notifications should still come through

  @happy-path @preferences
  Scenario: Configure notification sound
    When I select a custom notification sound
    Then notifications should play that sound
    And I should be able to set different sounds per category

  @happy-path @preferences
  Scenario: Disable all notifications
    When I toggle "Disable All Notifications"
    Then I should not receive any notifications
    And I should see a warning about missing updates
    And I should be able to re-enable at any time

  @happy-path @preferences
  Scenario: Configure per-league notification settings
    Given I am in multiple leagues
    When I configure notifications for "Playoff Champions"
    Then those settings should only apply to that league
    And other leagues should use their own settings

  @happy-path @preferences
  Scenario: Reset notification preferences to default
    When I tap "Reset to Defaults"
    Then all preferences should return to default values
    And I should see a confirmation message

  # ============================================================================
  # SCORE ALERTS
  # ============================================================================

  @happy-path @score-alerts
  Scenario: Receive score update during game
    Given my player is in an active game
    When my player scores a touchdown
    Then I should receive a notification
    And it should say "Tyreek Hill scored a TD! +6 pts"

  @happy-path @score-alerts
  Scenario: Receive matchup update notification
    Given my matchup is close
    When the score changes significantly
    Then I should receive a notification
    And it should show current scores for both teams

  @happy-path @score-alerts
  Scenario: Receive lead change notification
    Given I was winning my matchup
    When my opponent takes the lead
    Then I should receive a notification
    And it should say "You've fallen behind! 95-98"

  @happy-path @score-alerts
  Scenario: Receive game final notification
    Given I am watching my matchup
    When all games are complete
    Then I should receive a final score notification
    And it should indicate win or loss

  @happy-path @score-alerts
  Scenario: Configure score alert thresholds
    When I set score alerts for "Every 10 points"
    Then I should receive notifications at 10-point intervals
    And I should not be overwhelmed with updates

  @happy-path @score-alerts
  Scenario: Projection update notification
    Given the projection shows I will win by 2 points
    When the projection changes to losing by 5 points
    Then I should receive a projection alert
    And it should explain the projection change

  @happy-path @score-alerts
  Scenario: Player milestone notification
    Given my player is approaching 100 rushing yards
    When my player exceeds 100 rushing yards
    Then I should receive a milestone notification
    And it should include any bonus points earned

  # ============================================================================
  # TRADE NOTIFICATIONS
  # ============================================================================

  @happy-path @trade
  Scenario: Receive trade offer notification
    Given another manager sends me a trade offer
    When the offer is submitted
    Then I should receive a notification
    And it should show what I'm giving and receiving
    And it should link to the trade review page

  @happy-path @trade
  Scenario: Receive trade counter-offer notification
    Given I sent a trade offer
    When the other manager sends a counter-offer
    Then I should receive a notification
    And it should show the modified terms

  @happy-path @trade
  Scenario: Receive trade accepted notification
    Given I have a pending trade offer
    When the other manager accepts
    Then I should receive a notification
    And it should confirm the trade is processing

  @happy-path @trade
  Scenario: Receive trade rejected notification
    Given I have a pending trade offer
    When the other manager rejects
    Then I should receive a notification
    And I should be able to modify and resend

  @happy-path @trade
  Scenario: Receive trade vetoed notification
    Given my trade was approved
    When the commissioner vetoes the trade
    Then I should receive a notification
    And it should explain the veto reason

  @happy-path @trade
  Scenario: Trade review period reminder
    Given a trade is in the review period
    When 12 hours remain in the review period
    Then league members should receive a reminder
    And they should be prompted to review or vote

  @happy-path @trade
  Scenario: Trade completed notification
    Given my trade passed the review period
    When the trade processes
    Then I should receive a completion notification
    And my roster should reflect the changes

  # ============================================================================
  # WAIVER RESULTS
  # ============================================================================

  @happy-path @waiver
  Scenario: Receive waiver claim success notification
    Given I submitted a waiver claim
    When waivers process and I win the claim
    Then I should receive a success notification
    And it should show the player added
    And it should show any player dropped

  @happy-path @waiver
  Scenario: Receive waiver claim failed notification
    Given I submitted a waiver claim
    When waivers process and I lose the claim
    Then I should receive a notification
    And it should explain why I lost (higher priority claim)

  @happy-path @waiver
  Scenario: Receive FAAB bid result notification
    Given I submitted a FAAB bid of $25
    When waivers process
    Then I should receive a notification
    And it should show if I won or lost
    And it should show the winning bid amount

  @happy-path @waiver
  Scenario: Waiver processing reminder
    Given waivers process tomorrow at midnight
    When the reminder time is reached
    Then I should receive a notification
    And it should prompt me to submit or review claims

  @happy-path @waiver
  Scenario: Waiver claim conflict notification
    Given multiple claims exist for the same player
    When I view my pending claims
    Then I should see a notification about competition
    And I should be able to adjust my claims

  # ============================================================================
  # DRAFT REMINDERS
  # ============================================================================

  @happy-path @draft
  Scenario: Receive draft scheduled notification
    Given the commissioner schedules the draft
    When the draft is scheduled
    Then I should receive a notification
    And it should include the date, time, and link

  @happy-path @draft
  Scenario: Receive 24-hour draft reminder
    Given the draft is tomorrow
    When the 24-hour mark is reached
    Then I should receive a reminder notification
    And it should include countdown to draft

  @happy-path @draft
  Scenario: Receive 1-hour draft reminder
    Given the draft is in 1 hour
    When the 1-hour mark is reached
    Then I should receive an urgent reminder
    And the notification should be higher priority

  @happy-path @draft
  Scenario: Receive draft starting notification
    Given the draft is about to begin
    When the draft starts
    Then I should receive a notification
    And it should link directly to the draft room

  @happy-path @draft
  Scenario: Receive on-the-clock notification
    Given the draft is in progress
    When it becomes my turn to pick
    Then I should receive an urgent notification
    And it should show time remaining

  @happy-path @draft
  Scenario: Draft pick made notification
    Given I am watching the draft
    When another team makes a pick
    Then I should receive a notification
    And it should show who was picked

  @happy-path @draft
  Scenario: Draft complete notification
    Given the draft is in progress
    When the draft completes
    Then I should receive a notification
    And it should link to the draft recap

  # ============================================================================
  # ROSTER DEADLINES
  # ============================================================================

  @happy-path @roster
  Scenario: Receive lineup lock reminder
    Given my lineup locks in 2 hours
    When the reminder triggers
    Then I should receive a notification
    And it should prompt me to set my lineup

  @happy-path @roster
  Scenario: Receive empty lineup slot warning
    Given I have an empty starting position
    And games start in 1 hour
    When the warning triggers
    Then I should receive an urgent notification
    And it should identify the empty position

  @happy-path @roster
  Scenario: Receive bye week reminder
    Given I have players on bye this week
    When the week begins
    Then I should receive a notification
    And it should list players on bye

  @happy-path @roster
  Scenario: Receive game-day lineup confirmation
    Given it is game day
    When my configured reminder time arrives
    Then I should receive a lineup confirmation request
    And I should be able to confirm with one tap

  @happy-path @roster
  Scenario: Receive roster move deadline reminder
    Given the roster deadline is approaching
    When the deadline is in 1 hour
    Then I should receive a notification
    And it should remind me to make final moves

  # ============================================================================
  # INJURY ALERTS
  # ============================================================================

  @happy-path @injury
  Scenario: Receive injury update notification
    Given "Derrick Henry" is on my roster
    When "Derrick Henry" injury status changes to "Questionable"
    Then I should receive a notification
    And it should include the new injury status

  @happy-path @injury
  Scenario: Receive ruled out notification
    Given "Christian McCaffrey" is in my starting lineup
    When "Christian McCaffrey" is ruled out
    Then I should receive an urgent notification
    And it should suggest bench alternatives

  @happy-path @injury
  Scenario: Receive game-time decision notification
    Given "Patrick Mahomes" is questionable
    When the game-time decision is announced
    Then I should receive a notification
    And it should indicate whether he's active or inactive

  @happy-path @injury
  Scenario: Receive IR designation notification
    Given "Joe Burrow" is on my roster
    When "Joe Burrow" is placed on IR
    Then I should receive a notification
    And it should prompt me to move him to my IR slot

  @happy-path @injury
  Scenario: Receive injury recovery notification
    Given "Derrick Henry" was questionable
    When "Derrick Henry" is cleared to play
    Then I should receive a notification
    And it should say "Derrick Henry cleared - Full practice"

  @happy-path @injury
  Scenario: Configure injury alert severity
    When I configure injury alerts
    Then I should be able to choose severity levels:
      | Level       | Alert |
      | Out         | Yes   |
      | Doubtful    | Yes   |
      | Questionable| Yes   |
      | Probable    | No    |

  # ============================================================================
  # GAME START NOTIFICATIONS
  # ============================================================================

  @happy-path @game-start
  Scenario: Receive game starting notification
    Given I have players in the 1:00 PM games
    When the games are about to start
    Then I should receive a notification
    And it should remind me to check my lineup

  @happy-path @game-start
  Scenario: Receive Thursday Night Football reminder
    Given I have players in the Thursday night game
    When Thursday afternoon arrives
    Then I should receive a reminder
    And it should note the early deadline

  @happy-path @game-start
  Scenario: Receive primetime game notification
    Given I have players in Sunday Night Football
    When the game is about to start
    Then I should receive a notification
    And it should include matchup context

  @happy-path @game-start
  Scenario: Receive Monday Night Football notification
    Given I have players in Monday Night Football
    When the game is about to start
    Then I should receive a notification
    And it should show my current matchup score

  @happy-path @game-start
  Scenario: Receive kickoff notification
    Given I enabled kickoff notifications
    When a game kicks off
    Then I should receive a notification
    And it should list my players in that game

  # ============================================================================
  # NOTIFICATION HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View notification history
    When I view my notification history
    Then I should see all past notifications
    And they should be sorted by date
    And I should see read/unread status

  @happy-path @history
  Scenario: Filter notification history
    When I filter notifications by "Trade"
    Then I should see only trade-related notifications
    And other notification types should be hidden

  @happy-path @history
  Scenario: Search notification history
    When I search for "Patrick Mahomes"
    Then I should see notifications mentioning that player
    And results should highlight the search term

  @happy-path @history
  Scenario: Clear notification history
    When I tap "Clear History"
    Then I should see a confirmation prompt
    And confirming should delete all notifications
    And I should see "No notifications" message

  @happy-path @history
  Scenario: Notification history retention
    Given notifications older than 30 days exist
    When the retention period passes
    Then old notifications should be automatically archived
    And I should be able to access archived notifications

  @happy-path @history
  Scenario: Export notification history
    When I export my notification history
    Then I should receive a CSV or PDF file
    And it should include all notification details

  # ============================================================================
  # MUTE/SNOOZE
  # ============================================================================

  @happy-path @mute
  Scenario: Mute notifications for a league
    Given I want to temporarily stop notifications
    When I mute notifications for "Playoff Champions"
    Then I should not receive notifications for that league
    And other leagues should still notify me

  @happy-path @mute
  Scenario: Snooze all notifications
    When I snooze notifications for 2 hours
    Then I should not receive any notifications for 2 hours
    And a countdown should show time remaining
    And notifications should resume automatically

  @happy-path @mute
  Scenario: Mute specific notification type
    When I mute "Score Update" notifications
    Then I should not receive score updates
    And other notification types should continue

  @happy-path @mute
  Scenario: Mute during games
    Given I am watching games live
    When I enable "Game Day Mute"
    Then I should not receive score spoiler notifications
    And I should receive important alerts (injuries, etc.)

  @happy-path @mute
  Scenario: Unmute notifications
    Given I have muted a league
    When I unmute the league
    Then notifications should resume immediately
    And I should see any queued notifications

  @happy-path @mute
  Scenario: Auto-unmute after timeout
    Given I snoozed notifications for 1 hour
    When 1 hour passes
    Then notifications should automatically resume
    And I should receive a "Notifications resumed" message

  @happy-path @mute
  Scenario: Do Not Disturb mode
    When I enable "Do Not Disturb" mode
    Then all notifications should be silenced
    And they should be marked as delivered but not shown
    And I can review them when I disable DND

  # ============================================================================
  # NOTIFICATION CHANNELS
  # ============================================================================

  @happy-path @channels
  Scenario: Configure channel priority
    When I configure channel preferences
    Then I should be able to set priority:
      | Channel | Priority |
      | Push    | Primary  |
      | Email   | Backup   |
      | In-App  | Always   |

  @happy-path @channels
  Scenario: Multi-channel notification delivery
    Given I have all channels enabled
    When a trade offer is received
    Then I should receive a push notification
    And I should receive an email
    And I should see an in-app notification

  @happy-path @channels
  Scenario: Channel fallback when primary fails
    Given push notification delivery fails
    When a notification is triggered
    Then the system should fallback to email
    And in-app notification should always be created

  @happy-path @channels
  Scenario: Configure channel per notification type
    When I set channel preferences:
      | Notification Type | Push | Email | In-App |
      | Trade Offers      | Yes  | Yes   | Yes    |
      | Score Updates     | Yes  | No    | Yes    |
      | Waiver Results    | Yes  | Yes   | Yes    |
      | Draft Reminders   | Yes  | Yes   | Yes    |
    Then notifications should respect these preferences

  @happy-path @channels
  Scenario: Add SMS channel
    Given I have verified my phone number
    When I enable SMS notifications
    Then I should be able to receive text message alerts
    And I should configure which types go to SMS

  @happy-path @channels
  Scenario: Slack integration channel
    Given I have connected Slack
    When I enable Slack notifications
    Then league updates should post to my Slack channel
    And I should configure notification types

  @happy-path @channels
  Scenario: Discord integration channel
    Given I have connected Discord
    When I enable Discord notifications
    Then I should receive notifications in Discord
    And the bot should format messages appropriately

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: View notifications on mobile
    Given I am using a mobile device
    When I view my notifications
    Then I should see a mobile-optimized layout
    And I should be able to swipe to dismiss

  @mobile @responsive
  Scenario: Configure notifications on mobile
    Given I am using a mobile device
    When I access notification settings
    Then I should see all preference options
    And toggles should be easily tappable

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for notifications
    Given I am using a screen reader
    When I receive a notification
    Then the notification should be announced
    And I should be able to navigate notifications with gestures

  @accessibility @a11y
  Scenario: Visual notification indicators
    Given I have hearing impairment
    When a notification arrives
    Then I should see visual indicators (flash, vibration)
    And I should be able to configure visual alerts

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle push notification delivery failure
    Given push notification fails to deliver
    When the system detects the failure
    Then the notification should be queued for retry
    And in-app notification should be created as backup

  @error @resilience
  Scenario: Handle email delivery failure
    Given email notification fails
    When the system detects the failure
    Then the failure should be logged
    And user should be notified of delivery issues

  @error @resilience
  Scenario: Handle notification service outage
    Given the notification service is unavailable
    When notifications are triggered
    Then they should be queued
    And they should be delivered when service recovers
    And no notifications should be lost
