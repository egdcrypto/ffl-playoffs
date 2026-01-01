@league-chat
Feature: League Chat
  As a fantasy football league member
  I want comprehensive chat functionality
  So that I can communicate with other league members effectively

  Background:
    Given I am logged in as a league member
    And I have an active fantasy football league
    And I am on the league chat page

  # --------------------------------------------------------------------------
  # Group Messaging Scenarios
  # --------------------------------------------------------------------------
  @group-messaging
  Scenario: Send message to league-wide chat
    Given I am in the league-wide chat room
    When I compose a new message
    And I click the send button
    Then the message should appear in the chat
    And all league members should be able to see the message
    And the message should show my username and timestamp

  @group-messaging
  Scenario: Receive real-time messages
    Given I am viewing the league chat
    And another member sends a message
    When the message is delivered
    Then I should see the message appear immediately
    And no page refresh should be required
    And I should see a visual indicator for new messages

  @group-messaging
  Scenario: Reply to message in thread
    Given there is an existing message in the chat
    When I click the reply button on the message
    And I compose my reply
    And I send the reply
    Then the reply should appear as a thread under the original message
    And the thread count should be updated
    And thread participants should be notified

  @group-messaging
  Scenario: View message thread
    Given a message has multiple replies
    When I click on the message to expand the thread
    Then I should see all replies in chronological order
    And I should see the reply count
    And I should be able to add to the thread

  @group-messaging
  Scenario: Pin important message
    Given I have moderator privileges
    And there is a message to pin
    When I select "Pin Message" from message options
    Then the message should be pinned to the top of the chat
    And the pin indicator should be visible
    And all members should see the pinned message prominently

  @group-messaging
  Scenario: Unpin message
    Given there is a pinned message
    And I have moderator privileges
    When I select "Unpin Message" from message options
    Then the message should be unpinned
    And the message should return to its original position

  @group-messaging
  Scenario: View chat member list
    Given I am in the league chat
    When I click on the member list icon
    Then I should see all league members
    And I should see their online status
    And I should be able to start a direct message from here

  @group-messaging
  Scenario: Scroll through chat history
    Given the chat has extensive message history
    When I scroll up in the chat window
    Then older messages should load progressively
    And scrolling should be smooth
    And I should be able to return to newest messages easily

  # --------------------------------------------------------------------------
  # Direct Messaging Scenarios
  # --------------------------------------------------------------------------
  @direct-messaging
  Scenario: Start direct message with owner
    Given I want to message another team owner
    When I select the owner from the member list
    And I click "Send Direct Message"
    Then a private chat should be created
    And only the two of us should have access
    And the conversation should appear in my DM list

  @direct-messaging
  Scenario: Send private trade negotiation message
    Given I am in a direct message with another owner
    And we are discussing a potential trade
    When I send a message about trade terms
    Then the message should be delivered privately
    And no other league members should see it
    And the conversation should be tagged as trade-related

  @direct-messaging
  Scenario: View direct message history
    Given I have previous DM conversations
    When I access my direct message inbox
    Then I should see all my DM conversations
    And conversations should be sorted by most recent
    And I should see unread message indicators

  @direct-messaging
  Scenario: Search direct message history
    Given I have extensive DM history with another owner
    When I use the search function in the DM
    And I enter search terms
    Then matching messages should be highlighted
    And I should be able to jump to each result
    And the search should cover all message history

  @direct-messaging
  Scenario: Block user from direct messaging
    Given I no longer want to receive DMs from a user
    When I access the user's profile
    And I select "Block User"
    And I confirm the block
    Then the user should not be able to send me DMs
    And I should not see their messages
    And I can unblock them later if desired

  @direct-messaging
  Scenario: Delete direct message conversation
    Given I have a DM conversation I want to remove
    When I select "Delete Conversation" from options
    And I confirm the deletion
    Then the conversation should be removed from my inbox
    And the other user's copy should remain intact
    And I should not see new messages from that thread

  @direct-messaging
  Scenario: Mark direct messages as read
    Given I have unread direct messages
    When I open the DM conversation
    Then the messages should be marked as read
    And the unread indicator should be removed
    And the sender should see read receipt if enabled

  @direct-messaging
  Scenario: Send voice message in DM
    Given I am in a direct message conversation
    When I click the voice message button
    And I record my voice message
    And I send the recording
    Then the voice message should be delivered
    And the recipient should be able to play it
    And duration should be displayed

  # --------------------------------------------------------------------------
  # Chat Notifications Scenarios
  # --------------------------------------------------------------------------
  @chat-notifications
  Scenario: Receive new message alert
    Given I am not actively viewing the chat
    And a new message is posted
    When the message is delivered
    Then I should receive a notification alert
    And the notification should show a preview
    And clicking the notification should open the chat

  @chat-notifications
  Scenario: Receive mention notification
    Given another user mentions me in a message
    When the message is sent
    Then I should receive a prominent notification
    And my username should be highlighted in the message
    And the notification should indicate I was mentioned

  @chat-notifications
  Scenario: View unread message indicators
    Given I have unread messages in multiple conversations
    When I view the chat navigation
    Then I should see unread counts for each chat
    And the total unread count should be visible
    And unread indicators should clear when I view messages

  @chat-notifications
  Scenario: Configure notification preferences
    Given I want to customize my notifications
    When I access chat notification settings
    And I adjust my preferences
    And I save the settings
    Then notifications should follow my preferences
    And I should only receive alerts I opted into

  @chat-notifications
  Scenario: Mute notifications temporarily
    Given I want to temporarily mute chat notifications
    When I select "Mute Notifications"
    And I choose the mute duration
    Then I should not receive notifications during that period
    And a mute indicator should be visible
    And notifications should resume after the duration

  @chat-notifications
  Scenario: Enable do not disturb mode
    Given I want to stop all chat notifications
    When I enable do not disturb mode
    Then all chat notifications should be suppressed
    And a DND indicator should be visible
    And messages should still be delivered silently

  @chat-notifications
  Scenario: Receive notification for reactions
    Given I have sent a message
    And another user reacts to my message
    When the reaction is added
    Then I should receive a notification about the reaction
    And I should see what reaction was added
    And I can disable reaction notifications if desired

  @chat-notifications
  Scenario: Get notified of important messages
    Given I have set up priority notifications
    And a message matches my priority criteria
    When the message is posted
    Then I should receive a priority notification
    And the notification should bypass quiet hours if configured
    And the message should be highlighted in the chat

  # --------------------------------------------------------------------------
  # Message Types Scenarios
  # --------------------------------------------------------------------------
  @message-types
  Scenario: Send text message
    Given I am in a chat conversation
    When I type a text message
    And I send the message
    Then the text should appear in the chat
    And formatting should be preserved
    And the message should be delivered to recipients

  @message-types
  Scenario: Send emoji in message
    Given I am composing a message
    When I click the emoji picker
    And I select an emoji
    Then the emoji should be inserted into my message
    And I can add multiple emojis
    And emojis should render correctly for all users

  @message-types
  Scenario: Send GIF in chat
    Given I am in a chat conversation
    When I click the GIF button
    And I search for a GIF
    And I select and send the GIF
    Then the GIF should appear in the chat
    And the GIF should animate properly
    And the GIF should be appropriate for the platform

  @message-types
  Scenario: Share image in chat
    Given I want to share an image
    When I click the image upload button
    And I select an image from my device
    And I send the image
    Then the image should appear in the chat
    And users should be able to view full size
    And the image should be compressed if necessary

  @message-types
  Scenario: Share link with preview
    Given I want to share a link
    When I paste a URL into the message
    And I send the message
    Then the link should generate a preview
    And the preview should show title and image
    And users should be able to click through to the link

  @message-types
  Scenario: Send formatted text
    Given I am composing a message
    When I apply formatting (bold, italic, etc.)
    And I send the message
    Then the formatting should be preserved
    And all users should see the formatted text
    And formatting should work across platforms

  @message-types
  Scenario: Send code snippet
    Given I want to share a code snippet
    When I use code block formatting
    And I paste my code
    And I send the message
    Then the code should appear in a formatted block
    And syntax highlighting should be applied if possible
    And users should be able to copy the code

  @message-types
  Scenario: Send message with attachments
    Given I want to attach a file
    When I click the attachment button
    And I select a supported file type
    And I send the message with attachment
    Then the attachment should be uploaded
    And users should be able to download it
    And file type icons should be displayed

  # --------------------------------------------------------------------------
  # Chat Moderation Scenarios
  # --------------------------------------------------------------------------
  @chat-moderation
  Scenario: Mute user in chat
    Given I have moderation privileges
    And a user is being disruptive
    When I select "Mute User" from moderation options
    And I set the mute duration
    And I confirm the mute action
    Then the user should be muted
    And they should not be able to send messages
    And a mute notification should be shown

  @chat-moderation
  Scenario: Delete inappropriate message
    Given I have moderation privileges
    And there is an inappropriate message
    When I select "Delete Message" from options
    And I provide a deletion reason
    And I confirm the deletion
    Then the message should be removed
    And a placeholder should indicate deletion
    And the sender should be notified

  @chat-moderation
  Scenario: Report inappropriate content
    Given I see content that violates guidelines
    When I select "Report Message" from options
    And I choose the violation category
    And I provide additional details
    And I submit the report
    Then the report should be sent to moderators
    And I should receive confirmation
    And the reporter should remain anonymous

  @chat-moderation
  Scenario: Review reported content
    Given I am a moderator
    And there are pending reports
    When I access the moderation queue
    Then I should see all pending reports
    And I should see the reported content and context
    And I should be able to take action on reports

  @chat-moderation
  Scenario: Warn user for behavior
    Given I have moderation privileges
    And a user has minor violations
    When I issue a warning to the user
    And I specify the reason
    Then the user should receive a warning notification
    And the warning should be logged
    And repeated warnings should escalate

  @chat-moderation
  Scenario: Ban user from chat
    Given I have moderation privileges
    And a user has serious violations
    When I select "Ban User" from moderation options
    And I set the ban duration or make it permanent
    And I confirm the ban
    Then the user should be banned from chat
    And they should not be able to access chat
    And their messages should remain but be marked

  @chat-moderation
  Scenario: Set up word filters
    Given I am configuring chat moderation
    When I access the word filter settings
    And I add words to the filter list
    And I configure filter actions
    And I save the settings
    Then filtered words should be blocked or flagged
    And users should be notified of violations
    And the filter should apply to all messages

  @chat-moderation
  Scenario: View moderation log
    Given moderation actions have been taken
    When I access the moderation log
    Then I should see all moderation actions
    And each entry should show action details
    And I should be able to filter by action type

  # --------------------------------------------------------------------------
  # Trash Talk Features Scenarios
  # --------------------------------------------------------------------------
  @trash-talk
  Scenario: Access smack talk prompts
    Given I want to trash talk my opponent
    When I access the smack talk feature
    Then I should see suggested trash talk prompts
    And prompts should be contextual to matchups
    And I should be able to customize prompts

  @trash-talk
  Scenario: Send trash talk to matchup opponent
    Given I am playing against another team this week
    When I compose a trash talk message
    And I send it to my opponent
    Then the message should be delivered
    And it should be highlighted as trash talk
    And it should appear in the matchup chat

  @trash-talk
  Scenario: View rivalry statistics
    Given I have a rival in the league
    When I access the rivalry highlighting feature
    Then I should see our head-to-head record
    And memorable moments should be highlighted
    And I should be able to send rivalry-specific taunts

  @trash-talk
  Scenario: Join matchup-based chat room
    Given there is an active matchup
    When I access the matchup chat room
    Then I should be in a chat with my opponent
    And other league members can spectate
    And the chat should be focused on this matchup

  @trash-talk
  Scenario: Create trash talk poll
    Given I want to poll the league about a matchup
    When I create a trash talk poll
    And I set the poll options
    And I post the poll
    Then league members should be able to vote
    And results should update in real-time
    And the poll should add to the banter

  @trash-talk
  Scenario: Share victory celebration
    Given I have won my matchup
    When I access celebration features
    And I select a celebration to send
    Then the celebration should be posted to chat
    And my opponent should be notified
    And the celebration should be appropriately themed

  @trash-talk
  Scenario: Enable trash talk mode
    Given I want to engage in more trash talk
    When I enable trash talk mode
    Then I should see more aggressive prompts
    And my messages should have special formatting
    And I can disable this mode at any time

  @trash-talk
  Scenario: View all-time trash talk highlights
    Given the league has trash talk history
    When I access the trash talk hall of fame
    Then I should see memorable trash talk moments
    And moments should be voteable
    And I should be able to share highlights

  # --------------------------------------------------------------------------
  # Chat History Scenarios
  # --------------------------------------------------------------------------
  @chat-history
  Scenario: Search message history
    Given the chat has extensive history
    When I access the search function
    And I enter search terms
    Then matching messages should be displayed
    And I should see message context
    And I should be able to jump to each result

  @chat-history
  Scenario: Filter chat history by date
    Given I want to find messages from a specific time
    When I access history filters
    And I select a date range
    Then only messages from that period should show
    And I should be able to adjust the range
    And results should load efficiently

  @chat-history
  Scenario: Filter chat history by user
    Given I want to see messages from a specific user
    When I filter history by username
    Then only that user's messages should display
    And I should see message counts
    And I should be able to combine with other filters

  @chat-history
  Scenario: Archive old conversations
    Given I want to archive inactive conversations
    When I select conversations to archive
    And I confirm the archival
    Then the conversations should be archived
    And they should be accessible in archive folder
    And they should not appear in active list

  @chat-history
  Scenario: Export conversation history
    Given I want to export a conversation
    When I select "Export Conversation" from options
    And I choose the export format
    And I initiate the export
    Then the conversation should be exported
    And all messages should be included
    And the file should download to my device

  @chat-history
  Scenario: View message activity timeline
    Given I want to see chat activity patterns
    When I access the activity timeline
    Then I should see message volume over time
    And peak activity periods should be highlighted
    And I should be able to drill into specific periods

  @chat-history
  Scenario: Bookmark important messages
    Given I want to save an important message
    When I select "Bookmark" on the message
    Then the message should be saved to bookmarks
    And I should be able to access bookmarks later
    And bookmarks should be organized chronologically

  @chat-history
  Scenario: Restore archived conversation
    Given I have archived conversations
    When I access the archive
    And I select a conversation to restore
    Then the conversation should be moved to active
    And all messages should be preserved
    And the conversation should appear in my list

  # --------------------------------------------------------------------------
  # Chat Reactions Scenarios
  # --------------------------------------------------------------------------
  @chat-reactions
  Scenario: React to message with emoji
    Given there is a message in the chat
    When I click the reaction button
    And I select a reaction emoji
    Then the reaction should appear on the message
    And reaction count should be displayed
    And other users should see my reaction

  @chat-reactions
  Scenario: View who reacted to message
    Given a message has multiple reactions
    When I click on the reaction count
    Then I should see who added each reaction
    And reactions should be grouped by emoji
    And I should see when reactions were added

  @chat-reactions
  Scenario: Remove my reaction
    Given I have reacted to a message
    When I click on my reaction
    Then my reaction should be removed
    And the count should update
    And other reactions should remain

  @chat-reactions
  Scenario: Create poll in chat
    Given I want to poll the league
    When I click the poll creation button
    And I enter the poll question
    And I add poll options
    And I set poll duration
    And I post the poll
    Then the poll should appear in the chat
    And members should be able to vote
    And results should update in real-time

  @chat-reactions
  Scenario: Vote in chat poll
    Given there is an active poll
    When I select my choice
    And I submit my vote
    Then my vote should be recorded
    And I should see current results
    And I should not be able to vote again unless allowed

  @chat-reactions
  Scenario: View poll results
    Given a poll has ended
    When I view the poll
    Then I should see final results
    And vote percentages should be displayed
    And the winning option should be highlighted

  @chat-reactions
  Scenario: Create quick vote
    Given I want a simple yes/no vote
    When I use the quick vote feature
    And I enter the question
    And I post the quick vote
    Then members should be able to vote yes or no
    And results should show in real-time
    And the vote should expire after set time

  @chat-reactions
  Scenario: React with custom emoji
    Given the league has custom emojis
    When I react with a custom emoji
    Then the custom reaction should appear
    And the custom emoji should display properly
    And all users should see the custom emoji

  # --------------------------------------------------------------------------
  # Chat Integrations Scenarios
  # --------------------------------------------------------------------------
  @chat-integrations
  Scenario: View transaction announcements in chat
    Given a trade has been completed
    When the trade is processed
    Then a transaction announcement should appear in chat
    And the announcement should show trade details
    And users should be able to react or comment

  @chat-integrations
  Scenario: Receive score update notifications
    Given games are in progress
    When significant scoring events occur
    Then score updates should appear in chat
    And updates should include player and points
    And affected team owners should be highlighted

  @chat-integrations
  Scenario: See automated matchup updates
    Given matchups are active
    When matchup status changes occur
    Then updates should be posted to chat
    And updates should show current scores
    And lead changes should be highlighted

  @chat-integrations
  Scenario: Receive waiver wire notifications
    Given waiver claims have been processed
    When the waiver period ends
    Then successful claims should be announced
    And announcements should show player and team
    And FAAB amounts should be included if applicable

  @chat-integrations
  Scenario: View lineup change notifications
    Given lineup changes occur close to game time
    When a team makes a last-minute change
    Then a notification should appear in chat
    And the change should show who was swapped
    And the notification should be timely

  @chat-integrations
  Scenario: Integrate with injury updates
    Given a player has an injury status change
    When the injury is reported
    Then an injury update should appear in chat
    And the update should show player and status
    And affected team owners should be alerted

  @chat-integrations
  Scenario: Connect to external news feeds
    Given news feeds are configured
    When relevant fantasy news is published
    Then the news should be shared in chat
    And the news should be properly attributed
    And users should be able to discuss the news

  @chat-integrations
  Scenario: Enable bot notifications
    Given chat bots are available
    When I configure bot preferences
    Then selected bots should post in chat
    And bot messages should be clearly marked
    And I should be able to mute specific bots

  # --------------------------------------------------------------------------
  # Chat Settings Scenarios
  # --------------------------------------------------------------------------
  @chat-settings
  Scenario: Configure notification preferences
    Given I want to customize notifications
    When I access chat notification settings
    And I adjust notification types
    And I save my preferences
    Then only configured notifications should be sent
    And preferences should persist across sessions

  @chat-settings
  Scenario: Set up quiet hours
    Given I don't want notifications at certain times
    When I configure quiet hours
    And I set the time range
    And I save the settings
    Then notifications should be silenced during quiet hours
    And messages should still be delivered
    And I can override for urgent messages

  @chat-settings
  Scenario: Customize chat display settings
    Given I want to personalize the chat appearance
    When I access display settings
    And I adjust font size and theme
    And I configure message density
    And I save my settings
    Then the chat should reflect my preferences
    And settings should persist across devices

  @chat-settings
  Scenario: Configure message preview settings
    Given I want to control message previews
    When I access preview settings
    And I enable or disable previews
    And I set preview length
    Then message previews should follow my settings
    And privacy should be maintained as configured

  @chat-settings
  Scenario: Set up chat shortcuts
    Given I want to use keyboard shortcuts
    When I access shortcut settings
    And I view or customize shortcuts
    Then shortcuts should work as configured
    And I should be able to reset to defaults

  @chat-settings
  Scenario: Configure auto-archive settings
    Given I want conversations auto-archived
    When I set up auto-archive rules
    And I configure the archive threshold
    Then inactive conversations should be archived
    And I should be notified before archival
    And I can restore if needed

  @chat-settings
  Scenario: Manage blocked users
    Given I have blocked users
    When I access blocked user settings
    Then I should see my blocked list
    And I should be able to unblock users
    And blocking should take effect immediately

  @chat-settings
  Scenario: Export chat settings
    Given I want to backup my settings
    When I select "Export Settings"
    Then my chat preferences should be exported
    And I should be able to import later
    And settings should be in a portable format

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle message send failure
    Given I am sending a message
    And the network connection is lost
    When the send fails
    Then I should see an error indicator on the message
    And I should be able to retry sending
    And the message should not be lost

  @error-handling
  Scenario: Handle image upload failure
    Given I am uploading an image
    And the upload fails due to size limits
    When the error occurs
    Then I should see a clear error message
    And I should be told the size limit
    And I should be able to resize and retry

  @error-handling
  Scenario: Handle real-time connection loss
    Given I am in an active chat
    And the real-time connection drops
    When the disconnection is detected
    Then I should see a connection status indicator
    And messages should queue for sending
    And the connection should auto-reconnect

  @error-handling
  Scenario: Handle invalid GIF search
    Given I am searching for a GIF
    And the search service is unavailable
    When the error occurs
    Then I should see a friendly error message
    And I should be able to retry later
    And I should be able to send a text message instead

  @error-handling
  Scenario: Handle chat room at capacity
    Given a chat room has maximum participants
    And I try to join
    When I am denied entry
    Then I should see a capacity message
    And I should be queued if applicable
    And I should be notified when space opens

  @error-handling
  Scenario: Handle blocked user message attempt
    Given I am blocked by another user
    And I try to send them a DM
    When the send is attempted
    Then I should be informed I cannot message them
    And the message should not be delivered
    And the block reason should not be disclosed

  @error-handling
  Scenario: Handle expired poll vote
    Given a poll has ended
    And I try to vote
    When the vote is attempted
    Then I should be told the poll has closed
    And I should see the final results
    And my vote should not be counted

  @error-handling
  Scenario: Handle chat sync conflict
    Given I have the chat open on multiple devices
    And I send messages from both simultaneously
    When the messages arrive
    Then both messages should be properly ordered
    And no messages should be duplicated
    And the sync should resolve gracefully

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate chat with keyboard
    Given I am on the chat page
    When I navigate using only keyboard
    Then all chat features should be accessible
    And focus should move logically
    And I should be able to send messages via keyboard

  @accessibility
  Scenario: Use chat with screen reader
    Given I am using a screen reader
    When I access the chat
    Then all messages should be announced
    And new messages should trigger announcements
    And navigation should be clear and logical

  @accessibility
  Scenario: View chat in high contrast mode
    Given I have high contrast mode enabled
    When I view the chat
    Then all elements should be clearly visible
    And message bubbles should be distinguishable
    And unread indicators should be prominent

  @accessibility
  Scenario: Adjust chat text size
    Given I need larger text
    When I increase text size
    Then chat text should scale appropriately
    And no content should be cut off
    And the layout should remain usable

  @accessibility
  Scenario: Use chat with reduced motion
    Given I have reduced motion preferences
    When I use the chat
    Then animations should be minimized
    And new messages should not animate distractingly
    And the experience should remain fully functional

  @accessibility
  Scenario: Access chat on mobile device
    Given I am using a mobile device
    When I access the chat
    Then all features should be accessible
    And touch targets should be appropriately sized
    And the interface should be responsive

  @accessibility
  Scenario: Receive accessible notifications
    Given I receive a chat notification
    When the notification appears
    Then it should be announced to assistive technology
    And it should be visually prominent
    And it should be dismissible via keyboard

  @accessibility
  Scenario: Use voice input for messages
    Given voice input is supported
    When I use voice to compose a message
    Then my speech should be transcribed
    And I should be able to review before sending
    And voice commands should work for common actions

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load chat quickly
    Given I am accessing the chat
    When the page loads
    Then the chat should be usable within 2 seconds
    And recent messages should appear immediately
    And older messages should load progressively

  @performance
  Scenario: Handle high message volume
    Given the chat is very active
    And many messages are being sent simultaneously
    When new messages arrive
    Then all messages should be displayed in order
    And no messages should be lost
    And the interface should remain responsive

  @performance
  Scenario: Scroll through large history efficiently
    Given the chat has 10,000+ messages
    When I scroll through the history
    Then scrolling should be smooth
    And messages should load on demand
    And memory usage should remain stable

  @performance
  Scenario: Send messages with low latency
    Given I am sending a message
    When I click send
    Then the message should appear within 500ms
    And send confirmation should be immediate
    And the interface should not freeze

  @performance
  Scenario: Load images efficiently
    Given the chat contains many images
    When I scroll through the chat
    Then images should lazy load
    And thumbnails should appear quickly
    And full images should load on demand

  @performance
  Scenario: Handle offline message queuing
    Given I lose network connectivity
    When I compose and send messages
    Then messages should be queued locally
    And I should see pending status
    And messages should send when connection returns

  @performance
  Scenario: Sync across multiple devices
    Given I have chat open on multiple devices
    When I interact with the chat
    Then all devices should sync within 1 second
    And read status should sync
    And no conflicts should occur

  @performance
  Scenario: Search history efficiently
    Given I am searching a large chat history
    When I enter search terms
    Then results should appear within 2 seconds
    And results should be paginated appropriately
    And the search should not block the interface
