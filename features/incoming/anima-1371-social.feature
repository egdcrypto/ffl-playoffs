@social @anima-1371
Feature: Social
  As a fantasy football user
  I want social features to interact with other users
  So that I can engage with the community and my league mates

  Background:
    Given I am a logged-in user
    And the social features are enabled

  # ============================================================================
  # SOCIAL FEED
  # ============================================================================

  @happy-path @social-feed
  Scenario: View activity feed
    Given I am on the social page
    When I view my activity feed
    Then I should see recent activities
    And activities should be from people I follow

  @happy-path @social-feed
  Scenario: View user posts
    Given I am viewing the feed
    Then I should see posts from users
    And posts should display author and content

  @happy-path @social-feed
  Scenario: View league updates
    Given I am in leagues
    When I view the feed
    Then I should see league activity updates
    And updates should show transactions and news

  @happy-path @social-feed
  Scenario: View trending content
    Given I am viewing the feed
    When I check trending section
    Then I should see trending topics
    And trending should be based on engagement

  @happy-path @social-feed
  Scenario: Create a post
    Given I am on my feed
    When I create a new post
    Then my post should appear in the feed
    And others should be able to see it

  @happy-path @social-feed
  Scenario: Refresh feed
    Given I am viewing my feed
    When I refresh the feed
    Then I should see updated content
    And new posts should appear

  @happy-path @social-feed
  Scenario: Filter feed by type
    Given I am viewing my feed
    When I filter by content type
    Then I should see only that type of content
    And the filter should be clearable

  @mobile @social-feed
  Scenario: View feed on mobile
    Given I am on a mobile device
    When I view the social feed
    Then the feed should be mobile-optimized
    And I should be able to scroll smoothly

  # ============================================================================
  # FRIENDS/CONNECTIONS
  # ============================================================================

  @happy-path @friends
  Scenario: Send friend request
    Given I find another user
    When I send a friend request
    Then the request should be sent
    And the user should be notified

  @happy-path @friends
  Scenario: Accept friend request
    Given I have a pending friend request
    When I accept the request
    Then we should become friends
    And both parties should be notified

  @happy-path @friends
  Scenario: Decline friend request
    Given I have a pending friend request
    When I decline the request
    Then the request should be declined
    And the sender should be notified

  @happy-path @friends
  Scenario: View friend list
    Given I have friends
    When I view my friend list
    Then I should see all my friends
    And I should see their status

  @happy-path @friends
  Scenario: Get friend suggestions
    Given I use the platform
    Then I should see friend suggestions
    And suggestions should be relevant

  @happy-path @friends
  Scenario: Block a user
    Given I want to block someone
    When I block the user
    Then they should be blocked
    And they cannot contact me

  @happy-path @friends
  Scenario: Mute a user
    Given I want to mute someone
    When I mute the user
    Then their content should be hidden
    And I can unmute later

  @happy-path @friends
  Scenario: Remove friend
    Given I have a friend
    When I remove them as a friend
    Then we should no longer be friends
    And they should be notified

  # ============================================================================
  # MESSAGING
  # ============================================================================

  @happy-path @messaging
  Scenario: Send direct message
    Given I want to message someone
    When I send a direct message
    Then the message should be delivered
    And the recipient should be notified

  @happy-path @messaging
  Scenario: View message thread
    Given I have messages with someone
    When I view our conversation
    Then I should see the message history
    And messages should be in order

  @happy-path @messaging
  Scenario: Start group chat
    Given I want to chat with multiple people
    When I create a group chat
    Then the group should be created
    And members should be added

  @happy-path @messaging
  Scenario: Send message in group chat
    Given I am in a group chat
    When I send a message
    Then all members should see it
    And they should be notified

  @happy-path @messaging
  Scenario: Use league chat room
    Given my league has a chat room
    When I access league chat
    Then I should see league messages
    And I can send messages

  @happy-path @messaging
  Scenario: View message history
    Given I have message history
    When I scroll through messages
    Then I should see older messages
    And history should be complete

  @happy-path @messaging
  Scenario: Search messages
    Given I have many messages
    When I search within messages
    Then I should find matching messages
    And search should be fast

  @happy-path @messaging
  Scenario: Delete message
    Given I sent a message
    When I delete the message
    Then the message should be removed
    And deletion should be indicated

  @mobile @messaging
  Scenario: Message on mobile
    Given I am on a mobile device
    When I use messaging
    Then messaging should be mobile-friendly
    And notifications should work

  # ============================================================================
  # COMMENTS
  # ============================================================================

  @happy-path @comments
  Scenario: Comment on activity
    Given I see an activity post
    When I add a comment
    Then my comment should appear
    And the author should be notified

  @happy-path @comments
  Scenario: Reply to comment
    Given there is a comment
    When I reply to it
    Then my reply should appear
    And a thread should be created

  @happy-path @comments
  Scenario: View comment threads
    Given a post has comments
    When I view comments
    Then I should see comment threads
    And threading should be clear

  @happy-path @comments
  Scenario: Edit my comment
    Given I made a comment
    When I edit the comment
    Then the comment should be updated
    And edit should be indicated

  @happy-path @comments
  Scenario: Delete my comment
    Given I made a comment
    When I delete the comment
    Then the comment should be removed
    And deletion should be confirmed

  @commissioner @comments
  Scenario: Moderate comments
    Given I am a moderator
    When I moderate a comment
    Then I should be able to remove it
    And the commenter should be notified

  @happy-path @comments
  Scenario: Report inappropriate comment
    Given I see an inappropriate comment
    When I report it
    Then the report should be submitted
    And moderators should be notified

  # ============================================================================
  # REACTIONS
  # ============================================================================

  @happy-path @reactions
  Scenario: Like a post
    Given I see a post
    When I like it
    Then my like should be recorded
    And the author should be notified

  @happy-path @reactions
  Scenario: Add emoji reaction
    Given I see a post or comment
    When I add an emoji reaction
    Then my reaction should appear
    And reaction count should update

  @happy-path @reactions
  Scenario: View reaction counts
    Given content has reactions
    Then I should see reaction counts
    And counts should be accurate

  @happy-path @reactions
  Scenario: See who reacted
    Given content has reactions
    When I view reaction details
    Then I should see who reacted
    And I should see reaction types

  @happy-path @reactions
  Scenario: Remove my reaction
    Given I reacted to content
    When I remove my reaction
    Then my reaction should be removed
    And count should update

  @happy-path @reactions
  Scenario: Receive reaction notification
    Given someone reacts to my content
    Then I should receive a notification
    And notification should show the reaction

  # ============================================================================
  # SHARING
  # ============================================================================

  @happy-path @sharing
  Scenario: Share content within app
    Given I see shareable content
    When I share it
    Then the content should be shared
    And it should appear in my feed

  @happy-path @sharing
  Scenario: Share to social media
    Given I see shareable content
    When I share to social media
    Then I should see sharing options
    And content should be shared externally

  @happy-path @sharing
  Scenario: Invite friends via share
    Given I want to invite friends
    When I share an invite link
    Then the link should be generated
    And recipients can join

  @happy-path @sharing
  Scenario: Copy share link
    Given I want to share content
    When I copy the share link
    Then the link should be copied
    And I can paste it elsewhere

  @happy-path @sharing
  Scenario: Share via messaging
    Given I want to share with someone
    When I share via direct message
    Then the content should be sent
    And recipient should see it

  @happy-path @sharing
  Scenario: Control share privacy
    Given I am sharing content
    When I set share privacy
    Then I should choose who can see it
    And privacy should be respected

  # ============================================================================
  # GROUPS
  # ============================================================================

  @happy-path @groups
  Scenario: Create a group
    Given I want to create a group
    When I create the group
    Then the group should be created
    And I should be the admin

  @happy-path @groups
  Scenario: Invite members to group
    Given I manage a group
    When I invite members
    Then invitations should be sent
    And members can join

  @happy-path @groups
  Scenario: Join a group
    Given I am invited to a group
    When I accept the invitation
    Then I should join the group
    And I should see group content

  @happy-path @groups
  Scenario: Post in group discussion
    Given I am in a group
    When I post a discussion
    Then my post should appear
    And group members should see it

  @happy-path @groups
  Scenario: Manage group settings
    Given I am a group admin
    When I manage group settings
    Then I should configure privacy and rules
    And settings should be saved

  @happy-path @groups
  Scenario: Set group privacy
    Given I am configuring a group
    When I set privacy level
    Then group should be public or private
    And access should be controlled

  @happy-path @groups
  Scenario: Leave a group
    Given I am in a group
    When I leave the group
    Then I should be removed
    And I should not see group content

  @happy-path @groups
  Scenario: Remove member from group
    Given I am a group admin
    When I remove a member
    Then they should be removed
    And they should be notified

  # ============================================================================
  # MENTIONS/TAGGING
  # ============================================================================

  @happy-path @mentions
  Scenario: Mention user with @
    Given I am creating a post or comment
    When I type @ and a username
    Then I should see user suggestions
    And I can select a user to mention

  @happy-path @mentions
  Scenario: Tag user in content
    Given I am posting content
    When I tag a user
    Then the tag should be created
    And the user should be notified

  @happy-path @mentions
  Scenario: Receive mention notification
    Given someone mentions me
    Then I should receive a notification
    And I can view the content

  @happy-path @mentions
  Scenario: View tag suggestions
    Given I am typing a mention
    Then I should see relevant suggestions
    And suggestions should match my input

  @happy-path @mentions
  Scenario: Click on mention to view profile
    Given I see a mention
    When I click on it
    Then I should be taken to their profile
    And I can return to content

  @happy-path @mentions
  Scenario: View all my mentions
    Given I have been mentioned
    When I view my mentions
    Then I should see all mentions
    And they should be organized

  # ============================================================================
  # FOLLOWING
  # ============================================================================

  @happy-path @following
  Scenario: Follow a user
    Given I find an interesting user
    When I follow them
    Then I should follow them
    And their content should appear in my feed

  @happy-path @following
  Scenario: View followed user activity
    Given I follow users
    When I view my feed
    Then I should see their activity
    And updates should be recent

  @happy-path @following
  Scenario: Unfollow a user
    Given I follow someone
    When I unfollow them
    Then I should stop following them
    And their content should not appear

  @happy-path @following
  Scenario: View follower count
    Given I have a profile
    Then I should see my follower count
    And I should see following count

  @happy-path @following
  Scenario: View followers list
    Given I have followers
    When I view my followers
    Then I should see who follows me
    And I can follow them back

  @happy-path @following
  Scenario: View following list
    Given I follow users
    When I view who I follow
    Then I should see my following list
    And I can unfollow from there

  @happy-path @following
  Scenario: Get follow suggestions
    Given I use the platform
    Then I should see follow suggestions
    And suggestions should be relevant

  # ============================================================================
  # SOCIAL NOTIFICATIONS
  # ============================================================================

  @happy-path @social-notifications
  Scenario: Receive social alerts
    Given social events occur
    Then I should receive social alerts
    And alerts should be timely

  @happy-path @social-notifications
  Scenario: View activity notifications
    Given I have activity on my content
    When I view notifications
    Then I should see engagement alerts
    And alerts should be organized

  @happy-path @social-notifications
  Scenario: Configure social notification preferences
    Given I am in settings
    When I configure social notifications
    Then I should choose which alerts to receive
    And preferences should be saved

  @happy-path @social-notifications
  Scenario: Receive engagement alerts
    Given my content gets engagement
    Then I should receive engagement alerts
    And alerts should show the activity

  @happy-path @social-notifications
  Scenario: Receive social digest email
    Given I have social activity
    When digest time arrives
    Then I should receive a digest email
    And it should summarize activity

  @happy-path @social-notifications
  Scenario: Mark notifications as read
    Given I have social notifications
    When I mark them as read
    Then they should show as read
    And unread count should update

  @happy-path @social-notifications
  Scenario: Clear social notifications
    Given I have social notifications
    When I clear them
    Then notifications should be cleared
    And I should see confirmation

  @mobile @social-notifications
  Scenario: Receive social push notifications
    Given I have push enabled
    When social events occur
    Then I should receive push notifications
    And I can tap to view content
