@settings
Feature: Settings
  As a fantasy football user
  I want to manage my application settings
  So that I can customize my experience to my preferences

  # --------------------------------------------------------------------------
  # Account Settings
  # --------------------------------------------------------------------------

  @account-settings
  Scenario: Update profile information
    Given I am logged in as a user
    When I navigate to account settings
    And I update my display name
    And I update my profile bio
    And I update my profile picture
    And I save the changes
    Then my profile should be updated
    And I should see a confirmation message

  @account-settings
  Scenario: Update email address
    Given I am logged in as a user
    When I navigate to email settings
    And I enter a new email address
    And I confirm my password
    Then a verification email should be sent to the new address
    And my email should update after verification

  @account-settings
  Scenario: Configure email preferences
    Given I am logged in as a user
    When I navigate to email preferences
    Then I should be able to toggle marketing emails
    And I should be able to toggle league update emails
    And I should be able to toggle weekly digest emails
    And I should be able to toggle transaction notification emails

  @account-settings
  Scenario: Change password
    Given I am logged in as a user
    When I navigate to password settings
    And I enter my current password
    And I enter a new password meeting requirements
    And I confirm the new password
    Then my password should be updated
    And I should receive a confirmation email

  @account-settings
  Scenario: Password validation requirements
    Given I am logged in as a user
    When I try to set a new password
    Then I should see minimum length requirement
    And I should see complexity requirements
    And I should see that password cannot match previous passwords
    And weak passwords should be rejected

  @account-settings
  Scenario: Enable two-factor authentication
    Given I am logged in as a user
    When I navigate to security settings
    And I enable two-factor authentication
    And I scan the QR code with my authenticator app
    And I enter the verification code
    Then two-factor authentication should be enabled
    And I should receive backup codes

  @account-settings
  Scenario: Manage trusted devices
    Given I am logged in as a user
    And I have two-factor authentication enabled
    When I view my trusted devices
    Then I should see a list of trusted devices
    And I should be able to remove trusted devices
    And I should see last login time for each device

  @account-settings
  Scenario: View login history
    Given I am logged in as a user
    When I view my login history
    Then I should see recent login attempts
    And I should see IP addresses and locations
    And I should see timestamps
    And I should see device information

  @account-settings
  Scenario: Deactivate account
    Given I am logged in as a user
    When I navigate to account deactivation
    And I confirm my password
    And I select a reason for deactivation
    And I confirm the deactivation
    Then my account should be deactivated
    And I should have a grace period to reactivate

  @account-settings
  Scenario: Delete account permanently
    Given I am logged in as a user
    When I request permanent account deletion
    And I confirm my password
    And I acknowledge data deletion warning
    Then my account should be scheduled for deletion
    And I should receive confirmation email
    And my data should be deleted after retention period

  # --------------------------------------------------------------------------
  # Display Settings
  # --------------------------------------------------------------------------

  @display-settings
  Scenario: Select application theme
    Given I am logged in as a user
    When I navigate to display settings
    And I select a theme from available options
    Then the application should update to the selected theme
    And my preference should be saved

  @display-settings
  Scenario: Enable dark mode
    Given I am logged in as a user
    When I enable dark mode
    Then the application should switch to dark theme
    And my eyes should be less strained in low light
    And the preference should persist across sessions

  @display-settings
  Scenario: Configure automatic dark mode
    Given I am logged in as a user
    When I configure automatic dark mode
    Then I should be able to set start and end times
    And I should be able to use system preference
    And dark mode should activate automatically

  @display-settings
  Scenario: Adjust font size
    Given I am logged in as a user
    When I adjust the font size setting
    Then I should see small, medium, and large options
    And text throughout the app should resize
    And the preference should be saved

  @display-settings
  Scenario: Configure layout preferences
    Given I am logged in as a user
    When I configure layout preferences
    Then I should be able to choose compact or comfortable view
    And I should be able to configure sidebar position
    And I should be able to set default dashboard layout

  @display-settings
  Scenario: Customize dashboard widgets
    Given I am logged in as a user
    When I customize my dashboard
    Then I should be able to add and remove widgets
    And I should be able to rearrange widget positions
    And I should be able to resize widgets
    And my layout should be saved

  @display-settings
  Scenario: Configure table display preferences
    Given I am logged in as a user
    When I configure table display settings
    Then I should be able to set default rows per page
    And I should be able to choose column visibility
    And I should be able to set default sort order

  # --------------------------------------------------------------------------
  # Notification Settings
  # --------------------------------------------------------------------------

  @notification-settings
  Scenario: Configure push notification preferences
    Given I am logged in as a user
    When I navigate to notification settings
    And I configure push notifications
    Then I should be able to enable transaction alerts
    And I should be able to enable game start alerts
    And I should be able to enable score updates
    And I should be able to enable trade offers

  @notification-settings
  Scenario: Configure email alert preferences
    Given I am logged in as a user
    When I configure email alerts
    Then I should be able to toggle weekly recap emails
    And I should be able to toggle matchup preview emails
    And I should be able to toggle trade notification emails
    And I should be able to set email frequency

  @notification-settings
  Scenario: Configure in-app notification preferences
    Given I am logged in as a user
    When I configure in-app notifications
    Then I should be able to enable notification badges
    And I should be able to enable toast notifications
    And I should be able to configure notification sounds
    And I should be able to set notification duration

  @notification-settings
  Scenario: Set quiet hours
    Given I am logged in as a user
    When I configure quiet hours
    And I set start time and end time
    Then notifications should be silenced during quiet hours
    And urgent notifications should still come through if configured
    And the schedule should respect my timezone

  @notification-settings
  Scenario: Configure notification by category
    Given I am logged in as a user
    When I view notification categories
    Then I should see league notifications category
    And I should see transaction notifications category
    And I should see player notifications category
    And I should be able to configure each independently

  @notification-settings
  Scenario: Mute notifications for specific league
    Given I am logged in as a user
    And I am a member of multiple leagues
    When I mute notifications for a specific league
    Then I should not receive notifications from that league
    And other league notifications should continue
    And I should be able to unmute at any time

  # --------------------------------------------------------------------------
  # Privacy Settings
  # --------------------------------------------------------------------------

  @privacy-settings
  Scenario: Configure profile visibility
    Given I am logged in as a user
    When I navigate to privacy settings
    And I configure profile visibility
    Then I should be able to make profile public
    And I should be able to make profile visible to league members only
    And I should be able to make profile private

  @privacy-settings
  Scenario: Configure data sharing preferences
    Given I am logged in as a user
    When I configure data sharing
    Then I should be able to opt out of analytics
    And I should be able to opt out of personalized recommendations
    And I should be able to control third-party data sharing

  @privacy-settings
  Scenario: Configure activity status visibility
    Given I am logged in as a user
    When I configure activity status
    Then I should be able to show online status
    And I should be able to hide online status
    And I should be able to show last active time

  @privacy-settings
  Scenario: Block a user
    Given I am logged in as a user
    When I block another user
    Then the blocked user should not be able to message me
    And the blocked user should not see my profile
    And I should not see the blocked user's activity

  @privacy-settings
  Scenario: View and manage blocked users
    Given I am logged in as a user
    And I have blocked users
    When I view my blocked users list
    Then I should see all blocked users
    And I should be able to unblock users
    And I should see when each user was blocked

  @privacy-settings
  Scenario: Configure search visibility
    Given I am logged in as a user
    When I configure search visibility
    Then I should be able to appear in user search
    And I should be able to hide from user search
    And I should control who can find me by email

  @privacy-settings
  Scenario: Request privacy report
    Given I am logged in as a user
    When I request a privacy report
    Then I should receive a report of my data
    And the report should show what data is collected
    And the report should show how data is used

  # --------------------------------------------------------------------------
  # League Settings
  # --------------------------------------------------------------------------

  @league-settings
  Scenario: Configure scoring rules
    Given I am a commissioner
    When I navigate to league scoring settings
    Then I should be able to set points per reception
    And I should be able to configure passing touchdowns
    And I should be able to set rushing yards per point
    And I should be able to configure bonus scoring

  @league-settings
  Scenario: Configure roster limits
    Given I am a commissioner
    When I configure roster settings
    Then I should be able to set roster size
    And I should be able to configure starting lineup positions
    And I should be able to set bench size
    And I should be able to configure IR spots

  @league-settings
  Scenario: Configure transaction rules
    Given I am a commissioner
    When I configure transaction settings
    Then I should be able to set waiver type
    And I should be able to configure trade deadline
    And I should be able to set trade review period
    And I should be able to configure transaction limits

  @league-settings
  Scenario: Configure draft settings
    Given I am a commissioner
    When I configure draft settings
    Then I should be able to set draft type
    And I should be able to configure draft order
    And I should be able to set time per pick
    And I should be able to configure keeper rules

  @league-settings
  Scenario: Configure playoff settings
    Given I am a commissioner
    When I configure playoff settings
    Then I should be able to set number of playoff teams
    And I should be able to configure playoff weeks
    And I should be able to set playoff seeding rules
    And I should be able to configure tiebreaker rules

  @league-settings
  Scenario: Lock league settings
    Given I am a commissioner
    And the season has started
    When I try to change locked settings
    Then certain settings should be locked
    And I should see which settings cannot be changed
    And I should see when settings can be modified again

  # --------------------------------------------------------------------------
  # Team Settings
  # --------------------------------------------------------------------------

  @team-settings
  Scenario: Update team name
    Given I am logged in as a team owner
    When I navigate to team settings
    And I update my team name
    Then my team name should be changed
    And the new name should appear throughout the league

  @team-settings
  Scenario: Upload team logo
    Given I am logged in as a team owner
    When I upload a new team logo
    Then the logo should be validated for size and format
    And the logo should be displayed for my team
    And the logo should appear in matchups and standings

  @team-settings
  Scenario: Select team colors
    Given I am logged in as a team owner
    When I select team colors
    Then I should be able to choose primary color
    And I should be able to choose secondary color
    And my team branding should reflect these colors

  @team-settings
  Scenario: Configure team display preferences
    Given I am logged in as a team owner
    When I configure team display preferences
    Then I should be able to set roster view default
    And I should be able to configure matchup display
    And I should be able to set default sort order

  @team-settings
  Scenario: Set team motto
    Given I am logged in as a team owner
    When I set my team motto
    Then the motto should be displayed on my team page
    And the motto should be visible to league members

  @team-settings
  Scenario: Configure team privacy
    Given I am logged in as a team owner
    When I configure team privacy settings
    Then I should be able to hide bench from opponents
    And I should be able to hide recent transactions
    And I should be able to control lineup visibility before lock

  # --------------------------------------------------------------------------
  # App Settings
  # --------------------------------------------------------------------------

  @app-settings
  Scenario: Set language preference
    Given I am logged in as a user
    When I navigate to app settings
    And I select a language
    Then the app should display in the selected language
    And the preference should persist across sessions

  @app-settings
  Scenario: Set timezone
    Given I am logged in as a user
    When I set my timezone
    Then all times should display in my timezone
    And game times should be converted correctly
    And deadline times should be accurate

  @app-settings
  Scenario: Configure date format
    Given I am logged in as a user
    When I configure date format
    Then I should be able to choose MM/DD/YYYY format
    And I should be able to choose DD/MM/YYYY format
    And dates should display in my chosen format

  @app-settings
  Scenario: Configure number format
    Given I am logged in as a user
    When I configure number format
    Then I should be able to set decimal separator
    And I should be able to set thousands separator
    And numbers should display in my chosen format

  @app-settings
  Scenario: Configure currency display
    Given I am logged in as a user
    When I configure currency settings
    Then I should be able to select currency symbol
    And I should be able to set currency position
    And FAAB and financial values should display correctly

  @app-settings
  Scenario: Set default home page
    Given I am logged in as a user
    When I set my default home page
    Then I should be able to choose dashboard
    And I should be able to choose my team
    And I should be able to choose league home
    And that page should load on login

  # --------------------------------------------------------------------------
  # Integration Settings
  # --------------------------------------------------------------------------

  @integration-settings
  Scenario: Connect social media accounts
    Given I am logged in as a user
    When I navigate to integration settings
    And I connect my social media account
    Then I should be able to share content easily
    And I should be able to disconnect at any time

  @integration-settings
  Scenario: Configure API access
    Given I am logged in as a user
    When I configure API access
    Then I should be able to generate API keys
    And I should be able to set API permissions
    And I should be able to revoke API keys

  @integration-settings
  Scenario: Connect third-party fantasy apps
    Given I am logged in as a user
    When I connect a third-party app
    Then I should authorize specific permissions
    And I should see what data the app can access
    And I should be able to revoke access

  @integration-settings
  Scenario: Configure sync options
    Given I am logged in as a user
    When I configure sync settings
    Then I should be able to enable calendar sync
    And I should be able to sync with other fantasy platforms
    And I should be able to set sync frequency

  @integration-settings
  Scenario: View connected applications
    Given I am logged in as a user
    When I view connected applications
    Then I should see all connected apps
    And I should see permissions granted to each
    And I should see last activity date

  @integration-settings
  Scenario: Configure webhook settings
    Given I am logged in as a user
    When I configure webhooks
    Then I should be able to add webhook endpoints
    And I should be able to select events to trigger
    And I should be able to test webhook delivery

  # --------------------------------------------------------------------------
  # Data Settings
  # --------------------------------------------------------------------------

  @data-settings
  Scenario: Export personal data
    Given I am logged in as a user
    When I request a data export
    Then I should receive my data in downloadable format
    And the export should include profile data
    And the export should include transaction history
    And the export should include league history

  @data-settings
  Scenario: Export league data
    Given I am a commissioner
    When I export league data
    Then I should receive league configuration
    And I should receive roster data
    And I should receive transaction history
    And I should receive scoring history

  @data-settings
  Scenario: Import league data
    Given I am a commissioner
    When I import league data
    Then I should be able to upload from supported formats
    And the data should be validated
    And I should see import preview before confirming

  @data-settings
  Scenario: Configure backup preferences
    Given I am logged in as a user
    When I configure backup settings
    Then I should be able to enable automatic backups
    And I should be able to set backup frequency
    And I should be able to choose backup destination

  @data-settings
  Scenario: Configure data retention
    Given I am a commissioner
    When I configure data retention settings
    Then I should be able to set history retention period
    And I should be able to configure message retention
    And I should be able to set transaction log retention

  @data-settings
  Scenario: Clear local cache
    Given I am logged in as a user
    When I clear local cache
    Then cached data should be removed
    And I should see confirmation message
    And fresh data should be fetched on next load

  @data-settings
  Scenario: Download transaction history
    Given I am logged in as a user
    When I download my transaction history
    Then I should receive all my transactions
    And I should be able to choose date range
    And I should be able to select export format

  # --------------------------------------------------------------------------
  # Accessibility Settings
  # --------------------------------------------------------------------------

  @accessibility-settings
  Scenario: Enable screen reader support
    Given I am logged in as a user
    When I enable screen reader support
    Then all content should have proper ARIA labels
    And images should have alt text
    And interactive elements should be properly announced

  @accessibility-settings
  Scenario: Configure keyboard navigation
    Given I am logged in as a user
    When I configure keyboard navigation
    Then all interactive elements should be focusable
    And I should be able to navigate with Tab key
    And I should see visible focus indicators

  @accessibility-settings
  Scenario: Adjust color contrast
    Given I am logged in as a user
    When I enable high contrast mode
    Then text should have enhanced contrast
    And UI elements should be more distinguishable
    And the mode should meet WCAG guidelines

  @accessibility-settings
  Scenario: Enable reduced motion
    Given I am logged in as a user
    When I enable reduced motion
    Then animations should be minimized or disabled
    And transitions should be simplified
    And auto-playing content should be paused

  @accessibility-settings
  Scenario: Configure text spacing
    Given I am logged in as a user
    When I configure text spacing settings
    Then I should be able to increase line height
    And I should be able to increase letter spacing
    And I should be able to increase word spacing

  @accessibility-settings
  Scenario: Enable dyslexia-friendly mode
    Given I am logged in as a user
    When I enable dyslexia-friendly mode
    Then a dyslexia-friendly font should be used
    And text spacing should be optimized
    And background colors should be adjusted

  @accessibility-settings
  Scenario: Configure focus indicators
    Given I am logged in as a user
    When I configure focus indicator settings
    Then I should be able to increase focus ring size
    And I should be able to change focus ring color
    And focus should always be visible

  @accessibility-settings
  Scenario: Enable voice control hints
    Given I am logged in as a user
    When I enable voice control hints
    Then I should see labels for voice commands
    And interactive elements should show voice targets
    And help should be available for voice navigation

  # --------------------------------------------------------------------------
  # Settings Management
  # --------------------------------------------------------------------------

  @settings @management
  Scenario: Reset settings to defaults
    Given I am logged in as a user
    When I reset settings to defaults
    And I confirm the reset
    Then all my settings should revert to defaults
    And I should see confirmation message

  @settings @management
  Scenario: Export settings configuration
    Given I am logged in as a user
    When I export my settings
    Then I should receive a settings file
    And the file should include all my preferences
    And I should be able to import it later

  @settings @management
  Scenario: Import settings configuration
    Given I am logged in as a user
    When I import a settings file
    Then my settings should be updated
    And I should see which settings were changed
    And I should be able to undo the import

  @settings @management
  Scenario: Sync settings across devices
    Given I am logged in as a user
    When I enable settings sync
    Then my settings should sync across devices
    And changes on one device should appear on others
    And I should be able to disable sync

  # --------------------------------------------------------------------------
  # Error Handling and Validation
  # --------------------------------------------------------------------------

  @settings @error-handling
  Scenario: Handle invalid setting value
    Given I am logged in as a user
    When I enter an invalid setting value
    Then I should see a validation error
    And the invalid value should not be saved
    And I should see guidance on valid values

  @settings @error-handling
  Scenario: Handle settings save failure
    Given I am logged in as a user
    When saving settings fails due to network error
    Then I should see an error message
    And my changes should not be lost
    And I should be able to retry saving

  @settings @error-handling
  Scenario: Recover from corrupted settings
    Given I am logged in as a user
    And my settings have become corrupted
    When I try to load settings
    Then the system should detect corruption
    And I should be offered to reset to defaults
    And I should be warned about data loss

  @settings @validation
  Scenario: Validate email format
    Given I am logged in as a user
    When I enter an invalid email format
    Then I should see an email format error
    And the invalid email should not be saved

  @settings @validation
  Scenario: Validate image upload
    Given I am logged in as a user
    When I upload an invalid image
    Then I should see an error about file requirements
    And I should see allowed formats and sizes
    And the invalid file should be rejected
