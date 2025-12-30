Feature: Admin Content Monetization
  As a Platform Administrator
  I want to manage content monetization strategies and revenue optimization
  So that I can maximize platform revenue while maintaining creator satisfaction

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have content monetization permissions
    And the monetization system is enabled

  # ===========================================
  # Monetization Dashboard
  # ===========================================

  Scenario: Admin views monetization dashboard
    When the admin navigates to the monetization dashboard
    Then the dashboard displays:
      | metric                    | description                          |
      | Total Revenue (MTD)       | Month-to-date platform revenue       |
      | Creator Earnings (MTD)    | Amount paid to content creators      |
      | Platform Revenue (MTD)    | Platform's share of revenue          |
      | Active Subscribers        | Users with paid subscriptions        |
      | Conversion Rate           | Free to paid conversion percentage   |
    And revenue trends are displayed graphically

  Scenario: Admin views revenue breakdown by source
    Given multiple revenue streams exist
    When the admin views revenue breakdown
    Then revenue is itemized by source:
      | source                  | amount     | percentage | trend   |
      | Premium Subscriptions   | $125,450   | 45%        | +12%    |
      | League Entry Fees       | $89,230    | 32%        | +8%     |
      | Creator Content Sales   | $45,670    | 16%        | +25%    |
      | Advertising             | $12,340    | 4%         | -5%     |
      | API Partnerships        | $8,450     | 3%         | +18%    |

  Scenario: Admin views monetization KPIs
    When the admin views key performance indicators
    Then KPIs are displayed:
      | kpi                           | current | target  | status  |
      | Average Revenue Per User      | $4.56   | $5.00   | Warning |
      | Customer Lifetime Value       | $48.90  | $50.00  | On Track|
      | Churn Rate                    | 3.2%    | < 5%    | Good    |
      | Net Revenue Retention         | 108%    | > 100%  | Good    |
      | Payback Period (months)       | 4.2     | < 6     | Good    |

  Scenario: Admin views real-time transaction feed
    Given transactions are occurring
    When the admin views the transaction feed
    Then recent transactions are displayed:
      | timestamp           | user              | type            | amount  |
      | 2024-01-15 14:32:01 | player@example.com| Subscription    | $9.99   |
      | 2024-01-15 14:31:45 | user2@example.com | League Entry    | $25.00  |
      | 2024-01-15 14:31:12 | user3@example.com | Content Purchase| $4.99   |
    And transactions update in real-time

  # ===========================================
  # Revenue Sharing Configuration
  # ===========================================

  Scenario: Admin views revenue sharing settings
    When the admin views revenue sharing configuration
    Then current settings are displayed:
      | category              | creator_share | platform_share |
      | Premium Content       | 70%           | 30%            |
      | League Entry Fees     | 85%           | 15%            |
      | Subscription Revenue  | 60%           | 40%            |
      | Advertising Revenue   | 55%           | 45%            |
      | Merchandise           | 75%           | 25%            |

  Scenario: Admin configures revenue sharing tiers
    Given creators have different performance levels
    When the admin configures tiered revenue sharing:
      | tier        | monthly_revenue | creator_share | bonus        |
      | Bronze      | < $1,000        | 65%           | None         |
      | Silver      | $1,000 - $5,000 | 70%           | +2%          |
      | Gold        | $5,000 - $20,000| 75%           | +5%          |
      | Platinum    | > $20,000       | 80%           | +10%         |
    Then tiered sharing is configured
    And creators are automatically assigned to tiers

  Scenario: Admin sets minimum payout thresholds
    When the admin configures payout settings:
      | setting                   | value          |
      | minimum_payout            | $50.00         |
      | payout_frequency          | Monthly        |
      | payout_day                | 15th           |
      | rollover_unpaid           | Yes            |
      | payout_methods            | Bank, PayPal   |
    Then payout rules are updated
    And creators are notified of changes

  Scenario: Admin configures special revenue sharing agreements
    Given a high-value creator exists
    When the admin creates a custom agreement:
      | field                 | value                    |
      | creator               | star_creator@example.com |
      | custom_share          | 85%                      |
      | minimum_guarantee     | $5,000/month             |
      | exclusivity_bonus     | 5%                       |
      | contract_duration     | 12 months                |
    Then the custom agreement is saved
    And standard tiers are overridden for this creator

  Scenario: Admin views revenue sharing analytics
    Given revenue has been shared with creators
    When the admin views sharing analytics
    Then the report shows:
      | metric                    | value       |
      | Total Creator Payouts     | $245,670    |
      | Average Creator Earnings  | $1,234      |
      | Top Earner                | $15,890     |
      | Creators Above Threshold  | 89%         |
      | Pending Payouts           | $12,450     |

  # ===========================================
  # Subscription Tiers
  # ===========================================

  Scenario: Admin views subscription tiers
    When the admin navigates to subscription management
    Then the following tiers are displayed:
      | tier        | price_monthly | price_annual | subscribers | revenue_mtd |
      | Free        | $0            | $0           | 45,230      | $0          |
      | Basic       | $4.99         | $49.99       | 12,450      | $62,168     |
      | Pro         | $9.99         | $99.99       | 5,890       | $58,851     |
      | Elite       | $19.99        | $199.99      | 1,234       | $24,668     |

  Scenario: Admin creates new subscription tier
    Given the admin wants to add a tier
    When the admin creates a subscription tier:
      | field               | value                          |
      | name                | Ultimate                       |
      | price_monthly       | $29.99                         |
      | price_annual        | $299.99                        |
      | features            | All Pro + Priority Support     |
      | max_leagues         | Unlimited                      |
      | ai_features         | Full Access                    |
      | custom_branding     | Yes                            |
    Then the tier is created
    And it appears in subscription options

  Scenario: Admin modifies subscription tier pricing
    Given the "Pro" tier exists
    When the admin updates pricing:
      | field               | old_value | new_value |
      | price_monthly       | $9.99     | $12.99    |
      | price_annual        | $99.99    | $129.99   |
      | grandfathering      | Yes       | -         |
      | effective_date      | 2024-02-01| -         |
    Then existing subscribers keep old pricing
    And new subscribers pay updated prices

  Scenario: Admin configures tier features
    Given a subscription tier exists
    When the admin configures features:
      | feature                 | Free  | Basic | Pro   | Elite |
      | Max Leagues             | 1     | 3     | 10    | Unlimited |
      | Player Analytics        | Basic | Full  | Full  | Full  |
      | AI Predictions          | No    | Limited| Full | Full  |
      | Ad-Free Experience      | No    | No    | Yes   | Yes   |
      | Priority Support        | No    | No    | No    | Yes   |
      | Custom League Branding  | No    | No    | Yes   | Yes   |
    Then feature matrix is updated
    And changes apply immediately

  Scenario: Admin manages trial periods
    When the admin configures trial settings:
      | setting               | value              |
      | trial_duration        | 14 days            |
      | trial_tier            | Pro                |
      | payment_required      | No                 |
      | auto_convert          | Basic              |
      | reminder_schedule     | Day 7, Day 12, Day 14 |
    Then trial settings are saved
    And new users receive trial access

  Scenario: Admin views subscription analytics
    Given subscription data exists
    When the admin views subscription analytics
    Then metrics are displayed:
      | metric                    | value   |
      | Monthly Recurring Revenue | $145,687|
      | Annual Recurring Revenue  | $1.75M  |
      | Upgrade Rate              | 12.5%   |
      | Downgrade Rate            | 3.2%    |
      | Trial Conversion Rate     | 28.5%   |
    And cohort analysis is available

  # ===========================================
  # Creator Monetization Features
  # ===========================================

  Scenario: Admin views creator monetization overview
    When the admin views creator monetization
    Then the overview shows:
      | metric                    | value      |
      | Active Monetized Creators | 245        |
      | Total Creator Revenue     | $145,670   |
      | Average Revenue/Creator   | $594       |
      | Top 10% Revenue Share     | 68%        |
      | New Creators (30d)        | 34         |

  Scenario: Admin enables creator monetization
    Given a creator requests monetization
    When the admin reviews and approves:
      | field                 | value                    |
      | creator               | creator@example.com      |
      | min_followers         | 500 (met: 1,234)         |
      | content_quality       | Approved                 |
      | community_guidelines  | Compliant                |
      | payment_info          | Verified                 |
    Then monetization is enabled for the creator
    And the creator receives notification

  Scenario: Admin configures creator products
    Given creators can sell content
    When the admin configures product types:
      | product_type          | enabled | platform_fee | min_price | max_price |
      | Premium Predictions   | Yes     | 30%          | $0.99     | $49.99    |
      | Custom Leagues        | Yes     | 15%          | $9.99     | $99.99    |
      | Strategy Guides       | Yes     | 25%          | $4.99     | $29.99    |
      | 1-on-1 Coaching       | Yes     | 20%          | $19.99    | $199.99   |
      | Exclusive Content     | Yes     | 30%          | $1.99     | $19.99    |
    Then product configuration is saved
    And creators can list products

  Scenario: Admin reviews creator content for monetization
    Given creators submit content for sale
    When the admin reviews pending content
    Then the queue shows:
      | content               | creator              | price  | status   |
      | Week 15 Predictions   | expert@example.com   | $4.99  | Pending  |
      | Draft Strategy Guide  | coach@example.com    | $14.99 | Pending  |
      | Trade Analysis Tool   | analyst@example.com  | $9.99  | Pending  |
    And the admin can approve, reject, or request changes

  Scenario: Admin manages creator disputes
    Given a customer disputes a creator purchase
    When the admin reviews the dispute:
      | field                 | value                    |
      | order_id              | ORD-001234               |
      | customer              | buyer@example.com        |
      | creator               | seller@example.com       |
      | amount                | $9.99                    |
      | reason                | Content not as described |
    Then the admin can issue refund or deny
    And both parties are notified

  # ===========================================
  # Dynamic Pricing Strategies
  # ===========================================

  Scenario: Admin configures dynamic pricing rules
    When the admin sets up dynamic pricing:
      | rule_name             | condition                    | adjustment |
      | Peak Season           | NFL Playoffs active          | +20%       |
      | Off-Season Discount   | NFL Off-season               | -30%       |
      | New User Discount     | First 7 days                 | -50%       |
      | Loyalty Bonus         | Subscriber > 12 months       | -15%       |
      | Bundle Discount       | 3+ leagues                   | -25%       |
    Then pricing rules are active
    And prices adjust automatically

  Scenario: Admin views pricing experiments
    Given A/B pricing tests are running
    When the admin views experiment results
    Then results are displayed:
      | experiment            | variant_a | variant_b | winner   | confidence |
      | Annual Pricing        | $99.99    | $89.99    | $89.99   | 95%        |
      | League Entry Fee      | $25.00    | $19.99    | $19.99   | 88%        |
      | Pro Tier Pricing      | $9.99     | $12.99    | $9.99    | 92%        |
    And the admin can implement winning variants

  Scenario: Admin configures promotional pricing
    When the admin creates a promotion:
      | field                 | value                    |
      | name                  | Super Bowl Special       |
      | discount_type         | Percentage               |
      | discount_value        | 40%                      |
      | applies_to            | Annual subscriptions     |
      | start_date            | 2024-02-01               |
      | end_date              | 2024-02-11               |
      | max_redemptions       | 5,000                    |
      | promo_code            | SUPERBOWL2024            |
    Then the promotion is scheduled
    And marketing can be coordinated

  Scenario: Admin sets geographic pricing
    Given users are in different regions
    When the admin configures regional pricing:
      | region              | currency | multiplier | reason           |
      | United States       | USD      | 1.0x       | Base pricing     |
      | European Union      | EUR      | 0.95x      | VAT included     |
      | United Kingdom      | GBP      | 0.85x      | Market rate      |
      | Canada              | CAD      | 1.25x      | Currency rate    |
      | Emerging Markets    | Local    | 0.5x       | PPP adjustment   |
    Then regional pricing is applied automatically
    And users see localized prices

  Scenario: Admin configures volume discounts
    Given leagues have varying sizes
    When the admin sets volume pricing:
      | league_size       | discount | price_per_user |
      | 1-10 players      | 0%       | $5.00          |
      | 11-25 players     | 10%      | $4.50          |
      | 26-50 players     | 20%      | $4.00          |
      | 51-100 players    | 30%      | $3.50          |
      | 100+ players      | 40%      | $3.00          |
    Then volume discounts are applied
    And larger leagues pay less per user

  # ===========================================
  # Revenue Performance Analytics
  # ===========================================

  Scenario: Admin views revenue analytics dashboard
    When the admin navigates to revenue analytics
    Then the dashboard shows:
      | metric                    | value       | trend   |
      | Total Revenue             | $281,140    | +15%    |
      | New Customer Revenue      | $45,230     | +22%    |
      | Existing Customer Revenue | $235,910    | +12%    |
      | Refunds                   | $2,450      | -8%     |
      | Net Revenue               | $278,690    | +16%    |

  Scenario: Admin analyzes revenue by cohort
    Given users joined at different times
    When the admin views cohort analysis
    Then revenue by cohort is displayed:
      | cohort        | users  | revenue_m1 | revenue_m6 | revenue_m12 | ltv     |
      | Jan 2024      | 1,234  | $4,567     | $12,345    | -           | $45.67  |
      | Dec 2023      | 1,456  | $5,234     | $15,678    | -           | $52.34  |
      | Jun 2023      | 1,890  | $6,789     | $18,456    | $34,567     | $67.89  |
    And retention curves are shown

  Scenario: Admin views revenue funnel analysis
    When the admin views the revenue funnel
    Then conversion metrics are displayed:
      | stage                  | users   | conversion | revenue_potential |
      | Visitors               | 125,000 | -          | -                 |
      | Free Sign-ups          | 45,230  | 36.2%      | -                 |
      | Trial Started          | 12,450  | 27.5%      | -                 |
      | Paid Conversion        | 5,890   | 47.3%      | $58,851           |
      | Upgrade to Premium     | 1,234   | 20.9%      | $24,668           |
    And funnel optimization suggestions are provided

  Scenario: Admin views revenue attribution
    Given users come from different sources
    When the admin views attribution report
    Then revenue is attributed:
      | source              | revenue    | users  | cac     | roi     |
      | Organic Search      | $89,450    | 2,345  | $0      | -       |
      | Paid Social         | $56,780    | 1,890  | $12.50  | 240%    |
      | Referral Program    | $45,230    | 1,234  | $8.00   | 360%    |
      | Content Marketing   | $34,560    | 987    | $5.00   | 600%    |
      | Affiliate           | $23,450    | 678    | $15.00  | 180%    |

  Scenario: Admin views churn analysis
    Given users have churned
    When the admin views churn analytics
    Then churn data is displayed:
      | metric                    | value   |
      | Monthly Churn Rate        | 3.2%    |
      | Annual Churn Rate         | 32.4%   |
      | Revenue Churn             | $12,450 |
      | Primary Churn Reason      | Price   |
      | At-Risk Users             | 456     |
    And churn prediction scores are available

  # ===========================================
  # Monetization Payments
  # ===========================================

  Scenario: Admin views payment overview
    When the admin navigates to payments
    Then payment metrics are displayed:
      | metric                    | value       |
      | Successful Payments       | 12,450      |
      | Failed Payments           | 234         |
      | Payment Success Rate      | 98.2%       |
      | Processing Fees           | $3,450      |
      | Chargebacks               | 12          |

  Scenario: Admin views pending creator payouts
    Given creator payouts are due
    When the admin views pending payouts
    Then payouts are listed:
      | creator              | amount     | period       | method   | status    |
      | creator1@example.com | $1,234.56  | January 2024 | Bank     | Pending   |
      | creator2@example.com | $567.89    | January 2024 | PayPal   | Pending   |
      | creator3@example.com | $89.12     | January 2024 | Bank     | Below Min |
    And the admin can process or hold payouts

  Scenario: Admin processes bulk payouts
    Given multiple payouts are pending
    When the admin initiates bulk payout:
      | setting               | value              |
      | payout_date           | 2024-01-15         |
      | total_payouts         | 145                |
      | total_amount          | $145,670.00        |
      | payment_processor     | Stripe Connect     |
    Then payouts are queued for processing
    And creators are notified

  Scenario: Admin handles failed payments
    Given payments have failed
    When the admin views failed payments
    Then failures are categorized:
      | reason                | count | amount     | retry_eligible |
      | Insufficient Funds    | 89    | $4,567.00  | Yes            |
      | Card Expired          | 67    | $3,456.00  | No             |
      | Bank Declined         | 45    | $2,345.00  | Yes            |
      | Invalid Card          | 23    | $1,234.00  | No             |
    And the admin can trigger retries or contact users

  Scenario: Admin manages refunds
    Given refund requests exist
    When the admin views refund queue
    Then requests are displayed:
      | order_id     | user              | amount  | reason           | recommended |
      | ORD-001234   | user1@example.com | $9.99   | Duplicate charge | Approve     |
      | ORD-001235   | user2@example.com | $25.00  | Not satisfied    | Review      |
      | ORD-001236   | user3@example.com | $4.99   | Fraud suspected  | Deny        |
    And the admin can process each request

  Scenario: Admin configures payment methods
    When the admin manages payment methods:
      | method              | enabled | fees    | regions           |
      | Credit Card         | Yes     | 2.9%    | All               |
      | PayPal              | Yes     | 3.4%    | All               |
      | Apple Pay           | Yes     | 2.9%    | US, EU, UK        |
      | Google Pay          | Yes     | 2.9%    | US, EU, UK        |
      | Bank Transfer       | Yes     | 1.0%    | US, EU            |
      | Crypto              | No      | 1.5%    | US                |
    Then payment options are updated
    And users see available methods

  # ===========================================
  # Content Pricing Effectiveness
  # ===========================================

  Scenario: Admin analyzes pricing effectiveness
    When the admin views pricing analysis
    Then effectiveness metrics are shown:
      | product             | price  | sales  | revenue | conversion | optimal_price |
      | Pro Subscription    | $9.99  | 5,890  | $58,851 | 12.5%      | $8.99         |
      | League Entry        | $25.00 | 3,456  | $86,400 | 8.2%       | $19.99        |
      | Strategy Guide      | $14.99 | 1,234  | $18,498 | 5.6%       | $12.99        |
    And price elasticity insights are provided

  Scenario: Admin views price sensitivity analysis
    Given pricing data is available
    When the admin runs price sensitivity analysis
    Then the analysis shows:
      | price_point | estimated_demand | revenue_potential | margin  |
      | $4.99       | 8,500            | $42,415           | Low     |
      | $9.99       | 5,890            | $58,851           | Medium  |
      | $14.99      | 3,200            | $47,968           | High    |
      | $19.99      | 1,800            | $35,982           | High    |
    And optimal price point is recommended

  Scenario: Admin compares competitive pricing
    Given competitor pricing data exists
    When the admin views competitive analysis
    Then comparison is displayed:
      | feature             | our_price | competitor_a | competitor_b | position   |
      | Basic Subscription  | $4.99     | $5.99        | $4.99        | Competitive|
      | Pro Subscription    | $9.99     | $9.99        | $12.99       | Competitive|
      | League Entry        | $25.00    | $20.00       | $30.00       | Mid-market |
    And pricing recommendations are provided

  # ===========================================
  # Promotional Campaigns
  # ===========================================

  Scenario: Admin views active promotions
    When the admin views promotions
    Then active promotions are displayed:
      | promotion           | discount | redemptions | revenue_impact | status    |
      | New Year Special    | 30%      | 1,234       | +$12,450       | Active    |
      | Referral Bonus      | $10      | 567         | +$5,670        | Active    |
      | Bundle Deal         | 25%      | 345         | +$3,450        | Active    |

  Scenario: Admin creates promotional campaign
    When the admin creates a campaign:
      | field               | value                          |
      | name                | March Madness Promo            |
      | type                | Percentage Discount            |
      | value               | 35%                            |
      | target_products     | Pro Subscription               |
      | target_audience     | Lapsed users (30-90 days)      |
      | start_date          | 2024-03-01                     |
      | end_date            | 2024-03-31                     |
      | budget              | $10,000                        |
    Then the campaign is scheduled
    And targeting rules are configured

  Scenario: Admin views campaign performance
    Given a campaign is running
    When the admin views performance metrics
    Then the report shows:
      | metric                    | value       |
      | Impressions               | 45,230      |
      | Redemptions               | 1,234       |
      | Conversion Rate           | 2.7%        |
      | Revenue Generated         | $12,340     |
      | Cost (Discount Given)     | $4,567      |
      | Net ROI                   | 170%        |

  # ===========================================
  # Creator Economic Support
  # ===========================================

  Scenario: Admin views creator economic health
    When the admin views creator economics dashboard
    Then health metrics are displayed:
      | metric                    | value       |
      | Creators Earning > $100   | 156         |
      | Creators Earning > $1,000 | 45          |
      | Average Creator Earnings  | $594        |
      | Median Creator Earnings   | $234        |
      | Creators At Risk          | 23          |

  Scenario: Admin provides creator support
    Given a creator is struggling
    When the admin initiates support:
      | support_type          | value                    |
      | creator               | struggling@example.com   |
      | promotional_boost     | Featured for 7 days      |
      | revenue_advance       | $500                     |
      | coaching_session      | Scheduled                |
      | resource_access       | Creator toolkit          |
    Then support measures are applied
    And creator is notified

  Scenario: Admin manages creator tiers
    When the admin configures creator program tiers:
      | tier        | requirements              | benefits                    |
      | New         | Just joined              | Basic tools, 65% share      |
      | Rising      | $500 lifetime earnings   | Analytics, 70% share        |
      | Established | $5,000 lifetime earnings | Promotion, 75% share        |
      | Star        | $25,000 lifetime earnings| Priority support, 80% share |
      | Partner     | $100,000+ lifetime       | Custom terms, 85%+ share    |
    Then tier structure is saved
    And creators auto-advance as they qualify

  # ===========================================
  # Revenue Forecasting
  # ===========================================

  Scenario: Admin views revenue forecasts
    When the admin navigates to forecasting
    Then forecasts are displayed:
      | period     | projected_revenue | confidence | growth_rate |
      | February   | $295,000          | High       | +5%         |
      | Q1 2024    | $875,000          | High       | +12%        |
      | Q2 2024    | $920,000          | Medium     | +5%         |
      | 2024       | $3.8M             | Medium     | +18%        |

  Scenario: Admin creates revenue scenarios
    When the admin models scenarios:
      | scenario          | assumptions                    | projected_revenue |
      | Conservative      | 2% growth, 5% churn            | $3.2M             |
      | Base Case         | 5% growth, 3% churn            | $3.8M             |
      | Optimistic        | 10% growth, 2% churn           | $4.5M             |
      | New Product Launch| New tier + 15% adoption        | $4.2M             |
    Then scenarios are saved for comparison
    And variance analysis is available

  Scenario: Admin sets revenue targets
    When the admin configures targets:
      | metric                    | target      | stretch     |
      | Monthly Revenue           | $300,000    | $350,000    |
      | Quarterly Revenue         | $950,000    | $1,100,000  |
      | Annual Revenue            | $4,000,000  | $4,500,000  |
      | Creator Payouts           | $1,200,000  | $1,400,000  |
    Then targets are tracked
    And progress is reported regularly

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot set negative prices
    Given the admin is editing pricing
    When the admin attempts to set a negative price
    Then the request is rejected with error "INVALID_PRICE"
    And the error message is "Price must be greater than zero"

  Scenario: Admin cannot lower creator share below minimum
    Given revenue sharing has minimums
    When the admin attempts to set creator share below 50%
    Then the request is rejected with error "SHARE_BELOW_MINIMUM"
    And the minimum share requirement is displayed

  Scenario: Admin cannot process payout without verification
    Given a creator's payment info is unverified
    When the admin attempts to process payout
    Then the request is blocked with error "PAYMENT_VERIFICATION_REQUIRED"
    And verification steps are displayed

  Scenario: Promotion conflicts with existing campaign
    Given an active promotion exists for the same products
    When the admin creates an overlapping promotion
    Then a warning is displayed:
      """
      Warning: This promotion overlaps with "New Year Special"
      for the same products. Users may stack discounts.

      Options:
      1. Exclude existing promotion users
      2. End existing promotion early
      3. Proceed with overlap
      """

  Scenario: Admin cannot delete tier with active subscribers
    Given the "Pro" tier has active subscribers
    When the admin attempts to delete the tier
    Then the request is blocked with error "TIER_HAS_ACTIVE_SUBSCRIBERS"
    And migration options are displayed
