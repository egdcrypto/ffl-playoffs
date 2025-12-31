@chat @anima-1404
Feature: Chat
  As a fantasy football user
  I want comprehensive chat capabilities
  So that I can communicate in real-time with league members

  Background:
    Given I am a logged-in user
    And the chat system is available

  # ============================================================================
  # CHAT ROOMS
  # ============================================================================

  @happy-path @chat-rooms
  Scenario: Access league chat
    Given league chat exists
    When I access league chat
    Then I should see league chat room
    And all members should have access

  @happy-path @chat-rooms
  Scenario: Access team chat
    Given team chat exists
    When I access team chat
    Then I should see team chat room
    And only team members should have access

  @happy-path @chat-rooms
  Scenario: Start private chat
    Given I want to chat privately
    When I start private chat
    Then private chat should open
    And only we can see messages

  @happy-path @chat-rooms
  Scenario: Create group chat
    Given I want to chat with multiple people
    When I create group chat
    Then group chat should be created
    And selected members should be added

  @happy-path @chat-rooms
  Scenario: View chat rooms
    Given chat rooms exist
    When I view chat rooms
    Then I should see all my chat rooms
    And unread should be indicated

  @happy-path @chat-rooms
  Scenario: Join chat room
    Given chat room is available
    When I join chat room
    Then I should be added to room
    And I can participate

  @happy-path @chat-rooms
  Scenario: Leave chat room
    Given I am in chat room
    When I leave chat room
    Then I should be removed
    And I won't receive messages

  @happy-path @chat-rooms
  Scenario: View room info
    Given chat room exists
    When I view room info
    Then I should see room details
    And participants should be listed

  @happy-path @chat-rooms
  Scenario: Rename group chat
    Given I created group chat
    When I rename chat
    Then name should be updated
    And members should see new name

  @happy-path @chat-rooms
  Scenario: Pin chat room
    Given chat room exists
    When I pin chat room
    Then room should be pinned
    And it should appear at top

  # ============================================================================
  # CHAT MESSAGES
  # ============================================================================

  @happy-path @chat-messages
  Scenario: Send message
    Given I am in chat room
    When I send message
    Then message should be sent
    And others should receive it

  @happy-path @chat-messages
  Scenario: Receive message
    Given someone sends message
    When message is sent
    Then I should receive message
    And it should appear in chat

  @happy-path @chat-messages
  Scenario: View message history
    Given messages have been sent
    When I view history
    Then I should see past messages
    And they should be chronological

  @happy-path @chat-messages
  Scenario: Real-time chat
    Given I am in active chat
    When messages are sent
    Then they should appear instantly
    And no refresh should be needed

  @happy-path @chat-messages
  Scenario: View chat log
    Given chat has occurred
    When I view chat log
    Then I should see complete log
    And timestamps should be shown

  @happy-path @chat-messages
  Scenario: Reply to message
    Given message exists
    When I reply to message
    Then reply should reference original
    And context should be clear

  @happy-path @chat-messages
  Scenario: Edit message
    Given I sent message
    When I edit message
    Then message should be updated
    And edit should be indicated

  @happy-path @chat-messages
  Scenario: Delete message
    Given I sent message
    When I delete message
    Then message should be removed
    And deletion should be noted

  @happy-path @chat-messages
  Scenario: React to message
    Given message exists
    When I react to message
    Then reaction should be added
    And others should see it

  @happy-path @chat-messages
  Scenario: Quote message
    Given message exists
    When I quote message
    Then quote should be included
    And original should be referenced

  # ============================================================================
  # CHAT PARTICIPANTS
  # ============================================================================

  @happy-path @chat-participants
  Scenario: View participants
    Given chat room exists
    When I view participants
    Then I should see all participants
    And their info should be shown

  @happy-path @chat-participants
  Scenario: View online status
    Given participants exist
    When I view status
    Then I should see who is online
    And status should update

  @happy-path @chat-participants
  Scenario: See typing indicator
    Given someone is typing
    When they type
    Then I should see typing indicator
    And it should be real-time

  @happy-path @chat-participants
  Scenario: View user presence
    Given users are in chat
    When I view presence
    Then I should see their presence
    And active users should be indicated

  @happy-path @chat-participants
  Scenario: View member list
    Given chat room exists
    When I view member list
    Then I should see all members
    And roles should be shown

  @happy-path @chat-participants
  Scenario: Add participant
    Given I have permission
    When I add participant
    Then participant should be added
    And they should see chat history

  @happy-path @chat-participants
  Scenario: Remove participant
    Given I have permission
    When I remove participant
    Then participant should be removed
    And they can't access chat

  @happy-path @chat-participants
  Scenario: View participant profile
    Given participant exists
    When I view profile
    Then I should see their profile
    And I can message them

  @happy-path @chat-participants
  Scenario: Mention participant
    Given participant is in chat
    When I mention them
    Then they should be notified
    And mention should be highlighted

  @happy-path @chat-participants
  Scenario: View last seen
    Given participant was online
    When I view last seen
    Then I should see when they were active
    And time should be shown

  # ============================================================================
  # CHAT NOTIFICATIONS
  # ============================================================================

  @happy-path @chat-notifications
  Scenario: Receive chat alert
    Given alerts are enabled
    When new message arrives
    Then I should receive alert
    And sender should be shown

  @happy-path @chat-notifications
  Scenario: Receive new message notification
    Given notifications are enabled
    When message is received
    Then I should be notified
    And I can open chat

  @happy-path @chat-notifications
  Scenario: Receive mention notification
    Given I am mentioned
    When mention occurs
    Then I should receive notification
    And context should be shown

  @happy-path @chat-notifications
  Scenario: View chat badges
    Given unread messages exist
    When I view app
    Then badge should show count
    And it should update

  @happy-path @chat-notifications
  Scenario: Receive push notifications
    Given push is enabled
    When message arrives
    Then I should receive push
    And it should be timely

  @happy-path @chat-notifications
  Scenario: Configure notification sound
    Given sounds are available
    When I configure sound
    Then sound should be saved
    And it should play on notification

  @happy-path @chat-notifications
  Scenario: Mute chat notifications
    Given chat is noisy
    When I mute notifications
    Then notifications should stop
    And I can unmute later

  @happy-path @chat-notifications
  Scenario: Set do not disturb
    Given I need quiet time
    When I set DND
    Then notifications should pause
    And they should resume later

  @happy-path @chat-notifications
  Scenario: View notification history
    Given notifications have occurred
    When I view history
    Then I should see past notifications
    And I can review them

  @happy-path @chat-notifications
  Scenario: Configure per-chat notifications
    Given multiple chats exist
    When I configure per-chat
    Then each chat should have settings
    And they should apply independently

  # ============================================================================
  # CHAT SEARCH
  # ============================================================================

  @happy-path @chat-search
  Scenario: Search chat
    Given messages exist
    When I search chat
    Then I should find matching messages
    And results should be relevant

  @happy-path @chat-search
  Scenario: Find messages
    Given I want specific message
    When I search for it
    Then I should find message
    And I can jump to it

  @happy-path @chat-search
  Scenario: Filter by date
    Given messages span dates
    When I filter by date
    Then I should see date range
    And only matching should show

  @happy-path @chat-search
  Scenario: Filter by user
    Given multiple users chatted
    When I filter by user
    Then I should see their messages
    And others should be hidden

  @happy-path @chat-search
  Scenario: Keyword search
    Given messages contain keywords
    When I search keyword
    Then I should find matches
    And keyword should be highlighted

  @happy-path @chat-search
  Scenario: Search across rooms
    Given multiple rooms exist
    When I search all rooms
    Then I should find messages everywhere
    And room should be indicated

  @happy-path @chat-search
  Scenario: Search media
    Given media was shared
    When I search media
    Then I should find shared media
    And I can filter by type

  @happy-path @chat-search
  Scenario: View recent searches
    Given I have searched before
    When I view recent
    Then I should see recent searches
    And I can reuse them

  @happy-path @chat-search
  Scenario: Save search
    Given search is useful
    When I save search
    Then search should be saved
    And I can access later

  @happy-path @chat-search
  Scenario: Clear search
    Given search is active
    When I clear search
    Then search should reset
    And all messages should show

  # ============================================================================
  # CHAT MEDIA
  # ============================================================================

  @happy-path @chat-media
  Scenario: Share images
    Given I want to share image
    When I share image
    Then image should be sent
    And preview should be shown

  @happy-path @chat-media
  Scenario: Share files
    Given I want to share file
    When I share file
    Then file should be sent
    And others can download

  @happy-path @chat-media
  Scenario: Share links
    Given I want to share link
    When I share link
    Then link should be sent
    And preview should be generated

  @happy-path @chat-media
  Scenario: Send GIFs
    Given GIF library is available
    When I send GIF
    Then GIF should be sent
    And it should animate

  @happy-path @chat-media
  Scenario: Use emojis
    Given emoji picker is available
    When I use emoji
    Then emoji should be inserted
    And it should display correctly

  @happy-path @chat-media
  Scenario: View shared media gallery
    Given media has been shared
    When I view gallery
    Then I should see all media
    And I can filter by type

  @happy-path @chat-media
  Scenario: Download media
    Given media was shared
    When I download media
    Then file should be downloaded
    And it should be complete

  @happy-path @chat-media
  Scenario: Preview media
    Given media exists
    When I preview media
    Then preview should display
    And I can open full version

  @error @chat-media
  Scenario: Handle upload size limit
    Given file is too large
    When I try to upload
    Then I should see error
    And size limit should be explained

  @happy-path @chat-media
  Scenario: Use stickers
    Given stickers are available
    When I send sticker
    Then sticker should be sent
    And it should display correctly

  # ============================================================================
  # CHAT MODERATION
  # ============================================================================

  @happy-path @chat-moderation
  Scenario: Mute user
    Given user is disruptive
    When I mute user
    Then their messages should be hidden
    And I can unmute later

  @happy-path @chat-moderation
  Scenario: Block user
    Given I want to block someone
    When I block user
    Then user should be blocked
    And they can't message me

  @happy-path @chat-moderation
  Scenario: Report message
    Given message violates rules
    When I report message
    Then report should be submitted
    And moderators should be notified

  @commissioner @chat-moderation
  Scenario: Delete message as moderator
    Given I am moderator
    When I delete message
    Then message should be removed
    And action should be logged

  @happy-path @chat-moderation
  Scenario: View chat rules
    Given rules exist
    When I view rules
    Then I should see chat rules
    And expectations should be clear

  @commissioner @chat-moderation
  Scenario: Warn user
    Given user breaks rules
    When I warn user
    Then warning should be issued
    And user should be notified

  @commissioner @chat-moderation
  Scenario: Kick user from chat
    Given user should be removed
    When I kick user
    Then user should be removed from chat
    And they can't rejoin immediately

  @commissioner @chat-moderation
  Scenario: Ban user from chat
    Given user should be banned
    When I ban user
    Then user should be banned
    And they can't access chat

  @happy-path @chat-moderation
  Scenario: Unblock user
    Given user is blocked
    When I unblock user
    Then user should be unblocked
    And their messages should appear

  @commissioner @chat-moderation
  Scenario: View moderation log
    Given moderation actions occurred
    When I view log
    Then I should see all actions
    And details should be shown

  # ============================================================================
  # CHAT SETTINGS
  # ============================================================================

  @happy-path @chat-settings
  Scenario: Configure notification settings
    Given settings exist
    When I configure notifications
    Then settings should be saved
    And notifications should follow them

  @happy-path @chat-settings
  Scenario: Configure chat privacy
    Given privacy options exist
    When I configure privacy
    Then settings should be saved
    And privacy should be enforced

  @happy-path @chat-settings
  Scenario: Configure sound settings
    Given sound options exist
    When I configure sounds
    Then settings should be saved
    And sounds should follow them

  @happy-path @chat-settings
  Scenario: Select chat theme
    Given themes are available
    When I select theme
    Then theme should be applied
    And chat should reflect it

  @happy-path @chat-settings
  Scenario: Configure display preferences
    Given display options exist
    When I configure display
    Then settings should be saved
    And display should reflect them

  @happy-path @chat-settings
  Scenario: Set chat wallpaper
    Given wallpapers are available
    When I set wallpaper
    Then wallpaper should be applied
    And chat background should change

  @happy-path @chat-settings
  Scenario: Configure message size
    Given size options exist
    When I set message size
    Then size should be saved
    And messages should reflect it

  @happy-path @chat-settings
  Scenario: Enable compact mode
    Given compact mode exists
    When I enable compact
    Then messages should be compact
    And more should be visible

  @happy-path @chat-settings
  Scenario: Reset chat settings
    Given I have custom settings
    When I reset settings
    Then defaults should be restored
    And I should confirm first

  @happy-path @chat-settings
  Scenario: Export chat settings
    Given settings are configured
    When I export settings
    Then settings should be exported
    And I can import elsewhere

  # ============================================================================
  # CHAT HISTORY
  # ============================================================================

  @happy-path @chat-history
  Scenario: View history
    Given history exists
    When I view history
    Then I should see full history
    And it should be scrollable

  @happy-path @chat-history
  Scenario: Export chat
    Given chat exists
    When I export chat
    Then chat should be exported
    And format should be selectable

  @happy-path @chat-history
  Scenario: Archive chat
    Given chat should be archived
    When I archive chat
    Then chat should be archived
    And it should be accessible later

  @happy-path @chat-history
  Scenario: Clear history
    Given I want to clear history
    When I clear history
    Then history should be cleared
    And I should confirm first

  @happy-path @chat-history
  Scenario: Backup chat
    Given I want to backup
    When I backup chat
    Then backup should be created
    And I can restore later

  @happy-path @chat-history
  Scenario: Restore chat
    Given backup exists
    When I restore chat
    Then chat should be restored
    And messages should appear

  @happy-path @chat-history
  Scenario: View archived chats
    Given archived chats exist
    When I view archived
    Then I should see archived chats
    And I can unarchive them

  @happy-path @chat-history
  Scenario: Search history
    Given history is extensive
    When I search history
    Then I should find matches
    And I can jump to them

  @happy-path @chat-history
  Scenario: Load more history
    Given more history exists
    When I scroll up
    Then more history should load
    And older messages should appear

  @happy-path @chat-history
  Scenario: Jump to date in history
    Given history spans dates
    When I jump to date
    Then I should see that date
    And messages should be shown

  # ============================================================================
  # CHAT INTEGRATION
  # ============================================================================

  @happy-path @chat-integration
  Scenario: Trade chat
    Given trade is in progress
    When I access trade chat
    Then I should see trade discussion
    And trade parties should be present

  @happy-path @chat-integration
  Scenario: Waiver chat
    Given waivers are processing
    When I access waiver chat
    Then I should see waiver discussion
    And claims should be discussed

  @happy-path @chat-integration
  Scenario: Draft chat
    Given draft is active
    When I access draft chat
    Then I should see draft discussion
    And picks should be discussed

  @happy-path @chat-integration
  Scenario: Matchup chat
    Given matchup is active
    When I access matchup chat
    Then I should see matchup discussion
    And opponents can chat

  @happy-path @chat-integration
  Scenario: League events chat
    Given league event occurs
    When I view event chat
    Then I should see event discussion
    And reactions should be shared

  @happy-path @chat-integration
  Scenario: Playoff chat
    Given playoffs are active
    When I access playoff chat
    Then I should see playoff discussion
    And drama should be shared

  @happy-path @chat-integration
  Scenario: Game day chat
    Given games are on
    When I access game day chat
    Then I should see game discussion
    And live reactions should appear

  @happy-path @chat-integration
  Scenario: Transaction alert chat
    Given transaction occurs
    When alert is posted to chat
    Then transaction should be announced
    And discussion can follow

  @happy-path @chat-integration
  Scenario: Injury news chat
    Given injury news breaks
    When news is shared
    Then injury should be announced
    And impact should be discussed

  @happy-path @chat-integration
  Scenario: Commissioner announcement chat
    Given commissioner announces
    When announcement is made
    Then it should appear in chat
    And members can respond

