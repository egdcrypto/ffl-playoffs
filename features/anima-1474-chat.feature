@chat
Feature: Chat
  As a fantasy football manager
  I want to communicate with league members
  So that I can discuss trades, strategy, and engage with my league

  # --------------------------------------------------------------------------
  # League Chat
  # --------------------------------------------------------------------------

  @league-chat
  Scenario: Access league chat room
    Given I am a member of a league
    When I navigate to league chat
    Then I should see the league chat room
    And I should see recent messages
    And I should see who is online
    And I should be able to send messages

  @league-chat
  Scenario: Send message to league
    Given I am in the league chat room
    When I type a message
    And I send the message
    Then the message should appear in chat
    And other members should see my message
    And the message should show my name and timestamp

  @league-chat
  Scenario: View message history
    Given I am in the league chat room
    When I scroll up to view history
    Then I should see older messages
    And messages should load progressively
    And I should see message timestamps
    And I should be able to scroll to latest

  @league-chat
  Scenario: Pin important message
    Given I am a commissioner
    When I pin a message in league chat
    Then the message should be pinned
    And pinned message should be visible at top
    And all members should see the pinned message

  @league-chat
  Scenario: View pinned messages
    Given there are pinned messages in league chat
    When I view pinned messages
    Then I should see all pinned messages
    And I should see who pinned them
    And I should see when they were pinned

  @league-chat
  Scenario: Unpin message
    Given I am a commissioner
    And there is a pinned message
    When I unpin the message
    Then the message should be unpinned
    And it should return to normal message status

  # --------------------------------------------------------------------------
  # Direct Messages
  # --------------------------------------------------------------------------

  @direct-messages
  Scenario: Start direct message conversation
    Given I am logged in
    When I start a direct message with another user
    Then a DM conversation should be created
    And I should be able to send private messages
    And only the recipient should see messages

  @direct-messages
  Scenario: View conversation threads
    Given I have direct message conversations
    When I view my messages
    Then I should see all conversations
    And I should see the most recent message preview
    And I should see unread message count
    And conversations should be sorted by recent activity

  @direct-messages
  Scenario: View message status
    Given I have sent a direct message
    When I view the message
    Then I should see if message was sent
    And I should see if message was delivered
    And I should see if message was read

  @direct-messages
  Scenario: See read receipts
    Given I have sent a direct message
    And the recipient has read it
    When I view the message
    Then I should see read receipt
    And I should see when it was read

  @direct-messages
  Scenario: Reply to direct message
    Given I have received a direct message
    When I reply to the message
    Then my reply should be sent
    And the sender should be notified
    And the conversation should update

  @direct-messages
  Scenario: Delete conversation
    Given I have a direct message conversation
    When I delete the conversation
    Then the conversation should be removed from my view
    And the other person should still have their copy
    And I should see confirmation

  # --------------------------------------------------------------------------
  # Group Chat
  # --------------------------------------------------------------------------

  @group-chat
  Scenario: Create group chat
    Given I am logged in
    When I create a new group chat
    And I add members to the group
    And I name the group
    Then the group should be created
    And all members should be added
    And the group should appear in everyone's chats

  @group-chat
  Scenario: Add members to group
    Given I am in a group chat I created
    When I add new members
    Then new members should be added
    And they should see chat history
    And existing members should be notified

  @group-chat
  Scenario: Configure group settings
    Given I am a group admin
    When I configure group settings
    Then I should be able to change group name
    And I should be able to change group icon
    And I should be able to set who can add members

  @group-chat
  Scenario: Leave group chat
    Given I am a member of a group chat
    When I leave the group
    Then I should be removed from the group
    And I should no longer receive messages
    And other members should be notified

  @group-chat
  Scenario: Remove member from group
    Given I am a group admin
    When I remove a member from the group
    Then the member should be removed
    And they should no longer see new messages
    And group should be notified

  @group-chat
  Scenario: View group members
    Given I am in a group chat
    When I view group members
    Then I should see all members
    And I should see who is admin
    And I should see online status

  # --------------------------------------------------------------------------
  # Trade Chat
  # --------------------------------------------------------------------------

  @trade-chat
  Scenario: Start trade negotiation thread
    Given I am proposing a trade
    When I initiate trade chat
    Then a trade thread should be created
    And both parties should be able to message
    And trade details should be visible

  @trade-chat
  Scenario: Discuss trade proposal
    Given I have an active trade proposal
    When I send a message in trade chat
    Then the other party should receive it
    And message should be linked to trade
    And both should see conversation history

  @trade-chat
  Scenario: Send counter-offer in chat
    Given I am in a trade negotiation
    When I discuss counter-offer terms
    Then I should be able to reference players
    And I should be able to propose changes
    And we should reach agreement through chat

  @trade-chat
  Scenario: View trade chat history
    Given I have completed trades
    When I view trade chat history
    Then I should see past trade discussions
    And I should see which trades they led to
    And history should be searchable

  @trade-chat
  Scenario: Close trade chat
    Given a trade has been completed or rejected
    When the trade is finalized
    Then the trade chat should be archived
    And it should remain viewable
    And no new messages should be allowed

  # --------------------------------------------------------------------------
  # Chat Notifications
  # --------------------------------------------------------------------------

  @chat-notifications
  Scenario: Receive new message alert
    Given I have chat notifications enabled
    When someone sends me a message
    Then I should receive a notification
    And the notification should show message preview
    And I should be able to tap to open chat

  @chat-notifications
  Scenario: Receive mention notification
    Given I am mentioned in a chat
    When someone uses @mention with my name
    Then I should receive a mention notification
    And the notification should be highlighted
    And I should see who mentioned me

  @chat-notifications
  Scenario: Mute chat notifications
    Given I am in a busy chat
    When I mute the chat
    Then I should not receive notifications
    And I should still see unread count
    And I should be able to unmute

  @chat-notifications
  Scenario: Configure notification sounds
    Given I am in chat settings
    When I configure notification sounds
    Then I should be able to choose sound
    And I should be able to set volume
    And I should be able to disable sound

  @chat-notifications
  Scenario: Set do not disturb
    Given I want quiet time
    When I set do not disturb
    Then I should not receive chat notifications
    And DND should last for specified time
    And I should be able to override for urgent

  @chat-notifications
  Scenario: Get notification for specific keywords
    Given I have set keyword alerts
    When a message contains my keyword
    Then I should receive a notification
    And the keyword should be highlighted

  # --------------------------------------------------------------------------
  # Message Features
  # --------------------------------------------------------------------------

  @message-features
  Scenario: React to message with emoji
    Given I see a message in chat
    When I add an emoji reaction
    Then the reaction should appear on the message
    And others should see my reaction
    And I should see reaction count

  @message-features
  Scenario: Send GIF in chat
    Given I am composing a message
    When I search for and select a GIF
    Then the GIF should be sent in chat
    And GIF should play inline
    And others should see the GIF

  @message-features
  Scenario: Share image in chat
    Given I am in a chat
    When I share an image
    Then the image should upload
    And image should appear in chat
    And others should be able to view full size

  @message-features
  Scenario: Attach file to message
    Given I am in a chat
    When I attach a file
    Then the file should upload
    And file should be attached to message
    And others should be able to download

  @message-features
  Scenario: Format message text
    Given I am composing a message
    When I use formatting options
    Then I should be able to bold text
    And I should be able to italicize
    And I should be able to create lists

  @message-features
  Scenario: Reply to specific message
    Given I see a message I want to reply to
    When I reply to that message
    Then my reply should reference original
    And context should be visible
    And I should be able to jump to original

  @message-features
  Scenario: Edit sent message
    Given I have sent a message
    When I edit the message
    Then the message should be updated
    And edit indicator should be shown
    And edit history should be viewable

  @message-features
  Scenario: Delete sent message
    Given I have sent a message
    When I delete the message
    Then the message should be removed
    And others should see "message deleted"
    And I should see confirmation

  # --------------------------------------------------------------------------
  # Chat Moderation
  # --------------------------------------------------------------------------

  @chat-moderation
  Scenario: Report inappropriate message
    Given I see an inappropriate message
    When I report the message
    Then a report should be submitted
    And I should select reason for report
    And moderators should be notified

  @chat-moderation
  Scenario: Block user from messaging
    Given I want to block a user
    When I block the user
    Then they should not be able to message me
    And I should not see their messages
    And I should be able to unblock

  @chat-moderation
  Scenario: Use admin moderation controls
    Given I am a chat administrator
    When I access moderation tools
    Then I should be able to delete messages
    And I should be able to mute users
    And I should be able to ban users

  @chat-moderation
  Scenario: Enable content filtering
    Given I am a chat administrator
    When I enable content filtering
    Then inappropriate content should be filtered
    And filtered messages should be flagged
    And filter settings should be configurable

  @chat-moderation
  Scenario: Review reported messages
    Given I am a chat administrator
    And there are reported messages
    When I review reports
    Then I should see reported messages
    And I should see report reasons
    And I should be able to take action

  @chat-moderation
  Scenario: Mute user temporarily
    Given I am a chat administrator
    When I mute a user
    Then the user should not be able to send messages
    And mute should last for specified duration
    And user should be notified

  # --------------------------------------------------------------------------
  # Chat Search
  # --------------------------------------------------------------------------

  @chat-search
  Scenario: Search messages by keyword
    Given I am in a chat
    When I search for a keyword
    Then I should see matching messages
    And keyword should be highlighted
    And I should be able to jump to message

  @chat-search
  Scenario: Filter messages by user
    Given I am searching chat
    When I filter by specific user
    Then I should see only their messages
    And I should see message count
    And I should be able to combine filters

  @chat-search
  Scenario: Search by date range
    Given I am searching chat
    When I set a date range
    Then I should see messages from that period
    And I should be able to adjust range
    And results should be chronological

  @chat-search
  Scenario: See keyword highlighting
    Given I have searched for a term
    When I view search results
    Then search term should be highlighted
    And I should see context around match
    And I should navigate between matches

  @chat-search
  Scenario: Search across all chats
    Given I want to find a message
    When I search across all chats
    Then I should see results from all conversations
    And I should see which chat each is from
    And I should be able to open the chat

  @chat-search
  Scenario: Save search query
    Given I have a useful search query
    When I save the search
    Then the search should be saved
    And I should be able to run it again
    And I should manage saved searches

  # --------------------------------------------------------------------------
  # Chat History
  # --------------------------------------------------------------------------

  @chat-history
  Scenario: Access message archive
    Given I have old conversations
    When I access chat archive
    Then I should see archived conversations
    And I should be able to search archives
    And I should be able to restore if needed

  @chat-history
  Scenario: Export conversation
    Given I want to save a conversation
    When I export the conversation
    Then I should receive exportable format
    And export should include all messages
    And I should choose format type

  @chat-history
  Scenario: Delete messages permanently
    Given I want to delete messages
    When I delete messages permanently
    Then messages should be permanently removed
    And I should confirm before deletion
    And deletion should be irreversible

  @chat-history
  Scenario: Configure message retention
    Given I am a chat administrator
    When I configure retention settings
    Then I should set how long messages are kept
    And old messages should be deleted automatically
    And I should be warned before deletion

  @chat-history
  Scenario: View message statistics
    Given I am viewing chat history
    When I view statistics
    Then I should see message counts
    And I should see most active times
    And I should see most active users

  @chat-history
  Scenario: Restore deleted messages
    Given I have recently deleted messages
    When I try to restore within retention period
    Then I should be able to restore messages
    And messages should reappear in chat
    And I should see restore confirmation

  # --------------------------------------------------------------------------
  # Real-Time Chat
  # --------------------------------------------------------------------------

  @real-time-chat
  Scenario: Experience live messaging
    Given I am in an active chat
    When someone sends a message
    Then the message should appear instantly
    And no refresh should be needed
    And messages should stream in real-time

  @real-time-chat
  Scenario: See typing indicator
    Given I am in a chat
    When another user is typing
    Then I should see typing indicator
    And indicator should show who is typing
    And indicator should disappear when they stop

  @real-time-chat
  Scenario: View online status
    Given I am viewing chat members
    When I look at user status
    Then I should see who is online
    And I should see who is offline
    And I should see last active time

  @real-time-chat
  Scenario: Track message delivery
    Given I send a message
    Then I should see sent confirmation
    And I should see delivered status
    And status should update in real-time

  @real-time-chat
  Scenario: Handle reconnection gracefully
    Given I lose connection during chat
    When connection is restored
    Then I should receive missed messages
    And message order should be preserved
    And I should see reconnection notice

  @real-time-chat
  Scenario: Sync across devices
    Given I am logged in on multiple devices
    When I receive a message
    Then message should appear on all devices
    And read status should sync
    And typing should sync

  # --------------------------------------------------------------------------
  # Chat Accessibility
  # --------------------------------------------------------------------------

  @chat @accessibility
  Scenario: Use chat with screen reader
    Given I use a screen reader
    When I use the chat interface
    Then messages should be announced
    And I should navigate with keyboard
    And all controls should be accessible

  @chat @accessibility
  Scenario: Use keyboard shortcuts in chat
    Given I am in the chat interface
    When I use keyboard shortcuts
    Then I should send message with Enter
    And I should navigate with arrow keys
    And shortcuts should be discoverable

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @chat @error-handling
  Scenario: Handle message send failure
    Given I send a message
    When the send fails
    Then I should see error indicator
    And I should be able to retry
    And message should not be lost

  @chat @error-handling
  Scenario: Handle connection loss
    Given I am in an active chat
    When I lose connection
    Then I should see offline indicator
    And I should be able to queue messages
    And messages should send when reconnected

  @chat @error-handling
  Scenario: Handle file upload failure
    Given I am uploading a file
    When the upload fails
    Then I should see error message
    And I should be able to retry
    And I should see upload progress

  @chat @validation
  Scenario: Validate message content
    Given I am composing a message
    When I exceed character limit
    Then I should see character count
    And I should see limit warning
    And I should not be able to send until fixed

  @chat @security
  Scenario: Protect message privacy
    Given I am in a private chat
    Then messages should be transmitted securely
    And messages should be stored securely
    And unauthorized users should not access
