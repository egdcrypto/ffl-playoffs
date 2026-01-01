@backend @priority_2 @social
Feature: Social Features System
  As a fantasy football playoffs application
  I want to provide comprehensive social features for user interaction
  So that users can connect, communicate, and engage with the community

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the platform has social features enabled
    And user "john_doe" is authenticated

  # ==================== FRIEND SYSTEM ====================

  Scenario: Send friend request to another user
    Given user "jane_doe" exists on the platform
    And john_doe and jane_doe are not friends
    When john_doe sends a friend request to jane_doe
    Then jane_doe receives a friend request notification
    And the request appears in jane_doe's pending requests
    And john_doe sees the request status as "Pending"

  Scenario: Accept friend request
    Given jane_doe has a pending friend request from john_doe
    When jane_doe accepts the friend request
    Then john_doe and jane_doe become friends
    And john_doe receives a notification that jane_doe accepted
    And both users appear in each other's friends list
    And friendship start date is recorded

  Scenario: Decline friend request
    Given jane_doe has a pending friend request from john_doe
    When jane_doe declines the friend request
    Then the request is removed from pending requests
    And john_doe and jane_doe remain not friends
    And john_doe can send another request after 30 days

  Scenario: Cancel pending friend request
    Given john_doe has a pending friend request to jane_doe
    When john_doe cancels the friend request
    Then the request is removed from jane_doe's pending requests
    And john_doe can send a new request immediately

  Scenario: View friends list
    Given john_doe has multiple friends
    When john_doe views their friends list
    Then the list shows:
      | Friend       | Status    | Friends Since | Mutual Friends |
      | jane_doe     | Online    | 2024-01-15    | 3              |
      | bob_player   | Offline   | 2023-08-20    | 5              |
      | alice_player | Away      | 2024-02-01    | 2              |
    And friends can be sorted by name, status, or date

  Scenario: Remove friend
    Given john_doe and jane_doe are friends
    When john_doe removes jane_doe from friends
    Then jane_doe is removed from john_doe's friends list
    And john_doe is removed from jane_doe's friends list
    And no notification is sent to jane_doe
    And they can become friends again via new request

  Scenario: Block user
    Given john_doe wants to block "spam_user"
    When john_doe blocks spam_user
    Then spam_user cannot:
      | Send friend requests to john_doe    |
      | Send messages to john_doe           |
      | View john_doe's profile             |
      | See john_doe in search results      |
    And john_doe cannot see spam_user's content
    And existing friendship is terminated

  Scenario: Unblock user
    Given john_doe has blocked spam_user
    When john_doe unblocks spam_user
    Then spam_user can interact with john_doe again
    And they are not automatically friends
    And previous messages remain hidden

  Scenario: View mutual friends
    Given john_doe and jane_doe have mutual friends
    When viewing mutual friends between john_doe and jane_doe
    Then mutual friends are displayed:
      | Mutual Friend | Connection Date |
      | bob_player    | 2023-06-15      |
      | alice_player  | 2023-09-20      |
    And suggestions based on mutual friends are shown

  Scenario: Search for friends
    Given john_doe wants to find new friends
    When john_doe searches for users with "player"
    Then search results show:
      | User           | Mutual Friends | In Same League |
      | bob_player     | 3              | Yes            |
      | alice_player   | 2              | Yes            |
      | new_player     | 0              | No             |
    And results are ranked by relevance

  # ==================== SOCIAL PROFILES ====================

  Scenario: View user profile
    Given john_doe has a complete profile
    When another user views john_doe's profile
    Then the profile displays:
      | Section          | Content                           |
      | Display Name     | John Doe                          |
      | Avatar           | Custom profile picture            |
      | Bio              | Fantasy football enthusiast       |
      | Member Since     | January 2023                      |
      | Leagues          | 3 active leagues                  |
      | Achievements     | 5 badges earned                   |
      | Stats            | Championships, win rate           |

  Scenario: Edit profile information
    Given john_doe wants to update their profile
    When john_doe edits their profile with:
      | Field        | New Value                         |
      | Display Name | Johnny D                          |
      | Bio          | 2x League Champion                |
      | Location     | New York, NY                      |
      | Favorite Team| Kansas City Chiefs                |
    Then the profile is updated
    And changes are visible to other users

  Scenario: Upload profile picture
    Given john_doe wants to change their avatar
    When john_doe uploads a new profile picture
    Then the image is validated for:
      | Requirement    | Value            |
      | Max Size       | 5 MB             |
      | Formats        | JPG, PNG, GIF    |
      | Min Dimensions | 100x100 pixels   |
    And the image is resized and optimized
    And the new avatar is displayed

  Scenario: Set profile privacy settings
    Given john_doe wants to control profile visibility
    When john_doe configures privacy settings:
      | Setting              | Value           |
      | Profile Visibility   | Friends Only    |
      | Show Online Status   | Everyone        |
      | Show Statistics      | League Members  |
      | Allow Friend Requests| Everyone        |
    Then privacy settings are applied
    And non-friends see limited profile information

  Scenario: View profile achievements and badges
    Given john_doe has earned achievements
    When viewing john_doe's achievements
    Then achievements display:
      | Badge              | Description               | Earned Date |
      | Champion           | Won a league championship | 2024-01-28  |
      | Streak Master      | 8 consecutive wins        | 2024-01-21  |
      | Draft Expert       | A+ draft grade            | 2024-01-01  |
      | Social Butterfly   | 50 friends                | 2023-12-15  |
    And badges can be showcased on profile

  Scenario: View profile activity history
    Given john_doe has platform activity
    When viewing activity history
    Then recent activity shows:
      | Date       | Activity                              |
      | Today      | Won matchup vs jane_doe (178.5-165.2) |
      | Yesterday  | Made a trade: Mahomes for picks       |
      | 2 days ago | Joined new league "Pro League"        |
      | 3 days ago | Earned "Streak Master" badge          |
    And activity can be filtered by type

  Scenario: Set profile status message
    Given john_doe wants to set a status
    When john_doe sets status to "Looking for a competitive league!"
    Then the status appears on john_doe's profile
    And the status appears in friends' feeds
    And status expires after 7 days if not updated

  # ==================== SOCIAL FEED ====================

  Scenario: View personalized social feed
    Given john_doe has friends and league activity
    When john_doe views their social feed
    Then the feed displays:
      | Type              | Content                            | Time       |
      | Friend Activity   | jane_doe won their matchup         | 2 hours    |
      | League Update     | Trade completed in "Pro League"    | 4 hours    |
      | Achievement       | bob_player earned "Champion" badge | 1 day      |
      | Friend Post       | alice_player shared a meme         | 2 days     |
    And feed is sorted by relevance and recency

  Scenario: Create a post in social feed
    Given john_doe wants to share content
    When john_doe creates a post:
      | Content    | Just won my first championship!    |
      | Visibility | Friends                            |
      | Attachments| Championship trophy image          |
    Then the post appears in john_doe's profile
    And the post appears in friends' feeds
    And friends can interact with the post

  Scenario: Like a post
    Given jane_doe made a post in the feed
    When john_doe likes the post
    Then the like count increases by 1
    And jane_doe receives a notification
    And john_doe's like is recorded

  Scenario: Comment on a post
    Given jane_doe made a post in the feed
    When john_doe comments "Congratulations!"
    Then the comment appears under the post
    And jane_doe receives a notification
    And other users can see and reply to the comment

  Scenario: Share a post
    Given jane_doe made a shareable post
    When john_doe shares the post
    Then the shared post appears in john_doe's feed
    And original author is credited
    And share count is incremented

  Scenario: Delete own post
    Given john_doe created a post
    When john_doe deletes the post
    Then the post is removed from all feeds
    And comments and likes are deleted
    And shares become orphaned with "Post deleted" message

  Scenario: Report inappropriate post
    Given john_doe sees an inappropriate post
    When john_doe reports the post with reason "Offensive content"
    Then the report is submitted for review
    And moderators receive notification
    And john_doe can optionally hide the post

  Scenario: Filter social feed
    Given john_doe wants to filter their feed
    When john_doe applies filters:
      | Filter Type  | Value              |
      | Content Type | Achievements only  |
      | Time Range   | Last 7 days        |
      | Source       | League members     |
    Then only matching content is displayed
    And filter can be saved as preference

  Scenario: Mute user from feed
    Given john_doe doesn't want to see spam_user's posts
    When john_doe mutes spam_user
    Then spam_user's posts don't appear in john_doe's feed
    And they remain friends (if applicable)
    And john_doe can unmute at any time

  # ==================== GROUP CHATS ====================

  Scenario: Create a group chat
    Given john_doe wants to create a group chat
    When john_doe creates a group chat with:
      | Name        | Championship Contenders           |
      | Members     | jane_doe, bob_player, alice_player|
      | Description | Strategy discussion group         |
    Then the group chat is created
    And all members receive an invitation
    And john_doe is set as group admin

  Scenario: Join a group chat via invitation
    Given john_doe received a group chat invitation
    When john_doe accepts the invitation
    Then john_doe joins the group chat
    And john_doe can see message history (configurable)
    And other members are notified

  Scenario: Send message in group chat
    Given john_doe is a member of "Championship Contenders"
    When john_doe sends message "Who should I start at QB?"
    Then the message appears in the group chat
    And all members receive the message
    And message is timestamped and attributed to john_doe

  Scenario: React to group message
    Given jane_doe sent a message in the group
    When john_doe reacts with a thumbs up emoji
    Then the reaction appears on the message
    And reaction count is visible
    And jane_doe is notified of the reaction

  Scenario: Reply to specific message
    Given bob_player asked a question in the group
    When john_doe replies to that specific message
    Then the reply is linked to the original message
    And thread view is available
    And notification mentions the reply context

  Scenario: Leave group chat
    Given john_doe wants to leave a group
    When john_doe leaves "Championship Contenders"
    Then john_doe is removed from the group
    And john_doe cannot see new messages
    And message history remains for other members

  Scenario: Manage group chat settings as admin
    Given john_doe is admin of "Championship Contenders"
    When john_doe updates group settings:
      | Setting           | Value                |
      | Name              | Elite Contenders     |
      | Allow Invites By  | Admins Only          |
      | Message History   | New members can see  |
    Then settings are updated
    And members are notified of changes

  Scenario: Remove member from group chat
    Given john_doe is admin and wants to remove spam_user
    When john_doe removes spam_user from the group
    Then spam_user is removed from the group
    And spam_user cannot rejoin without invitation
    And removal is logged

  Scenario: Promote member to admin
    Given john_doe is admin and wants to promote jane_doe
    When john_doe promotes jane_doe to admin
    Then jane_doe gains admin privileges
    And jane_doe can manage settings and members
    And promotion is announced in the group

  Scenario: Pin important message
    Given john_doe is admin of the group
    When john_doe pins a message "Draft is on Sunday at 7 PM"
    Then the message is pinned at the top of the chat
    And all members can easily find pinned messages
    And multiple messages can be pinned

  # ==================== DIRECT MESSAGING ====================

  Scenario: Send direct message
    Given john_doe wants to message jane_doe
    When john_doe sends "Hey, want to trade?"
    Then jane_doe receives the message
    And jane_doe receives a notification
    And conversation appears in both users' inbox

  Scenario: View conversation history
    Given john_doe has message history with jane_doe
    When john_doe opens the conversation
    Then messages are displayed chronologically
    And read receipts show message status
    And conversation is paginated for long histories

  Scenario: Send message with attachment
    Given john_doe wants to share an image
    When john_doe sends a message with an image attachment
    Then the image is uploaded and displayed inline
    And file size is limited to 10 MB
    And supported formats are validated

  Scenario: Mark messages as read
    Given john_doe has unread messages from jane_doe
    When john_doe opens the conversation
    Then messages are marked as read
    And jane_doe sees read receipts
    And unread count is updated

  Scenario: Search message history
    Given john_doe has extensive message history
    When john_doe searches for "trade proposal"
    Then matching messages are displayed
    And search results show context
    And john_doe can jump to specific message

  Scenario: Delete conversation
    Given john_doe wants to clean up messages
    When john_doe deletes the conversation with jane_doe
    Then the conversation is removed from john_doe's inbox
    And jane_doe still has access to their copy
    And deleted messages cannot be recovered

  Scenario: Block user from messaging
    Given john_doe wants to stop messages from spam_user
    When john_doe blocks spam_user from messaging
    Then spam_user cannot send messages to john_doe
    And existing conversation is archived
    And block status is indicated

  Scenario: Enable do not disturb
    Given john_doe doesn't want message notifications
    When john_doe enables do not disturb for 2 hours
    Then message notifications are silenced
    And messages are still received
    And DND status is visible to others (optional)

  Scenario: Create message request from non-friend
    Given john_doe receives a message from non-friend "new_user"
    When new_user sends a message
    Then the message goes to john_doe's message requests
    And john_doe can accept or decline
    And accepting allows future messages

  # ==================== SOCIAL SHARING ====================

  Scenario: Share matchup result to social feed
    Given john_doe won a matchup
    When john_doe shares the result to their feed
    Then a formatted post is created with:
      | Element        | Content                    |
      | Score          | 178.5 - 165.2              |
      | Opponent       | jane_doe                   |
      | Top Performer  | Mahomes - 35.5 pts         |
      | Image          | Auto-generated graphic     |
    And friends can see and interact with the post

  Scenario: Share to external platforms
    Given john_doe wants to share externally
    When john_doe shares their championship win
    Then sharing options include:
      | Platform   | Format                    |
      | Twitter/X  | Text + image + link       |
      | Facebook   | Rich preview              |
      | Copy Link  | Shareable URL             |
      | Email      | Formatted message         |
    And shared content links back to platform

  Scenario: Generate shareable league invite
    Given john_doe is a league admin
    When john_doe generates a league invite link
    Then a unique invite URL is created
    And the link can be shared anywhere
    And link expiration can be configured
    And usage limits can be set

  Scenario: Share player performance highlight
    Given a player had an exceptional game
    When john_doe shares the performance
    Then highlight includes:
      | Element      | Content                      |
      | Player       | Patrick Mahomes              |
      | Stats        | 385 yds, 4 TDs, 42.5 pts     |
      | Visual       | Stats card graphic           |
    And highlight is formatted for social media

  Scenario: Share draft results
    Given john_doe's draft is complete
    When john_doe shares their draft
    Then draft summary shows:
      | Pick   | Player               |
      | 1.01   | Christian McCaffrey  |
      | 2.12   | Mark Andrews         |
      | 3.01   | Tyreek Hill          |
    And draft grade is included
    And summary can be customized before sharing

  Scenario: Control sharing permissions
    Given john_doe wants to limit sharing of their content
    When john_doe sets sharing preferences:
      | Content Type  | Shareable By        |
      | Scores        | Friends             |
      | Rosters       | League Members      |
      | Achievements  | Everyone            |
    Then sharing options are restricted accordingly
    And unauthorized sharing is prevented

  # ==================== COMMUNITY FORUMS ====================

  Scenario: View forum categories
    Given community forums are available
    When john_doe browses the forums
    Then categories are displayed:
      | Category           | Threads | Last Activity |
      | General Discussion | 1,250   | 5 min ago     |
      | Strategy & Advice  | 890     | 15 min ago    |
      | Trade Talk         | 2,100   | 2 min ago     |
      | League Recruitment | 450     | 30 min ago    |
      | Off-Topic          | 680     | 10 min ago    |

  Scenario: Create a forum thread
    Given john_doe wants to start a discussion
    When john_doe creates a thread:
      | Title    | Best QB for playoffs?              |
      | Category | Strategy & Advice                  |
      | Content  | Who are you targeting for playoffs?|
      | Tags     | QB, playoffs, strategy             |
    Then the thread is created
    And thread appears in the category
    And john_doe can edit the original post

  Scenario: Reply to forum thread
    Given an active thread exists
    When john_doe replies with strategy advice
    Then the reply is posted
    And thread is bumped to top of category
    And thread author is notified
    And reply count is incremented

  Scenario: Upvote helpful content
    Given jane_doe provided helpful advice
    When john_doe upvotes the post
    Then post score increases
    And jane_doe earns reputation points
    And highly upvoted posts are highlighted

  Scenario: Mark thread as solved
    Given john_doe asked a question in their thread
    When john_doe marks bob_player's reply as solution
    Then the thread is marked as "Solved"
    And solution is highlighted at top
    And bob_player earns reputation

  Scenario: Search forum content
    Given extensive forum history exists
    When john_doe searches for "PPR scoring"
    Then relevant threads are displayed
    And search supports filters:
      | Filter     | Options                    |
      | Category   | All or specific            |
      | Date Range | Any, week, month, year     |
      | Solved     | All, solved only           |

  Scenario: Report forum post
    Given john_doe sees rule-breaking content
    When john_doe reports the post
    Then report is submitted with:
      | Reason     | Spam/Harassment/Off-topic  |
      | Details    | Optional explanation       |
    And moderators are notified
    And john_doe can hide the content

  Scenario: Follow forum thread
    Given john_doe is interested in a thread
    When john_doe follows the thread
    Then john_doe receives notifications for new replies
    And thread appears in "Following" list
    And john_doe can unfollow anytime

  Scenario: Create poll in forum
    Given john_doe wants community input
    When john_doe creates a poll:
      | Question  | Best RB for Week 1?        |
      | Options   | CMC, Henry, Barkley, Other |
      | Duration  | 3 days                     |
    Then poll is active for voting
    And results are visible (configurable)
    And poll closes after duration

  # ==================== LEAGUES SOCIAL ====================

  Scenario: View league activity feed
    Given john_doe is a league member
    When john_doe views the league activity feed
    Then activity shows:
      | Time       | Event                              |
      | 1 hour ago | Trade: john_doe sent Mahomes to... |
      | 3 hours ago| jane_doe set new weekly high       |
      | Yesterday  | bob_player added Tank Dell         |
      | 2 days ago | Draft order randomized             |

  Scenario: Post in league message board
    Given the league has a message board
    When john_doe posts "Good luck everyone this week!"
    Then the message appears on the league board
    And all league members can see it
    And notifications are sent (based on settings)

  Scenario: Create league-specific group chat
    Given john_doe is a league admin
    When the league chat is created
    Then all league members are automatically added
    And league chat is linked to the league
    And leaving league removes from chat

  Scenario: Initiate trash talk
    Given john_doe has a matchup vs jane_doe
    When john_doe sends trash talk "Good luck, you'll need it!"
    Then trash talk appears in matchup view
    And jane_doe receives notification
    And trash talk history is preserved

  Scenario: View league standings with social context
    Given the league has standings
    When viewing standings with social features
    Then standings show:
      | Rank | Player     | Record | Social Status        |
      | 1    | john_doe   | 12-2   | "On fire" 🔥         |
      | 2    | jane_doe   | 10-4   | "Plotting comeback"  |
      | 3    | bob_player | 9-5    | "Trade proposals open"|
    And custom status messages are editable

  Scenario: Celebrate league achievements
    Given jane_doe won the championship
    When the championship is finalized
    Then celebration post is auto-generated
    And all league members are notified
    And commemorative badge is awarded
    And hall of fame is updated

  Scenario: Vote on league decisions
    Given commissioner proposes a rule change
    When league voting is initiated
    Then all members can vote:
      | Option           | Votes |
      | Approve change   | 7     |
      | Reject change    | 3     |
      | Abstain          | 2     |
    And results are binding based on league rules

  # ==================== FOLLOW SYSTEM ====================

  Scenario: Follow another user
    Given john_doe wants to follow jane_doe
    When john_doe follows jane_doe
    Then john_doe sees jane_doe's public activity
    And jane_doe is notified (optional)
    And follow relationship is recorded
    And jane_doe's follower count increases

  Scenario: View followers and following lists
    Given john_doe has followers and follows others
    When john_doe views their social connections
    Then lists show:
      | Followers (250) | Following (180)  |
      | jane_doe        | pro_player_1     |
      | bob_player      | fantasy_expert   |
      | alice_player    | league_champion  |
    And mutual follows are indicated

  Scenario: Unfollow user
    Given john_doe follows jane_doe
    When john_doe unfollows jane_doe
    Then john_doe no longer sees jane_doe's activity
    And jane_doe is not notified
    And follower count decreases

  Scenario: Set follow privacy settings
    Given john_doe wants to control who follows them
    When john_doe sets follow settings:
      | Setting               | Value           |
      | Who Can Follow        | Everyone        |
      | Approve Followers     | No              |
      | Show Follower Count   | Yes             |
      | Show Following List   | Friends Only    |
    Then settings are applied
    And privacy is respected

  Scenario: Follow with approval required
    Given jane_doe requires follow approval
    When john_doe requests to follow jane_doe
    Then request goes to pending
    And jane_doe can approve or decline
    And john_doe sees "Requested" status

  Scenario: View activity from followed users
    Given john_doe follows multiple users
    When john_doe views their following feed
    Then feed shows activity from followed users
    And feed is separate from friends feed
    And content is filtered by user preferences

  Scenario: Suggest users to follow
    Given john_doe is looking for users to follow
    When viewing follow suggestions
    Then suggestions include:
      | User           | Reason                    |
      | fantasy_pro    | Popular in your league    |
      | champion_2024  | Top performer last season |
      | friend_of_jane | Followed by your friends  |
    And suggestions are personalized

  # ==================== SOCIAL NOTIFICATIONS ====================

  Scenario: Configure notification preferences
    Given john_doe wants to manage notifications
    When john_doe sets notification preferences:
      | Notification Type   | Email | Push | In-App |
      | Friend Requests     | Yes   | Yes  | Yes    |
      | Messages            | Yes   | Yes  | Yes    |
      | Likes on Posts      | No    | No   | Yes    |
      | Comments            | Yes   | Yes  | Yes    |
      | League Activity     | Yes   | Yes  | Yes    |
      | Forum Replies       | No    | No   | Yes    |
    Then preferences are saved
    And notifications follow settings

  Scenario: View notification center
    Given john_doe has notifications
    When john_doe opens notification center
    Then notifications are displayed:
      | Time       | Type       | Content                        | Read  |
      | 5 min ago  | Message    | jane_doe sent you a message    | No    |
      | 1 hour ago | Like       | bob_player liked your post     | No    |
      | 2 hours ago| Friend     | alice_player accepted request  | Yes   |
    And unread count is shown
    And notifications can be marked as read

  Scenario: Mark all notifications as read
    Given john_doe has multiple unread notifications
    When john_doe marks all as read
    Then all notifications are marked read
    And unread count resets to 0
    And action is logged

  Scenario: Delete notification
    Given john_doe has old notifications
    When john_doe deletes a notification
    Then the notification is removed
    And deletion cannot be undone
    And space is cleared

  Scenario: Receive real-time notifications
    Given john_doe is online
    When jane_doe sends john_doe a message
    Then john_doe receives push notification within seconds
    And in-app notification appears immediately
    And notification badge updates

  Scenario: Batch notification delivery
    Given john_doe has notification batching enabled
    When multiple events occur:
      | Event                          |
      | 3 people liked your post       |
      | 2 new comments on your post    |
    Then notifications are batched:
      | Batch Summary                  |
      | 3 people liked your post       |
      | 2 new comments on your post    |
    And individual details are expandable

  Scenario: Quiet hours for notifications
    Given john_doe sets quiet hours 10 PM - 8 AM
    When a notification is triggered at 11 PM
    Then push notification is held
    And notification is delivered at 8 AM
    And in-app notifications still accumulate

  Scenario: Notification sound and vibration settings
    Given john_doe uses mobile app
    When john_doe configures notification settings:
      | Setting      | Value           |
      | Sound        | Custom tone     |
      | Vibration    | On              |
      | LED Color    | Blue            |
    Then device notifications use these settings
    And different notification types can have different settings

  Scenario: Unsubscribe from specific notification types
    Given john_doe gets too many forum notifications
    When john_doe unsubscribes from forum notifications
    Then no forum notifications are sent
    And other notification types continue
    And preference is remembered

  # ==================== SOCIAL MODERATION ====================

  Scenario: Report user for harassment
    Given john_doe experiences harassment from spam_user
    When john_doe reports spam_user:
      | Reason     | Harassment                    |
      | Evidence   | Message screenshots           |
      | Details    | Repeated unwanted messages    |
    Then report is submitted
    And moderation team is notified
    And john_doe can block spam_user

  Scenario: Appeal moderation action
    Given john_doe received a warning
    When john_doe appeals the decision
    Then appeal is submitted with:
      | Original Action | Warning for inappropriate post |
      | Appeal Reason   | Context was misunderstood      |
    And moderation team reviews appeal
    And decision is communicated

  Scenario: View community guidelines
    Given users need to understand rules
    When john_doe views community guidelines
    Then guidelines display:
      | Section              | Summary                        |
      | Respectful Conduct   | Be kind and constructive       |
      | Content Standards    | No spam, hate, or illegal content |
      | Privacy              | Respect others' privacy        |
      | Consequences         | Warnings, suspensions, bans    |
    And guidelines are easily accessible

  Scenario: Moderator reviews reported content
    Given a moderator is reviewing reports
    When moderator reviews a reported post
    Then moderator can:
      | Action              | Result                         |
      | Dismiss             | No action, report closed       |
      | Warn                | Warning sent to user           |
      | Remove Content      | Post/comment deleted           |
      | Suspend User        | Temporary account suspension   |
      | Ban User            | Permanent account ban          |
    And action is logged for audit
