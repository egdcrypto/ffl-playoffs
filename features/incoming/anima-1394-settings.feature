@settings @anima-1394
Feature: Settings
  As a fantasy football user
  I want comprehensive settings management
  So that I can customize my experience and manage my account

  Background:
    Given I am a logged-in user
    And the settings system is available

  # ============================================================================
  # ACCOUNT SETTINGS
  # ============================================================================

  @happy-path @account-settings
  Scenario: View account info
    Given I have an account
    When I view account info
    Then I should see my account details
    And all info should be displayed

  @happy-path @account-settings
  Scenario: Update account info
    Given I want to update info
    When I update account details
    Then changes should be saved
    And confirmation should be shown

  @happy-path @account-settings
  Scenario: Update email settings
    Given I have email configured
    When I update email settings
    Then settings should be saved
    And email should be verified

  @happy-path @account-settings
  Scenario: Change password
    Given I want to change password
    When I change my password
    Then password should be updated
    And I should confirm old password

  @happy-path @account-settings
  Scenario: Enable two-factor auth
    Given 2FA is available
    When I enable 2FA
    Then 2FA should be enabled
    And backup codes should be provided

  @happy-path @account-settings
  Scenario: Disable two-factor auth
    Given 2FA is enabled
    When I disable 2FA
    Then 2FA should be disabled
    And I should confirm with password

  @happy-path @account-settings
  Scenario: Request account deletion
    Given I want to delete account
    When I request deletion
    Then deletion should be scheduled
    And I should receive confirmation

  @happy-path @account-settings
  Scenario: Cancel account deletion
    Given deletion is scheduled
    When I cancel deletion
    Then deletion should be cancelled
    And account should remain active

  @happy-path @account-settings
  Scenario: Update username
    Given I want new username
    When I update username
    Then username should be changed
    And it should be unique

  @happy-path @account-settings
  Scenario: View account activity
    Given activity is tracked
    When I view account activity
    Then I should see activity log
    And timestamps should be shown

  # ============================================================================
  # DISPLAY SETTINGS
  # ============================================================================

  @happy-path @display-settings
  Scenario: Select theme
    Given themes are available
    When I select a theme
    Then theme should be applied
    And UI should reflect theme

  @happy-path @display-settings
  Scenario: Enable dark mode
    Given dark mode is available
    When I enable dark mode
    Then dark mode should be active
    And UI should be dark

  @happy-path @display-settings
  Scenario: Disable dark mode
    Given dark mode is enabled
    When I disable dark mode
    Then light mode should be active
    And UI should be light

  @happy-path @display-settings
  Scenario: Adjust font size
    Given font options exist
    When I adjust font size
    Then font size should change
    And readability should improve

  @happy-path @display-settings
  Scenario: Set layout preferences
    Given layout options exist
    When I set layout preference
    Then layout should be applied
    And pages should reflect layout

  @happy-path @display-settings
  Scenario: Choose color scheme
    Given color schemes exist
    When I choose color scheme
    Then colors should be applied
    And UI should reflect colors

  @happy-path @display-settings
  Scenario: Set auto dark mode
    Given auto mode is available
    When I enable auto dark mode
    Then mode should follow system
    And switch should be automatic

  @happy-path @display-settings
  Scenario: Preview theme changes
    Given I am selecting theme
    When I preview theme
    Then I should see preview
    And I can apply or cancel

  @happy-path @display-settings
  Scenario: Reset display settings
    Given I have custom settings
    When I reset display settings
    Then defaults should be restored
    And I should confirm first

  @happy-path @display-settings
  Scenario: Save display preferences
    Given I have preferences
    When I save preferences
    Then preferences should be saved
    And applied across devices

  # ============================================================================
  # PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy-settings
  Scenario: Set profile visibility
    Given visibility options exist
    When I set profile visibility
    Then visibility should be saved
    And profile should follow setting

  @happy-path @privacy-settings
  Scenario: Configure activity sharing
    Given sharing options exist
    When I configure sharing
    Then sharing should be saved
    And activity should follow setting

  @happy-path @privacy-settings
  Scenario: Manage data sharing
    Given data sharing options exist
    When I manage data sharing
    Then settings should be saved
    And data should follow preferences

  @happy-path @privacy-settings
  Scenario: Set search visibility
    Given search options exist
    When I set search visibility
    Then visibility should be saved
    And search should respect setting

  @happy-path @privacy-settings
  Scenario: Block user
    Given I want to block someone
    When I block a user
    Then user should be blocked
    And they cannot contact me

  @happy-path @privacy-settings
  Scenario: Unblock user
    Given user is blocked
    When I unblock user
    Then user should be unblocked
    And they can contact me again

  @happy-path @privacy-settings
  Scenario: View blocked users
    Given I have blocked users
    When I view blocked list
    Then I should see all blocked users
    And I can manage the list

  @happy-path @privacy-settings
  Scenario: Hide online status
    Given status is visible
    When I hide online status
    Then status should be hidden
    And others cannot see when I'm online

  @happy-path @privacy-settings
  Scenario: Export privacy settings
    Given settings are configured
    When I export settings
    Then settings should be exported
    And I can review them

  @happy-path @privacy-settings
  Scenario: View privacy policy
    Given privacy policy exists
    When I view privacy policy
    Then I should see the policy
    And it should be current

  # ============================================================================
  # APP PREFERENCES
  # ============================================================================

  @happy-path @app-preferences
  Scenario: Set default view
    Given view options exist
    When I set default view
    Then default should be saved
    And app should open to that view

  @happy-path @app-preferences
  Scenario: Customize homepage
    Given customization is available
    When I customize homepage
    Then customization should be saved
    And homepage should reflect changes

  @happy-path @app-preferences
  Scenario: Configure widget settings
    Given widgets are available
    When I configure widgets
    Then widget settings should be saved
    And widgets should behave accordingly

  @happy-path @app-preferences
  Scenario: Set dashboard layout
    Given layout options exist
    When I set dashboard layout
    Then layout should be saved
    And dashboard should reflect layout

  @happy-path @app-preferences
  Scenario: Configure quick actions
    Given quick actions are available
    When I configure quick actions
    Then actions should be saved
    And I can use them quickly

  @happy-path @app-preferences
  Scenario: Set default league
    Given I have multiple leagues
    When I set default league
    Then default should be saved
    And app should show that league first

  @happy-path @app-preferences
  Scenario: Configure startup behavior
    Given startup options exist
    When I configure startup
    Then settings should be saved
    And app should follow settings

  @happy-path @app-preferences
  Scenario: Set refresh preferences
    Given refresh options exist
    When I set refresh preferences
    Then preferences should be saved
    And data should refresh accordingly

  @happy-path @app-preferences
  Scenario: Configure tooltips
    Given tooltip options exist
    When I configure tooltips
    Then settings should be saved
    And tooltips should behave accordingly

  @happy-path @app-preferences
  Scenario: Reset app preferences
    Given I have custom preferences
    When I reset preferences
    Then defaults should be restored
    And I should confirm first

  # ============================================================================
  # LANGUAGE SETTINGS
  # ============================================================================

  @happy-path @language-settings
  Scenario: Select language
    Given languages are available
    When I select a language
    Then language should be applied
    And UI should be in that language

  @happy-path @language-settings
  Scenario: Set region
    Given regions are available
    When I set region
    Then region should be saved
    And content should be localized

  @happy-path @language-settings
  Scenario: Set date format
    Given date formats exist
    When I set date format
    Then format should be saved
    And dates should display accordingly

  @happy-path @language-settings
  Scenario: Set time format
    Given time formats exist
    When I set time format
    Then format should be saved
    And times should display accordingly

  @happy-path @language-settings
  Scenario: Set number format
    Given number formats exist
    When I set number format
    Then format should be saved
    And numbers should display accordingly

  @happy-path @language-settings
  Scenario: Set timezone
    Given timezones are available
    When I set timezone
    Then timezone should be saved
    And times should adjust accordingly

  @happy-path @language-settings
  Scenario: Set currency display
    Given currency options exist
    When I set currency display
    Then currency should be saved
    And values should display accordingly

  @happy-path @language-settings
  Scenario: Enable auto-translation
    Given translation is available
    When I enable auto-translation
    Then translation should be enabled
    And content should be translated

  @happy-path @language-settings
  Scenario: Preview language change
    Given I am selecting language
    When I preview language
    Then I should see preview
    And I can apply or cancel

  @happy-path @language-settings
  Scenario: Reset language settings
    Given I have custom settings
    When I reset language settings
    Then defaults should be restored
    And I should confirm first

  # ============================================================================
  # DATA MANAGEMENT
  # ============================================================================

  @happy-path @data-management
  Scenario: Export data
    Given I have data to export
    When I export my data
    Then data should be exported
    And I should receive download

  @happy-path @data-management
  Scenario: Import data
    Given I have data to import
    When I import data
    Then data should be imported
    And I should see confirmation

  @happy-path @data-management
  Scenario: Create data backup
    Given backup is available
    When I create backup
    Then backup should be created
    And I can restore later

  @happy-path @data-management
  Scenario: Restore from backup
    Given backup exists
    When I restore from backup
    Then data should be restored
    And I should confirm first

  @happy-path @data-management
  Scenario: Clear cache
    Given cache exists
    When I clear cache
    Then cache should be cleared
    And app should reload data

  @happy-path @data-management
  Scenario: View storage usage
    Given I have stored data
    When I view storage usage
    Then I should see usage details
    And breakdown should be shown

  @happy-path @data-management
  Scenario: Delete specific data
    Given I have data to delete
    When I delete specific data
    Then data should be removed
    And I should confirm first

  @happy-path @data-management
  Scenario: Schedule automatic backups
    Given auto-backup is available
    When I schedule backups
    Then schedule should be saved
    And backups should occur automatically

  @happy-path @data-management
  Scenario: Download all data
    Given GDPR export is available
    When I request all data
    Then export should be prepared
    And I should receive download link

  @happy-path @data-management
  Scenario: Manage data retention
    Given retention options exist
    When I set retention preferences
    Then preferences should be saved
    And data should follow policy

  # ============================================================================
  # CONNECTED ACCOUNTS
  # ============================================================================

  @happy-path @connected-accounts
  Scenario: Link account
    Given linking is available
    When I link an account
    Then account should be linked
    And I can use connected features

  @happy-path @connected-accounts
  Scenario: View connected accounts
    Given I have linked accounts
    When I view connected accounts
    Then I should see all connections
    And status should be shown

  @happy-path @connected-accounts
  Scenario: Connect social account
    Given social connection is available
    When I connect social account
    Then account should be connected
    And sharing should be enabled

  @happy-path @connected-accounts
  Scenario: Sync with platform
    Given platform sync is available
    When I sync with platform
    Then data should be synced
    And I should see confirmation

  @happy-path @connected-accounts
  Scenario: Disconnect account
    Given account is connected
    When I disconnect account
    Then account should be disconnected
    And features should be disabled

  @happy-path @connected-accounts
  Scenario: Set sync preferences
    Given sync options exist
    When I set sync preferences
    Then preferences should be saved
    And sync should follow settings

  @happy-path @connected-accounts
  Scenario: Refresh connection
    Given connection exists
    When I refresh connection
    Then connection should be refreshed
    And data should be updated

  @happy-path @connected-accounts
  Scenario: View connection permissions
    Given connection exists
    When I view permissions
    Then I should see what's shared
    And I can modify permissions

  @happy-path @connected-accounts
  Scenario: Troubleshoot connection
    Given connection has issues
    When I troubleshoot
    Then I should see diagnostics
    And I can fix issues

  @happy-path @connected-accounts
  Scenario: Manage connection settings
    Given connection exists
    When I manage settings
    Then settings should be available
    And I can configure behavior

  # ============================================================================
  # ACCESSIBILITY SETTINGS
  # ============================================================================

  @accessibility @accessibility-settings
  Scenario: Enable screen reader support
    Given screen reader is available
    When I enable screen reader support
    Then support should be enabled
    And content should be accessible

  @accessibility @accessibility-settings
  Scenario: Enable high contrast
    Given high contrast is available
    When I enable high contrast
    Then high contrast should be active
    And UI should be more visible

  @accessibility @accessibility-settings
  Scenario: Reduce motion
    Given motion reduction is available
    When I enable reduced motion
    Then motion should be reduced
    And animations should be minimized

  @accessibility @accessibility-settings
  Scenario: Enable keyboard navigation
    Given keyboard nav is available
    When I enable keyboard navigation
    Then navigation should work with keyboard
    And focus should be visible

  @accessibility @accessibility-settings
  Scenario: Enable text-to-speech
    Given TTS is available
    When I enable text-to-speech
    Then TTS should be enabled
    And content should be spoken

  @accessibility @accessibility-settings
  Scenario: Adjust contrast levels
    Given contrast options exist
    When I adjust contrast
    Then contrast should be saved
    And UI should reflect contrast

  @accessibility @accessibility-settings
  Scenario: Set focus indicators
    Given focus options exist
    When I set focus indicators
    Then indicators should be saved
    And focus should be visible

  @accessibility @accessibility-settings
  Scenario: Configure captions
    Given captions are available
    When I configure captions
    Then caption settings should be saved
    And captions should display

  @accessibility @accessibility-settings
  Scenario: Set reading preferences
    Given reading options exist
    When I set reading preferences
    Then preferences should be saved
    And content should be easier to read

  @accessibility @accessibility-settings
  Scenario: Test accessibility settings
    Given settings are configured
    When I test settings
    Then I should see how settings work
    And I can adjust as needed

  # ============================================================================
  # SECURITY SETTINGS
  # ============================================================================

  @happy-path @security-settings
  Scenario: View login history
    Given logins are tracked
    When I view login history
    Then I should see all logins
    And details should be shown

  @happy-path @security-settings
  Scenario: View active sessions
    Given sessions exist
    When I view active sessions
    Then I should see all sessions
    And I can manage them

  @happy-path @security-settings
  Scenario: End specific session
    Given session is active
    When I end session
    Then session should be terminated
    And device should be logged out

  @happy-path @security-settings
  Scenario: End all sessions
    Given multiple sessions exist
    When I end all sessions
    Then all sessions should end
    And I should re-authenticate

  @happy-path @security-settings
  Scenario: Manage trusted devices
    Given devices are tracked
    When I manage trusted devices
    Then I should see all devices
    And I can trust or remove them

  @happy-path @security-settings
  Scenario: Configure security alerts
    Given alerts are available
    When I configure alerts
    Then alert settings should be saved
    And I should receive alerts

  @happy-path @security-settings
  Scenario: Enable login notifications
    Given notifications are available
    When I enable login notifications
    Then notifications should be enabled
    And I should be notified on login

  @happy-path @security-settings
  Scenario: Set session timeout
    Given timeout options exist
    When I set session timeout
    Then timeout should be saved
    And sessions should expire accordingly

  @happy-path @security-settings
  Scenario: Generate recovery codes
    Given recovery is available
    When I generate recovery codes
    Then codes should be generated
    And I should save them securely

  @happy-path @security-settings
  Scenario: Review security recommendations
    Given recommendations exist
    When I review recommendations
    Then I should see suggestions
    And I can improve security

  # ============================================================================
  # SUBSCRIPTION SETTINGS
  # ============================================================================

  @happy-path @subscription-settings
  Scenario: View current plan
    Given I have a subscription
    When I view my plan
    Then I should see plan details
    And benefits should be shown

  @happy-path @subscription-settings
  Scenario: Manage billing info
    Given billing exists
    When I manage billing info
    Then I should see billing details
    And I can update them

  @happy-path @subscription-settings
  Scenario: Update payment method
    Given payment method exists
    When I update payment method
    Then new method should be saved
    And old method can be removed

  @happy-path @subscription-settings
  Scenario: Add payment method
    Given I want to add payment
    When I add payment method
    Then method should be added
    And I can use it for billing

  @happy-path @subscription-settings
  Scenario: View renewal settings
    Given subscription renews
    When I view renewal settings
    Then I should see renewal details
    And date should be shown

  @happy-path @subscription-settings
  Scenario: Cancel auto-renewal
    Given auto-renewal is on
    When I cancel auto-renewal
    Then renewal should be cancelled
    And I should keep access until expiry

  @happy-path @subscription-settings
  Scenario: Upgrade plan
    Given upgrade is available
    When I upgrade plan
    Then upgrade should be processed
    And I should get new benefits

  @happy-path @subscription-settings
  Scenario: Downgrade plan
    Given downgrade is available
    When I downgrade plan
    Then downgrade should be scheduled
    And I should be informed of changes

  @happy-path @subscription-settings
  Scenario: View billing history
    Given billing history exists
    When I view billing history
    Then I should see all transactions
    And I can download invoices

  @happy-path @subscription-settings
  Scenario: Apply promo code
    Given promo codes are accepted
    When I apply promo code
    Then discount should be applied
    And confirmation should be shown

