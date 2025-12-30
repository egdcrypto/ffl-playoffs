@world @analytics @metrics @insights
Feature: World Owner Analytics
  As a world owner
  I want to access detailed analytics about my world
  So that I can make data-driven decisions to improve player experience

  Background:
    Given I am logged in as the owner of "Epic Fantasy Realm"
    And I have analytics viewing permissions
    And my world has been active for 6 months
    And analytics data collection is enabled

  # ====================
  # ANALYTICS DASHBOARD
  # ====================

  @api @analytics @dashboard
  Scenario: View analytics overview dashboard
    Given my world has the following current metrics:
      | metric               | value    |
      | daily_active_users   | 1234     |
      | monthly_active_users | 15678    |
      | avg_session_time_min | 45       |
      | retention_rate_pct   | 42       |
      | revenue_mtd          | 12500.00 |
    When I navigate to the analytics dashboard
    Then I should see the analytics overview panel
    And I should see the following key metrics displayed:
      | metric              | display_value | trend     |
      | daily_active_users  | 1,234         | +5%       |
      | monthly_active_users| 15,678        | +12%      |
      | avg_session_time    | 45 min        | +3 min    |
      | retention_rate      | 42%           | -2%       |
      | revenue_mtd         | $12,500       | +8%       |
    And each metric should show a trend indicator with direction
    And I should see comparison values to the previous period
    And I should see AI-generated quick insights panel
    And the dashboard should show last updated timestamp

  @api @analytics @dashboard
  Scenario: Customize analytics dashboard layout
    Given I am viewing the analytics dashboard
    And the dashboard has the following default widgets:
      | widget_id        | position | size   |
      | key_metrics      | 1        | large  |
      | player_chart     | 2        | medium |
      | revenue_chart    | 3        | medium |
      | activity_feed    | 4        | small  |
    When I enter dashboard customization mode
    And I add a new widget "retention_funnel" to position 5
    And I resize widget "player_chart" to "large"
    And I remove widget "activity_feed"
    And I set the default date range to "last_30_days"
    And I save the dashboard layout
    Then the dashboard should reflect my customizations
    And the layout should persist across browser sessions
    And I should be able to reset to default layout
    And I should see a confirmation of saved changes

  @api @analytics @dashboard
  Scenario: View real-time analytics mode
    Given my world currently has 523 active players
    And 45 events occurred in the last minute
    When I enable real-time analytics mode
    Then I should see a live player count updating in real-time
    And I should see the following real-time metrics:
      | metric              | initial_value | update_frequency |
      | active_players      | 523           | 5 seconds        |
      | active_sessions     | 498           | 5 seconds        |
      | events_per_minute   | 45            | 30 seconds       |
      | zone_activity       | map_view      | 30 seconds       |
    And I should see a real-time event stream showing recent actions
    And the data should auto-refresh every 30 seconds
    And I should see a "live" indicator badge
    And I should be able to pause real-time updates

  @api @analytics @dashboard
  Scenario: Filter analytics by date range
    Given I am viewing the analytics dashboard
    When I select the date range filter
    Then I should see the following preset options:
      | preset       | description          |
      | today        | Current day          |
      | yesterday    | Previous day         |
      | last_7_days  | Last 7 days          |
      | last_30_days | Last 30 days         |
      | this_month   | Current month        |
      | last_month   | Previous month       |
      | this_quarter | Current quarter      |
      | custom       | Custom date range    |
    When I select "last_30_days"
    Then all dashboard widgets should update with filtered data
    And comparison period should adjust automatically
    And I should see the selected date range displayed

  @api @analytics @dashboard
  Scenario: Compare analytics across time periods
    Given I am viewing analytics for "last_30_days"
    When I enable period comparison mode
    And I select comparison period "previous_30_days"
    Then I should see side-by-side metrics comparison:
      | metric         | current | previous | change  |
      | dau_avg        | 1,234   | 1,100    | +12.2%  |
      | revenue        | $12,500 | $11,000  | +13.6%  |
      | session_time   | 45 min  | 42 min   | +7.1%   |
    And charts should show overlay of both periods
    And I should see which metrics improved or declined

  # ====================
  # PLAYER BEHAVIOR ANALYTICS
  # ====================

  @api @analytics @players
  Scenario: Analyze player behavior patterns
    Given my world has player behavior data collected
    When I navigate to the player behavior analytics section
    Then I should see the following behavior metrics:
      | metric                 | value        | benchmark |
      | avg_sessions_per_day   | 2.3          | 1.8       |
      | peak_hours             | 7-10 PM EST  | 6-9 PM    |
      | avg_actions_per_session| 156          | 120       |
      | most_common_actions    | combat, chat | -         |
    And I should see a heatmap of activity by hour and day
    And I should see behavior trend charts over time
    And I should see cohort comparison breakdowns
    And I should see action type distribution pie chart

  @api @analytics @players
  Scenario: Analyze new player onboarding behavior
    Given 500 new players joined in the last 7 days
    When I filter player behavior to "new_players_7_days"
    Then I should see the following onboarding metrics:
      | metric                    | value | target |
      | tutorial_start_rate       | 95%   | 90%    |
      | tutorial_completion_rate  | 72%   | 80%    |
      | first_quest_start_rate    | 85%   | 85%    |
      | day_1_return_rate         | 45%   | 50%    |
    And I should see tutorial drop-off points breakdown:
      | step                  | completion | drop_off |
      | character_creation    | 98%        | 2%       |
      | movement_tutorial     | 95%        | 3%       |
      | combat_tutorial       | 82%        | 13%      |
      | inventory_tutorial    | 72%        | 10%      |
    And I should see first session duration distribution
    And I should see early engagement indicators

  @api @analytics @players
  Scenario: View player journey funnel analysis
    Given player journey tracking is configured
    When I view the player journey funnel
    Then I should see conversion rates at each funnel stage:
      | stage             | players | conversion | drop_off |
      | registration      | 10000   | 100%       | 0%       |
      | tutorial_start    | 8500    | 85%        | 15%      |
      | tutorial_complete | 6000    | 71%        | 14%      |
      | first_quest       | 5200    | 87%        | 13%      |
      | level_5           | 3800    | 73%        | 27%      |
      | day_7_return      | 2100    | 55%        | 45%      |
      | day_30_return     | 1200    | 57%        | 43%      |
    And I should see visual funnel representation
    And I should see drop-off analysis with reasons
    And I should see AI-generated improvement suggestions
    And I should be able to drill down into each stage

  @api @analytics @players
  Scenario: Analyze player session patterns
    Given I have session data for the last 30 days
    When I view session analytics
    Then I should see the following session metrics:
      | metric                | value   |
      | total_sessions        | 45,000  |
      | unique_players        | 12,500  |
      | avg_session_duration  | 45 min  |
      | median_session_duration| 32 min |
      | sessions_per_player   | 3.6     |
    And I should see session duration distribution histogram
    And I should see session frequency by player segment
    And I should see session start time distribution
    And I should see multi-session player analysis

  @api @analytics @players
  Scenario: Analyze player retention cohorts
    Given I have retention data for multiple cohorts
    When I view retention cohort analysis
    Then I should see retention matrix:
      | cohort    | day_1 | day_7 | day_14 | day_30 | day_60 |
      | Week 1    | 45%   | 25%   | 18%    | 12%    | 8%     |
      | Week 2    | 48%   | 28%   | 20%    | 14%    | -      |
      | Week 3    | 52%   | 30%   | 22%    | -      | -      |
      | Week 4    | 50%   | 32%   | -      | -      | -      |
    And I should see retention trend over time
    And I should see cohort comparison visualization
    And I should see retention by acquisition source
    And I should see factors correlating with retention

  @api @analytics @players
  Scenario: Identify player engagement levels
    Given player engagement scoring is enabled
    When I view player engagement distribution
    Then I should see players segmented by engagement level:
      | engagement_level | player_count | percentage | avg_sessions |
      | highly_engaged   | 2,500        | 20%        | 5.2          |
      | engaged          | 3,750        | 30%        | 2.8          |
      | casual           | 4,375        | 35%        | 1.2          |
      | at_risk          | 1,250        | 10%        | 0.3          |
      | churned          | 625          | 5%         | 0.0          |
    And I should see engagement score methodology
    And I should see engagement trends over time
    And I should be able to drill into each segment

  # ====================
  # CONTENT PERFORMANCE ANALYTICS
  # ====================

  @api @analytics @content
  Scenario: Analyze content engagement metrics
    Given my world has various content types
    When I navigate to content performance analytics
    Then I should see engagement by content type:
      | content_type | total_views | unique_viewers | completion_rate | avg_time |
      | main_story   | 45000       | 12000          | 78%             | 25 min   |
      | side_quests  | 32000       | 8500           | 65%             | 15 min   |
      | dialogues    | 120000      | 14000          | 92%             | 2 min    |
      | tutorials    | 15000       | 10000          | 85%             | 8 min    |
      | events       | 28000       | 6000           | 70%             | 20 min   |
    And I should see top 10 performing content items
    And I should see underperforming content items
    And I should see content engagement trends
    And I should see content rating distribution

  @api @analytics @content
  Scenario: Analyze individual quest performance
    Given quest "Dragon's Lair Adventure" has been active for 30 days
    When I view detailed analytics for this quest
    Then I should see the following quest metrics:
      | metric               | value   |
      | times_started        | 5000    |
      | times_completed      | 3250    |
      | completion_rate      | 65%     |
      | avg_completion_time  | 25 min  |
      | abandonment_rate     | 35%     |
      | replay_rate          | 12%     |
    And I should see step-by-step completion funnel:
      | step           | reached | completed | drop_off |
      | quest_accept   | 5000    | 4800      | 4%       |
      | find_cave      | 4800    | 4500      | 6%       |
      | defeat_minions | 4500    | 3800      | 16%      |
      | boss_fight     | 3800    | 3250      | 14%      |
    And I should see difficulty analysis and suggestions
    And I should see reward satisfaction ratings
    And I should see player feedback summary

  @api @analytics @content
  Scenario: Analyze NPC interaction patterns
    Given my world has 50 interactive NPCs
    When I view NPC interaction analytics
    Then I should see NPC engagement overview:
      | npc_name        | interactions | unique_players | avg_duration | satisfaction |
      | Merchant Marco  | 15000        | 8000           | 45 sec       | 4.2/5        |
      | Quest Giver Ava | 12000        | 9500           | 90 sec       | 4.5/5        |
      | Guard Captain   | 8000         | 6000           | 30 sec       | 3.8/5        |
    And I should see dialogue path distribution per NPC
    And I should see conversation abandonment points
    And I should see NPC location heatmap
    And I should see player satisfaction by NPC

  @api @analytics @content
  Scenario: Track content discovery rates
    Given my world has 200 discoverable content items
    When I view content discovery analytics
    Then I should see discovery statistics:
      | discovery_rate | content_count | percentage |
      | 90-100%        | 50            | 25%        |
      | 70-89%         | 60            | 30%        |
      | 50-69%         | 40            | 20%        |
      | 25-49%         | 30            | 15%        |
      | 0-24%          | 20            | 10%        |
    And I should see least discovered content list
    And I should see discovery path analysis
    And I should see recommendations for improving discovery

  @api @analytics @content
  Scenario: Analyze content difficulty balance
    Given my world has difficulty-rated content
    When I view difficulty analytics
    Then I should see difficulty distribution analysis:
      | difficulty | content_count | avg_completion | player_rating |
      | easy       | 50            | 92%            | 3.5/5         |
      | medium     | 80            | 75%            | 4.2/5         |
      | hard       | 50            | 45%            | 4.0/5         |
      | expert     | 20            | 22%            | 4.5/5         |
    And I should see difficulty curve visualization
    And I should see content flagged as too easy or too hard
    And I should see player skill distribution

  # ====================
  # ECONOMY ANALYTICS
  # ====================

  @api @analytics @economy
  Scenario: Monitor world economy health
    Given my world has an active economy
    When I navigate to economy analytics
    Then I should see the following economic indicators:
      | metric              | value        | trend   | health  |
      | total_gold_supply   | 500,000,000  | +5%     | healthy |
      | gold_velocity       | 2.3x/month   | stable  | good    |
      | inflation_rate      | 3%           | +0.5%   | warning |
      | gold_sinks_total    | 45M/month    | +8%     | healthy |
      | gold_sources_total  | 50M/month    | +10%    | monitor |
      | gini_coefficient    | 0.45         | +0.02   | moderate|
    And I should see an overall economy health score
    And I should see economy trend predictions
    And I should see wealth distribution visualization
    And I should see recommended economic interventions

  @api @analytics @economy
  Scenario: Analyze item economy metrics
    Given my world has 10,000 unique item types
    When I view item economy analytics
    Then I should see item circulation metrics:
      | metric               | value     |
      | items_in_circulation | 2,500,000 |
      | daily_trade_volume   | 50,000    |
      | avg_item_lifespan    | 45 days   |
      | items_created_daily  | 25,000    |
      | items_destroyed_daily| 22,000    |
    And I should see most traded items:
      | item_name       | trades_daily | avg_price | price_trend |
      | Health Potion   | 5,000        | 100 gold  | stable      |
      | Iron Sword      | 2,500        | 500 gold  | -5%         |
      | Rare Gem        | 500          | 5,000 gold| +12%        |
    And I should see price trend charts
    And I should see rarity distribution analysis
    And I should see item sink/source balance

  @api @analytics @economy
  Scenario: Detect economy anomalies and exploits
    Given economy anomaly detection is enabled
    When I run economy anomaly detection
    Then I should see flagged anomalies:
      | anomaly_type        | severity | occurrences | players_involved |
      | rapid_gold_gain     | high     | 5           | 3                |
      | price_manipulation  | medium   | 12          | 8                |
      | unusual_trading     | low      | 45          | 25               |
    And I should see potential exploit patterns
    And I should see unusual wealth accumulation accounts
    And I should see recommended actions for each anomaly
    And I should be able to investigate specific anomalies

  @api @analytics @economy
  Scenario: Analyze gold flow sources and sinks
    Given I want to understand gold circulation
    When I view gold flow analysis
    Then I should see gold sources breakdown:
      | source           | amount_monthly | percentage |
      | quest_rewards    | 25,000,000     | 50%        |
      | enemy_drops      | 15,000,000     | 30%        |
      | daily_login      | 5,000,000      | 10%        |
      | achievements     | 3,000,000      | 6%         |
      | other            | 2,000,000      | 4%         |
    And I should see gold sinks breakdown:
      | sink             | amount_monthly | percentage |
      | npc_vendors      | 20,000,000     | 44%        |
      | repairs          | 10,000,000     | 22%        |
      | fast_travel      | 8,000,000      | 18%        |
      | auction_fees     | 5,000,000      | 11%        |
      | other            | 2,000,000      | 5%         |
    And I should see gold flow sankey diagram
    And I should see source/sink balance analysis

  @api @analytics @economy
  Scenario: Track marketplace analytics
    Given my world has a player marketplace
    When I view marketplace analytics
    Then I should see marketplace metrics:
      | metric                | value     |
      | active_listings       | 25,000    |
      | daily_transactions    | 8,500     |
      | total_volume_daily    | 50M gold  |
      | avg_listing_duration  | 2.5 days  |
      | listing_success_rate  | 72%       |
    And I should see price history for top items
    And I should see buyer/seller ratio
    And I should see market liquidity analysis
    And I should see fee revenue generated

  # ====================
  # SOCIAL ANALYTICS
  # ====================

  @api @analytics @social
  Scenario: Analyze social interaction metrics
    Given my world has social features enabled
    When I navigate to social analytics
    Then I should see the following social metrics:
      | metric              | value    | trend  |
      | messages_per_day    | 50,000   | +8%    |
      | guilds_active       | 234      | +5%    |
      | friend_connections  | 12,000   | +15%   |
      | group_activities    | 1,500    | +12%   |
      | voice_chat_minutes  | 25,000   | +20%   |
    And I should see community health score
    And I should see toxicity metrics and trends
    And I should see social engagement distribution
    And I should see peak social activity times

  @api @analytics @social
  Scenario: Analyze guild performance and health
    Given my world has 234 active guilds
    When I view guild analytics
    Then I should see guild distribution by size:
      | size_category | guild_count | total_members | avg_activity |
      | large (50+)   | 15          | 1,200         | 85%          |
      | medium (20-49)| 45          | 1,350         | 72%          |
      | small (5-19)  | 100         | 1,000         | 58%          |
      | micro (2-4)   | 74          | 222           | 45%          |
    And I should see top performing guilds by activity
    And I should see guild retention impact analysis
    And I should see guild-related event participation
    And I should see guild growth/decline trends

  @api @analytics @social
  Scenario: Monitor community sentiment
    Given sentiment analysis is enabled on chat
    When I view community sentiment analytics
    Then I should see sentiment breakdown:
      | sentiment | percentage | trend  |
      | positive  | 65%        | +3%    |
      | neutral   | 28%        | -1%    |
      | negative  | 7%         | -2%    |
    And I should see sentiment by channel/zone
    And I should see trending topics and keywords
    And I should see sentiment over time chart
    And I should see notable positive/negative spikes

  @api @analytics @social
  Scenario: Analyze social network structure
    Given social graph analysis is available
    When I view social network analytics
    Then I should see network metrics:
      | metric                 | value  |
      | network_density        | 0.15   |
      | avg_connections        | 8.5    |
      | clustering_coefficient | 0.42   |
      | largest_component_size | 95%    |
    And I should see social influencer identification
    And I should see community cluster visualization
    And I should see social isolation metrics
    And I should see connection growth trends

  # ====================
  # TECHNICAL PERFORMANCE ANALYTICS
  # ====================

  @api @analytics @technical
  Scenario: Monitor server technical performance
    Given technical monitoring is enabled
    When I navigate to technical performance analytics
    Then I should see the following performance metrics:
      | metric              | value    | threshold | status  |
      | avg_response_time   | 85ms     | 200ms     | healthy |
      | p95_response_time   | 150ms    | 500ms     | healthy |
      | error_rate          | 0.2%     | 1%        | healthy |
      | uptime              | 99.95%   | 99.9%     | healthy |
      | concurrent_peak     | 2,500    | 5,000     | healthy |
    And I should see performance trends over time
    And I should see bottleneck analysis by endpoint
    And I should see error rate breakdown by type
    And I should see capacity utilization metrics

  @api @analytics @technical
  Scenario: Analyze client-side performance
    Given client telemetry is enabled
    When I view client performance analytics
    Then I should see client metrics:
      | metric              | value    | target  |
      | avg_fps             | 58       | 60      |
      | crash_rate          | 0.5%     | 1%      |
      | avg_load_time       | 4.2s     | 5s      |
      | memory_usage_avg    | 2.1GB    | 4GB     |
      | network_latency_avg | 45ms     | 100ms   |
    And I should see device distribution:
      | device_tier | players | percentage | avg_fps |
      | high        | 3,500   | 28%        | 75      |
      | medium      | 6,250   | 50%        | 58      |
      | low         | 2,750   | 22%        | 35      |
    And I should see performance by platform
    And I should see crash reports summary

  @api @analytics @technical
  Scenario: Monitor database performance
    Given database monitoring is enabled
    When I view database performance analytics
    Then I should see database metrics:
      | metric              | value    |
      | query_count_daily   | 500,000  |
      | avg_query_time      | 15ms     |
      | slow_queries_daily  | 50       |
      | connection_pool_avg | 45%      |
      | storage_used        | 250GB    |
    And I should see slowest queries list
    And I should see query pattern analysis
    And I should see storage growth projection

  @api @analytics @technical
  Scenario: Track API usage analytics
    Given API usage tracking is enabled
    When I view API analytics
    Then I should see API usage metrics:
      | endpoint_category | requests_daily | avg_latency | error_rate |
      | authentication    | 15,000         | 50ms        | 0.1%       |
      | game_state        | 200,000        | 80ms        | 0.2%       |
      | inventory         | 75,000         | 45ms        | 0.15%      |
      | social            | 50,000         | 60ms        | 0.25%      |
    And I should see rate limiting statistics
    And I should see API version distribution
    And I should see deprecated endpoint usage

  # ====================
  # CUSTOM REPORTS
  # ====================

  @api @analytics @reports
  Scenario: Create custom analytics report
    Given I want to create a custom report
    When I create a new custom report with the following configuration:
      | field           | value                          |
      | name            | Weekly KPI Report              |
      | description     | Key performance indicators     |
      | metrics         | DAU, MAU, revenue, retention   |
      | dimensions      | date, platform, player_segment |
      | filters         | date_range: last_7_days        |
      | visualization   | line_chart, table              |
      | grouping        | daily                          |
    Then the report should be generated successfully
    And I should see the report preview
    And I should be able to save the report to my library
    And I should be able to share the report with team members
    And I should be able to schedule the report

  @api @analytics @reports
  Scenario: Schedule recurring analytics report
    Given I have created report "Weekly KPI Report"
    When I schedule the report with the following settings:
      | field       | value                |
      | frequency   | weekly               |
      | day         | Monday               |
      | time        | 9:00 AM EST          |
      | recipients  | team@example.com, pm@example.com |
      | format      | PDF, CSV             |
      | include     | charts, data_tables  |
    Then the report schedule should be saved
    And I should receive a confirmation email
    And the report should be sent automatically on schedule
    And I should see the schedule in my report management

  @api @analytics @reports
  Scenario: Use report templates
    Given standard report templates are available
    When I view available report templates
    Then I should see the following templates:
      | template_name          | category    | metrics_included |
      | Executive Summary      | overview    | DAU, revenue, retention |
      | Player Health Report   | players     | engagement, churn, satisfaction |
      | Economy Health Report  | economy     | inflation, velocity, balance |
      | Content Performance    | content     | completion, engagement, ratings |
      | Technical Performance  | technical   | uptime, latency, errors |
    And I should be able to create a report from any template
    And I should be able to customize template parameters
    And I should be able to save customized templates

  @api @analytics @reports
  Scenario: Export report data
    Given I am viewing report "Weekly KPI Report"
    When I export the report data
    Then I should see export format options:
      | format | description              |
      | PDF    | Formatted report document|
      | CSV    | Raw data spreadsheet     |
      | Excel  | Excel workbook           |
      | JSON   | Machine-readable data    |
    And I should be able to select date range for export
    And I should be able to choose included sections
    And the export should complete within reasonable time

  # ====================
  # PREDICTIVE ANALYTICS
  # ====================

  @api @analytics @predictive
  Scenario: View predictive analytics insights
    Given predictive models have been trained on my world data
    When I navigate to predictive analytics
    Then I should see the following predictions:
      | prediction             | value           | confidence | trend    |
      | next_month_revenue     | $15,000         | 85%        | up       |
      | next_week_dau          | 1,350           | 78%        | stable   |
      | churn_risk_30_days     | 234 players     | 82%        | down     |
      | peak_concurrent_next   | Saturday 8 PM   | 90%        | -        |
    And I should see prediction accuracy history
    And I should see key factors driving each prediction
    And I should see confidence intervals
    And I should see model performance metrics

  @api @analytics @predictive
  Scenario: Identify players at risk of churning
    Given churn prediction model is active
    When I view the churn prediction dashboard
    Then I should see at-risk player segments:
      | risk_level   | player_count | probability | avg_days_to_churn |
      | critical     | 45           | 90%+        | 3                 |
      | high         | 120          | 70-89%      | 7                 |
      | medium       | 350          | 50-69%      | 14                |
      | low          | 800          | 30-49%      | 30                |
    And I should see churn indicators for at-risk players:
      | indicator             | weight |
      | decreasing_sessions   | 35%    |
      | reduced_spending      | 25%    |
      | social_disconnection  | 20%    |
      | incomplete_content    | 15%    |
      | negative_sentiment    | 5%     |
    And I should see recommended retention interventions
    And I should be able to export at-risk player list

  @api @analytics @predictive
  Scenario: Forecast revenue projections
    Given revenue prediction model is trained
    When I view revenue forecasting
    Then I should see revenue projections:
      | period       | projection | confidence | range_low | range_high |
      | next_week    | $3,200     | 90%        | $2,900    | $3,500     |
      | next_month   | $15,000    | 85%        | $13,500   | $16,500    |
      | next_quarter | $48,000    | 75%        | $42,000   | $54,000    |
    And I should see revenue drivers analysis
    And I should see seasonal patterns identified
    And I should see what-if scenario modeling

  @api @analytics @predictive
  Scenario: Predict player lifetime value
    Given LTV prediction model is active
    When I view player LTV predictions
    Then I should see LTV distribution:
      | ltv_segment      | player_count | avg_ltv | total_value |
      | high_value       | 500          | $150    | $75,000     |
      | medium_value     | 2,500        | $50     | $125,000    |
      | low_value        | 5,000        | $15     | $75,000     |
      | at_risk          | 2,000        | $5      | $10,000     |
    And I should see LTV prediction accuracy
    And I should see factors correlating with high LTV
    And I should see LTV improvement recommendations

  # ====================
  # A/B TESTING ANALYTICS
  # ====================

  @api @analytics @ab-testing
  Scenario: View A/B test results
    Given A/B test "New Tutorial Flow" has been running for 14 days
    And the test has sufficient sample size
    When I view the test results
    Then I should see variant comparison:
      | variant    | users  | conversion | improvement | significance |
      | control    | 5000   | 65%        | baseline    | -            |
      | variant_a  | 5000   | 72%        | +10.8%      | 95%          |
      | variant_b  | 5000   | 68%        | +4.6%       | 87%          |
    And I should see statistical significance indicators
    And I should see confidence intervals for each variant
    And I should see winner recommendation with rationale
    And I should see segment breakdown by variant

  @api @analytics @ab-testing
  Scenario: Create new A/B test
    Given I want to test quest reward variations
    When I create a new A/B test with the following configuration:
      | field           | value                    |
      | name            | Quest Reward Test        |
      | hypothesis      | Higher gold rewards increase completion |
      | variants        | control: 100 gold, A: 150 gold, B: 100 gold + item |
      | primary_metric  | quest_completion_rate    |
      | secondary_metrics| player_satisfaction, time_to_complete |
      | sample_size     | 10000 per variant        |
      | duration        | 14 days                  |
      | audience        | new_players_only         |
    Then the test should be configured successfully
    And I should see estimated completion date
    And I should see minimum detectable effect size
    And the test should begin collecting data

  @api @analytics @ab-testing
  Scenario: Monitor active A/B tests
    Given I have 3 active A/B tests running
    When I view the A/B test dashboard
    Then I should see all active tests:
      | test_name          | status  | progress | current_winner |
      | Tutorial Flow      | running | 80%      | variant_a      |
      | Quest Rewards      | running | 45%      | too_early      |
      | UI Color Theme     | running | 95%      | control        |
    And I should see early results with appropriate warnings
    And I should see estimated time to significance
    And I should be able to stop tests early if needed

  @api @analytics @ab-testing
  Scenario: Analyze test segments
    Given A/B test "Tutorial Flow" has completed
    When I analyze results by segment
    Then I should see segment-specific results:
      | segment        | control_conv | variant_a_conv | lift   |
      | mobile         | 60%          | 70%            | +16.7% |
      | desktop        | 70%          | 74%            | +5.7%  |
      | new_players    | 55%          | 68%            | +23.6% |
      | returning      | 75%          | 76%            | +1.3%  |
    And I should see interaction effects
    And I should see personalization opportunities

  # ====================
  # PLAYER SEGMENTS
  # ====================

  @api @analytics @segments
  Scenario: View predefined player segments
    Given standard player segments are configured
    When I navigate to player segments analytics
    Then I should see the following predefined segments:
      | segment          | size   | percentage | key_characteristic      |
      | whales           | 250    | 2%         | >$100 monthly spend     |
      | dolphins         | 1,500  | 12%        | $10-100 monthly spend   |
      | social_players   | 3,125  | 25%        | guild_active, high_chat |
      | completionists   | 1,875  | 15%        | achievement_hunters     |
      | casual           | 5,000  | 40%        | <3 sessions/week        |
      | hardcore         | 750    | 6%         | >5 hours daily          |
    And I should see behavior metrics for each segment
    And I should see segment trends over time
    And I should see segment transition analysis

  @api @analytics @segments
  Scenario: Create custom player segment
    Given I want to track power users specifically
    When I create a custom segment with the following criteria:
      | field          | value                            |
      | name           | Power Users                      |
      | description    | Highly engaged experienced players|
      | criteria       | sessions >= 5/week AND level >= 50 AND guild_member = true |
      | track_metrics  | retention, spending, activity    |
    Then the segment should be created successfully
    And the segment should be populated with matching players
    And I should see segment size: 450 players (3.6%)
    And I should see segment analytics dashboard
    And the segment should update daily

  @api @analytics @segments
  Scenario: Compare segment behavior
    Given I want to compare two segments
    When I compare segments "whales" and "dolphins"
    Then I should see comparative metrics:
      | metric              | whales    | dolphins  | difference |
      | avg_session_time    | 120 min   | 45 min    | +167%      |
      | sessions_per_week   | 12        | 5         | +140%      |
      | content_completion  | 85%       | 55%       | +30pp      |
      | social_connections  | 25        | 12        | +108%      |
      | support_tickets     | 2.5/month | 0.5/month | +400%      |
    And I should see behavior pattern comparison
    And I should see conversion path from dolphins to whales
    And I should see recommendations for segment growth

  @api @analytics @segments
  Scenario: Analyze segment revenue contribution
    Given revenue is tracked by segment
    When I view segment revenue analysis
    Then I should see revenue contribution:
      | segment     | players | revenue_share | arpu    | ltv     |
      | whales      | 2%      | 45%           | $150    | $500    |
      | dolphins    | 12%     | 35%           | $25     | $80     |
      | social      | 25%     | 12%           | $4      | $15     |
      | casual      | 40%     | 5%            | $1      | $5      |
      | other       | 21%     | 3%            | $1.20   | $4      |
    And I should see revenue concentration analysis
    And I should see segment monetization opportunities

  # ====================
  # REVENUE ANALYTICS
  # ====================

  @api @analytics @revenue
  Scenario: Analyze revenue streams breakdown
    Given my world has multiple revenue sources
    When I navigate to revenue analytics
    Then I should see revenue breakdown:
      | source            | amount_mtd | percentage | trend  |
      | subscriptions     | $8,000     | 64%        | +5%    |
      | in_app_purchases  | $3,500     | 28%        | +12%   |
      | cosmetics         | $750       | 6%         | +25%   |
      | battle_pass       | $250       | 2%         | new    |
    And I should see key revenue metrics:
      | metric | value  |
      | arpu   | $2.50  |
      | arppu  | $15.00 |
      | ltv    | $45.00 |
    And I should see revenue trends over time
    And I should see LTV projections by cohort

  @api @analytics @revenue
  Scenario: Analyze purchase behavior patterns
    Given I have purchase history data
    When I view purchase analytics
    Then I should see purchase patterns:
      | metric                  | value       |
      | avg_first_purchase_day  | day 3       |
      | purchase_frequency      | 2.5x/month  |
      | avg_transaction_value   | $6.00       |
      | repeat_purchase_rate    | 65%         |
    And I should see popular price points:
      | price_point | transactions | revenue_share |
      | $0.99       | 5,000        | 15%           |
      | $4.99       | 3,000        | 45%           |
      | $9.99       | 1,500        | 30%           |
      | $19.99+     | 500          | 10%           |
    And I should see purchase trigger analysis
    And I should see conversion optimization suggestions

  @api @analytics @revenue
  Scenario: Track subscription metrics
    Given I offer subscription tiers
    When I view subscription analytics
    Then I should see subscription metrics:
      | tier      | subscribers | mrr     | churn_rate | avg_tenure |
      | basic     | 500         | $2,500  | 8%         | 4 months   |
      | premium   | 200         | $4,000  | 5%         | 8 months   |
      | ultimate  | 50          | $1,500  | 3%         | 12 months  |
    And I should see subscription funnel
    And I should see upgrade/downgrade flow
    And I should see subscription retention curve

  @api @analytics @revenue
  Scenario: Analyze monetization by player journey
    Given I want to understand when players monetize
    When I view monetization journey analysis
    Then I should see conversion by journey stage:
      | stage              | players | payers | conversion | avg_spend |
      | first_hour         | 10,000  | 100    | 1%         | $2.00     |
      | first_day          | 8,500   | 425    | 5%         | $5.00     |
      | first_week         | 5,000   | 500    | 10%        | $8.00     |
      | first_month        | 2,500   | 500    | 20%        | $15.00    |
      | long_term (30d+)   | 1,500   | 600    | 40%        | $35.00    |
    And I should see optimal monetization touchpoints
    And I should see payer conversion funnel

  # ====================
  # VISUALIZATION
  # ====================

  @api @analytics @visualization
  Scenario: View world activity heatmaps
    Given my world has zone-based activity tracking
    When I view activity heatmaps
    Then I should see player concentration visualization:
      | zone_name       | current_players | peak_players | avg_time_spent |
      | Starting Town   | 150             | 300          | 15 min         |
      | Dark Forest     | 80              | 200          | 45 min         |
      | Dragon's Keep   | 45              | 150          | 60 min         |
      | Market Square   | 200             | 400          | 20 min         |
    And I should see activity intensity color coding
    And I should see time-based pattern animation
    And I should be able to filter by player type
    And I should be able to select time range

  @api @analytics @visualization
  Scenario: View player flow visualization
    Given player movement is tracked between zones
    When I view the player flow diagram
    Then I should see movement patterns between zones:
      | from_zone       | to_zone        | flow_count | percentage |
      | Starting Town   | Dark Forest    | 5,000      | 40%        |
      | Starting Town   | Market Square  | 4,000      | 32%        |
      | Dark Forest     | Dragon's Keep  | 2,000      | 25%        |
      | Market Square   | Starting Town  | 3,500      | 45%        |
    And I should see sankey diagram of player flow
    And I should see popular paths highlighted
    And I should see dead-end areas identified
    And I should see bottleneck locations marked

  @api @analytics @visualization
  Scenario: View timeline visualization
    Given I want to see historical events
    When I view the analytics timeline
    Then I should see key events plotted on timeline:
      | date       | event_type      | description         | impact    |
      | 2024-01-15 | update          | v2.0 Released       | +25% DAU  |
      | 2024-02-01 | event           | Valentine Event     | +50% revenue |
      | 2024-02-15 | incident        | Server Outage       | -15% DAU  |
    And I should see metric overlays on timeline
    And I should be able to annotate custom events
    And I should see correlation analysis

  @api @analytics @visualization
  Scenario: Create custom data visualization
    Given I want to visualize specific data
    When I create a custom visualization:
      | field        | value                      |
      | chart_type   | multi_axis_line            |
      | primary_y    | daily_active_users         |
      | secondary_y  | revenue                    |
      | x_axis       | date                       |
      | date_range   | last_90_days               |
      | annotations  | major_updates              |
    Then the visualization should be rendered
    And I should be able to interact with data points
    And I should be able to save to dashboard
    And I should be able to export as image

  # ====================
  # DATA EXPORT
  # ====================

  @api @analytics @export
  Scenario: Export analytics data to file
    Given I need to export player behavior data
    When I configure data export:
      | field        | value              |
      | data_type    | player_behavior    |
      | date_range   | last_30_days       |
      | format       | CSV                |
      | granularity  | daily              |
      | anonymize    | true               |
    Then the export should be generated
    And I should receive download link
    And the file should contain expected columns
    And PII should be anonymized according to settings
    And export should complete within 5 minutes

  @api @analytics @export
  Scenario: Configure automated data pipeline
    Given I want to set up continuous data export
    When I configure a data export pipeline:
      | field        | value                    |
      | destination  | BigQuery                 |
      | frequency    | daily at 2:00 AM UTC     |
      | data_sets    | events, sessions, economy|
      | format       | Parquet                  |
      | compression  | snappy                   |
    Then the pipeline should be configured
    And I should see connection test results
    And data should begin flowing automatically
    And I should see pipeline health dashboard

  @api @analytics @export
  Scenario: Use analytics API
    Given API access is enabled for my world
    When I view analytics API documentation
    Then I should see available endpoints:
      | endpoint              | method | description           |
      | /analytics/metrics    | GET    | Retrieve metrics      |
      | /analytics/reports    | GET    | Get report data       |
      | /analytics/segments   | GET    | Get segment data      |
      | /analytics/events     | GET    | Query event stream    |
    And I should see API key management
    And I should see rate limiting information
    And I should see code examples in multiple languages

  @api @analytics @export
  Scenario: Export data for compliance
    Given I need to export data for audit purposes
    When I create compliance export:
      | field           | value              |
      | export_type     | gdpr_data_request  |
      | player_id       | player_12345       |
      | include         | all_personal_data  |
      | format          | JSON               |
      | encryption      | AES-256            |
    Then the compliance export should be generated
    And all personal data should be included
    And export should be encrypted
    And audit log should be created

  # ====================
  # ANALYTICS ALERTS
  # ====================

  @api @analytics @alerts
  Scenario: Configure analytics alerts
    Given I want proactive notifications
    When I configure analytics alerts:
      | metric             | condition    | threshold | channel | severity |
      | daily_active_users | drops_below  | 1000      | email   | warning  |
      | error_rate         | exceeds      | 5%        | slack   | critical |
      | revenue_daily      | drops_by     | 20%       | email   | urgent   |
      | concurrent_users   | exceeds      | 4500      | slack   | info     |
    Then alerts should be saved successfully
    And I should be able to test each alert
    And alerts should trigger when conditions are met
    And I should see alert preview

  @api @analytics @alerts
  Scenario: View and manage alert history
    Given I have configured alerts
    And some alerts have been triggered
    When I view alert history
    Then I should see triggered alerts:
      | alert_name    | triggered_at     | value   | threshold | status    |
      | DAU Drop      | 2024-02-15 08:00 | 950     | 1000      | resolved  |
      | Error Spike   | 2024-02-14 14:30 | 6.5%    | 5%        | resolved  |
      | Revenue Drop  | 2024-02-10 00:00 | -22%    | -20%      | acknowledged |
    And I should see alert resolution actions
    And I should see alert patterns and frequency
    And I should be able to adjust thresholds based on history

  @api @analytics @alerts
  Scenario: Create composite alert rule
    Given I want to alert on complex conditions
    When I create a composite alert:
      | field          | value                                    |
      | name           | Engagement Crisis                        |
      | conditions     | DAU < 1000 AND retention_d1 < 30% AND sentiment < 50% |
      | logic          | ALL conditions must be true              |
      | duration       | sustained for 24 hours                   |
      | actions        | email + slack + on_call                  |
    Then the composite alert should be created
    And I should see condition monitoring status
    And alert should only fire when all conditions met

  # ====================
  # BENCHMARKS
  # ====================

  @api @analytics @benchmarks
  Scenario: Compare metrics to industry benchmarks
    Given industry benchmark data is available
    When I view benchmark comparison
    Then I should see my metrics versus industry:
      | metric           | my_world | benchmark | percentile | status   |
      | day_1_retention  | 40%      | 35%       | 65th       | above    |
      | day_7_retention  | 20%      | 25%       | 35th       | below    |
      | day_30_retention | 10%      | 12%       | 40th       | below    |
      | arpu             | $2.50    | $3.00     | 45th       | below    |
      | session_time     | 45 min   | 30 min    | 80th       | above    |
    And I should see improvement opportunities
    And I should see peer comparison (anonymized)
    And I should see benchmark methodology

  @api @analytics @benchmarks
  Scenario: Set and track performance goals
    Given I want to improve specific metrics
    When I set performance goals:
      | metric           | current | goal   | deadline   | milestones |
      | day_7_retention  | 20%     | 30%    | 2024-06-30 | 22%, 25%, 28% |
      | arpu             | $2.50   | $3.50  | 2024-09-30 | $2.75, $3.00, $3.25 |
      | dau              | 1200    | 2000   | 2024-12-31 | 1400, 1600, 1800 |
    Then goals should be saved and tracked
    And I should see progress indicators on dashboard
    And I should receive milestone notifications
    And I should see goal projection based on current trend

  @api @analytics @benchmarks
  Scenario: Generate improvement recommendations
    Given my metrics are below benchmarks
    When I request improvement recommendations
    Then I should see actionable recommendations:
      | area            | current | target | recommendations                    |
      | day_7_retention | 20%     | 25%    | Improve tutorial, add day 3 reward |
      | arpu            | $2.50   | $3.00  | Optimize store, add bundle offers  |
      | session_time    | 45 min  | 50 min | Add daily quests, improve content  |
    And each recommendation should include expected impact
    And I should see implementation priority
    And I should be able to track recommendation adoption

  # ====================
  # DOMAIN EVENTS
  # ====================

  @domain-events
  Scenario: AnalyticsReportGenerated event triggers distribution
    Given report "Weekly KPI Report" has been generated
    When the AnalyticsReportGenerated event is published with:
      | field         | value                 |
      | report_id     | rpt-12345             |
      | report_name   | Weekly KPI Report     |
      | generated_at  | 2024-02-19T09:00:00Z  |
      | format        | PDF                   |
      | recipients    | team@example.com      |
    Then the report should be distributed to all recipients
    And the report should be archived in report storage
    And report generation should be logged for audit
    And report delivery confirmation should be tracked

  @domain-events
  Scenario: AnalyticsAlertTriggered event sends notifications
    Given alert "DAU Drop Alert" threshold has been breached
    When the AnalyticsAlertTriggered event is published with:
      | field         | value              |
      | alert_id      | alert-67890        |
      | alert_name    | DAU Drop Alert     |
      | metric        | daily_active_users |
      | current_value | 950                |
      | threshold     | 1000               |
      | severity      | warning            |
    Then notifications should be sent to configured channels
    And the alert should be logged in alert history
    And the dashboard should show alert indicator
    And on-call team should be notified if severity is critical

  @domain-events
  Scenario: AnalyticsExportCompleted event notifies user
    Given a large data export was requested
    When the AnalyticsExportCompleted event is published with:
      | field         | value              |
      | export_id     | exp-11111          |
      | requested_by  | user-12345         |
      | data_type     | player_behavior    |
      | file_size     | 250 MB             |
      | download_url  | https://...        |
      | expires_at    | 2024-02-26T00:00Z  |
    Then the requesting user should receive notification
    And the download link should be sent via email
    And export should be logged for compliance
    And expiration reminder should be scheduled

  @domain-events
  Scenario: PredictiveInsightGenerated event updates dashboard
    Given new churn predictions have been calculated
    When the PredictiveInsightGenerated event is published with:
      | field           | value            |
      | insight_type    | churn_prediction |
      | model_version   | v2.3             |
      | generated_at    | 2024-02-19T06:00Z|
      | accuracy_score  | 0.85             |
      | players_at_risk | 234              |
    Then the predictive analytics dashboard should update
    And insight notifications should be sent to subscribers
    And historical accuracy should be recorded
    And retention team should be notified of high-risk players

  @domain-events
  Scenario: ABTestCompleted event triggers analysis
    Given A/B test "Tutorial Flow" has reached completion criteria
    When the ABTestCompleted event is published with:
      | field           | value            |
      | test_id         | test-99999       |
      | test_name       | Tutorial Flow    |
      | winning_variant | variant_a        |
      | confidence      | 95%              |
      | lift            | +10.8%           |
    Then test results should be finalized
    And stakeholders should be notified
    And implementation recommendation should be generated
    And test should be archived with full data

  # ====================
  # ERROR HANDLING
  # ====================

  @api @error
  Scenario: Handle analytics service unavailable
    Given the analytics data service is experiencing issues
    When I attempt to access the analytics dashboard
    Then I should see a service status notification
    And I should see cached data from last successful load
    And the cached data timestamp should be clearly displayed
    And I should see expected recovery time if available
    And I should have option to refresh when service recovers

  @api @error
  Scenario: Handle large data export timeout
    Given I request an export with 10 million records
    When the export takes longer than the timeout threshold
    Then I should receive a notification that export is processing
    And the export should continue in background
    And I should see export progress indicator
    And I should receive download link when complete
    And I should be able to cancel the export if needed

  @api @error
  Scenario: Handle invalid date range selection
    Given I am configuring an analytics query
    When I select an invalid date range:
      | start_date | 2024-03-01 |
      | end_date   | 2024-02-01 |
    Then I should see validation error "End date must be after start date"
    And the query should not execute
    And I should be guided to correct the selection

  @api @error
  Scenario: Handle insufficient data for predictions
    Given my world has been active for only 7 days
    When I attempt to view predictive analytics
    Then I should see message "Insufficient data for predictions"
    And I should see minimum data requirements:
      | model_type      | min_days | min_events |
      | churn_prediction| 30       | 10,000     |
      | revenue_forecast| 60       | 5,000      |
      | ltv_prediction  | 90       | 1,000      |
    And I should see progress toward requirements
    And basic analytics should still be available

  @api @error
  Scenario: Handle rate limiting on analytics queries
    Given I have exceeded my analytics query quota
    When I attempt to run another query
    Then I should see rate limit notification
    And I should see my current usage:
      | quota_type    | used   | limit  | resets_at      |
      | queries_hour  | 100    | 100    | in 45 minutes  |
      | export_daily  | 10     | 10     | tomorrow       |
    And I should see options to upgrade quota
    And I should be able to schedule query for later

  @api @error
  Scenario: Handle corrupted visualization data
    Given a visualization widget has corrupted data
    When the dashboard attempts to render
    Then the corrupted widget should show error state
    And other widgets should render normally
    And I should see "Unable to load visualization" message
    And I should have option to report the issue
    And I should be able to remove or reset the widget

  @api @error
  Scenario: Handle benchmark data unavailable
    Given industry benchmark service is unavailable
    When I attempt to view benchmark comparison
    Then I should see message "Benchmark data temporarily unavailable"
    And my own metrics should still be displayed
    And I should see last available benchmark date
    And I should have option to be notified when restored
