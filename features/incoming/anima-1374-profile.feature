@profile @anima-1374
Feature: Profile
  As a fantasy football user
  I want to manage my profile and personal identity
  So that I can customize my presence and showcase my achievements

  Background:
    Given I am a logged-in user
    And I have access to my profile

  # ============================================================================
  # USER PROFILE
  # ============================================================================

  @happy-path @user-profile
  Scenario: View my profile
    Given I access my profile
    Then I should see my profile page
    And I should see my personal information

  @happy-path @user-profile
  Scenario: View personal information
    Given I am on my profile
    Then I should see my name and username
    And I should see my bio

  @happy-path @user-profile
  Scenario: View profile avatar
    Given I am on my profile
    Then I should see my avatar
    And the avatar should be displayed prominently

  @happy-path @user-profile
  Scenario: View cover photo
    Given I have a cover photo set
    Then I should see my cover photo
    And it should be displayed at the top

  @happy-path @user-profile
  Scenario: Update profile bio
    Given I am editing my profile
    When I update my bio
    Then my bio should be saved
    And it should display on my profile

  @happy-path @user-profile
  Scenario: Upload profile avatar
    Given I am editing my profile
    When I upload a new avatar
    Then the avatar should be saved
    And it should replace the old one

  @happy-path @user-profile
  Scenario: Upload cover photo
    Given I am editing my profile
    When I upload a cover photo
    Then the cover photo should be saved
    And it should display on my profile

  @happy-path @user-profile
  Scenario: View another user's profile
    Given I find another user
    When I view their profile
    Then I should see their public information
    And I should see their public stats

  @mobile @user-profile
  Scenario: View profile on mobile
    Given I am on a mobile device
    When I view a profile
    Then the profile should be mobile-friendly
    And all information should be accessible

  # ============================================================================
  # PROFILE SETTINGS
  # ============================================================================

  @happy-path @profile-settings
  Scenario: Edit profile information
    Given I am in profile settings
    When I edit my profile information
    Then I should be able to update all fields
    And changes should be saved

  @happy-path @profile-settings
  Scenario: Configure privacy settings
    Given I am in profile settings
    When I configure privacy settings
    Then I should set who can see what
    And my preferences should be saved

  @happy-path @profile-settings
  Scenario: Set display preferences
    Given I am in profile settings
    When I set display preferences
    Then I should choose how my profile appears
    And preferences should be applied

  @happy-path @profile-settings
  Scenario: Update account settings
    Given I am in profile settings
    When I update account settings
    Then my account should be updated
    And I should see confirmation

  @happy-path @profile-settings
  Scenario: Change display name
    Given I am in profile settings
    When I change my display name
    Then my new name should be saved
    And it should appear throughout the app

  @happy-path @profile-settings
  Scenario: Update contact information
    Given I am in profile settings
    When I update contact information
    Then my contact info should be saved
    And verification may be required

  @error @profile-settings
  Scenario: Handle invalid profile data
    Given I am editing my profile
    When I enter invalid data
    Then I should see validation errors
    And invalid data should not be saved

  # ============================================================================
  # PROFILE STATS
  # ============================================================================

  @happy-path @profile-stats
  Scenario: View user statistics
    Given I am on a profile
    Then I should see user statistics
    And stats should summarize performance

  @happy-path @profile-stats
  Scenario: View fantasy performance history
    Given I am viewing profile stats
    Then I should see fantasy performance history
    And history should span multiple seasons

  @happy-path @profile-stats
  Scenario: View win/loss records
    Given I am viewing profile stats
    Then I should see win/loss records
    And records should be by league and overall

  @happy-path @profile-stats
  Scenario: View rankings
    Given I am viewing profile stats
    Then I should see ranking information
    And rankings should show percentile

  @happy-path @profile-stats
  Scenario: View championship count
    Given I am viewing profile stats
    Then I should see championship count
    And championship years should be listed

  @happy-path @profile-stats
  Scenario: Compare stats to average
    Given I am viewing profile stats
    When I compare to average
    Then I should see how I compare
    And differences should be highlighted

  @happy-path @profile-stats
  Scenario: View stat trends
    Given I am viewing profile stats
    Then I should see performance trends
    And trends should be visualized

  # ============================================================================
  # PROFILE CUSTOMIZATION
  # ============================================================================

  @happy-path @profile-customization
  Scenario: Select profile theme
    Given I am customizing my profile
    When I select a theme
    Then the theme should be applied
    And my profile should reflect it

  @happy-path @profile-customization
  Scenario: Choose profile layout
    Given I am customizing my profile
    When I choose a layout option
    Then the layout should be applied
    And content should rearrange

  @happy-path @profile-customization
  Scenario: Display badges on profile
    Given I have earned badges
    When I choose badges to display
    Then selected badges should appear
    And I can arrange their order

  @happy-path @profile-customization
  Scenario: Set profile banner
    Given I am customizing my profile
    When I set a banner
    Then the banner should be displayed
    And it should enhance my profile

  @happy-path @profile-customization
  Scenario: Choose color scheme
    Given I am customizing my profile
    When I select a color scheme
    Then colors should be applied
    And my profile should look personalized

  @happy-path @profile-customization
  Scenario: Preview customizations
    Given I am making customizations
    When I preview changes
    Then I should see how my profile will look
    And I can adjust before saving

  @happy-path @profile-customization
  Scenario: Reset to default appearance
    Given I have customized my profile
    When I reset to defaults
    Then default appearance should be restored
    And customizations should be cleared

  # ============================================================================
  # PROFILE VISIBILITY
  # ============================================================================

  @happy-path @profile-visibility
  Scenario: Set profile to public
    Given I am configuring visibility
    When I set my profile to public
    Then anyone can view my profile
    And my setting should be saved

  @happy-path @profile-visibility
  Scenario: Set profile to private
    Given I am configuring visibility
    When I set my profile to private
    Then only approved users can view it
    And my setting should be saved

  @happy-path @profile-visibility
  Scenario: Control section visibility
    Given I am configuring visibility
    When I set visibility per section
    Then each section should follow its setting
    And I have granular control

  @happy-path @profile-visibility
  Scenario: Hide specific information
    Given I am configuring visibility
    When I hide specific information
    Then that information should not be visible
    And other info remains visible

  @happy-path @profile-visibility
  Scenario: View who can see my profile
    Given I am in visibility settings
    Then I should see who can view my profile
    And access levels should be clear

  @happy-path @profile-visibility
  Scenario: Block specific users from profile
    Given I want to block someone
    When I block them from my profile
    Then they cannot view my profile
    And I should see confirmation

  # ============================================================================
  # PROFILE VERIFICATION
  # ============================================================================

  @happy-path @profile-verification
  Scenario: Request identity verification
    Given I want to verify my identity
    When I request verification
    Then verification process should start
    And I should see instructions

  @happy-path @profile-verification
  Scenario: Complete verification process
    Given I am verifying my identity
    When I complete verification steps
    Then my verification should be submitted
    And I should see status

  @happy-path @profile-verification
  Scenario: Display verified badge
    Given I am verified
    Then my profile should show verified badge
    And the badge should be visible

  @happy-path @profile-verification
  Scenario: View trusted user status
    Given I have trusted user status
    Then my status should be displayed
    And others can see my trustworthiness

  @happy-path @profile-verification
  Scenario: Lose verification status
    Given my verification expires
    Then my verified badge should be removed
    And I should be notified

  # ============================================================================
  # PROFILE CONNECTIONS
  # ============================================================================

  @happy-path @profile-connections
  Scenario: View linked accounts
    Given I have linked accounts
    When I view my connections
    Then I should see linked accounts
    And I can manage them

  @happy-path @profile-connections
  Scenario: Link social account
    Given I want to link an account
    When I link a social account
    Then the account should be connected
    And it should appear in my profile

  @happy-path @profile-connections
  Scenario: View social connections
    Given I have social connections
    Then I should see my connections
    And I can view their profiles

  @happy-path @profile-connections
  Scenario: View friend list
    Given I have friends
    When I view my friend list
    Then I should see all friends
    And I can manage friendships

  @happy-path @profile-connections
  Scenario: View follower count
    Given I have followers
    Then I should see my follower count
    And I can view my followers

  @happy-path @profile-connections
  Scenario: Unlink connected account
    Given I have a linked account
    When I unlink the account
    Then it should be disconnected
    And I should see confirmation

  # ============================================================================
  # PROFILE ACTIVITY
  # ============================================================================

  @happy-path @profile-activity
  Scenario: View activity history
    Given I am on a profile
    When I view activity history
    Then I should see recent activities
    And activities should be chronological

  @happy-path @profile-activity
  Scenario: View recent actions
    Given I am viewing activity
    Then I should see recent actions
    And actions should be summarized

  @happy-path @profile-activity
  Scenario: View activity timeline
    Given I am viewing activity
    When I view the timeline
    Then I should see activities over time
    And timeline should be visual

  @happy-path @profile-activity
  Scenario: View engagement history
    Given I am viewing activity
    Then I should see engagement history
    And engagement should be tracked

  @happy-path @profile-activity
  Scenario: Filter activity by type
    Given I am viewing activity
    When I filter by activity type
    Then I should see only that type
    And filter should be clearable

  @happy-path @profile-activity
  Scenario: Clear activity history
    Given I want to clear history
    When I clear activity history
    Then history should be cleared
    And I should see confirmation

  # ============================================================================
  # PROFILE ACHIEVEMENTS
  # ============================================================================

  @happy-path @profile-achievements
  Scenario: View earned badges
    Given I have earned badges
    When I view my achievements
    Then I should see all badges
    And badge details should be shown

  @happy-path @profile-achievements
  Scenario: View trophies
    Given I have won trophies
    Then I should see my trophies
    And trophy details should be displayed

  @happy-path @profile-achievements
  Scenario: View milestones
    Given I have reached milestones
    Then I should see my milestones
    And milestone progress should be shown

  @happy-path @profile-achievements
  Scenario: View rewards
    Given I have earned rewards
    Then I should see my rewards
    And I can use or redeem them

  @happy-path @profile-achievements
  Scenario: Showcase accomplishments
    Given I have accomplishments
    When I arrange my showcase
    Then featured achievements should be prominent
    And my layout should be saved

  @happy-path @profile-achievements
  Scenario: View achievement progress
    Given there are achievements to earn
    When I view progress
    Then I should see what I'm close to
    And requirements should be shown

  @happy-path @profile-achievements
  Scenario: Share achievement
    Given I earned an achievement
    When I share it
    Then the achievement should be shared
    And others can see it

  # ============================================================================
  # PROFILE SHARING
  # ============================================================================

  @happy-path @profile-sharing
  Scenario: Share profile link
    Given I want to share my profile
    When I get my profile link
    Then I should receive a shareable URL
    And the link should work

  @happy-path @profile-sharing
  Scenario: Generate profile QR code
    Given I want to share via QR code
    When I generate a QR code
    Then a QR code should be created
    And scanning it should open my profile

  @happy-path @profile-sharing
  Scenario: Share profile to social media
    Given I want to share on social media
    When I share to a platform
    Then my profile should be shared
    And the post should link back

  @happy-path @profile-sharing
  Scenario: Copy profile link
    Given I want to copy my link
    When I copy the profile link
    Then the link should be copied
    And I can paste it elsewhere

  @happy-path @profile-sharing
  Scenario: Preview shared profile view
    Given I am sharing my profile
    When I preview shared view
    Then I should see what others will see
    And I can adjust visibility

  @happy-path @profile-sharing
  Scenario: Track profile views
    Given my profile is viewable
    Then I should see profile view count
    And views should be tracked

  @happy-path @profile-sharing
  Scenario: See who viewed profile
    Given I have profile view tracking
    When I check profile views
    Then I should see who viewed my profile
    And view times should be shown
