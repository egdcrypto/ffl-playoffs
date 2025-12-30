Feature: Admin AI Analytics and Insights
  As an Admin
  I want to view AI analytics, model performance, and usage insights
  So that I can optimize AI-driven features and manage costs effectively

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And the AI analytics system is enabled
    And the admin owns league "Playoffs 2024"

  # ===========================================
  # AI Model Performance Dashboard
  # ===========================================

  Scenario: Admin views AI model performance dashboard
    Given the AI system has processed requests in the last 30 days
    When the admin navigates to the AI analytics dashboard
    Then the dashboard displays the following metrics:
      | metric                    | description                          |
      | Total AI Requests         | Number of AI calls made              |
      | Average Response Time     | Mean latency in milliseconds         |
      | Success Rate              | Percentage of successful completions |
      | Error Rate                | Percentage of failed requests        |
      | Model Uptime              | Availability percentage              |
    And the dashboard shows trend charts for each metric
    And the default time range is "Last 30 Days"

  Scenario: Admin filters AI performance by time range
    Given the admin is on the AI analytics dashboard
    When the admin selects time range "Last 7 Days"
    Then all performance metrics are recalculated for the selected period
    And trend charts update to show daily data points
    When the admin selects time range "Last 24 Hours"
    Then trend charts update to show hourly data points

  Scenario: Admin views AI performance by model type
    Given the AI system uses multiple models:
      | model              | purpose                    |
      | gpt-4-turbo        | Complex narrative analysis |
      | gpt-3.5-turbo      | Quick suggestions          |
      | text-embedding-ada | Semantic search            |
    When the admin filters by model "gpt-4-turbo"
    Then only performance metrics for gpt-4-turbo are displayed
    And the admin can compare performance across models

  Scenario: Admin views AI request latency distribution
    Given the AI system has logged response times
    When the admin views the latency distribution chart
    Then the chart shows:
      | percentile | description           |
      | p50        | Median response time  |
      | p90        | 90th percentile       |
      | p95        | 95th percentile       |
      | p99        | 99th percentile       |
    And outliers are highlighted for investigation

  Scenario: Admin views AI error breakdown
    Given the AI system has encountered errors
    When the admin views the error breakdown
    Then errors are categorized by:
      | error_type         | description                    |
      | RATE_LIMIT         | API rate limit exceeded        |
      | TIMEOUT            | Request timed out              |
      | INVALID_RESPONSE   | Malformed AI response          |
      | CONTENT_FILTER     | Content policy violation       |
      | MODEL_OVERLOADED   | Model temporarily unavailable  |
      | TOKEN_LIMIT        | Context window exceeded        |
    And each category shows count and percentage
    And the admin can drill down to see specific error instances

  Scenario: Admin receives AI performance alerts
    Given the admin has configured performance thresholds:
      | metric          | threshold | condition    |
      | Error Rate      | 5%        | greater_than |
      | Response Time   | 3000ms    | greater_than |
      | Success Rate    | 95%       | less_than    |
    When any threshold is breached
    Then the admin receives an alert notification
    And the alert includes:
      | field       | description                   |
      | metric      | Which metric was breached     |
      | value       | Current value                 |
      | threshold   | Configured threshold          |
      | timestamp   | When breach occurred          |
      | severity    | WARNING or CRITICAL           |

  # ===========================================
  # Prediction Accuracy Tracking
  # ===========================================

  Scenario: Admin views prediction accuracy overview
    Given the AI system has made predictions
    When the admin navigates to prediction accuracy
    Then the following accuracy metrics are displayed:
      | metric                  | description                           |
      | Overall Accuracy        | Percentage of correct predictions     |
      | Precision               | True positives / predicted positives  |
      | Recall                  | True positives / actual positives     |
      | F1 Score                | Harmonic mean of precision and recall |
      | Mean Absolute Error     | Average prediction deviation          |

  Scenario: Admin views player performance prediction accuracy
    Given the AI has made player performance predictions
    And actual game results are available
    When the admin views player prediction accuracy
    Then the dashboard shows:
      | prediction_type         | accuracy_metric          |
      | Fantasy Points          | MAE (Mean Absolute Error)|
      | Touchdown Predictions   | Precision/Recall         |
      | Yardage Predictions     | RMSE (Root Mean Square)  |
      | Injury Risk             | AUC-ROC Score            |
    And predictions are compared against actual outcomes

  Scenario: Admin views prediction accuracy by position
    Given the AI has made predictions for various positions
    When the admin filters by position
    Then accuracy metrics are shown for:
      | position | sample_size | accuracy |
      | QB       | 128         | 78.5%    |
      | RB       | 256         | 72.3%    |
      | WR       | 384         | 69.8%    |
      | TE       | 96          | 74.1%    |
      | K        | 64          | 81.2%    |
      | DEF      | 32          | 68.9%    |
    And the admin can identify positions needing model improvement

  Scenario: Admin views prediction accuracy over time
    Given the AI has made predictions across multiple weeks
    When the admin views the accuracy trend chart
    Then the chart shows week-by-week accuracy
    And the admin can identify if model performance is improving or degrading
    And statistical significance indicators are shown for trends

  Scenario: Admin compares predicted vs actual fantasy points
    Given the AI predicted fantasy points for week 15
    And actual fantasy points are now available
    When the admin views the comparison report
    Then a scatter plot shows predicted vs actual points
    And the correlation coefficient (R-squared) is displayed
    And outliers are highlighted with player names
    And the admin can export the comparison data

  Scenario: Admin views prediction confidence calibration
    Given the AI provides confidence scores with predictions
    When the admin views the calibration chart
    Then the chart shows:
      | confidence_bucket | expected_accuracy | actual_accuracy |
      | 90-100%           | 95%               | 93%             |
      | 80-90%            | 85%               | 82%             |
      | 70-80%            | 75%               | 71%             |
      | 60-70%            | 65%               | 68%             |
      | 50-60%            | 55%               | 52%             |
    And the admin can assess if confidence scores are well-calibrated

  Scenario: Admin investigates prediction failures
    Given there are predictions with significant errors
    When the admin views the prediction failure analysis
    Then the system shows predictions with highest error margins
    And each failure includes:
      | field            | description                        |
      | player           | Player name and position           |
      | predicted        | AI predicted value                 |
      | actual           | Actual outcome                     |
      | error            | Difference                         |
      | context          | Factors that may have caused error |
    And the admin can flag predictions for model retraining

  # ===========================================
  # Usage Patterns Analysis
  # ===========================================

  Scenario: Admin views AI feature usage overview
    Given AI features are used across the platform
    When the admin views usage patterns
    Then the dashboard shows usage by feature:
      | feature                    | requests | unique_users |
      | Player Recommendations     | 12,450   | 842          |
      | Trade Analysis             | 3,280    | 521          |
      | Matchup Predictions        | 8,920    | 756          |
      | Waiver Wire Suggestions    | 5,640    | 634          |
      | Lineup Optimization        | 15,320   | 891          |

  Scenario: Admin views AI usage by time of day
    Given AI features are used throughout the day
    When the admin views the hourly usage chart
    Then the chart shows request volume by hour
    And peak usage times are highlighted
    And the admin can identify patterns (e.g., higher usage before game times)

  Scenario: Admin views AI usage by day of week
    Given AI features are used across the week
    When the admin views the daily usage pattern
    Then the chart shows:
      | day       | relative_usage |
      | Sunday    | 180%           |
      | Monday    | 95%            |
      | Tuesday   | 75%            |
      | Wednesday | 85%            |
      | Thursday  | 120%           |
      | Friday    | 90%            |
      | Saturday  | 155%           |
    And game days show significantly higher usage

  Scenario: Admin views AI usage by user segment
    Given users have different engagement levels
    When the admin views usage by user segment
    Then usage is broken down by:
      | segment         | users | avg_requests_per_user |
      | Power Users     | 125   | 45.2                  |
      | Regular Users   | 542   | 12.8                  |
      | Casual Users    | 1,234 | 3.4                   |
      | New Users       | 321   | 1.2                   |

  Scenario: Admin views AI token usage statistics
    Given AI models consume tokens for requests
    When the admin views token usage
    Then the dashboard shows:
      | metric                | value       |
      | Total Tokens Used     | 2,450,000   |
      | Input Tokens          | 1,850,000   |
      | Output Tokens         | 600,000     |
      | Avg Tokens per Request| 245         |
      | Max Tokens per Request| 4,096       |
    And token usage is broken down by model

  Scenario: Admin views AI request queue metrics
    Given the AI system uses request queuing
    When the admin views queue metrics
    Then the dashboard shows:
      | metric                | value   |
      | Queue Depth (current) | 12      |
      | Avg Queue Time        | 450ms   |
      | Max Queue Time        | 2,500ms |
      | Requests Throttled    | 234     |
    And alerts are triggered if queue depth exceeds threshold

  Scenario: Admin views AI cache hit rate
    Given the AI system caches common responses
    When the admin views cache performance
    Then the dashboard shows:
      | metric                | value |
      | Cache Hit Rate        | 34.5% |
      | Cache Miss Rate       | 65.5% |
      | Avg Response (cached) | 45ms  |
      | Avg Response (fresh)  | 890ms |
      | Cache Size Used       | 2.4GB |
    And the admin can see potential savings from improved caching

  # ===========================================
  # Cost Analysis
  # ===========================================

  Scenario: Admin views AI cost overview
    Given the AI system incurs API costs
    When the admin navigates to cost analysis
    Then the dashboard displays:
      | metric              | value    |
      | Total Cost (MTD)    | $1,245.67|
      | Cost per Request    | $0.012   |
      | Projected Monthly   | $1,856.00|
      | Budget Remaining    | $2,144.33|
      | Cost vs Last Month  | +12.3%   |

  Scenario: Admin views cost breakdown by model
    Given the AI system uses multiple models with different pricing
    When the admin views cost by model
    Then costs are itemized:
      | model              | requests | tokens     | cost     | % of total |
      | gpt-4-turbo        | 8,500    | 1,200,000  | $960.00  | 77.1%      |
      | gpt-3.5-turbo      | 45,000   | 900,000    | $180.00  | 14.5%      |
      | text-embedding-ada | 125,000  | 350,000    | $105.67  | 8.4%       |

  Scenario: Admin views cost breakdown by feature
    Given AI costs are tracked by feature
    When the admin views cost by feature
    Then costs are itemized:
      | feature                | cost     | % of total |
      | Lineup Optimization    | $456.78  | 36.7%      |
      | Player Recommendations | $312.45  | 25.1%      |
      | Matchup Predictions    | $234.56  | 18.8%      |
      | Trade Analysis         | $156.78  | 12.6%      |
      | Waiver Wire Suggestions| $85.10   | 6.8%       |

  Scenario: Admin views cost trend over time
    Given the admin wants to track cost trends
    When the admin views the cost trend chart
    Then the chart shows daily/weekly/monthly costs
    And the admin can identify cost spikes
    And cost anomalies are automatically flagged

  Scenario: Admin sets AI budget alerts
    Given the admin wants to control AI spending
    When the admin sets budget thresholds:
      | threshold_type | value    | action              |
      | Warning        | $3,000   | Send notification   |
      | Critical       | $4,000   | Send urgent alert   |
      | Hard Limit     | $5,000   | Throttle AI usage   |
    Then the budget alerts are configured
    And the admin receives notifications when thresholds are approached

  Scenario: Admin views cost per user metrics
    Given AI costs can be attributed to users
    When the admin views cost per user
    Then the dashboard shows:
      | metric                    | value   |
      | Average Cost per User     | $0.89   |
      | Median Cost per User      | $0.45   |
      | Top 10% User Cost Share   | 42%     |
      | Cost per Active User      | $1.23   |
    And the admin can identify high-cost user segments

  Scenario: Admin views cost efficiency metrics
    Given the admin wants to optimize AI costs
    When the admin views efficiency metrics
    Then the dashboard shows:
      | metric                         | value   |
      | Cost per Successful Request    | $0.013  |
      | Wasted Cost (failed requests)  | $45.67  |
      | Cache Savings (estimated)      | $312.00 |
      | Potential Savings (identified) | $189.00 |

  Scenario: Admin compares costs across time periods
    Given historical cost data is available
    When the admin compares this month to last month
    Then the comparison shows:
      | metric           | this_month | last_month | change  |
      | Total Cost       | $1,245.67  | $1,109.45  | +12.3%  |
      | Requests         | 103,500    | 98,200     | +5.4%   |
      | Cost per Request | $0.012     | $0.0113    | +6.2%   |
    And the admin can identify what drove cost changes

  # ===========================================
  # Optimization Recommendations
  # ===========================================

  Scenario: Admin receives AI optimization recommendations
    Given the AI analytics system analyzes usage patterns
    When the admin views optimization recommendations
    Then recommendations are displayed with:
      | field           | description                        |
      | recommendation  | What to change                     |
      | impact          | Estimated cost/performance impact  |
      | effort          | Implementation difficulty          |
      | priority        | Recommended priority               |

  Scenario: Admin receives model selection recommendations
    Given different models have different cost/performance tradeoffs
    When the admin views model recommendations
    Then the system suggests:
      """
      Recommendation: Switch 'Quick Suggestions' from gpt-4-turbo to gpt-3.5-turbo
      - Current Cost: $156.78/month
      - Projected Cost: $31.36/month
      - Savings: $125.42/month (80%)
      - Quality Impact: Minimal (92% similarity in responses)
      - Latency Improvement: 45% faster average response
      """
    And the admin can accept or dismiss the recommendation

  Scenario: Admin receives caching optimization recommendations
    Given the AI system has cache analytics
    When the admin views caching recommendations
    Then the system suggests:
      """
      Recommendation: Increase cache TTL for 'Player Stats' queries
      - Current TTL: 5 minutes
      - Recommended TTL: 30 minutes
      - Projected Cache Hit Rate: 52% (up from 34%)
      - Estimated Savings: $89.00/month
      - Risk: Slightly stale data during games
      """

  Scenario: Admin receives request batching recommendations
    Given the AI system detects unbatched requests
    When the admin views batching recommendations
    Then the system suggests:
      """
      Recommendation: Batch 'Player Comparison' requests
      - Current: 3.2 requests per comparison
      - Recommended: 1 batched request
      - Projected Savings: $67.00/month
      - Latency Improvement: 60% faster comparisons
      """

  Scenario: Admin receives prompt optimization recommendations
    Given the AI system analyzes prompt efficiency
    When the admin views prompt recommendations
    Then the system suggests optimizations:
      | current_prompt_length | optimized_length | token_savings | cost_savings |
      | 850 tokens avg        | 520 tokens       | 38.8%         | $124.00/mo   |
    And specific prompt templates are suggested

  Scenario: Admin receives usage throttling recommendations
    Given some features have low ROI
    When the admin views throttling recommendations
    Then the system suggests:
      """
      Recommendation: Rate limit 'Detailed Trade Analysis' for casual users
      - Current: Unlimited for all users
      - Recommended: 5 per day for casual users
      - Projected Savings: $156.00/month
      - User Impact: Affects 8% of requests from 45% of users
      """

  Scenario: Admin receives model fine-tuning recommendations
    Given the AI system tracks prediction accuracy
    When prediction accuracy falls below threshold
    Then the system recommends:
      """
      Recommendation: Fine-tune model for QB predictions
      - Current Accuracy: 68.5%
      - Target Accuracy: 78%
      - Training Data Available: 12,450 examples
      - Estimated Fine-tuning Cost: $45.00
      - Projected Accuracy Improvement: +8-12%
      """

  Scenario: Admin views optimization impact simulation
    Given the admin wants to preview optimization impacts
    When the admin runs an impact simulation for recommendations
    Then the simulation shows:
      | if_implemented    | current  | projected | change   |
      | Monthly Cost      | $1,245   | $876      | -29.6%   |
      | Avg Response Time | 890ms    | 650ms     | -27.0%   |
      | Success Rate      | 97.2%    | 97.8%     | +0.6%    |
    And the admin can adjust simulation parameters

  Scenario: Admin tracks optimization implementation
    Given the admin has accepted recommendations
    When the admin views optimization tracking
    Then implemented optimizations show:
      | optimization              | status      | actual_impact  |
      | Model downgrade for chat  | Implemented | -$125.42 saved |
      | Cache TTL increase        | In Progress | N/A            |
      | Prompt optimization       | Planned     | N/A            |
    And the admin can compare projected vs actual savings

  # ===========================================
  # Reporting and Export
  # ===========================================

  Scenario: Admin generates AI analytics report
    Given the admin wants to share AI insights
    When the admin generates an analytics report for "Last Month"
    Then the report includes:
      | section                  | included |
      | Executive Summary        | Yes      |
      | Performance Metrics      | Yes      |
      | Prediction Accuracy      | Yes      |
      | Usage Analytics          | Yes      |
      | Cost Analysis            | Yes      |
      | Optimization Roadmap     | Yes      |
    And the report is available in PDF and CSV formats

  Scenario: Admin schedules recurring AI reports
    Given the admin wants regular AI insights
    When the admin schedules a weekly report
    Then the report is configured to:
      | field         | value                      |
      | frequency     | Weekly                     |
      | day           | Monday                     |
      | time          | 9:00 AM                    |
      | recipients    | admin@example.com          |
      | format        | PDF                        |
    And reports are automatically generated and emailed

  Scenario: Admin exports AI analytics data
    Given the admin wants raw analytics data
    When the admin exports data for "Prediction Accuracy"
    Then the export includes:
      | column           | type      |
      | timestamp        | datetime  |
      | prediction_id    | string    |
      | predicted_value  | float     |
      | actual_value     | float     |
      | error            | float     |
      | model_version    | string    |
      | confidence       | float     |
    And the data is available in CSV or JSON format

  # ===========================================
  # Access Control and Audit
  # ===========================================

  Scenario: Only admins can access AI analytics
    Given I am authenticated as a player
    When I attempt to access AI analytics
    Then the request is rejected with 403 Forbidden
    And the error message is "AI Analytics requires admin access"

  Scenario: Super admin views AI analytics across all leagues
    Given I am authenticated as a super admin
    When I access the global AI analytics dashboard
    Then I can view aggregated AI metrics across all leagues
    And I can filter by specific league if needed

  Scenario: AI analytics access is audited
    Given the admin accesses AI analytics
    When the admin views sensitive cost data
    Then an audit log entry is created:
      | field       | value                    |
      | action      | AI_ANALYTICS_VIEWED      |
      | actor       | admin@example.com        |
      | resource    | cost_analysis            |
      | timestamp   | <now>                    |
      | ip_address  | <client_ip>              |

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: AI analytics unavailable when no data exists
    Given the AI system has not been used
    When the admin navigates to AI analytics
    Then a message is displayed:
      """
      No AI analytics data available yet.
      AI analytics will populate once AI features are used in your league.
      """

  Scenario: AI analytics handles partial data gracefully
    Given some AI metrics are missing
    When the admin views the dashboard
    Then available metrics are displayed
    And missing metrics show "Data unavailable"
    And the admin is informed which data is missing

  Scenario: Admin cannot access analytics for other leagues
    Given another admin owns league "Other League"
    When the admin attempts to view AI analytics for "Other League"
    Then the request is rejected with error "UNAUTHORIZED_LEAGUE_ACCESS"
    And no analytics data is returned

  Scenario: Export fails for excessive data range
    Given the admin requests a data export
    When the export covers more than 1 year of data
    Then the request is rejected with error "EXPORT_RANGE_TOO_LARGE"
    And the error message is "Maximum export range is 365 days"

  Scenario: Budget alerts require valid thresholds
    Given the admin configures budget alerts
    When the admin sets a negative budget threshold
    Then the request is rejected with error "INVALID_BUDGET_THRESHOLD"
    When the admin sets warning threshold higher than critical
    Then the request is rejected with error "INVALID_THRESHOLD_ORDER"
