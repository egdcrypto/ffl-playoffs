@notifications @anima-1393
Feature: Notifications
  As a fantasy football user
  I want comprehensive notification management
  So that I can stay informed about important events

  Background:
    Given I am a logged-in user
    And the notification system is available

  # ============================================================================
  # PUSH NOTIFICATIONS
  # ============================================================================

  @happy-path @push-notifications
  Scenario: Enable push notifications
    Given push is available
    When I enable push notifications
    Then push should be enabled
    And I should receive push alerts

  @happy-path @push-notifications
  Scenario: Disable push notifications
    Given push is enabled
    When I disable push notifications
    Then push should be disabled
    And I should not receive push alerts

  @happy-path @push-notifications
  Scenario: Configure push preferences
    Given push is enabled
    When I configure preferences
    Then preferences should be saved
    And alerts should follow preferences

  @happy-path @push-notifications
  Scenario: Register device for push
    Given I have a new device
    When I register device
    Then device should be registered
    And push should work on device

  @happy-path @push-notifications
  Scenario: Verify push delivery
    Given push is configured
    When a notification is sent
    Then I should receive push
    And notification should display

  @happy-path @push-notifications
  Scenario: Manage multiple devices
    Given I have multiple devices
    When I manage devices
    Then I should see all devices
    And I can configure each

  @happy-path @push-notifications
  Scenario: Remove device from push
    Given device is registered
    When I remove device
    Then device should be unregistered
    And push should stop on that device

  @happy-path @push-notifications
  Scenario: Test push notification
    Given push is configured
    When I send test notification
    Then I should receive test push
    And I can verify delivery

  @happy-path @push-notifications
  Scenario: View push history
    Given push history exists
    When I view push history
    Then I should see past push notifications
    And delivery status should be shown

  @happy-path @push-notifications
  Scenario: Configure push sound
    Given push is enabled
    When I configure sound
    Then sound preference should be saved
    And notifications should use that sound

  # ============================================================================
  # EMAIL NOTIFICATIONS
  # ============================================================================

  @happy-path @email-notifications
  Scenario: Enable email alerts
    Given email is available
    When I enable email alerts
    Then email should be enabled
    And I should receive email notifications

  @happy-path @email-notifications
  Scenario: Set email frequency
    Given email is enabled
    When I set frequency
    Then frequency should be saved
    And emails should follow schedule

  @happy-path @email-notifications
  Scenario: Configure email preferences
    Given email is enabled
    When I configure preferences
    Then preferences should be saved
    And emails should follow preferences

  @happy-path @email-notifications
  Scenario: Unsubscribe from emails
    Given I receive emails
    When I unsubscribe
    Then I should be unsubscribed
    And emails should stop

  @happy-path @email-notifications
  Scenario: View email templates
    Given templates exist
    When I view templates
    Then I should see available templates
    And preview should be shown

  @happy-path @email-notifications
  Scenario: Update email address
    Given I have email configured
    When I update email address
    Then new address should be saved
    And emails should go to new address

  @happy-path @email-notifications
  Scenario: Verify email address
    Given I entered new email
    When I verify email
    Then email should be verified
    And notifications should be enabled

  @happy-path @email-notifications
  Scenario: Set email digest
    Given I want summary emails
    When I set digest preferences
    Then digest should be configured
    And I should receive digests

  @happy-path @email-notifications
  Scenario: Resubscribe to emails
    Given I previously unsubscribed
    When I resubscribe
    Then emails should resume
    And preferences should be restored

  @happy-path @email-notifications
  Scenario: View email history
    Given emails have been sent
    When I view email history
    Then I should see past emails
    And I can resend if needed

  # ============================================================================
  # IN-APP NOTIFICATIONS
  # ============================================================================

  @happy-path @in-app-notifications
  Scenario: View notification center
    Given notifications exist
    When I open notification center
    Then I should see all notifications
    And they should be organized

  @happy-path @in-app-notifications
  Scenario: View notification badges
    Given unread notifications exist
    When I view the app
    Then I should see badge count
    And count should be accurate

  @happy-path @in-app-notifications
  Scenario: Mark notification as read
    Given unread notification exists
    When I mark as read
    Then notification should be read
    And badge should update

  @happy-path @in-app-notifications
  Scenario: Mark all as read
    Given multiple unread exist
    When I mark all as read
    Then all should be marked read
    And badge should clear

  @happy-path @in-app-notifications
  Scenario: View notification history
    Given notifications have occurred
    When I view history
    Then I should see all past notifications
    And timeline should be clear

  @happy-path @in-app-notifications
  Scenario: Clear notifications
    Given notifications exist
    When I clear notifications
    Then notifications should be cleared
    And center should be empty

  @happy-path @in-app-notifications
  Scenario: Filter notifications
    Given notifications exist
    When I filter by type
    Then I should see filtered notifications
    And filter should apply

  @happy-path @in-app-notifications
  Scenario: Click notification to navigate
    Given actionable notification exists
    When I click notification
    Then I should navigate to relevant page
    And notification should mark as read

  @happy-path @in-app-notifications
  Scenario: Dismiss notification
    Given notification is displayed
    When I dismiss notification
    Then notification should be dismissed
    And it should not reappear

  @happy-path @in-app-notifications
  Scenario: View notification details
    Given notification exists
    When I view details
    Then I should see full details
    And actions should be available

  # ============================================================================
  # NOTIFICATION SETTINGS
  # ============================================================================

  @happy-path @notification-settings
  Scenario: Configure notification preferences
    Given I have preferences
    When I configure preferences
    Then preferences should be saved
    And notifications should follow them

  @happy-path @notification-settings
  Scenario: Set quiet hours
    Given I want quiet time
    When I set quiet hours
    Then quiet hours should be saved
    And no notifications during quiet time

  @happy-path @notification-settings
  Scenario: Enable do not disturb
    Given I need focus time
    When I enable DND
    Then DND should be active
    And notifications should be silenced

  @happy-path @notification-settings
  Scenario: Configure notification sounds
    Given sounds are available
    When I configure sounds
    Then sound preferences should be saved
    And notifications should use selected sounds

  @happy-path @notification-settings
  Scenario: Configure vibration settings
    Given vibration is available
    When I configure vibration
    Then vibration should be set
    And notifications should vibrate accordingly

  @happy-path @notification-settings
  Scenario: Set notification priority
    Given priorities exist
    When I set priority levels
    Then priorities should be saved
    And high priority should override DND

  @happy-path @notification-settings
  Scenario: Configure per-league settings
    Given I have multiple leagues
    When I configure per-league
    Then settings should be league-specific
    And each league should follow its settings

  @happy-path @notification-settings
  Scenario: Reset to default settings
    Given I have custom settings
    When I reset to defaults
    Then defaults should be restored
    And I should confirm first

  @happy-path @notification-settings
  Scenario: Export notification settings
    Given settings are configured
    When I export settings
    Then settings should be exported
    And I can import elsewhere

  @happy-path @notification-settings
  Scenario: Import notification settings
    Given I have settings file
    When I import settings
    Then settings should be applied
    And I should review before saving

  # ============================================================================
  # GAME ALERTS
  # ============================================================================

  @happy-path @game-alerts
  Scenario: Receive game start alert
    Given game is about to start
    When game time arrives
    Then I should receive start alert
    And game info should be shown

  @happy-path @game-alerts
  Scenario: Receive scoring alert
    Given my player scores
    When scoring occurs
    Then I should receive scoring alert
    And points should be shown

  @happy-path @game-alerts
  Scenario: Receive injury alert
    Given my player gets injured
    When injury occurs during game
    Then I should receive injury alert
    And status should be shown

  @happy-path @game-alerts
  Scenario: Receive lineup lock alert
    Given lock time approaches
    When lock threshold reached
    Then I should receive lock alert
    And time remaining should be shown

  @happy-path @game-alerts
  Scenario: Receive game end alert
    Given game is finishing
    When game ends
    Then I should receive end alert
    And final score should be shown

  @happy-path @game-alerts
  Scenario: Configure game alert timing
    Given I have preferences
    When I configure timing
    Then timing should be saved
    And alerts should follow timing

  @happy-path @game-alerts
  Scenario: Receive halftime alert
    Given game is at halftime
    When halftime arrives
    Then I should receive halftime alert
    And stats should be shown

  @happy-path @game-alerts
  Scenario: Receive close game alert
    Given matchup is close
    When threshold reached
    Then I should receive close game alert
    And margin should be shown

  @happy-path @game-alerts
  Scenario: Receive big play alert
    Given significant play occurs
    When play is recorded
    Then I should receive big play alert
    And play details should be shown

  @happy-path @game-alerts
  Scenario: Disable game alerts
    Given I receive too many
    When I disable game alerts
    Then alerts should stop
    And I can re-enable later

  # ============================================================================
  # TRADE NOTIFICATIONS
  # ============================================================================

  @happy-path @trade-notifications
  Scenario: Receive trade offer notification
    Given someone sends trade offer
    When offer is received
    Then I should be notified
    And offer details should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade accepted notification
    Given my trade is accepted
    When acceptance occurs
    Then I should be notified
    And trade details should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade rejected notification
    Given my trade is rejected
    When rejection occurs
    Then I should be notified
    And rejection should be explained

  @happy-path @trade-notifications
  Scenario: Receive counter offer notification
    Given counter offer is made
    When counter is received
    Then I should be notified
    And counter details should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade deadline alert
    Given deadline approaches
    When threshold reached
    Then I should receive deadline alert
    And time remaining should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade veto notification
    Given trade is vetoed
    When veto occurs
    Then I should be notified
    And veto reason should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade processing notification
    Given trade is processing
    When trade processes
    Then I should be notified
    And status should be shown

  @happy-path @trade-notifications
  Scenario: Receive trade expiration warning
    Given offer is expiring
    When expiration approaches
    Then I should be warned
    And time remaining should be shown

  @happy-path @trade-notifications
  Scenario: Configure trade alert preferences
    Given I have preferences
    When I configure trade alerts
    Then preferences should be saved
    And alerts should follow preferences

  @happy-path @trade-notifications
  Scenario: Receive league trade notification
    Given trade occurs in league
    When trade is completed
    Then all members should be notified
    And trade details should be shown

  # ============================================================================
  # WAIVER NOTIFICATIONS
  # ============================================================================

  @happy-path @waiver-notifications
  Scenario: Receive waiver claim result
    Given I made a claim
    When claims are processed
    Then I should be notified of result
    And outcome should be clear

  @happy-path @waiver-notifications
  Scenario: Receive outbid alert
    Given someone outbid me
    When outbid occurs
    Then I should be notified
    And bid details should be shown

  @happy-path @waiver-notifications
  Scenario: Receive waiver processing notification
    Given waivers are processing
    When processing completes
    Then I should be notified
    And results should be shown

  @happy-path @waiver-notifications
  Scenario: Receive claim deadline alert
    Given deadline approaches
    When threshold reached
    Then I should receive deadline alert
    And time remaining should be shown

  @happy-path @waiver-notifications
  Scenario: Receive priority update notification
    Given my priority changes
    When priority is updated
    Then I should be notified
    And new priority should be shown

  @happy-path @waiver-notifications
  Scenario: Receive successful claim notification
    Given my claim succeeded
    When player is added
    Then I should be notified
    And player details should be shown

  @happy-path @waiver-notifications
  Scenario: Receive failed claim notification
    Given my claim failed
    When processing completes
    Then I should be notified
    And failure reason should be shown

  @happy-path @waiver-notifications
  Scenario: Receive FAAB budget alert
    Given budget is low
    When threshold reached
    Then I should be alerted
    And remaining budget should be shown

  @happy-path @waiver-notifications
  Scenario: Configure waiver alert preferences
    Given I have preferences
    When I configure waiver alerts
    Then preferences should be saved
    And alerts should follow preferences

  @happy-path @waiver-notifications
  Scenario: Receive waiver wire activity notification
    Given significant activity occurs
    When activity is recorded
    Then I should be notified
    And activity summary should be shown

  # ============================================================================
  # LEAGUE NOTIFICATIONS
  # ============================================================================

  @happy-path @league-notifications
  Scenario: Receive commissioner message
    Given commissioner sends message
    When message is sent
    Then I should be notified
    And message should be shown

  @happy-path @league-notifications
  Scenario: Receive league announcement
    Given announcement is made
    When announcement is posted
    Then I should be notified
    And announcement should be shown

  @happy-path @league-notifications
  Scenario: Receive rule change notification
    Given rules are changed
    When change is made
    Then I should be notified
    And changes should be explained

  @happy-path @league-notifications
  Scenario: Receive member activity notification
    Given member does something notable
    When activity occurs
    Then league should be notified
    And activity should be shown

  @happy-path @league-notifications
  Scenario: Receive league event notification
    Given event is scheduled
    When event approaches
    Then I should be notified
    And event details should be shown

  @happy-path @league-notifications
  Scenario: Receive new member notification
    Given someone joins league
    When they join
    Then I should be notified
    And member info should be shown

  @happy-path @league-notifications
  Scenario: Receive draft reminder
    Given draft approaches
    When reminder threshold reached
    Then I should be reminded
    And draft details should be shown

  @happy-path @league-notifications
  Scenario: Receive payment reminder
    Given payment is due
    When reminder threshold reached
    Then I should be reminded
    And payment details should be shown

  @happy-path @league-notifications
  Scenario: Receive season start notification
    Given season is starting
    When season begins
    Then I should be notified
    And season details should be shown

  @happy-path @league-notifications
  Scenario: Configure league notification preferences
    Given I have preferences
    When I configure league alerts
    Then preferences should be saved
    And alerts should follow preferences

  # ============================================================================
  # PLAYER ALERTS
  # ============================================================================

  @happy-path @player-alerts
  Scenario: Receive player news alert
    Given player has news
    When news is published
    Then I should be alerted
    And news should be shown

  @happy-path @player-alerts
  Scenario: Receive injury update alert
    Given player injury status changes
    When update is made
    Then I should be alerted
    And new status should be shown

  @happy-path @player-alerts
  Scenario: Receive status change alert
    Given player status changes
    When change occurs
    Then I should be alerted
    And new status should be shown

  @happy-path @player-alerts
  Scenario: Receive breakout alert
    Given player has breakout game
    When performance is notable
    Then I should be alerted
    And stats should be shown

  @happy-path @player-alerts
  Scenario: Receive watchlist alert
    Given player is on my watchlist
    When something happens
    Then I should be alerted
    And update should be shown

  @happy-path @player-alerts
  Scenario: Receive availability alert
    Given player becomes available
    When availability changes
    Then I should be alerted
    And I can take action

  @happy-path @player-alerts
  Scenario: Receive trade rumor alert
    Given trade rumors exist
    When rumor is published
    Then I should be alerted
    And rumor should be shown

  @happy-path @player-alerts
  Scenario: Receive practice report alert
    Given practice report is released
    When report is published
    Then I should be alerted
    And report should be shown

  @happy-path @player-alerts
  Scenario: Configure player alert preferences
    Given I have preferences
    When I configure player alerts
    Then preferences should be saved
    And alerts should follow preferences

  @happy-path @player-alerts
  Scenario: Receive depth chart change alert
    Given depth chart changes
    When change is made
    Then I should be alerted
    And change should be shown

  # ============================================================================
  # CUSTOM NOTIFICATIONS
  # ============================================================================

  @happy-path @custom-notifications
  Scenario: Create custom alert rule
    Given I want custom alerts
    When I create alert rule
    Then rule should be saved
    And alerts should trigger accordingly

  @happy-path @custom-notifications
  Scenario: Set threshold alert
    Given I want threshold notification
    When I set threshold
    Then threshold should be saved
    And alert should trigger at threshold

  @happy-path @custom-notifications
  Scenario: Set player-specific alert
    Given I want alerts for specific player
    When I configure player alert
    Then alert should be saved
    And I should be notified about that player

  @happy-path @custom-notifications
  Scenario: Set matchup alert
    Given I want matchup notifications
    When I configure matchup alert
    Then alert should be saved
    And I should receive matchup alerts

  @happy-path @custom-notifications
  Scenario: Set stat milestone alert
    Given I want milestone notifications
    When I configure milestone alert
    Then alert should be saved
    And I should be notified at milestones

  @happy-path @custom-notifications
  Scenario: Edit custom alert
    Given custom alert exists
    When I edit the alert
    Then changes should be saved
    And alert should behave accordingly

  @happy-path @custom-notifications
  Scenario: Delete custom alert
    Given custom alert exists
    When I delete the alert
    Then alert should be removed
    And I should not receive those notifications

  @happy-path @custom-notifications
  Scenario: Duplicate custom alert
    Given custom alert exists
    When I duplicate the alert
    Then copy should be created
    And I can modify the copy

  @happy-path @custom-notifications
  Scenario: View custom alert history
    Given custom alerts have triggered
    When I view history
    Then I should see triggered alerts
    And timeline should be shown

  @happy-path @custom-notifications
  Scenario: Share custom alert rules
    Given I have useful rules
    When I share rules
    Then rules should be shareable
    And others can use them

