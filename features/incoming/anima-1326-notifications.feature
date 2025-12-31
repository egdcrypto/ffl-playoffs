@notifications @ANIMA-1326
Feature: Notifications
  As a fantasy football team manager
  I want to receive timely notifications
  So that I can stay informed about important events and take action

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a team manager
    And I have notification permissions enabled

  # ============================================================================
  # PUSH NOTIFICATIONS - HAPPY PATH
  # ============================================================================

  @happy-path @push-notifications
  Scenario: Receive push notification on mobile
    Given I have the mobile app installed
    And push notifications are enabled
    When an important event occurs
    Then I should receive a push notification
    And the notification should show relevant details
    And tapping should open the relevant section

  @happy-path @push-notifications
  Scenario: Receive push notification on desktop
    Given I have desktop notifications enabled
    When an important event occurs
    Then I should receive a desktop notification
    And it should appear in my system tray
    And clicking should open the app

  @happy-path @push-notifications
  Scenario: View push notification preview
    Given a notification is delivered
    When I view the notification
    Then I should see a preview of the content
    And I should see the notification type icon
    And I should see the timestamp

  @happy-path @push-notifications
  Scenario: Receive grouped push notifications
    Given multiple events occur rapidly
    When notifications are delivered
    Then they should be grouped intelligently
    And I should see a summary count
    And expanding should show individual notifications

  @happy-path @push-notifications
  Scenario: Rich push notification with actions
    Given a notification requires action
    When I receive the push notification
    Then I should see action buttons
    And I should be able to respond directly
    And the action should be processed

  # ============================================================================
  # EMAIL NOTIFICATIONS
  # ============================================================================

  @happy-path @email-notifications
  Scenario: Receive email notification for important event
    Given email notifications are enabled
    When an important event occurs
    Then I should receive an email
    And the email should contain event details
    And I should have action links in the email

  @happy-path @email-notifications
  Scenario: Receive daily digest email
    Given I have digest emails enabled
    When the digest time is reached
    Then I should receive a summary email
    And it should contain all relevant events
    And I should be able to configure frequency

  @happy-path @email-notifications
  Scenario: Receive weekly recap email
    Given the week has completed
    When the recap email is sent
    Then I should receive a weekly summary
    And it should contain my matchup results
    And it should contain league highlights

  @happy-path @email-notifications
  Scenario: Unsubscribe from email notifications
    Given I receive email notifications
    When I click unsubscribe in an email
    Then I should be taken to preferences
    And I should be able to adjust settings
    And the unsubscribe should be confirmed

  @happy-path @email-notifications
  Scenario: Email notification with embedded content
    Given a notification has rich content
    When the email is sent
    Then it should contain formatted content
    And images should be embedded
    And the layout should be mobile-friendly

  # ============================================================================
  # IN-APP NOTIFICATIONS
  # ============================================================================

  @happy-path @in-app-notifications
  Scenario: View in-app notification center
    Given I am using the application
    When I open the notification center
    Then I should see all my notifications
    And they should be sorted by recency
    And unread notifications should be highlighted

  @happy-path @in-app-notifications
  Scenario: Receive real-time in-app notification
    Given I am using the application
    When an event occurs
    Then I should see a notification badge update
    And I should see a toast notification
    And I can dismiss or act on it

  @happy-path @in-app-notifications
  Scenario: Mark notification as read
    Given I have unread notifications
    When I view a notification
    Then it should be marked as read
    And the unread count should decrease
    And the visual indicator should change

  @happy-path @in-app-notifications
  Scenario: Mark all notifications as read
    Given I have multiple unread notifications
    When I click "Mark all as read"
    Then all notifications should be marked read
    And the unread count should reset to zero
    And the notification list should update

  @happy-path @in-app-notifications
  Scenario: Delete notification
    Given I have a notification
    When I delete the notification
    Then it should be removed from my list
    And it should not reappear
    And the deletion should be confirmed

  @happy-path @in-app-notifications
  Scenario: Filter notifications by type
    Given I have various notification types
    When I filter by a specific type
    Then only that type should display
    And I should be able to clear the filter
    And counts should reflect the filter

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @notification-preferences
  Scenario: Access notification preferences
    Given I want to customize notifications
    When I open notification settings
    Then I should see all notification types
    And I should see current settings for each
    And I should be able to modify each

  @happy-path @notification-preferences
  Scenario: Enable specific notification type
    Given a notification type is disabled
    When I enable that type
    Then the setting should be saved
    And I should start receiving those notifications
    And the UI should confirm the change

  @happy-path @notification-preferences
  Scenario: Disable specific notification type
    Given a notification type is enabled
    When I disable that type
    Then the setting should be saved
    And I should stop receiving those notifications
    And other types should be unaffected

  @happy-path @notification-preferences
  Scenario: Configure notification channel per type
    Given I want different channels for different notifications
    When I configure channels per notification type
    Then I should choose push, email, or both
    And preferences should be saved per type
    And delivery should respect preferences

  @happy-path @notification-preferences
  Scenario: Set notification priority levels
    Given I want to prioritize notifications
    When I set priority levels
    Then high priority should always notify
    And low priority can be batched
    And medium priority follows defaults

  @happy-path @notification-preferences
  Scenario: Reset to default preferences
    Given I have customized preferences
    When I reset to defaults
    Then all settings should return to default
    And I should confirm the reset
    And changes should take effect immediately

  # ============================================================================
  # SCORE ALERTS
  # ============================================================================

  @happy-path @score-alerts
  Scenario: Receive score update notification
    Given my player scores points
    When the score is recorded
    Then I should receive a notification
    And it should show the player and points
    And it should show my new total

  @happy-path @score-alerts
  Scenario: Receive big play alert
    Given a player makes a big play
    When the play is recorded
    Then I should receive an immediate alert
    And it should highlight the achievement
    And it should show the point impact

  @happy-path @score-alerts
  Scenario: Receive lead change alert
    Given I am watching my matchup
    When the lead changes
    Then I should receive a notification
    And it should show the new scores
    And it should indicate who is now winning

  @happy-path @score-alerts
  Scenario: Receive final score notification
    Given my matchup is completing
    When the final score is determined
    Then I should receive the final result
    And it should show win or loss
    And it should show final scores

  @happy-path @score-alerts
  Scenario: Configure score alert thresholds
    Given I want custom score alerts
    When I set point thresholds
    Then I should only be notified above threshold
    And small scoring should not alert
    And thresholds should be saved

  # ============================================================================
  # TRADE ALERTS
  # ============================================================================

  @happy-path @trade-alerts
  Scenario: Receive trade proposal notification
    Given someone sends me a trade
    When the trade is proposed
    Then I should receive a notification
    And it should show trade details
    And I should be able to respond from notification

  @happy-path @trade-alerts
  Scenario: Receive trade accepted notification
    Given my trade offer is accepted
    When the acceptance is recorded
    Then I should receive a notification
    And it should confirm the trade
    And it should show processing timeline

  @happy-path @trade-alerts
  Scenario: Receive trade rejected notification
    Given my trade offer is rejected
    When the rejection is recorded
    Then I should receive a notification
    And it should indicate rejection
    And I can modify and resend

  @happy-path @trade-alerts
  Scenario: Receive trade counter notification
    Given I receive a counter offer
    When the counter is sent
    Then I should receive a notification
    And it should show the counter details
    And I should be able to respond

  @happy-path @trade-alerts
  Scenario: Receive league trade alert
    Given a trade completes in the league
    When the trade processes
    Then I should receive a notification
    And it should show the trade details
    And I should see the teams involved

  # ============================================================================
  # WAIVER ALERTS
  # ============================================================================

  @happy-path @waiver-alerts
  Scenario: Receive waiver claim result notification
    Given I made a waiver claim
    When waivers process
    Then I should receive a notification
    And it should show if claim succeeded
    And it should show the player status

  @happy-path @waiver-alerts
  Scenario: Receive FAAB bid result notification
    Given I made a FAAB bid
    When the auction resolves
    Then I should receive a notification
    And it should show if I won
    And it should show my remaining budget

  @happy-path @waiver-alerts
  Scenario: Receive outbid notification
    Given another manager outbid me
    When the bidding is resolved
    Then I should receive a notification
    And it should show I was outbid
    And it should show the winning bid if allowed

  @happy-path @waiver-alerts
  Scenario: Receive waiver processing reminder
    Given waivers are about to process
    When the reminder time is reached
    Then I should receive a notification
    And it should remind me to submit claims
    And it should show time remaining

  @happy-path @waiver-alerts
  Scenario: Receive hot waiver pickup alert
    Given a highly sought player is added
    When the pickup is processed
    Then I should receive an alert
    And it should show who got the player
    And it should indicate high interest

  # ============================================================================
  # LINEUP REMINDERS
  # ============================================================================

  @happy-path @lineup-reminders
  Scenario: Receive lineup lock reminder
    Given roster lock is approaching
    When the reminder time is reached
    Then I should receive a notification
    And it should show time until lock
    And it should link to lineup page

  @happy-path @lineup-reminders
  Scenario: Receive empty roster spot alert
    Given I have an empty starting position
    When game time approaches
    Then I should receive an alert
    And it should identify the empty spot
    And it should prompt me to set lineup

  @happy-path @lineup-reminders
  Scenario: Receive bye week reminder
    Given I have a starter on bye
    When lineup deadline approaches
    Then I should receive a reminder
    And it should identify the bye player
    And it should suggest replacements

  @happy-path @lineup-reminders
  Scenario: Receive questionable player reminder
    Given a starter is listed as questionable
    When game time approaches
    Then I should receive a notification
    And it should show the player status
    And it should suggest monitoring

  @happy-path @lineup-reminders
  Scenario: Configure reminder timing
    Given I want custom reminder times
    When I set my reminder preferences
    Then I should choose hours before lock
    And reminders should follow my timing
    And I can set multiple reminders

  # ============================================================================
  # GAME START ALERTS
  # ============================================================================

  @happy-path @game-start-alerts
  Scenario: Receive game starting notification
    Given a game involving my players is starting
    When the game begins
    Then I should receive a notification
    And it should show the game and players
    And I should be able to watch

  @happy-path @game-start-alerts
  Scenario: Receive primetime game alert
    Given a primetime game is starting
    When the game begins
    Then I should receive a notification
    And it should highlight the primetime game
    And it should show my relevant players

  @happy-path @game-start-alerts
  Scenario: Receive Thursday night reminder
    Given Thursday Night Football is approaching
    When game time nears
    Then I should receive a reminder
    And it should warn about early lock
    And it should prompt lineup review

  @happy-path @game-start-alerts
  Scenario: Configure game alerts per slot
    Given I want different alerts for different games
    When I configure game slot preferences
    Then I can enable/disable per game slot
    And preferences should be saved
    And alerts should follow preferences

  # ============================================================================
  # INJURY ALERTS
  # ============================================================================

  @happy-path @injury-alerts
  Scenario: Receive injury update notification
    Given my player has an injury update
    When the update is reported
    Then I should receive a notification
    And it should show the injury status
    And it should indicate impact on availability

  @happy-path @injury-alerts
  Scenario: Receive in-game injury alert
    Given my player is injured during a game
    When the injury is reported
    Then I should receive an immediate alert
    And it should show the player and injury
    And it should indicate return status

  @happy-path @injury-alerts
  Scenario: Receive player ruled out notification
    Given my player is ruled out
    When the status is updated
    Then I should receive a notification
    And it should clearly state ruled out
    And it should prompt lineup adjustment

  @happy-path @injury-alerts
  Scenario: Receive player cleared notification
    Given my player was questionable
    When they are cleared to play
    Then I should receive a notification
    And it should confirm availability
    And I can adjust my lineup

  @happy-path @injury-alerts
  Scenario: Configure injury alert sensitivity
    Given I want to customize injury alerts
    When I set alert levels
    Then I can choose which statuses trigger alerts
    And I can set alert timing
    And preferences should be saved

  # ============================================================================
  # NEWS ALERTS
  # ============================================================================

  @happy-path @news-alerts
  Scenario: Receive breaking news for my player
    Given there is breaking news about my player
    When the news is published
    Then I should receive a notification
    And it should summarize the news
    And I should be able to read the full story

  @happy-path @news-alerts
  Scenario: Receive fantasy-relevant news alert
    Given news affects fantasy value
    When the news is analyzed
    Then I should receive an alert
    And it should indicate fantasy impact
    And it should suggest actions

  @happy-path @news-alerts
  Scenario: Receive roster move news
    Given a team makes a roster move
    When it affects my player
    Then I should receive a notification
    And it should explain the impact
    And it should suggest considerations

  @happy-path @news-alerts
  Scenario: Filter news by relevance
    Given I want to limit news alerts
    When I set relevance filters
    Then only high-impact news should alert
    And minor news should not notify
    And filters should be saved

  # ============================================================================
  # COMMISSIONER ANNOUNCEMENTS
  # ============================================================================

  @happy-path @commissioner-announcements
  Scenario: Receive commissioner announcement
    Given the commissioner sends an announcement
    When the announcement is posted
    Then I should receive a notification
    And it should be marked as official
    And the content should be displayed

  @happy-path @commissioner-announcements
  Scenario: Receive urgent commissioner message
    Given the commissioner sends urgent message
    When the message is sent
    Then I should receive high priority notification
    And it should stand out from regular notifications
    And it should demand attention

  @happy-path @commissioner-announcements
  Scenario: Receive league rule change notification
    Given the commissioner changes rules
    When the change is made
    Then I should receive a notification
    And it should explain the change
    And it should show effective date

  @happy-path @commissioner-announcements
  Scenario: Receive draft scheduling notification
    Given the commissioner schedules draft
    When the schedule is set
    Then I should receive a notification
    And it should show date and time
    And it should add to my calendar option

  # ============================================================================
  # NOTIFICATION HISTORY
  # ============================================================================

  @happy-path @notification-history
  Scenario: View notification history
    Given I have received notifications
    When I view notification history
    Then I should see all past notifications
    And they should be sorted by date
    And I should see read/unread status

  @happy-path @notification-history
  Scenario: Search notification history
    Given I am looking for a specific notification
    When I search the history
    Then I should find matching notifications
    And results should be highlighted
    And I can click to view details

  @happy-path @notification-history
  Scenario: Filter history by type
    Given I want specific notification types
    When I filter the history
    Then only that type should show
    And the filter should be clearable
    And counts should update

  @happy-path @notification-history
  Scenario: Clear notification history
    Given I want to clear old notifications
    When I clear history
    Then notifications should be removed
    And I should confirm the action
    And cleared notifications should not return

  @happy-path @notification-history
  Scenario: Export notification history
    Given I want to save my notifications
    When I export history
    Then I should receive a file
    And it should contain notification data
    And the format should be readable

  # ============================================================================
  # QUIET HOURS
  # ============================================================================

  @happy-path @quiet-hours
  Scenario: Configure quiet hours
    Given I want notification-free periods
    When I set quiet hours
    Then I should set start and end times
    And quiet hours should be saved
    And I should see the schedule

  @happy-path @quiet-hours
  Scenario: Notifications muted during quiet hours
    Given quiet hours are active
    When a notification is triggered
    Then it should not make sound
    And it should not show push notification
    And it should be delivered silently

  @happy-path @quiet-hours
  Scenario: Critical notifications bypass quiet hours
    Given quiet hours are active
    When a critical notification triggers
    Then it should still notify me
    And it should be marked as critical
    And bypass should be logged

  @happy-path @quiet-hours
  Scenario: Configure quiet hours by day
    Given I want different hours per day
    When I set daily quiet hours
    Then each day should have its schedule
    And schedules should be independent
    And I can view the full week

  @happy-path @quiet-hours
  Scenario: Temporarily disable quiet hours
    Given quiet hours are configured
    When I need notifications now
    Then I should be able to pause quiet hours
    And they should resume automatically
    And I should see pause status

  # ============================================================================
  # NOTIFICATION CHANNELS CONFIGURATION
  # ============================================================================

  @happy-path @notification-channels
  Scenario: Configure push notification channel
    Given I want to set up push notifications
    When I configure the channel
    Then I should enable or disable push
    And I should set device preferences
    And the channel should be tested

  @happy-path @notification-channels
  Scenario: Configure email notification channel
    Given I want to set up email notifications
    When I configure the channel
    Then I should verify my email
    And I should set email preferences
    And a test email should be sendable

  @happy-path @notification-channels
  Scenario: Configure SMS notification channel
    Given I want SMS notifications
    When I configure SMS
    Then I should verify my phone number
    And I should set SMS preferences
    And a test SMS should be sendable

  @happy-path @notification-channels
  Scenario: Configure in-app notification channel
    Given I want to adjust in-app notifications
    When I configure the channel
    Then I should set toast behavior
    And I should set badge preferences
    And I should set sound preferences

  @happy-path @notification-channels
  Scenario: Test notification channel
    Given I have configured a channel
    When I test the channel
    Then a test notification should be sent
    And I should confirm receipt
    And issues should be reported

  @happy-path @notification-channels
  Scenario: Add secondary email for notifications
    Given I want backup email delivery
    When I add another email
    Then both emails should receive notifications
    And I can set priority between them
    And both should be verified

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Push notification delivery fails
    Given a push notification is triggered
    When delivery fails
    Then the system should retry
    And alternate channels should be tried
    And failure should be logged

  @error
  Scenario: Email notification bounces
    Given an email notification is sent
    When the email bounces
    Then I should be notified of the issue
    And I should be prompted to update email
    And future emails should be paused

  @error
  Scenario: Notification center fails to load
    Given I try to open notifications
    When loading fails
    Then I should see an error message
    And I should be able to retry
    And cached notifications should show

  @error
  Scenario: Preferences fail to save
    Given I am updating preferences
    When saving fails
    Then I should see an error message
    And my changes should be preserved
    And I should be able to retry

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Receive mobile push notification
    Given I have the mobile app
    When a notification is triggered
    Then I should receive a mobile push
    And the notification should be actionable
    And tapping should open the app

  @mobile
  Scenario: View notifications on mobile
    Given I am using the mobile app
    When I view notifications
    Then the layout should be mobile-optimized
    And I should swipe to dismiss
    And I should scroll through history

  @mobile
  Scenario: Configure notifications from mobile
    Given I am on mobile
    When I access notification settings
    Then all settings should be accessible
    And toggles should work on touch
    And changes should save properly

  @mobile
  Scenario: Receive notification with quick reply
    Given I receive a message notification
    When I view on mobile
    Then I should be able to quick reply
    And reply should work from notification
    And the response should be sent

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate notifications with keyboard
    Given I am using keyboard navigation
    When I navigate the notification center
    Then I should tab through notifications
    And I should act with keyboard shortcuts
    And focus should be visible

  @accessibility
  Scenario: Screen reader notification access
    Given I am using a screen reader
    When notifications arrive
    Then they should be announced
    And content should be readable
    And actions should be accessible

  @accessibility
  Scenario: High contrast notification display
    Given I have high contrast mode enabled
    When I view notifications
    Then notifications should be visible
    And read/unread should be distinguishable
    And actions should be clear

  @accessibility
  Scenario: Notification sounds configuration
    Given I need audio alerts
    When I configure notification sounds
    Then I should choose sounds per type
    And volume should be adjustable
    And sounds should be tested
