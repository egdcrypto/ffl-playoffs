@ANIMA-1421 @backend @priority_2 @integrations
Feature: Platform Integrations System
  As a fantasy football playoffs platform user
  I want to connect with external services and platforms
  So that I can import data, share content, and enhance my experience

  Background:
    Given the integration system is enabled
    And the user is authenticated
    And integration APIs are available

  # ==================== ESPN INTEGRATION ====================

  Scenario: Connect ESPN fantasy account
    Given the user wants to connect their ESPN account
    When the user clicks "Connect ESPN"
    Then the connection flow:
      | Redirects to ESPN login                 |
      | Requests necessary permissions          |
      | Returns with authorization token        |
      | Shows connection success                |
    And ESPN account is linked to user profile

  Scenario: Import ESPN league data
    Given the user has connected their ESPN account
    When the user selects a league to import
    Then import options show:
      | Data Type           | Available                       |
      | League Settings     | Yes                             |
      | Team Rosters        | Yes                             |
      | Player Stats        | Yes                             |
      | Transaction History | Yes                             |
      | Draft Results       | Yes                             |
    And user selects data to import
    And import progress is displayed

  Scenario: Sync ESPN roster to platform
    Given the user has an ESPN league connected
    When roster sync is triggered
    Then the system:
      | Fetches current ESPN roster             |
      | Maps players to platform database       |
      | Updates platform roster                 |
      | Logs sync timestamp                     |
    And roster reflects ESPN lineup

  Scenario: Handle ESPN API rate limits
    Given the user is syncing ESPN data
    When API rate limit is reached
    Then the system:
      | Shows rate limit message                |
      | Queues remaining sync operations        |
      | Retries after cooldown period           |
      | Notifies when sync completes            |
    And partial data is preserved

  Scenario: Disconnect ESPN account
    Given the user has an ESPN account connected
    When the user clicks "Disconnect ESPN"
    Then the system:
      | Confirms disconnection request          |
      | Revokes access tokens                   |
      | Removes ESPN data from platform         |
      | Preserves user-created content          |
    And ESPN connection is removed

  # ==================== YAHOO INTEGRATION ====================

  Scenario: Connect Yahoo Fantasy account
    Given the user wants to connect their Yahoo account
    When the user clicks "Connect Yahoo"
    Then OAuth flow begins:
      | Step                | Action                          |
      | Redirect            | Yahoo authorization page        |
      | Permissions         | Request fantasy data access     |
      | Callback            | Return with auth code           |
      | Token Exchange      | Get access/refresh tokens       |
    And Yahoo account is linked

  Scenario: Import Yahoo league data
    Given the user has connected their Yahoo account
    When leagues are fetched
    Then available leagues show:
      | League Name         | Season | Teams | Status   |
      | Yahoo Pro League    | 2025   | 12    | Active   |
      | Friends League      | 2025   | 10    | Active   |
      | Dynasty Yahoo       | 2024   | 12    | Archived |
    And user can select leagues to import

  Scenario: Sync Yahoo player statistics
    Given Yahoo integration is active
    When player stats sync runs
    Then statistics are updated:
      | Stat Type           | Source                          |
      | Season Stats        | Yahoo season totals             |
      | Weekly Stats        | Yahoo weekly breakdown          |
      | Projections         | Yahoo expert projections        |
    And stats are merged with platform data

  Scenario: Handle Yahoo token refresh
    Given Yahoo access token is expiring
    When token refresh is needed
    Then the system:
      | Uses refresh token automatically        |
      | Obtains new access token                |
      | Updates stored credentials              |
      | Continues operation seamlessly          |
    And user is not interrupted

  Scenario: Yahoo authentication failure
    Given Yahoo credentials become invalid
    When sync is attempted
    Then the system:
      | Detects authentication failure          |
      | Notifies user of issue                  |
      | Provides re-authentication link         |
      | Pauses scheduled syncs                  |
    And user can re-connect Yahoo

  # ==================== SLEEPER INTEGRATION ====================

  Scenario: Connect Sleeper account
    Given the user wants to connect Sleeper
    When connection is initiated
    Then the connection process:
      | Requests Sleeper username               |
      | Verifies account exists                 |
      | Fetches user ID from Sleeper API        |
      | Links account to platform               |
    And Sleeper username is displayed

  Scenario: Import Sleeper leagues
    Given the user has connected Sleeper
    When league import is triggered
    Then Sleeper leagues are fetched:
      | League Name         | Format   | Size | Status   |
      | Sleeper Dynasty     | Dynasty  | 12   | Active   |
      | Best Ball League    | Best Ball| 10   | Active   |
      | Redraft 2025        | Redraft  | 12   | Active   |
    And league settings are imported

  Scenario: Sync Sleeper rosters real-time
    Given Sleeper integration is active
    When real-time sync is enabled
    Then the system:
      | Establishes websocket connection        |
      | Receives roster update events           |
      | Updates platform data in real-time      |
      | Handles connection interruptions        |
    And roster changes appear within seconds

  Scenario: Import Sleeper transaction history
    Given the user imports a Sleeper league
    When transaction history is synced
    Then transactions include:
      | Type                | Data Imported                   |
      | Trades              | Players, picks, dates           |
      | Waivers             | Claims, priority, FAAB          |
      | Drops               | Player dropped, date            |
      | IR Moves            | Player, IR designation          |
    And history is searchable on platform

  Scenario: Handle Sleeper API unavailable
    Given Sleeper API is temporarily down
    When sync is attempted
    Then the system:
      | Shows service unavailable message       |
      | Uses cached data if available           |
      | Schedules retry attempts                |
      | Notifies when service recovers          |
    And user experience is not blocked

  # ==================== NFL INTEGRATION ====================

  Scenario: Fetch official NFL data
    Given the platform uses NFL data
    When NFL data sync runs
    Then official data includes:
      | Data Type           | Source                          |
      | Player Information  | NFL official rosters            |
      | Game Schedules      | NFL schedule API                |
      | Live Scores         | NFL live scoring                |
      | Injury Reports      | NFL injury designations         |
    And data is updated per NFL schedule

  Scenario: Sync live NFL game scores
    Given NFL games are in progress
    When live score sync is active
    Then scores update:
      | Frequency           | Every 30 seconds                |
      | Data Points         | Score, stats, game state        |
      | Latency             | Under 1 minute delay            |
    And fantasy points calculate in real-time

  Scenario: Import NFL player injury status
    Given injury reports are published
    When injury sync runs
    Then injury data shows:
      | Player          | Status    | Details              |
      | Patrick Mahomes | Probable  | Ankle - Limited      |
      | Travis Kelce    | Questionable | Knee - DNP Thursday |
      | Tyreek Hill     | Out       | Hip - IR             |
    And injury badges appear on player cards

  Scenario: Fetch NFL schedule updates
    Given the NFL schedule may change
    When schedule sync runs
    Then updates include:
      | Change Type         | Action                          |
      | Game Time Change    | Update stored game time         |
      | Venue Change        | Update location                 |
      | Game Postponement   | Mark game as postponed          |
      | Game Cancellation   | Handle appropriately            |
    And affected users are notified

  Scenario: Handle NFL off-season
    Given it is NFL off-season
    When data sync runs
    Then off-season handling:
      | Reduces sync frequency                  |
      | Focuses on roster moves                 |
      | Tracks free agency news                 |
      | Prepares for upcoming season            |
    And platform adjusts accordingly

  # ==================== SOCIAL MEDIA INTEGRATION ====================

  Scenario: Connect Twitter/X account
    Given the user wants to share to Twitter
    When Twitter connection is initiated
    Then OAuth flow:
      | Redirects to Twitter authorization      |
      | Requests post permissions               |
      | Returns with access token               |
      | Stores credentials securely             |
    And Twitter sharing is enabled

  Scenario: Share achievement to social media
    Given the user earns an achievement
    When share options are shown
    Then available platforms include:
      | Platform            | Share Type                      |
      | Twitter/X           | Tweet with image                |
      | Facebook            | Post with link preview          |
      | Instagram           | Story or post (via app)         |
      | LinkedIn            | Professional share              |
    And pre-populated content is editable

  Scenario: Auto-share matchup results
    Given the user enables auto-sharing
    When a matchup is won
    Then automatic share:
      | Creates share content                   |
      | Includes score and opponent             |
      | Posts to connected platforms            |
      | Respects sharing preferences            |
    And user can disable per platform

  Scenario: Import social contacts for friend finding
    Given the user connects social account
    When friend finding is enabled
    Then the system:
      | Requests contact access permission      |
      | Matches contacts to platform users      |
      | Shows potential connections             |
      | Allows friend requests                  |
    And contact data is not stored permanently

  Scenario: Disconnect social media account
    Given the user has connected social accounts
    When disconnection is requested
    Then the system:
      | Confirms disconnection                  |
      | Revokes access tokens                   |
      | Disables auto-sharing                   |
      | Removes social links from profile       |
    And previously shared content remains

  # ==================== CALENDAR INTEGRATION ====================

  Scenario: Connect Google Calendar
    Given the user wants calendar sync
    When Google Calendar is connected
    Then OAuth flow completes:
      | Step                | Action                          |
      | Authorize           | Google permission screen        |
      | Select Calendar     | Choose target calendar          |
      | Confirm             | Enable sync                     |
    And calendar events are synced

  Scenario: Sync matchup schedule to calendar
    Given calendar integration is active
    When matchup events are synced
    Then calendar entries include:
      | Event               | Details                         |
      | Matchup Start       | vs jane_doe - Week 15           |
      | Roster Deadline     | Lineup locks at 1:00 PM ET      |
      | Playoff Round       | Wild Card Round begins          |
    And events include platform links

  Scenario: Sync NFL game times to calendar
    Given the user follows specific NFL games
    When game sync is configured
    Then calendar shows:
      | Event               | Time        | Details           |
      | Chiefs vs Bills     | 4:25 PM ET  | AFC Championship  |
      | Eagles vs 49ers     | 8:15 PM ET  | NFC Championship  |
    And reminders are set automatically

  Scenario: Connect Apple Calendar
    Given the user uses Apple Calendar
    When Apple Calendar integration is enabled
    Then the system:
      | Generates .ics subscription URL         |
      | User adds to Apple Calendar             |
      | Events sync automatically               |
      | Updates reflect in calendar             |
    And subscription remains active

  Scenario: Calendar event reminders
    Given calendar events are synced
    When reminder settings are configured
    Then reminders are sent:
      | Event Type          | Reminder Time                   |
      | Roster Deadline     | 1 hour before                   |
      | Game Start          | 15 minutes before               |
      | Trade Deadline      | 24 hours before                 |
    And reminder methods are configurable

  # ==================== NOTIFICATION INTEGRATION ====================

  Scenario: Connect push notification service
    Given the user enables push notifications
    When device registration occurs
    Then the system:
      | Registers device token                  |
      | Associates with user account            |
      | Enables push delivery                   |
      | Tests notification delivery             |
    And push notifications work on device

  Scenario: Integrate with Slack
    Given the user wants Slack notifications
    When Slack is connected
    Then integration setup:
      | Adds Slack app to workspace             |
      | Configures notification channel         |
      | Sets notification preferences           |
      | Tests message delivery                  |
    And updates post to Slack channel

  Scenario: Integrate with Discord
    Given the user wants Discord notifications
    When Discord webhook is configured
    Then setup includes:
      | Creates Discord webhook URL             |
      | Enters webhook in platform settings     |
      | Configures message format               |
      | Tests webhook delivery                  |
    And notifications post to Discord

  Scenario: Configure notification routing
    Given multiple notification channels exist
    When routing rules are set
    Then routing options include:
      | Event Type          | Channels                        |
      | Score Updates       | Push, Email                     |
      | Trade Proposals     | Push, Slack, Email              |
      | League Announcements| Email, Discord                  |
      | Urgent Alerts       | All channels                    |
    And rules are customizable

  Scenario: Handle notification delivery failure
    Given a notification fails to deliver
    When failure is detected
    Then the system:
      | Logs delivery failure                   |
      | Retries with backoff                    |
      | Falls back to alternate channel         |
      | Notifies user if persistent             |
    And notification eventually delivers

  # ==================== API ACCESS ====================

  Scenario: Generate API access key
    Given the user wants API access
    When API key generation is requested
    Then the system:
      | Verifies user is eligible               |
      | Generates secure API key                |
      | Displays key once (copy required)       |
      | Associates key with user account        |
    And API key is ready for use

  Scenario: View API documentation
    Given the user has API access
    When documentation is accessed
    Then docs include:
      | Section             | Content                         |
      | Authentication      | How to use API keys             |
      | Endpoints           | Available API endpoints         |
      | Rate Limits         | Request limits and quotas       |
      | Examples            | Code samples in multiple languages|
      | Changelog           | API version history             |
    And interactive API explorer is available

  Scenario: Monitor API usage
    Given the user uses the API
    When usage dashboard is viewed
    Then metrics show:
      | Metric              | Value                           |
      | Requests Today      | 1,234                           |
      | Requests This Month | 45,678                          |
      | Rate Limit          | 10,000/day                      |
      | Average Latency     | 125ms                           |
    And usage history is graphed

  Scenario: Handle API rate limiting
    Given API rate limit is exceeded
    When request is made
    Then the system:
      | Returns 429 status code                 |
      | Includes retry-after header             |
      | Shows remaining quota                   |
      | Does not count against limit            |
    And user can retry after cooldown

  Scenario: Revoke API access key
    Given the user wants to revoke a key
    When revocation is requested
    Then the system:
      | Confirms revocation action              |
      | Immediately invalidates key             |
      | Logs revocation event                   |
      | Allows generating new key               |
    And old key no longer works

  Scenario: API access tiers
    Given different API access levels exist
    When access tiers are displayed
    Then tiers include:
      | Tier        | Rate Limit  | Features          | Price     |
      | Free        | 100/day     | Read-only         | $0        |
      | Developer   | 10,000/day  | Read + Write      | $29/mo    |
      | Professional| 100,000/day | All + Priority    | $99/mo    |
      | Enterprise  | Unlimited   | All + SLA         | Custom    |
    And upgrade path is available

  # ==================== THIRD-PARTY APPS ====================

  Scenario: Browse third-party app marketplace
    Given the user accesses app marketplace
    When marketplace loads
    Then apps are displayed:
      | App Name            | Category    | Rating | Price     |
      | Trade Analyzer Pro  | Analysis    | 4.8    | Free      |
      | Draft Assistant     | Draft       | 4.5    | $4.99     |
      | Roster Optimizer    | Lineup      | 4.7    | $2.99/mo  |
      | Fantasy Insights    | Stats       | 4.2    | Free      |
    And apps are searchable and filterable

  Scenario: Install third-party app
    Given the user selects an app
    When installation is initiated
    Then installation process:
      | Shows app permissions required          |
      | Requests user authorization             |
      | Installs app to user account            |
      | Provides access to user data            |
    And app appears in installed apps

  Scenario: Manage app permissions
    Given the user has installed apps
    When app permissions are viewed
    Then permissions show:
      | App                 | Permissions                     |
      | Trade Analyzer Pro  | Read roster, Read transactions  |
      | Draft Assistant     | Read league, Write draft picks  |
    And permissions can be modified

  Scenario: Uninstall third-party app
    Given the user wants to remove an app
    When uninstall is requested
    Then the system:
      | Confirms uninstallation                 |
      | Revokes app access                      |
      | Removes app data                        |
      | Preserves user data created in app      |
    And app is removed from account

  Scenario: Review and rate third-party app
    Given the user has used an app
    When review is submitted
    Then review includes:
      | Field               | Content                         |
      | Rating              | 1-5 stars                       |
      | Title               | Review headline                 |
      | Description         | Detailed feedback               |
      | Recommend           | Yes/No                          |
    And review is published after moderation

  # ==================== DATA EXPORT ====================

  Scenario: Export roster data
    Given the user wants to export roster
    When export is requested
    Then export options include:
      | Format              | Content                         |
      | CSV                 | Tabular roster data             |
      | JSON                | Structured data                 |
      | PDF                 | Formatted roster report         |
    And download is initiated

  Scenario: Export league history
    Given the user wants league history
    When history export is configured
    Then export includes:
      | Data Type           | Available                       |
      | Transaction History | All trades, waivers, drops      |
      | Score History       | Week-by-week scores             |
      | Standing History    | Historical rankings             |
      | Draft History       | All draft picks                 |
    And date range is selectable

  Scenario: Export player statistics
    Given the user wants player stats
    When export is requested
    Then export options include:
      | Scope               | Options                         |
      | Players             | My roster, All players          |
      | Time Period         | Season, Playoffs, Custom        |
      | Stats               | All stats, Fantasy points only  |
    And export format is selectable

  Scenario: Schedule automatic data export
    Given the user wants regular exports
    When scheduled export is configured
    Then schedule options include:
      | Frequency           | Daily, Weekly, Monthly          |
      | Delivery            | Email attachment, Cloud storage |
      | Format              | CSV, JSON, PDF                  |
      | Data Scope          | Configurable selections         |
    And exports run automatically

  Scenario: Export to cloud storage
    Given the user has cloud storage connected
    When export destination is selected
    Then cloud options include:
      | Service             | Status                          |
      | Google Drive        | Connected                       |
      | Dropbox             | Not connected                   |
      | OneDrive            | Connected                       |
    And export saves directly to cloud

  Scenario: Bulk data export (GDPR)
    Given the user requests all their data
    When GDPR export is initiated
    Then the export includes:
      | Data Category       | Content                         |
      | Profile Data        | All account information         |
      | Activity Logs       | All platform activity           |
      | Content Created     | Posts, messages, settings       |
      | Transaction Data    | All payment history             |
    And export is delivered within 30 days

  # ==================== INTEGRATION MANAGEMENT ====================

  Scenario: View all active integrations
    Given the user has multiple integrations
    When integration dashboard is viewed
    Then integrations show:
      | Integration         | Status    | Last Sync        | Actions |
      | ESPN                | Connected | 5 minutes ago    | Manage  |
      | Yahoo               | Connected | 1 hour ago       | Manage  |
      | Google Calendar     | Connected | Real-time        | Manage  |
      | Slack               | Error     | Failed yesterday | Fix     |
    And status indicators are clear

  Scenario: Troubleshoot integration issues
    Given an integration has errors
    When troubleshooting is accessed
    Then diagnostics include:
      | Check               | Result                          |
      | Authentication      | Valid/Expired                   |
      | API Connectivity    | Reachable/Unreachable           |
      | Permissions         | Sufficient/Insufficient         |
      | Rate Limits         | OK/Exceeded                     |
    And suggested fixes are provided

  Scenario: Integration health monitoring
    Given integrations are active
    When health check runs
    Then monitoring includes:
      | Checks every 15 minutes                 |
      | Alerts on failures                      |
      | Auto-attempts reconnection              |
      | Logs all status changes                 |
    And user is notified of issues

  # ==================== ERROR HANDLING ====================

  Scenario: Handle integration service outage
    Given an external service is unavailable
    When integration sync is attempted
    Then the system:
      | Shows service status message            |
      | Uses cached data if available           |
      | Queues sync for when service recovers   |
      | Notifies user of degraded functionality |
    And platform continues functioning

  Scenario: Handle OAuth token expiration
    Given OAuth tokens expire
    When token refresh fails
    Then the system:
      | Notifies user of authentication issue   |
      | Provides re-authentication link         |
      | Preserves integration settings          |
      | Pauses dependent features               |
    And user can re-authenticate easily
