@admin @revenue-analytics
Feature: Admin Revenue Analytics
  As a platform administrator
  I want to analyze revenue data and financial performance
  So that I can make data-driven business decisions

  Background:
    Given I am logged in as a platform administrator
    And I have revenue analytics permissions

  # =============================================================================
  # REVENUE DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View revenue overview dashboard
    When I navigate to the revenue analytics dashboard
    Then I should see key revenue metrics:
      | Metric                    | Time Period    |
      | Total revenue             | MTD, QTD, YTD  |
      | Monthly recurring revenue | Current        |
      | Annual recurring revenue  | Current        |
      | Average revenue per user  | Current month  |
      | Revenue growth rate       | MoM, YoY       |
      | Net revenue retention     | Trailing 12mo  |
    And I should see revenue trend charts
    And I should see revenue by product/service breakdown
    And I should see top revenue drivers

  @dashboard @real-time
  Scenario: Monitor real-time revenue metrics
    When I enable real-time revenue monitoring
    Then I should see live updates for:
      | Metric                | Update Frequency |
      | Transactions today    | Real-time        |
      | Revenue today         | Real-time        |
      | Active subscriptions  | 5 minutes        |
      | Conversion rate       | Hourly           |
      | Average order value   | Hourly           |
    And I should see transaction velocity
    And I should receive alerts for anomalies

  @dashboard @comparison
  Scenario: Compare revenue across time periods
    When I access revenue comparison tools
    Then I should be able to compare:
      | Comparison Type       | Options                          |
      | Period over period    | Day, week, month, quarter, year  |
      | Custom date ranges    | Any two date ranges              |
      | Seasonal comparison   | Same period prior year           |
      | Budget vs actual      | Compare to budget/forecast       |
    And I should see percentage changes highlighted
    And I should be able to drill into variances

  @dashboard @goals
  Scenario: Track revenue goals and targets
    When I view revenue goals
    Then I should see:
      | Goal Tracking           | Information                      |
      | Current progress        | Percentage of goal achieved      |
      | Pace indicator          | On track, ahead, behind          |
      | Required run rate       | Daily rate needed to meet goal   |
      | Gap to goal             | Amount remaining                 |
      | Projected attainment    | Forecasted final achievement     |
    And I should see goal progress visualizations
    And I should receive alerts for at-risk goals

  # =============================================================================
  # REVENUE BY SOURCE ANALYSIS
  # =============================================================================

  @source @breakdown
  Scenario: Analyze revenue by source
    When I analyze revenue by source
    Then I should see revenue breakdown by:
      | Source Category         | Metrics                          |
      | Product lines           | Revenue, % of total, growth      |
      | Service offerings       | Revenue, margins, utilization    |
      | Subscription tiers      | MRR by tier, upgrades/downgrades |
      | One-time purchases      | Transaction count, average value |
      | Add-ons and upsells     | Attach rate, contribution        |
      | Professional services   | Revenue, project margins         |
    And I should see source trends over time
    And I should identify top performing sources

  @source @channel
  Scenario: Analyze revenue by channel
    When I analyze revenue by channel
    Then I should see breakdown by:
      | Channel                 | Metrics                          |
      | Direct sales            | Revenue, deal size, cycle time   |
      | Online/self-service     | Revenue, conversion rate         |
      | Partner/reseller        | Revenue, partner contribution    |
      | Marketplace             | Revenue, listing performance     |
      | Affiliate               | Revenue, commission paid         |
    And I should see channel performance comparison
    And I should track channel mix changes

  @source @acquisition
  Scenario: Analyze revenue by acquisition source
    When I analyze revenue by acquisition source
    Then I should see:
      | Acquisition Source      | Revenue Metrics                  |
      | Organic search          | Revenue, LTV, CAC                |
      | Paid advertising        | Revenue, ROAS, CAC               |
      | Social media            | Revenue, engagement to revenue   |
      | Referrals               | Revenue, referral rate           |
      | Content marketing       | Revenue, attribution             |
      | Events                  | Revenue, event ROI               |
    And I should see customer LTV by source
    And I should calculate ROI by acquisition channel

  # =============================================================================
  # COHORT ANALYSIS
  # =============================================================================

  @cohort @revenue
  Scenario: View revenue cohort analysis
    When I access revenue cohort analysis
    Then I should see cohorts grouped by:
      | Cohort Type             | Grouping                         |
      | Signup month            | Customers by join date           |
      | First purchase date     | By first transaction date        |
      | Subscription start      | By subscription activation       |
      | Acquisition channel     | By how they were acquired        |
      | Initial plan            | By starting subscription tier    |
    And for each cohort I should see:
      | Cohort Metric           | Description                      |
      | Cohort size             | Number of customers              |
      | Revenue by month        | Monthly revenue from cohort      |
      | Cumulative revenue      | Total revenue over time          |
      | Retention rate          | Active customers remaining       |
      | Average revenue         | Per customer revenue             |

  @cohort @retention
  Scenario: Analyze revenue retention by cohort
    When I analyze revenue retention
    Then I should see:
      | Retention Metric        | Description                      |
      | Gross revenue retention | Revenue from existing base       |
      | Net revenue retention   | Including expansion revenue      |
      | Logo retention          | Customer count retention         |
      | Contraction             | Downgrade revenue impact         |
      | Churn                   | Lost revenue                     |
      | Expansion               | Upgrade and upsell revenue       |
    And I should see retention curves by cohort
    And I should identify high-performing cohorts

  @cohort @ltv
  Scenario: Calculate customer lifetime value by cohort
    When I view LTV analysis
    Then I should see:
      | LTV Metric              | Calculation                      |
      | Average LTV             | Total cohort revenue / customers |
      | LTV by segment          | LTV for different segments       |
      | LTV to CAC ratio        | Payback period indicator         |
      | Projected LTV           | Forward-looking estimate         |
      | LTV trend               | How LTV is changing              |
    And I should compare LTV across cohorts
    And I should see LTV drivers analysis

  # =============================================================================
  # GEOGRAPHIC REVENUE ANALYSIS
  # =============================================================================

  @geography @regional
  Scenario: Analyze revenue by geography
    When I analyze revenue by geography
    Then I should see revenue data for:
      | Geographic Level        | Metrics                          |
      | Country                 | Revenue, growth, % of total      |
      | Region                  | Revenue, market penetration      |
      | State/Province          | Revenue, customer density        |
      | City                    | Revenue, average deal size       |
      | Timezone                | Revenue, peak activity times     |
    And I should see geographic heat maps
    And I should identify expansion opportunities

  @geography @currency
  Scenario: Analyze revenue by currency
    When I analyze multi-currency revenue
    Then I should see:
      | Currency Analysis       | Information                      |
      | Revenue by currency     | Breakdown of currency mix        |
      | Exchange rate impact    | FX gains/losses                  |
      | Constant currency       | Growth excluding FX effects      |
      | Currency hedging        | Hedging effectiveness            |
    And I should see currency trends
    And I should model FX sensitivity

  @geography @market
  Scenario: Analyze market penetration
    When I analyze market penetration
    Then I should see:
      | Market Metric           | Information                      |
      | Total addressable market| TAM by region                    |
      | Serviceable market      | SAM by region                    |
      | Market share            | Our share of market              |
      | Penetration rate        | % of potential customers         |
      | Growth potential        | Untapped opportunity             |
    And I should compare penetration across regions
    And I should prioritize market expansion

  # =============================================================================
  # PRICING PERFORMANCE ANALYSIS
  # =============================================================================

  @pricing @effectiveness
  Scenario: Analyze pricing performance
    When I analyze pricing effectiveness
    Then I should see:
      | Pricing Metric          | Information                      |
      | Average selling price   | Mean transaction value           |
      | Price realization       | Actual vs list price             |
      | Discount depth          | Average discount percentage      |
      | Price elasticity        | Impact of price on demand        |
      | Margin by price point   | Profitability at each level      |
    And I should see pricing trends over time
    And I should identify pricing optimization opportunities

  @pricing @tiers
  Scenario: Analyze revenue by pricing tier
    When I analyze pricing tier performance
    Then I should see for each tier:
      | Tier Metric             | Information                      |
      | Subscribers             | Count and percentage             |
      | MRR contribution        | Revenue from tier                |
      | Conversion rate         | Trial to paid conversion         |
      | Upgrade rate            | Moving to higher tiers           |
      | Downgrade rate          | Moving to lower tiers            |
      | Churn rate              | Cancellation rate                |
    And I should see tier movement patterns
    And I should optimize tier pricing

  @pricing @discounts
  Scenario: Analyze discount impact on revenue
    When I analyze discount effectiveness
    Then I should see:
      | Discount Metric         | Information                      |
      | Total discount given    | Dollar amount discounted         |
      | Discount rate           | % of revenue discounted          |
      | Conversion lift         | Impact on conversion             |
      | Revenue impact          | Net revenue after discounts      |
      | Customer LTV            | LTV of discounted customers      |
    And I should see discount ROI analysis
    And I should identify optimal discount levels

  # =============================================================================
  # REVENUE FORECASTING
  # =============================================================================

  @forecast @projections
  Scenario: View revenue forecasts
    When I access revenue forecasting
    Then I should see projections for:
      | Forecast Period         | Metrics                          |
      | Next month              | Revenue, confidence interval     |
      | Next quarter            | Revenue, scenario range          |
      | Next year               | Revenue, growth assumptions      |
    And forecasts should include:
      | Forecast Component      | Description                      |
      | Base revenue            | Existing recurring revenue       |
      | New business            | Projected new sales              |
      | Expansion               | Upsell and cross-sell            |
      | Contraction             | Expected downgrades              |
      | Churn                   | Projected cancellations          |

  @forecast @models
  Scenario: Configure forecasting models
    When I configure forecasting models
    Then I should be able to select:
      | Model Type              | Description                      |
      | Historical trend        | Based on past performance        |
      | Cohort-based            | Using cohort behavior patterns   |
      | Pipeline-based          | Using sales pipeline data        |
      | ML-based                | Machine learning predictions     |
      | Bottom-up               | Aggregated from segments         |
    And I should set model parameters
    And I should see model accuracy metrics

  @forecast @scenarios
  Scenario: Model revenue scenarios
    When I create revenue scenarios
    Then I should be able to model:
      | Scenario Type           | Variables                        |
      | Best case               | Optimistic assumptions           |
      | Base case               | Expected performance             |
      | Worst case              | Conservative assumptions         |
      | Custom scenarios        | User-defined variables           |
    And I should adjust variables:
      | Variable                | Adjustment Range                 |
      | Growth rate             | -50% to +100%                    |
      | Churn rate              | 0.5x to 2x current               |
      | Average deal size       | -30% to +50%                     |
      | Conversion rate         | -25% to +50%                     |
    And I should see scenario comparison charts

  @forecast @accuracy
  Scenario: Track forecast accuracy
    When I review forecast accuracy
    Then I should see:
      | Accuracy Metric         | Information                      |
      | Forecast vs actual      | Variance analysis                |
      | MAPE                    | Mean absolute percentage error   |
      | Bias                    | Systematic over/under forecast   |
      | Hit rate                | Within acceptable range          |
    And I should see accuracy by:
      | Dimension               | Breakdown                        |
      | Time period             | Monthly, quarterly accuracy      |
      | Product                 | By product line                  |
      | Region                  | By geographic area               |
      | Forecast type           | New vs expansion vs renewal      |

  # =============================================================================
  # CUSTOMER SEGMENT REVENUE
  # =============================================================================

  @segment @analysis
  Scenario: Analyze revenue by customer segment
    When I analyze revenue by segment
    Then I should see segments defined by:
      | Segment Criteria        | Categories                       |
      | Company size            | SMB, Mid-market, Enterprise      |
      | Industry                | Tech, Finance, Healthcare, etc.  |
      | Use case                | Primary product use case         |
      | Engagement level        | High, medium, low                |
      | Tenure                  | New, established, long-term      |
    And for each segment I should see:
      | Segment Metric          | Information                      |
      | Revenue contribution    | Total and percentage             |
      | Growth rate             | Segment growth trend             |
      | Average contract value  | Mean deal size                   |
      | Customer count          | Number in segment                |
      | LTV                     | Lifetime value                   |

  @segment @profitability
  Scenario: Analyze segment profitability
    When I analyze segment profitability
    Then I should see:
      | Profitability Metric    | Information                      |
      | Revenue per segment     | Total segment revenue            |
      | Cost to serve           | Support and service costs        |
      | Gross margin            | Revenue minus direct costs       |
      | Customer acquisition    | CAC by segment                   |
      | Net contribution        | Profit contribution              |
    And I should identify most profitable segments
    And I should optimize resource allocation

  @segment @behavior
  Scenario: Analyze segment purchasing behavior
    When I analyze segment behavior
    Then I should see:
      | Behavior Metric         | Information                      |
      | Purchase frequency      | How often they buy               |
      | Cross-sell rate         | Additional product adoption      |
      | Upgrade propensity      | Likelihood to upgrade            |
      | Payment behavior        | On-time payment rate             |
      | Support usage           | Service utilization              |
    And I should identify upsell opportunities
    And I should predict at-risk segments

  # =============================================================================
  # REVENUE CHURN ANALYSIS
  # =============================================================================

  @churn @revenue
  Scenario: Analyze revenue churn
    When I analyze revenue churn
    Then I should see:
      | Churn Metric            | Information                      |
      | Gross MRR churn         | Lost recurring revenue           |
      | Net MRR churn           | After expansion revenue          |
      | Churn rate              | Percentage of revenue churned    |
      | Churn by reason         | Categorized churn reasons        |
      | Churn by segment        | Which segments churn most        |
      | Recoverable churn       | Winback opportunities            |
    And I should see churn trends over time
    And I should identify churn risk factors

  @churn @contraction
  Scenario: Analyze revenue contraction
    When I analyze revenue contraction
    Then I should see:
      | Contraction Metric      | Information                      |
      | Downgrade MRR           | Revenue lost to downgrades       |
      | Contraction rate        | Percentage of base contracted    |
      | Downgrade paths         | Common downgrade patterns        |
      | Reasons for downgrade   | Why customers downgrade          |
      | Save rate               | Prevented downgrades             |
    And I should identify at-risk customers
    And I should model intervention impact

  @churn @winback
  Scenario: Analyze winback revenue
    When I analyze winback performance
    Then I should see:
      | Winback Metric          | Information                      |
      | Churned customer pool   | Eligible for winback             |
      | Winback attempts        | Outreach efforts                 |
      | Winback rate            | Successful reactivations         |
      | Winback revenue         | Revenue from reactivations       |
      | Time to winback         | Average reactivation time        |
      | Winback LTV             | LTV of won-back customers        |
    And I should see effective winback strategies
    And I should prioritize winback targets

  # =============================================================================
  # PAYMENT METHOD ANALYSIS
  # =============================================================================

  @payment @revenue
  Scenario: Analyze revenue by payment method
    When I analyze revenue by payment method
    Then I should see breakdown by:
      | Payment Method          | Metrics                          |
      | Credit card             | Revenue, % of total, fees        |
      | ACH/bank transfer       | Revenue, processing time         |
      | Digital wallets         | Revenue, adoption rate           |
      | Invoice/PO              | Revenue, DSO                     |
      | Cryptocurrency          | Revenue, volatility impact       |
    And I should see payment success rates
    And I should calculate payment processing costs

  @payment @failed
  Scenario: Analyze failed payment revenue impact
    When I analyze failed payments
    Then I should see:
      | Failed Payment Metric   | Information                      |
      | Failed payment amount   | Revenue at risk                  |
      | Failure rate            | Percentage of attempts           |
      | Failure reasons         | Categorized failure causes       |
      | Recovery rate           | Successfully retried             |
      | Permanent churn         | Lost due to payment failure      |
    And I should see dunning effectiveness
    And I should optimize payment recovery

  @payment @billing-cycle
  Scenario: Analyze revenue by billing cycle
    When I analyze billing cycles
    Then I should see:
      | Billing Cycle           | Metrics                          |
      | Monthly                 | MRR, customer count              |
      | Quarterly               | Revenue, discount impact         |
      | Annual                  | ARR, prepayment benefit          |
      | Multi-year              | Contract value, risk             |
    And I should see billing cycle preferences
    And I should model cycle optimization

  # =============================================================================
  # REVENUE ATTRIBUTION
  # =============================================================================

  @attribution @marketing
  Scenario: View revenue attribution
    When I view revenue attribution
    Then I should see attribution by:
      | Attribution Model       | Description                      |
      | First touch             | Credit to first interaction      |
      | Last touch              | Credit to final interaction      |
      | Linear                  | Equal credit to all touches      |
      | Time decay              | More credit to recent touches    |
      | Position-based          | Weight first and last more       |
      | Data-driven             | ML-based attribution             |
    And I should compare model results
    And I should see attributed revenue by channel

  @attribution @sales
  Scenario: Analyze sales attribution
    When I analyze sales attribution
    Then I should see:
      | Attribution Element     | Metrics                          |
      | Sales rep               | Revenue by rep                   |
      | Sales team              | Revenue by team                  |
      | Territory               | Revenue by territory             |
      | Deal source             | Inbound vs outbound              |
      | Partner involvement     | Partner-influenced deals         |
    And I should see quota attainment
    And I should identify top performers

  @attribution @product
  Scenario: Analyze product-led revenue attribution
    When I analyze product-led growth
    Then I should see:
      | PLG Metric              | Information                      |
      | Product-qualified leads | Users meeting PQL criteria       |
      | Self-serve conversion   | Without sales involvement        |
      | Feature adoption        | Features driving conversion      |
      | Upgrade triggers        | In-product upgrade drivers       |
      | Expansion signals       | Usage indicating expansion       |
    And I should identify high-value features
    And I should optimize product-led funnel

  # =============================================================================
  # DISCOUNT AND PROMOTION ANALYSIS
  # =============================================================================

  @promotion @impact
  Scenario: Analyze discount and promotion impact
    When I analyze promotion effectiveness
    Then I should see for each promotion:
      | Promotion Metric        | Information                      |
      | Redemption count        | Times promotion was used         |
      | Revenue generated       | Total revenue from promotion     |
      | Discount cost           | Value of discounts given         |
      | Incremental revenue     | Net new revenue attributed       |
      | Customer acquisition    | New customers from promotion     |
      | ROI                     | Return on promotion investment   |
    And I should compare promotion performance
    And I should identify optimal promotion strategies

  @promotion @cannibalization
  Scenario: Analyze promotion cannibalization
    When I analyze cannibalization
    Then I should see:
      | Cannibalization Metric  | Information                      |
      | Baseline revenue        | Expected without promotion       |
      | Promotional revenue     | Revenue during promotion         |
      | Incremental lift        | True additional revenue          |
      | Pull-forward            | Future sales pulled forward      |
      | Margin impact           | Effect on profitability          |
    And I should identify cannibalization patterns
    And I should optimize promotion timing

  @promotion @customer-behavior
  Scenario: Analyze promotion customer behavior
    When I analyze promotional customer behavior
    Then I should see:
      | Behavior Metric         | Information                      |
      | Promotion sensitivity   | Customer response to discounts   |
      | LTV comparison          | Promo vs non-promo customers     |
      | Retention rate          | Post-promotion retention         |
      | Repeat purchase         | Second purchase rate             |
      | Full price conversion   | Transition to full price         |
    And I should identify promotion-dependent customers
    And I should develop graduation strategies

  # =============================================================================
  # REVENUE EXPERIMENTS
  # =============================================================================

  @experiment @pricing
  Scenario: Track revenue experiments
    When I track revenue experiments
    Then I should see active experiments:
      | Experiment Type         | Metrics Tracked                  |
      | Pricing tests           | Conversion, revenue, margin      |
      | Feature bundling        | Attach rate, deal size           |
      | Trial length            | Conversion, time to convert      |
      | Onboarding flows        | Activation, retention            |
      | Payment options         | Completion rate, method mix      |
    And I should see experiment results
    And I should calculate statistical significance

  @experiment @ab-test
  Scenario: Manage revenue A/B tests
    When I manage A/B tests
    Then I should be able to:
      | Test Configuration      | Options                          |
      | Define variants         | Control and test groups          |
      | Set sample size         | Statistical power calculation    |
      | Set duration            | Test runtime                     |
      | Define success metrics  | Primary and secondary metrics    |
      | Set guardrails          | Metrics to protect               |
    And I should see real-time test results
    And I should receive significance alerts

  @experiment @analysis
  Scenario: Analyze experiment revenue impact
    When I analyze experiment impact
    Then I should see:
      | Analysis Metric         | Information                      |
      | Revenue lift            | Difference vs control            |
      | Statistical significance| P-value and confidence           |
      | Sample size             | Users in each variant            |
      | Effect size             | Practical significance           |
      | Long-term impact        | Extended observation results     |
    And I should see segment-level results
    And I should model full rollout impact

  # =============================================================================
  # REVENUE HEALTH METRICS
  # =============================================================================

  @health @saas-metrics
  Scenario: View revenue health metrics
    When I view revenue health dashboard
    Then I should see SaaS metrics:
      | Health Metric           | Target        | Status           |
      | MRR growth rate         | > 10% MoM     | On/off track     |
      | Net revenue retention   | > 100%        | Current value    |
      | Gross margin            | > 70%         | Trend            |
      | CAC payback             | < 12 months   | Current          |
      | LTV/CAC ratio           | > 3x          | Ratio            |
      | Rule of 40              | > 40%         | Growth + margin  |
    And I should see trend indicators
    And I should receive health alerts

  @health @benchmarks
  Scenario: Compare revenue against benchmarks
    When I compare against benchmarks
    Then I should see comparisons to:
      | Benchmark Source        | Metrics Compared                 |
      | Industry averages       | Growth, retention, margins       |
      | Peer companies          | Similar size/stage               |
      | Best-in-class           | Top performers                   |
      | Historical self         | Own past performance             |
    And I should see percentile rankings
    And I should identify improvement areas

  @health @unit-economics
  Scenario: Analyze unit economics
    When I analyze unit economics
    Then I should see:
      | Unit Economic Metric    | Information                      |
      | Customer acquisition    | Total CAC breakdown              |
      | Lifetime value          | LTV calculation                  |
      | Gross margin            | Per customer margin              |
      | Payback period          | Months to recover CAC            |
      | Contribution margin     | After variable costs             |
    And I should see trends over time
    And I should model improvement scenarios

  # =============================================================================
  # EXECUTIVE REPORTING
  # =============================================================================

  @reporting @executive
  Scenario: Generate executive revenue report
    When I generate executive revenue report
    Then the report should include:
      | Report Section          | Content                          |
      | Executive summary       | Key highlights and insights      |
      | Revenue performance     | Actual vs target vs prior        |
      | Growth analysis         | Drivers of growth/decline        |
      | Segment performance     | Performance by key segments      |
      | Forecast update         | Updated projections              |
      | Key risks               | Revenue risks and mitigation     |
      | Action items            | Recommended actions              |
    And report should be visually clear
    And report should be exportable in multiple formats

  @reporting @board
  Scenario: Generate board revenue report
    When I generate board-level report
    Then the report should include:
      | Board Report Section    | Content                          |
      | Financial highlights    | Key revenue metrics              |
      | Strategic progress      | Performance vs strategic goals   |
      | Market position         | Competitive revenue standing     |
      | Investment efficiency   | Return on growth investments     |
      | Outlook                 | Forward-looking guidance         |
    And report should support quarterly cadence
    And report should include supporting data

  @reporting @custom
  Scenario: Create custom revenue reports
    When I create custom reports
    Then I should be able to:
      | Configuration           | Options                          |
      | Select metrics          | Choose from metric library       |
      | Set dimensions          | Group by attributes              |
      | Apply filters           | Limit data scope                 |
      | Set time range          | Custom date selection            |
      | Choose visualization    | Charts, tables, scorecards       |
      | Schedule delivery       | Automated email delivery         |
    And reports should be saved as templates
    And I should share reports with stakeholders

  @reporting @alerts
  Scenario: Configure revenue alerts
    When I configure revenue alerts
    Then I should be able to set alerts for:
      | Alert Type              | Trigger Conditions               |
      | Threshold breach        | Metric above/below value         |
      | Trend change            | Significant trend deviation      |
      | Anomaly detection       | Unusual pattern detected         |
      | Goal progress           | At risk of missing goal          |
      | Comparative             | Falling behind prior period      |
    And I should set alert recipients
    And I should configure alert channels

  # =============================================================================
  # DATA INTEGRATION
  # =============================================================================

  @integration @sources
  Scenario: Manage revenue data sources
    When I manage data sources
    Then I should be able to integrate:
      | Data Source             | Data Type                        |
      | Payment processor       | Transaction data                 |
      | CRM system              | Customer and deal data           |
      | Billing system          | Subscription data                |
      | ERP                     | Financial data                   |
      | Marketing automation    | Campaign attribution             |
      | Product analytics       | Usage data                       |
    And I should configure sync frequency
    And I should monitor data freshness

  @integration @export
  Scenario: Export revenue data
    When I export revenue data
    Then I should be able to:
      | Export Option           | Configuration                    |
      | Format                  | CSV, Excel, JSON, API            |
      | Data selection          | Choose metrics and dimensions    |
      | Time range              | Select date range                |
      | Scheduling              | One-time or recurring            |
      | Destination             | Download, email, SFTP, API       |
    And exports should respect data permissions
    And I should track export history

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient analytics permissions
    Given I do not have revenue analytics permissions
    When I attempt to access revenue analytics
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @data-unavailable
  Scenario: Handle data unavailability
    Given revenue data source is unavailable
    When I attempt to view revenue metrics
    Then I should see a data unavailability warning
    And I should see last available data timestamp
    And I should see which metrics are affected
    And I should receive notification when data is restored

  @error @calculation-error
  Scenario: Handle metric calculation errors
    Given there is an error calculating a metric
    When I view the revenue dashboard
    Then the affected metric should show an error indicator
    And I should see the specific error message
    And I should see suggested troubleshooting steps
    And I should be able to report the issue

  @error @export-failed
  Scenario: Handle export failure
    Given I am exporting revenue data
    When the export fails
    Then I should see a specific error message
    And I should see possible causes:
      | Cause                   | Resolution                       |
      | Data too large          | Reduce date range or metrics     |
      | Timeout                 | Schedule as background job       |
      | Permission issue        | Contact administrator            |
    And I should be able to retry the export

  @error @forecast-unavailable
  Scenario: Handle insufficient data for forecasting
    Given there is insufficient historical data
    When I attempt to generate forecasts
    Then I should see a "Insufficient Data" message
    And I should see minimum data requirements
    And I should see alternative analysis options
    And I should be notified when sufficient data exists
