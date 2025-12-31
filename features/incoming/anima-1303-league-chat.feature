@league-chat @messaging
Feature: League Chat
  As a fantasy football manager
  I want to communicate with my league members
  So that I can engage in discussions, trash talk, and coordinate trades

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the league chat is enabled

  # ============================================================================
  # GROUP CHAT ROOM
  # ============================================================================

  @happy-path @group-chat
  Scenario: Access league chat room
    When I open the league chat
    Then I should see the main chat room
    And I should see recent messages
    And I should see who is online

  @happy-path @group-chat
  Scenario: Send message to group chat
    When I type "Good luck this week everyone!"
    And I send the message
    Then my message should appear in the chat
    And all league members should see it
    And the message should show my name and timestamp

  @happy-path @group-chat
  Scenario: View online members
    When I view the chat room
    Then I should see a list of online members
    And I should see their status (online, away, offline)
    And I should see when they were last active

  @happy-path @group-chat
  Scenario: Scroll through chat history
    Given the chat has extensive history
    When I scroll up in the chat
    Then older messages should load
    And I should be able to scroll to any point in history
    And loading should be smooth

  @happy-path @group-chat
  Scenario: Create topic-based chat channels
    Given the commissioner has enabled multiple channels
    When I view available channels
    Then I should see:
      | Channel         | Description            |
      | General         | Main league discussion |
      | Trade Talk      | Trade negotiations     |
      | Trash Talk      | Competitive banter     |
      | Game Day        | Live game discussion   |

  @happy-path @group-chat
  Scenario: Switch between chat channels
    Given multiple channels exist
    When I switch to the "Trade Talk" channel
    Then I should see Trade Talk messages
    And my messages should post to that channel

  # ============================================================================
  # DIRECT MESSAGING
  # ============================================================================

  @happy-path @dm
  Scenario: Start direct message conversation
    When I click on "John Smith" in the member list
    And I select "Send Message"
    Then a DM conversation should open
    And I should be able to send private messages

  @happy-path @dm
  Scenario: Send direct message
    Given I have a DM conversation with "John Smith"
    When I send "Hey, interested in trading Kelce?"
    Then John should receive the message
    And it should be private between us

  @happy-path @dm
  Scenario: View DM conversation list
    When I view my direct messages
    Then I should see all my DM conversations
    And I should see unread message counts
    And conversations should be sorted by recent activity

  @happy-path @dm
  Scenario: Start group DM
    When I create a group DM with:
      | Member      |
      | John Smith  |
      | Jane Doe    |
      | Bob Jones   |
    Then a group conversation should be created
    And all selected members should be included

  @happy-path @dm
  Scenario: Leave group DM
    Given I am in a group DM
    When I leave the conversation
    Then I should no longer receive messages
    And I should be removed from the participant list

  @happy-path @dm
  Scenario: Block DMs from a user
    Given "SpamUser" keeps messaging me
    When I block "SpamUser" from DMs
    Then I should not receive their messages
    And they should see their messages as delivered

  # ============================================================================
  # CHAT NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive notification for new message
    Given I am not in the chat room
    When someone sends a message
    Then I should receive a notification
    And the notification should show a preview

  @happy-path @notifications
  Scenario: Receive notification for @mention
    Given someone mentions me with "@MyName"
    When the message is sent
    Then I should receive a priority notification
    And the notification should be highlighted

  @happy-path @notifications
  Scenario: Configure chat notification settings
    When I configure chat notifications
    Then I should be able to set:
      | Setting            | Options                    |
      | All Messages       | On/Off                     |
      | Mentions Only      | On/Off                     |
      | DMs Only           | On/Off                     |
      | Sound              | On/Off                     |

  @happy-path @notifications
  Scenario: Notification badge for unread messages
    Given I have 5 unread chat messages
    When I view the app navigation
    Then the chat icon should show "5" badge
    And the badge should clear when I read messages

  @happy-path @notifications
  Scenario: Desktop notification for chat
    Given I have desktop notifications enabled
    When a new message arrives
    Then I should see a desktop notification
    And clicking it should open the chat

  # ============================================================================
  # MESSAGE REACTIONS
  # ============================================================================

  @happy-path @reactions
  Scenario: React to a message with emoji
    Given there is a message in chat
    When I react with a thumbs up emoji
    Then the reaction should appear on the message
    And others should see my reaction

  @happy-path @reactions
  Scenario: View all reactions on a message
    Given a message has multiple reactions
    When I click on the reactions
    Then I should see who reacted with what
    And I should see reaction counts

  @happy-path @reactions
  Scenario: Remove my reaction
    Given I reacted to a message
    When I click my reaction again
    Then my reaction should be removed
    And the count should decrease

  @happy-path @reactions
  Scenario: Quick reaction options
    When I hover over a message
    Then I should see quick reaction options
    And I should be able to react with one click

  @happy-path @reactions
  Scenario: Custom reaction picker
    When I open the full emoji picker
    Then I should see all available emojis
    And I should see recently used emojis
    And I should be able to search emojis

  # ============================================================================
  # IMAGE/GIF SHARING
  # ============================================================================

  @happy-path @media
  Scenario: Share an image in chat
    When I upload an image to chat
    Then the image should appear in the conversation
    And others should be able to view it
    And clicking should open full size

  @happy-path @media
  Scenario: Share GIF using GIF picker
    When I open the GIF picker
    And I search for "touchdown dance"
    Then I should see relevant GIFs
    And selecting one should send it to chat

  @happy-path @media
  Scenario: Preview image before sending
    When I select an image to upload
    Then I should see a preview
    And I should be able to add a caption
    And I should confirm before sending

  @validation @media
  Scenario: Validate image file size
    When I try to upload an image over 10MB
    Then I should see "Image must be less than 10MB"
    And the upload should be blocked

  @validation @media
  Scenario: Validate file types
    When I try to upload an unsupported file type
    Then I should see "Only images and GIFs are allowed"
    And the upload should be blocked

  @happy-path @media
  Scenario: View shared media gallery
    When I view the media gallery for the chat
    Then I should see all shared images and GIFs
    And I should be able to filter by type
    And I should see who shared each item

  # ============================================================================
  # TRASH TALK
  # ============================================================================

  @happy-path @trash-talk
  Scenario: Send trash talk message
    When I send a competitive message
    Then it should display with trash talk styling
    And it should be visible to my opponent

  @happy-path @trash-talk
  Scenario: Use trash talk templates
    When I open trash talk templates
    Then I should see pre-made trash talk options:
      | Template                                    |
      | Your team doesn't stand a chance this week! |
      | Enjoy watching from the losers bracket!     |
      | I've seen better rosters in free leagues!   |
    And I should be able to customize before sending

  @happy-path @trash-talk
  Scenario: Trash talk with stats
    When I send trash talk with auto-stats
    Then the message should include:
      """
      Your team has scored 50 fewer points than mine this season!
      Current record: Me 8-2, You 5-5
      """

  @happy-path @trash-talk
  Scenario: Matchup-specific trash talk
    Given it's game week
    When I view my matchup chat
    Then I should see a dedicated trash talk section
    And messages should be visible to my opponent

  @happy-path @trash-talk
  Scenario: Award best trash talker
    Given the season has ended
    When the commissioner reviews trash talk
    Then they should be able to award "Best Trash Talker"
    And the award should appear on the winner's profile

  # ============================================================================
  # CHAT MODERATION
  # ============================================================================

  @commissioner @moderation
  Scenario: Delete inappropriate message
    Given I am the commissioner
    When I delete an inappropriate message
    Then the message should be removed
    And a "[Message deleted]" placeholder should appear
    And the sender should be notified

  @commissioner @moderation
  Scenario: Warn user for behavior
    Given I am the commissioner
    When I issue a warning to "BadBehavior"
    Then the user should receive a warning notification
    And the warning should be logged
    And I should see their warning history

  @commissioner @moderation
  Scenario: Mute user from chat
    Given I am the commissioner
    When I mute "TrollUser" for 24 hours
    Then they should not be able to send messages
    And they should see "You are muted until [time]"
    And they should be automatically unmuted after

  @commissioner @moderation
  Scenario: Ban user from chat permanently
    Given I am the commissioner
    When I permanently ban "AbusiveUser" from chat
    Then they should not be able to access chat
    And they should see a ban message
    And I should be able to unban later

  @happy-path @moderation
  Scenario: Report message to commissioner
    When I report a message as inappropriate
    Then the commissioner should receive a notification
    And the message should be flagged for review
    And I should see confirmation of the report

  @commissioner @moderation
  Scenario: View moderation log
    Given I am the commissioner
    When I view the moderation log
    Then I should see all moderation actions
    And I should see who took each action
    And I should see the reason for each action

  # ============================================================================
  # MESSAGE HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: Search message history
    When I search for "trade Kelce"
    Then I should see all messages containing those words
    And I should see the context of each match
    And I should be able to jump to the message

  @happy-path @history
  Scenario: Filter messages by date
    When I filter messages from "October 2024"
    Then I should see only messages from that month
    And I should be able to navigate by date

  @happy-path @history
  Scenario: Filter messages by member
    When I filter messages from "John Smith"
    Then I should see only John's messages
    And I should see the conversation context

  @happy-path @history
  Scenario: Export chat history
    When I export chat history
    Then I should receive a downloadable file
    And it should include all messages
    And I should choose the format (PDF, TXT)

  @happy-path @history
  Scenario: View message in context
    Given I found a message in search
    When I click "View in Context"
    Then the chat should scroll to that message
    And the message should be highlighted
    And I should see surrounding messages

  # ============================================================================
  # PINNED MESSAGES
  # ============================================================================

  @commissioner @pinned
  Scenario: Pin important message
    Given I am the commissioner
    When I pin a message
    Then the message should appear in pinned section
    And all members should see it's pinned
    And it should stay at the top

  @happy-path @pinned
  Scenario: View pinned messages
    When I click on pinned messages
    Then I should see all pinned messages
    And I should see who pinned each
    And I should see when it was pinned

  @commissioner @pinned
  Scenario: Unpin message
    Given I am the commissioner
    And a message is pinned
    When I unpin the message
    Then it should be removed from pinned
    And it should remain in normal history

  @happy-path @pinned
  Scenario: Navigate to pinned message
    When I click on a pinned message
    Then I should jump to that message in history
    And the message should be highlighted

  @commissioner @pinned
  Scenario: Pin message with expiration
    Given I am the commissioner
    When I pin a message with 7-day expiration
    Then the message should unpin automatically after 7 days
    And members should see the expiration date

  # ============================================================================
  # @MENTIONS
  # ============================================================================

  @happy-path @mentions
  Scenario: Mention a user in chat
    When I type "@John" in my message
    Then I should see autocomplete suggestions
    And selecting John should add the mention
    And John should be notified

  @happy-path @mentions
  Scenario: Mention everyone
    When I type "@everyone"
    Then all league members should be notified
    And the message should be highlighted for all

  @happy-path @mentions
  Scenario: Mention by role
    When I type "@commissioners"
    Then all commissioners should be notified
    And only commissioners should get the mention notification

  @happy-path @mentions
  Scenario: View my mentions
    When I view my mentions
    Then I should see all messages that mentioned me
    And I should see unread mentions highlighted
    And I should be able to jump to each

  @happy-path @mentions
  Scenario: Mention autocomplete
    When I type "@Jo"
    Then I should see:
      | Suggestion   |
      | @John Smith  |
      | @Joe Brown   |
      | @Jordan Lee  |
    And selecting should complete the mention

  @validation @mentions
  Scenario: Rate limit @everyone mentions
    Given I just used @everyone
    When I try to use @everyone again
    Then I should see "Please wait before using @everyone again"
    And the mention should not work

  # ============================================================================
  # CHAT MUTING
  # ============================================================================

  @happy-path @muting
  Scenario: Mute league chat
    When I mute the league chat
    Then I should not receive notifications
    And I should still be able to read messages
    And a muted indicator should appear

  @happy-path @muting
  Scenario: Mute for specific duration
    When I mute chat for 1 hour
    Then I should not receive notifications for 1 hour
    And after 1 hour, notifications should resume
    And I should see the mute expiration

  @happy-path @muting
  Scenario: Mute specific channel
    Given multiple channels exist
    When I mute the "Trash Talk" channel
    Then I should not receive notifications for that channel
    And other channel notifications should continue

  @happy-path @muting
  Scenario: Mute except mentions
    When I set "Mute except @mentions"
    Then I should not receive general message notifications
    And I should still receive mention notifications

  @happy-path @muting
  Scenario: Unmute chat
    Given chat is muted
    When I unmute the chat
    Then notifications should resume immediately
    And the muted indicator should disappear

  @happy-path @muting
  Scenario: View muted conversations
    When I view my muted conversations
    Then I should see all muted chats
    And I should be able to unmute each

  # ============================================================================
  # MOBILE PUSH
  # ============================================================================

  @mobile @push
  Scenario: Receive push notification for chat message
    Given I have the mobile app installed
    And push notifications are enabled
    When someone sends a chat message
    Then I should receive a push notification
    And tapping should open the chat

  @mobile @push
  Scenario: Push notification shows message preview
    Given someone sends "Great trade offer!"
    When I receive the push notification
    Then I should see the message preview
    And I should see who sent it

  @mobile @push
  Scenario: Quick reply from notification
    Given I received a chat notification
    When I use the quick reply action
    Then I should be able to type a response
    And my reply should be sent without opening the app

  @mobile @push
  Scenario: Group multiple notifications
    Given 5 new messages arrive while I'm away
    When I view my notifications
    Then they should be grouped as "5 new messages in Playoff Champions"
    And tapping should show all messages

  @mobile @push
  Scenario: Configure mobile push for chat
    When I configure mobile push settings
    Then I should be able to:
      | Setting             | Options     |
      | Enable Push         | On/Off      |
      | Show Preview        | On/Off      |
      | Sound               | On/Off      |
      | Vibration           | On/Off      |

  # ============================================================================
  # REAL-TIME MESSAGING
  # ============================================================================

  @happy-path @real-time
  Scenario: Messages appear in real-time
    Given I am in the chat room
    When another user sends a message
    Then the message should appear immediately
    And I should not need to refresh

  @happy-path @real-time
  Scenario: Typing indicator
    Given I am viewing a conversation
    When another user starts typing
    Then I should see "John is typing..."
    And the indicator should disappear when they stop

  @happy-path @real-time
  Scenario: Read receipts
    Given I sent a message
    When the recipient reads it
    Then I should see a "Read" indicator
    And I should see when it was read

  @happy-path @real-time
  Scenario: Online presence updates
    When a user comes online
    Then their status should update to "Online"
    And I should see this in real-time

  @happy-path @real-time
  Scenario: Message delivery confirmation
    When I send a message
    Then I should see a "Sending..." indicator
    And it should change to "Sent" when delivered
    And I should see a checkmark

  @edge-case @real-time
  Scenario: Handle connection interruption
    Given I am chatting
    And my connection is interrupted
    When I reconnect
    Then I should see any missed messages
    And my pending message should retry
    And I should see connection status

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Chat on mobile device
    Given I am using a mobile device
    When I open the chat
    Then I should see a mobile-optimized layout
    And the keyboard should not block messages
    And I should be able to swipe to navigate

  @mobile @responsive
  Scenario: Send image from mobile
    Given I am on mobile
    When I tap the camera icon
    Then I should be able to take a photo
    Or I should be able to choose from gallery
    And I should preview before sending

  @mobile @responsive
  Scenario: Voice message on mobile
    Given the league has voice messages enabled
    When I hold the microphone button
    Then I should be able to record a voice message
    And I should preview before sending
    And others should be able to play it

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for chat
    Given I am using a screen reader
    When I navigate the chat
    Then messages should be announced
    And sender and timestamp should be clear
    And new messages should be announced

  @accessibility @a11y
  Scenario: Keyboard navigation for chat
    Given I am using keyboard only
    When I use the chat
    Then I should navigate with Tab
    And I should send with Enter
    And I should access all features

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle message send failure
    Given my network connection fails
    When I try to send a message
    Then I should see "Message failed to send"
    And I should see a retry option
    And my message should be preserved

  @error @resilience
  Scenario: Handle image upload failure
    Given image upload fails
    When I try to share an image
    Then I should see an error message
    And I should be able to retry
    And my image should be preserved

  @error @resilience
  Scenario: Handle real-time connection loss
    Given my WebSocket connection drops
    Then I should see "Reconnecting..."
    And the system should auto-reconnect
    And I should receive missed messages
