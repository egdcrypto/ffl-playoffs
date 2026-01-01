@settings
Feature: Settings
  As a fantasy football platform user
  I want to configure my application settings
  So that I can customize my experience and preferences

  # Display Settings Scenarios
  @display-settings
  Scenario: Select application theme
    Given I am in display settings
    When I select a theme option
    Then the theme should apply immediately
    And theme should persist across sessions
    And all screens should reflect the theme

  @display-settings
  Scenario: Customize color scheme
    Given I am in display settings
    When I customize color scheme options
    Then accent colors should update
    And I should see preview of changes
    And custom colors should be saved

  @display-settings
  Scenario: Adjust font sizes
    Given I am in display settings
    When I adjust font size settings
    Then text should resize throughout the app
    And layout should adapt to font changes
    And readability should be maintained

  @display-settings
  Scenario: Configure layout preferences
    Given I am in display settings
    When I configure layout options
    Then I should be able to choose compact or expanded views
    And I should be able to set default page layouts
    And preferences should apply to all screens

  @display-settings
  Scenario: Set dark mode schedule
    Given I am in display settings
    When I configure dark mode schedule
    Then I should be able to set automatic switching
    And switching should follow schedule
    And I should be able to sync with system settings

  @display-settings
  Scenario: Configure dashboard widgets
    Given I am in display settings
    When I customize dashboard layout
    Then I should be able to add or remove widgets
    And I should be able to reorder widgets
    And layout should save automatically

  @display-settings
  Scenario: Set default sort preferences
    Given I am in display settings
    When I set default sort options
    Then lists should sort by my preference
    And sort should apply to relevant screens
    And I should be able to override per screen

  @display-settings
  Scenario: Reset display settings to default
    Given I have customized display settings
    When I reset to defaults
    Then all display settings should revert
    And I should be warned before reset
    And reset should be confirmed

  # Notification Settings Scenarios
  @notification-settings
  Scenario: Configure email notification preferences
    Given I am in notification settings
    When I configure email preferences
    Then I should be able to toggle email types
    And I should be able to set email frequency
    And changes should save immediately

  @notification-settings
  Scenario: Configure push notification settings
    Given I am in notification settings
    When I configure push notifications
    Then I should be able to toggle notification types
    And I should be able to set notification sounds
    And settings should sync to my devices

  @notification-settings
  Scenario: Set alert types and priorities
    Given I am in notification settings
    When I configure alert settings
    Then I should be able to set priority levels
    And high priority alerts should be distinguishable
    And I should be able to mute low priority

  @notification-settings
  Scenario: Configure notification frequency
    Given I am in notification settings
    When I set frequency controls
    Then I should be able to batch notifications
    And I should be able to set digest times
    And real-time option should be available

  @notification-settings
  Scenario: Set quiet hours for notifications
    Given I am in notification settings
    When I configure quiet hours
    Then notifications should be silenced during hours
    And I should be able to allow exceptions
    And quiet hours should respect timezone

  @notification-settings
  Scenario: Configure game day notification surge
    Given I am in notification settings
    When I set game day preferences
    Then I should be able to increase notifications on game days
    And I should be able to set pre-game reminders
    And post-game summaries should be configurable

  @notification-settings
  Scenario: Unsubscribe from notification categories
    Given I am in notification settings
    When I unsubscribe from a category
    Then I should stop receiving those notifications
    And unsubscribe should be immediate
    And I should be able to resubscribe easily

  @notification-settings
  Scenario: Test notification delivery
    Given I am in notification settings
    When I send a test notification
    Then I should receive test notification
    And notification should arrive promptly
    And I should see delivery confirmation

  # Privacy Settings Scenarios
  @privacy-settings
  Scenario: Configure profile visibility
    Given I am in privacy settings
    When I set profile visibility options
    Then I should be able to make profile public or private
    And I should be able to control what is visible
    And changes should apply immediately

  @privacy-settings
  Scenario: Manage data sharing preferences
    Given I am in privacy settings
    When I configure data sharing options
    Then I should be able to opt out of analytics
    And I should be able to control third-party sharing
    And I should see what data is shared

  @privacy-settings
  Scenario: Set activity privacy levels
    Given I am in privacy settings
    When I configure activity visibility
    Then I should be able to hide my activity
    And I should be able to set league-specific visibility
    And activity should respect settings

  @privacy-settings
  Scenario: Configure search visibility
    Given I am in privacy settings
    When I set search visibility options
    Then I should be able to hide from user search
    And I should be able to appear to friends only
    And changes should take effect immediately

  @privacy-settings
  Scenario: Manage blocked users
    Given I am in privacy settings
    When I access blocked users list
    Then I should see blocked users
    And I should be able to unblock users
    And I should be able to add blocks

  @privacy-settings
  Scenario: Control roster visibility
    Given I am in privacy settings
    When I configure roster privacy
    Then I should be able to hide roster from opponents
    And I should be able to set reveal timing
    And league rules should be respected

  @privacy-settings
  Scenario: Download privacy data report
    Given I am in privacy settings
    When I request my data report
    Then report should be generated
    And I should be able to download all my data
    And report should be comprehensive

  @privacy-settings
  Scenario: Delete personal data
    Given I am in privacy settings
    When I request data deletion
    Then I should see what will be deleted
    And I should confirm the deletion
    And deletion should comply with regulations

  # Language Settings Scenarios
  @language-settings
  Scenario: Select application language
    Given I am in language settings
    When I select a different language
    Then the app should switch to that language
    And all UI text should be translated
    And language should persist

  @language-settings
  Scenario: Configure regional formats
    Given I am in language settings
    When I set regional format preferences
    Then numbers should use regional format
    And currency should display correctly
    And measurements should match region

  @language-settings
  Scenario: Set timezone configuration
    Given I am in language settings
    When I configure my timezone
    Then all times should display in my timezone
    And game times should be converted
    And deadline times should be accurate

  @language-settings
  Scenario: Configure date format preferences
    Given I am in language settings
    When I set date format preference
    Then dates should display in chosen format
    And format should be consistent throughout
    And calendars should respect format

  @language-settings
  Scenario: Set time format preference
    Given I am in language settings
    When I choose 12 or 24 hour format
    Then times should display in chosen format
    And format should apply everywhere
    And input should accept either format

  @language-settings
  Scenario: Auto-detect location settings
    Given I am in language settings
    When I enable auto-detect
    Then language should match my location
    And timezone should be detected
    And I should be able to override

  @language-settings
  Scenario: Configure first day of week
    Given I am in language settings
    When I set first day of week
    Then calendars should start on that day
    And week views should adjust
    And scheduling should respect setting

  @language-settings
  Scenario: Set temperature unit preference
    Given I am in language settings
    When I select temperature unit
    Then weather displays should use that unit
    And game day conditions should convert
    And preference should persist

  # Accessibility Settings Scenarios
  @accessibility-settings
  Scenario: Enable screen reader optimization
    Given I am in accessibility settings
    When I enable screen reader support
    Then content should be optimized for screen readers
    And ARIA labels should be comprehensive
    And focus management should improve

  @accessibility-settings
  Scenario: Enable high contrast mode
    Given I am in accessibility settings
    When I enable high contrast mode
    Then colors should switch to high contrast
    And all text should be clearly visible
    And UI elements should be distinguishable

  @accessibility-settings
  Scenario: Enable reduced motion
    Given I am in accessibility settings
    When I enable reduced motion
    Then animations should be minimized
    And transitions should be simplified
    And auto-playing content should stop

  @accessibility-settings
  Scenario: Configure keyboard navigation
    Given I am in accessibility settings
    When I configure keyboard navigation
    Then I should see keyboard shortcuts
    And I should be able to customize shortcuts
    And all features should be keyboard accessible

  @accessibility-settings
  Scenario: Enable focus indicators
    Given I am in accessibility settings
    When I enable enhanced focus indicators
    Then focus should be highly visible
    And focus should follow logical order
    And all interactive elements should show focus

  @accessibility-settings
  Scenario: Configure text-to-speech
    Given I am in accessibility settings
    When I enable text-to-speech
    Then I should be able to have content read aloud
    And speech rate should be configurable
    And voice should be selectable

  @accessibility-settings
  Scenario: Set caption preferences
    Given I am in accessibility settings
    When I configure caption settings
    Then video content should show captions
    And caption style should be customizable
    And captions should sync correctly

  @accessibility-settings
  Scenario: Enable dyslexia-friendly mode
    Given I am in accessibility settings
    When I enable dyslexia-friendly mode
    Then font should switch to dyslexia-friendly
    And spacing should increase
    And text formatting should adjust

  # Data Settings Scenarios
  @data-settings
  Scenario: Export personal data
    Given I am in data settings
    When I request data export
    Then I should be able to choose export format
    And export should include all my data
    And download link should be provided

  @data-settings
  Scenario: Import data from other platforms
    Given I am in data settings
    When I import data from another platform
    Then I should see supported import formats
    And import should map data correctly
    And I should see import preview

  @data-settings
  Scenario: Configure sync preferences
    Given I am in data settings
    When I configure sync options
    Then I should be able to set sync frequency
    And I should be able to choose what syncs
    And I should be able to force manual sync

  @data-settings
  Scenario: Set up data backup
    Given I am in data settings
    When I configure backup settings
    Then I should be able to enable automatic backups
    And I should be able to set backup location
    And I should be able to restore from backup

  @data-settings
  Scenario: Manage data retention
    Given I am in data settings
    When I configure data retention
    Then I should be able to set retention periods
    And old data should be archived or deleted
    And I should see current data usage

  @data-settings
  Scenario: Configure offline data
    Given I am in data settings
    When I set offline data preferences
    Then I should be able to choose what is cached
    And cache size should be configurable
    And I should be able to clear cache

  @data-settings
  Scenario: Set up cloud sync
    Given I am in data settings
    When I enable cloud sync
    Then data should sync across devices
    And I should see sync status
    And conflicts should be resolved

  @data-settings
  Scenario: View data usage statistics
    Given I am in data settings
    When I view data usage
    Then I should see storage used
    And I should see data by category
    And I should see recommendations

  # Communication Settings Scenarios
  @communication-settings
  Scenario: Set contact preferences
    Given I am in communication settings
    When I set contact preferences
    Then I should choose how platform contacts me
    And preferred methods should be respected
    And I should be able to verify contact info

  @communication-settings
  Scenario: Manage marketing opt-ins
    Given I am in communication settings
    When I configure marketing preferences
    Then I should be able to opt in or out
    And opt-out should be immediate
    And I should see what I am subscribed to

  @communication-settings
  Scenario: Configure newsletter subscriptions
    Given I am in communication settings
    When I manage newsletter subscriptions
    Then I should see available newsletters
    And I should be able to subscribe or unsubscribe
    And frequency should be configurable

  @communication-settings
  Scenario: Manage partner offers
    Given I am in communication settings
    When I configure partner communications
    Then I should be able to opt out of partner offers
    And I should see partner categories
    And changes should apply immediately

  @communication-settings
  Scenario: Set communication frequency limits
    Given I am in communication settings
    When I set frequency limits
    Then communications should respect limits
    And I should be able to set max per day or week
    And important messages should still arrive

  @communication-settings
  Scenario: Configure league communication preferences
    Given I am in communication settings
    When I set league communication options
    Then I should be able to set per-league preferences
    And I should control commissioner messages
    And trade offer notifications should be configurable

  @communication-settings
  Scenario: Manage SMS notifications
    Given I am in communication settings
    When I configure SMS settings
    Then I should be able to enable or disable SMS
    And I should be able to set SMS categories
    And phone number should be verified

  @communication-settings
  Scenario: View communication history
    Given I am in communication settings
    When I view communication history
    Then I should see recent communications
    And I should be able to filter by type
    And I should be able to mark as read

  # Game Settings Scenarios
  @game-settings
  Scenario: Set default lineup rules
    Given I am in game settings
    When I configure lineup defaults
    Then I should set auto-bench rules for injuries
    And I should set position preferences
    And defaults should apply to all leagues

  @game-settings
  Scenario: Configure auto-draft preferences
    Given I am in game settings
    When I set auto-draft options
    Then I should be able to set draft strategy
    And I should set position priorities
    And preferences should apply when needed

  @game-settings
  Scenario: Set trade review preferences
    Given I am in game settings
    When I configure trade settings
    Then I should set trade notification preferences
    And I should set auto-decline rules
    And review period preferences should save

  @game-settings
  Scenario: Configure waiver priorities
    Given I am in game settings
    When I set waiver preferences
    Then I should set default bid amounts
    And I should set claim priorities
    And settings should apply to all leagues

  @game-settings
  Scenario: Set scoring display preferences
    Given I am in game settings
    When I configure scoring display
    Then I should choose decimal precision
    And I should set projection sources
    And I should configure stat categories shown

  @game-settings
  Scenario: Configure player news preferences
    Given I am in game settings
    When I set player news options
    Then I should set news sources
    And I should set update frequency
    And I should filter by relevance

  @game-settings
  Scenario: Set draft preparation defaults
    Given I am in game settings
    When I configure draft prep options
    Then I should set default rankings source
    And I should set mock draft preferences
    And cheat sheet format should be configurable

  @game-settings
  Scenario: Configure matchup display preferences
    Given I am in game settings
    When I set matchup display options
    Then I should choose stats to display
    And I should set comparison format
    And projection display should be configurable

  # Account Settings Scenarios
  @account-settings
  Scenario: Change account password
    Given I am in account settings
    When I change my password
    Then I should enter current password
    And new password should meet requirements
    And password should update successfully

  @account-settings
  Scenario: Update email address
    Given I am in account settings
    When I update my email address
    Then verification should be sent to new email
    And I should confirm the change
    And email should update after confirmation

  @account-settings
  Scenario: Manage linked accounts
    Given I am in account settings
    When I view linked accounts
    Then I should see connected services
    And I should be able to link new accounts
    And I should be able to unlink accounts

  @account-settings
  Scenario: Manage active sessions
    Given I am in account settings
    When I view active sessions
    Then I should see all logged-in devices
    And I should be able to end other sessions
    And session details should be shown

  @account-settings
  Scenario: Enable two-factor authentication
    Given I am in account settings
    When I enable two-factor authentication
    Then I should set up authenticator app
    And I should receive backup codes
    And 2FA should be required on login

  @account-settings
  Scenario: Update profile information
    Given I am in account settings
    When I update my profile
    Then I should be able to change display name
    And I should be able to update avatar
    And changes should save immediately

  @account-settings
  Scenario: Configure login preferences
    Given I am in account settings
    When I set login preferences
    Then I should be able to enable remember me
    And I should set session timeout
    And I should configure login notifications

  @account-settings
  Scenario: Delete account
    Given I am in account settings
    When I request account deletion
    Then I should see deletion consequences
    And I should confirm multiple times
    And account should be scheduled for deletion

  # Advanced Settings Scenarios
  @advanced-settings
  Scenario: Access developer options
    Given I am an advanced user
    When I access developer options
    Then I should see API access settings
    And I should see webhook configuration
    And developer documentation should link

  @advanced-settings
  Scenario: Enable beta features
    Given I am in advanced settings
    When I enable beta features
    Then I should see available beta features
    And I should understand beta risks
    And I should be able to toggle individual features

  @advanced-settings
  Scenario: Enable debug mode
    Given I am in advanced settings
    When I enable debug mode
    Then additional logging should activate
    And debug information should display
    And I should be able to export logs

  @advanced-settings
  Scenario: Configure cache controls
    Given I am in advanced settings
    When I access cache controls
    Then I should see cache usage
    And I should be able to clear specific caches
    And I should set cache limits

  @advanced-settings
  Scenario: Configure API rate limits
    Given I am in advanced settings
    When I view API settings
    Then I should see my rate limits
    And I should see current usage
    And I should be able to request increases

  @advanced-settings
  Scenario: Manage experimental features
    Given I am in advanced settings
    When I access experimental features
    Then I should see feature flags
    And I should understand experimental nature
    And I should be able to toggle features

  @advanced-settings
  Scenario: Export application logs
    Given I am in advanced settings
    When I export application logs
    Then logs should be compiled
    And sensitive data should be redacted
    And download should be provided

  @advanced-settings
  Scenario: Reset all settings
    Given I am in advanced settings
    When I reset all settings
    Then I should be warned about consequences
    And all settings should revert to defaults
    And account data should remain intact

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle settings save failure
    Given I am changing settings
    When save operation fails
    Then I should see error message
    And my changes should not be lost
    And retry option should be available

  @error-handling
  Scenario: Handle invalid setting values
    Given I am entering setting values
    When I enter invalid values
    Then validation should prevent save
    And clear error message should display
    And valid values should be indicated

  @error-handling
  Scenario: Handle settings sync conflicts
    Given I have changed settings on multiple devices
    When settings sync conflicts
    Then I should be notified of conflict
    And I should choose which to keep
    And resolution should be logged

  @error-handling
  Scenario: Handle notification permission denied
    Given I am enabling notifications
    When permission is denied
    Then I should see explanation
    And I should see how to enable in system settings
    And app should function without notifications

  @error-handling
  Scenario: Handle data export failure
    Given I am exporting my data
    When export fails
    Then I should see error details
    And I should be able to retry
    And partial exports should be handled

  @error-handling
  Scenario: Handle language file loading failure
    Given I am changing language
    When language file fails to load
    Then I should see error message
    And app should remain in current language
    And retry should be available

  @error-handling
  Scenario: Handle account linking failure
    Given I am linking an external account
    When linking fails
    Then I should see specific error
    And I should see troubleshooting steps
    And partial link should not be saved

  @error-handling
  Scenario: Handle settings migration failure
    Given settings need migration after update
    When migration fails
    Then I should be notified
    And default settings should apply
    And support contact should be provided

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate settings with keyboard
    Given I am in settings
    When I navigate using only keyboard
    Then all settings should be reachable
    And focus order should be logical
    And actions should be executable

  @accessibility
  Scenario: Screen reader announces settings
    Given I am using a screen reader
    When I navigate settings
    Then settings should be announced clearly
    And current values should be stated
    And changes should be confirmed

  @accessibility
  Scenario: Settings visible in high contrast
    Given I have enabled high contrast mode
    When I view settings
    Then all options should be visible
    And toggles should be distinguishable
    And text should be readable

  @accessibility
  Scenario: Large touch targets in settings
    Given I am using touch interface
    When I interact with settings
    Then touch targets should be adequate size
    And spacing should prevent mis-taps
    And all controls should be tappable

  @accessibility
  Scenario: Settings form labels are accessible
    Given I am using assistive technology
    When I interact with form fields
    Then labels should be properly associated
    And required fields should be indicated
    And errors should be announced

  @accessibility
  Scenario: Settings changes announced
    Given I am using a screen reader
    When I change a setting
    Then change should be announced
    And new value should be stated
    And save confirmation should be announced

  @accessibility
  Scenario: Help text is accessible
    Given I am using assistive technology
    When I access setting help text
    Then help should be readable
    And relationship to setting should be clear
    And I should be able to dismiss help

  @accessibility
  Scenario: Settings work with zoom
    Given I have zoomed the interface
    When I view settings
    Then all content should be visible
    And I should be able to scroll
    And layout should adapt appropriately

  # Performance Scenarios
  @performance
  Scenario: Settings page loads quickly
    Given I am accessing settings
    When I open settings page
    Then page should load within 1 second
    And all sections should be available
    And no loading spinners should linger

  @performance
  Scenario: Settings save quickly
    Given I am changing settings
    When I save changes
    Then save should complete within 500ms
    And UI should provide immediate feedback
    And I should be able to continue

  @performance
  Scenario: Settings search is responsive
    Given I am in settings
    When I search for a setting
    Then results should appear instantly
    And filtering should be smooth
    And matching should be accurate

  @performance
  Scenario: Settings sync efficiently
    Given I have settings to sync
    When sync occurs
    Then sync should complete quickly
    And bandwidth should be minimized
    And only changes should sync

  @performance
  Scenario: Data export performs efficiently
    Given I am exporting large amounts of data
    When export runs
    Then progress should be shown
    And export should complete in reasonable time
    And system should remain responsive

  @performance
  Scenario: Settings cache efficiently
    Given I access settings frequently
    When I return to settings
    Then cached values should load instantly
    And only changed values should fetch
    And cache should stay current

  @performance
  Scenario: Language switch is fast
    Given I am changing language
    When language switch occurs
    Then switch should complete within 2 seconds
    And UI should update smoothly
    And no flashing should occur

  @performance
  Scenario: Settings handle slow networks
    Given I have slow network connection
    When I access settings
    Then settings should still be usable
    And timeouts should be reasonable
    And offline values should display
