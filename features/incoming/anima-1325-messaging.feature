@messaging @ANIMA-1325
Feature: Messaging
  As a fantasy football league member
  I want to communicate with other league members
  So that I can negotiate trades, talk trash, and engage with my league

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a league member
    And I have access to league messaging features

  # ============================================================================
  # DIRECT MESSAGES - HAPPY PATH
  # ============================================================================

  @happy-path @direct-messages
  Scenario: Send direct message to another owner
    Given I want to message another league member
    When I open a new direct message
    And I select the recipient
    And I type and send my message
    Then the message should be delivered
    And the recipient should be notified

  @happy-path @direct-messages
  Scenario: View direct message conversation
    Given I have an ongoing conversation
    When I open the conversation
    Then I should see all messages in order
    And I should see timestamps
    And I should see read receipts if enabled

  @happy-path @direct-messages
  Scenario: Reply to direct message
    Given I received a direct message
    When I open the message
    And I type a reply
    And I send the reply
    Then my reply should appear in the conversation
    And the sender should be notified

  @happy-path @direct-messages
  Scenario: View all direct message conversations
    Given I have multiple conversations
    When I open my messages inbox
    Then I should see all conversations
    And they should be sorted by recency
    And unread conversations should be highlighted

  @happy-path @direct-messages
  Scenario: Send message with attachment
    Given I am composing a direct message
    When I attach an image or file
    And I send the message
    Then the attachment should be uploaded
    And the recipient should see the attachment

  @happy-path @direct-messages
  Scenario: React to a message
    Given I am viewing a message
    When I add a reaction emoji
    Then the reaction should appear on the message
    And the sender should be notified
    And others in the chat should see it

  # ============================================================================
  # LEAGUE-WIDE ANNOUNCEMENTS
  # ============================================================================

  @happy-path @announcements
  Scenario: View league announcements
    Given the league has announcements
    When I view the announcements section
    Then I should see all league announcements
    And they should be in chronological order
    And I should see who posted each

  @happy-path @announcements @commissioner
  Scenario: Commissioner posts announcement
    Given I am the league commissioner
    When I create a new announcement
    And I write the announcement content
    And I post the announcement
    Then all league members should see it
    And notifications should be sent

  @happy-path @announcements @commissioner
  Scenario: Pin important announcement
    Given I am the commissioner
    And I have posted an announcement
    When I pin the announcement
    Then it should appear at the top
    And it should be marked as pinned
    And it should remain visible

  @happy-path @announcements
  Scenario: Comment on announcement
    Given there is a league announcement
    When I add a comment
    Then my comment should appear
    And other members should see it
    And the poster should be notified

  @happy-path @announcements @commissioner
  Scenario: Schedule announcement for future
    Given I am the commissioner
    When I create an announcement
    And I schedule it for a future time
    Then the announcement should be saved
    And it should post at the scheduled time
    And I should see it as scheduled

  # ============================================================================
  # TRADE NEGOTIATION CHAT
  # ============================================================================

  @happy-path @trade-chat
  Scenario: Start trade negotiation chat
    Given I want to discuss a trade
    When I initiate a trade chat with another owner
    Then a trade chat thread should be created
    And both parties should have access
    And the chat should be linked to trades

  @happy-path @trade-chat
  Scenario: Send message in trade negotiation
    Given I am in a trade negotiation chat
    When I send a message about the trade
    Then the message should appear in the chat
    And the other party should be notified
    And the chat should update in real-time

  @happy-path @trade-chat
  Scenario: View trade offer in chat
    Given a trade offer has been made
    When I view the trade chat
    Then I should see the trade offer embedded
    And I should see trade details
    And I should be able to respond to the offer

  @happy-path @trade-chat
  Scenario: Counter offer in chat
    Given I received a trade offer
    When I create a counter offer in chat
    Then the counter should be displayed
    And the other party should see it
    And negotiations should continue

  @happy-path @trade-chat
  Scenario: Trade chat history preserved
    Given a trade was completed
    When I view the trade chat history
    Then I should see all negotiation messages
    And I should see the final trade details
    And the chat should be archived

  # ============================================================================
  # DRAFT ROOM CHAT
  # ============================================================================

  @happy-path @draft-chat
  Scenario: Send message during draft
    Given the draft is in progress
    And I am in the draft room
    When I send a chat message
    Then all drafters should see my message
    And the message should appear immediately
    And my name should be shown

  @happy-path @draft-chat
  Scenario: React to draft pick
    Given someone just made a pick
    When I react with an emoji or comment
    Then the reaction should appear
    And it should be tied to that pick
    And others should see my reaction

  @happy-path @draft-chat
  Scenario: View draft chat history
    Given the draft has been ongoing
    When I scroll through chat history
    Then I should see all previous messages
    And pick announcements should be interspersed
    And timestamps should be shown

  @happy-path @draft-chat
  Scenario: Mention user in draft chat
    Given I am in draft chat
    When I mention another drafter with @
    Then they should receive a notification
    And their name should be highlighted
    And they can jump to the mention

  @happy-path @draft-chat
  Scenario: Send GIF in draft chat
    Given I am in the draft room chat
    When I search for and send a GIF
    Then the GIF should appear in chat
    And it should play automatically
    And others should see it

  # ============================================================================
  # TRASH TALK FEATURES
  # ============================================================================

  @happy-path @trash-talk
  Scenario: Post trash talk in league chat
    Given the league has a trash talk channel
    When I post a trash talk message
    Then the message should appear in the channel
    And it should be visible to all members
    And I should be able to tag opponents

  @happy-path @trash-talk
  Scenario: Send trash talk GIF
    Given I want to taunt an opponent
    When I select and send a trash talk GIF
    Then the GIF should display in chat
    And the opponent should be notified
    And it should be appropriately fun

  @happy-path @trash-talk
  Scenario: Create weekly smack talk thread
    Given matchups are set for the week
    When I view the smack talk section
    Then I should see threads for each matchup
    And I can post in my matchup thread
    And I can view other matchup threads

  @happy-path @trash-talk
  Scenario: Respond to trash talk
    Given I received trash talk
    When I compose a response
    Then my response should be visible
    And the conversation should continue
    And other league members can enjoy

  @happy-path @trash-talk
  Scenario: Use trash talk templates
    Given I want quick trash talk
    When I select a trash talk template
    Then a pre-written message should be customized
    And I can edit before sending
    And it should be sent to the right person

  @happy-path @trash-talk
  Scenario: View trash talk hall of fame
    Given there have been memorable moments
    When I view the hall of fame
    Then I should see best trash talk moments
    And I should see reactions and votes
    And legendary burns should be preserved

  # ============================================================================
  # MESSAGE NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive push notification for message
    Given I have push notifications enabled
    When someone sends me a message
    Then I should receive a push notification
    And the notification should preview the message
    And tapping should open the conversation

  @happy-path @notifications
  Scenario: Receive email notification for message
    Given I have email notifications enabled
    When I receive an important message
    Then I should receive an email
    And the email should contain the message
    And I should be able to reply from email

  @happy-path @notifications
  Scenario: Configure notification preferences
    Given I want to customize notifications
    When I access notification settings
    Then I should set preferences per message type
    And I should set quiet hours
    And I should choose notification methods

  @happy-path @notifications
  Scenario: View notification badges
    Given I have unread messages
    When I view the app
    Then I should see notification badges
    And badges should show unread count
    And clearing messages should update badges

  @happy-path @notifications
  Scenario: Receive mention notification
    Given someone mentions me in a chat
    When the message is sent
    Then I should receive a specific mention notification
    And it should be higher priority
    And I should be able to jump to the mention

  # ============================================================================
  # MESSAGE HISTORY
  # ============================================================================

  @happy-path @message-history
  Scenario: View complete message history
    Given I have a long conversation
    When I scroll through history
    Then I should be able to load older messages
    And all messages should be preserved
    And I should see the full conversation

  @happy-path @message-history
  Scenario: Search message history
    Given I am looking for a specific message
    When I search within a conversation
    Then I should find matching messages
    And results should be highlighted
    And I should be able to jump to results

  @happy-path @message-history
  Scenario: Export conversation history
    Given I want to save a conversation
    When I export the conversation
    Then I should receive a downloadable file
    And all messages should be included
    And the format should be readable

  @happy-path @message-history
  Scenario: View message history across seasons
    Given I have multi-season history
    When I view historical messages
    Then I should see messages from past seasons
    And they should be organized by date
    And I should be able to filter by season

  @happy-path @message-history
  Scenario: Delete message from history
    Given I sent a message I want to remove
    When I delete the message
    Then it should be removed from the conversation
    And others should see it was deleted
    And it should not be recoverable

  # ============================================================================
  # GROUP CHATS
  # ============================================================================

  @happy-path @group-chats
  Scenario: Create group chat with multiple members
    Given I want to chat with several people
    When I create a new group chat
    And I add multiple members
    Then the group should be created
    And all members should have access
    And the group should have a name

  @happy-path @group-chats
  Scenario: Send message to group
    Given I am in a group chat
    When I send a message
    Then all group members should see it
    And notifications should go to all members
    And the message should appear in the group

  @happy-path @group-chats
  Scenario: Add member to existing group
    Given I am in a group chat
    When I add a new member
    Then they should join the group
    And they should see chat history
    And they should receive future messages

  @happy-path @group-chats
  Scenario: Remove member from group
    Given I am a group admin
    When I remove a member from the group
    Then they should lose access
    And they should be notified
    And existing messages should remain

  @happy-path @group-chats
  Scenario: Leave group chat
    Given I am in a group chat
    When I choose to leave the group
    Then I should be removed from the group
    And I should stop receiving messages
    And other members should be notified

  @happy-path @group-chats
  Scenario: Rename group chat
    Given I am in a group chat
    When I rename the group
    Then the new name should appear
    And all members should see the change
    And the rename should be announced

  # ============================================================================
  # COMMISSIONER BROADCASTS
  # ============================================================================

  @happy-path @commissioner-broadcast
  Scenario: Send broadcast to all league members
    Given I am the commissioner
    When I create a broadcast message
    And I send it to all members
    Then all members should receive it
    And it should be marked as official
    And delivery should be confirmed

  @happy-path @commissioner-broadcast
  Scenario: Send urgent broadcast
    Given I am the commissioner
    And I have urgent information
    When I send an urgent broadcast
    Then it should be delivered with high priority
    And notifications should be emphasized
    And it should appear prominently

  @happy-path @commissioner-broadcast
  Scenario: Schedule broadcast for later
    Given I am the commissioner
    When I schedule a broadcast
    Then it should be queued for the scheduled time
    And I should see it in scheduled messages
    And it should send at the right time

  @happy-path @commissioner-broadcast
  Scenario: Send broadcast with poll
    Given I am the commissioner
    When I create a broadcast with a poll
    Then members should see the poll
    And they should be able to vote
    And results should be visible

  @happy-path @commissioner-broadcast
  Scenario: View broadcast delivery status
    Given I sent a broadcast
    When I check delivery status
    Then I should see who received it
    And I should see who read it
    And I should see any failures

  # ============================================================================
  # MUTE AND BLOCK FUNCTIONALITY
  # ============================================================================

  @happy-path @mute-block
  Scenario: Mute a conversation
    Given I have a noisy conversation
    When I mute the conversation
    Then I should stop receiving notifications
    And I should still see messages when I open it
    And the mute should be indicated

  @happy-path @mute-block
  Scenario: Unmute a conversation
    Given I have muted a conversation
    When I unmute it
    Then I should resume receiving notifications
    And the mute indicator should be removed
    And new messages should notify me

  @happy-path @mute-block
  Scenario: Block a user
    Given I do not want to receive messages from someone
    When I block the user
    Then I should not receive their messages
    And I should not see them in member lists
    And they should not be able to message me

  @happy-path @mute-block
  Scenario: Unblock a user
    Given I have blocked a user
    When I unblock them
    Then I should be able to receive their messages
    And they should be able to message me
    And previous blocks should be cleared

  @happy-path @mute-block
  Scenario: View blocked users list
    Given I have blocked users
    When I view my blocked list
    Then I should see all blocked users
    And I should be able to unblock from the list
    And block reasons should be shown if given

  @happy-path @mute-block
  Scenario: Mute notifications for time period
    Given I want temporary quiet
    When I mute for a specific duration
    Then notifications should pause for that time
    And they should resume automatically
    And I should see time remaining

  # ============================================================================
  # MESSAGE SEARCH
  # ============================================================================

  @happy-path @message-search
  Scenario: Search all messages
    Given I am looking for specific content
    When I search across all messages
    Then I should see matching results
    And results should show context
    And I should be able to click to view

  @happy-path @message-search
  Scenario: Search within specific conversation
    Given I am in a conversation
    When I search within this conversation
    Then I should find matches in this thread only
    And I should be able to navigate between results
    And matches should be highlighted

  @happy-path @message-search
  Scenario: Filter search by date range
    Given I am searching messages
    When I apply a date filter
    Then results should be within that range
    And I should be able to adjust the range
    And result count should update

  @happy-path @message-search
  Scenario: Filter search by sender
    Given I am searching messages
    When I filter by a specific sender
    Then only their messages should appear
    And I should see the context
    And I can combine with other filters

  @happy-path @message-search
  Scenario: Save search for later
    Given I have a useful search
    When I save the search
    Then it should be available in saved searches
    And I can re-run it later
    And results should update with new messages

  # ============================================================================
  # MESSAGE MODERATION TOOLS
  # ============================================================================

  @happy-path @moderation @commissioner
  Scenario: View reported messages
    Given I am the commissioner
    When I view the moderation queue
    Then I should see all reported messages
    And I should see who reported them
    And I should see report reasons

  @happy-path @moderation @commissioner
  Scenario: Remove inappropriate message
    Given I am the commissioner
    And a message was reported
    When I remove the message
    Then it should be deleted from the conversation
    And the sender should be notified
    And the action should be logged

  @happy-path @moderation @commissioner
  Scenario: Warn user about behavior
    Given I am the commissioner
    When I issue a warning to a user
    Then the user should receive the warning
    And the warning should be logged
    And repeat offenses should be trackable

  @happy-path @moderation @commissioner
  Scenario: Temporarily mute user from league chat
    Given I am the commissioner
    When I mute a user from league chat
    Then they should not be able to post
    And the mute duration should be set
    And they should be notified

  @happy-path @moderation
  Scenario: Report inappropriate message
    Given I see an inappropriate message
    When I report the message
    Then the report should be submitted
    And the commissioner should be notified
    And I should receive confirmation

  @happy-path @moderation @commissioner
  Scenario: View moderation history
    Given moderation actions have been taken
    When I view moderation history
    Then I should see all past actions
    And I should see who took each action
    And I should see the outcomes

  @happy-path @moderation @commissioner
  Scenario: Set chat content guidelines
    Given I am the commissioner
    When I set content guidelines
    Then guidelines should be visible to all
    And new members should see them
    And they should be enforceable

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Message fails to send
    Given I am sending a message
    When the send fails
    Then I should see an error indicator
    And I should be able to retry
    And the message should not be lost

  @error
  Scenario: Attachment upload fails
    Given I am uploading an attachment
    When the upload fails
    Then I should see an error message
    And I should be able to retry
    And the message text should be preserved

  @error
  Scenario: Real-time connection lost
    Given I am in a live chat
    When connection is lost
    Then I should see a connection warning
    And messages should queue for sending
    And I should reconnect automatically

  @error
  Scenario: Message history fails to load
    Given I am loading message history
    When the load fails
    Then I should see an error message
    And I should be able to retry
    And recent messages should still show

  @error
  Scenario: Notification delivery fails
    Given a notification should be sent
    When delivery fails
    Then the system should retry
    And fallback methods should be tried
    And failure should be logged

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Send message on mobile
    Given I am using the mobile app
    When I compose and send a message
    Then the message should send properly
    And the keyboard should be mobile-friendly
    And attachments should work

  @mobile
  Scenario: Receive push notification on mobile
    Given I have the mobile app
    When I receive a message
    Then I should get a push notification
    And tapping should open the conversation
    And I should be able to reply quickly

  @mobile
  Scenario: View conversations on mobile
    Given I am using the mobile app
    When I view my conversations
    Then the layout should be optimized
    And I should be able to scroll easily
    And I should navigate between chats

  @mobile
  Scenario: Use swipe gestures in messaging
    Given I am viewing messages on mobile
    When I swipe on a conversation
    Then I should see quick actions
    And I can archive or mute
    And gestures should be intuitive

  @mobile
  Scenario: Send voice message on mobile
    Given I am in a conversation on mobile
    When I record and send a voice message
    Then the recording should upload
    And the recipient should hear it
    And playback should work properly

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate messaging with keyboard
    Given I am using keyboard navigation
    When I navigate the messaging interface
    Then I should move between conversations
    And I should compose messages with keyboard
    And focus should be managed properly

  @accessibility
  Scenario: Screen reader messaging access
    Given I am using a screen reader
    When I use messaging features
    Then messages should be read properly
    And new messages should be announced
    And navigation should be clear

  @accessibility
  Scenario: High contrast messaging display
    Given I have high contrast mode enabled
    When I view messages
    Then text should be clearly readable
    And message bubbles should be distinguishable
    And unread indicators should be visible

  @accessibility
  Scenario: Voice control messaging
    Given I am using voice control
    When I compose a message by voice
    Then speech should be transcribed
    And I should be able to send by voice
    And commands should be recognized
