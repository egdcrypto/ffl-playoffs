@user-profiles
Feature: User Profiles
  As a fantasy football user
  I want to manage my profile
  So that I can showcase my achievements and connect with other managers

  # --------------------------------------------------------------------------
  # Profile Creation
  # --------------------------------------------------------------------------

  @profile-creation
  Scenario: Complete initial profile setup
    Given I have just registered for an account
    When I am prompted to set up my profile
    Then I should be able to enter my display name
    And I should be able to select a username
    And I should be able to upload an avatar
    And I should be able to write a bio

  @profile-creation
  Scenario: Select unique username
    Given I am setting up my profile
    When I enter a username
    Then the system should check for availability
    And I should see if the username is taken
    And I should be able to choose an available username
    And the username should meet format requirements

  @profile-creation
  Scenario: Upload profile avatar
    Given I am setting up my profile
    When I upload an avatar image
    Then the image should be validated for format
    And the image should be validated for size
    And I should be able to crop the image
    And the avatar should be saved to my profile

  @profile-creation
  Scenario: Write profile bio
    Given I am setting up my profile
    When I write my bio
    Then I should have a character limit
    And I should be able to include links
    And I should be able to use basic formatting
    And the bio should be saved to my profile

  @profile-creation
  Scenario: Skip optional profile fields
    Given I am setting up my profile
    When I skip optional fields
    Then I should be able to complete setup
    And I should have a basic profile created
    And I should be able to add details later

  @profile-creation
  Scenario: Choose profile template
    Given I am setting up my profile
    When I choose a profile template
    Then I should see template options
    And the template should pre-configure layout
    And I should be able to customize from template

  # --------------------------------------------------------------------------
  # Profile Editing
  # --------------------------------------------------------------------------

  @profile-editing
  Scenario: Update profile information
    Given I am logged in
    When I navigate to profile settings
    And I update my display name
    And I save the changes
    Then my profile should be updated
    And I should see confirmation message

  @profile-editing
  Scenario: Change profile avatar
    Given I am logged in
    When I navigate to profile settings
    And I upload a new avatar
    Then my avatar should be updated
    And the old avatar should be replaced
    And the change should be visible immediately

  @profile-editing
  Scenario: Edit profile bio
    Given I am logged in
    When I edit my bio
    And I save the changes
    Then my bio should be updated
    And the changes should be visible on my profile

  @profile-editing
  Scenario: Update contact details
    Given I am logged in
    When I update my contact details
    And I add my email for display
    And I add my social media links
    Then my contact details should be updated
    And visibility should respect my privacy settings

  @profile-editing
  Scenario: Add profile header image
    Given I am logged in
    When I upload a header image
    Then the header should appear on my profile
    And I should be able to reposition the image
    And I should be able to remove the header

  @profile-editing
  Scenario: Update profile location
    Given I am logged in
    When I update my location
    Then I should be able to enter city and state
    And I should be able to select timezone
    And location should display on my profile

  # --------------------------------------------------------------------------
  # Profile Display
  # --------------------------------------------------------------------------

  @profile-display
  Scenario: View public profile
    Given I am viewing another user's profile
    Then I should see their display name
    And I should see their avatar
    And I should see their bio
    And I should see their public stats
    And I should see their achievements

  @profile-display
  Scenario: View profile cards
    Given I am viewing a list of users
    When I see profile cards
    Then each card should show avatar
    And each card should show username
    And each card should show key stats
    And I should be able to click to view full profile

  @profile-display
  Scenario: Display profile badges
    Given I am viewing a user profile
    When the user has earned badges
    Then badges should be displayed prominently
    And I should see badge descriptions on hover
    And badges should be in earned order

  @profile-display
  Scenario: Show verification status
    Given I am viewing a user profile
    When the user is verified
    Then I should see verification badge
    And I should see what type of verification
    And verified status should be prominent

  @profile-display
  Scenario: View profile on mobile
    Given I am viewing a profile on mobile
    Then the profile should be responsive
    And key information should be visible
    And I should be able to scroll for more details

  @profile-display
  Scenario: View profile activity feed
    Given I am viewing a user profile
    When I view their activity feed
    Then I should see recent transactions
    And I should see recent league activity
    And I should see recent achievements

  # --------------------------------------------------------------------------
  # Profile Privacy
  # --------------------------------------------------------------------------

  @profile-privacy
  Scenario: Configure profile visibility
    Given I am logged in
    When I configure privacy settings
    Then I should be able to make profile public
    And I should be able to make profile private
    And I should be able to make profile visible to friends only

  @profile-privacy
  Scenario: Hide stats from profile
    Given I am logged in
    When I configure stat visibility
    Then I should be able to hide win/loss record
    And I should be able to hide championship history
    And I should be able to hide league memberships

  @profile-privacy
  Scenario: Enable anonymous mode
    Given I am logged in
    When I enable anonymous mode
    Then my activity should not be publicly visible
    And my username should be hidden in public contexts
    And I should be able to disable anonymous mode

  @profile-privacy
  Scenario: Block a user
    Given I am logged in
    When I block another user
    Then they should not see my full profile
    And they should not be able to message me
    And I should not see their content

  @profile-privacy
  Scenario: Manage blocked users list
    Given I have blocked users
    When I view my blocked list
    Then I should see all blocked users
    And I should be able to unblock users
    And I should see when each was blocked

  @profile-privacy
  Scenario: Control profile searchability
    Given I am logged in
    When I configure search visibility
    Then I should control if I appear in searches
    And I should control who can find me by email
    And I should control directory visibility

  # --------------------------------------------------------------------------
  # Profile Stats
  # --------------------------------------------------------------------------

  @profile-stats
  Scenario: View win/loss record
    Given I am viewing a user profile
    When I view their stats
    Then I should see overall win/loss record
    And I should see record by season
    And I should see record by league type

  @profile-stats
  Scenario: View championships won
    Given I am viewing a user profile
    When I view their achievements
    Then I should see total championships
    And I should see championship years
    And I should see league names for each

  @profile-stats
  Scenario: View all-time points
    Given I am viewing a user profile
    When I view their stats
    Then I should see total fantasy points scored
    And I should see average points per week
    And I should see points by season

  @profile-stats
  Scenario: View league history
    Given I am viewing a user profile
    When I view their league history
    Then I should see all leagues participated in
    And I should see finish position in each
    And I should see years of participation

  @profile-stats
  Scenario: View head-to-head record
    Given I am viewing another user's profile
    When I view our head-to-head record
    Then I should see our matchup history
    And I should see win/loss against each other
    And I should see average score differential

  @profile-stats
  Scenario: Compare stats with another user
    Given I am viewing another user's profile
    When I compare our stats
    Then I should see side-by-side comparison
    And I should see where I lead and trail
    And I should see career stat differences

  # --------------------------------------------------------------------------
  # Profile Achievements
  # --------------------------------------------------------------------------

  @profile-achievements
  Scenario: Earn achievement badges
    Given I am an active user
    When I complete an achievement criteria
    Then I should earn the corresponding badge
    And I should receive a notification
    And the badge should appear on my profile

  @profile-achievements
  Scenario: View milestones reached
    Given I am viewing my profile
    When I view my milestones
    Then I should see milestones I have reached
    And I should see progress toward next milestones
    And I should see milestone dates

  @profile-achievements
  Scenario: Collect trophies
    Given I have won championships or awards
    When I view my trophy case
    Then I should see all trophies earned
    And I should see trophy details
    And I should be able to feature trophies

  @profile-achievements
  Scenario: Display awards on profile
    Given I have earned awards
    When others view my profile
    Then they should see my featured awards
    And awards should be visually prominent
    And award details should be accessible

  @profile-achievements
  Scenario: Share achievements
    Given I have earned an achievement
    When I share the achievement
    Then I should be able to share to social media
    And I should be able to share to league
    And the share should include achievement details

  @profile-achievements
  Scenario: View achievement leaderboard
    Given I am viewing achievements
    When I view the leaderboard
    Then I should see top achievement earners
    And I should see my ranking
    And I should see achievement categories

  # --------------------------------------------------------------------------
  # Profile Connections
  # --------------------------------------------------------------------------

  @profile-connections
  Scenario: Add friend
    Given I am viewing another user's profile
    When I send a friend request
    Then a friend request should be sent
    And I should see pending status
    And they should receive notification

  @profile-connections
  Scenario: Accept friend request
    Given I have a pending friend request
    When I accept the request
    Then we should become friends
    And they should appear in my friends list
    And I should appear in their friends list

  @profile-connections
  Scenario: Follow another user
    Given I am viewing another user's profile
    When I follow them
    Then I should see their activity in my feed
    And my following count should increase
    And their follower count should increase

  @profile-connections
  Scenario: View league connections
    Given I am viewing my connections
    When I view league connections
    Then I should see users I share leagues with
    And I should see which leagues we share
    And I should be able to message them

  @profile-connections
  Scenario: Send direct message
    Given I am viewing a user's profile
    When I click to message them
    Then I should be able to compose a message
    And the message should be sent
    And I should see it in my messages

  @profile-connections
  Scenario: View mutual connections
    Given I am viewing another user's profile
    When I view mutual connections
    Then I should see friends we share
    And I should see leagues we share
    And I should see mutual followers

  @profile-connections
  Scenario: Remove connection
    Given I have a friend connection
    When I remove the connection
    Then we should no longer be connected
    And they should not see my private content
    And I should see confirmation

  # --------------------------------------------------------------------------
  # Profile Preferences
  # --------------------------------------------------------------------------

  @profile-preferences
  Scenario: Set favorite NFL teams
    Given I am logged in
    When I set my favorite NFL teams
    Then my favorite teams should be saved
    And they should display on my profile
    And I should receive relevant team content

  @profile-preferences
  Scenario: Set preferred positions
    Given I am logged in
    When I set preferred fantasy positions
    Then my preferences should be saved
    And recommendations should consider preferences
    And preferences should display on profile

  @profile-preferences
  Scenario: Configure notification preferences
    Given I am logged in
    When I configure profile notifications
    Then I should control friend request notifications
    And I should control mention notifications
    And I should control achievement notifications

  @profile-preferences
  Scenario: Set fantasy preferences
    Given I am logged in
    When I set fantasy preferences
    Then I should set preferred league formats
    And I should set preferred scoring types
    And I should set preferred draft styles

  @profile-preferences
  Scenario: Set display preferences
    Given I am logged in
    When I configure display preferences
    Then I should set profile theme
    And I should set featured content
    And I should set profile layout options

  # --------------------------------------------------------------------------
  # Profile Verification
  # --------------------------------------------------------------------------

  @profile-verification
  Scenario: Verify email address
    Given I am logged in
    And my email is not verified
    When I verify my email
    Then I should receive verification email
    And clicking the link should verify my email
    And I should see verified email badge

  @profile-verification
  Scenario: Verify phone number
    Given I am logged in
    When I add and verify my phone number
    Then I should receive SMS verification code
    And entering the code should verify my phone
    And I should see verified phone status

  @profile-verification
  Scenario: Complete identity verification
    Given I am logged in
    When I request identity verification
    Then I should provide identity documents
    And documents should be reviewed
    And I should receive verification status

  @profile-verification
  Scenario: Display verification badges
    Given I have completed verification
    When others view my profile
    Then they should see verification badge
    And they should see what is verified
    And verification should increase trust

  @profile-verification
  Scenario: Handle verification rejection
    Given I submitted identity verification
    When verification is rejected
    Then I should be notified of rejection
    And I should see the reason
    And I should be able to resubmit

  # --------------------------------------------------------------------------
  # Profile Export
  # --------------------------------------------------------------------------

  @profile-export
  Scenario: Download profile data
    Given I am logged in
    When I request profile data export
    Then my profile data should be compiled
    And I should receive downloadable file
    And the export should include all my data

  @profile-export
  Scenario: Export fantasy stats
    Given I am logged in
    When I export my stats
    Then I should receive stats in chosen format
    And export should include historical data
    And I should choose date ranges

  @profile-export
  Scenario: Request GDPR data export
    Given I am logged in
    When I request GDPR compliant export
    Then I should receive all personal data
    And export should be in portable format
    And I should be notified when ready

  @profile-export
  Scenario: Initiate account deletion
    Given I am logged in
    When I request account deletion
    Then I should see deletion consequences
    And I should confirm deletion intent
    And deletion should be scheduled

  @profile-export
  Scenario: Cancel pending deletion
    Given I have requested account deletion
    And deletion is still pending
    When I cancel the deletion
    Then deletion should be cancelled
    And my account should remain active
    And I should see confirmation

  @profile-export
  Scenario: Data retention after deletion
    Given I have deleted my account
    Then my personal data should be removed
    And anonymized data may be retained
    And I should be unable to recover account after period

  # --------------------------------------------------------------------------
  # Profile Search and Discovery
  # --------------------------------------------------------------------------

  @profile-discovery
  Scenario: Search for users
    Given I am logged in
    When I search for a user
    Then I should see matching users
    And I should see profile previews
    And I should be able to filter results

  @profile-discovery
  Scenario: Discover suggested connections
    Given I am logged in
    When I view suggested connections
    Then I should see users I may know
    And suggestions should be based on leagues
    And I should be able to connect with them

  @profile-discovery
  Scenario: Browse user directory
    Given I am logged in
    When I browse the user directory
    Then I should see users by various filters
    And I should filter by location
    And I should filter by league type

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @user-profiles @error-handling
  Scenario: Handle invalid avatar upload
    Given I am uploading an avatar
    When I upload an invalid file
    Then I should see an error message
    And I should see allowed file types
    And I should be able to try again

  @user-profiles @error-handling
  Scenario: Handle username change limits
    Given I have changed my username recently
    When I try to change it again
    Then I should see cooldown message
    And I should see when I can change again

  @user-profiles @error-handling
  Scenario: Handle profile not found
    Given I am trying to view a profile
    When the profile does not exist
    Then I should see profile not found message
    And I should be offered search option
    And I should not see an error page

  @user-profiles @validation
  Scenario: Validate profile field lengths
    Given I am editing my profile
    When I exceed field character limits
    Then I should see character count
    And I should see limit warning
    And I should not be able to save until fixed

  @user-profiles @security
  Scenario: Sanitize profile content
    Given I am editing my profile
    When I try to include malicious content
    Then the content should be sanitized
    And scripts should be removed
    And my profile should remain safe
