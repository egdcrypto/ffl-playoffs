@social @ANIMA-1330
Feature: Social
  As a fantasy football enthusiast
  I want to connect with other players socially
  So that I can share experiences, find leagues, and build a community

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # FRIEND LISTS - HAPPY PATH
  # ============================================================================

  @happy-path @friend-lists
  Scenario: View friends list
    Given I have added friends
    When I view my friends list
    Then I should see all my friends
    And I should see their online status
    And I should see their recent activity

  @happy-path @friend-lists
  Scenario: Send friend request
    Given I want to add someone as a friend
    When I send a friend request
    Then the request should be sent
    And the recipient should be notified
    And I should see pending status

  @happy-path @friend-lists
  Scenario: Accept friend request
    Given I have a pending friend request
    When I accept the request
    Then we should become friends
    And both users should be notified
    And they should appear in my friends list

  @happy-path @friend-lists
  Scenario: Decline friend request
    Given I have a pending friend request
    When I decline the request
    Then the request should be removed
    And the sender should not be notified explicitly
    And they can send another request later

  @happy-path @friend-lists
  Scenario: Remove friend
    Given I have an existing friend
    When I remove them from my friends
    Then they should be removed from my list
    And I should be removed from their list
    And the removal should be confirmed

  @happy-path @friend-lists
  Scenario: Search for friends by username
    Given I want to find a specific user
    When I search by username
    Then I should see matching results
    And I should be able to send requests
    And I should see mutual friends

  @happy-path @friend-lists
  Scenario: View friend suggestions
    Given I have some friends
    When I view friend suggestions
    Then I should see users with mutual friends
    And I should see users from my leagues
    And I should be able to add them

  # ============================================================================
  # USER FOLLOWING
  # ============================================================================

  @happy-path @following
  Scenario: Follow another user
    Given I want to follow a user
    When I click follow
    Then I should follow them
    And their activity should appear in my feed
    And they should be notified optionally

  @happy-path @following
  Scenario: Unfollow a user
    Given I am following a user
    When I unfollow them
    Then I should stop following
    And their activity should leave my feed
    And they should not be notified

  @happy-path @following
  Scenario: View users I follow
    Given I follow multiple users
    When I view my following list
    Then I should see all followed users
    And I should see their profiles
    And I should be able to unfollow

  @happy-path @following
  Scenario: View my followers
    Given I have followers
    When I view my followers list
    Then I should see who follows me
    And I should see follower count
    And I should be able to follow back

  @happy-path @following
  Scenario: View mutual follows
    Given I have mutual follows
    When I view connections
    Then I should see mutual follows highlighted
    And I should see follow status for each
    And I should manage relationships

  # ============================================================================
  # SOCIAL FEEDS
  # ============================================================================

  @happy-path @social-feeds
  Scenario: View social feed
    Given I am on the social section
    When I view my feed
    Then I should see activity from friends
    And I should see activity from followed users
    And posts should be in chronological order

  @happy-path @social-feeds
  Scenario: View personalized feed
    Given I have a personalized feed
    When I view the feed
    Then content should be ranked by relevance
    And I should see trending content
    And I should see recommended posts

  @happy-path @social-feeds
  Scenario: Filter social feed
    Given I want specific content
    When I filter the feed
    Then I should filter by content type
    And I should filter by user
    And I should filter by time

  @happy-path @social-feeds
  Scenario: Interact with feed posts
    Given I see a post in my feed
    When I interact with it
    Then I should like the post
    And I should comment on it
    And I should share it

  @happy-path @social-feeds
  Scenario: Hide post from feed
    Given I see a post I don't want
    When I hide the post
    Then it should be removed from my feed
    And similar content may be reduced
    And I can undo the action

  @happy-path @social-feeds
  Scenario: Report inappropriate content
    Given I see inappropriate content
    When I report the post
    Then the report should be submitted
    And moderators should be notified
    And I should receive confirmation

  # ============================================================================
  # ACTIVITY SHARING
  # ============================================================================

  @happy-path @activity-sharing
  Scenario: Share matchup result
    Given I won a matchup
    When I share the result
    Then a post should be created
    And it should show the result details
    And friends should see it

  @happy-path @activity-sharing
  Scenario: Share trade completion
    Given I completed a trade
    When I share the trade
    Then a post should be created
    And it should show trade details
    And others can react

  @happy-path @activity-sharing
  Scenario: Share achievement earned
    Given I earned an achievement
    When I share the achievement
    Then a celebratory post should be created
    And the achievement should be displayed
    And friends should be able to congratulate

  @happy-path @activity-sharing
  Scenario: Share draft results
    Given my draft is complete
    When I share draft results
    Then my team should be displayed
    And draft grade should be included
    And others can comment

  @happy-path @activity-sharing
  Scenario: Configure activity sharing preferences
    Given I want to control sharing
    When I configure preferences
    Then I should auto-share certain activities
    And I should hide certain activities
    And preferences should be saved

  @happy-path @activity-sharing
  Scenario: Share to external platforms
    Given I have shareable content
    When I share externally
    Then I should choose platform
    And content should be formatted
    And share should complete

  # ============================================================================
  # LEAGUE DISCOVERY
  # ============================================================================

  @happy-path @league-discovery
  Scenario: Browse public leagues
    Given I want to join a league
    When I browse available leagues
    Then I should see public leagues
    And I should see league details
    And I should see entry requirements

  @happy-path @league-discovery
  Scenario: Search for leagues
    Given I want a specific type of league
    When I search with criteria
    Then I should find matching leagues
    And results should be filterable
    And I should see relevance ranking

  @happy-path @league-discovery
  Scenario: Filter leagues by settings
    Given I have preferences
    When I filter league results
    Then I should filter by format
    And I should filter by size
    And I should filter by buy-in

  @happy-path @league-discovery
  Scenario: View league details before joining
    Given I found an interesting league
    When I view league details
    Then I should see full settings
    And I should see current members
    And I should see league history

  @happy-path @league-discovery
  Scenario: Request to join league
    Given I want to join a league
    When I request to join
    Then my request should be submitted
    And the commissioner should be notified
    And I should see pending status

  @happy-path @league-discovery
  Scenario: View recommended leagues
    Given I have preferences
    When I view recommendations
    Then I should see matched leagues
    And I should see why recommended
    And I should join easily

  # ============================================================================
  # PUBLIC PROFILES
  # ============================================================================

  @happy-path @public-profiles
  Scenario: View public profile
    Given a user has a public profile
    When I view their profile
    Then I should see their public info
    And I should see their achievements
    And I should see their activity

  @happy-path @public-profiles
  Scenario: Configure profile visibility
    Given I want to control my profile
    When I set visibility settings
    Then I should make sections public or private
    And I should control who sees what
    And settings should be saved

  @happy-path @public-profiles
  Scenario: View profile statistics
    Given I am viewing a profile
    When I check their stats
    Then I should see win-loss record
    And I should see championships
    And I should see fantasy career stats

  @happy-path @public-profiles
  Scenario: View profile activity
    Given I am viewing a profile
    When I check their activity
    Then I should see recent activity
    And I should see shared content
    And activity should respect privacy

  @happy-path @public-profiles
  Scenario: Compare profiles
    Given I want to compare with another user
    When I compare profiles
    Then I should see side-by-side stats
    And I should see head-to-head history
    And I should see comparison insights

  # ============================================================================
  # SOCIAL LOGIN INTEGRATION
  # ============================================================================

  @happy-path @social-login
  Scenario: Sign up with social account
    Given I am a new user
    When I sign up with Google
    Then my account should be created
    And I should be logged in
    And my profile should be populated

  @happy-path @social-login
  Scenario: Login with Facebook
    Given I have linked Facebook
    When I login with Facebook
    Then I should be authenticated
    And I should access my account
    And login should be quick

  @happy-path @social-login
  Scenario: Link social account to existing profile
    Given I have an existing account
    When I link a social account
    Then the account should be linked
    And I should login either way
    And the link should be confirmed

  @happy-path @social-login
  Scenario: Unlink social account
    Given I have a linked social account
    When I unlink it
    Then the connection should be removed
    And I should still login with password
    And the unlink should be confirmed

  @happy-path @social-login
  Scenario: Login with Apple
    Given I want to use Apple login
    When I authenticate with Apple
    Then I should be logged in
    And privacy should be maintained
    And hide my email should work

  # ============================================================================
  # SHARE TO SOCIAL MEDIA
  # ============================================================================

  @happy-path @share-social-media
  Scenario: Share to Twitter/X
    Given I have content to share
    When I share to Twitter
    Then a tweet should be composed
    And it should include content details
    And I should post from Twitter

  @happy-path @share-social-media
  Scenario: Share to Facebook
    Given I have content to share
    When I share to Facebook
    Then a Facebook post should be composed
    And it should include preview
    And I should post from Facebook

  @happy-path @share-social-media
  Scenario: Share to Instagram Stories
    Given I have shareable content
    When I share to Instagram Stories
    Then a story should be prepared
    And it should include graphics
    And I should post to Stories

  @happy-path @share-social-media
  Scenario: Generate shareable graphic
    Given I want a visual share
    When I generate a graphic
    Then a branded image should be created
    And it should include key stats
    And it should be downloadable

  @happy-path @share-social-media
  Scenario: Copy share link
    Given I want to share a link
    When I copy the link
    Then the link should be copied
    And it should be shareable anywhere
    And tracking should be included

  # ============================================================================
  # SOCIAL LEADERBOARDS
  # ============================================================================

  @happy-path @social-leaderboards
  Scenario: View friends leaderboard
    Given I have friends who play
    When I view friends leaderboard
    Then I should see friends ranked
    And I should see relevant stats
    And I should see my position

  @happy-path @social-leaderboards
  Scenario: View global leaderboard
    Given there is a global leaderboard
    When I view global rankings
    Then I should see top players
    And I should see various categories
    And I should find my ranking

  @happy-path @social-leaderboards
  Scenario: View weekly challenge leaderboard
    Given there is a weekly challenge
    When I view the leaderboard
    Then I should see challenge standings
    And I should see my progress
    And I should see prizes

  @happy-path @social-leaderboards
  Scenario: Filter leaderboard by category
    Given I want specific rankings
    When I filter the leaderboard
    Then I should filter by stat type
    And I should filter by time period
    And I should filter by league type

  @happy-path @social-leaderboards
  Scenario: Challenge friend from leaderboard
    Given I see a friend on leaderboard
    When I challenge them
    Then a challenge should be created
    And they should be notified
    And competition should begin

  # ============================================================================
  # FRIEND LEAGUES
  # ============================================================================

  @happy-path @friend-leagues
  Scenario: Create league with friends
    Given I want a friends-only league
    When I create a friend league
    Then I should invite friends
    And the league should be private
    And only invitees can join

  @happy-path @friend-leagues
  Scenario: Invite friends to league
    Given I am a league commissioner
    When I invite friends
    Then invitations should be sent
    And friends should receive notifications
    And they should accept or decline

  @happy-path @friend-leagues
  Scenario: View friends in my leagues
    Given I have leagues with friends
    When I view league members
    Then I should see which are friends
    And I should see friendship indicator
    And I should interact with them

  @happy-path @friend-leagues
  Scenario: Suggest leagues to friends
    Given I am in a league seeking members
    When I suggest to friends
    Then they should receive the suggestion
    And they should see league details
    And they should be able to join

  @happy-path @friend-leagues
  Scenario: Find friends' public leagues
    Given my friends are in public leagues
    When I view friends' leagues
    Then I should see their leagues
    And I should see if open
    And I should be able to join

  # ============================================================================
  # SOCIAL CHALLENGES
  # ============================================================================

  @happy-path @social-challenges
  Scenario: Create challenge with friend
    Given I want to compete with a friend
    When I create a challenge
    Then I should set challenge terms
    And my friend should be invited
    And challenge should begin on acceptance

  @happy-path @social-challenges
  Scenario: Accept social challenge
    Given I received a challenge
    When I accept the challenge
    Then the challenge should activate
    And tracking should begin
    And both should be notified

  @happy-path @social-challenges
  Scenario: View active challenges
    Given I have active challenges
    When I view my challenges
    Then I should see all challenges
    And I should see current standings
    And I should see time remaining

  @happy-path @social-challenges
  Scenario: Complete challenge and award winner
    Given a challenge is ending
    When the challenge completes
    Then the winner should be determined
    And both should be notified
    And bragging rights should be awarded

  @happy-path @social-challenges
  Scenario: Share challenge results
    Given a challenge is complete
    When I share results
    Then results should be shareable
    And winner should be highlighted
    And engagement should be tracked

  @happy-path @social-challenges
  Scenario: View challenge history
    Given I have past challenges
    When I view challenge history
    Then I should see all past challenges
    And I should see win-loss record
    And I should see rivalry stats

  # ============================================================================
  # USER MENTIONS
  # ============================================================================

  @happy-path @user-mentions
  Scenario: Mention user in post
    Given I am creating a post
    When I mention another user with @
    Then they should be tagged
    And they should receive notification
    And their name should be linked

  @happy-path @user-mentions
  Scenario: View my mentions
    Given I have been mentioned
    When I view my mentions
    Then I should see all mentions
    And I should see context
    And I should respond to them

  @happy-path @user-mentions
  Scenario: Mention in comment
    Given I am commenting
    When I mention a user
    Then they should be notified
    And the mention should be highlighted
    And they can view the context

  @happy-path @user-mentions
  Scenario: Search users to mention
    Given I want to mention someone
    When I start typing @
    Then I should see suggestions
    And suggestions should match my input
    And I should select easily

  @happy-path @user-mentions
  Scenario: Configure mention notifications
    Given I receive many mentions
    When I configure notification settings
    Then I should control mention alerts
    And I should filter by source
    And preferences should be saved

  # ============================================================================
  # SOCIAL NOTIFICATIONS
  # ============================================================================

  @happy-path @social-notifications
  Scenario: Receive friend request notification
    Given someone sends me a friend request
    When the request is sent
    Then I should receive notification
    And I should see who it's from
    And I should respond from notification

  @happy-path @social-notifications
  Scenario: Receive follow notification
    Given someone follows me
    When they follow
    Then I should receive notification
    And I should see who followed
    And I should follow back optionally

  @happy-path @social-notifications
  Scenario: Receive comment notification
    Given someone comments on my post
    When they comment
    Then I should receive notification
    And I should see the comment
    And I should respond

  @happy-path @social-notifications
  Scenario: Receive like notification
    Given someone likes my content
    When they like
    Then I should receive notification
    And I should see aggregate likes
    And engagement should be tracked

  @happy-path @social-notifications
  Scenario: Configure social notification preferences
    Given I receive many notifications
    When I configure preferences
    Then I should control each type
    And I should set delivery method
    And preferences should be saved

  # ============================================================================
  # COMMUNITY FEATURES
  # ============================================================================

  @happy-path @community
  Scenario: View community forums
    Given there are community forums
    When I access forums
    Then I should see discussion topics
    And I should see popular threads
    And I should participate

  @happy-path @community
  Scenario: Create community post
    Given I want to start a discussion
    When I create a post
    Then the post should be published
    And others should see it
    And engagement should be tracked

  @happy-path @community
  Scenario: Join community group
    Given there are community groups
    When I join a group
    Then I should become a member
    And I should see group content
    And I should participate

  @happy-path @community
  Scenario: View trending topics
    Given there are trending discussions
    When I view trending
    Then I should see popular topics
    And I should see engagement metrics
    And I should join conversations

  @happy-path @community
  Scenario: Report community violation
    Given I see a rule violation
    When I report it
    Then the report should be submitted
    And moderators should review
    And action should be taken

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Social feed fails to load
    Given I try to view social feed
    When loading fails
    Then I should see an error message
    And I should be able to retry
    And cached content should show

  @error
  Scenario: Friend request fails to send
    Given I send a friend request
    When sending fails
    Then I should see an error
    And I should be able to retry
    And status should be clear

  @error
  Scenario: Social share fails
    Given I try to share content
    When sharing fails
    Then I should see an error
    And content should not be lost
    And I should retry

  @error
  Scenario: Social login fails
    Given I try social login
    When authentication fails
    Then I should see an error
    And I should have alternative login
    And my account should be safe

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View social features on mobile
    Given I am using the mobile app
    When I access social features
    Then the interface should be mobile-optimized
    And touch interactions should work
    And navigation should be easy

  @mobile
  Scenario: Share content from mobile
    Given I am on mobile
    When I share content
    Then native share sheet should appear
    And I should select destination
    And sharing should complete

  @mobile
  Scenario: Receive mobile social notifications
    Given I have mobile app
    When social events occur
    Then I should receive push notifications
    And tapping should open relevant section
    And actions should be quick

  @mobile
  Scenario: Browse social feed on mobile
    Given I am viewing feed on mobile
    When I scroll through content
    Then scrolling should be smooth
    And content should load progressively
    And interactions should work

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate social features with keyboard
    Given I am using keyboard navigation
    When I navigate social pages
    Then all elements should be accessible
    And focus should move logically
    And actions should work

  @accessibility
  Scenario: Screen reader social access
    Given I am using a screen reader
    When I use social features
    Then content should be announced
    And interactions should be labeled
    And updates should be communicated

  @accessibility
  Scenario: High contrast social display
    Given I have high contrast mode enabled
    When I view social content
    Then content should be visible
    And buttons should be clear
    And status indicators should work

  @accessibility
  Scenario: Social with reduced motion
    Given I have reduced motion preferences
    When I view social features
    Then animations should be minimized
    And transitions should be simple
    And content should still be engaging
