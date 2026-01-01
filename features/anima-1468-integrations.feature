@integrations
Feature: Integrations
  As a fantasy football manager
  I want to integrate with external platforms and services
  So that I can sync data and enhance my fantasy experience

  # --------------------------------------------------------------------------
  # ESPN Integration
  # --------------------------------------------------------------------------

  @espn-integration
  Scenario: Connect ESPN account
    Given I am logged in as a user
    When I navigate to ESPN integration settings
    And I click Connect ESPN Account
    Then I should be redirected to ESPN login
    And after successful login I should be redirected back
    And my ESPN account should be connected

  @espn-integration
  Scenario: Import ESPN league
    Given I have connected my ESPN account
    When I view my ESPN leagues
    And I select a league to import
    Then the league settings should be imported
    And rosters should be imported
    And standings should be imported
    And I should see import confirmation

  @espn-integration
  Scenario: Sync ESPN rosters
    Given I have an imported ESPN league
    When I trigger roster sync
    Then rosters should update from ESPN
    And any roster changes should be reflected
    And sync timestamp should be updated

  @espn-integration
  Scenario: Import ESPN draft results
    Given I have an imported ESPN league
    And the draft has been completed on ESPN
    When I import draft results
    Then all draft picks should be imported
    And draft order should be preserved
    And keeper designations should be imported

  @espn-integration
  Scenario: Configure ESPN auto-sync
    Given I have an imported ESPN league
    When I configure auto-sync settings
    Then I should be able to set sync frequency
    And I should be able to choose what data syncs
    And syncs should occur automatically

  @espn-integration
  Scenario: Handle ESPN authentication expiration
    Given I have connected my ESPN account
    And my ESPN authentication has expired
    When I try to sync data
    Then I should be prompted to re-authenticate
    And after re-authentication sync should complete

  # --------------------------------------------------------------------------
  # Yahoo Integration
  # --------------------------------------------------------------------------

  @yahoo-integration
  Scenario: Connect Yahoo account via OAuth
    Given I am logged in as a user
    When I navigate to Yahoo integration settings
    And I initiate Yahoo OAuth connection
    Then I should be redirected to Yahoo authorization
    And I should grant necessary permissions
    And my Yahoo account should be connected

  @yahoo-integration
  Scenario: Import Yahoo league
    Given I have connected my Yahoo account
    When I view my Yahoo leagues
    And I select a league to import
    Then league configuration should be imported
    And team rosters should be imported
    And transaction history should be imported

  @yahoo-integration
  Scenario: Sync Yahoo standings
    Given I have an imported Yahoo league
    When standings are updated on Yahoo
    And I sync standings
    Then standings should match Yahoo
    And playoff positions should be accurate
    And tiebreakers should be applied correctly

  @yahoo-integration
  Scenario: Import Yahoo transactions
    Given I have an imported Yahoo league
    When I import transaction history
    Then all trades should be imported
    And all waiver claims should be imported
    And add/drop transactions should be imported

  @yahoo-integration
  Scenario: Handle Yahoo rate limits
    Given I am syncing Yahoo data
    When I hit Yahoo API rate limits
    Then I should see a rate limit notification
    And sync should retry after cooldown
    And partial data should be preserved

  @yahoo-integration
  Scenario: Disconnect Yahoo account
    Given I have connected my Yahoo account
    When I disconnect my Yahoo account
    Then the OAuth tokens should be revoked
    And Yahoo leagues should remain but not sync
    And I should see disconnection confirmation

  # --------------------------------------------------------------------------
  # Sleeper Integration
  # --------------------------------------------------------------------------

  @sleeper-integration
  Scenario: Connect Sleeper account
    Given I am logged in as a user
    When I navigate to Sleeper integration
    And I enter my Sleeper username
    Then my Sleeper account should be linked
    And I should see my Sleeper leagues

  @sleeper-integration
  Scenario: Import Sleeper league
    Given I have connected my Sleeper account
    When I select a Sleeper league to import
    Then league settings should be imported
    And dynasty settings should be imported if applicable
    And all team rosters should be imported

  @sleeper-integration
  Scenario: Sync Sleeper lineups
    Given I have an imported Sleeper league
    When lineups are set on Sleeper
    And I sync lineups
    Then lineups should match Sleeper
    And taxi squad should be synced if applicable
    And IR designations should be synced

  @sleeper-integration
  Scenario: Import Sleeper chat history
    Given I have an imported Sleeper league
    When I import chat history
    Then league chat messages should be imported
    And trade discussion threads should be imported
    And message timestamps should be preserved

  @sleeper-integration
  Scenario: Sync Sleeper draft picks
    Given I have an imported Sleeper dynasty league
    When I sync future draft picks
    Then draft pick ownership should be current
    And traded picks should be reflected
    And draft pick values should be calculated

  @sleeper-integration
  Scenario: Real-time Sleeper updates
    Given I have an imported Sleeper league
    When a transaction occurs on Sleeper
    Then I should receive near real-time notification
    And the transaction should sync automatically

  # --------------------------------------------------------------------------
  # NFL Integration
  # --------------------------------------------------------------------------

  @nfl-integration
  Scenario: Import NFL.com league
    Given I am logged in as a user
    When I navigate to NFL.com integration
    And I login to my NFL.com account
    And I select a league to import
    Then the league should be imported
    And all rosters should be imported
    And scoring settings should be imported

  @nfl-integration
  Scenario: Sync player data from NFL
    Given I have NFL data integration enabled
    When player data is updated by NFL
    Then player profiles should update
    And injury statuses should update
    And depth chart positions should update

  @nfl-integration
  Scenario: Integrate NFL schedule
    Given I have NFL integration enabled
    When I view the schedule
    Then NFL game times should be accurate
    And bye weeks should be reflected
    And primetime games should be indicated

  @nfl-integration
  Scenario: Receive NFL injury updates
    Given I have NFL integration enabled
    When an injury report is released
    Then injury updates should sync
    And my roster should show injury designations
    And I should receive injury alerts for my players

  @nfl-integration
  Scenario: Sync NFL game scores
    Given I have NFL integration enabled
    And games are in progress
    When I view live scoring
    Then scores should update in real-time
    And player stats should be current
    And box scores should be available

  # --------------------------------------------------------------------------
  # CBS Integration
  # --------------------------------------------------------------------------

  @cbs-integration
  Scenario: Import CBS Sports league
    Given I am logged in as a user
    When I navigate to CBS integration
    And I authenticate with CBS Sports
    And I select a league to import
    Then league configuration should be imported
    And all teams and rosters should be imported

  @cbs-integration
  Scenario: Sync CBS rosters
    Given I have an imported CBS league
    When roster changes occur on CBS
    And I sync rosters
    Then all roster changes should be reflected
    And IR moves should be synced
    And taxi squad should be synced

  @cbs-integration
  Scenario: Import CBS scoring settings
    Given I have an imported CBS league
    When I import scoring settings
    Then all scoring categories should be imported
    And point values should match CBS
    And custom scoring rules should be preserved

  @cbs-integration
  Scenario: Handle CBS import errors
    Given I am importing a CBS league
    When an import error occurs
    Then I should see a clear error message
    And partial import data should be preserved
    And I should be able to retry the import

  # --------------------------------------------------------------------------
  # Social Media Integration
  # --------------------------------------------------------------------------

  @social-integration
  Scenario: Share to Twitter/X
    Given I am logged in as a user
    And I have connected my Twitter/X account
    When I share content to Twitter
    Then a tweet should be composed
    And I should be able to customize the message
    And the tweet should be posted successfully

  @social-integration
  Scenario: Post to Facebook
    Given I am logged in as a user
    And I have connected my Facebook account
    When I share content to Facebook
    Then a Facebook post should be composed
    And I should choose audience visibility
    And the post should be published

  @social-integration
  Scenario: Send Discord notifications
    Given I am logged in as a commissioner
    When I configure Discord integration
    And I add a Discord webhook
    Then league events should post to Discord
    And I should be able to customize which events post
    And messages should be formatted for Discord

  @social-integration
  Scenario: Share matchup results
    Given I have completed a matchup
    When I share my matchup results
    Then I should see shareable content generated
    And I should be able to share to multiple platforms
    And the shared content should include key stats

  @social-integration
  Scenario: Configure social sharing defaults
    Given I am logged in as a user
    When I configure social sharing settings
    Then I should set default share message template
    And I should choose default platforms
    And I should control what data is shared

  @social-integration
  Scenario: Disconnect social media account
    Given I have connected a social media account
    When I disconnect the account
    Then the connection should be removed
    And posting permissions should be revoked
    And I should see disconnection confirmation

  # --------------------------------------------------------------------------
  # Calendar Integration
  # --------------------------------------------------------------------------

  @calendar-integration
  Scenario: Sync with Google Calendar
    Given I am logged in as a user
    When I connect Google Calendar
    And I authorize calendar access
    Then my fantasy schedule should sync to Google Calendar
    And game times should appear as events
    And lineup deadlines should be added

  @calendar-integration
  Scenario: Sync with Apple Calendar
    Given I am logged in as a user
    When I connect Apple Calendar
    Then I should receive a calendar subscription URL
    And subscribing should add fantasy events
    And events should update automatically

  @calendar-integration
  Scenario: Integrate with Outlook
    Given I am logged in as a user
    When I connect Outlook calendar
    And I authorize access
    Then fantasy events should sync to Outlook
    And reminders should be configured
    And recurring events should be created

  @calendar-integration
  Scenario: Configure calendar event types
    Given I have calendar integration enabled
    When I configure event settings
    Then I should choose which events to sync
    And I should set reminder timing
    And I should customize event details

  @calendar-integration
  Scenario: Update calendar when schedule changes
    Given I have calendar integration enabled
    When a game is rescheduled
    Then calendar events should update
    And I should receive notification of change
    And new times should be reflected

  @calendar-integration
  Scenario: Remove calendar integration
    Given I have calendar integration enabled
    When I remove calendar integration
    Then synced events should be removed
    And future syncing should stop
    And I should see removal confirmation

  # --------------------------------------------------------------------------
  # Payment Integration
  # --------------------------------------------------------------------------

  @payment-integration
  Scenario: Connect PayPal for league dues
    Given I am a commissioner
    When I configure PayPal integration
    And I connect my PayPal business account
    Then league members should be able to pay via PayPal
    And I should see payment status for each member

  @payment-integration
  Scenario: Process Venmo payments
    Given I am a commissioner
    And Venmo integration is enabled
    When a member pays via Venmo
    Then the payment should be recorded
    And the member's payment status should update
    And I should receive payment notification

  @payment-integration
  Scenario: Configure Stripe for payments
    Given I am a commissioner
    When I configure Stripe integration
    And I complete Stripe onboarding
    Then members should be able to pay by card
    And payment processing should be secure
    And payout to my account should be available

  @payment-integration
  Scenario: Send payment reminders
    Given I am a commissioner
    And some members have not paid dues
    When I send payment reminders
    Then reminders should be sent to unpaid members
    And payment links should be included
    And I should see reminder confirmation

  @payment-integration
  Scenario: Process prize payouts
    Given I am a commissioner
    And the season has ended
    When I process prize payouts
    Then I should select payout recipients
    And I should initiate payouts via connected service
    And payout status should be tracked

  @payment-integration
  Scenario: View payment history
    Given I am a commissioner
    When I view payment history
    Then I should see all payments received
    And I should see all payouts made
    And I should be able to export payment records

  @payment-integration
  Scenario: Handle payment disputes
    Given a payment dispute is filed
    When I view the dispute
    Then I should see dispute details
    And I should be able to provide evidence
    And dispute resolution should be tracked

  # --------------------------------------------------------------------------
  # Data Provider Integration
  # --------------------------------------------------------------------------

  @data-provider-integration
  Scenario: Integrate FantasyPros data
    Given I am logged in as a user
    When I enable FantasyPros integration
    Then I should see FantasyPros rankings
    And I should see expert consensus projections
    And I should see start/sit recommendations

  @data-provider-integration
  Scenario: Integrate PFF data
    Given I am logged in as a user
    And I have a PFF subscription
    When I connect my PFF account
    Then I should see PFF grades for players
    And I should see advanced metrics
    And I should see PFF projections

  @data-provider-integration
  Scenario: Configure ESPN API data feed
    Given I am logged in as a user
    When I enable ESPN data feed
    Then I should receive ESPN projections
    And I should see ESPN player news
    And I should see ESPN fantasy analysis

  @data-provider-integration
  Scenario: Configure NFL API data feed
    Given I am logged in as a user
    When I enable NFL data feed
    Then I should receive official NFL stats
    And I should see real-time game data
    And I should see official injury reports

  @data-provider-integration
  Scenario: Handle data provider outage
    Given I have data provider integrations enabled
    When a data provider is unavailable
    Then I should see an outage notification
    And cached data should be used
    And data should resume when provider recovers

  @data-provider-integration
  Scenario: Configure data refresh frequency
    Given I have data provider integrations
    When I configure refresh settings
    Then I should set refresh frequency
    And I should prioritize certain data types
    And I should manage data usage limits

  # --------------------------------------------------------------------------
  # Webhook Integration
  # --------------------------------------------------------------------------

  @webhook-integration
  Scenario: Create custom webhook
    Given I am a commissioner
    When I create a custom webhook
    And I provide a webhook URL
    And I select events to trigger
    Then the webhook should be created
    And I should be able to test the webhook

  @webhook-integration
  Scenario: Configure Zapier integration
    Given I am logged in as a user
    When I connect to Zapier
    Then I should see available triggers
    And I should be able to create Zaps
    And league events should trigger Zapier workflows

  @webhook-integration
  Scenario: Configure IFTTT integration
    Given I am logged in as a user
    When I connect to IFTTT
    Then I should see available triggers
    And I should be able to create applets
    And fantasy events should work with IFTTT

  @webhook-integration
  Scenario: Send Slack notifications
    Given I am a commissioner
    When I configure Slack integration
    And I add a Slack webhook
    Then league events should post to Slack
    And messages should be formatted for Slack
    And I should customize notification settings

  @webhook-integration
  Scenario: Test webhook delivery
    Given I have configured a webhook
    When I test the webhook
    Then a test payload should be sent
    And I should see delivery status
    And I should see the response received

  @webhook-integration
  Scenario: View webhook logs
    Given I have configured webhooks
    When I view webhook logs
    Then I should see all webhook deliveries
    And I should see success and failure status
    And I should see payload contents

  @webhook-integration
  Scenario: Handle webhook failures
    Given I have configured a webhook
    When a webhook delivery fails
    Then the failure should be logged
    And retry attempts should occur
    And I should be notified of persistent failures

  @webhook-integration
  Scenario: Secure webhook with signature
    Given I am creating a webhook
    When I configure webhook security
    Then I should receive a signing secret
    And payloads should include signature header
    And I should be able to verify authenticity

  # --------------------------------------------------------------------------
  # Integration Management
  # --------------------------------------------------------------------------

  @integration-management
  Scenario: View all active integrations
    Given I am logged in as a user
    When I view my integrations
    Then I should see all connected services
    And I should see connection status
    And I should see last sync times

  @integration-management
  Scenario: Refresh integration connection
    Given I have an integration with issues
    When I refresh the connection
    Then the connection should be re-established
    And data should sync fresh
    And I should see connection health

  @integration-management
  Scenario: Manage integration permissions
    Given I have connected integrations
    When I review integration permissions
    Then I should see what data is shared
    And I should be able to modify permissions
    And I should be able to revoke access

  @integration-management
  Scenario: Export integration data
    Given I have data from integrations
    When I export integration data
    Then I should receive a data export
    And all synced data should be included
    And the export should be in standard format

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @integrations @error-handling
  Scenario: Handle integration authentication failure
    Given I am connecting an integration
    When authentication fails
    Then I should see a clear error message
    And I should be able to retry
    And my previous data should be preserved

  @integrations @error-handling
  Scenario: Handle sync conflicts
    Given I have data in multiple platforms
    When a sync conflict is detected
    Then I should be notified of the conflict
    And I should see both versions
    And I should choose which version to keep

  @integrations @error-handling
  Scenario: Handle API deprecation
    Given I am using an integration
    When the external API is deprecated
    Then I should be notified in advance
    And I should see migration options
    And my data should be preserved

  @integrations @rate-limits
  Scenario: Handle rate limiting gracefully
    Given I am syncing large amounts of data
    When I hit rate limits
    Then sync should pause gracefully
    And I should see rate limit status
    And sync should resume when allowed

  @integrations @security
  Scenario: Secure credential storage
    Given I connect to external services
    Then my credentials should be encrypted
    And tokens should be stored securely
    And I should be able to rotate credentials
