@world @dashboard @analytics @management
Feature: World Owner Dashboard
  As a world owner
  I want to access a comprehensive dashboard for my world
  So that I can effectively manage and monitor my game world

  Background:
    Given I am logged in as a world owner
    And I own the world "Epic Fantasy Realm"
    And I have world management permissions
    And the dashboard service is operational

  # ===========================================================================
  # DASHBOARD OVERVIEW
  # ===========================================================================

  @api @dashboard
  Scenario: View world owner dashboard
    Given my world has active players and content
    When I navigate to my world dashboard
    Then I should see a response with status 200
    And I should see world status summary:
      | field            | description                    |
      | world_name       | Epic Fantasy Realm             |
      | status           | online                         |
      | uptime           | 99.9%                          |
      | last_restart     | 3 days ago                     |
    And I should see key metrics at a glance:
      | metric           | value     |
      | online_players   | 127       |
      | daily_active     | 1,245     |
      | monthly_active   | 8,932     |
      | storage_used     | 8.5 GB    |
    And I should see recent activity feed
    And I should see pending actions requiring attention
    And I should see quick action buttons

  @api @dashboard
  Scenario: View dashboard for multiple worlds
    Given I own 3 worlds:
      | world_name          | status   | players_online |
      | Epic Fantasy Realm  | online   | 127            |
      | Sci-Fi Adventures   | online   | 89             |
      | Mystery Manor       | offline  | 0              |
    When I view my dashboard
    Then I should see a world selector dropdown
    And I should be able to switch between worlds
    And metrics should update for selected world
    And I should see aggregate view option
    When I select aggregate view
    Then I should see combined metrics across all worlds

  @api @dashboard
  Scenario: View dashboard first-time experience
    Given I am a new world owner
    And I have just created my first world
    When I first access the dashboard
    Then I should see onboarding guidance overlay
    And I should see recommended setup steps:
      | step | task                        | status   |
      | 1    | Configure world settings    | pending  |
      | 2    | Create initial content      | pending  |
      | 3    | Set up moderation rules     | pending  |
      | 4    | Invite players              | pending  |
    And I should see help resources sidebar
    And I should be able to dismiss onboarding
    And onboarding progress should be saved

  @api @dashboard
  Scenario: View dashboard loading states
    Given I am accessing a large world with extensive data
    When I navigate to the dashboard
    Then I should see loading indicators for each widget
    And widgets should load progressively
    And critical metrics should load first
    And I should see skeleton placeholders during load

  # ===========================================================================
  # DASHBOARD CUSTOMIZATION
  # ===========================================================================

  @api @dashboard @customization
  Scenario: Customize dashboard layout
    Given I am viewing my dashboard
    When I enter dashboard customization mode
    Then I should see customization controls
    And I should be able to drag and drop widgets
    And I should see grid guidelines for alignment
    And I should be able to resize widgets by dragging corners
    And I should be able to add widgets from available catalog:
      | widget_name          | category      |
      | player_map           | players       |
      | revenue_chart        | financial     |
      | server_status        | health        |
      | moderation_queue     | moderation    |
    And I should be able to remove widgets
    And changes should save automatically
    And I should see "Unsaved changes" indicator while editing

  @api @dashboard @customization
  Scenario: Add widget from catalog
    Given I am in customization mode
    When I browse the widget catalog
    Then I should see available widgets organized by category
    And each widget should show preview and description
    When I add "Player Heatmap" widget
    Then the widget should appear on my dashboard
    And I should be able to position it
    And widget should start loading data

  @api @dashboard @customization
  Scenario: Save dashboard layout preset
    Given I have customized my dashboard layout
    When I save the layout as "Operations View"
    Then the preset should be saved successfully
    And I should see confirmation message
    And "Operations View" should appear in my presets list
    When I create another layout and save as "Financial View"
    Then I should have multiple presets available
    And I should be able to switch between presets instantly
    And presets should persist across sessions and devices

  @api @dashboard @customization
  Scenario: Load saved dashboard preset
    Given I have saved presets:
      | preset_name      | widget_count |
      | Operations View  | 8            |
      | Financial View   | 6            |
      | Minimal View     | 4            |
    When I select "Financial View" preset
    Then dashboard should switch to that layout
    And all widgets from preset should load
    And my current view should update immediately

  @api @dashboard @customization
  Scenario: Reset dashboard to default
    Given I have a heavily customized dashboard
    When I reset to default layout
    Then standard widgets should be restored:
      | widget              |
      | status_summary      |
      | player_stats        |
      | recent_activity     |
      | quick_actions       |
      | health_monitor      |
    And custom presets should remain available
    And I should be able to restore my custom layout

  @api @dashboard @customization
  Scenario: Configure individual widget settings
    Given I have a "Player Statistics" widget on my dashboard
    When I configure the widget settings
    Then I should be able to set:
      | setting          | options                          |
      | time_range       | 24h, 7d, 30d, custom             |
      | display_type     | chart, table, number             |
      | refresh_interval | 1m, 5m, 15m, 30m, manual         |
      | metrics_shown    | online, dau, mau, retention      |
    And settings should be saved per widget
    And widget should update based on settings

  # ===========================================================================
  # WORLD HEALTH MONITORING
  # ===========================================================================

  @api @dashboard @health
  Scenario: Monitor world health status
    Given my world has various components running
    When I view world health section
    Then I should see overall health score (0-100)
    And health score should be color coded:
      | score_range | color  | status   |
      | 90-100      | green  | healthy  |
      | 70-89       | yellow | warning  |
      | 0-69        | red    | critical |
    And I should see status for each component:
      | component        | status  | latency_ms | uptime   |
      | game_servers     | healthy | 45         | 99.99%   |
      | database         | healthy | 12         | 99.95%   |
      | ai_services      | warning | 250        | 98.5%    |
      | content_delivery | healthy | 85         | 99.9%    |
      | auth_service     | healthy | 30         | 99.99%   |
    And I should see health history trend for last 24 hours

  @api @dashboard @health
  Scenario: View health alert details
    Given a component "ai_services" shows warning status
    When I click on the warning indicator
    Then I should see alert details:
      | field            | value                              |
      | component        | ai_services                        |
      | status           | warning                            |
      | current_latency  | 250ms                              |
      | threshold        | 200ms                              |
      | started_at       | 2024-12-28 14:30:00                |
      | duration         | 45 minutes                         |
    And I should see potential causes:
      | cause                              | likelihood |
      | High API request volume            | 75%        |
      | Upstream service degradation       | 20%        |
      | Configuration issue                | 5%         |
    And I should see recommended actions
    And I should see incident timeline

  @api @dashboard @health
  Scenario: Configure health alert thresholds
    Given I want to customize when alerts trigger
    When I configure health monitoring thresholds:
      | metric           | warning | critical | enabled |
      | response_time_ms | 500     | 1000     | true    |
      | error_rate       | 2%      | 5%       | true    |
      | cpu_usage        | 70%     | 90%      | true    |
      | memory_usage     | 75%     | 90%      | true    |
      | disk_usage       | 80%     | 95%      | true    |
    Then thresholds should be applied immediately
    And alerts should trigger at configured levels
    And I should see threshold lines on graphs
    And a HealthThresholdsUpdated event should be published

  @api @dashboard @health
  Scenario: View historical health data
    Given I want to analyze past health issues
    When I view health history for last 30 days
    Then I should see:
      | metric                  | value    |
      | overall_uptime          | 99.85%   |
      | incidents_count         | 3        |
      | mean_time_to_resolution | 25 min   |
      | longest_outage          | 45 min   |
    And I should see incident timeline
    And I should be able to drill into each incident

  @api @dashboard @health
  Scenario: Acknowledge health alert
    Given there is an active health warning
    When I acknowledge the alert
    Then alert should be marked as acknowledged
    And acknowledgment time should be recorded
    And escalation should be paused
    And I should set expected resolution time

  # ===========================================================================
  # RECENT ACTIVITY
  # ===========================================================================

  @api @dashboard @activity
  Scenario: View recent world activity
    Given my world has various activities occurring
    When I view the activity feed
    Then I should see recent events chronologically:
      | timestamp           | event_type       | description                    |
      | 2 min ago           | player_milestone | DragonSlayer reached level 50  |
      | 15 min ago          | moderation       | ToxicPlayer banned by ModBot   |
      | 30 min ago          | system           | Auto-backup completed          |
      | 1 hour ago          | content          | New quest "Dark Forest" created|
    And events should include player milestones
    And events should include system events
    And events should include moderation actions
    And I should be able to filter by event type

  @api @dashboard @activity
  Scenario: Filter activity by event type
    Given I want to see only moderation activity
    When I filter activity feed by "moderation"
    Then I should only see moderation-related events
    And filter should be applied instantly
    And I should see filtered event count
    And I should be able to apply multiple filters

  @api @dashboard @activity
  Scenario: View activity for specific time range
    Given I want to analyze yesterday's activity
    When I select "Last 24 hours" time range
    Then activity should be filtered to that period
    And I should see activity volume comparison:
      | period       | event_count |
      | selected     | 1,245       |
      | previous     | 1,180       |
      | change       | +5.5%       |
    And I should be able to export activity log as CSV

  @api @dashboard @activity
  Scenario: View activity details
    Given I see an interesting activity event
    When I click on the event
    Then I should see full event details
    And I should see related entities (player, content, etc.)
    And I should be able to take action if applicable
    And I should see event in full context

  @api @dashboard @activity
  Scenario: Configure activity feed
    Given I want to customize what appears in my feed
    When I configure activity feed settings:
      | event_type         | show  | priority |
      | player_milestones  | true  | high     |
      | system_events      | true  | medium   |
      | moderation_actions | true  | high     |
      | content_updates    | true  | low      |
      | minor_events       | false | n/a      |
    Then feed should show only configured events
    And high priority events should be highlighted

  # ===========================================================================
  # QUICK ACTIONS
  # ===========================================================================

  @api @dashboard @actions
  Scenario: Access quick management actions
    Given I am viewing my dashboard
    When I view quick actions panel
    Then I should see frequently used actions:
      | action               | icon          | description                 |
      | send_announcement    | megaphone     | Broadcast message to world  |
      | restart_world        | refresh       | Graceful world restart      |
      | toggle_maintenance   | wrench        | Enable/disable maintenance  |
      | view_reports         | flag          | Open moderation reports     |
      | access_moderation    | shield        | Open moderation dashboard   |
      | backup_now           | save          | Create immediate backup     |
    And each action should show tooltip on hover
    And actions should be executable with one click

  @api @dashboard @actions
  Scenario: Execute quick action with confirmation
    Given maintenance mode is a critical action
    When I click "Toggle Maintenance"
    Then I should see confirmation dialog:
      | field            | value                              |
      | action           | Enable Maintenance Mode            |
      | impact           | All players will be disconnected   |
      | affected_players | 127 currently online               |
    And I should see impact summary
    And I should confirm before execution
    When I confirm the action
    Then maintenance mode should be enabled
    And players should be notified
    And a MaintenanceModeToggled event should be published

  @api @dashboard @actions
  Scenario: Send world announcement
    Given I want to notify all players
    When I click "Send Announcement" quick action
    Then I should see announcement composer:
      | field            | options                          |
      | message          | (text input)                     |
      | priority         | normal, important, urgent        |
      | target           | all, online_only, specific_group |
      | expiry           | 1h, 6h, 24h, permanent           |
    When I compose and send announcement
    Then announcement should be broadcast
    And I should see delivery confirmation
    And an AnnouncementSent event should be published

  @api @dashboard @actions
  Scenario: Customize quick action shortcuts
    Given I want to personalize my quick actions
    When I customize quick actions
    Then I should see all available actions
    And I should be able to add frequently used actions
    And I should be able to remove actions from shortcuts
    And I should be able to reorder actions by drag-drop
    And I should have maximum of 8 quick actions
    And changes should save automatically

  @api @dashboard @actions
  Scenario: Execute world restart
    Given I need to restart my world for updates
    When I click "Restart World" quick action
    Then I should see restart options:
      | option              | description                        |
      | immediate           | Restart now (disconnect all)       |
      | graceful_5min       | 5-minute countdown                 |
      | graceful_15min      | 15-minute countdown                |
      | scheduled           | Schedule for specific time         |
    When I select "graceful_5min"
    Then countdown should begin
    And all players should receive warning
    And I should see restart progress

  # ===========================================================================
  # PLAYER STATISTICS
  # ===========================================================================

  @api @dashboard @players
  Scenario: Monitor player statistics
    Given my world has active players
    When I view player statistics widget
    Then I should see current metrics:
      | metric              | value    | trend    |
      | online_players      | 127      | +12%     |
      | daily_active_users  | 1,245    | +5%      |
      | weekly_active_users | 4,532    | +8%      |
      | monthly_active_users| 8,932    | +3%      |
      | retention_rate_d7   | 45%      | +2%      |
      | new_signups_today   | 89       | +15%     |
    And trends should compare to previous period
    And I should see sparkline graphs for each metric

  @api @dashboard @players
  Scenario: View player demographics
    Given I want to understand my player base
    When I expand player demographics section
    Then I should see geographic distribution:
      | region          | percentage | count  |
      | North America   | 45%        | 4,019  |
      | Europe          | 30%        | 2,680  |
      | Asia            | 15%        | 1,340  |
      | Other           | 10%        | 893    |
    And I should see play session durations:
      | duration        | percentage |
      | < 30 min        | 20%        |
      | 30 min - 1 hr   | 35%        |
      | 1 - 2 hrs       | 30%        |
      | > 2 hrs         | 15%        |
    And I should see peak activity times (hourly heatmap)
    And I should see player progression distribution

  @api @dashboard @players
  Scenario: Track player trends over time
    Given I want to analyze player growth
    When I view player trend charts for last 30 days
    Then I should see player count timeline
    And I should see growth rate calculation
    And I should see churn indicators:
      | metric              | value    |
      | churned_players     | 234      |
      | churn_rate          | 2.6%     |
      | at_risk_players     | 156      |
    And I should be able to compare to previous periods
    And I should be able to overlay events on timeline

  @api @dashboard @players
  Scenario: View real-time player map
    Given I have the player map widget
    When I view the real-time player map
    Then I should see players distributed across world locations
    And I should see player density indicators
    And I should see hot spots highlighted
    And I should be able to zoom and pan
    And map should update in real-time

  @api @dashboard @players
  Scenario: Identify at-risk players
    Given I want to reduce churn
    When I view at-risk player analysis
    Then I should see players likely to churn:
      | player_name    | last_active | risk_score | reason              |
      | Player123      | 5 days ago  | 85%        | declining_activity  |
      | AnotherPlayer  | 7 days ago  | 92%        | no_recent_progress  |
    And I should see engagement recommendations
    And I should be able to send targeted messages

  # ===========================================================================
  # RESOURCE CONSUMPTION
  # ===========================================================================

  @api @dashboard @resources
  Scenario: Track resource consumption
    Given my world consumes various resources
    When I view resource usage widget
    Then I should see current resource usage:
      | resource         | used    | limit   | percentage |
      | compute_hours    | 450     | 1000    | 45%        |
      | storage_gb       | 8.5     | 20      | 43%        |
      | bandwidth_gb     | 120     | 500     | 24%        |
      | ai_tokens        | 45000   | 100000  | 45%        |
      | api_calls        | 250000  | 1000000 | 25%        |
    And I should see usage trend graphs
    And I should see projected month-end usage
    And resources near limit should be highlighted

  @api @dashboard @resources
  Scenario: View resource usage breakdown
    Given I want to understand what consumes resources
    When I expand resource details for "storage_gb"
    Then I should see usage by category:
      | category         | usage   | percentage |
      | player_data      | 3.2 GB  | 38%        |
      | world_content    | 2.8 GB  | 33%        |
      | media_assets     | 1.5 GB  | 18%        |
      | backups          | 0.7 GB  | 8%         |
      | logs             | 0.3 GB  | 4%         |
    And I should see usage by time period
    And I should see cost implications
    And I should see optimization suggestions

  @api @dashboard @resources
  Scenario: Set resource usage alerts
    Given I want to be notified before hitting limits
    When I configure resource alerts:
      | resource         | warning_at | critical_at |
      | compute_hours    | 80%        | 95%         |
      | storage_gb       | 80%        | 90%         |
      | bandwidth_gb     | 75%        | 90%         |
      | ai_tokens        | 70%        | 90%         |
    Then alerts should be configured
    And I should receive notifications when thresholds crossed
    And alerts should include usage details
    And alerts should suggest actions

  @api @dashboard @resources
  Scenario: View resource cost analysis
    Given my world has usage-based billing
    When I view resource cost analysis
    Then I should see:
      | resource         | usage   | cost    |
      | compute_hours    | 450     | $45.00  |
      | storage_gb       | 8.5     | $2.55   |
      | bandwidth_gb     | 120     | $12.00  |
      | ai_tokens        | 45000   | $9.00   |
    And I should see total projected cost
    And I should see cost comparison to previous period
    And I should see cost optimization recommendations

  # ===========================================================================
  # NOTIFICATIONS
  # ===========================================================================

  @api @dashboard @notifications
  Scenario: View world notifications
    Given I have various notifications
    When I view notifications panel
    Then I should see unread notifications count badge
    And notifications should be categorized:
      | category       | unread | description                |
      | critical       | 2      | Urgent issues              |
      | system         | 5      | System updates             |
      | player_reports | 12     | Moderation reports         |
      | billing        | 1      | Payment/subscription       |
      | performance    | 3      | Performance alerts         |
    And I should be able to mark individual as read
    And I should be able to mark all as read

  @api @dashboard @notifications
  Scenario: Configure notification preferences
    Given I want to control how I receive notifications
    When I configure notification settings:
      | notification_type | in_app | email | push  | frequency   |
      | critical_alerts   | true   | true  | true  | immediate   |
      | player_reports    | true   | true  | false | hourly      |
      | billing           | true   | true  | false | immediate   |
      | performance       | true   | false | false | immediate   |
      | daily_summary     | false  | true  | false | daily_9am   |
    Then preferences should be saved
    And notifications should follow preferences
    And I should receive confirmation of changes

  @api @dashboard @notifications
  Scenario: Snooze notification
    Given I have a non-urgent notification
    When I snooze the notification for 1 hour
    Then notification should be hidden temporarily
    And snooze indicator should show remaining time
    And notification should reappear after 1 hour
    And I should be able to unsnooze early

  @api @dashboard @notifications
  Scenario: View notification details
    Given I receive a player report notification
    When I click on the notification
    Then I should see full notification details
    And I should see related context
    And I should be able to take action directly
    And notification should be marked as read

  @api @dashboard @notifications
  Scenario: Filter notifications
    Given I have many notifications
    When I filter by "player_reports"
    Then I should only see player report notifications
    And I should see filtered count
    And I should be able to bulk mark as read

  # ===========================================================================
  # PERFORMANCE DASHBOARD
  # ===========================================================================

  @api @dashboard @performance
  Scenario: View world performance dashboard
    Given my world is actively running
    When I access performance metrics
    Then I should see response time graph (p50, p95, p99)
    And I should see error rate trends
    And I should see throughput metrics:
      | metric              | value      |
      | requests_per_second | 1,250      |
      | peak_rps_today      | 2,100      |
      | avg_response_time   | 45ms       |
    And I should see latency percentiles
    And graphs should update in real-time

  @api @dashboard @performance
  Scenario: Drill down into performance issues
    Given performance graph shows degradation at 2pm
    When I click on the affected time period
    Then I should see detailed breakdown:
      | metric           | value_before | value_during | change   |
      | response_time    | 45ms         | 250ms        | +456%    |
      | error_rate       | 0.1%         | 2.5%         | +2400%   |
      | throughput       | 1,250 rps    | 800 rps      | -36%     |
    And I should see correlated events
    And I should see affected endpoints
    And I should see remediation suggestions

  @api @dashboard @performance
  Scenario: Compare performance across periods
    Given I want to analyze performance trends
    When I compare this week to last week
    Then I should see performance comparison:
      | metric           | this_week | last_week | change  |
      | avg_response     | 48ms      | 52ms      | -8%     |
      | error_rate       | 0.15%     | 0.20%     | -25%    |
      | uptime           | 99.95%    | 99.90%    | +0.05%  |
    And improvements should be highlighted in green
    And degradations should be highlighted in red
    And I should be able to drill into differences

  @api @dashboard @performance
  Scenario: Set performance baselines
    Given I want to track against expected performance
    When I set performance baselines:
      | metric           | baseline | acceptable_variance |
      | response_time    | 50ms     | 20%                 |
      | error_rate       | 0.1%     | 50%                 |
      | throughput       | 1,000    | 10%                 |
    Then baselines should be saved
    And deviations should be highlighted
    And I should receive alerts on significant deviations

  @api @dashboard @performance
  Scenario: View performance by endpoint
    Given I want to identify slow endpoints
    When I view endpoint performance breakdown
    Then I should see:
      | endpoint            | avg_response | p99_response | calls_per_min |
      | /api/game/state     | 25ms         | 100ms        | 500           |
      | /api/player/action  | 45ms         | 200ms        | 1,200         |
      | /api/ai/dialogue    | 150ms        | 800ms        | 100           |
    And slow endpoints should be highlighted
    And I should see endpoint-specific recommendations

  # ===========================================================================
  # CONTENT SNAPSHOT
  # ===========================================================================

  @api @dashboard @content
  Scenario: View world content snapshot
    Given my world has various content types
    When I view content summary widget
    Then I should see entity counts:
      | entity_type | count | limit     | percentage |
      | npcs        | 150   | 200       | 75%        |
      | items       | 890   | 1000      | 89%        |
      | quests      | 45    | 100       | 45%        |
      | locations   | 78    | 200       | 39%        |
      | dialogues   | 2,500 | unlimited | n/a        |
    And I should see recent content changes
    And I should see content health indicators
    And I should be able to click through to content manager

  @api @dashboard @content
  Scenario: View content usage statistics
    Given I want to understand content engagement
    When I view content analytics
    Then I should see most visited locations:
      | location        | visits_per_day | avg_time_spent |
      | Dragon's Lair   | 1,250          | 15 min         |
      | Market Square   | 980            | 8 min          |
      | Dark Forest     | 750            | 22 min         |
    And I should see most interacted NPCs:
      | npc_name        | interactions_per_day |
      | Merchant Arlo   | 2,100                |
      | Quest Giver Jim | 1,800                |
    And I should see quest completion rates
    And I should see underutilized content flagged

  @api @dashboard @content
  Scenario: View content health indicators
    Given some content may have issues
    When I view content health section
    Then I should see content issues:
      | issue_type       | count | severity |
      | broken_links     | 3     | warning  |
      | orphaned_items   | 12    | low      |
      | missing_dialogue | 2     | warning  |
      | unbalanced_quests| 5     | info     |
    And I should be able to click to fix each issue
    And I should see content quality score

  @api @dashboard @content
  Scenario: View recent content changes
    Given content has been modified recently
    When I view content change log
    Then I should see recent changes:
      | timestamp    | author      | change_type | entity      |
      | 2 hours ago  | AdminUser   | created     | Quest: Hunt |
      | 5 hours ago  | AIAssistant | modified    | NPC: Guard  |
      | 1 day ago    | AdminUser   | deleted     | Item: Sword |
    And I should be able to revert changes if needed

  # ===========================================================================
  # FINANCIAL STATUS
  # ===========================================================================

  @api @dashboard @financial
  Scenario: View world financial status
    Given my world has active billing
    When I view financial dashboard widget
    Then I should see:
      | metric                    | value      |
      | current_period_charges    | $127.50    |
      | projected_month_end       | $185.00    |
      | subscription_status       | active     |
      | next_billing_date         | Jan 1, 2025|
      | payment_method            | Visa *4242 |
    And I should see payment history summary
    And I should see link to detailed billing

  @api @dashboard @financial
  Scenario: View revenue breakdown for monetized world
    Given my world has monetization enabled
    And players make in-world purchases
    When I view revenue details
    Then I should see revenue by source:
      | source               | this_month | last_month | change  |
      | player_subscriptions | $2,500     | $2,300     | +8.7%   |
      | in_world_purchases   | $1,200     | $1,100     | +9.1%   |
      | premium_content      | $800       | $750       | +6.7%   |
      | total_revenue        | $4,500     | $4,150     | +8.4%   |
    And I should see payout schedule
    And I should see revenue trends graph

  @api @dashboard @financial
  Scenario: View cost projections
    Given I want to forecast expenses
    When I view cost forecast widget
    Then I should see:
      | period        | projected_cost | budget    | variance |
      | This month    | $185.00        | $200.00   | -$15.00  |
      | Next month    | $195.00        | $200.00   | -$5.00   |
      | Next quarter  | $600.00        | $600.00   | $0.00    |
    And I should see cost drivers breakdown
    And I should see optimization opportunities
    And I should see budget vs actual chart

  @api @dashboard @financial
  Scenario: Set budget alerts
    Given I want to control costs
    When I set budget alerts:
      | alert_type       | threshold | notification |
      | monthly_budget   | $180      | email        |
      | daily_spike      | 150%      | push         |
      | resource_overage | any       | in_app       |
    Then alerts should be configured
    And I should receive notifications at thresholds

  # ===========================================================================
  # AI ASSISTANT
  # ===========================================================================

  @api @dashboard @ai
  Scenario: Activate AI world assistant
    Given I want help managing my world
    When I activate the AI assistant
    Then I should see assistant interface
    And I should be able to ask questions in natural language
    And assistant should have context of my world
    And I should see suggested prompts

  @api @dashboard @ai
  Scenario: Ask AI for world insights
    Given the AI assistant is active
    When I ask "What should I focus on today?"
    Then the assistant should analyze world state
    And provide prioritized recommendations:
      | priority | recommendation                          | reason                    |
      | 1        | Address 5 pending moderation reports    | Player safety             |
      | 2        | Review declining player retention       | -5% this week             |
      | 3        | Optimize slow AI dialogue endpoint      | p99 > 500ms               |
    And explain reasoning for each suggestion
    And offer to help implement changes

  @api @dashboard @ai
  Scenario: Execute action through AI assistant
    Given I want to schedule maintenance
    When I say "Schedule maintenance for 2 hours from now with 15 minute warning"
    Then assistant should parse my request
    And confirm understanding:
      | field            | value              |
      | action           | schedule_maintenance|
      | start_time       | 2 hours from now   |
      | warning_period   | 15 minutes         |
    When I confirm
    Then maintenance should be scheduled
    And warning announcement should be queued
    And I should receive confirmation

  @api @dashboard @ai
  Scenario: Get AI analysis of player behavior
    Given I want to understand player patterns
    When I ask "Why are players leaving after level 10?"
    Then assistant should analyze player data
    And provide insights:
      | finding                           | confidence |
      | Quest difficulty spike at level 10| 85%        |
      | Lack of rewards between 10-15     | 72%        |
      | Tutorial ends abruptly            | 65%        |
    And suggest specific improvements
    And offer to implement changes

  @api @dashboard @ai
  Scenario: AI proactive alerts
    Given AI monitoring is enabled
    When AI detects an anomaly
    Then I should receive proactive notification:
      | alert_type      | message                              |
      | anomaly         | Unusual spike in player complaints   |
      | recommendation  | Review recent content changes        |
    And I should be able to investigate from alert
    And I should be able to dismiss or snooze

  # ===========================================================================
  # MOBILE ACCESS
  # ===========================================================================

  @api @dashboard @mobile
  Scenario: Access dashboard on mobile device
    Given I am using a mobile device
    When I access the world owner dashboard
    Then layout should be mobile-optimized:
      | adaptation              | description                    |
      | single_column_layout    | Widgets stack vertically       |
      | touch_targets           | Larger clickable areas         |
      | swipe_navigation        | Swipe between sections         |
      | collapsed_navigation    | Hamburger menu                 |
    And critical information should be prioritized
    And performance should be acceptable on mobile networks
    And I should be able to perform essential actions

  @api @dashboard @mobile
  Scenario: Receive mobile push notifications
    Given I have enabled mobile push notifications
    And I am not currently on the dashboard
    When a critical alert occurs in my world
    Then I should receive push notification:
      | field          | value                           |
      | title          | Critical Alert: Epic Fantasy    |
      | body           | Server error rate above 5%      |
      | action         | View Details                    |
    And notification should link directly to issue
    And I should be able to take action from mobile

  @api @dashboard @mobile
  Scenario: Use mobile quick actions
    Given I am on mobile dashboard
    When I access quick actions
    Then I should see mobile-optimized action menu
    And I should be able to:
      | action                    |
      | send_quick_announcement   |
      | toggle_maintenance        |
      | view_critical_alerts      |
      | contact_support           |
    And confirmations should use mobile-friendly dialogs

  # ===========================================================================
  # SEARCH
  # ===========================================================================

  @api @dashboard @search
  Scenario: Search across world data
    Given I want to find specific information
    When I search for "dragon quest"
    Then I should see matching results across:
      | category     | matches | top_result                  |
      | quests       | 3       | Dragon Slayer Quest         |
      | npcs         | 5       | Dragon Keeper               |
      | items        | 12      | Dragon Scale Armor          |
      | players      | 2       | DragonMaster99              |
      | logs         | 45      | Various activity logs       |
    And results should be ranked by relevance
    And I should be able to filter by category
    And I should see result previews

  @api @dashboard @search
  Scenario: Use advanced search filters
    Given I need precise search results
    When I use advanced search with filters:
      | filter       | value          |
      | type         | player         |
      | date_range   | last_7_days    |
      | status       | active         |
      | level_min    | 20             |
    Then results should match all filters
    And I should see filter summary
    And I should be able to save search as preset
    And I should be able to modify filters easily

  @api @dashboard @search
  Scenario: Save and reuse search
    Given I frequently search for high-level players
    When I save search as "VIP Players"
    Then search should be saved to my presets
    And I should see saved searches in search menu
    When I select "VIP Players" preset
    Then search should execute with saved parameters

  @api @dashboard @search
  Scenario: Search with autocomplete
    Given I start typing in search box
    When I type "drag"
    Then I should see autocomplete suggestions:
      | suggestion        | category |
      | Dragon            | NPC      |
      | Dragon Quest      | Quest    |
      | Dragon Scale      | Item     |
    And I should be able to select suggestion
    And recent searches should appear

  # ===========================================================================
  # REPORTS
  # ===========================================================================

  @api @dashboard @reports
  Scenario: Generate comprehensive world report
    Given I need to create a status report
    When I generate a comprehensive report
    Then I should be able to select sections:
      | section             | included | description                  |
      | executive_summary   | true     | Key highlights and metrics   |
      | player_analytics    | true     | Player stats and trends      |
      | performance_metrics | true     | Technical performance        |
      | financial_summary   | true     | Revenue and costs            |
      | content_analytics   | true     | Content usage and health     |
      | moderation_summary  | false    | Moderation activity          |
    And I should select date range
    When I generate report
    Then report should be created
    And I should be able to preview report
    And I should be able to download as PDF

  @api @dashboard @reports
  Scenario: Schedule recurring reports
    Given I want weekly status reports
    When I schedule weekly report:
      | setting     | value               |
      | frequency   | weekly              |
      | day         | Monday              |
      | time        | 9:00 AM             |
      | recipients  | me@example.com      |
      | format      | PDF                 |
      | sections    | all                 |
    Then schedule should be created
    And reports should be sent automatically
    And I should be able to modify schedule
    And I should see next scheduled report date

  @api @dashboard @reports
  Scenario: Share report with stakeholders
    Given I have generated a report
    When I share with stakeholders:
      | recipient           | access_level |
      | investor@fund.com   | view_only    |
      | partner@studio.com  | download     |
    Then recipients should receive secure link
    And link should have configurable expiry
    And access should be tracked
    And I should be able to revoke access

  @api @dashboard @reports
  Scenario: View report history
    Given I have generated multiple reports
    When I view report history
    Then I should see past reports:
      | report_name          | date       | type      |
      | December Summary     | 2024-12-01 | monthly   |
      | Week 48 Report       | 2024-12-02 | weekly    |
      | Q4 Analysis          | 2024-10-01 | quarterly |
    And I should be able to download past reports
    And I should be able to compare reports

  @api @dashboard @reports
  Scenario: Create custom report template
    Given I frequently need specific report format
    When I create custom template "Investor Report":
      | section             |
      | executive_summary   |
      | player_growth       |
      | revenue_trends      |
      | future_projections  |
    Then template should be saved
    And I should be able to generate reports from template
    And template should be available for scheduling

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: DashboardViewed tracks usage analytics
    Given I access my dashboard
    When DashboardViewed event is published
    Then the event should contain:
      | field           | description                    |
      | owner_id        | Who viewed the dashboard       |
      | world_id        | Which world's dashboard        |
      | timestamp       | When viewed                    |
      | device_type     | desktop/mobile/tablet          |
    And view should be logged for analytics
    And session duration should be tracked
    And widget interactions should be recorded

  @domain-events
  Scenario: AlertAcknowledged updates alert status
    Given I acknowledge a health alert
    When AlertAcknowledged event is published
    Then the event should contain:
      | field           | description                    |
      | alert_id        | Which alert was acknowledged   |
      | acknowledged_by | Who acknowledged               |
      | timestamp       | When acknowledged              |
    And alert should be marked as seen
    And response time should be recorded
    And escalation timer should stop

  @domain-events
  Scenario: DashboardCustomized persists preferences
    Given I customize my dashboard layout
    When DashboardCustomized event is published
    Then the event should contain:
      | field           | description                    |
      | owner_id        | Who customized                 |
      | layout          | New layout configuration       |
      | widgets         | List of widget positions       |
    And layout should be persisted
    And layout should sync across devices

  @domain-events
  Scenario: QuickActionExecuted logs action
    Given I execute a quick action
    When QuickActionExecuted event is published
    Then the event should contain:
      | field           | description                    |
      | action_type     | Which action was executed      |
      | executed_by     | Who executed                   |
      | parameters      | Action parameters              |
      | result          | Success or failure             |
    And action should be logged in activity feed
    And action should be auditable

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle dashboard data loading failure
    Given a widget fails to load data
    When I view the dashboard
    Then failed widget should show error state:
      | element          | display                        |
      | error_icon       | Warning triangle               |
      | error_message    | Unable to load data            |
      | retry_button     | Retry                          |
    And other widgets should load normally
    And I should be able to retry failed widget
    And failure should be logged

  @api @error
  Scenario: Handle stale dashboard data
    Given dashboard data has not updated in 5 minutes
    When staleness is detected
    Then I should see last updated timestamp
    And stale indicator should be visible
    And I should be offered manual refresh
    And auto-refresh should attempt recovery
    And a DashboardDataStale event should be published

  @api @error
  Scenario: Handle complete dashboard failure
    Given dashboard service is unavailable
    When I access the dashboard
    Then I should see friendly error page
    And I should see status of service
    And I should see estimated recovery time if available
    And I should be able to access basic functions
    And I should be notified when service recovers

  @api @error
  Scenario: Handle partial data in widgets
    Given some metrics are unavailable
    When widget loads with partial data
    Then available data should be displayed
    And unavailable metrics should show "N/A"
    And tooltip should explain why data is missing
    And I should see when data will be available

  @api @error
  Scenario: Recover from session timeout
    Given my dashboard session has timed out
    When I interact with the dashboard
    Then I should see session expired message
    And I should be prompted to re-authenticate
    And my dashboard state should be preserved
    And I should return to same view after login
