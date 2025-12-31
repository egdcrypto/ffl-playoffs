@settings @anima-1365
Feature: Settings
  As a fantasy football user
  I want to manage my account and application settings
  So that I can customize my experience and control my data

  Background:
    Given I am a logged-in user
    And I have access to the settings page

  # ============================================================================
  # ACCOUNT SETTINGS
  # ============================================================================

  @happy-path @account-settings
  Scenario: View account profile information
    Given I am on the account settings page
    Then I should see my profile information
    And I should see my display name and avatar

  @happy-path @account-settings
  Scenario: Update profile information
    Given I am on the account settings page
    When I update my profile information
    And I save the changes
    Then my profile should be updated
    And I should see confirmation

  @happy-path @account-settings
  Scenario: Change email address
    Given I am on the account settings page
    When I enter a new email address
    And I verify the new email
    Then my email should be updated
    And I should receive confirmation at both addresses

  @happy-path @account-settings
  Scenario: Change password
    Given I am on the account settings page
    When I enter my current password
    And I enter a new password
    And I confirm the new password
    Then my password should be updated
    And I should see confirmation

  @happy-path @account-settings
  Scenario: Update phone number
    Given I am on the account settings page
    When I enter a new phone number
    And I verify the phone number
    Then my phone number should be updated

  @happy-path @account-settings
  Scenario: Link external account
    Given I am on the account settings page
    When I link an external account
    Then the account should be connected
    And I should see the linked account

  @happy-path @account-settings
  Scenario: Unlink external account
    Given I have a linked external account
    When I unlink the account
    Then the account should be disconnected
    And I should see confirmation

  @error @account-settings
  Scenario: Attempt to change password with wrong current password
    Given I am on the account settings page
    When I enter an incorrect current password
    Then I should see an error message
    And my password should not be changed

  @error @account-settings
  Scenario: Attempt to use invalid email format
    Given I am on the account settings page
    When I enter an invalid email format
    Then I should see a validation error
    And the email should not be saved

  # ============================================================================
  # PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy-settings
  Scenario: Configure profile visibility
    Given I am on the privacy settings page
    When I set my profile visibility
    Then I should choose public, friends, or private
    And the setting should be saved

  @happy-path @privacy-settings
  Scenario: Configure data sharing preferences
    Given I am on the privacy settings page
    When I configure data sharing
    Then I should enable or disable data sharing
    And my preference should be saved

  @happy-path @privacy-settings
  Scenario: Set activity visibility
    Given I am on the privacy settings page
    When I configure activity visibility
    Then I should choose who can see my activity
    And the setting should be applied

  @happy-path @privacy-settings
  Scenario: Configure search visibility
    Given I am on the privacy settings page
    When I set search visibility
    Then I should appear or not appear in searches
    And my preference should be saved

  @happy-path @privacy-settings
  Scenario: View privacy policy
    Given I am on the privacy settings page
    When I view the privacy policy
    Then I should see the full privacy policy
    And I should be able to download it

  @happy-path @privacy-settings
  Scenario: Manage cookie preferences
    Given I am on the privacy settings page
    When I manage cookie preferences
    Then I should see cookie categories
    And I should be able to accept or reject each

  @happy-path @privacy-settings
  Scenario: Request personal data report
    Given I am on the privacy settings page
    When I request my personal data
    Then a data report should be generated
    And I should receive it via email

  # ============================================================================
  # DISPLAY SETTINGS
  # ============================================================================

  @happy-path @display-settings
  Scenario: Select application theme
    Given I am on the display settings page
    When I select a theme
    Then the theme should be applied
    And the setting should persist

  @happy-path @display-settings
  Scenario: Enable dark mode
    Given I am on the display settings page
    When I enable dark mode
    Then the app should switch to dark mode
    And my preference should be saved

  @happy-path @display-settings
  Scenario: Disable dark mode
    Given dark mode is enabled
    When I disable dark mode
    Then the app should switch to light mode
    And my preference should be saved

  @happy-path @display-settings
  Scenario: Set automatic dark mode
    Given I am on the display settings page
    When I enable automatic dark mode
    Then the app should follow system settings
    And transitions should be smooth

  @happy-path @display-settings
  Scenario: Configure layout preferences
    Given I am on the display settings page
    When I set layout preferences
    Then the layout should adjust accordingly
    And my preference should be saved

  @happy-path @display-settings
  Scenario: Adjust font size
    Given I am on the display settings page
    When I adjust the font size
    Then text should resize throughout the app
    And readability should be maintained

  @happy-path @display-settings
  Scenario: Customize color scheme
    Given I am on the display settings page
    When I customize the color scheme
    Then the colors should be applied
    And the scheme should be saved

  @happy-path @display-settings
  Scenario: Preview display changes
    Given I am making display changes
    When I preview the changes
    Then I should see how the app will look
    And I can confirm or cancel

  # ============================================================================
  # NOTIFICATION SETTINGS
  # ============================================================================

  @happy-path @notification-settings
  Scenario: Configure push notification preferences
    Given I am on the notification settings page
    When I configure push preferences
    Then I should enable or disable push types
    And my preferences should be saved

  @happy-path @notification-settings
  Scenario: Configure email notification preferences
    Given I am on the notification settings page
    When I configure email preferences
    Then I should set email notification types
    And my preferences should be saved

  @happy-path @notification-settings
  Scenario: Configure in-app notification preferences
    Given I am on the notification settings page
    When I configure in-app preferences
    Then I should set which in-app notifications to show
    And my preferences should be saved

  @happy-path @notification-settings
  Scenario: Set notification frequency
    Given I am on the notification settings page
    When I set notification frequency
    Then I should choose immediate, daily, or weekly
    And the frequency should be applied

  @happy-path @notification-settings
  Scenario: Configure quiet hours
    Given I am on the notification settings page
    When I set quiet hours
    Then notifications should be muted during those hours
    And the setting should be saved

  @happy-path @notification-settings
  Scenario: Test notification delivery
    Given I am on the notification settings page
    When I send a test notification
    Then I should receive a test notification
    And delivery should be confirmed

  # ============================================================================
  # LEAGUE SETTINGS
  # ============================================================================

  @happy-path @league-settings
  Scenario: Set default league
    Given I have multiple leagues
    When I set a default league
    Then that league should be shown by default
    And the setting should be saved

  @happy-path @league-settings
  Scenario: Configure scoring display format
    Given I am on the league settings page
    When I set scoring display format
    Then scores should display in that format
    And the preference should persist

  @happy-path @league-settings
  Scenario: Set timezone preference
    Given I am on the league settings page
    When I select my timezone
    Then all times should display in that timezone
    And the setting should be saved

  @happy-path @league-settings
  Scenario: Configure date format
    Given I am on the league settings page
    When I set date format preference
    Then dates should display in that format
    And the preference should persist

  @happy-path @league-settings
  Scenario: Set default scoring format
    Given I am on the league settings page
    When I set default scoring format
    Then projections should use that format
    And the setting should be saved

  @happy-path @league-settings
  Scenario: Configure league sort order
    Given I am on the league settings page
    When I set league sort preference
    Then leagues should be ordered accordingly
    And the preference should persist

  # ============================================================================
  # MOBILE SETTINGS
  # ============================================================================

  @happy-path @mobile-settings
  Scenario: Manage app permissions
    Given I am on the mobile settings page
    When I manage app permissions
    Then I should see all permission requests
    And I should be able to grant or revoke

  @happy-path @mobile-settings
  Scenario: Configure data usage preferences
    Given I am on the mobile settings page
    When I configure data usage
    Then I should set cellular data preferences
    And my preference should be saved

  @happy-path @mobile-settings
  Scenario: Enable offline mode
    Given I am on the mobile settings page
    When I enable offline mode
    Then essential data should be cached
    And the app should work offline

  @happy-path @mobile-settings
  Scenario: Disable offline mode
    Given offline mode is enabled
    When I disable offline mode
    Then cached data should be cleared
    And the app should require connectivity

  @happy-path @mobile-settings
  Scenario: Configure sync preferences
    Given I am on the mobile settings page
    When I configure sync settings
    Then I should set sync frequency
    And I should choose what to sync

  @happy-path @mobile-settings
  Scenario: Clear cached data
    Given I am on the mobile settings page
    When I clear cached data
    Then all cached data should be removed
    And I should see confirmation

  @mobile @mobile-settings
  Scenario: Access mobile settings on device
    Given I am on a mobile device
    When I access mobile settings
    Then settings should be touch-friendly
    And all options should be accessible

  # ============================================================================
  # SECURITY SETTINGS
  # ============================================================================

  @happy-path @security-settings
  Scenario: Enable two-factor authentication
    Given I am on the security settings page
    When I enable two-factor authentication
    And I verify with my phone
    Then 2FA should be enabled
    And I should receive backup codes

  @happy-path @security-settings
  Scenario: Disable two-factor authentication
    Given two-factor authentication is enabled
    When I disable 2FA
    And I confirm with my password
    Then 2FA should be disabled

  @happy-path @security-settings
  Scenario: View active sessions
    Given I am on the security settings page
    When I view session management
    Then I should see all active sessions
    And I should see device and location info

  @happy-path @security-settings
  Scenario: Terminate specific session
    Given I have multiple active sessions
    When I terminate a session
    Then that session should be ended
    And the device should be logged out

  @happy-path @security-settings
  Scenario: Terminate all other sessions
    Given I have multiple active sessions
    When I terminate all other sessions
    Then only my current session should remain
    And other devices should be logged out

  @happy-path @security-settings
  Scenario: View login history
    Given I am on the security settings page
    When I view login history
    Then I should see recent login attempts
    And I should see success and failure status

  @happy-path @security-settings
  Scenario: Manage trusted devices
    Given I am on the security settings page
    When I manage trusted devices
    Then I should see trusted devices list
    And I should be able to remove devices

  @happy-path @security-settings
  Scenario: Generate new backup codes
    Given 2FA is enabled
    When I generate new backup codes
    Then I should receive new backup codes
    And old codes should be invalidated

  # ============================================================================
  # DATA MANAGEMENT
  # ============================================================================

  @happy-path @data-management
  Scenario: Export personal data
    Given I am on the data management page
    When I request data export
    Then my data should be packaged
    And I should receive a download link

  @happy-path @data-management
  Scenario: Request account deletion
    Given I am on the data management page
    When I request account deletion
    And I confirm my decision
    Then a deletion request should be submitted
    And I should see the deletion timeline

  @happy-path @data-management
  Scenario: Cancel account deletion
    Given I have a pending deletion request
    When I cancel the deletion
    Then my account should be preserved
    And I should see confirmation

  @happy-path @data-management
  Scenario: Configure data retention preferences
    Given I am on the data management page
    When I set data retention preferences
    Then my preferences should be saved
    And data should follow retention rules

  @happy-path @data-management
  Scenario: Create data backup
    Given I am on the data management page
    When I create a backup
    Then my data should be backed up
    And I should see backup status

  @happy-path @data-management
  Scenario: Restore from backup
    Given I have a data backup
    When I restore from backup
    Then my data should be restored
    And I should see restoration status

  @happy-path @data-management
  Scenario: View data usage summary
    Given I am on the data management page
    When I view data usage
    Then I should see how my data is used
    And I should see storage information

  # ============================================================================
  # ACCESSIBILITY SETTINGS
  # ============================================================================

  @happy-path @accessibility-settings
  Scenario: Enable screen reader optimizations
    Given I am on the accessibility settings page
    When I enable screen reader mode
    Then the app should optimize for screen readers
    And all elements should be labeled

  @happy-path @accessibility-settings
  Scenario: Enable high contrast mode
    Given I am on the accessibility settings page
    When I enable high contrast
    Then the app should use high contrast colors
    And text should be more visible

  @happy-path @accessibility-settings
  Scenario: Enable reduced motion
    Given I am on the accessibility settings page
    When I enable reduced motion
    Then animations should be minimized
    And transitions should be simpler

  @happy-path @accessibility-settings
  Scenario: Configure keyboard navigation
    Given I am on the accessibility settings page
    When I configure keyboard settings
    Then keyboard navigation should be enhanced
    And focus indicators should be visible

  @happy-path @accessibility-settings
  Scenario: Set text scaling
    Given I am on the accessibility settings page
    When I set text scaling
    Then text should scale accordingly
    And layout should adapt

  @happy-path @accessibility-settings
  Scenario: Enable focus highlights
    Given I am on the accessibility settings page
    When I enable focus highlights
    Then focused elements should be clearly visible
    And navigation should be easier

  @accessibility @accessibility-settings
  Scenario: Navigate settings with keyboard only
    Given I am using keyboard navigation
    When I navigate through settings
    Then all settings should be reachable
    And focus order should be logical

  # ============================================================================
  # INTEGRATION SETTINGS
  # ============================================================================

  @happy-path @integration-settings
  Scenario: Generate API access token
    Given I am on the integration settings page
    When I generate an API token
    Then a new token should be created
    And I should see the token once

  @happy-path @integration-settings
  Scenario: Revoke API access token
    Given I have an API token
    When I revoke the token
    Then the token should be invalidated
    And API access should stop working

  @happy-path @integration-settings
  Scenario: View connected third-party apps
    Given I am on the integration settings page
    When I view connected apps
    Then I should see all connected applications
    And I should see their permissions

  @happy-path @integration-settings
  Scenario: Disconnect third-party app
    Given I have a connected third-party app
    When I disconnect the app
    Then the app should lose access
    And I should see confirmation

  @happy-path @integration-settings
  Scenario: Configure connected services
    Given I am on the integration settings page
    When I configure a connected service
    Then I should set service preferences
    And the configuration should be saved

  @happy-path @integration-settings
  Scenario: Set up webhook
    Given I am on the integration settings page
    When I configure a webhook
    And I provide a webhook URL
    Then the webhook should be registered
    And test events should be sendable

  @happy-path @integration-settings
  Scenario: View webhook delivery history
    Given I have webhooks configured
    When I view webhook history
    Then I should see delivery attempts
    And I should see success or failure status

  @happy-path @integration-settings
  Scenario: Delete webhook
    Given I have a webhook configured
    When I delete the webhook
    Then the webhook should be removed
    And events should stop sending

  @error @integration-settings
  Scenario: Handle invalid webhook URL
    Given I am configuring a webhook
    When I enter an invalid URL
    Then I should see a validation error
    And the webhook should not be saved
