@ANIMA-1415 @backend @priority_2 @profile
Feature: User Profile System
  As a fantasy football playoffs platform user
  I want to manage my profile, view my stats, and connect with other users
  So that I can personalize my experience and track my performance

  Background:
    Given a user "john_doe" is authenticated
    And the user has an active account
    And profile features are enabled

  # ==================== PROFILE OVERVIEW ====================

  Scenario: View user profile
    Given the user navigates to their profile
    When the profile page loads
    Then the user sees their profile information:
      | Field           | Content                        |
      | Display Name    | John Doe                       |
      | Username        | @john_doe                      |
      | Member Since    | January 2024                   |
      | Profile Picture | User's avatar or default       |
      | Bio             | User's bio text                |
      | Location        | User's location if set         |
    And navigation options are available

  Scenario: Access profile dashboard
    Given the user is on their profile
    When the profile dashboard loads
    Then the dashboard displays key metrics:
      | Widget              | Content                         |
      | Quick Stats         | W-L record, total points        |
      | Active Leagues      | Count of current leagues        |
      | Recent Activity     | Last 5 actions                  |
      | Upcoming Matchups   | Next scheduled matchups         |
      | Achievements        | Recent badges earned            |
    And widgets are interactive and expandable

  Scenario: View profile summary
    Given another user views "john_doe" profile
    When the public profile loads
    Then the summary shows:
      | Section             | Visibility                      |
      | Display Name        | Always visible                  |
      | Username            | Always visible                  |
      | Bio                 | Based on privacy settings       |
      | Stats               | Based on privacy settings       |
      | Achievements        | Based on privacy settings       |
      | Teams               | Based on privacy settings       |
    And privacy-restricted content shows appropriate message

  Scenario: View account info
    Given the user accesses account information
    When the account info section loads
    Then the user sees:
      | Field               | Value                           |
      | Email               | j***@example.com (masked)       |
      | Phone               | ***-***-1234 (masked)           |
      | Account Type        | Premium / Free                  |
      | Account Status      | Active                          |
      | Email Verified      | Yes / No                        |
      | Two-Factor Auth     | Enabled / Disabled              |
    And sensitive data is partially masked

  Scenario: Check profile status
    Given the user views their profile status
    When the status section loads
    Then the status displays:
      | Status Type         | Current State                   |
      | Account Status      | Active                          |
      | Profile Completeness| 85%                             |
      | Verification Status | Verified                        |
      | Standing            | Good                            |
      | Last Login          | 2 hours ago                     |
      | Session Status      | Active on 2 devices             |
    And recommendations for improving profile are shown

  # ==================== PROFILE SETTINGS ====================

  Scenario: Edit profile information
    Given the user clicks "Edit Profile"
    When the edit form loads
    Then the user can modify:
      | Field             | Type           | Validation              |
      | Display Name      | Text           | 2-50 characters         |
      | Bio               | Textarea       | Max 500 characters      |
      | Location          | Text           | Optional                |
      | Website           | URL            | Valid URL format        |
      | Date of Birth     | Date picker    | Must be 13+ years old   |
      | Timezone          | Dropdown       | Valid timezone          |
    And changes require confirmation before saving

  Scenario: Update account information
    Given the user wants to update account info
    When the user modifies their email address
    Then the system:
      | Step                | Action                          |
      | Validate format     | Check email is valid            |
      | Check uniqueness    | Ensure email not already used   |
      | Send verification   | Email confirmation link sent    |
      | Pending status      | Show email pending verification |
    And old email remains active until new one is verified

  Scenario: Configure profile preferences
    Given the user accesses preferences
    When the preferences panel loads
    Then the user can configure:
      | Preference          | Options                         |
      | Language            | English, Spanish, French, etc.  |
      | Date Format         | MM/DD/YYYY, DD/MM/YYYY, etc.   |
      | Time Format         | 12-hour, 24-hour                |
      | Theme               | Light, Dark, System default     |
      | Notifications       | Email, Push, In-app             |
      | Default League View | List, Grid, Compact             |
    And preferences are saved immediately

  Scenario: Manage account settings
    Given the user accesses account settings
    When the settings page loads
    Then the user can manage:
      | Setting             | Options                         |
      | Change Password     | Current + New password          |
      | Two-Factor Auth     | Enable/Disable, Setup           |
      | Connected Accounts  | Google, Apple, Facebook links   |
      | Session Management  | View/revoke active sessions     |
      | Account Export      | Download all account data       |
      | Delete Account      | Permanent account deletion      |
    And critical actions require password confirmation

  Scenario: Configure privacy settings
    Given the user accesses privacy settings
    When the privacy panel loads
    Then the user can control:
      | Setting                 | Options                       |
      | Profile Visibility      | Public, Friends Only, Private |
      | Show Online Status      | Everyone, Friends, Nobody     |
      | Show Stats              | Everyone, Friends, Nobody     |
      | Show Teams              | Everyone, Friends, Nobody     |
      | Show Activity           | Everyone, Friends, Nobody     |
      | Allow Friend Requests   | Everyone, Friends of Friends, Nobody |
      | Searchable Profile      | Yes, No                       |
    And privacy changes take effect immediately

  # ==================== PROFILE AVATAR ====================

  Scenario: Upload profile picture
    Given the user wants to update their avatar
    When the user clicks on the avatar area
    Then upload options are displayed:
      | Option              | Description                     |
      | Upload Photo        | Select from device              |
      | Take Photo          | Use camera (mobile)             |
      | Choose Avatar       | Select from gallery             |
      | Remove Photo        | Revert to default               |
    And supported formats are JPG, PNG, GIF (max 5MB)

  Scenario: Crop and adjust avatar
    Given the user has selected an image for upload
    When the image editor loads
    Then the user can:
      | Action              | Description                     |
      | Crop                | Adjust to square or circle      |
      | Zoom                | Scale image in/out              |
      | Rotate              | Rotate 90 degrees               |
      | Apply Filters       | Basic brightness/contrast       |
      | Preview             | See how avatar will appear      |
    And changes are previewed in real-time

  Scenario: Customize avatar appearance
    Given the user prefers a generated avatar
    When the user accesses avatar customization
    Then customization options include:
      | Element             | Options                         |
      | Style               | Initials, Geometric, Cartoon    |
      | Background Color    | Color picker or presets         |
      | Border Style        | None, Circle, Rounded           |
      | Frame               | League trophies, badges         |
      | Animation           | Static, Animated (premium)      |
    And customized avatar is generated instantly

  Scenario: View profile image history
    Given the user wants to see previous avatars
    When the user accesses image history
    Then the system displays:
      | Avatar              | Date Set        | Actions         |
      | Current avatar      | 2025-01-15      | Active          |
      | Previous avatar 1   | 2024-12-01      | Restore, Delete |
      | Previous avatar 2   | 2024-08-15      | Restore, Delete |
    And the user can restore any previous avatar

  Scenario: Select from avatar gallery
    Given the user wants a pre-made avatar
    When the user browses the avatar gallery
    Then the gallery displays categories:
      | Category            | Avatars Available               |
      | NFL Teams           | All 32 team logos               |
      | Fantasy Football    | Themed fantasy avatars          |
      | Sports              | General sports icons            |
      | Achievements        | Unlockable achievement avatars  |
      | Seasonal            | Holiday/event themed            |
    And locked avatars show unlock requirements

  # ==================== PROFILE STATS ====================

  Scenario: View user statistics
    Given the user accesses their stats page
    When the stats load
    Then comprehensive statistics are displayed:
      | Stat Category       | Metrics                         |
      | Overall Record      | Wins, Losses, Win %             |
      | Total Points        | Career points scored            |
      | Average Score       | Points per matchup              |
      | Best Week           | Highest single-week score       |
      | Championships       | Titles won                      |
      | Playoffs Made       | Playoff appearances             |
    And stats can be filtered by season or all-time

  Scenario: View performance history
    Given the user wants to see historical performance
    When the performance history loads
    Then the display shows:
      | Season    | Leagues | Record | Points   | Best Finish | Worst Finish |
      | 2025      | 3       | 25-8   | 4,250.5  | 1st         | 4th          |
      | 2024      | 2       | 18-10  | 3,125.2  | 2nd         | 6th          |
      | 2023      | 2       | 15-13  | 2,890.0  | 3rd         | 8th          |
    And trends are visualized with charts
    And each season is expandable for details

  Scenario: View win/loss record breakdown
    Given the user wants detailed W-L analysis
    When the record breakdown loads
    Then the breakdown shows:
      | Category                | Record   | Win %    |
      | Overall                 | 58-31    | 65.2%    |
      | Regular Season          | 48-27    | 64.0%    |
      | Playoffs                | 10-4     | 71.4%    |
      | Championship Games      | 3-1      | 75.0%    |
      | vs Top 5 Players        | 12-8     | 60.0%    |
      | Home                    | 30-14    | 68.2%    |
      | Away                    | 28-17    | 62.2%    |
    And head-to-head records are accessible

  Scenario: View all-time statistics
    Given the user views career all-time stats
    When all-time stats load
    Then the display shows:
      | Milestone               | Value           | Rank         |
      | Total Matchups Played   | 89              | -            |
      | Career Points           | 13,265.7        | Top 5%       |
      | Career TDs Scored       | 312             | Top 10%      |
      | Longest Win Streak      | 8               | Personal Best|
      | Most Points (Single)    | 198.5           | League Record|
      | Perfect Weeks           | 2               | -            |
    And comparisons to league averages are shown

  Scenario: View achievements and milestones
    Given the user accesses achievements section
    When achievements load
    Then the display organizes by category:
      | Category            | Achievements Earned / Total     |
      | Scoring             | 8 / 15                          |
      | Winning             | 5 / 10                          |
      | Championships       | 3 / 8                           |
      | Participation       | 10 / 12                         |
      | Social              | 4 / 10                          |
    And each achievement shows progress and unlock date

  # ==================== PROFILE TEAMS ====================

  Scenario: View my teams
    Given the user accesses "My Teams" section
    When the teams page loads
    Then active teams are displayed:
      | Team Name           | League              | Status    | Record |
      | Doe's Dominators    | FFL Championship    | Active    | 8-2    |
      | John's All-Stars    | Office Pool 2025    | Active    | 6-4    |
      | The Dynasty         | Dynasty League Pro  | Active    | 10-0   |
    And each team links to detailed team page

  Scenario: View team history
    Given the user wants to see past teams
    When team history loads
    Then historical teams are displayed:
      | Team Name           | League              | Season | Final Record | Finish |
      | Championship Squad  | FFL Pro League      | 2024   | 12-3         | 1st    |
      | Rookie Risers       | Beginner League     | 2023   | 8-7          | 5th    |
      | Trial Team          | Demo League         | 2023   | 5-10         | 10th   |
    And archived leagues are expandable for details

  Scenario: Manage active teams
    Given the user is on active teams page
    When viewing team management options
    Then the user can:
      | Action              | Description                     |
      | Edit Team Name      | Change display name             |
      | Update Team Logo    | Change team avatar              |
      | View Roster         | See current roster              |
      | Leave League        | Exit from league (if allowed)   |
      | Team Settings       | Manage team-specific settings   |
    And actions are context-aware per league rules

  Scenario: View past team details
    Given the user selects a past team
    When the past team details load
    Then the display shows:
      | Section             | Content                         |
      | Final Standing      | Position and record             |
      | Season Stats        | Points, average, best week      |
      | Final Roster        | End-of-season lineup            |
      | Playoff Results     | Bracket performance             |
      | Memorable Moments   | Highlights from the season      |
    And stats are preserved permanently

  Scenario: View team memberships
    Given the user has multiple team associations
    When memberships are displayed
    Then the list shows:
      | Team                | Role         | League Type   | Since      |
      | Doe's Dominators    | Owner        | Head-to-Head  | 2024-08-01 |
      | Office Pool Team    | Co-Manager   | Points Only   | 2024-09-15 |
      | Dynasty Squad       | Manager      | Dynasty       | 2023-01-01 |
    And role-based permissions are indicated

  # ==================== PROFILE LEAGUES ====================

  Scenario: View my leagues
    Given the user accesses "My Leagues" section
    When the leagues page loads
    Then active leagues are displayed:
      | League Name         | Type            | Players | My Standing | Status   |
      | FFL Championship    | Head-to-Head    | 12      | 2nd         | Active   |
      | Office Pool 2025    | Points Only     | 20      | 5th         | Active   |
      | Dynasty League Pro  | Dynasty         | 10      | 1st         | Active   |
    And quick actions are available per league

  Scenario: View league history
    Given the user wants to see past leagues
    When league history loads
    Then the display shows:
      | League Name         | Type            | Season | My Finish | Champion       |
      | FFL Pro 2024        | Head-to-Head    | 2024   | 1st       | john_doe (me)  |
      | Summer League       | Points Only     | 2024   | 3rd       | jane_doe       |
      | Winter Challenge    | Playoffs Only   | 2023   | 8th       | bob_player     |
    And leagues are searchable and filterable

  Scenario: Access active league details
    Given the user selects an active league
    When league details load
    Then the display shows:
      | Section             | Content                         |
      | League Overview     | Name, type, commissioner        |
      | Current Standings   | All teams ranked                |
      | My Team             | Quick link to team management   |
      | Recent Activity     | Last 10 league events           |
      | Upcoming Matchups   | Next week's schedule            |
      | League Settings     | Rules and configuration         |
    And league-specific actions are available

  Scenario: View past league details
    Given the user selects a past league
    When past league details load
    Then the archived data shows:
      | Section             | Content                         |
      | Final Standings     | All teams final positions       |
      | My Performance      | Season summary for user         |
      | Champion            | League winner details           |
      | Awards              | Season award recipients         |
      | Notable Stats       | League records and highlights   |
    And data is read-only

  Scenario: Manage league memberships
    Given the user views league memberships
    When membership management loads
    Then the user can:
      | Action                  | Availability                  |
      | View League Details     | All leagues                   |
      | Leave League            | If allowed by league rules    |
      | Change Team Name        | Active leagues only           |
      | Notification Settings   | Per-league customization      |
      | Export Data             | Download league history       |
    And confirmation required for irreversible actions

  # ==================== PROFILE ACTIVITY ====================

  Scenario: View activity feed
    Given the user accesses their activity feed
    When the feed loads
    Then recent activities are displayed:
      | Time          | Activity                                    |
      | 2 hours ago   | Made roster move: Added K. Allen            |
      | 5 hours ago   | Won matchup vs jane_doe (145.5 - 132.0)     |
      | 1 day ago     | Joined league "Office Pool 2025"            |
      | 2 days ago    | Earned badge "Hot Streak" (5 wins in a row) |
      | 3 days ago    | Updated team name to "Doe's Dominators"     |
    And activities are paginated with infinite scroll

  Scenario: Filter recent activity
    Given the user wants to filter activities
    When filter options are applied
    Then activities can be filtered by:
      | Filter Type         | Options                         |
      | Activity Type       | Roster, Matchups, Social, Admin |
      | League              | Specific league or all          |
      | Date Range          | Last 7 days, 30 days, custom    |
      | Result              | Wins only, Losses only, All     |
    And filters can be combined

  Scenario: View detailed activity log
    Given the user wants comprehensive activity history
    When the activity log loads
    Then the log displays:
      | Date/Time       | Type        | Description              | Details        |
      | 2025-01-20 14:30| Roster      | Dropped T. Hill          | Injury concern |
      | 2025-01-20 14:31| Roster      | Added J. Waddle          | Week 3 start   |
      | 2025-01-20 18:00| Score       | Score updated: +12.5 pts | Live game      |
      | 2025-01-20 23:15| Matchup     | Matchup finalized: WIN   | 145.5 - 138.2  |
    And log entries can be exported

  Scenario: Track user actions
    Given the admin views user action tracking
    When action history loads
    Then tracked actions include:
      | Action Type         | Count (30 days)   | Trend         |
      | Roster Changes      | 24                | +15%          |
      | Logins              | 45                | Stable        |
      | Profile Views       | 12                | +8%           |
      | Report Generation   | 5                 | New           |
      | Settings Changes    | 3                 | -20%          |
    And action patterns are analyzed

  Scenario: View activity history summary
    Given the user views activity summary
    When the summary loads
    Then aggregated stats show:
      | Period          | Roster Moves | Matchups | Badges Earned | Leagues Joined |
      | This Week       | 3            | 1        | 1             | 0              |
      | This Month      | 12           | 4        | 2             | 1              |
      | This Season     | 45           | 14       | 8             | 2              |
      | All Time        | 234          | 89       | 35            | 12             |
    And trends are visualized

  # ==================== PROFILE BADGES ====================

  Scenario: View earned badges
    Given the user accesses their badges
    When the badges page loads
    Then earned badges are displayed:
      | Badge Name          | Category    | Earned Date  | Rarity      |
      | First Victory       | Winning     | 2023-09-15   | Common      |
      | Perfect Week        | Scoring     | 2024-11-20   | Rare        |
      | Dynasty Builder     | Longevity   | 2025-01-01   | Epic        |
      | League Champion     | Achievement | 2024-12-22   | Legendary   |
    And badges show detailed descriptions on hover

  Scenario: Track achievement progress
    Given the user views achievement progress
    When progress tracking loads
    Then in-progress achievements show:
      | Achievement         | Progress    | Requirement         | Reward         |
      | Score 10,000 pts    | 8,500/10K   | Career points       | Gold Badge     |
      | Win 50 Matchups     | 42/50       | Total wins          | Silver Badge   |
      | Join 10 Leagues     | 7/10        | League memberships  | Bronze Badge   |
      | 10 Game Win Streak  | 6/10        | Consecutive wins    | Epic Badge     |
    And estimated completion is shown

  Scenario: View milestone achievements
    Given the user accesses milestones
    When milestones load
    Then career milestones display:
      | Milestone               | Achieved    | Date         |
      | First League Joined     | Yes         | 2023-08-01   |
      | First Win               | Yes         | 2023-09-08   |
      | First Playoff           | Yes         | 2023-12-15   |
      | First Championship      | Yes         | 2024-12-22   |
      | 5 Championships         | No          | -            |
    And unlocked milestones show celebration animation

  Scenario: View awards received
    Given the user views their awards
    When awards section loads
    Then awards are displayed:
      | Award                   | League              | Season | Type        |
      | League Champion         | FFL Pro League      | 2024   | Championship|
      | Highest Scorer          | Office Pool         | 2024   | Season      |
      | Most Improved           | Dynasty League      | 2024   | Special     |
      | Comeback King           | FFL Championship    | 2023   | Playoff     |
    And awards can be featured on profile

  Scenario: Customize badge showcase
    Given the user wants to feature badges
    When badge showcase settings load
    Then the user can:
      | Action                  | Description                     |
      | Select Featured Badges  | Choose up to 5 to display       |
      | Arrange Order           | Drag to reorder featured badges |
      | Show/Hide All Badges    | Toggle full badge visibility    |
      | Set Primary Badge       | Badge shown next to username    |
    And showcase updates in real-time

  # ==================== PROFILE PRIVACY ====================

  Scenario: Configure privacy controls
    Given the user accesses privacy controls
    When the privacy panel loads
    Then granular controls are available:
      | Privacy Setting         | Options                         |
      | Profile Visibility      | Public, Private, Custom         |
      | Stats Visibility        | Everyone, Friends, Hidden       |
      | Activity Visibility     | Everyone, Friends, Hidden       |
      | Team Visibility         | Everyone, Friends, Hidden       |
      | Search Visibility       | Searchable, Not Searchable      |
    And changes take effect immediately

  Scenario: Set visibility settings
    Given the user configures visibility
    When custom visibility is selected
    Then the user can set per-section:
      | Section                 | Visibility Level                |
      | Basic Profile           | Public                          |
      | Bio and Details         | Friends Only                    |
      | Stats and Records       | Friends Only                    |
      | League Memberships      | Private                         |
      | Activity Feed           | Private                         |
      | Badge Showcase          | Public                          |
    And preview shows how profile appears to others

  Scenario: Toggle public/private profile
    Given the user has a public profile
    When the user switches to private
    Then the system:
      | Updates profile visibility to private     |
      | Removes profile from search results       |
      | Shows confirmation of changes             |
      | Notifies about impact on discoverability  |
    And existing friends retain access

  Scenario: Manage data sharing
    Given the user reviews data sharing settings
    When data sharing options load
    Then the user can control:
      | Data Type               | Sharing Options                 |
      | Performance Stats       | Share with leagues, Keep private|
      | Activity Data           | Share, Anonymize, Don't share   |
      | Profile Information     | Full, Limited, None             |
      | Analytics Participation | Opt-in, Opt-out                 |
    And data usage explanation is provided

  Scenario: Block other users
    Given the user wants to block another user
    When the user accesses block settings
    Then blocking options include:
      | Action                  | Effect                          |
      | Block User              | No interaction, hidden profile  |
      | Mute User               | Hide activity, allow leagues    |
      | Report User             | Flag for admin review           |
      | Unblock User            | Restore normal interaction      |
    And blocked users list is manageable
    And blocked user cannot see blocker's profile

  # ==================== PROFILE CONNECTIONS ====================

  Scenario: Manage friends list
    Given the user accesses friends section
    When friends list loads
    Then the display shows:
      | Friend              | Status      | Mutual Leagues | Since      |
      | jane_doe            | Online      | 2              | 2023-08-15 |
      | bob_player          | Offline     | 1              | 2024-01-20 |
      | alice_player        | Away        | 3              | 2024-06-10 |
    And friend actions are available:
      | View Profile | Message | Remove Friend | Block |

  Scenario: View followers
    Given the user has followers
    When followers list loads
    Then followers are displayed:
      | Follower            | Following Since | Mutual       | Actions       |
      | sports_fan_42       | 2024-09-01      | No           | Follow Back   |
      | fantasy_king        | 2024-10-15      | Yes          | View Profile  |
      | newbie_player       | 2025-01-05      | No           | Follow Back   |
    And follow-back option is prominent

  Scenario: View following list
    Given the user follows other users
    When following list loads
    Then followed users show:
      | User                | Category      | Since          | Actions       |
      | pro_analyst         | Expert        | 2024-06-01     | Unfollow      |
      | league_champion_21  | Competitor    | 2024-08-20     | Unfollow      |
      | fantasy_tips        | Content       | 2024-11-10     | Unfollow      |
    And notification settings per followed user available

  Scenario: Manage connections
    Given the user manages connections
    When connections panel loads
    Then connection management includes:
      | Action                  | Description                     |
      | Send Friend Request     | Request to connect              |
      | Accept Request          | Approve pending request         |
      | Decline Request         | Reject pending request          |
      | Remove Connection       | End friendship                  |
      | View Pending            | See outgoing requests           |
    And mutual connections are highlighted

  Scenario: Link social accounts
    Given the user wants to add social links
    When social links section loads
    Then available integrations include:
      | Platform            | Status          | Actions               |
      | Twitter/X           | Not Connected   | Connect               |
      | Discord             | Connected       | Disconnect, Update    |
      | Facebook            | Not Connected   | Connect               |
      | Instagram           | Connected       | Disconnect, Update    |
    And connected accounts show on public profile
    And privacy controls per platform available

  # ==================== FRIEND REQUESTS ====================

  Scenario: Send friend request
    Given the user views another user's profile
    When the user clicks "Add Friend"
    Then the system:
      | Sends friend request to target user        |
      | Shows pending status on profile            |
      | Creates notification for target user       |
      | Allows cancellation before acceptance      |
    And request includes optional message

  Scenario: Respond to friend request
    Given the user has pending friend requests
    When the user views requests
    Then for each request the user can:
      | Action              | Result                          |
      | Accept              | Add to friends, notify sender   |
      | Decline             | Remove request silently         |
      | View Profile        | See requester's public profile  |
      | Block               | Block user and decline          |
    And bulk actions are available for multiple requests

  # ==================== PROFILE SEARCH ====================

  Scenario: Search for users
    Given the user uses the search function
    When searching for users
    Then search options include:
      | Search By           | Example                         |
      | Username            | @john_doe                       |
      | Display Name        | John Doe                        |
      | Email               | john@example.com (if allowed)   |
      | League Membership   | Members of "FFL Championship"   |
    And results show profile previews

  Scenario: Discover suggested connections
    Given the user views connection suggestions
    When suggestions load
    Then the system recommends:
      | User                | Reason                          |
      | player_123          | 3 mutual friends                |
      | fantasy_ace         | Same league as you              |
      | sports_guru         | Similar stats profile           |
      | league_mate_22      | Played against you 5 times      |
    And suggestions can be dismissed or followed

  # ==================== ERROR HANDLING ====================

  Scenario: Handle profile update failure
    Given the user attempts to update their profile
    When the update fails
    Then the user sees:
      | Error Element       | Content                         |
      | Error Message       | "Unable to save profile changes"|
      | Reason              | Specific validation error       |
      | Suggestion          | How to fix the issue            |
      | Retry Option        | Button to try again             |
    And unsaved changes are preserved

  Scenario: Handle avatar upload failure
    Given the user attempts to upload an invalid image
    When upload fails
    Then the error displays:
      | Issue               | File too large (>5MB)           |
      | Resolution          | Compress or choose smaller file |
      | Supported Formats   | JPG, PNG, GIF                   |
      | Max Dimensions      | 2048x2048 pixels                |
    And current avatar remains unchanged

  Scenario: Handle blocked profile access
    Given a user tries to view a blocking user's profile
    When the profile request is made
    Then the system displays:
      | Message             | "This profile is unavailable"   |
    And no profile information is shown
    And no indication of blocking is given

  # ==================== ACCOUNT SECURITY ====================

  Scenario: Change password
    Given the user wants to change their password
    When the password change form loads
    Then requirements include:
      | Requirement             | Details                       |
      | Current Password        | Must match existing           |
      | New Password            | Minimum 12 characters         |
      | Password Strength       | Must include upper, lower, number |
      | Confirmation            | Must match new password       |
    And password change triggers session review
    And notification sent to email

  Scenario: Enable two-factor authentication
    Given the user enables 2FA
    When setup wizard loads
    Then the user can choose:
      | Method                  | Description                   |
      | Authenticator App       | Google/Authy/etc.             |
      | SMS                     | Text message codes            |
      | Email                   | Email verification codes      |
      | Backup Codes            | One-time recovery codes       |
    And recovery options are required
    And 2FA confirmation required for sensitive actions

  Scenario: View active sessions
    Given the user accesses session management
    When active sessions load
    Then sessions display:
      | Device              | Location        | Last Active   | Actions       |
      | iPhone 15           | New York, US    | Current       | -             |
      | Chrome on Windows   | New York, US    | 2 hours ago   | Revoke        |
      | Safari on MacBook   | Boston, US      | 1 day ago     | Revoke        |
    And suspicious sessions are flagged
    And "Revoke All" option available
