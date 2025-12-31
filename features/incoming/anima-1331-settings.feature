@settings @ANIMA-1331
Feature: Settings
  As a fantasy football application user
  I want to configure my application settings
  So that I can personalize my experience and control my account

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # ACCOUNT SETTINGS - HAPPY PATH
  # ============================================================================

  @happy-path @account-settings
  Scenario: View account settings
    Given I am on the settings page
    When I view account settings
    Then I should see my account information
    And I should see my email address
    And I should see my username

  @happy-path @account-settings
  Scenario: Update email address
    Given I am in account settings
    When I change my email address
    Then I should receive a verification email
    And I should confirm the new email
    And my email should be updated

  @happy-path @account-settings
  Scenario: Update username
    Given I am in account settings
    When I change my username
    Then the system should check availability
    And my username should be updated
    And the change should be confirmed

  @happy-path @account-settings
  Scenario: Update phone number
    Given I am in account settings
    When I add or change my phone number
    Then I should receive a verification code
    And I should verify via SMS
    And my phone should be updated

  @happy-path @account-settings
  Scenario: Change password
    Given I am in account settings
    When I change my password
    Then I should enter current password
    And I should enter new password twice
    And my password should be updated

  @happy-path @account-settings
  Scenario: View account activity log
    Given I am in account settings
    When I view activity log
    Then I should see login history
    And I should see recent actions
    And I should see timestamps and locations

  @happy-path @account-settings
  Scenario: Delete account
    Given I want to delete my account
    When I initiate account deletion
    Then I should see warnings and consequences
    And I should confirm deletion
    And my account should be scheduled for deletion

  # ============================================================================
  # PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy-settings
  Scenario: View privacy settings
    Given I am on the settings page
    When I view privacy settings
    Then I should see all privacy options
    And I should see current settings
    And I should be able to modify them

  @happy-path @privacy-settings
  Scenario: Set profile visibility
    Given I am in privacy settings
    When I set profile visibility
    Then I should choose public or private
    And the setting should be saved
    And my profile should respect the setting

  @happy-path @privacy-settings
  Scenario: Control activity visibility
    Given I am in privacy settings
    When I configure activity visibility
    Then I should show or hide activity
    And I should control what is visible
    And settings should be saved

  @happy-path @privacy-settings
  Scenario: Manage data sharing preferences
    Given I am in privacy settings
    When I manage data sharing
    Then I should control analytics sharing
    And I should control personalization
    And preferences should be saved

  @happy-path @privacy-settings
  Scenario: Control search discoverability
    Given I am in privacy settings
    When I set search settings
    Then I should appear or hide from search
    And I should control who can find me
    And settings should be saved

  @happy-path @privacy-settings
  Scenario: Manage blocked users
    Given I have blocked users
    When I manage blocked list
    Then I should see all blocked users
    And I should unblock if desired
    And the list should update

  @happy-path @privacy-settings
  Scenario: View privacy policy
    Given I am in privacy settings
    When I view privacy policy
    Then I should see the full policy
    And I should see last updated date
    And I should understand my rights

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @notification-preferences
  Scenario: View notification preferences
    Given I am on the settings page
    When I view notification preferences
    Then I should see all notification types
    And I should see current settings
    And I should modify each type

  @happy-path @notification-preferences
  Scenario: Configure email notifications
    Given I am in notification settings
    When I configure email notifications
    Then I should enable or disable email types
    And I should set email frequency
    And settings should be saved

  @happy-path @notification-preferences
  Scenario: Configure push notifications
    Given I am in notification settings
    When I configure push notifications
    Then I should enable or disable push types
    And I should set urgency levels
    And settings should be saved

  @happy-path @notification-preferences
  Scenario: Configure in-app notifications
    Given I am in notification settings
    When I configure in-app notifications
    Then I should control toast notifications
    And I should control badge counts
    And settings should be saved

  @happy-path @notification-preferences
  Scenario: Set quiet hours
    Given I am in notification settings
    When I set quiet hours
    Then I should set start and end times
    And notifications should pause during quiet hours
    And settings should be saved

  @happy-path @notification-preferences
  Scenario: Configure notification sounds
    Given I am in notification settings
    When I configure sounds
    Then I should enable or disable sounds
    And I should choose sound types
    And I should set volume

  @happy-path @notification-preferences
  Scenario: Test notification settings
    Given I have configured notifications
    When I test notifications
    Then a test notification should be sent
    And I should confirm receipt
    And settings should be validated

  # ============================================================================
  # DISPLAY PREFERENCES
  # ============================================================================

  @happy-path @display-preferences
  Scenario: View display preferences
    Given I am on the settings page
    When I view display preferences
    Then I should see display options
    And I should see current settings
    And I should preview changes

  @happy-path @display-preferences
  Scenario: Configure list view preferences
    Given I am in display settings
    When I set list view options
    Then I should choose compact or expanded
    And I should set items per page
    And settings should be saved

  @happy-path @display-preferences
  Scenario: Configure dashboard layout
    Given I am in display settings
    When I set dashboard preferences
    Then I should choose widget layout
    And I should set default view
    And settings should be saved

  @happy-path @display-preferences
  Scenario: Configure player display format
    Given I am in display settings
    When I set player display
    Then I should choose name format
    And I should choose stat display
    And settings should be saved

  @happy-path @display-preferences
  Scenario: Configure score display preferences
    Given I am in display settings
    When I set score preferences
    Then I should choose decimal places
    And I should choose live update frequency
    And settings should be saved

  @happy-path @display-preferences
  Scenario: Configure table column preferences
    Given I am in display settings
    When I customize table columns
    Then I should show or hide columns
    And I should reorder columns
    And preferences should be saved

  # ============================================================================
  # THEME SELECTION
  # ============================================================================

  @happy-path @theme-selection
  Scenario: View available themes
    Given I am in display settings
    When I view theme options
    Then I should see available themes
    And I should preview each theme
    And I should see theme descriptions

  @happy-path @theme-selection
  Scenario: Select light theme
    Given I am selecting a theme
    When I choose light theme
    Then the app should switch to light mode
    And colors should be light-based
    And the change should be immediate

  @happy-path @theme-selection
  Scenario: Select dark theme
    Given I am selecting a theme
    When I choose dark theme
    Then the app should switch to dark mode
    And colors should be dark-based
    And eye strain should be reduced

  @happy-path @theme-selection
  Scenario: Set theme to match system
    Given I am selecting a theme
    When I choose system theme
    Then the app should match OS setting
    And changes should sync automatically
    And transitions should be smooth

  @happy-path @theme-selection
  Scenario: Configure accent colors
    Given I am customizing theme
    When I select accent colors
    Then buttons and highlights should change
    And I should preview the changes
    And settings should be saved

  @happy-path @theme-selection
  Scenario: Schedule theme changes
    Given I want automatic theme switching
    When I schedule theme changes
    Then I should set time-based switching
    And themes should change automatically
    And schedule should be saved

  # ============================================================================
  # LANGUAGE SETTINGS
  # ============================================================================

  @happy-path @language-settings
  Scenario: View language options
    Given I am in settings
    When I view language settings
    Then I should see available languages
    And I should see current language
    And I should be able to change

  @happy-path @language-settings
  Scenario: Change application language
    Given I am in language settings
    When I select a different language
    Then the interface should translate
    And all text should update
    And the change should be confirmed

  @happy-path @language-settings
  Scenario: Set regional format preferences
    Given I am in language settings
    When I set regional formats
    Then I should choose date format
    And I should choose number format
    And formats should apply throughout

  @happy-path @language-settings
  Scenario: Set content language preference
    Given I am in language settings
    When I set content language
    Then news and content should be in that language
    And player names should respect preference
    And settings should be saved

  # ============================================================================
  # TIMEZONE CONFIGURATION
  # ============================================================================

  @happy-path @timezone-settings
  Scenario: View timezone settings
    Given I am in settings
    When I view timezone settings
    Then I should see current timezone
    And I should see detected timezone
    And I should be able to change

  @happy-path @timezone-settings
  Scenario: Change timezone
    Given I am in timezone settings
    When I select a different timezone
    Then all times should adjust
    And deadlines should reflect new timezone
    And the change should be confirmed

  @happy-path @timezone-settings
  Scenario: Enable automatic timezone detection
    Given I am in timezone settings
    When I enable auto-detection
    Then timezone should match my location
    And changes should sync automatically
    And I should be notified of changes

  @happy-path @timezone-settings
  Scenario: Set timezone display preference
    Given I am in timezone settings
    When I set display preference
    Then I should show times in my timezone
    And I should optionally show original timezone
    And preferences should be saved

  # ============================================================================
  # DATA EXPORT
  # ============================================================================

  @happy-path @data-export
  Scenario: Request data export
    Given I want to export my data
    When I request a data export
    Then my request should be processed
    And I should receive notification when ready
    And I should download my data

  @happy-path @data-export
  Scenario: Select data to export
    Given I am requesting export
    When I select export options
    Then I should choose data types
    And I should choose format
    And I should choose date range

  @happy-path @data-export
  Scenario: Export league history
    Given I want league data
    When I export league history
    Then I should receive league data
    And it should include all seasons
    And format should be readable

  @happy-path @data-export
  Scenario: Export transaction history
    Given I want transaction data
    When I export transactions
    Then I should receive all transactions
    And trades and waivers should be included
    And dates should be accurate

  @happy-path @data-export
  Scenario: Schedule recurring exports
    Given I want regular exports
    When I schedule exports
    Then I should set frequency
    And exports should run automatically
    And I should receive notifications

  @happy-path @data-export
  Scenario: Export to third-party service
    Given I want to sync data
    When I export to a service
    Then I should authenticate
    And data should be transferred
    And sync should be confirmed

  # ============================================================================
  # CONNECTED ACCOUNTS
  # ============================================================================

  @happy-path @connected-accounts
  Scenario: View connected accounts
    Given I am in settings
    When I view connected accounts
    Then I should see all connections
    And I should see connection status
    And I should manage each connection

  @happy-path @connected-accounts
  Scenario: Connect social account
    Given I want to connect a social account
    When I connect the account
    Then I should authorize the connection
    And the account should be linked
    And connection should be confirmed

  @happy-path @connected-accounts
  Scenario: Connect fantasy platform
    Given I want to link another platform
    When I connect ESPN/Yahoo/etc
    Then I should authenticate
    And data should be imported
    And sync should be established

  @happy-path @connected-accounts
  Scenario: Disconnect account
    Given I have a connected account
    When I disconnect it
    Then the connection should be removed
    And associated data should be handled
    And disconnection should be confirmed

  @happy-path @connected-accounts
  Scenario: Refresh connected account data
    Given I have connected accounts
    When I refresh data
    Then latest data should sync
    And I should see last sync time
    And any errors should be reported

  @happy-path @connected-accounts
  Scenario: View connected account permissions
    Given I have connected accounts
    When I view permissions
    Then I should see what is shared
    And I should modify permissions
    And changes should be saved

  # ============================================================================
  # SECURITY SETTINGS
  # ============================================================================

  @happy-path @security-settings
  Scenario: View security settings
    Given I am in settings
    When I view security settings
    Then I should see security options
    And I should see security status
    And I should enhance security

  @happy-path @security-settings
  Scenario: Enable two-factor authentication
    Given I want enhanced security
    When I enable 2FA
    Then I should set up authenticator
    And I should generate backup codes
    And 2FA should be active

  @happy-path @security-settings
  Scenario: View active sessions
    Given I am in security settings
    When I view active sessions
    Then I should see all logged-in devices
    And I should see locations and times
    And I should revoke sessions

  @happy-path @security-settings
  Scenario: Revoke specific session
    Given I have multiple sessions
    When I revoke a session
    Then that session should be terminated
    And the device should be logged out
    And the action should be logged

  @happy-path @security-settings
  Scenario: Set up security questions
    Given I want account recovery options
    When I set up security questions
    Then I should choose and answer questions
    And answers should be saved securely
    And I should use them for recovery

  @happy-path @security-settings
  Scenario: View security activity log
    Given I am in security settings
    When I view security log
    Then I should see security events
    And I should see login attempts
    And suspicious activity should be flagged

  @happy-path @security-settings
  Scenario: Set login alerts
    Given I want login notifications
    When I enable login alerts
    Then I should be notified of new logins
    And I should see device information
    And I should take action if needed

  # ============================================================================
  # ACCESSIBILITY OPTIONS
  # ============================================================================

  @happy-path @accessibility-options
  Scenario: View accessibility options
    Given I am in settings
    When I view accessibility options
    Then I should see all options
    And I should see current settings
    And I should modify as needed

  @happy-path @accessibility-options
  Scenario: Enable high contrast mode
    Given I need better visibility
    When I enable high contrast
    Then colors should increase contrast
    And text should be more readable
    And the change should apply immediately

  @happy-path @accessibility-options
  Scenario: Adjust text size
    Given I need larger text
    When I adjust text size
    Then I should increase or decrease size
    And all text should scale
    And layout should adjust

  @happy-path @accessibility-options
  Scenario: Enable reduced motion
    Given I prefer less animation
    When I enable reduced motion
    Then animations should be minimized
    And transitions should be simple
    And functionality should remain

  @happy-path @accessibility-options
  Scenario: Configure screen reader support
    Given I use a screen reader
    When I configure support
    Then I should optimize for screen readers
    And labels should be enhanced
    And navigation should be improved

  @happy-path @accessibility-options
  Scenario: Enable keyboard navigation enhancements
    Given I navigate by keyboard
    When I enable enhancements
    Then focus indicators should be prominent
    And shortcuts should be available
    And navigation should be easier

  @happy-path @accessibility-options
  Scenario: Configure color blindness support
    Given I have color vision deficiency
    When I configure color settings
    Then colors should be distinguishable
    And patterns should supplement color
    And UI should be accessible

  # ============================================================================
  # LEAGUE-SPECIFIC SETTINGS
  # ============================================================================

  @happy-path @league-settings
  Scenario: View league-specific settings
    Given I am in a league
    When I view league settings
    Then I should see my preferences for that league
    And I should see notification settings
    And I should see display options

  @happy-path @league-settings
  Scenario: Configure per-league notifications
    Given I am in multiple leagues
    When I configure league notifications
    Then I should set preferences per league
    And settings should be independent
    And preferences should be saved

  @happy-path @league-settings
  Scenario: Set team preferences per league
    Given I have multiple teams
    When I set team preferences
    Then I should configure each team
    And I should set default lineups
    And I should set auto-pick preferences

  @happy-path @league-settings
  Scenario: Configure league display preferences
    Given I am in a league
    When I set display preferences
    Then I should customize league view
    And I should set default tabs
    And preferences should be saved

  @happy-path @league-settings
  Scenario: Sync settings across leagues
    Given I want consistent settings
    When I sync league settings
    Then settings should apply to all leagues
    And I should confirm the sync
    And exceptions should be noted

  # ============================================================================
  # SETTINGS MANAGEMENT
  # ============================================================================

  @happy-path @settings-management
  Scenario: Reset settings to default
    Given I want to start fresh
    When I reset settings
    Then settings should return to defaults
    And I should confirm the reset
    And the action should be logged

  @happy-path @settings-management
  Scenario: Export settings
    Given I want to backup settings
    When I export settings
    Then I should receive settings file
    And the file should be portable
    And I should import elsewhere

  @happy-path @settings-management
  Scenario: Import settings
    Given I have a settings file
    When I import settings
    Then settings should be applied
    And conflicts should be handled
    And import should be confirmed

  @happy-path @settings-management
  Scenario: Search settings
    Given I am looking for a setting
    When I search settings
    Then I should find matching options
    And I should navigate to them
    And search should be quick

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Settings fail to save
    Given I am changing settings
    When saving fails
    Then I should see an error message
    And my changes should be preserved
    And I should be able to retry

  @error
  Scenario: Invalid setting value
    Given I am entering a setting
    When I enter an invalid value
    Then I should see validation error
    And the field should be highlighted
    And I should correct the value

  @error
  Scenario: Connected account sync fails
    Given I have connected accounts
    When sync fails
    Then I should see sync error
    And I should retry manually
    And I should see troubleshooting

  @error
  Scenario: Data export fails
    Given I requested an export
    When export fails
    Then I should be notified
    And I should see the reason
    And I should retry or contact support

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Access settings on mobile
    Given I am using the mobile app
    When I access settings
    Then the layout should be mobile-friendly
    And all options should be accessible
    And toggles should be touch-friendly

  @mobile
  Scenario: Change settings on mobile
    Given I am in settings on mobile
    When I modify settings
    Then changes should save properly
    And confirmations should be clear
    And navigation should be easy

  @mobile
  Scenario: Access security settings on mobile
    Given I am on mobile
    When I access security settings
    Then 2FA should work on mobile
    And session management should work
    And all security features should be available

  @mobile
  Scenario: Manage notifications on mobile
    Given I am on mobile
    When I manage notification settings
    Then push settings should be accessible
    And I should test notifications
    And settings should save properly

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate settings with keyboard
    Given I am using keyboard navigation
    When I navigate settings
    Then all options should be accessible
    And focus should move logically
    And changes should work with keyboard

  @accessibility
  Scenario: Screen reader settings access
    Given I am using a screen reader
    When I access settings
    Then options should be announced
    And toggles should be labeled
    And confirmations should be spoken

  @accessibility
  Scenario: High contrast settings display
    Given I have high contrast enabled
    When I view settings
    Then all text should be readable
    And options should be distinguishable
    And status should be clear

  @accessibility
  Scenario: Settings with reduced motion
    Given I have reduced motion enabled
    When I navigate settings
    Then transitions should be minimal
    And functionality should remain
    And settings should be accessible
