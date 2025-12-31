@backend @priority_1 @social
Feature: Social Platform
  As a fantasy football playoffs application
  I want to provide comprehensive social features including feeds, sharing, friends, following, profiles, comments, reactions, mentions, groups, leaderboards, and notifications
  So that users can engage with each other and build a vibrant community around their playoff experience

  Background:
    Given a registered user "john_doe" exists with verified email
    And user "john_doe" has an active social profile
    And the social platform is operational

  # ==================== SOCIAL FEED ====================

  Scenario: Display personalized social feed for a user
    Given user "john_doe" follows 5 other users
    And user "john_doe" is a member of 2 social groups
    When john_doe opens their social feed
    Then the feed displays posts from followed users
    And the feed displays posts from joined groups
    And posts are ordered by relevance and recency
    And the feed shows a mix of activity types

  Scenario: Load social feed with infinite scroll pagination
    Given user "john_doe" has a feed with 100+ posts available
    When john_doe loads the initial feed
    Then the first 20 posts are displayed
    When john_doe scrolls to the bottom
    Then the next 20 posts are loaded automatically
    And loading indicator is shown during fetch

  Scenario: Filter social feed by content type
    Given user "john_doe" has various content types in their feed
    When john_doe filters the feed by "Roster Updates"
    Then only roster update posts are displayed
    When john_doe filters by "Matchup Results"
    Then only matchup result posts are displayed
    When john_doe clears all filters
    Then all content types are displayed again

  Scenario: Display trending topics in social feed
    Given multiple users are discussing playoff matchups
    When john_doe views the feed sidebar
    Then trending topics are displayed with post counts:
      | Topic               | Posts |
      | #WildCardWeekend    | 245   |
      | #MahomesVsAllen     | 189   |
      | #PlayoffUpset       | 156   |
    And clicking a trending topic filters the feed

  Scenario: Hide post from social feed
    Given john_doe sees a post from "spammy_user" in their feed
    When john_doe selects "Hide this post"
    Then the post is removed from john_doe's feed
    And an option to "Undo" is briefly shown
    And the post remains visible to other users

  Scenario: Report inappropriate content in feed
    Given john_doe sees an offensive post in their feed
    When john_doe selects "Report post"
    And john_doe chooses reason "Harassment"
    And john_doe submits the report
    Then the report is recorded with the content and reason
    And the post is hidden from john_doe's feed
    And a confirmation message is displayed

  Scenario: Refresh social feed to see new posts
    Given john_doe has their feed open
    And 5 new posts were created after initial load
    When john_doe pulls down to refresh
    Then the new posts appear at the top of the feed
    And a count of new posts is displayed temporarily

  # ==================== SOCIAL SHARING ====================

  Scenario: Share roster selection to social feed
    Given john_doe has locked their roster for Wild Card round
    When john_doe clicks "Share Roster"
    And john_doe adds caption "Ready for Wild Card weekend!"
    And john_doe submits the share
    Then a post is created showing the roster positions and players
    And the post appears in followers' feeds
    And the post includes john_doe's username and timestamp

  Scenario: Share matchup result after winning
    Given john_doe won their Wild Card matchup against "bob_player"
    When the system generates a shareable matchup result
    Then john_doe can share the result showing:
      | Winner Score  | 152.3        |
      | Loser Score   | 138.7        |
      | Margin        | 13.6 points  |
    And the shared post includes a visual bracket snippet

  Scenario: Share achievement badge to social platforms
    Given john_doe earned the "Upset Master" badge
    When john_doe clicks "Share Achievement"
    And john_doe selects sharing to "Social Feed"
    Then a celebratory post is created with badge image
    And the post describes how the badge was earned

  Scenario: Share post to external platforms
    Given john_doe created a post about their championship run
    When john_doe clicks "Share externally"
    Then options are displayed for:
      | Platform   |
      | Twitter/X  |
      | Facebook   |
      | Copy Link  |
    When john_doe selects "Twitter/X"
    Then a shareable link is generated
    And the Twitter share dialog opens with pre-filled text

  Scenario: Control who can see shared content
    Given john_doe is composing a new post
    When john_doe selects visibility options
    Then the following options are available:
      | Visibility      | Description                     |
      | Public          | Anyone can see                  |
      | Followers Only  | Only followers can see          |
      | Friends Only    | Only mutual connections can see |
      | Private         | Only john_doe can see           |
    When john_doe selects "Followers Only"
    Then the post visibility is set to followers only

  Scenario: Share weekly performance summary
    Given john_doe completed Divisional round with score 165.5
    When the weekly summary is generated
    Then john_doe can share a summary showing:
      | Metric                 | Value        |
      | Total Score            | 165.5        |
      | Rank This Week         | 5th          |
      | Top Performer          | Patrick Mahomes |
      | Top Performer Score    | 32.5         |

  Scenario: Prevent sharing of private league content
    Given john_doe is in a private league "Secret Champions"
    And the league has sharing restrictions enabled
    When john_doe attempts to share matchup details publicly
    Then the share is blocked with message "This league restricts public sharing"
    And john_doe can only share within the league

  # ==================== FRIEND SYSTEM ====================

  Scenario: Send friend request to another user
    Given user "jane_doe" exists and is not connected to john_doe
    When john_doe sends a friend request to jane_doe
    Then a pending friend request is created
    And jane_doe receives a notification about the request
    And john_doe sees "Friend Request Sent" status on jane_doe's profile

  Scenario: Accept incoming friend request
    Given jane_doe sent a friend request to john_doe
    When john_doe views their pending requests
    Then the request from jane_doe is displayed
    When john_doe accepts the request
    Then john_doe and jane_doe become mutual friends
    And jane_doe receives a notification that request was accepted
    And both users appear in each other's friend lists

  Scenario: Decline incoming friend request
    Given "spammy_user" sent a friend request to john_doe
    When john_doe declines the request
    Then the request is removed from pending
    And "spammy_user" is not notified of the decline
    And "spammy_user" can send another request after 30 days

  Scenario: Cancel outgoing friend request
    Given john_doe sent a friend request to "bob_player" that is pending
    When john_doe cancels the friend request
    Then the pending request is deleted
    And bob_player no longer sees the request
    And john_doe can send a new request immediately

  Scenario: View friend list with online status
    Given john_doe has 10 friends
    And 3 friends are currently online
    When john_doe views their friend list
    Then all 10 friends are displayed
    And online friends are shown with active indicator
    And friends are sorted by online status then alphabetically

  Scenario: Unfriend an existing friend
    Given john_doe and jane_doe are mutual friends
    When john_doe unfriends jane_doe
    Then they are no longer mutual friends
    And jane_doe is removed from john_doe's friend list
    And john_doe is removed from jane_doe's friend list
    And jane_doe is not notified of the unfriending

  Scenario: Block a user from sending friend requests
    Given john_doe is receiving unwanted requests from "harasser"
    When john_doe blocks "harasser"
    Then "harasser" cannot send friend requests to john_doe
    And "harasser" cannot view john_doe's profile
    And "harasser" cannot see john_doe's posts
    And any existing connection is severed

  Scenario: Search for friends by username or email
    Given multiple users exist in the system
    When john_doe searches for "jane"
    Then users matching "jane" are displayed:
      | Username    | Display Name | Mutual Friends |
      | jane_doe    | Jane Doe     | 3              |
      | jane_smith  | Jane Smith   | 0              |
    And results show existing connection status

  Scenario: Import friends from contacts
    Given john_doe grants contact access permission
    When john_doe imports contacts
    Then the system matches contacts to registered users
    And john_doe sees a list of contacts who are on the platform
    And john_doe can send bulk friend requests to selected contacts

  Scenario: View mutual friends between users
    Given john_doe is viewing bob_player's profile
    And they share 5 mutual friends
    When john_doe clicks "Mutual Friends"
    Then a list of 5 mutual friends is displayed
    And each mutual friend shows their profile summary

  # ==================== FOLLOWING SYSTEM ====================

  Scenario: Follow another user without mutual requirement
    Given user "celebrity_player" exists with public profile
    When john_doe follows celebrity_player
    Then john_doe is added to celebrity_player's followers
    And celebrity_player's posts appear in john_doe's feed
    And celebrity_player does not automatically follow john_doe back

  Scenario: Unfollow a user
    Given john_doe follows jane_doe
    When john_doe unfollows jane_doe
    Then john_doe is removed from jane_doe's followers
    And jane_doe's posts no longer appear in john_doe's feed
    And jane_doe is not notified of the unfollow

  Scenario: View follower and following counts
    Given john_doe has 150 followers and follows 75 users
    When visiting john_doe's profile
    Then the profile displays:
      | Metric     | Count |
      | Followers  | 150   |
      | Following  | 75    |
    And clicking either count shows the list

  Scenario: Approve followers for private account
    Given john_doe has a private account
    When jane_doe requests to follow john_doe
    Then the request appears in john_doe's pending followers
    When john_doe approves the request
    Then jane_doe becomes a follower
    And jane_doe can now see john_doe's posts

  Scenario: Deny follow request for private account
    Given john_doe has a private account
    And "unwanted_follower" requested to follow john_doe
    When john_doe denies the request
    Then the request is removed
    And "unwanted_follower" cannot see john_doe's posts

  Scenario: View list of followers
    Given john_doe has 50 followers
    When john_doe views their followers list
    Then followers are displayed with:
      | Username | Since Date | Mutual Status |
    And john_doe can follow back from this list
    And john_doe can remove followers from this list

  Scenario: Remove a follower
    Given "annoying_user" follows john_doe
    When john_doe removes "annoying_user" from followers
    Then "annoying_user" no longer follows john_doe
    And "annoying_user" is not notified of the removal
    And "annoying_user" can follow again unless blocked

  Scenario: Get suggested users to follow
    Given john_doe has following activity and preferences
    When john_doe views "Suggested Users"
    Then the system suggests users based on:
      | Criteria                          |
      | Mutual connections                |
      | Similar league participation      |
      | Popular users in same leagues     |
      | Users with similar roster choices |
    And each suggestion shows reason for suggestion

  Scenario: Toggle between public and private following
    Given john_doe's following list is public
    When john_doe sets following list to private
    Then only john_doe can see who they follow
    And the following count is still visible publicly

  # ==================== SOCIAL PROFILES ====================

  Scenario: Create social profile with basic information
    Given a new user "new_player" registers
    When new_player sets up their social profile with:
      | Field         | Value                    |
      | Display Name  | New Player               |
      | Bio           | Fantasy football fanatic |
      | Location      | New York, NY             |
      | Favorite Team | Giants                   |
    Then the profile is created with provided information
    And profile is publicly visible by default

  Scenario: Upload and update profile picture
    Given john_doe has a default profile picture
    When john_doe uploads a new profile picture
    Then the image is validated for size and format
    And the image is resized to standard dimensions
    And the new picture replaces the default
    And previous profile pictures are retained in history

  Scenario: View user profile with statistics
    Given user "jane_doe" has participated in multiple seasons
    When john_doe views jane_doe's profile
    Then the profile displays:
      | Section         | Content                          |
      | Basic Info      | Display name, bio, location      |
      | Statistics      | Win rate, championships, badges  |
      | Recent Activity | Latest posts and interactions    |
      | Achievements    | Earned badges and milestones     |

  Scenario: Display fantasy performance on profile
    Given jane_doe has playoff history
    When viewing jane_doe's profile statistics
    Then performance is shown:
      | Metric                    | Value    |
      | Playoff Appearances       | 5        |
      | Championship Wins         | 2        |
      | Total Playoff Points      | 2,450.5  |
      | Best Single Week Score    | 185.3    |
      | Current Season Rank       | 3rd      |

  Scenario: Set profile visibility to private
    Given john_doe has a public profile
    When john_doe sets profile visibility to private
    Then only friends can view john_doe's full profile
    And non-friends see limited information:
      | Visible           | Hidden                 |
      | Display Name      | Bio                    |
      | Profile Picture   | Statistics             |
      | Friend Request    | Recent Activity        |

  Scenario: Verify profile with email confirmation
    Given john_doe wants to verify their profile
    When john_doe requests verification
    Then a verification badge request is submitted
    And admin reviews the profile for authenticity
    When verification is approved
    Then a verified badge appears on john_doe's profile

  Scenario: Link external accounts to profile
    Given john_doe wants to link social accounts
    When john_doe connects their Twitter account
    Then the Twitter handle is displayed on profile
    And john_doe can share directly to Twitter
    When john_doe connects their ESPN Fantasy account
    Then fantasy history can be imported

  Scenario: Customize profile theme and layout
    Given john_doe has profile customization options
    When john_doe selects a team-themed profile layout
    And john_doe chooses "Kansas City Chiefs" theme
    Then the profile displays with Chiefs colors and styling
    And the customization is saved to john_doe's preferences

  Scenario: View profile visit history
    Given john_doe has profile analytics enabled
    When john_doe views their profile insights
    Then they see:
      | Metric                | Value    |
      | Profile Views (Week)  | 45       |
      | Profile Views (Month) | 180      |
      | Top Visitors          | hidden   |

  # ==================== COMMENTS AND REACTIONS ====================

  Scenario: Add comment to a post
    Given jane_doe shared a post about her roster
    When john_doe adds comment "Great picks!"
    Then the comment appears under jane_doe's post
    And jane_doe receives a notification about the comment
    And the comment shows john_doe's username and timestamp

  Scenario: Reply to an existing comment
    Given bob_player commented on jane_doe's post
    When john_doe replies to bob_player's comment
    Then the reply is nested under bob_player's comment
    And bob_player receives a notification about the reply
    And the thread is collapsible

  Scenario: Add reaction to a post
    Given jane_doe shared a victory post
    When john_doe reacts with "Celebrate" emoji
    Then the reaction count increases on the post
    And jane_doe receives a notification about the reaction
    And john_doe's reaction is visible on the post

  Scenario: View all reactions on a post
    Given a post has received 50 reactions
    When john_doe clicks on the reaction count
    Then a breakdown of reactions is shown:
      | Reaction  | Count | Sample Users          |
      | Like      | 30    | jane_doe, bob_player  |
      | Celebrate | 15    | alice_player          |
      | Laugh     | 5     | player5               |
    And john_doe can see full list of reactors

  Scenario: Remove own reaction from a post
    Given john_doe previously reacted to a post
    When john_doe clicks their reaction again
    Then john_doe's reaction is removed
    And the reaction count decreases by one
    And no notification is sent for removal

  Scenario: Edit own comment
    Given john_doe posted a comment with a typo
    When john_doe edits the comment within 5 minutes
    Then the comment is updated with new text
    And an "edited" indicator is shown
    And the original timestamp is preserved

  Scenario: Delete own comment
    Given john_doe has a comment on jane_doe's post
    When john_doe deletes their comment
    Then the comment is removed from the post
    And replies to the comment are also removed
    And comment count decreases

  Scenario: Post author can delete any comment on their post
    Given john_doe has a post with comments
    And "troll_user" left an inappropriate comment
    When john_doe deletes troll_user's comment
    Then the comment is removed from the post
    And john_doe can optionally block troll_user

  Scenario: Display comment count on posts
    Given a post has 25 comments
    When viewing the post in the feed
    Then comment count shows "25 comments"
    And clicking expands to show comments
    And initially only top comments are loaded

  Scenario: Sort comments by different criteria
    Given a post has 50 comments
    When john_doe views comments sorted by "Top"
    Then comments are ordered by reaction count
    When john_doe sorts by "Newest"
    Then comments are ordered by timestamp descending
    When john_doe sorts by "Oldest"
    Then comments are ordered by timestamp ascending

  # ==================== USER MENTIONS ====================

  Scenario: Mention a user in a post
    Given john_doe is creating a new post
    When john_doe types "@jane_doe"
    Then a suggestion dropdown shows matching users
    When john_doe selects "jane_doe"
    Then the mention is formatted as a link
    And jane_doe will receive a notification when posted

  Scenario: Receive notification when mentioned
    Given john_doe posted "Great game @jane_doe!"
    Then jane_doe receives a mention notification
    And the notification shows the post preview
    And clicking the notification navigates to the post

  Scenario: Mention user in a comment
    Given john_doe is commenting on a post
    When john_doe types "@bob_player check this out"
    Then bob_player receives a mention notification
    And the notification indicates it's in a comment

  Scenario: View all posts where user is mentioned
    Given jane_doe has been mentioned in 20 posts
    When jane_doe views their "Mentions" tab
    Then all posts mentioning jane_doe are displayed
    And posts are sorted by recency
    And each shows the mention context

  Scenario: Control who can mention you
    Given john_doe is receiving unwanted mentions
    When john_doe updates mention settings to "Friends Only"
    Then only friends can mention john_doe
    And non-friends see an error when trying to mention john_doe

  Scenario: Mention multiple users in one post
    Given john_doe is creating a post
    When john_doe mentions "@jane_doe @bob_player @alice_player"
    Then all three users are properly linked
    And all three receive separate notifications
    And the post displays all mentions correctly

  Scenario: Prevent mention of blocked users
    Given john_doe has blocked "blocked_user"
    When john_doe types "@blocked_user"
    Then blocked_user does not appear in suggestions
    And if typed manually, the mention is not linked

  Scenario: Autocomplete mention suggestions
    Given john_doe types "@ja" in a post
    Then suggestions show:
      | Username     | Display Name | Relation    |
      | jane_doe     | Jane Doe     | Friend      |
      | james_player | James P      | Following   |
      | jack_smith   | Jack Smith   | Same League |
    And friends appear first in suggestions

  # ==================== SOCIAL GROUPS ====================

  Scenario: Create a new social group
    Given john_doe wants to create a discussion group
    When john_doe creates a group with:
      | Field       | Value                     |
      | Name        | Chiefs Kingdom Fans       |
      | Description | For all Chiefs fans       |
      | Privacy     | Public                    |
      | Category    | Team Fans                 |
    Then the group is created with john_doe as admin
    And the group is discoverable in search

  Scenario: Join a public group
    Given "Eagles Nation" is a public group
    When john_doe clicks "Join Group"
    Then john_doe becomes a member immediately
    And group posts appear in john_doe's feed
    And john_doe can post in the group

  Scenario: Request to join a private group
    Given "VIP Champions Club" is a private group
    When john_doe requests to join
    Then a join request is sent to group admins
    And john_doe sees "Request Pending" status
    When group admin approves the request
    Then john_doe becomes a member

  Scenario: Post content to a group
    Given john_doe is a member of "Fantasy Experts" group
    When john_doe creates a post in the group
    Then the post is visible to all group members
    And the post appears in members' feeds with group tag
    And non-members cannot see the post

  Scenario: Leave a group
    Given john_doe is a member of "Casual Players" group
    When john_doe leaves the group
    Then john_doe is removed from member list
    And group posts no longer appear in john_doe's feed
    And john_doe can rejoin at any time

  Scenario: Manage group as admin
    Given john_doe is admin of "Chiefs Kingdom Fans"
    When john_doe views admin settings
    Then john_doe can:
      | Action                        |
      | Approve/deny member requests  |
      | Remove members                |
      | Promote members to moderator  |
      | Edit group settings           |
      | Delete inappropriate posts    |

  Scenario: Invite users to join a group
    Given john_doe is a member of "Strategy Experts" group
    When john_doe invites jane_doe to the group
    Then jane_doe receives a group invitation notification
    And jane_doe can accept or decline the invitation

  Scenario: Search for groups to join
    Given multiple groups exist in the system
    When john_doe searches for groups with "fantasy"
    Then matching groups are displayed:
      | Name               | Members | Privacy |
      | Fantasy Experts    | 1,250   | Public  |
      | Fantasy Beginners  | 850     | Public  |
    And results show member count and description

  Scenario: Create group event
    Given john_doe is admin of "Local League" group
    When john_doe creates an event:
      | Field     | Value                    |
      | Title     | Draft Party              |
      | Date      | 2025-09-05               |
      | Location  | Sports Bar Downtown      |
    Then the event is visible to group members
    And members can RSVP to the event

  Scenario: View group activity feed
    Given john_doe is viewing "Chiefs Kingdom Fans" group
    When john_doe opens the group
    Then the group feed shows:
      | Recent posts from members        |
      | Pinned announcements at top      |
      | Member join notifications        |
      | Upcoming group events            |

  # ==================== LEADERBOARDS SOCIAL ====================

  Scenario: View weekly social leaderboard
    Given Wild Card round is complete
    When john_doe views the weekly leaderboard
    Then the leaderboard displays:
      | Rank | Player       | Score  | Change |
      | 1    | jane_doe     | 175.5  | +2     |
      | 2    | john_doe     | 165.3  | -1     |
      | 3    | bob_player   | 158.7  | +5     |
    And rank change indicates movement from previous week

  Scenario: View season-long leaderboard
    Given multiple playoff rounds have completed
    When john_doe views the season leaderboard
    Then cumulative scores are shown:
      | Rank | Player       | Total   | Rounds |
      | 1    | alice_player | 485.5   | 3      |
      | 2    | jane_doe     | 472.3   | 3      |
      | 3    | john_doe     | 468.1   | 3      |
    And eliminated players are marked

  Scenario: Share leaderboard position to social feed
    Given john_doe is ranked 3rd on the leaderboard
    When john_doe clicks "Share Position"
    Then a shareable post is created showing:
      | Rank           | 3rd                |
      | Total Score    | 468.1              |
      | League         | FFL Playoffs 2025  |

  Scenario: Filter leaderboard by league
    Given john_doe is in multiple leagues
    When john_doe filters leaderboard by "Work League"
    Then only players from "Work League" are shown
    And john_doe's rank within that league is displayed

  Scenario: View friends-only leaderboard
    Given john_doe has 20 friends participating in playoffs
    When john_doe views "Friends Leaderboard"
    Then only friends' scores are displayed
    And john_doe can easily compare against friends

  Scenario: Celebrate reaching leaderboard milestone
    Given john_doe moves into top 10 on the leaderboard
    Then an automatic achievement is triggered
    And john_doe can share the milestone
    And the milestone appears on john_doe's profile

  Scenario: View leaderboard with position breakdown
    Given john_doe views detailed leaderboard
    When john_doe expands a player's entry
    Then position-by-position scores are shown:
      | Position | Player           | Points |
      | QB       | Patrick Mahomes  | 32.5   |
      | RB       | Derrick Henry    | 24.0   |
      | WR       | Tyreek Hill      | 28.5   |

  Scenario: Compare leaderboard position with specific user
    Given john_doe and jane_doe are both on leaderboard
    When john_doe selects "Compare with jane_doe"
    Then a side-by-side comparison shows:
      | Metric              | john_doe | jane_doe |
      | Total Score         | 468.1    | 472.3    |
      | Best Week           | 165.3    | 175.5    |
      | Win-Loss            | 3-0      | 3-0      |

  Scenario: Display leaderboard movement animations
    Given john_doe is viewing live leaderboard during games
    When scores update and rankings change
    Then animated rank changes are displayed
    And john_doe sees their position move up or down
    And sound notification plays for significant changes

  # ==================== SOCIAL NOTIFICATIONS ====================

  Scenario: Receive notification for new follower
    Given jane_doe follows john_doe
    Then john_doe receives a notification:
      | Type    | new_follower              |
      | Message | jane_doe started following you |
      | Action  | View Profile              |

  Scenario: Receive notification for friend request
    Given bob_player sends friend request to john_doe
    Then john_doe receives a notification:
      | Type    | friend_request                        |
      | Message | bob_player wants to be your friend    |
      | Actions | Accept, Decline                       |

  Scenario: Receive notification for post reaction
    Given john_doe's post received a reaction from jane_doe
    Then john_doe receives a notification:
      | Type    | post_reaction                   |
      | Message | jane_doe liked your post        |
      | Action  | View Post                       |

  Scenario: Receive notification for comment on post
    Given bob_player comments on john_doe's post
    Then john_doe receives a notification:
      | Type    | comment                              |
      | Message | bob_player commented on your post    |
      | Preview | First 50 characters of comment       |
      | Action  | View Comment                         |

  Scenario: Receive notification for mention
    Given jane_doe mentions john_doe in a post
    Then john_doe receives a notification:
      | Type    | mention                           |
      | Message | jane_doe mentioned you in a post  |
      | Action  | View Post                         |

  Scenario: Receive notification for matchup result
    Given john_doe's matchup completed with a win
    Then john_doe receives a notification:
      | Type    | matchup_result                          |
      | Message | You won your matchup against bob_player |
      | Score   | 152.3 - 138.7                           |
      | Action  | Share Result                            |

  Scenario: Aggregate multiple similar notifications
    Given john_doe's post received 25 reactions in 5 minutes
    Then notifications are aggregated:
      | Message | jane_doe and 24 others liked your post |
    And clicking expands to show all reactors

  Scenario: Configure notification preferences
    Given john_doe wants to customize notifications
    When john_doe updates notification settings:
      | Notification Type   | Push | Email | In-App |
      | Friend Requests     | Yes  | Yes   | Yes    |
      | Post Reactions      | No   | No    | Yes    |
      | Comments            | Yes  | No    | Yes    |
      | Mentions            | Yes  | Yes   | Yes    |
      | Matchup Results     | Yes  | Yes   | Yes    |
    Then notifications are delivered according to preferences

  Scenario: Mark notifications as read
    Given john_doe has 15 unread notifications
    When john_doe views the notification list
    Then notifications are marked as read automatically
    And the unread count decreases to 0
    And previously viewed notifications show "read" status

  Scenario: Mark all notifications as read
    Given john_doe has 50 unread notifications
    When john_doe clicks "Mark All as Read"
    Then all notifications are marked as read
    And the notification badge clears

  Scenario: Enable quiet hours for notifications
    Given john_doe sets quiet hours from 10 PM to 7 AM
    Then push notifications are silenced during quiet hours
    And in-app notifications are still recorded
    And notifications are delivered after quiet hours end

  Scenario: Receive notification for group activity
    Given john_doe is a member of "Chiefs Kingdom Fans"
    When a new post is made in the group
    Then john_doe receives a notification:
      | Type    | group_activity                         |
      | Message | New post in Chiefs Kingdom Fans        |
      | Action  | View Group                             |

  Scenario: Delete individual notifications
    Given john_doe has a notification they want to remove
    When john_doe deletes the notification
    Then the notification is removed from the list
    And the notification cannot be recovered

  Scenario: Filter notifications by type
    Given john_doe has 100 notifications of various types
    When john_doe filters by "Mentions"
    Then only mention notifications are displayed
    When john_doe filters by "Friend Requests"
    Then only friend request notifications are displayed

  Scenario: Receive real-time notifications
    Given john_doe has the app open
    When jane_doe follows john_doe
    Then the notification appears instantly without refresh
    And the notification count updates in real-time
    And an optional sound plays for new notifications

  # ==================== ERROR HANDLING ====================

  Scenario: Handle network error when loading feed
    Given john_doe's network connection is unstable
    When john_doe tries to load the social feed
    And the request times out
    Then an error message is displayed: "Unable to load feed"
    And a "Retry" button is shown
    And cached content is displayed if available

  Scenario: Handle error when sending friend request
    Given john_doe tries to send a friend request
    And the target user has reached maximum friends
    Then an error is displayed: "This user cannot accept more friend requests"
    And the request is not sent

  Scenario: Handle rate limiting for social actions
    Given john_doe is performing rapid social actions
    When john_doe exceeds 100 actions per minute
    Then further actions are temporarily blocked
    And an error message shows: "Please slow down. Try again in 60 seconds"

  Scenario: Handle content length limits
    Given john_doe is creating a post
    When john_doe exceeds the 500 character limit
    Then the remaining character count shows negative
    And the submit button is disabled
    And a message shows: "Post exceeds maximum length"

  Scenario: Handle blocked user interactions
    Given john_doe has blocked jane_doe
    When jane_doe tries to view john_doe's profile
    Then jane_doe sees: "This profile is not available"
    And no user information is displayed
