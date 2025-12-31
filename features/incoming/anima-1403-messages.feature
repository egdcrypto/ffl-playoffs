@messages @anima-1403
Feature: Messages
  As a fantasy football user
  I want comprehensive messaging capabilities
  So that I can communicate with other league members

  Background:
    Given I am a logged-in user
    And the messaging system is available

  # ============================================================================
  # MESSAGE INBOX
  # ============================================================================

  @happy-path @message-inbox
  Scenario: View messages
    Given I have messages
    When I view messages
    Then I should see my messages
    And they should be organized

  @happy-path @message-inbox
  Scenario: View inbox
    Given inbox contains messages
    When I view inbox
    Then I should see all inbox messages
    And unread should be highlighted

  @happy-path @message-inbox
  Scenario: View unread messages
    Given I have unread messages
    When I view unread
    Then I should see only unread messages
    And count should match

  @happy-path @message-inbox
  Scenario: View message list
    Given messages exist
    When I view list
    Then I should see message list
    And sender and subject should be shown

  @happy-path @message-inbox
  Scenario: View message threads
    Given threads exist
    When I view threads
    Then I should see conversation threads
    And replies should be grouped

  @happy-path @message-inbox
  Scenario: Mark message as read
    Given unread message exists
    When I open message
    Then message should be marked read
    And unread count should decrease

  @happy-path @message-inbox
  Scenario: Mark message as unread
    Given read message exists
    When I mark as unread
    Then message should be marked unread
    And unread count should increase

  @happy-path @message-inbox
  Scenario: Star important message
    Given message exists
    When I star message
    Then message should be starred
    And I can filter starred

  @happy-path @message-inbox
  Scenario: Sort inbox messages
    Given multiple messages exist
    When I sort messages
    Then messages should be sorted
    And order should match selection

  @happy-path @message-inbox
  Scenario: Refresh inbox
    Given inbox may have new messages
    When I refresh inbox
    Then inbox should update
    And new messages should appear

  # ============================================================================
  # MESSAGE COMPOSE
  # ============================================================================

  @happy-path @message-compose
  Scenario: Compose message
    Given I want to send message
    When I compose message
    Then compose window should open
    And I can write message

  @happy-path @message-compose
  Scenario: Send new message
    Given I have composed message
    When I send message
    Then message should be sent
    And recipient should receive it

  @happy-path @message-compose
  Scenario: Reply to message
    Given I received message
    When I reply to message
    Then reply should be sent
    And it should be in thread

  @happy-path @message-compose
  Scenario: Forward message
    Given message exists
    When I forward message
    Then message should be forwarded
    And original content should be included

  @happy-path @message-compose
  Scenario: Save draft message
    Given I am composing message
    When I save as draft
    Then draft should be saved
    And I can continue later

  @happy-path @message-compose
  Scenario: Edit draft message
    Given draft exists
    When I edit draft
    Then I can modify draft
    And changes should be saved

  @happy-path @message-compose
  Scenario: Delete draft message
    Given draft exists
    When I delete draft
    Then draft should be removed
    And I should confirm first

  @happy-path @message-compose
  Scenario: Reply all to message
    Given group message exists
    When I reply all
    Then reply should go to all recipients
    And everyone should receive it

  @happy-path @message-compose
  Scenario: Add subject to message
    Given I am composing
    When I add subject
    Then subject should be saved
    And it should display in inbox

  @happy-path @message-compose
  Scenario: Format message text
    Given I am composing
    When I format text
    Then formatting should apply
    And recipient should see it

  # ============================================================================
  # MESSAGE RECIPIENTS
  # ============================================================================

  @happy-path @message-recipients
  Scenario: Select recipients
    Given I am composing
    When I select recipients
    Then recipients should be added
    And I can add multiple

  @happy-path @message-recipients
  Scenario: Message league members
    Given league members exist
    When I select league members
    Then they should be added as recipients
    And I can see their names

  @happy-path @message-recipients
  Scenario: Message team owners
    Given team owners exist
    When I select team owners
    Then they should be added as recipients
    And teams should be shown

  @happy-path @message-recipients
  Scenario: Send group message
    Given I want to message group
    When I create group message
    Then message should go to all
    And everyone should receive it

  @happy-path @message-recipients
  Scenario: Send broadcast message
    Given I have broadcast permission
    When I send broadcast
    Then message should go to everyone
    And all league members should receive it

  @happy-path @message-recipients
  Scenario: Search for recipient
    Given many members exist
    When I search for recipient
    Then matching members should appear
    And I can select them

  @happy-path @message-recipients
  Scenario: View recipient suggestions
    Given I am selecting recipients
    When I start typing
    Then suggestions should appear
    And I can choose from list

  @happy-path @message-recipients
  Scenario: Remove recipient
    Given recipients are selected
    When I remove recipient
    Then recipient should be removed
    And message should update

  @happy-path @message-recipients
  Scenario: Add CC recipients
    Given I am composing
    When I add CC
    Then CC recipients should be added
    And they should receive copy

  @happy-path @message-recipients
  Scenario: Create recipient group
    Given I message same people often
    When I create group
    Then group should be saved
    And I can reuse it

  # ============================================================================
  # MESSAGE SEARCH
  # ============================================================================

  @happy-path @message-search
  Scenario: Search messages
    Given messages exist
    When I search messages
    Then I should find matching results
    And search should be fast

  @happy-path @message-search
  Scenario: Filter by sender
    Given messages from multiple senders
    When I filter by sender
    Then I should see only that sender's messages
    And others should be hidden

  @happy-path @message-search
  Scenario: Filter by date
    Given messages from various dates
    When I filter by date
    Then I should see date range
    And only matching should show

  @happy-path @message-search
  Scenario: Filter by keyword
    Given messages contain keywords
    When I filter by keyword
    Then I should see matching messages
    And keyword should be highlighted

  @happy-path @message-search
  Scenario: Use advanced search
    Given advanced options exist
    When I use advanced search
    Then I should see detailed options
    And results should match criteria

  @happy-path @message-search
  Scenario: Search within thread
    Given thread exists
    When I search in thread
    Then I should find matching messages
    And context should be shown

  @happy-path @message-search
  Scenario: Save search filters
    Given I have useful filters
    When I save filters
    Then filters should be saved
    And I can reuse later

  @happy-path @message-search
  Scenario: Clear search
    Given search is active
    When I clear search
    Then search should reset
    And all messages should show

  @happy-path @message-search
  Scenario: Search attachments
    Given attachments exist
    When I search attachments
    Then I should find messages with attachments
    And file names should be searchable

  @happy-path @message-search
  Scenario: View recent searches
    Given I have searched before
    When I view recent
    Then I should see recent searches
    And I can reuse them

  # ============================================================================
  # MESSAGE NOTIFICATIONS
  # ============================================================================

  @happy-path @message-notifications
  Scenario: Receive message alert
    Given alerts are enabled
    When new message arrives
    Then I should receive alert
    And sender should be shown

  @happy-path @message-notifications
  Scenario: Receive new message notification
    Given notifications are enabled
    When message is received
    Then I should be notified
    And I can open message

  @happy-path @message-notifications
  Scenario: Receive reply notification
    Given I sent message
    When reply is received
    Then I should be notified
    And I can view reply

  @happy-path @message-notifications
  Scenario: Receive mention alert
    Given I am mentioned
    When mention occurs
    Then I should receive alert
    And context should be shown

  @happy-path @message-notifications
  Scenario: Receive push notification
    Given push is enabled
    When message arrives
    Then I should receive push
    And it should be timely

  @happy-path @message-notifications
  Scenario: Configure notification sound
    Given sounds are available
    When I configure sound
    Then sound should be saved
    And it should play on notification

  @happy-path @message-notifications
  Scenario: Mute notifications temporarily
    Given I need quiet time
    When I mute notifications
    Then notifications should pause
    And they should resume later

  @happy-path @message-notifications
  Scenario: View notification badge
    Given unread messages exist
    When I view app
    Then badge should show count
    And it should update

  @happy-path @message-notifications
  Scenario: Disable message notifications
    Given I receive too many
    When I disable notifications
    Then notifications should stop
    And I can re-enable later

  @happy-path @message-notifications
  Scenario: Set quiet hours
    Given I don't want night alerts
    When I set quiet hours
    Then notifications should pause during hours
    And they should resume after

  # ============================================================================
  # MESSAGE THREADS
  # ============================================================================

  @happy-path @message-threads
  Scenario: View conversation threads
    Given conversations exist
    When I view threads
    Then I should see grouped conversations
    And they should be organized

  @happy-path @message-threads
  Scenario: View message history
    Given history exists
    When I view history
    Then I should see full conversation
    And all messages should be shown

  @happy-path @message-threads
  Scenario: View thread view
    Given thread exists
    When I view thread
    Then messages should be threaded
    And replies should be nested

  @happy-path @message-threads
  Scenario: View reply chain
    Given replies exist
    When I view reply chain
    Then I should see all replies
    And order should be chronological

  @happy-path @message-threads
  Scenario: View grouped messages
    Given messages are related
    When I view grouped
    Then related messages should be together
    And context should be clear

  @happy-path @message-threads
  Scenario: Collapse thread
    Given thread is expanded
    When I collapse thread
    Then thread should collapse
    And I can expand again

  @happy-path @message-threads
  Scenario: Expand thread
    Given thread is collapsed
    When I expand thread
    Then all messages should show
    And I can read full conversation

  @happy-path @message-threads
  Scenario: Navigate thread
    Given thread has many messages
    When I navigate thread
    Then I can move through messages
    And navigation should be easy

  @happy-path @message-threads
  Scenario: View thread participants
    Given thread exists
    When I view participants
    Then I should see all participants
    And their roles should be shown

  @happy-path @message-threads
  Scenario: Leave thread
    Given I am in thread
    When I leave thread
    Then I should be removed
    And I won't receive updates

  # ============================================================================
  # MESSAGE ATTACHMENTS
  # ============================================================================

  @happy-path @message-attachments
  Scenario: Attach files
    Given I am composing
    When I attach file
    Then file should be attached
    And recipient can download

  @happy-path @message-attachments
  Scenario: Attach images
    Given I am composing
    When I attach image
    Then image should be attached
    And preview should be shown

  @happy-path @message-attachments
  Scenario: Share links
    Given I want to share link
    When I add link
    Then link should be included
    And preview should be shown

  @happy-path @message-attachments
  Scenario: Embed content
    Given content is embeddable
    When I embed content
    Then content should be embedded
    And it should display inline

  @happy-path @message-attachments
  Scenario: Upload files
    Given I have files to upload
    When I upload files
    Then files should be uploaded
    And progress should be shown

  @happy-path @message-attachments
  Scenario: Download attachment
    Given attachment exists
    When I download attachment
    Then file should be downloaded
    And it should be complete

  @happy-path @message-attachments
  Scenario: Preview attachment
    Given attachment is previewable
    When I preview attachment
    Then preview should display
    And I can open full version

  @happy-path @message-attachments
  Scenario: Remove attachment
    Given attachment is added
    When I remove attachment
    Then attachment should be removed
    And message should update

  @error @message-attachments
  Scenario: Handle file size limit
    Given file is too large
    When I try to attach
    Then I should see error
    And size limit should be explained

  @happy-path @message-attachments
  Scenario: View all attachments
    Given messages have attachments
    When I view all attachments
    Then I should see all files
    And I can filter by type

  # ============================================================================
  # MESSAGE SETTINGS
  # ============================================================================

  @happy-path @message-settings
  Scenario: Configure notification preferences
    Given preferences exist
    When I configure notifications
    Then preferences should be saved
    And notifications should follow them

  @happy-path @message-settings
  Scenario: Configure message privacy
    Given privacy options exist
    When I configure privacy
    Then settings should be saved
    And privacy should be enforced

  @happy-path @message-settings
  Scenario: Block user
    Given I want to block someone
    When I block user
    Then user should be blocked
    And their messages should be hidden

  @happy-path @message-settings
  Scenario: Mute conversation
    Given conversation is noisy
    When I mute conversation
    Then notifications should stop
    And I can unmute later

  @happy-path @message-settings
  Scenario: Set auto-reply
    Given I will be away
    When I set auto-reply
    Then auto-reply should be saved
    And senders should receive it

  @happy-path @message-settings
  Scenario: Unblock user
    Given user is blocked
    When I unblock user
    Then user should be unblocked
    And their messages should appear

  @happy-path @message-settings
  Scenario: Configure read receipts
    Given read receipts are available
    When I configure receipts
    Then setting should be saved
    And it should apply to messages

  @happy-path @message-settings
  Scenario: Set message signature
    Given I want signature
    When I set signature
    Then signature should be saved
    And it should appear on messages

  @happy-path @message-settings
  Scenario: Configure message display
    Given display options exist
    When I configure display
    Then settings should be saved
    And messages should reflect them

  @happy-path @message-settings
  Scenario: Reset message settings
    Given I have custom settings
    When I reset settings
    Then defaults should be restored
    And I should confirm first

  # ============================================================================
  # MESSAGE ARCHIVE
  # ============================================================================

  @happy-path @message-archive
  Scenario: Archive messages
    Given messages should be archived
    When I archive messages
    Then messages should be archived
    And they should be removed from inbox

  @happy-path @message-archive
  Scenario: Delete messages
    Given messages should be deleted
    When I delete messages
    Then messages should be deleted
    And I should confirm first

  @happy-path @message-archive
  Scenario: View trash
    Given deleted messages exist
    When I view trash
    Then I should see deleted messages
    And I can restore them

  @happy-path @message-archive
  Scenario: Backup messages
    Given I want to backup
    When I backup messages
    Then backup should be created
    And I can download it

  @happy-path @message-archive
  Scenario: Restore messages
    Given messages are in trash
    When I restore messages
    Then messages should be restored
    And they should appear in inbox

  @happy-path @message-archive
  Scenario: View archived messages
    Given archived messages exist
    When I view archive
    Then I should see archived messages
    And I can unarchive them

  @happy-path @message-archive
  Scenario: Unarchive message
    Given message is archived
    When I unarchive message
    Then message should be restored to inbox
    And it should be accessible

  @happy-path @message-archive
  Scenario: Empty trash
    Given trash has messages
    When I empty trash
    Then trash should be emptied
    And messages should be permanently deleted

  @happy-path @message-archive
  Scenario: Auto-delete old messages
    Given auto-delete is configured
    When threshold is reached
    Then old messages should be deleted
    And I should be notified

  @happy-path @message-archive
  Scenario: Export messages
    Given messages exist
    When I export messages
    Then export file should be created
    And I can download it

  # ============================================================================
  # MESSAGE TEMPLATES
  # ============================================================================

  @happy-path @message-templates
  Scenario: Use saved templates
    Given templates exist
    When I use template
    Then template should be inserted
    And I can customize it

  @happy-path @message-templates
  Scenario: Use quick replies
    Given quick replies exist
    When I use quick reply
    Then reply should be inserted
    And I can send quickly

  @happy-path @message-templates
  Scenario: Use canned responses
    Given canned responses exist
    When I use canned response
    Then response should be inserted
    And I can modify if needed

  @happy-path @message-templates
  Scenario: Use message shortcuts
    Given shortcuts exist
    When I use shortcut
    Then text should be inserted
    And it should save time

  @happy-path @message-templates
  Scenario: Create signature
    Given I want signature
    When I create signature
    Then signature should be saved
    And it should auto-append

  @happy-path @message-templates
  Scenario: Create new template
    Given I have common message
    When I create template
    Then template should be saved
    And I can reuse it

  @happy-path @message-templates
  Scenario: Edit template
    Given template exists
    When I edit template
    Then changes should be saved
    And template should update

  @happy-path @message-templates
  Scenario: Delete template
    Given template exists
    When I delete template
    Then template should be removed
    And I should confirm first

  @happy-path @message-templates
  Scenario: Organize templates
    Given multiple templates exist
    When I organize templates
    Then templates should be organized
    And I can find them easily

  @happy-path @message-templates
  Scenario: Share template
    Given template exists
    When I share template
    Then template should be shared
    And others can use it

