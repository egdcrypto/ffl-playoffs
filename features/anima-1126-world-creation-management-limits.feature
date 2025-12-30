@platform @limits @subscription @quotas
Feature: World Creation and Management Limits
  As a platform administrator
  I want to enforce limits on world creation and activation
  So that I can manage resource usage and monetize the platform appropriately

  Background:
    Given I am logged in as a world owner
    And the platform has defined subscription tiers
    And the limit enforcement service is operational
    And my account is in good standing

  # ===========================================================================
  # WORLD CREATION LIMITS
  # ===========================================================================

  @api @limits @creation
  Scenario: Check world creation limit for free tier
    Given I have a free tier subscription
    And free tier allows 1 world
    And I currently have 0 worlds
    When I check my world creation limit
    Then I should see a response with status 200
    And the response should contain:
      | field              | value |
      | tier               | free  |
      | max_worlds         | 1     |
      | current_worlds     | 0     |
      | remaining_slots    | 1     |
    And I should see upgrade options for more worlds
    And upgrade options should include "basic", "professional", "enterprise"

  @api @limits @creation
  Scenario: Create world within subscription limit
    Given I have a professional subscription
    And my subscription allows 5 worlds
    And I currently have 3 worlds
    When I create a new world with name "Adventure Land"
    Then the world should be created successfully
    And the response should have status 201
    And my world count should increase to 4
    And I should see 1 remaining slot
    And a WorldCreated event should be published
    And the event should contain world details and owner information

  @api @limits @creation @validation
  Scenario: Block world creation when limit reached
    Given I have a basic subscription allowing 2 worlds
    And I already have 2 worlds:
      | world_name    | status |
      | World Alpha   | active |
      | World Beta    | active |
    When I attempt to create a new world with name "World Gamma"
    Then the creation should be blocked
    And the response should have status 403
    And the response should contain error "World creation limit reached"
    And the response should contain field "current_limit" with value 2
    And the response should contain field "current_usage" with value 2
    And I should see upgrade subscription options
    And a WorldCreationLimitReached event should be published
    And the event should contain user_id and current_tier

  @api @limits @creation
  Scenario Outline: World limits by subscription tier
    Given I have a "<tier>" subscription
    And I have 0 worlds currently
    When I check my world creation limit
    Then I should see a limit of <max_worlds> worlds
    And the response should contain field "tier" with value "<tier>"
    And the response should indicate if limit is "unlimited"

    Examples:
      | tier          | max_worlds |
      | free          | 1          |
      | basic         | 3          |
      | professional  | 10         |
      | enterprise    | unlimited  |

  @api @limits @creation @validation
  Scenario: Validate world creation request before limit check
    Given I have a basic subscription with available slots
    When I attempt to create a world with invalid data:
      | field       | value |
      | name        |       |
      | description | Test  |
    Then the response should have status 400
    And the response should contain validation error for "name"
    And no world should be created
    And no limit check should be consumed

  @api @limits @creation
  Scenario: World creation limit includes both active and inactive worlds
    Given I have a basic subscription allowing 3 worlds
    And I have 2 active worlds and 1 inactive world
    When I attempt to create a new world
    Then the creation should be blocked
    And I should see total world count is 3
    And I should see that inactive worlds count toward limit
    And I should see option to permanently delete worlds

  # ===========================================================================
  # SUBSCRIPTION UPGRADES
  # ===========================================================================

  @api @limits @subscription
  Scenario: Upgrade subscription to increase world limit
    Given I have a basic subscription with 3 world limit
    And I have 3 worlds at limit
    And I have valid payment method on file
    When I upgrade to professional subscription
    Then the upgrade should be processed successfully
    And my world limit should increase to 10
    And I should have 7 remaining slots
    And upgrade should take effect immediately
    And a SubscriptionUpgraded event should be published
    And the event should contain:
      | field           | value        |
      | previous_tier   | basic        |
      | new_tier        | professional |
      | new_world_limit | 10           |
    And I should receive confirmation email

  @api @limits @subscription
  Scenario: Downgrade subscription with excess worlds
    Given I have a professional subscription with 10 worlds
    And I currently have 8 active worlds
    When I request to downgrade to basic subscription with 3 world limit
    Then I should see a downgrade warning
    And the warning should indicate 5 excess worlds
    And I should be required to deactivate or delete 5 worlds
    And downgrade should not proceed until resolved
    And I should see a list of worlds to choose from
    And the downgrade request should be held pending

  @api @limits @subscription
  Scenario: Complete downgrade after resolving excess worlds
    Given I have a pending downgrade request
    And I need to remove 5 excess worlds
    When I deactivate 5 worlds:
      | world_name |
      | World E    |
      | World F    |
      | World G    |
      | World H    |
      | World I    |
    And I confirm the downgrade
    Then the downgrade should be processed
    And my subscription should change to basic
    And my world limit should be 3
    And a SubscriptionDowngraded event should be published

  @api @limits @subscription
  Scenario: Grace period for subscription expiration
    Given my subscription is set to expire in 3 days
    When subscription expires
    Then I should have a 7-day grace period
    And worlds should remain accessible during grace
    And I should receive renewal reminders on days 1, 3, and 7
    And after 7 days, worlds should be deactivated
    And I should receive final warning before deactivation
    And a SubscriptionGracePeriodStarted event should be published

  @api @limits @subscription
  Scenario: Subscription renewal during grace period
    Given my subscription has expired
    And I am in the 7-day grace period
    And my worlds are still accessible
    When I renew my subscription
    Then my subscription should be reactivated
    And all worlds should remain active
    And grace period should be cancelled
    And a SubscriptionRenewed event should be published
    And I should receive confirmation of renewal

  @api @limits @subscription
  Scenario: Failed subscription renewal
    Given my subscription is due for renewal
    And my payment method is invalid or declined
    When renewal is attempted
    Then renewal should fail
    And I should receive payment failure notification
    And grace period should start
    And I should have 7 days to update payment method
    And a SubscriptionRenewalFailed event should be published

  @api @limits @subscription
  Scenario: View subscription comparison before upgrade
    Given I have a basic subscription
    When I view upgrade options
    Then I should see comparison table:
      | feature             | basic | professional | enterprise |
      | max_worlds          | 3     | 10           | unlimited  |
      | max_npcs_per_world  | 50    | 200          | unlimited  |
      | storage_per_world   | 5GB   | 25GB         | 100GB      |
      | concurrent_players  | 100   | 500          | 10000      |
    And I should see pricing for each tier
    And I should see proration calculation

  # ===========================================================================
  # ACTIVE WORLD LIMITS
  # ===========================================================================

  @api @limits @active
  Scenario: Enforce active world limits
    Given I have a subscription allowing 5 active worlds
    And I have 5 active worlds:
      | world_name | status | player_count |
      | World A    | active | 25           |
      | World B    | active | 50           |
      | World C    | active | 10           |
      | World D    | active | 0            |
      | World E    | active | 100          |
    When I try to activate another world "World F"
    Then activation should be blocked
    And the response should have status 403
    And I should see error "Active world limit reached"
    And I should see which worlds can be deactivated
    And response should recommend deactivating "World D" with 0 players
    And an ActiveWorldLimitReached event should be published

  @api @limits @active
  Scenario: Deactivate world to activate another
    Given I have reached my active world limit of 3
    And I have active worlds:
      | world_name | status |
      | World A    | active |
      | World B    | active |
      | World C    | active |
    And I have a deactivated world "World D"
    When I deactivate "World A"
    Then "World A" should have status "inactive"
    And players connected to "World A" should be notified
    When I activate "World D"
    Then "World D" should have status "active"
    And my active count should remain at 3
    And WorldDeactivated and WorldActivated events should be published

  @api @limits @active
  Scenario: View active vs total world counts
    Given I have 10 total worlds with the following status:
      | world_name | status   |
      | World 1    | active   |
      | World 2    | active   |
      | World 3    | active   |
      | World 4    | active   |
      | World 5    | active   |
      | World 6    | inactive |
      | World 7    | inactive |
      | World 8    | inactive |
      | World 9    | inactive |
      | World 10   | inactive |
    And my active world limit is 5
    When I view my world dashboard
    Then I should see "5 of 10 worlds active"
    And I should see active world limit is 5
    And I should see each world's status clearly indicated
    And active worlds should show current player counts
    And I should see total storage usage across all worlds

  @api @limits @active
  Scenario: Cannot deactivate world with ongoing critical processes
    Given I have an active world "Critical World"
    And the world has an ongoing database migration
    When I attempt to deactivate "Critical World"
    Then deactivation should be blocked
    And I should see error "Cannot deactivate world with ongoing processes"
    And I should see list of blocking processes
    And I should see estimated completion time

  @api @limits @active
  Scenario: Schedule world deactivation
    Given I have an active world "Busy World" with 50 players
    When I schedule deactivation for "Busy World" in 24 hours
    Then a deactivation should be scheduled
    And all connected players should be notified
    And players should see countdown to deactivation
    And I should receive confirmation of scheduled deactivation
    And a WorldDeactivationScheduled event should be published

  # ===========================================================================
  # ENTITY LIMITS
  # ===========================================================================

  @api @limits @entity
  Scenario: Enforce entity limits per world
    Given my subscription allows 100 NPCs per world
    And my world "Adventure Land" has 100 NPCs
    When I try to create another NPC with name "New Character"
    Then creation should be blocked
    And the response should have status 403
    And I should see error "NPC limit reached for this world"
    And the response should contain:
      | field         | value |
      | entity_type   | npc   |
      | current_count | 100   |
      | limit         | 100   |
    And I should see options to upgrade or remove NPCs
    And an EntityLimitReached event should be published

  @api @limits @entity
  Scenario: Check multiple entity type limits
    Given my world has entity limits:
      | entity_type | limit | current |
      | npcs        | 100   | 80      |
      | items       | 500   | 450     |
      | quests      | 50    | 50      |
      | locations   | 200   | 150     |
    When I view entity usage for my world
    Then I should see usage for each entity type
    And I should see quests are at limit (50/50)
    And I should receive warning for items near limit (450/500)
    And the response should contain usage percentage for each type
    And types at 90%+ should be flagged as "warning"
    And types at 100% should be flagged as "limit_reached"

  @api @limits @entity
  Scenario Outline: Entity limits by subscription tier
    Given I have a "<tier>" subscription
    And I have a world named "Test World"
    When I check entity limits for "Test World"
    Then NPC limit should be <npc_limit>
    And item limit should be <item_limit>
    And quest limit should be <quest_limit>
    And location limit should be <location_limit>

    Examples:
      | tier          | npc_limit | item_limit | quest_limit | location_limit |
      | free          | 10        | 50         | 5           | 20             |
      | basic         | 50        | 200        | 25          | 100            |
      | professional  | 200       | 1000       | 100         | 500            |
      | enterprise    | unlimited | unlimited  | unlimited   | unlimited      |

  @api @limits @entity
  Scenario: Bulk import respects entity limits
    Given my world has 80 NPCs with limit of 100
    And I have prepared a bulk import file with 30 NPCs
    When I attempt to bulk import the NPCs
    Then import should be partially completed
    And 20 NPCs should be imported successfully
    And 10 NPCs should be skipped
    And the response should contain:
      | field           | value |
      | imported_count  | 20    |
      | skipped_count   | 10    |
      | new_total       | 100   |
    And I should see which NPCs were skipped with reasons
    And I should see options to increase limit
    And a BulkImportPartiallyCompleted event should be published

  @api @limits @entity
  Scenario: Bulk import completely blocked when at limit
    Given my world has 100 NPCs with limit of 100
    When I attempt to bulk import 10 NPCs
    Then import should be completely blocked
    And the response should have status 403
    And no NPCs should be imported
    And I should see error "Entity limit already reached"

  @api @limits @entity
  Scenario: Entity deletion frees up limit capacity
    Given my world has 100 NPCs with limit of 100
    When I delete 5 NPCs
    Then my NPC count should be 95
    And I should have 5 available NPC slots
    And I should be able to create new NPCs
    And entity deletion events should be published

  @api @limits @entity
  Scenario: Transferring entity between worlds respects limits
    Given I have world "Source World" with 50 NPCs
    And I have world "Target World" with 95 NPCs and limit of 100
    When I attempt to transfer 10 NPCs from "Source World" to "Target World"
    Then transfer should be partially completed
    And only 5 NPCs should be transferred
    And 5 NPCs should remain in "Source World"
    And I should see transfer summary

  # ===========================================================================
  # CONCURRENT PLAYER LIMITS
  # ===========================================================================

  @api @limits @players
  Scenario: Enforce concurrent player limits
    Given my world "Popular World" allows 100 concurrent players
    And 100 players are currently connected
    When player 101 attempts to join
    Then connection should be rejected
    And player should see "World at capacity" message
    And player should see current player count
    And player should be offered to join queue if enabled
    And a WorldCapacityReached event should be published
    And the event should contain world_id and player_count

  @api @limits @players
  Scenario: Player queue when world at capacity
    Given my world allows 100 concurrent players
    And 100 players are currently connected
    And queue system is enabled with max queue size of 50
    When player 101 attempts to join
    Then player should be added to queue
    And player should see queue position 1
    And player should see estimated wait time
    When a connected player disconnects
    Then player 101 should be automatically connected
    And queue should be empty

  @api @limits @players
  Scenario: Set custom player limits below subscription maximum
    Given my subscription allows up to 500 concurrent players
    And my world currently has no custom limit
    When I set my world limit to 200 players
    Then the world should only allow 200 concurrent players
    And the response should confirm limit set to 200
    And limit should take effect immediately
    And existing connections should not be affected
    And a WorldPlayerLimitChanged event should be published

  @api @limits @players
  Scenario: Cannot set player limit above subscription maximum
    Given my subscription allows up to 500 concurrent players
    When I attempt to set my world limit to 750 players
    Then the request should be rejected
    And I should see error "Cannot exceed subscription limit of 500"
    And I should see upgrade options for higher limits

  @api @limits @players
  Scenario: Priority queue for premium players
    Given my world is at capacity with 100 players
    And queue system is enabled
    And there are 10 standard players in queue
    When a premium player attempts to join
    Then premium player should be placed at position 1 in queue
    And standard players should see updated positions (2-11)
    And premium players should have priority factor of 2x
    And estimated wait times should be recalculated

  @api @limits @players
  Scenario: Handle player limit during peak times
    Given my world approaches player limit
    And current player count is 90 of 100 limit
    When usage reaches 90% capacity
    Then I should receive capacity warning notification
    And dashboard should show capacity alert
    And I should see options to temporarily increase limit
    And I should see burst pricing if available
    And a WorldCapacityWarning event should be published

  @api @limits @players
  Scenario: Temporary burst capacity increase
    Given my world is at 100 player limit
    And burst capacity is available for my subscription
    When I enable burst capacity for 2 hours
    Then player limit should temporarily increase to 150
    And burst pricing should be applied
    And I should see countdown to burst expiration
    And after 2 hours, limit should return to 100
    And excess players should be gracefully disconnected

  @api @limits @players
  Scenario: View real-time player connection metrics
    Given my world has 75 players connected
    And player limit is 100
    When I view player connection dashboard
    Then I should see:
      | metric                    | value |
      | current_players           | 75    |
      | player_limit              | 100   |
      | utilization_percentage    | 75%   |
      | peak_today                | 95    |
      | average_session_duration  | 45min |
    And I should see player connection trend graph
    And I should see geographic distribution

  # ===========================================================================
  # STORAGE LIMITS
  # ===========================================================================

  @api @limits @storage
  Scenario: Monitor world storage usage
    Given my subscription allows 10GB storage per world
    And my world "Content Rich" has various assets
    When I view storage usage for "Content Rich"
    Then I should see total used storage
    And I should see breakdown by asset type:
      | asset_type   | usage   | percentage |
      | images       | 2.5 GB  | 31%        |
      | audio        | 1.8 GB  | 23%        |
      | 3d_models    | 3.2 GB  | 40%        |
      | world_data   | 500 MB  | 6%         |
    And I should see total usage is 8GB of 10GB
    And I should see 2GB remaining space

  @api @limits @storage
  Scenario: Block upload when storage limit reached
    Given my world has used 9.9GB of 10GB storage
    When I attempt to upload a 200MB image asset
    Then upload should be blocked
    And the response should have status 413
    And I should see error "Storage limit exceeded"
    And the response should contain:
      | field           | value    |
      | current_usage   | 9.9GB    |
      | limit           | 10GB     |
      | available       | 0.1GB    |
      | required        | 0.2GB    |
    And I should see options to delete assets or upgrade
    And a StorageLimitReached event should be published

  @api @limits @storage
  Scenario: Storage warning thresholds at 80%
    Given my world storage is at 8GB of 10GB (80% capacity)
    When I view world dashboard
    Then I should see storage warning indicator
    And warning should show "Storage at 80% - consider cleanup"
    And I should receive email notification about storage
    And I should see cleanup recommendations
    And I should see largest assets that could be removed

  @api @limits @storage
  Scenario: Storage critical warning at 95%
    Given my world storage is at 9.5GB of 10GB (95% capacity)
    When I view world dashboard
    Then I should see critical storage warning
    And warning should show "Storage critically low"
    And I should receive urgent notification
    And some features may be restricted
    And a StorageCriticalWarning event should be published

  @api @limits @storage
  Scenario: Calculate storage by asset type
    Given my world has various assets stored
    When I view detailed storage breakdown
    Then I should see storage used by:
      | asset_type     | usage   | file_count |
      | images         | 2.5 GB  | 500        |
      | audio          | 1.8 GB  | 150        |
      | 3d_models      | 3.2 GB  | 75         |
      | world_data     | 500 MB  | 1          |
      | backups        | 1.0 GB  | 5          |
    And I should see which types consume most space
    And I should see average file size per type
    And I should see recommendations for optimization

  @api @limits @storage
  Scenario: Automatic image compression to save storage
    Given my world has storage optimization enabled
    When I upload a 50MB uncompressed image
    Then the image should be automatically compressed
    And compressed size should be approximately 5MB
    And original quality should be preserved for display
    And storage savings should be shown
    And an AssetOptimized event should be published

  @api @limits @storage
  Scenario: Identify and clean up unused assets
    Given my world has assets that are not referenced
    When I run storage cleanup analysis
    Then I should see list of unused assets:
      | asset_name      | size    | last_used   |
      | old_texture.png | 50MB    | 6 months    |
      | unused_sound.mp3| 25MB    | 1 year      |
      | draft_model.obj | 100MB   | never       |
    And I should see total potential savings
    And I should be able to bulk delete unused assets

  @api @limits @storage
  Scenario: Storage limit affects backup retention
    Given my world is at 95% storage capacity
    And automatic backups are enabled
    When a new backup is created
    Then oldest backup may be automatically deleted
    And I should receive notification about backup rotation
    And minimum backup retention policy should be maintained

  # ===========================================================================
  # WORLD ARCHIVING
  # ===========================================================================

  @api @limits @archive
  Scenario: Archive world to free up slots
    Given I have reached my active world limit of 5
    And I have an old world "Legacy World" with minimal activity
    When I archive "Legacy World"
    Then "Legacy World" should be moved to archive
    And the world status should change to "archived"
    And one active slot should be freed
    And I should now have 4 active worlds
    And I should be able to create a new world
    And archived world data should be preserved in cold storage
    And a WorldArchived event should be published
    And the event should contain archive_date and estimated_restore_time

  @api @limits @archive
  Scenario: Archive world with active players
    Given "Busy World" has 25 active players connected
    When I attempt to archive "Busy World"
    Then I should see warning about active players
    And warning should list player count: 25
    And I should be required to set shutdown notice period
    And minimum notice period should be 24 hours
    When I set notice period to 48 hours
    Then archive should be scheduled in 48 hours
    And all connected players should be notified
    And players should see countdown to archive
    And a WorldArchiveScheduled event should be published

  @api @limits @archive
  Scenario: View archived worlds
    Given I have archived multiple worlds over time
    When I view my archived worlds
    Then I should see all archived worlds:
      | world_name     | archive_date | storage_usage | restore_estimate |
      | Old Adventure  | 2024-01-15   | 2.5 GB        | 15 minutes       |
      | Test World     | 2024-03-20   | 500 MB        | 5 minutes        |
      | Legacy Game    | 2024-06-01   | 5 GB          | 25 minutes       |
    And I should see total archived storage usage
    And I should see restore options for each world
    And I should see archive retention policy

  @api @limits @archive
  Scenario: Archive retention policy warning
    Given a world has been archived for 330 days
    And retention policy deletes archives after 365 days
    When retention policy check runs
    Then I should receive warning about upcoming deletion
    And warning should indicate 35 days remaining
    And I should have option to restore or extend retention
    And a ArchiveRetentionWarning event should be published

  @api @limits @archive
  Scenario: Extend archive retention
    Given a world "Important Archive" is scheduled for deletion in 30 days
    When I request retention extension of 180 days
    Then retention should be extended
    And new deletion date should be 210 days from now
    And additional storage fees may apply
    And I should receive confirmation of extension

  @api @limits @archive
  Scenario: Archive deletion after retention period
    Given a world has been archived for 365 days
    And no retention extension was requested
    And final warning was sent 30 days ago
    When retention period expires
    Then archived data should be permanently deleted
    And I should receive deletion confirmation
    And storage should be freed
    And a WorldArchiveDeleted event should be published

  @api @limits @archive
  Scenario: Cancel scheduled archive
    Given "Busy World" has archive scheduled in 24 hours
    And players have been notified
    When I cancel the scheduled archive
    Then archive should be cancelled
    And world should remain active
    And players should be notified of cancellation
    And a WorldArchiveCancelled event should be published

  # ===========================================================================
  # WORLD RESTORATION
  # ===========================================================================

  @api @limits @restore
  Scenario: Restore archived world
    Given I have an archived world "Vintage World"
    And "Vintage World" was archived 6 months ago
    And I have an available active world slot
    When I restore "Vintage World"
    Then restoration process should start
    And I should see restoration progress
    And after restoration completes:
      | field        | value    |
      | status       | active   |
      | data_intact  | true     |
      | players_can_connect | true |
    And a WorldRestored event should be published
    And I should receive notification when restore is complete

  @api @limits @restore @validation
  Scenario: Cannot restore without available slot
    Given I have reached my active world limit of 5
    And I have an archived world "Old World"
    When I attempt to restore "Old World"
    Then restore should be blocked
    And the response should have status 403
    And I should see error "No active world slots available"
    And I should see current usage: 5 of 5 slots
    And I should see options:
      | option                    | description                    |
      | deactivate_world          | Free up a slot by deactivating |
      | upgrade_subscription      | Get more active world slots    |
      | archive_another_world     | Archive to free a slot         |

  @api @limits @restore
  Scenario: Restore world to specific version
    Given an archived world "Versioned World" has multiple backup versions:
      | version    | date        | description              |
      | v3         | 2024-06-01  | Final state before archive |
      | v2         | 2024-05-15  | Before major update      |
      | v1         | 2024-05-01  | Initial stable version   |
    When I initiate restore with version selection
    Then I should see available versions listed
    And I should see description for each version
    When I select version "v2" to restore
    Then the v2 version should be restored
    And world state should match May 15th backup
    And a WorldRestoredFromVersion event should be published

  @api @limits @restore
  Scenario: Restore progress tracking
    Given I have initiated restore for a large archived world (5GB)
    When I check restore progress
    Then I should see progress information:
      | field              | value        |
      | status             | in_progress  |
      | percentage         | 45%          |
      | data_restored      | 2.25 GB      |
      | estimated_remaining| 10 minutes   |
    And I should see which components are being restored
    And progress should update in real-time

  @api @limits @restore
  Scenario: Handle restore failure gracefully
    Given I have initiated restore for an archived world
    And restore process encounters an error
    When restore fails
    Then I should receive failure notification
    And failure reason should be provided
    And archived data should remain intact
    And I should be able to retry restore
    And a WorldRestoreFailed event should be published

  @api @limits @restore
  Scenario: Restore archived world with outdated schema
    Given an archived world uses an older data schema
    When I restore the world
    Then data migration should be performed automatically
    And I should see migration progress
    And world should work with current platform version
    And any migration issues should be reported

  # ===========================================================================
  # RATE LIMITING
  # ===========================================================================

  @api @limits @rate
  Scenario: Rate limit world creation requests
    Given rate limit is 5 world creations per hour
    And I have created 5 worlds within the last hour
    When I attempt to create a 6th world
    Then creation should be rate limited
    And the response should have status 429
    And I should see error "Rate limit exceeded"
    And the response should contain:
      | field          | value       |
      | limit          | 5 per hour  |
      | remaining      | 0           |
      | reset_at       | (timestamp) |
    And I should see when I can try again

  @api @limits @rate
  Scenario: Rate limit API calls per world
    Given API rate limit is 1000 calls per minute per world
    And my world "High Traffic" has made 1000 API calls this minute
    When another API call is made to "High Traffic"
    Then the call should be throttled
    And the response should have status 429
    And response header should contain "Retry-After"
    And rate limit reset time should be provided
    And a RateLimitExceeded event should be published

  @api @limits @rate
  Scenario: Different rate limits by endpoint type
    Given my world has endpoint-specific rate limits:
      | endpoint_type    | limit_per_minute |
      | read_operations  | 5000             |
      | write_operations | 500              |
      | search_queries   | 100              |
      | bulk_operations  | 10               |
    When I check rate limit status
    Then I should see remaining quota for each endpoint type
    And I should see reset times for each limit

  @api @limits @rate
  Scenario: Rate limit headers included in responses
    Given I make an API call to my world
    When the response is returned
    Then response headers should include:
      | header                  | description                |
      | X-RateLimit-Limit       | Maximum requests allowed   |
      | X-RateLimit-Remaining   | Requests remaining         |
      | X-RateLimit-Reset       | Time when limit resets     |
    And I can use these headers to manage my request rate

  @api @limits @rate
  Scenario: Burst allowance for rate limits
    Given my base rate limit is 100 requests per minute
    And burst allowance is 50 additional requests
    When I send 120 requests in 10 seconds
    Then all 120 requests should succeed (within burst)
    And burst allowance should be partially consumed
    And subsequent requests should be paced
    And burst should regenerate over time

  @api @limits @rate
  Scenario: Rate limit exemption for premium tiers
    Given I have an enterprise subscription
    When I check my rate limits
    Then I should see elevated rate limits:
      | limit_type           | value      |
      | api_calls_per_minute | 10000      |
      | world_creations_per_hour | 50     |
      | bulk_operations_per_hour | 100    |
    And some operations may be unlimited

  # ===========================================================================
  # LIMIT MONITORING AND ALERTS
  # ===========================================================================

  @api @limits @monitoring
  Scenario: Monitor all limits from dashboard
    Given I have multiple worlds with various usage levels
    When I view my limits dashboard
    Then I should see all limit types:
      | limit_type          | current | limit     | percentage |
      | active_worlds       | 4       | 5         | 80%        |
      | total_worlds        | 8       | 10        | 80%        |
      | total_storage       | 45GB    | 50GB      | 90%        |
      | concurrent_players  | 350     | 500       | 70%        |
    And I should see historical usage trends graph
    And approaching limits should be highlighted in yellow/red
    And I should see projected limit breach dates

  @api @limits @alerts
  Scenario: Configure limit alert thresholds
    Given I want to customize my alert settings
    When I configure alerts:
      | limit_type         | warning_threshold | critical_threshold |
      | storage            | 80%               | 95%                |
      | active_worlds      | 80%               | 100%               |
      | concurrent_players | 90%               | 100%               |
      | entity_counts      | 85%               | 95%                |
    Then alert configuration should be saved
    And alerts should trigger at configured thresholds
    And I should receive notifications appropriately
    And a LimitAlertConfigured event should be published

  @api @limits @alerts
  Scenario: Receive alert notifications through multiple channels
    Given I have configured alerts for storage at 80%
    And I have notification preferences:
      | channel    | enabled |
      | email      | true    |
      | webhook    | true    |
      | dashboard  | true    |
      | sms        | false   |
    When storage reaches 80%
    Then I should receive email notification
    And webhook should be triggered with alert payload
    And dashboard should show alert banner
    And SMS should not be sent

  @api @limits @monitoring
  Scenario: View limit usage history
    Given I want to analyze my usage patterns
    When I view usage history for the last 30 days
    Then I should see daily usage data:
      | date       | storage_used | active_players_peak | api_calls |
      | 2024-12-01 | 42GB         | 425                 | 150000    |
      | 2024-12-02 | 43GB         | 380                 | 145000    |
    And I should see trend analysis
    And I should see peak usage times
    And I should see growth rate projections

  @api @limits @alerts
  Scenario: Alert escalation for unresolved limits
    Given storage has been at 95% for 7 days
    And initial alert was sent but not addressed
    When escalation policy triggers
    Then additional notifications should be sent
    And escalation level should increase
    And account manager may be notified
    And a LimitAlertEscalated event should be published

  @api @limits @monitoring
  Scenario: Export limit usage report
    Given I need to analyze limit usage externally
    When I export limit usage report for the last quarter
    Then I should receive a downloadable report
    And report should include:
      | section                  |
      | usage_summary            |
      | daily_breakdown          |
      | peak_usage_analysis      |
      | limit_breach_incidents   |
      | recommendations          |
    And report should be available in CSV and PDF formats

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: WorldCreationLimitReached triggers upgrade prompt
    Given a user has reached their world creation limit
    When WorldCreationLimitReached event is published
    Then the event should contain:
      | field         | description              |
      | user_id       | The user who hit limit   |
      | current_tier  | User's subscription tier |
      | current_count | Number of worlds owned   |
      | limit         | Maximum allowed          |
    And upgrade options should be presented to user
    And usage analytics should be recorded
    And for enterprise prospects, sales team may be notified
    And marketing automation may trigger upgrade campaign

  @domain-events
  Scenario: EntityLimitReached triggers optimization suggestions
    Given a world has reached its NPC limit
    When EntityLimitReached event is published
    Then the event should contain:
      | field        | description                |
      | world_id     | The world at limit         |
      | entity_type  | Type of entity (npc, item) |
      | current_count| Current entity count       |
      | limit        | Maximum allowed            |
    And optimization suggestions should be generated
    And unused entities should be identified
    And upgrade path should be presented
    And a notification should be sent to world owner

  @domain-events
  Scenario: StorageLimitReached triggers cleanup workflow
    Given a world has reached its storage limit
    When StorageLimitReached event is published
    Then the event should contain:
      | field          | description              |
      | world_id       | The world at limit       |
      | current_usage  | Current storage used     |
      | limit          | Maximum storage allowed  |
      | largest_assets | Top 5 largest assets     |
    And cleanup recommendations should be generated
    And large unused assets should be identified
    And compression opportunities should be suggested
    And owner should receive notification with actionable items

  @domain-events
  Scenario: SubscriptionDowngraded triggers limit enforcement
    Given a user has downgraded their subscription
    When SubscriptionDowngraded event is published
    Then new limits should be calculated
    And if user exceeds new limits:
      | action                    | description                    |
      | worlds_deactivation_required | Excess worlds must be deactivated |
      | grace_period_started      | 30 days to comply              |
      | notifications_sent        | User informed of requirements  |
    And limit enforcement timeline should be established

  @domain-events
  Scenario: ConcurrentPlayerLimitReached triggers queue activation
    Given a world has reached player capacity
    When ConcurrentPlayerLimitReached event is published
    Then queue system should be activated if configured
    And capacity notification should be displayed
    And world owner should be notified
    And burst capacity option should be offered if available
    And metrics should be recorded for capacity planning

  @domain-events
  Scenario: LimitWarningThresholdReached triggers proactive notification
    Given a limit is approaching threshold (80%)
    When LimitWarningThresholdReached event is published
    Then proactive notification should be sent
    And notification should include:
      | field              | description                    |
      | limit_type         | Which limit is approaching     |
      | current_percentage | Current usage percentage       |
      | projected_breach   | Estimated date of breach       |
      | recommendations    | Actions to prevent breach      |
    And user should have time to take action

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle limit service unavailable
    Given limit checking service is experiencing issues
    When I attempt to create a world
    Then creation should fail safely
    And the response should have status 503
    And I should see "Limit service temporarily unavailable"
    And retry should be suggested after delay
    And response should include "Retry-After" header
    And a LimitServiceUnavailable event should be published

  @api @error
  Scenario: Handle limit calculation inconsistency
    Given cached limit data shows 3 worlds
    But actual count in database is 4 worlds
    When limit check is performed
    Then system should detect inconsistency
    And cache should be invalidated
    And fresh count should be fetched from database
    And correct limits should be applied
    And inconsistency should be logged for investigation
    And a LimitDataInconsistency event should be published

  @api @error @edge-case
  Scenario: Handle concurrent limit updates
    Given two browser sessions are open simultaneously
    And both attempt to update world limit settings
    When both submit changes at the same time
    Then one request should succeed
    And the other should receive conflict error (409)
    And conflict response should contain current limit values
    And user should be able to retry with fresh data

  @api @error
  Scenario: Handle subscription data sync failure
    Given subscription service is temporarily unavailable
    When I attempt to check my world limits
    Then cached subscription data should be used if available
    And I should see warning about potentially stale data
    And limits should be enforced conservatively
    And subscription sync should be retried in background

  @api @error @edge-case
  Scenario: Handle limit check during world deletion
    Given I am deleting "World A"
    And deletion is in progress
    When I simultaneously try to create a new world
    Then system should wait for deletion to complete
    Or system should use pessimistic count
    And race condition should be prevented
    And final world count should be accurate

  @api @error
  Scenario: Handle database transaction failure during limit update
    Given I am creating a new world
    And world creation succeeds
    But limit counter update fails
    When transaction fails
    Then world creation should be rolled back
    And user should see error message
    And limit count should remain accurate
    And retry should be possible
    And a LimitUpdateTransactionFailed event should be published

  @api @error
  Scenario: Handle invalid limit configuration
    Given an administrator attempts to configure limits
    When invalid configuration is provided:
      | field       | value | issue                    |
      | max_worlds  | -5    | Negative value           |
      | max_storage | abc   | Non-numeric value        |
    Then configuration should be rejected
    And validation errors should be returned
    And existing configuration should remain unchanged
    And invalid attempt should be logged

  @api @error @recovery
  Scenario: Recover from limit enforcement failure
    Given limit enforcement experienced a failure
    And some operations may have bypassed limits
    When recovery process runs
    Then actual counts should be reconciled
    And any over-limit resources should be identified
    And owners should be notified of discrepancies
    And grace period should be provided to resolve
    And a LimitReconciliationCompleted event should be published
