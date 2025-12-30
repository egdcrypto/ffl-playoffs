@admin @reporting @ANIMA-1089
Feature: Admin Reporting System
  As a platform administrator
  I want to generate and manage comprehensive reports
  So that I can track performance, compliance, and business metrics effectively

  Background:
    Given I am logged in as a platform administrator
    And I have reporting system permissions
    And the reporting system is active

  # =============================================================================
  # REPORT GENERATION DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: Access report generation interface
    When I navigate to the report generation dashboard
    Then I should see available report categories:
      | category           | report_count | last_generated |
      | Financial          | 12           | 2 hours ago    |
      | User Analytics     | 18           | 1 hour ago     |
      | System Performance | 8            | 30 minutes ago |
      | Compliance         | 6            | 1 day ago      |
      | Marketing          | 10           | 3 hours ago    |
    And I should see recent reports
    And I should see scheduled reports
    And I should see report generation queue

  @dashboard @quick-reports
  Scenario: Generate quick reports from dashboard
    Given I am on the report generation dashboard
    When I select "Quick Report" for "Daily Active Users"
    Then the report should generate immediately
    And I should see a preview of the report
    And I should be able to download or share the report

  @dashboard @favorites
  Scenario: Access favorite reports
    Given I have saved favorite reports
    When I view my favorite reports
    Then I should see my saved reports:
      | report_name              | last_run     | frequency |
      | Weekly Revenue Summary   | 3 days ago   | weekly    |
      | Monthly User Growth      | 2 weeks ago  | monthly   |
      | Daily Error Report       | today        | daily     |
    And I should be able to run any favorite immediately

  @dashboard @recent
  Scenario: View recently generated reports
    When I view recently generated reports
    Then I should see reports from the last 7 days:
      | report_name          | generated_by   | date       | size   |
      | Q2 Financial Summary | admin@ffl.com  | 2024-06-15 | 2.5 MB |
      | User Retention Report| analyst@ffl.com| 2024-06-14 | 1.2 MB |
      | System Health Report | ops@ffl.com    | 2024-06-14 | 850 KB |
    And I should be able to download or view any report

  # =============================================================================
  # FINANCIAL REPORTS
  # =============================================================================

  @financial @revenue
  Scenario: Generate revenue report
    When I generate a revenue report:
      | parameter      | value           |
      | date_range     | Q2 2024         |
      | breakdown      | monthly         |
      | segments       | subscription, ads|
      | comparison     | YoY             |
    Then the revenue report should include:
      | metric              | value        |
      | total_revenue       | $1,250,000   |
      | subscription_revenue| $950,000     |
      | ad_revenue          | $300,000     |
      | yoy_growth          | +18%         |
    And I should see revenue trends chart

  @financial @expenses
  Scenario: Generate expense report
    When I generate an expense report:
      | parameter      | value           |
      | date_range     | June 2024       |
      | categories     | all             |
      | cost_centers   | all             |
    Then the expense report should include:
      | category            | amount      | budget   | variance |
      | Infrastructure      | $125,000    | $130,000 | -$5,000  |
      | Personnel           | $450,000    | $450,000 | $0       |
      | Marketing           | $85,000     | $100,000 | -$15,000 |
      | Operations          | $65,000     | $60,000  | +$5,000  |
    And I should see expense breakdown charts

  @financial @profit-loss
  Scenario: Generate profit and loss statement
    When I generate a P&L report for "H1 2024"
    Then the report should include:
      | line_item           | amount       |
      | Gross Revenue       | $2,500,000   |
      | Cost of Goods       | $750,000     |
      | Gross Profit        | $1,750,000   |
      | Operating Expenses  | $1,200,000   |
      | Net Income          | $550,000     |
    And I should see margin percentages
    And I should see period comparisons

  @financial @billing
  Scenario: Generate billing and subscription report
    When I generate a billing report
    Then I should see billing metrics:
      | metric              | value        |
      | active_subscriptions| 45,000       |
      | monthly_recurring   | $180,000     |
      | churn_rate          | 3.2%         |
      | avg_revenue_per_user| $4.00        |
      | failed_payments     | 125          |
    And I should see subscription tier breakdown
    And I should see payment method distribution

  @financial @forecasting
  Scenario: Generate financial forecast report
    When I generate a financial forecast:
      | parameter      | value           |
      | forecast_period| 6 months        |
      | model          | trend_based     |
      | confidence     | 95%             |
    Then the forecast should include:
      | month     | projected_revenue | confidence_range    |
      | July      | $430,000          | $410,000 - $450,000 |
      | August    | $445,000          | $420,000 - $470,000 |
      | September | $465,000          | $435,000 - $495,000 |
    And I should see forecast assumptions
    And I should see risk factors

  # =============================================================================
  # USER ACTIVITY REPORTS
  # =============================================================================

  @user-activity @engagement
  Scenario: Generate user engagement report
    When I generate a user engagement report:
      | parameter      | value           |
      | date_range     | last 30 days    |
      | user_segments  | all             |
      | metrics        | comprehensive   |
    Then the report should include:
      | metric              | value    | trend   |
      | daily_active_users  | 45,000   | +5%     |
      | weekly_active_users | 120,000  | +8%     |
      | avg_session_duration| 8.5 min  | +1.2min |
      | sessions_per_user   | 4.2      | +0.5    |
      | feature_adoption    | 72%      | +3%     |
    And I should see engagement by user cohort

  @user-activity @retention
  Scenario: Generate retention report
    When I generate a retention report
    Then I should see retention cohorts:
      | cohort      | day_1 | day_7 | day_30 | day_90 |
      | Jan 2024    | 85%   | 65%   | 45%    | 32%    |
      | Feb 2024    | 88%   | 68%   | 48%    | 35%    |
      | Mar 2024    | 86%   | 66%   | 47%    | -      |
    And I should see retention curves
    And I should see churn analysis

  @user-activity @acquisition
  Scenario: Generate user acquisition report
    When I generate an acquisition report:
      | parameter      | value           |
      | date_range     | Q2 2024         |
      | channels       | all             |
    Then the report should include:
      | channel         | users   | cost     | cac      |
      | organic_search  | 15,000  | $0       | $0       |
      | paid_search     | 8,000   | $24,000  | $3.00    |
      | social_media    | 12,000  | $18,000  | $1.50    |
      | referral        | 5,000   | $5,000   | $1.00    |
    And I should see conversion funnels by channel

  @user-activity @behavior
  Scenario: Generate user behavior report
    When I generate a behavior analytics report
    Then I should see behavior patterns:
      | behavior              | percentage | trend   |
      | roster_editors        | 65%        | +5%     |
      | score_checkers        | 85%        | stable  |
      | trade_participants    | 35%        | +8%     |
      | waiver_users          | 45%        | +3%     |
    And I should see user journey maps
    And I should see feature usage heatmaps

  @user-activity @segmentation
  Scenario: Generate user segmentation report
    When I generate a segmentation report
    Then I should see user segments:
      | segment         | size   | avg_revenue | engagement |
      | power_users     | 12%    | $12.00      | very_high  |
      | regular_users   | 45%    | $5.00       | high       |
      | casual_users    | 30%    | $2.00       | medium     |
      | at_risk         | 8%     | $1.50       | low        |
      | dormant         | 5%     | $0.50       | minimal    |
    And I should see segment characteristics
    And I should see segment trends

  # =============================================================================
  # SYSTEM PERFORMANCE REPORTS
  # =============================================================================

  @performance @infrastructure
  Scenario: Generate system performance report
    When I generate a system performance report:
      | parameter      | value           |
      | date_range     | last 7 days     |
      | components     | all             |
      | granularity    | hourly          |
    Then the report should include:
      | metric              | avg      | peak     | threshold |
      | cpu_utilization     | 45%      | 82%      | 80%       |
      | memory_usage        | 62%      | 78%      | 85%       |
      | response_time       | 180ms    | 450ms    | 500ms     |
      | error_rate          | 0.3%     | 1.2%     | 1%        |
    And I should see performance trends
    And I should see capacity recommendations

  @performance @availability
  Scenario: Generate availability report
    When I generate an availability report
    Then the report should include:
      | service             | uptime   | incidents | mttr      |
      | api_gateway         | 99.95%   | 2         | 15 min    |
      | database_cluster    | 99.99%   | 0         | n/a       |
      | scoring_service     | 99.92%   | 3         | 25 min    |
      | notification_service| 99.88%   | 4         | 18 min    |
    And I should see downtime analysis
    And I should see SLA compliance status

  @performance @api
  Scenario: Generate API performance report
    When I generate an API performance report
    Then the report should include:
      | endpoint            | requests  | avg_time | p99_time | errors |
      | /api/v1/scores      | 2.5M      | 85ms     | 250ms    | 0.2%   |
      | /api/v1/players     | 1.8M      | 120ms    | 380ms    | 0.3%   |
      | /api/v1/rosters     | 1.2M      | 95ms     | 290ms    | 0.1%   |
      | /api/v1/trades      | 450K      | 150ms    | 420ms    | 0.4%   |
    And I should see endpoint performance trends
    And I should see slow endpoint analysis

  @performance @database
  Scenario: Generate database performance report
    When I generate a database performance report
    Then the report should include:
      | metric              | value    | trend   |
      | query_throughput    | 5,000/s  | +8%     |
      | avg_query_time      | 12ms     | -15%    |
      | connection_pool     | 75%      | stable  |
      | slow_queries        | 45/day   | -20%    |
      | index_usage         | 92%      | +2%     |
    And I should see query analysis
    And I should see optimization recommendations

  @performance @scaling
  Scenario: Generate capacity and scaling report
    When I generate a capacity report
    Then the report should include:
      | resource            | current  | projected_30d | headroom |
      | compute_instances   | 24       | 28            | 16%      |
      | database_storage    | 850 GB   | 920 GB        | 8%       |
      | bandwidth           | 2.5 Gbps | 3.0 Gbps      | 16%      |
      | cache_memory        | 32 GB    | 38 GB         | 15%      |
    And I should see scaling recommendations
    And I should see cost projections

  # =============================================================================
  # COMPLIANCE AND AUDIT REPORTS
  # =============================================================================

  @compliance @audit-trail
  Scenario: Generate audit trail report
    When I generate an audit trail report:
      | parameter      | value           |
      | date_range     | last 90 days    |
      | event_types    | all             |
      | users          | all             |
    Then the report should include audit events:
      | event_type          | count  | users  |
      | login_attempts      | 125,000| 45,000 |
      | data_access         | 850,000| 42,000 |
      | configuration_change| 450    | 25     |
      | permission_change   | 120    | 15     |
    And I should see detailed event logs
    And I should see suspicious activity flags

  @compliance @gdpr
  Scenario: Generate GDPR compliance report
    When I generate a GDPR compliance report
    Then the report should include:
      | requirement            | status     | evidence_count |
      | consent_management     | compliant  | 45,000         |
      | data_access_requests   | compliant  | 128            |
      | data_deletion_requests | compliant  | 45             |
      | breach_notifications   | compliant  | 0              |
      | dpo_documentation      | compliant  | verified       |
    And I should see compliance gaps if any
    And I should see remediation recommendations

  @compliance @soc2
  Scenario: Generate SOC2 compliance report
    When I generate a SOC2 compliance report
    Then the report should include:
      | trust_principle     | controls | compliant | gaps |
      | security            | 45       | 44        | 1    |
      | availability        | 18       | 18        | 0    |
      | processing_integrity| 22       | 21        | 1    |
      | confidentiality     | 15       | 15        | 0    |
      | privacy             | 12       | 12        | 0    |
    And I should see control evidence
    And I should see gap remediation status

  @compliance @access-review
  Scenario: Generate access review report
    When I generate an access review report
    Then the report should include:
      | access_level        | users  | last_review | excessive |
      | admin               | 15     | 30 days ago | 2         |
      | moderator           | 45     | 45 days ago | 5         |
      | support             | 120    | 60 days ago | 12        |
      | read_only           | 350    | 90 days ago | 25        |
    And I should see recommendations for access cleanup
    And I should see orphaned accounts

  @compliance @data-retention
  Scenario: Generate data retention compliance report
    When I generate a data retention report
    Then the report should include:
      | data_category       | retention_policy | compliant | volume    |
      | user_data           | 7 years          | yes       | 250 GB    |
      | transaction_logs    | 5 years          | yes       | 180 GB    |
      | session_data        | 90 days          | yes       | 45 GB     |
      | marketing_data      | 2 years          | warning   | 120 GB    |
    And I should see data pending deletion
    And I should see retention policy violations

  # =============================================================================
  # MARKETING REPORTS
  # =============================================================================

  @marketing @campaign
  Scenario: Generate marketing campaign performance report
    When I generate a campaign performance report:
      | parameter      | value           |
      | date_range     | Q2 2024         |
      | campaigns      | all_active      |
    Then the report should include:
      | campaign            | impressions | clicks  | conversions | roi    |
      | summer_promo        | 2.5M        | 125,000 | 8,500       | 250%   |
      | referral_bonus      | 1.2M        | 85,000  | 12,000      | 380%   |
      | playoff_push        | 3.8M        | 190,000 | 15,000      | 320%   |
    And I should see campaign attribution
    And I should see channel performance

  @marketing @email
  Scenario: Generate email marketing report
    When I generate an email marketing report
    Then the report should include:
      | campaign_type       | sent    | opened | clicked | converted |
      | weekly_newsletter   | 120,000 | 35%    | 12%     | 3%        |
      | promotional         | 85,000  | 28%    | 15%     | 5%        |
      | transactional       | 450,000 | 72%    | 25%     | n/a       |
      | re_engagement       | 25,000  | 18%    | 8%      | 2%        |
    And I should see email performance trends
    And I should see optimal send time analysis

  @marketing @social
  Scenario: Generate social media report
    When I generate a social media report
    Then the report should include:
      | platform    | followers | engagement | reach   | growth |
      | Twitter     | 125,000   | 4.2%       | 850,000 | +8%    |
      | Instagram   | 85,000    | 5.8%       | 420,000 | +12%   |
      | Facebook    | 200,000   | 2.5%       | 1.2M    | +3%    |
      | TikTok      | 45,000    | 8.5%       | 380,000 | +25%   |
    And I should see content performance
    And I should see audience demographics

  @marketing @attribution
  Scenario: Generate marketing attribution report
    When I generate an attribution report
    Then the report should include:
      | touchpoint          | first_touch | last_touch | multi_touch |
      | organic_search      | 35%         | 25%        | 28%         |
      | paid_search         | 20%         | 30%        | 25%         |
      | social_media        | 25%         | 15%        | 22%         |
      | email               | 10%         | 20%        | 15%         |
      | direct              | 10%         | 10%        | 10%         |
    And I should see customer journey analysis
    And I should see channel synergy effects

  @marketing @roi
  Scenario: Generate marketing ROI report
    When I generate a marketing ROI report
    Then the report should include:
      | channel         | spend    | revenue  | roi    | cac     |
      | paid_search     | $25,000  | $85,000  | 240%   | $3.50   |
      | social_ads      | $18,000  | $52,000  | 189%   | $2.80   |
      | content_mktg    | $12,000  | $45,000  | 275%   | $1.80   |
      | influencer      | $8,000   | $32,000  | 300%   | $2.20   |
    And I should see ROI trends over time
    And I should see budget optimization recommendations

  # =============================================================================
  # CONTENT REPORTS
  # =============================================================================

  @content @creation
  Scenario: Generate content creation report
    When I generate a content creation report
    Then the report should include:
      | content_type        | created | published | engagement |
      | articles            | 45      | 42        | 125,000    |
      | videos              | 12      | 12        | 85,000     |
      | infographics        | 8       | 8         | 45,000     |
      | podcasts            | 4       | 4         | 22,000     |
    And I should see content calendar status
    And I should see content performance metrics

  @content @consumption
  Scenario: Generate content consumption report
    When I generate a content consumption report
    Then the report should include:
      | content_category    | views   | avg_time | completion |
      | player_stats        | 2.5M    | 3.2 min  | 75%        |
      | news_articles       | 1.8M    | 2.5 min  | 65%        |
      | fantasy_tips        | 1.2M    | 4.5 min  | 82%        |
      | video_highlights    | 850K    | 2.8 min  | 70%        |
    And I should see content preferences by segment
    And I should see trending content

  @content @performance
  Scenario: Generate content performance report
    When I generate a content performance report
    Then the report should include top performing content:
      | content_title           | views   | shares | engagement_rate |
      | Week 12 Rankings        | 125,000 | 8,500  | 12%             |
      | Trade Deadline Analysis | 98,000  | 6,200  | 15%             |
      | Waiver Wire Picks       | 85,000  | 5,800  | 14%             |
    And I should see content optimization recommendations
    And I should see SEO performance

  # =============================================================================
  # CUSTOMER SUPPORT REPORTS
  # =============================================================================

  @support @tickets
  Scenario: Generate support ticket analytics report
    When I generate a support ticket report
    Then the report should include:
      | metric              | value   | trend   | target  |
      | total_tickets       | 2,450   | +5%     | -       |
      | avg_resolution_time | 4.2 hrs | -15%    | 6 hrs   |
      | first_response_time | 45 min  | -20%    | 1 hr    |
      | customer_satisfaction| 4.5/5  | +0.2    | 4.0     |
      | resolution_rate     | 92%     | +3%     | 90%     |
    And I should see ticket volume trends
    And I should see agent performance

  @support @categories
  Scenario: Generate support category analysis
    When I generate a support category report
    Then the report should include:
      | category            | tickets | resolution | satisfaction |
      | billing_issues      | 450     | 2.5 hrs    | 4.2/5        |
      | technical_problems  | 680     | 5.2 hrs    | 4.0/5        |
      | account_access      | 320     | 1.8 hrs    | 4.6/5        |
      | feature_requests    | 280     | n/a        | 4.3/5        |
      | bug_reports         | 420     | 4.5 hrs    | 3.8/5        |
    And I should see category trends
    And I should see escalation patterns

  @support @agent
  Scenario: Generate agent performance report
    When I generate an agent performance report
    Then the report should include:
      | agent           | tickets_closed | avg_resolution | satisfaction |
      | agent_1         | 245            | 3.8 hrs        | 4.7/5        |
      | agent_2         | 218            | 4.2 hrs        | 4.5/5        |
      | agent_3         | 198            | 4.5 hrs        | 4.3/5        |
    And I should see agent utilization
    And I should see training recommendations

  @support @self-service
  Scenario: Generate self-service analytics report
    When I generate a self-service report
    Then the report should include:
      | metric              | value   |
      | help_article_views  | 125,000 |
      | search_queries      | 45,000  |
      | successful_self_help| 65%     |
      | escalation_rate     | 35%     |
      | chatbot_resolution  | 45%     |
    And I should see top help articles
    And I should see failed search analysis

  # =============================================================================
  # SECURITY REPORTS
  # =============================================================================

  @security @incidents
  Scenario: Generate security incident report
    When I generate a security incident report:
      | parameter      | value           |
      | date_range     | last 90 days    |
      | severity       | all             |
    Then the report should include:
      | incident_type       | count | severity | resolved | avg_time |
      | failed_logins       | 1,250 | low      | 100%     | n/a      |
      | suspicious_access   | 45    | medium   | 100%     | 2 hrs    |
      | data_breach_attempt | 3     | high     | 100%     | 4 hrs    |
      | ddos_attack         | 2     | critical | 100%     | 1 hr     |
    And I should see incident timeline
    And I should see response effectiveness

  @security @threats
  Scenario: Generate threat analysis report
    When I generate a threat analysis report
    Then the report should include:
      | threat_type         | attempts | blocked | success_rate |
      | brute_force         | 5,200    | 5,198   | 99.96%       |
      | sql_injection       | 1,450    | 1,450   | 100%         |
      | xss_attempts        | 890      | 890     | 100%         |
      | api_abuse           | 320      | 315     | 98.4%        |
    And I should see threat trends
    And I should see threat intelligence

  @security @vulnerability
  Scenario: Generate vulnerability report
    When I generate a vulnerability report
    Then the report should include:
      | severity    | open | fixed | avg_fix_time |
      | critical    | 0    | 5     | 24 hrs       |
      | high        | 2    | 18    | 72 hrs       |
      | medium      | 8    | 45    | 7 days       |
      | low         | 15   | 120   | 30 days      |
    And I should see vulnerability aging
    And I should see remediation progress

  @security @access
  Scenario: Generate access security report
    When I generate an access security report
    Then the report should include:
      | metric                  | value   |
      | mfa_adoption            | 85%     |
      | password_strength_avg   | strong  |
      | dormant_accounts        | 245     |
      | privileged_users        | 35      |
      | api_key_rotation_due    | 12      |
    And I should see access anomalies
    And I should see security recommendations

  # =============================================================================
  # CUSTOM REPORT BUILDER
  # =============================================================================

  @custom @builder
  Scenario: Create custom report using report builder
    When I access the report builder
    Then I should see available data sources:
      | data_source         | tables | fields |
      | user_analytics      | 12     | 85     |
      | financial_data      | 8      | 62     |
      | system_metrics      | 15     | 120    |
      | content_analytics   | 6      | 45     |
    And I should be able to drag-and-drop fields
    And I should see preview as I build

  @custom @query
  Scenario: Build custom query for report
    When I build a custom report query:
      | element         | selection                    |
      | data_source     | user_analytics               |
      | dimensions      | user_segment, acquisition_channel |
      | measures        | revenue, session_count       |
      | filters         | date >= 2024-01-01           |
      | grouping        | user_segment                 |
    Then the query should be validated
    And I should see query preview
    And I should see estimated execution time

  @custom @templates
  Scenario: Save custom report as template
    Given I have created a custom report
    When I save the report as a template:
      | field          | value                    |
      | template_name  | Monthly Segment Analysis |
      | description    | User segment breakdown   |
      | category       | User Analytics           |
      | shared_with    | analytics_team           |
    Then the template should be saved
    And the template should be available for reuse

  @custom @formulas
  Scenario: Add calculated fields to custom report
    When I add calculated fields:
      | field_name      | formula                      |
      | conversion_rate | conversions / visitors * 100 |
      | avg_order_value | revenue / orders             |
      | ltv_estimate    | avg_order_value * frequency  |
    Then calculated fields should be available
    And I should see formula validation

  @custom @joins
  Scenario: Join multiple data sources
    When I join data sources:
      | primary_source  | join_source    | join_key     | join_type |
      | user_analytics  | financial_data | user_id      | left      |
      | user_analytics  | content_views  | session_id   | inner     |
    Then data sources should be joined
    And I should see combined field list

  # =============================================================================
  # REPORT DISTRIBUTION
  # =============================================================================

  @distribution @access
  Scenario: Manage report access permissions
    When I configure report access:
      | report_name         | access_level | users_groups         |
      | Financial Summary   | restricted   | finance_team, execs  |
      | User Analytics      | internal     | all_employees        |
      | Public Metrics      | public       | all                  |
    Then access permissions should be applied
    And unauthorized access should be blocked

  @distribution @sharing
  Scenario: Share report with stakeholders
    When I share a report:
      | parameter        | value                    |
      | report           | Q2 Performance Summary   |
      | recipients       | ceo@ffl.com, cfo@ffl.com |
      | format           | PDF                      |
      | include_data     | yes                      |
      | message          | Q2 results attached      |
    Then the report should be shared
    And recipients should receive notification

  @distribution @subscriptions
  Scenario: Manage report subscriptions
    When I configure report subscriptions:
      | report              | frequency | recipients         | format |
      | Daily KPIs          | daily     | leadership_team    | email  |
      | Weekly Summary      | weekly    | all_managers       | PDF    |
      | Monthly Financials  | monthly   | finance_team       | Excel  |
    Then subscriptions should be active
    And reports should be delivered on schedule

  @distribution @export
  Scenario: Export reports in multiple formats
    Given a report is generated
    When I export the report
    Then I should see export options:
      | format    | options                    |
      | PDF       | page_size, orientation     |
      | Excel     | include_charts, raw_data   |
      | CSV       | delimiter, encoding        |
      | PowerPoint| slides_per_section         |
      | JSON      | api_compatible             |
    And I should be able to download in any format

  @distribution @embedding
  Scenario: Embed reports in dashboards
    When I configure report embedding:
      | report          | embed_target    | refresh_rate |
      | Live Metrics    | exec_dashboard  | real_time    |
      | Weekly Trends   | team_dashboard  | hourly       |
    Then reports should be embedded
    And embedded reports should update automatically

  # =============================================================================
  # AUTOMATED REPORTING
  # =============================================================================

  @automation @scheduling
  Scenario: Schedule automated report generation
    When I schedule a report:
      | parameter       | value                |
      | report          | Weekly Performance   |
      | schedule        | every Monday 8:00 AM |
      | timezone        | America/New_York     |
      | delivery        | email + slack        |
      | recipients      | leadership_team      |
    Then the schedule should be created
    And I should see next run time

  @automation @triggers
  Scenario: Configure event-triggered reports
    When I configure trigger-based reporting:
      | trigger                | report_type       | recipients      |
      | error_rate > 5%        | Incident Report   | ops_team        |
      | revenue_drop > 10%     | Revenue Alert     | finance_team    |
      | new_user_milestone     | Milestone Report  | marketing_team  |
    Then triggers should be active
    And reports should generate on trigger events

  @automation @data-refresh
  Scenario: Configure automated data refresh
    When I configure data refresh:
      | data_source         | refresh_schedule | priority |
      | user_analytics      | every 15 min     | high     |
      | financial_data      | every hour       | high     |
      | content_metrics     | every 30 min     | medium   |
      | system_performance  | every 5 min      | critical |
    Then data refresh should be scheduled
    And stale data should be flagged

  @automation @workflows
  Scenario: Configure report generation workflows
    When I configure a report workflow:
      | step | action                | condition              |
      | 1    | generate_report       | scheduled              |
      | 2    | validate_data         | report_generated       |
      | 3    | send_for_review       | if_threshold_breached  |
      | 4    | distribute            | after_approval         |
    Then workflow should be active
    And reports should follow workflow steps

  # =============================================================================
  # VISUAL REPORTS
  # =============================================================================

  @visual @charts
  Scenario: Create visual reports with charts
    When I create a visual report:
      | chart_type    | data_source       | dimensions        |
      | line_chart    | revenue_over_time | date, revenue     |
      | bar_chart     | users_by_segment  | segment, count    |
      | pie_chart     | traffic_sources   | source, percentage|
      | heatmap       | user_activity     | hour, day, count  |
    Then charts should be generated
    And charts should be interactive

  @visual @dashboards
  Scenario: Create dashboard from reports
    When I create a dashboard:
      | widget_type   | report_source     | position   |
      | kpi_card      | daily_metrics     | top_row    |
      | line_chart    | revenue_trend     | middle_left|
      | bar_chart     | user_segments     | middle_right|
      | table         | top_content       | bottom     |
    Then dashboard should be created
    And widgets should be responsive

  @visual @themes
  Scenario: Apply visual themes to reports
    When I apply a theme to reports:
      | theme_element   | value              |
      | color_scheme    | corporate_blue     |
      | font_family     | Inter              |
      | logo            | company_logo.png   |
      | header_style    | modern             |
    Then theme should be applied
    And reports should be brand-consistent

  @visual @interactivity
  Scenario: Configure interactive report elements
    When I configure interactivity:
      | element         | interaction           | action           |
      | chart_point     | click                 | show_details     |
      | table_row       | hover                 | highlight        |
      | filter          | select                | update_all       |
      | date_range      | drag                  | filter_data      |
    Then interactivity should work
    And interactions should update visualizations

  # =============================================================================
  # REPORT PERFORMANCE
  # =============================================================================

  @performance @monitoring
  Scenario: Monitor report generation performance
    When I view report generation metrics
    Then I should see performance data:
      | report              | avg_gen_time | queries | data_size |
      | Daily KPIs          | 15s          | 12      | 2.5 MB    |
      | Weekly Summary      | 2.5 min      | 45      | 25 MB     |
      | Monthly Financials  | 8 min        | 120     | 150 MB    |
    And I should see slow report analysis
    And I should see optimization recommendations

  @performance @optimization
  Scenario: Optimize slow reports
    Given a report is taking too long
    When I analyze report performance
    Then I should see optimization suggestions:
      | optimization              | impact    | effort   |
      | add_index_on_date         | -40% time | low      |
      | cache_aggregations        | -30% time | medium   |
      | partition_large_tables    | -50% time | high     |
      | simplify_joins            | -20% time | low      |
    And I should be able to apply optimizations

  @performance @caching
  Scenario: Configure report caching
    When I configure report caching:
      | report              | cache_duration | invalidation      |
      | Daily Metrics       | 15 minutes     | on_data_update    |
      | Weekly Summary      | 4 hours        | scheduled         |
      | Historical Reports  | 24 hours       | manual            |
    Then caching should be configured
    And cache hit rate should improve

  @performance @queuing
  Scenario: Manage report generation queue
    When I view the report queue
    Then I should see queue status:
      | position | report              | status     | estimated_time |
      | 1        | Monthly Financials  | generating | 3 min          |
      | 2        | User Cohort Analysis| queued     | 5 min          |
      | 3        | Custom Report #42   | queued     | 2 min          |
    And I should be able to prioritize reports

  # =============================================================================
  # DATA QUALITY
  # =============================================================================

  @data-quality @validation
  Scenario: Validate report data accuracy
    When I run data quality checks on a report
    Then I should see validation results:
      | check_type          | status | issues |
      | completeness        | pass   | 0      |
      | consistency         | warning| 3      |
      | timeliness          | pass   | 0      |
      | accuracy            | pass   | 0      |
    And I should see issue details for warnings

  @data-quality @reconciliation
  Scenario: Reconcile report data with source systems
    When I reconcile financial report data
    Then I should see reconciliation results:
      | data_point          | report_value | source_value | variance |
      | total_revenue       | $1,250,000   | $1,250,000   | $0       |
      | subscription_count  | 45,000       | 45,012       | 12       |
      | transaction_count   | 128,500      | 128,500      | 0        |
    And I should see variance explanations

  @data-quality @lineage
  Scenario: View data lineage for reports
    When I view data lineage for a report
    Then I should see data flow:
      | source_system   | transformations      | final_field      |
      | payments_db     | aggregate, filter    | total_revenue    |
      | users_db        | join, calculate      | active_users     |
      | events_stream   | window, count        | daily_events     |
    And I should see transformation logic
    And I should see data freshness

  @data-quality @anomaly
  Scenario: Detect data anomalies in reports
    Given data quality monitoring is active
    When an anomaly is detected:
      | field           | expected | actual  | deviation |
      | daily_revenue   | $45,000  | $12,000 | -73%      |
    Then an anomaly alert should be raised
    And the report should be flagged
    And investigation should be prompted

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @generation-failure
  Scenario: Handle report generation failure
    Given a report is being generated
    When generation fails due to timeout
    Then the failure should be logged
    And I should receive failure notification
    And I should see retry options
    And partial results should be saved if possible

  @error-handling @data-unavailable
  Scenario: Handle missing data in reports
    Given some data sources are unavailable
    When I generate a report
    Then available data should be included
    And missing data should be clearly indicated
    And I should see data source status
    And approximate values should be flagged

  @edge-case @large-report
  Scenario: Handle very large report generation
    Given I request a report with millions of rows
    When the report size exceeds limits
    Then I should be offered alternatives:
      | option              | description              |
      | paginated_export    | Download in chunks       |
      | summary_version     | Aggregated data only     |
      | scheduled_delivery  | Generate in background   |
    And I should see estimated completion time

  @edge-case @concurrent-reports
  Scenario: Handle concurrent report requests
    Given multiple users request the same report
    When requests are received simultaneously
    Then duplicate generation should be prevented
    And all users should receive the same report
    And generation should be optimized

  @edge-case @historical-data
  Scenario: Handle reports with expired historical data
    Given some historical data has been archived
    When I request a report including archived data
    Then I should be notified about data availability
    And archive restoration should be offered
    And available data should be clearly marked
