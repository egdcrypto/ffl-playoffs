@user-profile @account
Feature: User Profile
  As a fantasy football manager
  I want to manage my user profile and settings
  So that I can personalize my experience and control my account

  Background:
    Given I am logged in as a registered user
    And I have access to my profile settings

  # ============================================================================
  # PROFILE SETTINGS
  # ============================================================================

  @happy-path @settings
  Scenario: View my profile settings
    When I navigate to profile settings
    Then I should see my current profile information
    And I should see editable fields
    And I should see save and cancel options

  @happy-path @settings
  Scenario: Update basic profile information
    When I update my profile information:
      | Field        | Value              |
      | First Name   | John               |
      | Last Name    | Smith              |
      | Email        | john@example.com   |
      | Time Zone    | America/New_York   |
    And I save the changes
    Then my profile should be updated
    And I should see a success confirmation

  @happy-path @settings
  Scenario: Change email address
    Given my current email is "old@example.com"
    When I change my email to "new@example.com"
    Then a verification email should be sent
    And my email should update after verification
    And I should be notified of the change

  @validation @settings
  Scenario: Validate email format
    When I enter an invalid email format "notanemail"
    Then I should see "Please enter a valid email address"
    And the save button should be disabled

  @happy-path @settings
  Scenario: Change preferred language
    When I change my language preference to "Spanish"
    Then the interface should update to Spanish
    And my preference should be saved

  @happy-path @settings
  Scenario: Set date and time format preferences
    When I configure display preferences:
      | Setting      | Value         |
      | Date Format  | MM/DD/YYYY    |
      | Time Format  | 12-hour       |
      | Week Start   | Sunday        |
    Then dates and times should display accordingly

  # ============================================================================
  # AVATAR UPLOAD
  # ============================================================================

  @happy-path @avatar
  Scenario: Upload profile avatar
    When I upload a profile picture
    Then my avatar should be updated
    And the image should be resized appropriately
    And I should see a preview before saving

  @happy-path @avatar
  Scenario: Crop avatar before upload
    When I select an image for my avatar
    Then I should see a cropping interface
    And I should be able to adjust the crop area
    And I should preview the final result

  @validation @avatar
  Scenario: Validate avatar file size
    When I upload an image larger than 5MB
    Then I should see "Image must be less than 5MB"
    And the upload should be rejected

  @validation @avatar
  Scenario: Validate avatar file type
    When I upload a non-image file
    Then I should see "Please upload a valid image (JPG, PNG, GIF)"
    And the upload should be rejected

  @happy-path @avatar
  Scenario: Remove current avatar
    Given I have a custom avatar
    When I remove my avatar
    Then my avatar should revert to default
    And I should see the default avatar placeholder

  @happy-path @avatar
  Scenario: Use avatar from connected account
    Given I have connected my Google account
    When I choose to use my Google profile picture
    Then my avatar should sync from Google
    And it should update if my Google picture changes

  @happy-path @avatar
  Scenario: Choose from preset avatars
    When I browse preset avatar options
    Then I should see a gallery of preset images
    And I should be able to select one
    And my selection should be saved

  # ============================================================================
  # DISPLAY NAME
  # ============================================================================

  @happy-path @display-name
  Scenario: Set display name
    When I set my display name to "FantasyKing2024"
    Then my display name should be updated
    And this name should appear throughout the app
    And other users should see this name

  @validation @display-name
  Scenario: Validate display name length
    When I enter a display name longer than 20 characters
    Then I should see "Display name must be 20 characters or less"
    And the name should not be saved

  @validation @display-name
  Scenario: Validate display name characters
    When I enter a display name with special characters "$#@!"
    Then I should see "Display name can only contain letters, numbers, and underscores"
    And the name should not be saved

  @validation @display-name
  Scenario: Check display name availability
    Given "FantasyKing" is already taken
    When I try to use "FantasyKing" as my display name
    Then I should see "This display name is already in use"
    And I should see suggestions for alternatives

  @happy-path @display-name
  Scenario: Display name history
    When I view my display name history
    Then I should see my previous display names
    And I should see when each was used

  # ============================================================================
  # BIO SECTION
  # ============================================================================

  @happy-path @bio
  Scenario: Add profile bio
    When I add a bio:
      """
      5-time fantasy champion. Die-hard Chiefs fan.
      Trading is my specialty!
      """
    Then my bio should be saved
    And it should appear on my public profile

  @validation @bio
  Scenario: Validate bio length
    When I enter a bio longer than 500 characters
    Then I should see "Bio must be 500 characters or less"
    And I should see the character count

  @happy-path @bio
  Scenario: Format bio with basic styling
    When I add formatting to my bio
    Then I should be able to use bold and italic
    And links should be clickable
    And line breaks should be preserved

  @moderation @bio
  Scenario: Bio content moderation
    When I submit a bio with inappropriate content
    Then the content should be flagged for review
    And I should be notified of the moderation
    And the bio should not display until approved

  @happy-path @bio
  Scenario: Add social links to bio
    When I add social media links:
      | Platform | Handle        |
      | Twitter  | @fantasykng   |
      | Instagram| @fantasykng   |
    Then the links should appear on my profile
    And they should be clickable

  # ============================================================================
  # TEAM BRANDING
  # ============================================================================

  @happy-path @team-branding
  Scenario: Upload team logo
    When I upload a team logo
    Then my logo should appear next to my team
    And it should display in matchups and standings
    And I should see size requirements

  @happy-path @team-branding
  Scenario: Set team colors
    When I set my team colors:
      | Color Type | Value   |
      | Primary    | #FF0000 |
      | Secondary  | #000000 |
    Then my team should use these colors
    And they should appear in team displays

  @happy-path @team-branding
  Scenario: Choose team mascot
    When I select a mascot from the gallery
    Then my mascot should appear with my team
    And it should be visible in the draft room
    And it should show in matchups

  @happy-path @team-branding
  Scenario: Set team motto/slogan
    When I set my team motto to "Champions breed champions"
    Then my motto should appear on my team page
    And it should be visible to league members

  @happy-path @team-branding
  Scenario: Apply team theme
    When I apply a pre-designed team theme
    Then my team should use the theme colors and graphics
    And I should be able to preview before applying

  @happy-path @team-branding
  Scenario: Different branding per league
    Given I am in multiple leagues
    When I set different branding for each team
    Then each team should have its own branding
    And branding should be league-specific

  # ============================================================================
  # PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy
  Scenario: Set profile visibility
    When I set my profile visibility to "League Members Only"
    Then only league members should see my full profile
    And non-members should see limited information

  @happy-path @privacy
  Scenario: Configure what's visible publicly
    When I configure privacy settings:
      | Setting          | Visibility    |
      | Win-Loss Record  | Public        |
      | Roster           | League Only   |
      | Activity Feed    | Private       |
      | Achievements     | Public        |
    Then my profile should respect these settings

  @happy-path @privacy
  Scenario: Hide from league directory
    When I enable "Hide from league directory"
    Then I should not appear in public league searches
    And I should still be visible to my leagues

  @happy-path @privacy
  Scenario: Block another user
    When I block "SpamUser123"
    Then I should not see content from that user
    And they should not be able to message me
    And they should not see my activity

  @happy-path @privacy
  Scenario: Manage blocked users
    When I view my blocked users list
    Then I should see all blocked users
    And I should be able to unblock users
    And I should see when I blocked them

  @happy-path @privacy
  Scenario: Control search engine indexing
    When I disable "Allow search engine indexing"
    Then my profile should not appear in Google
    And robots.txt should block my profile
    And I should understand the privacy implications

  # ============================================================================
  # ACCOUNT LINKING
  # ============================================================================

  @happy-path @linking
  Scenario: Link Google account
    When I link my Google account
    Then I should be redirected to Google OAuth
    And upon success, accounts should be linked
    And I should be able to sign in with Google

  @happy-path @linking
  Scenario: Link Apple account
    When I link my Apple account
    Then I should complete Apple sign-in
    And accounts should be linked
    And I should be able to sign in with Apple

  @happy-path @linking
  Scenario: Link other fantasy platforms
    When I link my ESPN Fantasy account
    Then I should authorize the connection
    And I should be able to import leagues
    And my history should sync

  @happy-path @linking
  Scenario: View linked accounts
    When I view my linked accounts
    Then I should see all connected services
    And I should see connection status
    And I should see last sync time

  @happy-path @linking
  Scenario: Unlink an account
    Given my Google account is linked
    When I unlink my Google account
    Then the connection should be removed
    And I should confirm before unlinking
    And I should still be able to log in with password

  @validation @linking
  Scenario: Cannot unlink only sign-in method
    Given I only have Google sign-in configured
    When I try to unlink Google
    Then I should see "Please set up a password before unlinking"
    And the unlink should be prevented

  # ============================================================================
  # ACHIEVEMENT BADGES
  # ============================================================================

  @happy-path @achievements
  Scenario: View earned achievements
    When I view my achievements
    Then I should see all badges I've earned
    And I should see when each was earned
    And I should see the achievement criteria

  @happy-path @achievements
  Scenario: View achievement progress
    When I view achievement progress
    Then I should see progress toward locked achievements
    And I should see what's needed to unlock
    And I should see percentage complete

  @happy-path @achievements
  Scenario: Display featured achievements
    When I select achievements to feature on my profile
    Then those achievements should be prominently displayed
    And I should be able to feature up to 5
    And visitors should see my featured badges

  @happy-path @achievements
  Scenario: Earn new achievement
    Given I am close to winning 50 games
    When I win my 50th game
    Then I should earn the "50 Wins" achievement
    And I should receive a notification
    And the badge should appear on my profile

  @happy-path @achievements
  Scenario: View rare achievements
    When I view the achievement gallery
    Then I should see rarity indicators
    And I should see what percentage of users have each
    And rare achievements should be highlighted

  @happy-path @achievements
  Scenario: Share achievement
    When I share an achievement
    Then I should get a shareable image/link
    And it should be formatted for social media
    And it should show the achievement details

  # ============================================================================
  # ACTIVITY HISTORY
  # ============================================================================

  @happy-path @activity
  Scenario: View my activity history
    When I view my activity history
    Then I should see all my recent actions:
      | Activity Type    | Details                |
      | Trade Completed  | Sent Henry for Allen   |
      | Waiver Claim     | Added Kelce            |
      | Lineup Change    | Started Wilson at QB   |
      | Message Sent     | Matchup chat           |

  @happy-path @activity
  Scenario: Filter activity history
    When I filter activity by "Trades"
    Then I should see only trade-related activity
    And I should be able to filter by date range

  @happy-path @activity
  Scenario: View activity statistics
    When I view my activity stats
    Then I should see:
      | Stat             | Value |
      | Trades Made      | 15    |
      | Waiver Claims    | 42    |
      | Lineup Changes   | 156   |
      | Messages Sent    | 89    |

  @happy-path @activity
  Scenario: Export activity history
    When I export my activity history
    Then I should receive a downloadable file
    And it should include all activity details
    And I should choose the format (CSV, JSON)

  @happy-path @activity
  Scenario: Clear activity history
    When I clear my activity history
    Then I should confirm the action
    And historical activity should be removed
    And new activity should still be tracked

  # ============================================================================
  # FAVORITE TEAMS
  # ============================================================================

  @happy-path @favorites
  Scenario: Set favorite NFL team
    When I set my favorite NFL team to "Kansas City Chiefs"
    Then my team affiliation should be saved
    And the Chiefs logo should appear on my profile
    And I should get relevant content recommendations

  @happy-path @favorites
  Scenario: Follow multiple NFL teams
    When I follow multiple teams:
      | Team            | Priority  |
      | Kansas City     | Primary   |
      | Philadelphia    | Secondary |
    Then I should receive updates for both teams
    And I should see customized content

  @happy-path @favorites
  Scenario: Set favorite players
    When I add "Patrick Mahomes" to my favorite players
    Then I should get alerts about Mahomes
    And his updates should be prioritized
    And I should see his fantasy impact

  @happy-path @favorites
  Scenario: View personalized content
    Given I have set my favorite team to Chiefs
    When I view the home page
    Then I should see Chiefs-related content
    And I should see fantasy impact of Chiefs players
    And recommendations should be personalized

  @happy-path @favorites
  Scenario: Remove favorite team
    Given "Chiefs" is my favorite team
    When I remove the Chiefs from favorites
    Then they should no longer be my favorite
    And recommendations should update

  # ============================================================================
  # NOTIFICATION PREFERENCES
  # ============================================================================

  @happy-path @notifications
  Scenario: Configure notification preferences
    When I configure notification settings
    Then I should see all notification categories
    And I should toggle each category on/off
    And I should choose delivery methods

  @happy-path @notifications
  Scenario: Set notification schedule
    When I set notification quiet hours
    Then I should specify start and end times
    And I should not receive notifications during quiet hours
    And urgent notifications should still come through

  @happy-path @notifications
  Scenario: Configure per-league notifications
    Given I am in multiple leagues
    When I configure notifications for each league
    Then settings should be league-specific
    And I can mute specific leagues

  @happy-path @notifications
  Scenario: Test notifications
    When I send a test notification
    Then I should receive a test push/email
    And I should confirm receipt
    And I should troubleshoot if not received

  @happy-path @notifications
  Scenario: Unsubscribe from all marketing
    When I unsubscribe from marketing emails
    Then I should only receive transactional emails
    And I should not receive promotional content
    And I should be able to resubscribe

  # ============================================================================
  # SECURITY SETTINGS
  # ============================================================================

  @happy-path @security
  Scenario: Change password
    When I change my password
    Then I should enter my current password
    And I should enter a new password twice
    And the password should meet security requirements

  @validation @security
  Scenario: Validate password strength
    When I enter a weak password "123456"
    Then I should see password strength indicator
    And I should see "Password must include uppercase, lowercase, number, and symbol"

  @happy-path @security
  Scenario: Enable two-factor authentication
    When I enable 2FA
    Then I should scan a QR code with authenticator app
    And I should verify with a code
    And I should save backup codes

  @happy-path @security
  Scenario: View login history
    When I view my login history
    Then I should see recent sign-in attempts
    And I should see location and device info
    And I should see any failed attempts

  @happy-path @security
  Scenario: Sign out all devices
    When I sign out from all devices
    Then all sessions should be terminated
    And I should be signed out everywhere
    And I should need to re-authenticate

  @happy-path @security
  Scenario: Set up security questions
    When I set up security questions
    Then I should choose 3 questions
    And I should provide answers
    And these should help with account recovery

  @happy-path @security
  Scenario: Download my data
    When I request a download of my data
    Then the system should prepare my data export
    And I should receive a download link
    And it should include all my personal data

  @happy-path @security
  Scenario: Delete my account
    When I request account deletion
    Then I should see what will be deleted
    And I should confirm with my password
    And I should have a grace period to cancel

  # ============================================================================
  # PROFILE VISIBILITY
  # ============================================================================

  @happy-path @visibility
  Scenario: View my public profile
    When I preview my public profile
    Then I should see what others see
    And I should see which sections are visible
    And I should be able to edit from preview

  @happy-path @visibility
  Scenario: Customize profile sections
    When I customize my profile layout
    Then I should reorder sections
    And I should show/hide specific sections
    And I should save my layout preference

  @happy-path @visibility
  Scenario: View another user's profile
    When I view "JohnSmith" profile
    Then I should see their public information
    And I should see their achievements
    And I should see their league activity

  @happy-path @visibility
  Scenario: Verify profile badge
    Given I have verified my identity
    When I view my profile
    Then I should see a verified badge
    And others should see I am verified

  @happy-path @visibility
  Scenario: Set profile to private
    When I set my entire profile to private
    Then only I should see my profile
    And others should see "This profile is private"
    And I should be hidden from searches

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Edit profile on mobile
    Given I am using a mobile device
    When I access my profile settings
    Then I should see a mobile-optimized interface
    And all settings should be accessible
    And I should be able to upload avatar from camera

  @mobile @responsive
  Scenario: Take photo for avatar on mobile
    Given I am on mobile
    When I choose to take a photo for avatar
    Then the camera should open
    And I should be able to take and crop the photo
    And I should preview before saving

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for profile
    Given I am using a screen reader
    When I navigate profile settings
    Then all form fields should be labeled
    And error messages should be announced
    And navigation should be clear

  @accessibility @a11y
  Scenario: Keyboard navigation for profile
    Given I am using keyboard only
    When I edit my profile
    Then I should tab through all fields
    And I should be able to save with Enter
    And focus should be visible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle profile save failure
    Given I am saving profile changes
    And the server is unavailable
    When the save fails
    Then I should see an error message
    And my changes should be preserved locally
    And I should be able to retry

  @error @resilience
  Scenario: Handle avatar upload failure
    Given I am uploading an avatar
    And the upload fails
    When the error occurs
    Then I should see "Upload failed - please try again"
    And my current avatar should remain
    And I should be able to retry

  @error @resilience
  Scenario: Handle session expiry during edit
    Given I am editing my profile
    And my session expires
    When I try to save
    Then I should be prompted to re-authenticate
    And my changes should be preserved
    And I should continue after login
