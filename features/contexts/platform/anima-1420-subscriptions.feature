@ANIMA-1420 @backend @priority_1 @subscriptions
Feature: Subscriptions System
  As a fantasy football playoffs platform user
  I want to manage my subscription to access premium features
  So that I can enhance my fantasy football experience

  Background:
    Given the subscription system is enabled
    And the user is authenticated
    And subscription plans are configured

  # ==================== SUBSCRIPTION TIERS ====================

  Scenario: View available subscription tiers
    Given the user accesses subscription options
    When subscription tiers are displayed
    Then available tiers show:
      | Tier        | Monthly | Annual  | Description              |
      | Free        | $0      | $0      | Basic features           |
      | Pro         | $9.99   | $79.99  | Advanced analytics       |
      | Premium     | $19.99  | $159.99 | All features + support   |
      | Ultimate    | $29.99  | $239.99 | Everything + exclusive   |
    And feature comparison is displayed
    And savings for annual plans are highlighted

  Scenario: Compare subscription tier features
    Given the user views tier comparison
    When feature matrix loads
    Then features are compared:
      | Feature                    | Free | Pro  | Premium | Ultimate |
      | Basic Roster Management    | Yes  | Yes  | Yes     | Yes      |
      | Live Score Updates         | Yes  | Yes  | Yes     | Yes      |
      | Advanced Player Stats      | No   | Yes  | Yes     | Yes      |
      | Trade Analyzer             | No   | Yes  | Yes     | Yes      |
      | Waiver Wire Assistant      | No   | No   | Yes     | Yes      |
      | Custom Reports             | No   | No   | Yes     | Yes      |
      | Priority Support           | No   | No   | Yes     | Yes      |
      | Exclusive Content          | No   | No   | No      | Yes      |
      | Ad-Free Experience         | No   | Yes  | Yes     | Yes      |
    And upgrade CTAs are shown per tier

  Scenario: View tier-specific details
    Given the user selects "Pro" tier
    When tier details are displayed
    Then information includes:
      | Section             | Content                         |
      | Price Options       | Monthly and annual pricing      |
      | Feature List        | All included features           |
      | Not Included        | Premium-only features grayed    |
      | User Reviews        | Ratings from Pro subscribers    |
      | FAQ                 | Common questions about Pro      |
    And "Start Pro" CTA is prominent

  Scenario: Display best value tier
    Given pricing tiers are shown
    When best value is calculated
    Then the system highlights:
      | Tier            | Badge                           |
      | Pro Annual      | "Most Popular"                  |
      | Premium Annual  | "Best Value"                    |
    And badges are visually prominent
    And value proposition is explained

  Scenario: Show tier pricing by region
    Given the user is in a specific region
    When pricing is displayed
    Then prices are localized:
      | Region      | Pro Monthly | Currency |
      | US          | $9.99       | USD      |
      | UK          | £7.99       | GBP      |
      | EU          | €8.99       | EUR      |
      | Canada      | $12.99      | CAD      |
    And currency symbol matches region
    And conversion rates are current

  # ==================== SUBSCRIPTION SIGNUP ====================

  Scenario: Sign up for subscription from free tier
    Given the user has a free account
    When the user clicks "Upgrade to Pro"
    Then signup flow begins:
      | Step                | Content                         |
      | Plan Selection      | Confirm Pro plan details        |
      | Billing Cycle       | Monthly or Annual               |
      | Payment Method      | Add or select payment           |
      | Review              | Summary before confirmation     |
      | Confirm             | Complete subscription           |
    And subscription activates immediately

  Scenario: Sign up with annual billing
    Given the user selects annual billing
    When annual option is chosen
    Then the display shows:
      | Element             | Value                           |
      | Annual Price        | $79.99/year                     |
      | Monthly Equivalent  | $6.67/month                     |
      | Savings             | Save $40 (33% off)              |
      | Billed              | Once per year                   |
    And savings are emphasized

  Scenario: Sign up with trial offer
    Given a trial offer is available
    When the user starts signup
    Then trial terms show:
      | Element             | Value                           |
      | Trial Length        | 14 days free                    |
      | After Trial         | $9.99/month                     |
      | Billing Date        | February 3, 2025                |
      | Cancel Anytime      | No charge if cancelled in trial |
    And payment method is required upfront

  Scenario: Sign up with promo code
    Given the user has a promo code
    When code is applied during signup
    Then discount is applied:
      | Original Price      | $9.99/month                     |
      | Discount            | -$3.00 (30% off)                |
      | Final Price         | $6.99/month                     |
      | Duration            | First 3 months                  |
    And regular pricing after promo period

  Scenario: Handle signup payment failure
    Given the user completes signup form
    When payment is declined
    Then the system:
      | Shows payment error message             |
      | Preserves form data                     |
      | Offers alternative payment methods      |
      | Does not create subscription            |
    And user can retry with different method

  Scenario: Confirm subscription signup
    Given signup is successful
    When confirmation is displayed
    Then confirmation includes:
      | Element             | Content                         |
      | Welcome Message     | "Welcome to Pro!"               |
      | Subscription Start  | January 20, 2025                |
      | Next Billing        | February 20, 2025               |
      | New Features        | Quick tour of Pro features      |
      | Receipt             | Email confirmation sent         |
    And features are unlocked immediately

  # ==================== SUBSCRIPTION MANAGEMENT ====================

  Scenario: View current subscription
    Given the user has an active subscription
    When subscription details are accessed
    Then current subscription shows:
      | Field               | Value                           |
      | Plan                | Pro Monthly                     |
      | Status              | Active                          |
      | Started             | January 15, 2025                |
      | Next Billing        | February 15, 2025               |
      | Amount              | $9.99                           |
      | Payment Method      | Visa ending 4242                |
    And management options are available

  Scenario: Change billing cycle
    Given the user has monthly billing
    When switching to annual billing
    Then the change shows:
      | Current Cycle       | Monthly ($9.99/mo)              |
      | New Cycle           | Annual ($79.99/yr)              |
      | Savings             | $40/year                        |
      | Effective           | Next billing date               |
      | Credit              | Prorated for remaining days     |
    And confirmation is required

  Scenario: Upgrade subscription tier
    Given the user has Pro subscription
    When upgrading to Premium
    Then upgrade flow shows:
      | Element             | Value                           |
      | Current Plan        | Pro ($9.99/mo)                  |
      | New Plan            | Premium ($19.99/mo)             |
      | Price Increase      | +$10.00/month                   |
      | New Features        | List of Premium features        |
      | Effective           | Immediately                     |
    And prorated charge is calculated
    And upgrade is confirmed

  Scenario: Downgrade subscription tier
    Given the user has Premium subscription
    When downgrading to Pro
    Then downgrade flow shows:
      | Element             | Value                           |
      | Current Plan        | Premium ($19.99/mo)             |
      | New Plan            | Pro ($9.99/mo)                  |
      | Features Lost       | Premium-only features list      |
      | Effective           | End of current billing period   |
      | Credit              | None (use remaining time)       |
    And features remain until period ends

  Scenario: Update payment method for subscription
    Given the user needs to update payment
    When payment method is changed
    Then the update:
      | Validates new payment method            |
      | Sets as default for subscription        |
      | Does not charge immediately             |
      | Shows confirmation                      |
    And next billing uses new method

  Scenario: Pause subscription
    Given the user wants to pause temporarily
    When pause is requested
    Then pause options include:
      | Duration            | Options                         |
      | 1 Month             | Resume February 15              |
      | 2 Months            | Resume March 15                 |
      | 3 Months            | Resume April 15                 |
    And features are disabled during pause
    And billing is suspended
    And auto-resume is scheduled

  # ==================== SUBSCRIPTION RENEWAL ====================

  Scenario: Automatic subscription renewal
    Given the user has auto-renewal enabled
    When the billing date arrives
    Then renewal process:
      | Charges saved payment method            |
      | Extends subscription period             |
      | Sends renewal confirmation email        |
      | Updates next billing date               |
    And subscription continues uninterrupted

  Scenario: Send renewal reminder
    Given renewal is approaching
    When 7 days before billing
    Then reminder includes:
      | Element             | Content                         |
      | Renewal Date        | January 22, 2025                |
      | Amount              | $9.99                           |
      | Payment Method      | Visa ending 4242                |
      | Update Link         | Change payment or cancel        |
    And reminder is sent via email and in-app

  Scenario: Handle failed renewal
    Given automatic renewal fails
    When payment is declined
    Then the system:
      | Notifies user of failure                |
      | Provides grace period (3 days)          |
      | Allows payment method update            |
      | Retries automatically                   |
    And features continue during grace period

  Scenario: Grace period expiration
    Given grace period expires without payment
    When subscription lapses
    Then the system:
      | Downgrades to Free tier                 |
      | Disables premium features               |
      | Preserves user data                     |
      | Sends final notification                |
    And user can resubscribe anytime

  Scenario: Manual renewal for expired subscription
    Given subscription has expired
    When user chooses to renew
    Then renewal options show:
      | Option              | Details                         |
      | Same Plan           | Reactivate at current pricing   |
      | Different Plan      | Choose new tier                 |
      | Special Offer       | Win-back discount if available  |
    And renewal activates immediately

  Scenario: Handle price increase at renewal
    Given subscription price is increasing
    When renewal approaches
    Then notification includes:
      | Element             | Content                         |
      | Current Price       | $9.99/month                     |
      | New Price           | $12.99/month                    |
      | Effective Date      | Next billing cycle              |
      | Options             | Accept or cancel before renewal |
    And user can lock in old price annually

  # ==================== SUBSCRIPTION CANCELLATION ====================

  Scenario: Initiate subscription cancellation
    Given the user wants to cancel
    When cancellation is started
    Then cancellation flow includes:
      | Step                | Content                         |
      | Reason Survey       | Why are you cancelling?         |
      | Retention Offer     | Special offer to stay           |
      | Confirmation        | Access until period end         |
      | Final Confirm       | Confirm cancellation            |
    And cancellation can be abandoned

  Scenario: Present retention offer
    Given the user is cancelling
    When retention offer is presented
    Then offer may include:
      | Offer Type          | Details                         |
      | Discount            | 50% off for 3 months            |
      | Pause               | Pause instead of cancel         |
      | Downgrade           | Switch to cheaper plan          |
      | Feature Highlight   | Remind of unused features       |
    And user can accept or decline offer

  Scenario: Complete cancellation
    Given the user confirms cancellation
    When cancellation is processed
    Then confirmation shows:
      | Element             | Content                         |
      | Cancellation Date   | January 20, 2025                |
      | Access Until        | February 15, 2025               |
      | Refund Status       | No refund (use remaining time)  |
      | Resubscribe Option  | Can resubscribe anytime         |
    And confirmation email is sent

  Scenario: Immediate cancellation with refund
    Given the user requests immediate cancellation
    When refund eligibility is checked
    Then refund calculation:
      | Scenario            | Refund                          |
      | Within 24 hours     | Full refund                     |
      | Annual, mid-period  | Prorated refund                 |
      | Monthly, mid-period | No refund, access continues     |
    And refund is processed to original payment

  Scenario: Cancel during trial period
    Given the user is in trial period
    When cancellation is requested
    Then the system:
      | Cancels trial immediately               |
      | Does not charge payment method          |
      | Removes trial from account              |
      | Allows new trial in future (maybe)      |
    And no payment is processed

  Scenario: Reactivate cancelled subscription
    Given the user cancelled but period hasn't ended
    When reactivation is requested
    Then the system:
      | Reverses cancellation                   |
      | Restores auto-renewal                   |
      | Keeps same billing date                 |
      | Shows reactivation confirmation         |
    And subscription continues normally

  # ==================== TRIAL PERIOD ====================

  Scenario: Start free trial
    Given the user is eligible for trial
    When trial is activated
    Then trial begins:
      | Element             | Value                           |
      | Trial Duration      | 14 days                         |
      | Features            | Full Pro access                 |
      | Start Date          | January 20, 2025                |
      | End Date            | February 3, 2025                |
      | Payment Required    | Yes (charged after trial)       |
    And trial countdown is displayed

  Scenario: Check trial eligibility
    Given a user considers trial
    When eligibility is checked
    Then eligibility rules apply:
      | Condition           | Eligible                        |
      | New user            | Yes                             |
      | Previous subscriber | No                              |
      | Previous trial      | No (one trial per user)         |
      | Invited user        | Yes (special trial)             |
    And ineligibility reason is shown

  Scenario: Trial countdown display
    Given the user is in trial
    When trial status is shown
    Then countdown displays:
      | Element             | Value                           |
      | Days Remaining      | 7 days left                     |
      | Trial Ends          | February 3, 2025                |
      | After Trial         | $9.99/month                     |
      | Cancel Option       | Cancel before trial ends        |
    And countdown appears on key pages

  Scenario: Trial expiration warning
    Given trial is ending soon
    When 3 days remain
    Then warning is sent:
      | Channel             | Message                         |
      | Email               | "Your trial ends in 3 days"     |
      | In-App              | Banner with countdown           |
      | Push                | Reminder notification           |
    And options to subscribe or cancel

  Scenario: Trial converts to paid subscription
    Given trial period ends
    When user hasn't cancelled
    Then conversion occurs:
      | Charges payment method                  |
      | Activates paid subscription             |
      | Sends receipt email                     |
      | Continues all features                  |
    And billing cycle starts from trial end

  Scenario: Extend trial with special offer
    Given trial is about to end
    When extension offer is available
    Then offer shows:
      | Element             | Value                           |
      | Extension           | 7 additional days free          |
      | Condition           | Refer a friend                  |
      | One-Time            | Only one extension allowed      |
    And extension is applied if earned

  # ==================== SUBSCRIPTION BENEFITS ====================

  Scenario: Display subscription benefits
    Given the user has an active subscription
    When benefits are viewed
    Then Pro benefits show:
      | Benefit             | Description                     |
      | Advanced Stats      | Detailed player analytics       |
      | Trade Analyzer      | Evaluate trade fairness         |
      | No Ads              | Ad-free experience              |
      | Priority Support    | Faster response times           |
      | Exclusive Content   | Premium articles and insights   |
    And usage of each benefit is shown

  Scenario: Track benefit usage
    Given the user uses subscription features
    When usage is tracked
    Then statistics show:
      | Benefit             | Usage This Month                |
      | Trade Analyzer      | 12 trades analyzed              |
      | Advanced Reports    | 8 reports generated             |
      | Priority Support    | 2 tickets opened                |
    And value summary is provided

  Scenario: Unlock benefit on upgrade
    Given the user upgrades subscription
    When new tier activates
    Then new benefits:
      | Are immediately available               |
      | Show "New" badge temporarily            |
      | Include introduction/tutorial           |
      | Are highlighted in dashboard            |
    And user is guided to try new features

  Scenario: Benefit access after downgrade
    Given the user downgrades subscription
    When downgrade takes effect
    Then higher-tier benefits:
      | Are disabled                            |
      | Show lock icon                          |
      | Display "Upgrade to access"             |
      | Preserve historical data                |
    And previously generated content remains

  Scenario: Show benefit value summary
    Given end of billing period approaches
    When value summary is displayed
    Then summary includes:
      | Element             | Value                           |
      | Features Used       | 15 premium features             |
      | Time Saved          | Estimated 8 hours               |
      | Insights Gained     | 24 analysis reports             |
      | Value Delivered     | Worth $50+ in value             |
    And ROI is highlighted

  # ==================== SUBSCRIPTION BILLING ====================

  Scenario: View billing summary
    Given the user accesses billing
    When billing summary loads
    Then summary shows:
      | Field               | Value                           |
      | Current Plan        | Pro Monthly                     |
      | Amount              | $9.99                           |
      | Billing Date        | 15th of each month              |
      | Payment Method      | Visa ending 4242                |
      | Next Charge         | February 15, 2025               |
    And billing history link is available

  Scenario: View billing history
    Given the user views billing history
    When history loads
    Then charges are displayed:
      | Date       | Description           | Amount   | Status    |
      | 2025-01-15 | Pro Monthly           | $9.99    | Paid      |
      | 2024-12-15 | Pro Monthly           | $9.99    | Paid      |
      | 2024-11-15 | Pro Monthly           | $9.99    | Paid      |
    And receipts are downloadable

  Scenario: Apply account credit
    Given the user has account credit
    When billing is calculated
    Then credit is applied:
      | Subscription Cost   | $9.99                           |
      | Account Credit      | -$5.00                          |
      | Amount Charged      | $4.99                           |
    And credit balance is updated

  Scenario: Handle billing disputes
    Given the user disputes a charge
    When dispute is submitted
    Then dispute process:
      | Logs dispute reason                     |
      | Assigns to billing team                 |
      | Provides expected resolution time       |
      | Allows tracking of dispute status       |
    And subscription continues during review

  Scenario: Calculate prorated charges
    Given the user changes plans mid-cycle
    When proration is calculated
    Then charges show:
      | Element             | Value                           |
      | Days on Pro         | 10 days @ $0.33/day = $3.33     |
      | Days on Premium     | 20 days @ $0.67/day = $13.40    |
      | Total This Period   | $16.73                          |
    And breakdown is transparent

  Scenario: Handle payment method expiration
    Given payment method is expiring
    When expiration is detected
    Then notifications sent:
      | 30 days before      | "Card expiring soon"            |
      | 7 days before       | "Update payment to avoid lapse" |
      | On expiration       | "Payment method expired"        |
    And update link is included

  # ==================== SUBSCRIPTION NOTIFICATIONS ====================

  Scenario: Send welcome notification
    Given subscription is activated
    When welcome is triggered
    Then notification includes:
      | Element             | Content                         |
      | Welcome Message     | "Welcome to Pro!"               |
      | Getting Started     | Quick start guide link          |
      | New Features        | Highlights of unlocked features |
      | Support             | How to get help                 |
    And sent via email and in-app

  Scenario: Send billing notification
    Given billing is processed
    When charge completes
    Then notification includes:
      | Element             | Content                         |
      | Amount Charged      | $9.99                           |
      | Payment Method      | Visa ending 4242                |
      | Receipt Link        | Download receipt                |
      | Next Billing        | February 15, 2025               |
    And sent via email

  Scenario: Send renewal reminder
    Given renewal is approaching
    When reminder schedule triggers
    Then reminders are sent:
      | Days Before | Channel | Content                       |
      | 7           | Email   | Renewal reminder              |
      | 3           | Email   | Final reminder                |
      | 1           | Push    | "Renews tomorrow"             |
    And unsubscribe option is included

  Scenario: Send payment failure notification
    Given payment fails
    When failure is detected
    Then urgent notification includes:
      | Element             | Content                         |
      | Failure Reason      | Card declined                   |
      | Grace Period        | 3 days to update                |
      | Update Link         | Direct link to payment settings |
      | Consequences        | What happens if not resolved    |
    And multiple channels are used

  Scenario: Send cancellation confirmation
    Given subscription is cancelled
    When cancellation completes
    Then notification includes:
      | Element             | Content                         |
      | Cancellation Date   | January 20, 2025                |
      | Access Until        | February 15, 2025               |
      | Resubscribe Link    | Easy reactivation               |
      | Feedback Request    | Optional survey                 |
    And we're sorry to see you go message

  Scenario: Configure notification preferences
    Given the user manages preferences
    When subscription notifications are configured
    Then options include:
      | Notification Type       | Email | Push | In-App |
      | Billing Receipts        | On    | Off  | On     |
      | Renewal Reminders       | On    | Off  | On     |
      | Payment Failures        | On    | On   | On     |
      | Feature Updates         | On    | Off  | On     |
      | Special Offers          | Off   | Off  | On     |
    And preferences are saved

  # ==================== SUBSCRIPTION ANALYTICS ====================

  Scenario: View subscription dashboard (Admin)
    Given an admin accesses subscription analytics
    When dashboard loads
    Then metrics include:
      | Metric                  | Value           |
      | Total Subscribers       | 15,234          |
      | Monthly Recurring Revenue| $125,432       |
      | Churn Rate              | 3.2%            |
      | Trial Conversion Rate   | 45%             |
      | Average Revenue/User    | $8.23           |
    And metrics are real-time

  Scenario: Analyze subscription growth
    Given historical data exists
    When growth analytics are viewed
    Then trends show:
      | Period      | New Subs | Cancelled | Net Growth |
      | Jan 2025    | 1,250    | 340       | +910       |
      | Dec 2024    | 1,100    | 380       | +720       |
      | Nov 2024    | 980      | 320       | +660       |
    And growth rate is calculated
    And projections are provided

  Scenario: Track tier distribution
    Given subscribers exist across tiers
    When distribution is analyzed
    Then breakdown shows:
      | Tier        | Subscribers | Percentage | Revenue    |
      | Pro         | 8,500       | 56%        | $84,915    |
      | Premium     | 4,200       | 28%        | $83,958    |
      | Ultimate    | 2,534       | 16%        | $76,020    |
    And tier migration trends are shown

  Scenario: Analyze churn patterns
    Given cancellation data exists
    When churn analysis runs
    Then insights include:
      | Cancellation Reason     | Percentage |
      | Too Expensive           | 35%        |
      | Not Using Features      | 28%        |
      | Found Alternative       | 18%        |
      | Technical Issues        | 12%        |
      | Other                   | 7%         |
    And at-risk subscribers are identified

  Scenario: Track trial conversion funnel
    Given trial data is available
    When conversion funnel is analyzed
    Then funnel shows:
      | Stage                   | Count  | Rate    |
      | Trial Started           | 5,000  | 100%    |
      | Active During Trial     | 4,200  | 84%     |
      | Reached Trial End       | 3,800  | 76%     |
      | Converted to Paid       | 2,250  | 45%     |
    And drop-off points are identified

  Scenario: Analyze revenue metrics
    Given billing data exists
    When revenue analytics are viewed
    Then metrics include:
      | Metric                  | Value           |
      | MRR                     | $125,432        |
      | ARR                     | $1,505,184      |
      | Average Order Value     | $12.45          |
      | Lifetime Value (LTV)    | $145.50         |
      | Customer Acquisition Cost| $25.00         |
    And LTV:CAC ratio is calculated

  # ==================== SUBSCRIPTION FEATURES ACCESS ====================

  Scenario: Gate feature by subscription tier
    Given a feature requires Premium tier
    When a Pro user accesses it
    Then access control:
      | Shows feature preview                   |
      | Displays upgrade prompt                 |
      | Explains Premium benefits               |
      | Provides upgrade button                 |
    And feature is not accessible

  Scenario: Handle subscription lapse during active use
    Given user is using premium feature
    When subscription expires
    Then graceful degradation:
      | Current session continues               |
      | Shows subscription expired notice       |
      | Saves any in-progress work              |
      | Blocks new premium actions              |
    And user is prompted to renew

  # ==================== ERROR HANDLING ====================

  Scenario: Handle subscription service unavailable
    Given subscription service is down
    When subscription action is attempted
    Then the system:
      | Shows service unavailable message       |
      | Preserves current subscription state    |
      | Offers to retry later                   |
      | Provides support contact                |
    And incident is logged

  Scenario: Handle invalid subscription state
    Given subscription data is inconsistent
    When inconsistency is detected
    Then the system:
      | Logs error for investigation            |
      | Shows user-friendly error               |
      | Defaults to safe state (current tier)   |
      | Alerts support team                     |
    And user data is protected
