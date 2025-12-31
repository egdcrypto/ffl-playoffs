@notifications @anima-1364
Feature: Notifications
  As a fantasy football manager
  I want to receive timely notifications about my team and league
  So that I can stay informed and take action when needed

  Background:
    Given I am a logged-in user
    And I have at least one fantasy team
    And notifications are enabled

  # ============================================================================
  # PUSH NOTIFICATIONS
  # ============================================================================

  @happy-path @push-notifications
  Scenario: Receive mobile push notification
    Given I have mobile push notifications enabled
    When a notification event occurs
    Then I should receive a push notification on my device
    And the notification should appear in my notification tray

  @happy-path @push-notifications
  Scenario: Receive browser push notification
    Given I have browser push notifications enabled
    When a notification event occurs
    Then I should receive a browser notification
    And the notification should appear even if app is not open

  @happy-path @push-notifications
  Scenario: Receive real-time alert
    Given I am subscribed to real-time alerts
    When a time-sensitive event occurs
    Then I should receive an immediate notification
    And the notification should arrive within seconds

  @happy-path @push-notifications
  Scenario: Interact with actionable notification
    Given I receive an actionable push notification
    When I tap on the action button
    Then I should be taken to the relevant action
    And I should be able to complete the action

  @happy-path @push-notifications
  Scenario: View push notification with rich content
    Given I receive a push notification
    Then the notification should include relevant preview
    And images or rich content should display

  @happy-path @push-notifications
  Scenario: Enable push notifications
    Given push notifications are disabled
    When I enable push notifications
    Then I should grant permission
    And push notifications should start working

  @happy-path @push-notifications
  Scenario: Disable push notifications
    Given push notifications are enabled
    When I disable push notifications
    Then I should stop receiving push notifications
    And my preference should be saved

  @error @push-notifications
  Scenario: Handle push notification permission denied
    Given I denied push notification permission
    When the app tries to send notifications
    Then notifications should not be sent
    And I should see guidance to enable permissions

  @error @push-notifications
  Scenario: Handle push notification delivery failure
    Given a push notification fails to deliver
    Then the system should retry delivery
    And failed notifications should be logged

  # ============================================================================
  # EMAIL NOTIFICATIONS
  # ============================================================================

  @happy-path @email-notifications
  Scenario: Receive email alert
    Given I have email notifications enabled
    When a notification event occurs
    Then I should receive an email notification
    And the email should contain relevant details

  @happy-path @email-notifications
  Scenario: Receive digest email
    Given I have digest emails enabled
    When the digest schedule is reached
    Then I should receive a digest email
    And the digest should summarize recent activity

  @happy-path @email-notifications
  Scenario: Receive weekly recap email
    Given I have weekly recaps enabled
    When a week ends
    Then I should receive a weekly recap email
    And the recap should include my team's performance

  @happy-path @email-notifications
  Scenario: Receive transaction confirmation email
    Given I complete a transaction
    When the transaction is processed
    Then I should receive a confirmation email
    And the email should include transaction details

  @happy-path @email-notifications
  Scenario: Configure email frequency
    Given I am in notification settings
    When I set email frequency preferences
    Then I should choose immediate, daily, or weekly
    And my preference should be saved

  @happy-path @email-notifications
  Scenario: Unsubscribe from email notifications
    Given I receive an email notification
    When I click the unsubscribe link
    Then I should be unsubscribed from that email type
    And I should see confirmation

  @happy-path @email-notifications
  Scenario: View email in browser
    Given I receive an email notification
    When I click "view in browser"
    Then I should see the email content in browser
    And formatting should be preserved

  @error @email-notifications
  Scenario: Handle invalid email address
    Given my email address is invalid
    When the system tries to send email
    Then delivery should fail gracefully
    And I should be prompted to update email

  # ============================================================================
  # IN-APP NOTIFICATIONS
  # ============================================================================

  @happy-path @in-app-notifications
  Scenario: View notification center
    Given I have notifications
    When I open the notification center
    Then I should see all my notifications
    And notifications should be organized by recency

  @happy-path @in-app-notifications
  Scenario: View unread count badge
    Given I have unread notifications
    Then I should see an unread count badge
    And the badge should show the correct count

  @happy-path @in-app-notifications
  Scenario: View notification feed
    Given I am in the notification center
    When I scroll through the feed
    Then I should see all notifications
    And I should be able to load more

  @happy-path @in-app-notifications
  Scenario: See notification badges on menu items
    Given I have notifications for specific features
    Then relevant menu items should show badges
    And badges should indicate notification count

  @happy-path @in-app-notifications
  Scenario: Receive real-time in-app notification
    Given I am using the app
    When a notification event occurs
    Then I should see a toast notification
    And the notification center should update

  @happy-path @in-app-notifications
  Scenario: Filter in-app notifications
    Given I am in the notification center
    When I filter by notification type
    Then I should see only that type
    And filters should be clearable

  @mobile @in-app-notifications
  Scenario: View notification center on mobile
    Given I am on a mobile device
    When I open notification center
    Then it should be mobile-optimized
    And swipe gestures should work

  @accessibility @in-app-notifications
  Scenario: Navigate notifications with screen reader
    Given I am using a screen reader
    When I navigate the notification center
    Then all notifications should be announced
    And navigation should be accessible

  # ============================================================================
  # NOTIFICATION TYPES
  # ============================================================================

  @happy-path @notification-types
  Scenario: Receive trade alert
    Given I receive a trade offer
    Then I should get a trade notification
    And the notification should show trade details

  @happy-path @notification-types
  Scenario: Receive waiver alert
    Given a waiver claim is processed
    Then I should get a waiver notification
    And the notification should show claim results

  @happy-path @notification-types
  Scenario: Receive injury alert
    Given a player on my roster is injured
    Then I should get an injury notification
    And the notification should include injury status

  @happy-path @notification-types
  Scenario: Receive game alert
    Given a game involving my players starts
    Then I should get a game notification
    And the notification should link to live scoring

  @happy-path @notification-types
  Scenario: Receive lineup reminder
    Given lineup lock is approaching
    And my lineup has issues
    Then I should get a lineup reminder
    And the reminder should highlight issues

  @happy-path @notification-types
  Scenario: Receive scoring alert
    Given a player on my roster scores
    When scoring thresholds are met
    Then I should get a scoring notification
    And the notification should show points scored

  @happy-path @notification-types
  Scenario: Receive draft alert
    Given a draft is scheduled
    When the draft is about to start
    Then I should get a draft reminder
    And the notification should link to draft room

  @happy-path @notification-types
  Scenario: Receive commissioner announcement
    Given the commissioner posts an announcement
    Then I should get an announcement notification
    And the notification should show the message

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @notification-preferences
  Scenario: Enable specific notification type
    Given I am in notification settings
    When I enable a notification type
    Then that notification should be active
    And I should start receiving those notifications

  @happy-path @notification-preferences
  Scenario: Disable specific notification type
    Given I am in notification settings
    When I disable a notification type
    Then that notification should be inactive
    And I should stop receiving those notifications

  @happy-path @notification-preferences
  Scenario: Set notification frequency
    Given I am in notification settings
    When I set frequency for a notification type
    Then notifications should follow that frequency
    And my preference should be saved

  @happy-path @notification-preferences
  Scenario: Configure quiet hours
    Given I am in notification settings
    When I set quiet hours
    Then notifications should be suppressed during those hours
    And suppressed notifications should queue

  @happy-path @notification-preferences
  Scenario: Set channel preferences
    Given I am in notification settings
    When I set channel preferences per notification type
    Then I should choose push, email, or in-app
    And preferences should be saved per type

  @happy-path @notification-preferences
  Scenario: Reset to default preferences
    Given I have custom notification preferences
    When I reset to defaults
    Then all preferences should return to default
    And I should see confirmation

  @happy-path @notification-preferences
  Scenario: Import notification preferences
    Given I have preferences from another device
    When I sync preferences
    Then preferences should be imported
    And all devices should be in sync

  # ============================================================================
  # NOTIFICATION TRIGGERS
  # ============================================================================

  @happy-path @notification-triggers
  Scenario: Trigger on score update
    Given I have score update notifications enabled
    When a score update occurs
    Then I should receive a notification
    And the notification should show updated score

  @happy-path @notification-triggers
  Scenario: Trigger on player news
    Given I have player news notifications enabled
    When news about my player is published
    Then I should receive a notification
    And the notification should summarize the news

  @happy-path @notification-triggers
  Scenario: Trigger on roster changes
    Given I have roster change notifications enabled
    When my roster changes
    Then I should receive a notification
    And the notification should describe the change

  @happy-path @notification-triggers
  Scenario: Trigger on league activity
    Given I have league activity notifications enabled
    When league activity occurs
    Then I should receive a notification
    And the notification should describe the activity

  @happy-path @notification-triggers
  Scenario: Trigger on deadline reminder
    Given I have deadline reminders enabled
    When a deadline approaches
    Then I should receive a reminder
    And the reminder should include time remaining

  @happy-path @notification-triggers
  Scenario: Configure custom triggers
    Given I am in notification settings
    When I create a custom trigger
    Then the custom notification should work
    And I should be able to edit or delete it

  @happy-path @notification-triggers
  Scenario: Trigger on matchup result
    Given my matchup is complete
    When the result is finalized
    Then I should receive a result notification
    And the notification should show win/loss and score

  # ============================================================================
  # NOTIFICATION HISTORY
  # ============================================================================

  @happy-path @notification-history
  Scenario: View past notifications
    Given I have received notifications
    When I view notification history
    Then I should see all past notifications
    And history should be searchable

  @happy-path @notification-history
  Scenario: View notification log
    Given I am in notification settings
    When I view the notification log
    Then I should see all sent notifications
    And delivery status should be shown

  @happy-path @notification-history
  Scenario: Clear notification history
    Given I have notification history
    When I clear history
    Then all history should be removed
    And I should see confirmation

  @happy-path @notification-history
  Scenario: Archive important notifications
    Given I have an important notification
    When I archive it
    Then it should be saved in archives
    And it should not be cleared with history

  @happy-path @notification-history
  Scenario: Search notification history
    Given I have extensive notification history
    When I search for specific notifications
    Then I should see matching results
    And search should be fast

  @happy-path @notification-history
  Scenario: Filter notification history by date
    Given I am viewing notification history
    When I filter by date range
    Then I should see notifications from that period
    And filter should be clearable

  @happy-path @notification-history
  Scenario: Export notification history
    Given I am viewing notification history
    When I export history
    Then I should receive a downloadable file
    And all history should be included

  # ============================================================================
  # NOTIFICATION ACTIONS
  # ============================================================================

  @happy-path @notification-actions
  Scenario: Mark notification as read
    Given I have an unread notification
    When I mark it as read
    Then the notification should show as read
    And unread count should decrease

  @happy-path @notification-actions
  Scenario: Mark all notifications as read
    Given I have multiple unread notifications
    When I mark all as read
    Then all should be marked read
    And unread count should be zero

  @happy-path @notification-actions
  Scenario: Dismiss notification
    Given I have a notification
    When I dismiss it
    Then the notification should be removed
    And it should not appear again

  @happy-path @notification-actions
  Scenario: Snooze notification
    Given I have a notification
    When I snooze it
    Then the notification should be hidden temporarily
    And it should reappear after snooze period

  @happy-path @notification-actions
  Scenario: Use quick action from notification
    Given I receive a notification with quick actions
    When I tap a quick action
    Then the action should be executed
    And I should see confirmation

  @happy-path @notification-actions
  Scenario: Deep link from notification
    Given I tap on a notification
    Then I should be taken to the relevant screen
    And context should be preserved

  @mobile @notification-actions
  Scenario: Swipe to dismiss notification
    Given I am on a mobile device
    When I swipe to dismiss a notification
    Then the notification should be dismissed
    And the gesture should feel natural

  # ============================================================================
  # NOTIFICATION SCHEDULING
  # ============================================================================

  @happy-path @notification-scheduling
  Scenario: Schedule a future notification
    Given I am setting up a notification
    When I schedule it for a future time
    Then the notification should be queued
    And it should deliver at the scheduled time

  @happy-path @notification-scheduling
  Scenario: Set recurring reminder
    Given I want recurring notifications
    When I set up a recurring schedule
    Then I should receive notifications on schedule
    And recurrence should work correctly

  @happy-path @notification-scheduling
  Scenario: Configure custom schedule
    Given I am in notification settings
    When I create a custom schedule
    Then notifications should follow my schedule
    And I should be able to modify the schedule

  @happy-path @notification-scheduling
  Scenario: Handle time zone differences
    Given I am in a different time zone
    When notifications are scheduled
    Then they should respect my time zone
    And delivery times should be correct

  @happy-path @notification-scheduling
  Scenario: Cancel scheduled notification
    Given I have a scheduled notification
    When I cancel it
    Then the notification should not be sent
    And I should see confirmation

  @happy-path @notification-scheduling
  Scenario: View scheduled notifications
    Given I have scheduled notifications
    When I view scheduled list
    Then I should see all upcoming notifications
    And I should be able to manage them

  @happy-path @notification-scheduling
  Scenario: Modify scheduled notification
    Given I have a scheduled notification
    When I modify the schedule
    Then the new schedule should be saved
    And the notification should follow new schedule

  # ============================================================================
  # NOTIFICATION TEMPLATES
  # ============================================================================

  @happy-path @notification-templates
  Scenario: View default notification templates
    Given I am in notification settings
    When I view notification templates
    Then I should see default templates
    And templates should be categorized

  @happy-path @notification-templates
  Scenario: Create custom notification message
    Given I am creating a custom notification
    When I write a custom message
    Then the custom message should be used
    And personalization tokens should work

  @happy-path @notification-templates
  Scenario: Use personalization in notifications
    Given notifications use personalization
    When a notification is sent
    Then personal details should be inserted
    And the message should feel personal

  @happy-path @notification-templates
  Scenario: Include rich content in notification
    Given I am creating a notification
    When I add rich content
    Then the notification should include formatted content
    And rich content should display properly

  @happy-path @notification-templates
  Scenario: Attach media to notification
    Given I am creating a notification
    When I attach an image
    Then the notification should include the image
    And the image should display correctly

  @commissioner @notification-templates
  Scenario: Create league notification template
    Given I am a league commissioner
    When I create a notification template
    Then the template should be saved
    And I should be able to reuse it

  @commissioner @notification-templates
  Scenario: Send bulk notification to league
    Given I am a league commissioner
    When I send a notification to all members
    Then all members should receive it
    And the template should be applied

  @error @notification-templates
  Scenario: Handle invalid template syntax
    Given I am creating a template
    When I use invalid syntax
    Then I should see an error message
    And I should be shown correct syntax
