@world @settings @configuration @customization
Feature: World Owner Settings
  As a world owner
  I want to configure comprehensive world settings
  So that I can customize the experience for my players

  Background:
    Given I am logged in as the owner of "Epic Fantasy Realm"
    And I have world configuration permissions
    And the settings service is operational

  # ===========================================================================
  # GENERAL SETTINGS
  # ===========================================================================

  @api @settings @general
  Scenario: View settings categories
    Given my world has configurable settings
    When I navigate to world settings
    Then I should see a response with status 200
    And I should see settings categories:
      | category        | description                      | settings_count |
      | general         | Basic world information          | 12             |
      | gameplay        | Game mechanics and rules         | 25             |
      | economy         | Currency and trading             | 18             |
      | social          | Chat and community features      | 15             |
      | technical       | Server and performance           | 10             |
      | monetization    | Payments and purchases           | 8              |
      | privacy         | Data and visibility              | 10             |
    And I should see current values for each setting
    And I should see which settings require world restart
    And I should see last modified timestamp per category

  @api @settings @general
  Scenario: Edit world information
    Given I want to update my world's profile
    When I edit world information:
      | field           | value                      |
      | name            | Epic Fantasy Realm 2.0     |
      | description     | Updated adventure awaits   |
      | tagline         | Your legend begins here    |
      | category        | RPG Fantasy                |
      | age_rating      | Teen                       |
      | website         | https://epicfantasy.com    |
    Then the response should have status 200
    And information should be updated immediately
    And changes should be visible to players
    And search indexes should be updated
    And a WorldInfoUpdated event should be published

  @api @settings @general
  Scenario: Validate world name uniqueness
    Given another world exists with name "Popular World"
    When I attempt to change my world name to "Popular World"
    Then the request should be rejected
    And I should see error "World name already in use"
    And I should see suggestions for available names
    And original name should be preserved

  @api @settings @general
  Scenario: Upload world branding assets
    Given I want to update my world's visual identity
    When I upload branding assets:
      | asset_type     | file              | requirements                |
      | logo           | new_logo.png      | 512x512, PNG, < 1MB         |
      | banner         | world_banner.jpg  | 1920x480, JPG/PNG, < 2MB    |
      | icon           | app_icon.png      | 256x256, PNG, < 500KB       |
      | loading_screen | loading.jpg       | 1920x1080, JPG, < 3MB       |
      | favicon        | favicon.ico       | 32x32, ICO, < 50KB          |
    Then assets should be validated for size and format
    And assets should be optimized for delivery
    And assets should be applied to world
    And old assets should be archived for 30 days
    And a BrandingUpdated event should be published

  @api @settings @general
  Scenario: Reject invalid branding asset
    Given I upload an oversized logo
    When I submit a 5MB PNG file as logo
    Then the upload should be rejected
    And I should see error "File exceeds maximum size of 1MB"
    And I should see current asset requirements
    And existing logo should remain unchanged

  @api @settings @general
  Scenario: Configure world timezone
    Given I want to set my world's default timezone
    When I configure timezone settings:
      | field              | value              |
      | default_timezone   | America/New_York   |
      | display_format     | 12_hour            |
      | show_local_time    | true               |
    Then timezone should be applied
    And scheduled events should use this timezone
    And players should see times in their local zone option

  # ===========================================================================
  # GAMEPLAY MECHANICS
  # ===========================================================================

  @api @settings @gameplay
  Scenario: Configure core gameplay mechanics
    Given I want to customize how the game plays
    When I configure gameplay settings:
      | setting              | value      | description                    |
      | pvp_enabled          | true       | Allow player vs player combat  |
      | friendly_fire        | false      | Allies cannot damage each other|
      | death_penalty        | moderate   | XP and gold loss on death      |
      | respawn_time         | 30_seconds | Time before respawn            |
      | level_cap            | 100        | Maximum player level           |
      | auto_save            | true       | Save progress automatically    |
    Then settings should be applied immediately
    And active players should see changes reflected
    And settings should be logged in changelog
    And a GameplaySettingsUpdated event should be published

  @api @settings @gameplay
  Scenario: Configure combat settings
    Given I want to define combat behavior
    When I configure combat:
      | setting              | value       | options                        |
      | combat_style         | action      | action, turn_based, hybrid     |
      | auto_target          | enabled     | enabled, disabled, optional    |
      | damage_numbers       | visible     | visible, hidden, minimal       |
      | critical_multiplier  | 2.0         | 1.5 - 3.0                      |
      | dodge_enabled        | true        | true, false                    |
      | block_enabled        | true        | true, false                    |
    Then combat should behave according to settings
    And tutorial content should reflect combat style
    And UI should adapt to combat mode

  @api @settings @gameplay
  Scenario: Configure progression system
    Given I want to customize player advancement
    When I configure progression:
      | setting                  | value        |
      | xp_rate                  | 1.5x         |
      | skill_points_per_level   | 5            |
      | max_skills               | 20           |
      | respec_allowed           | true         |
      | respec_cost              | 1000_gold    |
      | prestige_enabled         | true         |
      | prestige_levels          | 10           |
    Then progression should follow these rules
    And player UI should reflect configuration
    And level-up notifications should show correct values

  @api @settings @gameplay
  Scenario: Configure quest system
    Given I want to set up quest mechanics
    When I configure quest settings:
      | setting                  | value        |
      | max_active_quests        | 25           |
      | daily_quest_limit        | 5            |
      | quest_sharing            | enabled      |
      | quest_tracking           | enabled      |
      | abandon_penalty          | none         |
      | repeatable_quests        | enabled      |
    Then quest system should operate with these limits
    And players should see quest limits in UI

  # ===========================================================================
  # CUSTOM DIFFICULTY
  # ===========================================================================

  @api @settings @difficulty
  Scenario: Create custom difficulty preset
    Given I want to offer unique challenge options
    When I create difficulty preset:
      | field             | value          |
      | name              | Nightmare Mode |
      | description       | For the bravest|
      | enemy_damage      | 200%           |
      | enemy_health      | 150%           |
      | enemy_aggro_range | 125%           |
      | loot_quality      | 125%           |
      | xp_bonus          | 175%           |
      | gold_bonus        | 150%           |
    Then difficulty should be created
    And difficulty should be available for selection
    And leaderboards should separate by difficulty
    And a DifficultyCreated event should be published

  @api @settings @difficulty
  Scenario: Set default difficulty
    Given multiple difficulties exist:
      | name       | modifier_average |
      | Easy       | 50%              |
      | Normal     | 100%             |
      | Hard       | 150%             |
      | Nightmare  | 200%             |
    When I set "Normal" as default difficulty
    Then new players should start on Normal
    And difficulty selection UI should show Normal as default
    And existing players should keep their selection

  @api @settings @difficulty
  Scenario: Disable difficulty option
    Given "Easy" difficulty exists and has players
    When I disable "Easy" difficulty
    Then I should see warning about affected players
    And I should select migration difficulty for affected players
    When I confirm migration to "Normal"
    Then affected players should be moved
    And "Easy" should no longer be selectable
    And a DifficultyDisabled event should be published

  @api @settings @difficulty
  Scenario Outline: Validate difficulty modifiers
    Given I am creating a difficulty preset
    When I set <modifier> to <value>
    Then validation should <result>
    And I should see <message>

    Examples:
      | modifier       | value | result | message                          |
      | enemy_damage   | 500%  | fail   | Maximum modifier is 400%         |
      | enemy_health   | 10%   | fail   | Minimum modifier is 25%          |
      | loot_quality   | 200%  | pass   | Setting accepted                 |
      | xp_bonus       | 0%    | fail   | XP bonus must be at least 25%    |

  # ===========================================================================
  # ECONOMY SETTINGS
  # ===========================================================================

  @api @settings @economy
  Scenario: Configure world economy
    Given I want to set up the economic system
    When I configure economy:
      | setting           | value         |
      | currency_name     | Dragon Coins  |
      | currency_symbol   | DC            |
      | starting_gold     | 100           |
      | gold_cap          | 1000000       |
      | vendor_prices     | standard      |
      | trade_enabled     | true          |
      | trade_tax         | 5%            |
      | mail_gold_enabled | true          |
    Then economy should operate with these rules
    And currency name should display in all UI
    And trade tax should be applied to transactions
    And an EconomyConfigured event should be published

  @api @settings @economy
  Scenario: Configure loot drop rates
    Given I want to balance item acquisition
    When I configure loot settings:
      | rarity      | drop_rate | color     |
      | common      | 60%       | #FFFFFF   |
      | uncommon    | 25%       | #1EFF00   |
      | rare        | 10%       | #0070DD   |
      | epic        | 4%        | #A335EE   |
      | legendary   | 1%        | #FF8000   |
    Then drops should follow these rates
    And I should see rate verification in drop logs
    And loot tables should use these base rates
    And total rates must equal 100%

  @api @settings @economy
  Scenario: Set up auction house
    Given I want players to trade via auction
    When I configure auction house:
      | setting           | value      |
      | enabled           | true       |
      | listing_fee       | 2%         |
      | sale_fee          | 5%         |
      | max_duration      | 7_days     |
      | min_duration      | 1_hour     |
      | buyout_enabled    | true       |
      | min_bid_increment | 5%         |
      | max_listings_per_player | 50   |
    Then auction house should be available
    And fees should be applied to transactions
    And listing limits should be enforced

  @api @settings @economy
  Scenario: Configure crafting system
    Given I want to enable player crafting
    When I configure crafting:
      | setting              | value      |
      | crafting_enabled     | true       |
      | success_rate_base    | 80%        |
      | quality_variance     | 10%        |
      | recipe_discovery     | enabled    |
      | salvage_enabled      | true       |
      | salvage_return_rate  | 25%        |
    Then crafting should use these parameters
    And crafting UI should reflect settings

  @api @settings @economy
  Scenario: Configure gold sinks
    Given I want to prevent economy inflation
    When I configure gold sinks:
      | sink_type            | cost       | frequency  |
      | repair_costs         | moderate   | per_use    |
      | fast_travel          | 50_gold    | per_use    |
      | auction_fees         | 5%         | per_sale   |
      | guild_maintenance    | 1000_gold  | weekly     |
      | respec_cost          | 1000_gold  | per_respec |
    Then gold sinks should be active
    And economy health should be monitored

  # ===========================================================================
  # SOCIAL FEATURES
  # ===========================================================================

  @api @settings @social
  Scenario: Configure social features
    Given I want to enable community features
    When I configure social settings:
      | setting           | value      |
      | chat_enabled      | true       |
      | voice_chat        | optional   |
      | guilds_enabled    | true       |
      | max_guild_size    | 100        |
      | friends_limit     | 200        |
      | emotes_enabled    | true       |
      | player_housing    | enabled    |
    Then social features should follow settings
    And limits should be enforced
    And a SocialSettingsUpdated event should be published

  @api @settings @social
  Scenario: Configure chat settings
    Given I want to define chat behavior
    When I configure chat:
      | setting              | value        |
      | global_chat          | enabled      |
      | zone_chat            | enabled      |
      | trade_chat           | enabled      |
      | whispers             | enabled      |
      | chat_cooldown        | 1_second     |
      | message_max_length   | 500          |
      | links_allowed        | false        |
      | emoji_enabled        | true         |
      | profanity_filter     | strict       |
    Then chat should behave according to settings
    And moderation should apply to all channels
    And filter violations should be logged

  @api @settings @social
  Scenario: Configure party and group settings
    Given I want to set group mechanics
    When I configure grouping:
      | setting              | value        |
      | max_party_size       | 5            |
      | raid_size            | 40           |
      | auto_loot            | round_robin  |
      | loot_threshold       | rare         |
      | need_before_greed    | enabled      |
      | group_finder         | enabled      |
      | cross_realm_groups   | disabled     |
    Then group mechanics should follow settings
    And party UI should reflect limits

  @api @settings @social
  Scenario: Configure guild settings
    Given I want to customize guild features
    When I configure guild settings:
      | setting              | value        |
      | guild_creation_cost  | 10000_gold   |
      | guild_bank_enabled   | true         |
      | guild_ranks          | 10           |
      | guild_perks          | enabled      |
      | guild_wars           | disabled     |
      | alliance_size        | 5_guilds     |
    Then guild system should use these settings
    And guild creation should charge fee

  # ===========================================================================
  # TECHNICAL PARAMETERS
  # ===========================================================================

  @api @settings @technical
  Scenario: Configure technical parameters
    Given I want to optimize world performance
    When I configure technical settings:
      | setting              | value      | requires_restart |
      | tick_rate            | 30         | yes              |
      | max_concurrent_users | 1000       | yes              |
      | auto_save_interval   | 5_minutes  | no               |
      | session_timeout      | 30_minutes | no               |
      | reconnect_grace      | 5_minutes  | no               |
      | afk_timeout          | 15_minutes | no               |
    Then settings requiring restart should be queued
    And other settings should apply immediately
    And I should see restart scheduling option

  @api @settings @technical
  Scenario: Configure server regions
    Given I want to optimize for my player base
    When I configure server regions:
      | region        | enabled | capacity | priority |
      | us-east       | true    | 500      | primary  |
      | us-west       | true    | 300      | secondary|
      | eu-west       | true    | 400      | primary  |
      | asia-pacific  | false   | 0        | disabled |
    Then world should be available in enabled regions
    And players should connect to nearest region
    And capacity limits should be enforced
    And a ServerRegionsUpdated event should be published

  @api @settings @technical
  Scenario: Configure world sharding
    Given I expect high player counts
    When I configure sharding:
      | setting              | value        |
      | sharding_enabled     | true         |
      | players_per_shard    | 200          |
      | shard_balancing      | automatic    |
      | cross_shard_chat     | enabled      |
      | shard_transfers      | on_request   |
    Then sharding should be configured
    And players should be distributed across shards
    And cross-shard features should work

  @api @settings @technical
  Scenario: Configure content delivery
    Given I want to optimize asset loading
    When I configure CDN settings:
      | setting              | value        |
      | cdn_enabled          | true         |
      | cache_duration       | 24_hours     |
      | compression          | gzip         |
      | lazy_loading         | enabled      |
    Then assets should be served via CDN
    And load times should improve

  # ===========================================================================
  # MONETIZATION
  # ===========================================================================

  @api @settings @monetization
  Scenario: Configure monetization options
    Given I want to generate revenue
    When I configure monetization:
      | setting           | value       |
      | premium_enabled   | true        |
      | premium_price     | $9.99/month |
      | cosmetics_store   | enabled     |
      | pay_to_win        | disabled    |
      | ads_enabled       | false       |
      | gift_cards        | enabled     |
    Then monetization should follow settings
    And store should display allowed items
    And a MonetizationConfigured event should be published

  @api @settings @monetization
  Scenario: Configure premium subscription benefits
    Given I offer premium subscriptions
    When I configure premium benefits:
      | benefit              | value        |
      | xp_bonus             | 25%          |
      | gold_bonus           | 15%          |
      | exclusive_cosmetics  | true         |
      | priority_queue       | true         |
      | extra_character_slots| 2            |
      | reduced_cooldowns    | 10%          |
    Then premium members should receive benefits
    And benefits should be clearly displayed
    And non-premium players should see upgrade prompts

  @api @settings @monetization
  Scenario: Configure in-app purchases
    Given I want to sell virtual items
    When I configure IAP:
      | setting              | value    |
      | currency_packs       | enabled  |
      | cosmetic_items       | enabled  |
      | convenience_items    | enabled  |
      | power_items          | disabled |
      | refund_policy        | standard |
      | purchase_limits      | enabled  |
      | daily_spend_cap      | $100     |
    Then store should offer allowed items only
    And purchase restrictions should be enforced
    And spending caps should prevent excessive purchases

  @api @settings @monetization
  Scenario: Configure battle pass
    Given I want seasonal content monetization
    When I configure battle pass:
      | setting              | value        |
      | battle_pass_enabled  | true         |
      | season_duration      | 90_days      |
      | free_track_levels    | 50           |
      | premium_track_levels | 100          |
      | premium_price        | $14.99       |
      | catch_up_mechanic    | enabled      |
    Then battle pass should be available
    And progression should track properly
    And rewards should be distributed at milestones

  # ===========================================================================
  # NOTIFICATIONS
  # ===========================================================================

  @api @settings @notifications
  Scenario: Configure notification defaults
    Given I want to set notification preferences
    When I configure notification settings:
      | notification_type    | in_game | push   | email  |
      | world_announcements  | true    | true   | true   |
      | maintenance_alerts   | true    | true   | true   |
      | event_reminders      | true    | true   | false  |
      | achievement_unlocks  | true    | false  | false  |
      | friend_activity      | true    | false  | false  |
      | guild_updates        | true    | true   | false  |
    Then these become default for new players
    And existing players keep their preferences
    And players can override personally

  @api @settings @notifications
  Scenario: Configure announcement system
    Given I want to communicate with players
    When I configure announcements:
      | setting              | value        |
      | announcement_banner  | enabled      |
      | banner_duration      | 10_seconds   |
      | dismissible          | true         |
      | audio_notification   | optional     |
      | urgent_override      | enabled      |
    Then announcement system should follow settings
    And urgent messages should always display

  # ===========================================================================
  # PRIVACY OPTIONS
  # ===========================================================================

  @api @settings @privacy
  Scenario: Configure privacy options
    Given I want to protect player privacy
    When I configure privacy settings:
      | setting              | value       |
      | player_profiles      | public      |
      | activity_visibility  | friends     |
      | location_sharing     | opt_in      |
      | data_collection      | minimal     |
      | gdpr_compliant       | true        |
      | ccpa_compliant       | true        |
      | analytics_enabled    | anonymized  |
    Then privacy settings should be enforced
    And compliance should be documented
    And a PrivacySettingsUpdated event should be published

  @api @settings @privacy
  Scenario: Configure data retention
    Given I need to manage data lifecycle
    When I configure data retention:
      | data_type            | retention      |
      | chat_logs            | 30_days        |
      | player_data          | account_life   |
      | analytics            | 1_year         |
      | deleted_accounts     | 90_days        |
      | transaction_records  | 7_years        |
      | moderation_logs      | 2_years        |
    Then data should be managed per policy
    And automated cleanup should occur on schedule
    And retention compliance should be monitored

  @api @settings @privacy
  Scenario: Configure player data controls
    Given I want players to control their data
    When I configure data controls:
      | control              | enabled  |
      | data_export          | true     |
      | data_deletion        | true     |
      | marketing_opt_out    | true     |
      | third_party_sharing  | opt_in   |
    Then data control options should be available
    And player requests should be processed within SLA

  # ===========================================================================
  # WORLD DISCOVERY
  # ===========================================================================

  @api @settings @discovery
  Scenario: Configure world discovery
    Given I want my world to be found
    When I configure discovery settings:
      | setting              | value      |
      | listed_publicly      | true       |
      | searchable           | true       |
      | featured_eligible    | true       |
      | age_gate             | 13+        |
      | invite_only          | false      |
      | newcomer_friendly    | true       |
    Then world should appear in discovery
    And search should include world
    And appropriate age gates should be applied

  @api @settings @discovery
  Scenario: Configure SEO and metadata
    Given I want to optimize discoverability
    When I configure metadata:
      | field                | value                              |
      | meta_description     | Epic fantasy adventure awaits      |
      | keywords             | rpg, fantasy, multiplayer, quests  |
      | og_image             | social_preview.jpg                 |
      | twitter_card         | summary_large_image                |
    Then metadata should be applied
    And social sharing should use these values

  @api @settings @discovery
  Scenario: Configure join requirements
    Given I want to control who can join
    When I configure join requirements:
      | requirement          | value      |
      | email_verified       | true       |
      | minimum_account_age  | 7_days     |
      | application_required | false      |
      | invite_code          | optional   |
      | captcha_required     | true       |
      | region_restrictions  | none       |
    Then requirements should be enforced on join
    And rejected players should see clear reasons
    And approved players should join seamlessly

  @api @settings @discovery
  Scenario: Configure world capacity
    Given I want to manage player population
    When I configure capacity settings:
      | setting              | value      |
      | max_players          | 5000       |
      | queue_enabled        | true       |
      | queue_priority_vip   | true       |
      | overflow_handling    | waitlist   |
    Then capacity should be enforced
    And queue should manage overflow
    And VIP players should get priority

  # ===========================================================================
  # BACKUP AND RECOVERY
  # ===========================================================================

  @api @settings @backup
  Scenario: Configure backup schedule
    Given I want to protect world data
    When I configure backups:
      | setting              | value        |
      | auto_backup          | enabled      |
      | frequency            | every_6_hours|
      | retention            | 30_days      |
      | include_player_data  | true         |
      | include_chat_logs    | false        |
      | compression          | enabled      |
    Then backups should run on schedule
    And I should see backup history
    And a BackupScheduleConfigured event should be published

  @api @settings @backup
  Scenario: Configure disaster recovery
    Given I need robust recovery options
    When I configure recovery options:
      | setting              | value      |
      | point_in_time        | enabled    |
      | max_recovery_window  | 7_days     |
      | cross_region_backup  | true       |
      | automated_failover   | enabled    |
      | recovery_testing     | monthly    |
    Then recovery options should be available
    And I should be able to test recovery
    And failover should be configured

  @api @settings @backup
  Scenario: View backup history
    Given backups have been running
    When I view backup history
    Then I should see recent backups:
      | backup_id    | timestamp           | size   | status    |
      | BK-001       | 2024-12-28 02:00    | 5.2 GB | completed |
      | BK-002       | 2024-12-27 20:00    | 5.1 GB | completed |
      | BK-003       | 2024-12-27 14:00    | 5.1 GB | completed |
    And I should be able to restore from any backup
    And I should see storage usage

  # ===========================================================================
  # API ACCESS
  # ===========================================================================

  @api @settings @api
  Scenario: Configure API access
    Given I want to enable integrations
    When I configure API settings:
      | setting              | value      |
      | api_enabled          | true       |
      | rate_limit           | 1000/min   |
      | webhook_enabled      | true       |
      | public_endpoints     | limited    |
      | auth_required        | true       |
      | api_version          | v2         |
    Then API should follow configuration
    And documentation should reflect settings
    And an APIConfigured event should be published

  @api @settings @api
  Scenario: Manage API keys
    Given I need to create API access
    When I create API key:
      | field                | value              |
      | name                 | Discord Bot        |
      | permissions          | read_players       |
      | rate_limit           | 100/min            |
      | expires              | 2025-12-31         |
      | ip_whitelist         | 192.168.1.0/24     |
    Then API key should be generated
    And I should see the key only once
    And key should have specified restrictions

  @api @settings @api
  Scenario: Configure webhooks
    Given I want real-time event notifications
    When I configure webhooks:
      | event                | url                          | active |
      | player_joined        | https://api.example.com/join | true   |
      | player_achievement   | https://api.example.com/ach  | true   |
      | purchase_completed   | https://api.example.com/buy  | true   |
      | player_left          | https://api.example.com/left | false  |
    Then webhooks should fire on active events
    And delivery should be verified
    And failed deliveries should be retried

  @api @settings @api
  Scenario: View webhook delivery logs
    Given webhooks have been firing
    When I view webhook logs
    Then I should see delivery history:
      | event            | url                      | status  | response_time |
      | player_joined    | https://api.example.com  | 200 OK  | 45ms          |
      | purchase_completed| https://api.example.com | 200 OK  | 52ms          |
      | player_joined    | https://api.example.com  | timeout | 30000ms       |
    And I should see retry status for failures
    And I should be able to replay failed webhooks

  # ===========================================================================
  # ADVANCED OPTIONS
  # ===========================================================================

  @api @settings @advanced
  Scenario: Access advanced options
    Given I need to configure advanced settings
    When I access advanced settings
    Then I should see warning about potential impact
    And I should see advanced settings:
      | setting              | description                        | risk_level |
      | debug_mode           | Enable verbose logging             | low        |
      | experimental_features| Access beta features               | medium     |
      | custom_scripts       | Run custom game logic              | high       |
      | override_limits      | Remove platform restrictions       | high       |
    And changes should require explicit confirmation

  @api @settings @advanced
  Scenario: Enable experimental features
    Given there are experimental features available
    When I enable experimental feature "new_combat_system":
      | field              | value                              |
      | feature            | new_combat_system                  |
      | acknowledgment     | I understand the risks             |
      | rollback_plan      | can_disable_anytime                |
    Then I should see feature description and risks
    And feature should be enabled
    And feature should be flagged as experimental in UI
    And an ExperimentalFeatureEnabled event should be published

  @api @settings @advanced
  Scenario: Configure custom scripts
    Given I have developer permissions
    When I configure custom script:
      | field              | value                    |
      | script_name        | holiday_event            |
      | trigger            | on_player_login          |
      | sandbox_mode       | enabled                  |
      | resource_limits    | standard                 |
    Then script should be validated for safety
    And script should run in sandbox
    And resource usage should be monitored

  # ===========================================================================
  # TEMPLATES AND PRESETS
  # ===========================================================================

  @api @settings @templates
  Scenario: Apply settings template
    Given settings templates are available:
      | template_name    | description                    |
      | Competitive PvP  | Settings for competitive play  |
      | Casual PvE       | Relaxed PvE experience         |
      | Hardcore         | Maximum difficulty             |
      | Family Friendly  | Safe for all ages              |
    When I apply template "Competitive PvP"
    Then settings should be configured per template
    And I should see what settings changed
    And I should be able to customize further
    And a TemplateApplied event should be published

  @api @settings @templates
  Scenario: Save current settings as template
    Given I have customized my settings
    When I save as template:
      | field              | value                    |
      | name               | My Custom Setup          |
      | description        | Balanced RPG experience  |
      | category           | RPG                      |
      | shareable          | true                     |
    Then template should be saved
    And I should be able to apply to other worlds
    And template should be shareable with others
    And a TemplateCreated event should be published

  @api @settings @templates
  Scenario: Import community template
    Given community templates are available
    When I browse community templates
    Then I should see popular templates:
      | template_name    | author       | downloads | rating |
      | Ultimate RPG     | TopCreator   | 15,432    | 4.8    |
      | Competitive Arena| ProGamer     | 8,234     | 4.6    |
    And I should be able to preview settings
    And I should be able to import and modify

  # ===========================================================================
  # CHANGELOG AND HISTORY
  # ===========================================================================

  @api @settings @changelog
  Scenario: View settings changelog
    Given settings have been modified over time
    When I view settings changelog
    Then I should see all setting changes:
      | timestamp           | setting          | old_value | new_value | changed_by |
      | 2024-12-28 10:00    | pvp_enabled      | false     | true      | AdminUser  |
      | 2024-12-27 15:30    | max_party_size   | 4         | 5         | AdminUser  |
      | 2024-12-26 09:00    | xp_rate          | 1.0x      | 1.5x      | AdminUser  |
    And I should see who made each change
    And I should be able to filter by setting or date
    And I should be able to export changelog

  @api @settings @changelog
  Scenario: Revert setting to previous value
    Given "xp_rate" was changed from 1.0x to 1.5x yesterday
    When I revert "xp_rate" to previous value
    Then setting should be restored to 1.0x
    And revert should be logged in changelog
    And I should see confirmation message
    And a SettingReverted event should be published

  @api @settings @changelog
  Scenario: View setting history for specific setting
    Given I want to see history of one setting
    When I view history for "pvp_enabled"
    Then I should see all changes to this setting:
      | timestamp           | old_value | new_value | changed_by | reason         |
      | 2024-12-28 10:00    | false     | true      | AdminUser  | Event launch   |
      | 2024-11-01 12:00    | true      | false     | AdminUser  | Maintenance    |
      | 2024-06-15 08:00    | false     | true      | AdminUser  | Initial setup  |
    And I should be able to restore any historical value

  # ===========================================================================
  # EXPORT AND IMPORT
  # ===========================================================================

  @api @settings @export
  Scenario: Export world settings
    Given I want to backup or share settings
    When I export settings:
      | option               | value      |
      | format               | JSON       |
      | include_sensitive    | false      |
      | include_api_keys     | false      |
      | include_history      | false      |
    Then I should receive settings file
    And sensitive settings should be excluded
    And export should be downloadable
    And a SettingsExported event should be published

  @api @settings @export
  Scenario: Import settings from file
    Given I have a settings file to import
    When I import the settings:
      | field              | value                    |
      | file               | world_settings.json      |
      | merge_mode         | overwrite                |
      | validate_first     | true                     |
    Then settings should be validated
    And conflicts should be highlighted:
      | setting          | current_value | import_value | conflict |
      | pvp_enabled      | true          | false        | yes      |
      | max_party_size   | 5             | 5            | no       |
    And I should confirm before applying
    And import should be logged
    And a SettingsImported event should be published

  @api @settings @export
  Scenario: Validate import file
    Given I upload an invalid settings file
    When validation runs
    Then I should see validation errors:
      | field            | error                          |
      | xp_rate          | Value 10x exceeds maximum 5x   |
      | unknown_setting  | Setting not recognized         |
    And import should be blocked
    And I should see how to fix errors

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: SettingsChanged triggers player notification
    Given players are online
    When significant setting changes (e.g., PvP enabled)
    Then SettingsChanged event should be published
    And the event should contain:
      | field           | description                    |
      | setting_name    | Which setting changed          |
      | old_value       | Previous value                 |
      | new_value       | New value                      |
      | changed_by      | Who made the change            |
    And affected players should be notified
    And change summary should be displayed
    And changelog should be updated

  @domain-events
  Scenario: CriticalSettingChanged requires confirmation
    Given a setting affects gameplay significantly
    When critical setting is modified
    Then CriticalSettingChanged event should be published
    And additional confirmation should be required
    And change should be logged with elevated detail
    And notification should go to all co-owners/admins
    And rollback should be easily available

  @domain-events
  Scenario: SettingsScheduledChange queues future change
    Given I schedule a setting change
    When scheduled time arrives
    Then change should be applied automatically
    And SettingsScheduledChangeApplied event should be published
    And players should be notified
    And I should receive confirmation

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle invalid setting value
    Given I am editing settings
    When I enter invalid value for "max_party_size" as -5
    Then validation should reject the value
    And I should see error "Party size must be between 2 and 40"
    And setting should retain previous value
    And form should highlight the error

  @api @error
  Scenario: Handle settings conflict
    Given two admins are editing settings simultaneously
    And Admin A changes "pvp_enabled" to true
    When Admin B submits change to "pvp_enabled" as false
    Then Admin B should see conflict notification
    And current value (true) should be displayed
    And Admin B should choose to override or cancel
    And conflict should be logged

  @api @error
  Scenario: Handle settings service unavailable
    Given settings service is experiencing issues
    When I attempt to save settings
    Then I should see service error message
    And changes should be queued locally
    And I should be notified when service recovers
    And auto-retry should occur

  @api @error
  Scenario: Recover from failed settings update
    Given a settings update partially failed
    When I view settings status
    Then I should see which settings applied
    And I should see which settings failed
    And I should be able to retry failed settings
    And rollback option should be available
