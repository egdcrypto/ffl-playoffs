@user-profile @ANIMA-1327
Feature: User Profile
  As a fantasy football application user
  I want to manage my profile and account settings
  So that I can personalize my experience and showcase my achievements

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # PROFILE CREATION AND EDITING - HAPPY PATH
  # ============================================================================

  @happy-path @profile-creation
  Scenario: Complete initial profile setup
    Given I am a new user
    When I complete the profile setup wizard
    Then my profile should be created
    And I should see my profile page
    And I should be welcomed to the platform

  @happy-path @profile-editing
  Scenario: Edit profile information
    Given I am viewing my profile
    When I click edit profile
    Then I should see editable fields
    And I should be able to modify my information
    And I should save my changes

  @happy-path @profile-editing
  Scenario: Update display name
    Given I am editing my profile
    When I change my display name
    And I save the changes
    Then my new display name should appear
    And it should update across the application
    And other users should see the change

  @happy-path @profile-editing
  Scenario: Update username
    Given I am editing my profile
    When I change my username
    And I verify the new username is available
    And I save the changes
    Then my username should be updated
    And my profile URL should reflect the change

  @happy-path @profile-editing
  Scenario: Preview profile changes before saving
    Given I am editing my profile
    When I preview my changes
    Then I should see how my profile will look
    And I should be able to continue editing
    And I should confirm before saving

  # ============================================================================
  # AVATAR AND PROFILE PHOTOS
  # ============================================================================

  @happy-path @avatar
  Scenario: Upload profile avatar
    Given I am editing my profile
    When I upload a new avatar image
    Then the image should be processed
    And I should be able to crop the image
    And my avatar should be updated

  @happy-path @avatar
  Scenario: Choose from preset avatars
    Given I am editing my avatar
    When I select from preset avatars
    Then I should see available options
    And I should select one
    And the selected avatar should be applied

  @happy-path @avatar
  Scenario: Upload cover photo
    Given I am editing my profile
    When I upload a cover photo
    Then the photo should be processed
    And I should be able to position it
    And the cover photo should be displayed

  @happy-path @avatar
  Scenario: Remove profile photo
    Given I have a profile photo
    When I remove my photo
    Then my photo should be deleted
    And a default avatar should be shown
    And the removal should be confirmed

  @happy-path @avatar
  Scenario: Resize and crop avatar
    Given I am uploading an avatar
    When I adjust the crop area
    Then I should see a preview
    And I should be able to zoom and pan
    And the cropped image should be saved

  @happy-path @avatar
  Scenario: Use team logo as avatar
    Given I have a fantasy team
    When I choose to use team logo as avatar
    Then my team logo should become my avatar
    And the option should sync with my team
    And updates should reflect automatically

  # ============================================================================
  # DISPLAY NAME AND USERNAME
  # ============================================================================

  @happy-path @display-name
  Scenario: Set display name with special characters
    Given I am editing my display name
    When I enter a name with allowed special characters
    Then the name should be accepted
    And it should display correctly
    And it should be searchable

  @happy-path @username
  Scenario: Check username availability
    Given I want to change my username
    When I enter a new username
    Then I should see if it's available
    And unavailable usernames should show error
    And suggestions should be offered

  @happy-path @username
  Scenario: View username change history
    Given I have changed my username before
    When I view username history
    Then I should see previous usernames
    And I should see change dates
    And old usernames should redirect

  @happy-path @username
  Scenario: Reserve username during grace period
    Given I recently changed my username
    When the grace period is active
    Then my old username should be reserved
    And others should not claim it
    And I should be able to revert

  # ============================================================================
  # BIO AND ABOUT SECTIONS
  # ============================================================================

  @happy-path @bio
  Scenario: Write profile bio
    Given I am editing my profile
    When I write my bio
    Then the bio should be saved
    And it should display on my profile
    And it should respect character limits

  @happy-path @bio
  Scenario: Format bio with markdown
    Given I am writing my bio
    When I use markdown formatting
    Then the formatting should be rendered
    And preview should show formatted text
    And links should be clickable

  @happy-path @bio
  Scenario: Add about section details
    Given I am editing my about section
    When I add personal details
    Then I should add location
    And I should add favorite team
    And I should add fantasy experience

  @happy-path @bio
  Scenario: Add social links to profile
    Given I am editing my profile
    When I add social media links
    Then links should be validated
    And they should display with icons
    And they should open in new tabs

  @happy-path @bio
  Scenario: Set fantasy philosophy
    Given I am editing my about section
    When I describe my fantasy philosophy
    Then it should be saved
    And other users should see it
    And it should be searchable

  # ============================================================================
  # TEAM HISTORY AND ACHIEVEMENTS
  # ============================================================================

  @happy-path @team-history
  Scenario: View complete team history
    Given I have played in multiple leagues
    When I view my team history
    Then I should see all my teams
    And I should see league names
    And I should see seasons played

  @happy-path @team-history
  Scenario: View historical performance
    Given I have team history
    When I view performance statistics
    Then I should see win-loss records
    And I should see playoff appearances
    And I should see championships won

  @happy-path @team-history
  Scenario: View team performance by season
    Given I have multi-season history
    When I select a specific season
    Then I should see that season's details
    And I should see weekly results
    And I should see roster snapshots

  @happy-path @achievements
  Scenario: View earned achievements
    Given I have earned achievements
    When I view my achievements
    Then I should see all achievements
    And I should see earn dates
    And I should see achievement details

  @happy-path @achievements
  Scenario: View achievement progress
    Given I have achievements in progress
    When I view achievement tracking
    Then I should see progress bars
    And I should see requirements remaining
    And I should see next milestones

  @happy-path @achievements
  Scenario: Share achievement unlocked
    Given I just earned an achievement
    When I share the achievement
    Then a shareable graphic should generate
    And I should share to social media
    And the share should include details

  # ============================================================================
  # TROPHY CASE
  # ============================================================================

  @happy-path @trophy-case
  Scenario: View trophy case
    Given I have won championships
    When I view my trophy case
    Then I should see all my trophies
    And they should be displayed prominently
    And I should see trophy details

  @happy-path @trophy-case
  Scenario: View individual trophy details
    Given I am viewing my trophy case
    When I click on a trophy
    Then I should see trophy details
    And I should see the league and year
    And I should see the championship matchup

  @happy-path @trophy-case
  Scenario: Arrange trophy case display
    Given I have multiple trophies
    When I arrange my trophy case
    Then I should be able to reorder trophies
    And I should be able to feature specific ones
    And the arrangement should be saved

  @happy-path @trophy-case
  Scenario: View championship banners
    Given I have won championships
    When I view championship banners
    Then I should see banners for each title
    And they should show league name and year
    And they should be shareable

  @happy-path @trophy-case
  Scenario: View other awards in trophy case
    Given I have won other awards
    When I view all awards
    Then I should see regular season titles
    And I should see division titles
    And I should see special awards

  # ============================================================================
  # WIN-LOSS RECORDS
  # ============================================================================

  @happy-path @win-loss-records
  Scenario: View overall win-loss record
    Given I have fantasy history
    When I view my overall record
    Then I should see total wins and losses
    And I should see winning percentage
    And I should see all-time statistics

  @happy-path @win-loss-records
  Scenario: View record by league
    Given I participate in multiple leagues
    When I view records by league
    Then I should see record per league
    And I should see league-specific stats
    And I should compare performance

  @happy-path @win-loss-records
  Scenario: View record by opponent
    Given I have played various opponents
    When I view head-to-head records
    Then I should see record vs each opponent
    And I should see rivalry information
    And I should see matchup history

  @happy-path @win-loss-records
  Scenario: View playoff record
    Given I have made playoffs
    When I view playoff record
    Then I should see playoff wins and losses
    And I should see championship appearances
    And I should see playoff batting average

  @happy-path @win-loss-records
  Scenario: View records over time
    Given I have multi-year history
    When I view records by year
    Then I should see year-by-year breakdown
    And I should see trends over time
    And I should see career trajectory

  # ============================================================================
  # PROFILE PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy-settings
  Scenario: Set profile to public
    Given I am editing privacy settings
    When I set my profile to public
    Then anyone should be able to view it
    And my activity should be visible
    And I should see what's public

  @happy-path @privacy-settings
  Scenario: Set profile to private
    Given I am editing privacy settings
    When I set my profile to private
    Then only approved users can view it
    And my activity should be hidden
    And a private indicator should show

  @happy-path @privacy-settings
  Scenario: Configure individual privacy options
    Given I want granular privacy control
    When I configure individual settings
    Then I should set team history visibility
    And I should set trophy case visibility
    And I should set activity visibility

  @happy-path @privacy-settings
  Scenario: Hide from league finder
    Given I want to control discoverability
    When I hide from league finder
    Then I should not appear in searches
    And my profile should be less visible
    And league invites should still work

  @happy-path @privacy-settings
  Scenario: Block specific users from profile
    Given I want to restrict access
    When I block a specific user
    Then they should not see my profile
    And they should not contact me
    And I should manage blocked users

  # ============================================================================
  # LINKED ACCOUNTS
  # ============================================================================

  @happy-path @linked-accounts
  Scenario: Link social media account
    Given I want to link a social account
    When I connect my Twitter/X account
    Then I should authorize the connection
    And the account should be linked
    And I should see linked status

  @happy-path @linked-accounts
  Scenario: Link multiple platform accounts
    Given I use multiple fantasy platforms
    When I link other platform accounts
    Then I should connect ESPN, Yahoo, etc.
    And my history should be imported
    And stats should be consolidated

  @happy-path @linked-accounts
  Scenario: View all linked accounts
    Given I have linked accounts
    When I view linked accounts
    Then I should see all connections
    And I should see connection status
    And I should manage each connection

  @happy-path @linked-accounts
  Scenario: Unlink account
    Given I have a linked account
    When I unlink the account
    Then the connection should be removed
    And associated data should be handled
    And the unlink should be confirmed

  @happy-path @linked-accounts
  Scenario: Refresh linked account data
    Given I have linked accounts
    When I refresh account data
    Then latest data should be fetched
    And profile should be updated
    And sync status should be shown

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @notification-preferences
  Scenario: Configure email notification preferences
    Given I am in notification settings
    When I configure email preferences
    Then I should set email types
    And I should set email frequency
    And preferences should be saved

  @happy-path @notification-preferences
  Scenario: Configure push notification preferences
    Given I am in notification settings
    When I configure push preferences
    Then I should enable or disable types
    And I should set priority levels
    And preferences should be saved

  @happy-path @notification-preferences
  Scenario: Set notification quiet hours
    Given I want quiet time
    When I set quiet hours
    Then I should set time range
    And notifications should pause during quiet hours
    And settings should be saved

  @happy-path @notification-preferences
  Scenario: Configure notification digest
    Given I prefer consolidated notifications
    When I enable digest mode
    Then I should choose digest frequency
    And notifications should be batched
    And digests should be sent on schedule

  # ============================================================================
  # ACCOUNT SETTINGS
  # ============================================================================

  @happy-path @account-settings
  Scenario: Update email address
    Given I want to change my email
    When I enter a new email address
    Then I should verify the new email
    And the email should be updated
    And confirmation should be sent

  @happy-path @account-settings
  Scenario: Update phone number
    Given I want to update my phone
    When I enter a new phone number
    Then I should verify via SMS
    And the phone should be updated
    And confirmation should be sent

  @happy-path @account-settings
  Scenario: Change account language
    Given I want to change language
    When I select a different language
    Then the application should update
    And all text should translate
    And preference should be saved

  @happy-path @account-settings
  Scenario: Change timezone
    Given I want to update my timezone
    When I select a new timezone
    Then times should adjust
    And notifications should follow new timezone
    And preference should be saved

  @happy-path @account-settings
  Scenario: Delete account
    Given I want to delete my account
    When I initiate account deletion
    Then I should see warnings
    And I should confirm deletion
    And the account should be deleted

  @happy-path @account-settings
  Scenario: Download account data
    Given I want a copy of my data
    When I request data download
    Then my data should be compiled
    And I should receive a download link
    And all data should be included

  # ============================================================================
  # PASSWORD MANAGEMENT
  # ============================================================================

  @happy-path @password-management
  Scenario: Change password
    Given I am logged in
    When I change my password
    Then I should enter current password
    And I should enter new password twice
    And the password should be updated

  @happy-path @password-management
  Scenario: Password strength validation
    Given I am setting a new password
    When I enter a password
    Then I should see strength indicator
    And I should see requirements
    And weak passwords should be rejected

  @happy-path @password-management
  Scenario: Reset forgotten password
    Given I forgot my password
    When I request a password reset
    Then I should receive a reset link
    And I should be able to set new password
    And the reset should be confirmed

  @happy-path @password-management
  Scenario: View active sessions
    Given I want to see my sessions
    When I view active sessions
    Then I should see all logged in devices
    And I should see location and time
    And I should be able to revoke sessions

  @happy-path @password-management
  Scenario: Revoke all sessions
    Given I want to sign out everywhere
    When I revoke all sessions
    Then all sessions should be terminated
    And I should need to re-authenticate
    And the action should be logged

  # ============================================================================
  # TWO-FACTOR AUTHENTICATION
  # ============================================================================

  @happy-path @two-factor-auth
  Scenario: Enable two-factor authentication
    Given I want to secure my account
    When I enable 2FA
    Then I should see setup instructions
    And I should scan QR code
    And 2FA should be activated

  @happy-path @two-factor-auth
  Scenario: Configure authenticator app
    Given I am setting up 2FA
    When I configure an authenticator
    Then I should see QR code
    And I should enter verification code
    And the authenticator should be linked

  @happy-path @two-factor-auth
  Scenario: Generate backup codes
    Given I have 2FA enabled
    When I generate backup codes
    Then I should receive one-time codes
    And I should store them securely
    And they should work for recovery

  @happy-path @two-factor-auth
  Scenario: Use backup code for login
    Given I cannot access my authenticator
    When I use a backup code
    Then I should be able to login
    And the code should be consumed
    And I should be warned about remaining codes

  @happy-path @two-factor-auth
  Scenario: Disable two-factor authentication
    Given I have 2FA enabled
    When I disable 2FA
    Then I should verify my identity
    And 2FA should be removed
    And I should be warned about security

  @happy-path @two-factor-auth
  Scenario: Configure SMS as 2FA backup
    Given I want SMS backup for 2FA
    When I add SMS as backup method
    Then I should verify my phone number
    And SMS should be available as fallback
    And I should receive codes via SMS

  # ============================================================================
  # PROFILE SHARING
  # ============================================================================

  @happy-path @profile-sharing
  Scenario: Share profile link
    Given I want to share my profile
    When I get my profile link
    Then I should receive a shareable URL
    And the link should work for others
    And I should be able to copy it

  @happy-path @profile-sharing
  Scenario: Generate profile card
    Given I want to share a profile card
    When I generate my profile card
    Then a visual card should be created
    And it should contain key stats
    And it should be downloadable

  @happy-path @profile-sharing
  Scenario: Share profile to social media
    Given I want to share to social
    When I share my profile
    Then I should choose a platform
    And the share should be formatted
    And it should link back to my profile

  @happy-path @profile-sharing
  Scenario: Create shareable stat graphic
    Given I want to share specific stats
    When I create a stat graphic
    Then I should select stats to include
    And a graphic should be generated
    And it should be shareable

  @happy-path @profile-sharing
  Scenario: View profile share analytics
    Given I have shared my profile
    When I view share analytics
    Then I should see view counts
    And I should see share sources
    And I should see engagement

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Profile image upload fails
    Given I am uploading a profile image
    When the upload fails
    Then I should see an error message
    And my current image should remain
    And I should be able to retry

  @error
  Scenario: Username already taken
    Given I am changing my username
    When I enter a taken username
    Then I should see unavailability error
    And I should see suggestions
    And I should try a different name

  @error
  Scenario: Invalid email format
    Given I am updating my email
    When I enter an invalid format
    Then I should see validation error
    And the field should be highlighted
    And I should correct the format

  @error
  Scenario: Profile save fails
    Given I am saving profile changes
    When the save fails
    Then I should see an error message
    And my changes should be preserved
    And I should be able to retry

  @error
  Scenario: 2FA setup fails
    Given I am setting up 2FA
    When the setup fails
    Then I should see an error message
    And I should be able to retry
    And my account should remain secure

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Edit profile on mobile
    Given I am using the mobile app
    When I edit my profile
    Then the interface should be mobile-friendly
    And all fields should be accessible
    And saving should work properly

  @mobile
  Scenario: Upload avatar from mobile camera
    Given I am on mobile
    When I take a photo for avatar
    Then the camera should open
    And I should capture the image
    And it should be uploaded

  @mobile
  Scenario: View profile on mobile
    Given I am viewing a profile on mobile
    When the profile loads
    Then the layout should be responsive
    And all sections should be visible
    And navigation should be easy

  @mobile
  Scenario: Manage settings on mobile
    Given I am managing settings on mobile
    When I access various settings
    Then all options should be accessible
    And toggles should work on touch
    And changes should save properly

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate profile with keyboard
    Given I am using keyboard navigation
    When I navigate my profile
    Then all elements should be accessible
    And focus should move logically
    And actions should work with keyboard

  @accessibility
  Scenario: Screen reader profile access
    Given I am using a screen reader
    When I view or edit my profile
    Then all content should be readable
    And form fields should be labeled
    And actions should be announced

  @accessibility
  Scenario: High contrast profile display
    Given I have high contrast mode enabled
    When I view profiles
    Then text should be readable
    And buttons should be visible
    And status indicators should be clear

  @accessibility
  Scenario: Profile with reduced motion
    Given I have reduced motion preferences
    When I interact with my profile
    Then animations should be minimized
    And transitions should be simple
    And functionality should be preserved
