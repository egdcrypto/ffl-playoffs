Feature: Admin Pricing Configuration
  As a Platform Administrator
  I want to configure and manage pricing strategies
  So that I can optimize revenue and market positioning

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have pricing configuration permissions
    And the pricing system is enabled

  # ===========================================
  # Pricing Plan Management
  # ===========================================

  Scenario: Admin views current pricing structure
    When the admin navigates to pricing configuration
    Then the pricing structure is displayed:
      | plan        | monthly | annual  | features               | subscribers |
      | Free        | $0      | $0      | Basic access           | 45,230      |
      | Basic       | $4.99   | $49.99  | Enhanced features      | 12,450      |
      | Pro         | $9.99   | $99.99  | Full features          | 5,890       |
      | Elite       | $19.99  | $199.99 | Premium + Priority     | 1,234       |
    And revenue metrics are shown for each plan

  Scenario: Admin views plan comparison matrix
    When the admin views plan comparison
    Then features are compared:
      | feature                 | Free  | Basic | Pro   | Elite |
      | Max Leagues             | 1     | 3     | 10    | Unlimited |
      | Player Analytics        | Basic | Full  | Full  | Full  |
      | AI Predictions          | No    | Limited| Full | Full  |
      | Ad-Free Experience      | No    | No    | Yes   | Yes   |
      | Priority Support        | No    | No    | No    | Yes   |
      | API Access              | No    | No    | Yes   | Yes   |
      | Custom Branding         | No    | No    | No    | Yes   |

  Scenario: Admin creates new pricing plan
    When the admin creates a pricing plan:
      | field               | value                          |
      | name                | Team                           |
      | description         | For small groups               |
      | monthly_price       | $14.99                         |
      | annual_price        | $149.99                        |
      | annual_discount     | 17%                            |
      | max_users           | 5                              |
      | position            | Between Pro and Elite          |
    Then the plan is created in draft status
    And pricing page preview is generated

  Scenario: Admin modifies pricing plan
    Given the "Pro" plan exists
    When the admin modifies the plan:
      | field               | old_value | new_value |
      | monthly_price       | $9.99     | $12.99    |
      | annual_price        | $99.99    | $129.99   |
      | effective_date      | -         | 2024-02-01|
    Then the changes are staged
    And existing subscribers are flagged for review

  Scenario: Admin archives pricing plan
    Given the "Legacy" plan has no active subscribers
    When the admin archives the plan
    Then the plan is marked as archived
    And it no longer appears in public pricing
    And historical data is preserved

  Scenario: Admin views plan performance metrics
    When the admin views plan analytics
    Then performance is displayed:
      | plan    | revenue_mtd | growth | churn | ltv     | margin |
      | Basic   | $62,168     | +8%    | 4.2%  | $156.00 | 85%    |
      | Pro     | $58,851     | +12%   | 2.8%  | $312.00 | 88%    |
      | Elite   | $24,668     | +15%   | 1.5%  | $567.00 | 92%    |

  # ===========================================
  # Dynamic Pricing Configuration
  # ===========================================

  Scenario: Admin configures dynamic pricing rules
    When the admin sets up dynamic pricing:
      | rule_name           | condition                    | adjustment |
      | Peak Season         | NFL Playoffs (Jan-Feb)       | +15%       |
      | Off-Season          | NFL Off-season (Mar-Aug)     | -20%       |
      | Game Day            | Sunday 12PM-8PM              | +10%       |
      | Early Bird          | 30+ days before season       | -25%       |
    Then pricing rules are saved
    And prices adjust automatically

  Scenario: Admin configures demand-based pricing
    When the admin enables demand pricing:
      | setting             | value                |
      | enabled             | Yes                  |
      | min_adjustment      | -30%                 |
      | max_adjustment      | +25%                 |
      | demand_signal       | Signup velocity      |
      | adjustment_frequency| Daily                |
    Then demand pricing is active
    And prices reflect current demand

  Scenario: Admin sets time-limited pricing
    When the admin creates time-limited offer:
      | field               | value                |
      | name                | Flash Sale           |
      | discount            | 40%                  |
      | start_time          | 2024-01-20 00:00 UTC |
      | end_time            | 2024-01-20 23:59 UTC |
      | max_redemptions     | 500                  |
      | applies_to          | Pro Annual           |
    Then the offer is scheduled
    And countdown timer will display

  Scenario: Admin views dynamic pricing history
    Given dynamic pricing has been active
    When the admin views pricing history
    Then adjustments are displayed:
      | date       | plan    | base_price | adjustment | final_price | reason      |
      | 2024-01-15 | Pro     | $9.99      | +10%       | $10.99      | Game Day    |
      | 2024-01-14 | Pro     | $9.99      | 0%         | $9.99       | Standard    |
      | 2024-01-13 | Pro     | $9.99      | -20%       | $7.99       | Off-Season  |

  # ===========================================
  # Add-on Products
  # ===========================================

  Scenario: Admin views add-on products
    When the admin navigates to add-ons
    Then add-ons are displayed:
      | add_on               | price    | compatible_plans | purchases |
      | Extra League Slot    | $2.99/mo | Basic, Pro       | 3,450     |
      | Advanced Analytics   | $4.99/mo | Free, Basic      | 2,890     |
      | Priority Support     | $9.99/mo | Basic, Pro       | 1,234     |
      | API Access           | $19.99/mo| Basic            | 567       |

  Scenario: Admin creates add-on product
    When the admin creates an add-on:
      | field               | value                    |
      | name                | AI Coach                 |
      | description         | Personalized AI advice   |
      | monthly_price       | $7.99                    |
      | compatible_plans    | Basic, Pro               |
      | trial_period        | 7 days                   |
      | bundled_with        | None                     |
    Then the add-on is created
    And it appears in upgrade options

  Scenario: Admin configures add-on pricing tiers
    Given the "Extra League Slot" add-on exists
    When the admin configures quantity pricing:
      | quantity | price_each | total    |
      | 1        | $2.99      | $2.99    |
      | 2-3      | $2.49      | $4.98-$7.47 |
      | 4-5      | $1.99      | $7.96-$9.95 |
      | 6+       | $1.49      | $8.94+   |
    Then quantity discounts are applied
    And users see savings on bulk purchase

  Scenario: Admin manages add-on compatibility
    When the admin updates add-on compatibility:
      | add_on               | free | basic | pro | elite | notes              |
      | Extra League Slot    | No   | Yes   | Yes | No    | Included in Elite  |
      | Advanced Analytics   | Yes  | Yes   | No  | No    | Included in Pro+   |
      | Priority Support     | No   | Yes   | Yes | No    | Included in Elite  |
    Then compatibility rules are updated
    And UI reflects available options

  # ===========================================
  # Regional Pricing
  # ===========================================

  Scenario: Admin views regional pricing
    When the admin navigates to regional pricing
    Then regional prices are displayed:
      | region              | currency | multiplier | pro_monthly | status   |
      | United States       | USD      | 1.0x       | $9.99       | Active   |
      | European Union      | EUR      | 0.95x      | €9.49       | Active   |
      | United Kingdom      | GBP      | 0.85x      | £8.49       | Active   |
      | Canada              | CAD      | 1.25x      | $12.49      | Active   |
      | Australia           | AUD      | 1.35x      | $13.49      | Active   |

  Scenario: Admin configures regional pricing
    When the admin adds regional pricing:
      | field               | value                |
      | region              | Brazil               |
      | currency            | BRL                  |
      | multiplier          | 0.40x                |
      | reasoning           | PPP adjustment       |
      | effective_date      | 2024-02-01           |
    Then regional pricing is configured
    And Brazilian users see localized prices

  Scenario: Admin configures emerging market pricing
    When the admin sets up emerging market tiers:
      | tier                | countries                    | discount |
      | Tier 1              | India, Indonesia, Vietnam    | 60%      |
      | Tier 2              | Brazil, Mexico, Turkey       | 50%      |
      | Tier 3              | Poland, Thailand, Philippines| 40%      |
    Then purchasing power parity is applied
    And users see fair regional pricing

  Scenario: Admin prevents regional arbitrage
    When the admin configures anti-arbitrage rules:
      | setting             | value                    |
      | vpn_detection       | Enabled                  |
      | billing_address_check| Required                |
      | payment_method_region| Must match              |
      | region_lock_period  | 12 months                |
    Then arbitrage protection is active
    And violations are logged

  # ===========================================
  # Promotional Campaigns
  # ===========================================

  Scenario: Admin views active promotions
    When the admin views promotions
    Then active promotions are displayed:
      | promotion           | discount | redemptions | revenue   | status  |
      | New Year Sale       | 30%      | 1,234       | $12,340   | Active  |
      | Referral Bonus      | $10      | 567         | $5,670    | Active  |
      | Student Discount    | 50%      | 890         | $4,450    | Active  |

  Scenario: Admin creates promotional campaign
    When the admin creates a promotion:
      | field               | value                    |
      | name                | Super Bowl Promo         |
      | code                | SUPERBOWL2024            |
      | discount_type       | Percentage               |
      | discount_value      | 35%                      |
      | applies_to          | All annual plans         |
      | start_date          | 2024-02-01               |
      | end_date            | 2024-02-11               |
      | max_redemptions     | 5,000                    |
      | new_users_only      | No                       |
    Then the promotion is created
    And promo code is active

  Scenario: Admin configures promotion targeting
    Given a promotion exists
    When the admin sets targeting rules:
      | rule                    | value                    |
      | user_segments           | Lapsed users (30-90 days)|
      | geographic_regions      | US, Canada               |
      | referral_source         | Social media             |
      | minimum_plan            | Basic                    |
      | exclude_current_promos  | Yes                      |
    Then targeting is configured
    And only eligible users see the promotion

  Scenario: Admin views promotion analytics
    Given a promotion is running
    When the admin views promotion performance
    Then metrics are displayed:
      | metric                    | value       |
      | Impressions               | 45,230      |
      | Code Uses                 | 1,234       |
      | Conversion Rate           | 2.7%        |
      | Revenue Generated         | $12,340     |
      | Discount Given            | $6,340      |
      | Net ROI                   | 95%         |
      | Avg Order Value           | $45.67      |

  Scenario: Admin manages coupon codes
    When the admin manages coupons:
      | action              | code          | details              |
      | Create              | WELCOME20     | 20% off first month  |
      | Disable             | EXPIRED2023   | No longer valid      |
      | Extend              | HOLIDAY2024   | Extend to Feb 28     |
      | Limit               | FLASH50       | Reduce max to 100    |
    Then coupon changes are applied
    And audit trail is updated

  # ===========================================
  # Product Bundles
  # ===========================================

  Scenario: Admin views product bundles
    When the admin navigates to bundles
    Then bundles are displayed:
      | bundle               | includes                    | price   | savings |
      | Complete Package     | Pro + All Add-ons           | $24.99  | 35%     |
      | Family Plan          | Pro + 4 Extra Users         | $19.99  | 40%     |
      | Season Pass          | Pro Annual + Merch Credit   | $119.99 | 25%     |

  Scenario: Admin creates product bundle
    When the admin creates a bundle:
      | field               | value                        |
      | name                | Ultimate Fan Bundle          |
      | includes            | Elite + API Access + Support |
      | monthly_price       | $34.99                       |
      | savings_display     | Save $15/month               |
      | limited_time        | No                           |
      | featured            | Yes                          |
    Then the bundle is created
    And appears in pricing options

  Scenario: Admin configures bundle discounts
    Given a bundle exists
    When the admin configures discount structure:
      | component           | regular_price | bundle_price | discount |
      | Elite Plan          | $19.99        | $18.99       | 5%       |
      | API Access          | $19.99        | $12.99       | 35%      |
      | Priority Support    | $9.99         | $3.01        | 70%      |
      | Total               | $49.97        | $34.99       | 30%      |
    Then bundle pricing is configured
    And component savings are displayed

  Scenario: Admin manages bundle availability
    When the admin configures bundle rules:
      | setting             | value                    |
      | available_to        | New users only           |
      | min_commitment      | Annual                   |
      | upgrade_eligible    | Yes                      |
      | downgrade_rules     | Pro-rated refund         |
    Then bundle rules are saved
    And eligibility is enforced

  # ===========================================
  # A/B Price Testing
  # ===========================================

  Scenario: Admin creates price test
    When the admin creates an A/B test:
      | field               | value                    |
      | name                | Pro Pricing Test         |
      | product             | Pro Monthly              |
      | variant_a           | $9.99 (control)          |
      | variant_b           | $12.99                   |
      | variant_c           | $7.99                    |
      | traffic_split       | 33% / 33% / 34%          |
      | duration            | 30 days                  |
      | success_metric      | Revenue per visitor      |
    Then the test is created
    And begins when scheduled

  Scenario: Admin views test results
    Given a price test has been running
    When the admin views test results
    Then results are displayed:
      | variant | price  | conversions | revenue  | rpv    | confidence |
      | A       | $9.99  | 456         | $4,555   | $0.91  | Control    |
      | B       | $12.99 | 312         | $4,053   | $0.81  | 85%        |
      | C       | $7.99  | 589         | $4,706   | $0.94  | 92%        |
    And statistical significance is shown

  Scenario: Admin implements test winner
    Given a price test has concluded
    And variant C is the winner
    When the admin implements the winner
    Then the new price is applied
    And test variants are merged
    And all users see winning price

  Scenario: Admin configures test guardrails
    When the admin sets test limits:
      | guardrail           | value                    |
      | max_price_increase  | 50%                      |
      | max_price_decrease  | 50%                      |
      | min_sample_size     | 1,000 per variant        |
      | max_revenue_loss    | 10%                      |
      | auto_stop           | If revenue drops > 15%   |
    Then guardrails are configured
    And tests are monitored

  # ===========================================
  # Grandfathering Policies
  # ===========================================

  Scenario: Admin configures grandfathering
    When the admin sets grandfathering policy:
      | setting             | value                    |
      | price_lock_period   | 24 months                |
      | feature_changes     | Add only, never remove   |
      | notification_period | 60 days before expiry    |
      | renewal_terms       | Current price + max 10%  |
    Then grandfathering policy is saved
    And existing subscribers are protected

  Scenario: Admin views grandfathered subscribers
    When the admin views grandfathered users
    Then users are displayed:
      | user                | plan   | locked_price | lock_expires | current_price |
      | user1@example.com   | Pro    | $7.99        | 2024-06-15   | $9.99         |
      | user2@example.com   | Elite  | $14.99       | 2024-09-20   | $19.99        |
      | user3@example.com   | Basic  | $3.99        | 2025-01-01   | $4.99         |
    And revenue impact is calculated

  Scenario: Admin extends grandfathering
    Given users have expiring price locks
    When the admin extends grandfathering:
      | selection           | Extension              |
      | All expiring in 30d | 12 additional months   |
      | Reason              | Customer retention     |
      | Notify users        | Yes                    |
    Then price locks are extended
    And users receive notification

  Scenario: Admin transitions grandfathered users
    Given grandfathering is expiring for users
    When the admin configures transition:
      | setting             | value                    |
      | transition_period   | 3 billing cycles         |
      | step_increases      | 33% per cycle            |
      | retention_offer     | 20% loyalty discount     |
      | allow_downgrade     | Yes                      |
    Then transition plan is created
    And users are notified of options

  # ===========================================
  # Usage-Based Pricing
  # ===========================================

  Scenario: Admin configures usage-based pricing
    When the admin sets up usage pricing:
      | metric              | included   | overage_rate |
      | API Calls           | 10,000/mo  | $0.001 each  |
      | AI Predictions      | 100/mo     | $0.10 each   |
      | Data Exports        | 5/mo       | $0.50 each   |
      | Premium Stats       | 50/mo      | $0.05 each   |
    Then usage tiers are configured
    And metering begins

  Scenario: Admin views usage metrics
    When the admin views usage data
    Then metrics are displayed:
      | metric              | total_usage | overage_users | overage_revenue |
      | API Calls           | 45.2M       | 234           | $4,520          |
      | AI Predictions      | 125,000     | 567           | $2,500          |
      | Data Exports        | 8,900       | 1,234         | $1,950          |
    And usage trends are shown

  Scenario: Admin configures usage alerts
    When the admin sets usage alerts:
      | threshold           | action                   |
      | 80% of included     | Email notification       |
      | 100% of included    | In-app warning           |
      | 150% of included    | Upgrade prompt           |
      | 200% of included    | Rate limit + alert       |
    Then usage alerts are configured
    And users are notified proactively

  Scenario: Admin configures rollover credits
    When the admin enables usage rollover:
      | setting             | value                    |
      | rollover_enabled    | Yes                      |
      | max_rollover        | 50% of monthly included  |
      | expiration          | Next billing cycle       |
      | applies_to          | Pro and Elite only       |
    Then rollover is configured
    And unused credits carry forward

  # ===========================================
  # Enterprise Pricing
  # ===========================================

  Scenario: Admin views enterprise pricing
    When the admin navigates to enterprise
    Then enterprise deals are displayed:
      | customer            | users  | price/user | contract | mrr      |
      | ESPN                | 500    | $8.00      | 2 years  | $4,000   |
      | Yahoo               | 250    | $10.00     | 1 year   | $2,500   |
      | CBS Sports          | 100    | $12.00     | 1 year   | $1,200   |

  Scenario: Admin creates enterprise quote
    When the admin creates a quote:
      | field               | value                    |
      | customer            | NFL Network              |
      | users               | 1,000                    |
      | base_plan           | Enterprise               |
      | discount            | 35%                      |
      | price_per_user      | $6.50                    |
      | contract_length     | 3 years                  |
      | payment_terms       | Annual upfront           |
      | custom_features     | Dedicated support, SLA   |
    Then the quote is generated
    And sent for customer review

  Scenario: Admin configures volume discounts
    When the admin sets volume tiers:
      | users               | discount | price/user |
      | 10-49               | 10%      | $9.00      |
      | 50-99               | 20%      | $8.00      |
      | 100-249             | 30%      | $7.00      |
      | 250-499             | 40%      | $6.00      |
      | 500+                | 50%      | $5.00      |
    Then volume pricing is configured
    And quotes auto-calculate

  Scenario: Admin manages enterprise contracts
    When the admin views contract management
    Then contracts are displayed:
      | customer            | status    | renewal     | action_needed |
      | ESPN                | Active    | 2025-06-15  | None          |
      | Yahoo               | Active    | 2024-09-20  | Renewal soon  |
      | Legacy Corp         | Expiring  | 2024-02-01  | Urgent        |
    And renewal workflows are available

  # ===========================================
  # Competitor Pricing Tracking
  # ===========================================

  Scenario: Admin views competitor pricing
    When the admin views competitive analysis
    Then competitor prices are displayed:
      | competitor          | basic   | pro     | elite   | last_updated |
      | FFL Playoffs (Us)   | $4.99   | $9.99   | $19.99  | Current      |
      | ESPN Fantasy+       | $6.99   | $12.99  | $24.99  | 2024-01-10   |
      | Yahoo Fantasy+      | $4.99   | $9.99   | $14.99  | 2024-01-08   |
      | Sleeper Premium     | $4.99   | $7.99   | N/A     | 2024-01-12   |

  Scenario: Admin tracks competitor changes
    Given competitor monitoring is enabled
    When a competitor changes pricing
    Then the admin receives alert:
      | field               | value                    |
      | competitor          | ESPN Fantasy+            |
      | product             | Pro tier                 |
      | old_price           | $9.99                    |
      | new_price           | $12.99                   |
      | change              | +30%                     |
      | effective_date      | 2024-02-01               |
    And market position is recalculated

  Scenario: Admin views market position
    When the admin views market positioning
    Then positioning is displayed:
      | metric              | our_position | market_avg | premium/discount |
      | Basic Plan          | $4.99        | $5.66      | -12% (Value)     |
      | Pro Plan            | $9.99        | $10.32     | -3% (Competitive)|
      | Elite Plan          | $19.99       | $19.99     | 0% (At Market)   |

  # ===========================================
  # Pricing Optimization
  # ===========================================

  Scenario: Admin views optimization suggestions
    When the admin views pricing recommendations
    Then suggestions are displayed:
      | recommendation              | potential_impact | confidence |
      | Raise Pro to $11.99         | +$8,450 MRR      | High       |
      | Add $6.99 tier              | +$12,340 MRR     | Medium     |
      | Reduce Elite to $17.99      | +$3,450 MRR      | Low        |
      | Bundle analytics add-on     | +$5,670 MRR      | High       |

  Scenario: Admin runs pricing simulation
    When the admin simulates price change:
      | setting             | value                    |
      | product             | Pro Monthly              |
      | current_price       | $9.99                    |
      | proposed_price      | $12.99                   |
      | elasticity_model    | Historical               |
    Then simulation results show:
      | metric              | current   | projected | change   |
      | Subscribers         | 5,890     | 4,850     | -18%     |
      | MRR                 | $58,851   | $62,978   | +7%      |
      | Churn Rate          | 2.8%      | 4.2%      | +50%     |

  Scenario: Admin views price elasticity
    When the admin views elasticity analysis
    Then elasticity data is displayed:
      | product             | elasticity | interpretation           |
      | Basic Monthly       | -1.8       | Elastic - price sensitive|
      | Pro Monthly         | -0.9       | Unit elastic             |
      | Elite Monthly       | -0.4       | Inelastic - loyal users  |
      | Annual Plans        | -0.6       | Less elastic than monthly|

  # ===========================================
  # Pricing Approvals
  # ===========================================

  Scenario: Admin submits pricing for approval
    Given pricing changes are staged
    When the admin submits for approval:
      | field               | value                    |
      | change_summary      | Pro: $9.99 -> $12.99     |
      | effective_date      | 2024-02-01               |
      | justification       | Market alignment         |
      | revenue_impact      | +$8,450 MRR              |
      | risk_assessment     | Low - within market norm |
    Then the request is submitted
    And approvers are notified

  Scenario: Admin views approval workflow
    When the admin views pending approvals
    Then requests are displayed:
      | change              | submitted_by | status    | approvers          |
      | Pro price increase  | admin@...    | Pending   | finance, marketing |
      | New bundle          | admin@...    | Approved  | -                  |
      | Regional pricing    | admin@...    | Rejected  | legal              |
    And approval history is visible

  Scenario: Admin configures approval rules
    When the admin sets approval requirements:
      | change_type             | approvers_required       |
      | Price increase > 10%    | Finance + CEO            |
      | Price decrease > 20%    | Finance                  |
      | New plan creation       | Product + Finance        |
      | Regional pricing        | Legal + Finance          |
      | Promotional campaigns   | Marketing                |
    Then approval rules are saved
    And workflows are enforced

  # ===========================================
  # Pricing Communications
  # ===========================================

  Scenario: Admin configures price change notifications
    When the admin sets notification settings:
      | setting             | value                    |
      | advance_notice      | 30 days                  |
      | channels            | Email, In-app, SMS       |
      | include_reasons     | Yes                      |
      | offer_alternatives  | Yes                      |
      | lock_current_price  | For annual subscribers   |
    Then notification rules are saved
    And templates are prepared

  Scenario: Admin previews customer communications
    Given a price change is scheduled
    When the admin previews communications
    Then email template shows:
      """
      Subject: Important Update to Your FFL Playoffs Subscription

      Dear [Customer Name],

      We're writing to let you know about an upcoming change to our pricing.
      Starting [Date], the Pro plan will be $12.99/month (previously $9.99).

      As a valued subscriber, here are your options:
      - Lock in current pricing by switching to annual billing (save 17%)
      - Continue at the new rate with enhanced features
      - Explore our other plan options

      We're committed to providing the best fantasy football experience.
      Thank you for being part of the FFL Playoffs community.
      """
    And the admin can customize messaging

  Scenario: Admin schedules price change rollout
    When the admin configures rollout:
      | setting             | value                    |
      | notification_date   | 2024-01-01               |
      | effective_date      | 2024-02-01               |
      | legacy_user_date    | 2024-03-01               |
      | full_rollout        | 2024-04-01               |
    Then phased rollout is scheduled
    And each segment is notified appropriately

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot set negative price
    When the admin attempts to set price to -$5.00
    Then the request is rejected with error "INVALID_PRICE"
    And the error message is "Price must be zero or positive"

  Scenario: Admin cannot delete plan with subscribers
    Given the "Pro" plan has active subscribers
    When the admin attempts to delete the plan
    Then the request is blocked with error "PLAN_HAS_SUBSCRIBERS"
    And migration options are suggested

  Scenario: Admin cannot create conflicting promotion
    Given a 30% promotion is active for Pro
    When the admin creates another 50% promotion for Pro
    Then a warning is displayed:
      """
      Conflict: Active promotion "New Year Sale" (30% off) overlaps.
      Users could potentially stack discounts.

      Options:
      1. End existing promotion first
      2. Exclude users with active promotions
      3. Allow stacking (not recommended)
      """

  Scenario: Admin cannot bypass approval for major changes
    Given approval is required for changes > 10%
    When the admin attempts to raise prices by 50% without approval
    Then the request is rejected with error "APPROVAL_REQUIRED"
    And the change is staged for review

  Scenario: Regional pricing validation fails
    When the admin sets regional multiplier to 5.0x
    Then the request is rejected with error "MULTIPLIER_OUT_OF_RANGE"
    And valid range (0.1x - 3.0x) is displayed
