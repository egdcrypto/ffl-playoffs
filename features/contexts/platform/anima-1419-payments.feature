@ANIMA-1419 @backend @priority_1 @payments
Feature: Payments System
  As a fantasy football playoffs platform user
  I want to manage payments, subscriptions, and financial transactions
  So that I can participate in paid leagues and access premium features

  Background:
    Given the payment system is enabled
    And secure payment processing is configured
    And the user is authenticated

  # ==================== PAYMENT METHODS ====================

  Scenario: View saved payment methods
    Given the user has saved payment methods
    When the user accesses payment methods
    Then saved methods are displayed:
      | Type        | Last 4   | Expiry  | Default | Status   |
      | Visa        | 4242     | 12/26   | Yes     | Active   |
      | Mastercard  | 5555     | 08/25   | No      | Active   |
      | PayPal      | j***@e.. | -       | No      | Active   |
    And card logos are displayed
    And default payment method is highlighted

  Scenario: Add credit card payment method
    Given the user wants to add a new card
    When the payment form loads
    Then the user can enter:
      | Field               | Validation                      |
      | Card Number         | Valid card number (Luhn check)  |
      | Expiration Date     | MM/YY, not expired              |
      | CVV                 | 3-4 digits                      |
      | Cardholder Name     | Required                        |
      | Billing Address     | Required fields                 |
    And card type is auto-detected
    And form uses secure tokenization

  Scenario: Add PayPal payment method
    Given the user chooses PayPal
    When the user clicks "Connect PayPal"
    Then the system:
      | Redirects to PayPal login               |
      | Returns with authorization token        |
      | Links PayPal account to user            |
      | Shows connected PayPal email            |
    And PayPal can be set as default

  Scenario: Add Apple Pay / Google Pay
    Given the user's device supports digital wallet
    When wallet payment options are shown
    Then available options include:
      | Wallet        | Availability                    |
      | Apple Pay     | iOS/Safari only                 |
      | Google Pay    | Chrome/Android                  |
    And wallet setup uses native prompts
    And stored cards from wallet are available

  Scenario: Set default payment method
    Given the user has multiple payment methods
    When the user sets a new default
    Then the system:
      | Updates default flag                    |
      | Shows confirmation                      |
      | Uses this method for future charges     |
    And previous default is unmarked

  Scenario: Remove payment method
    Given the user wants to remove a payment method
    When the user clicks "Remove"
    Then confirmation is required
    And if confirmed:
      | Payment method is deleted               |
      | Active subscriptions show warning       |
      | Alternative method required if only one |
    And removal is logged for audit

  Scenario: Update payment method
    Given the user needs to update card info
    When the update form loads
    Then the user can modify:
      | Field               | Editable                        |
      | Expiration Date     | Yes                             |
      | Billing Address     | Yes                             |
      | Card Number         | No (add new instead)            |
    And changes are saved securely

  # ==================== SUBSCRIPTION PLANS ====================

  Scenario: View available subscription plans
    Given the user accesses subscription options
    When plans are displayed
    Then available plans show:
      | Plan        | Price    | Billing   | Features                     |
      | Free        | $0       | -         | Basic features               |
      | Pro         | $9.99    | Monthly   | Advanced stats, no ads       |
      | Pro Annual  | $79.99   | Yearly    | Save 33%, all Pro features   |
      | Premium     | $19.99   | Monthly   | All features, priority support|
    And current plan is highlighted
    And feature comparison is available

  Scenario: Subscribe to paid plan
    Given the user selects "Pro" subscription
    When the subscription checkout loads
    Then the process includes:
      | Step                | Content                         |
      | Plan Summary        | Features and price              |
      | Payment Method      | Select or add new               |
      | Billing Info        | Address confirmation            |
      | Terms Agreement     | Subscription terms checkbox     |
      | Confirm             | Submit subscription             |
    And trial period is shown if applicable

  Scenario: Upgrade subscription plan
    Given the user has "Pro" subscription
    When the user chooses to upgrade to "Premium"
    Then upgrade flow shows:
      | Element             | Content                         |
      | Price Difference    | $10.00/month more               |
      | New Features        | Additional features list        |
      | Proration           | Credit for remaining Pro time   |
      | Effective Date      | Immediate or next billing       |
    And upgrade is confirmed
    And new features activate immediately

  Scenario: Downgrade subscription plan
    Given the user wants to downgrade
    When downgrade is initiated
    Then the system shows:
      | Element             | Content                         |
      | Features Lost       | What will no longer be available|
      | Effective Date      | End of current billing period   |
      | Refund Status       | No refund for partial period    |
      | Confirmation        | Acknowledge downgrade terms     |
    And downgrade takes effect at period end

  Scenario: Cancel subscription
    Given the user wants to cancel subscription
    When cancellation is initiated
    Then the flow includes:
      | Step                | Content                         |
      | Reason Survey       | Optional cancellation reason    |
      | Retention Offer     | Discount or pause option        |
      | Confirm Cancel      | Final confirmation              |
      | Access Until        | End of paid period date         |
    And subscription remains active until period ends
    And reactivation option is available

  Scenario: View subscription status
    Given the user has an active subscription
    When subscription details are viewed
    Then status shows:
      | Element             | Value                           |
      | Current Plan        | Pro Monthly                     |
      | Status              | Active                          |
      | Next Billing Date   | February 15, 2025               |
      | Next Charge         | $9.99                           |
      | Member Since        | January 15, 2024                |
      | Payment Method      | Visa ending 4242                |
    And billing history link is available

  # ==================== CHECKOUT FLOW ====================

  Scenario: Complete single purchase checkout
    Given the user is purchasing league entry ($25)
    When checkout begins
    Then the checkout flow includes:
      | Step                | Content                         |
      | Order Summary       | League name, entry fee          |
      | Payment Method      | Select payment option           |
      | Review Order        | Total with any fees             |
      | Confirm Payment     | Submit payment                  |
    And order confirmation is displayed

  Scenario: Apply taxes to checkout
    Given the user's location requires sales tax
    When checkout calculates totals
    Then tax is applied:
      | Line Item           | Amount                          |
      | Subtotal            | $25.00                          |
      | Tax (8.25%)         | $2.06                           |
      | Total               | $27.06                          |
    And tax calculation uses billing address
    And tax exempt status is honored if applicable

  Scenario: Handle payment processing
    Given the user confirms payment
    When payment is submitted
    Then processing includes:
      | Step                | Status                          |
      | Validate Card       | Check with payment processor    |
      | Authorize Amount    | Hold funds                      |
      | Capture Payment     | Complete transaction            |
      | Generate Receipt    | Create payment record           |
    And success confirmation is shown
    And email receipt is sent

  Scenario: Handle payment failure
    Given the user submits payment
    When payment is declined
    Then the system displays:
      | Element             | Content                         |
      | Error Message       | "Payment declined"              |
      | Reason              | Insufficient funds, expired, etc|
      | Options             | Try again, use different method |
    And cart/order is preserved
    And user can retry immediately

  Scenario: Cart checkout with multiple items
    Given the user has multiple items in cart
    When checkout begins
    Then cart shows:
      | Item                | Price     | Quantity  | Subtotal  |
      | Pro Subscription    | $9.99     | 1         | $9.99     |
      | League Entry        | $50.00    | 1         | $50.00    |
      | Total               | -         | -         | $59.99    |
    And items can be removed before payment
    And quantity adjustments are available

  Scenario: Express checkout
    Given the user has saved payment method
    When express checkout is used
    Then the process is streamlined:
      | Single confirmation page                |
      | Pre-selected default payment method     |
      | One-click purchase option               |
    And full checkout remains available
    And express checkout can be disabled

  # ==================== BILLING HISTORY ====================

  Scenario: View billing history
    Given the user accesses billing history
    When history loads
    Then transactions are displayed:
      | Date       | Description           | Amount   | Status    |
      | 2025-01-15 | Pro Subscription      | $9.99    | Paid      |
      | 2025-01-10 | League Entry - FFL    | $50.00   | Paid      |
      | 2024-12-15 | Pro Subscription      | $9.99    | Paid      |
      | 2024-12-01 | Refund - League Cancel| -$25.00  | Refunded  |
    And transactions are sortable and filterable
    And date range selection is available

  Scenario: View transaction details
    Given the user selects a transaction
    When details are displayed
    Then information includes:
      | Field               | Value                           |
      | Transaction ID      | TXN-123456789                   |
      | Date                | January 15, 2025 3:45 PM        |
      | Description         | Pro Monthly Subscription        |
      | Amount              | $9.99                           |
      | Payment Method      | Visa ending 4242                |
      | Status              | Completed                       |
    And receipt can be downloaded

  Scenario: Download receipt/invoice
    Given the user needs a receipt
    When download is requested
    Then receipt options include:
      | Format              | Content                         |
      | PDF                 | Formatted invoice               |
      | Email               | Send to registered email        |
      | Print               | Printer-friendly version        |
    And receipt includes all tax information
    And business expense details are included

  Scenario: View upcoming charges
    Given the user has recurring payments
    When upcoming charges are viewed
    Then the display shows:
      | Date       | Description           | Amount   | Status    |
      | 2025-02-15 | Pro Subscription      | $9.99    | Scheduled |
      | 2025-02-01 | League Dues - Dynasty | $10.00   | Scheduled |
    And charges can be cancelled before date
    And payment method update is available

  Scenario: Export billing history
    Given the user needs billing records
    When export is requested
    Then export options include:
      | Format              | Content                         |
      | CSV                 | Spreadsheet-compatible          |
      | PDF                 | Formatted report                |
    And date range can be specified
    And export includes all transaction details

  # ==================== REFUNDS ====================

  Scenario: Request refund for eligible purchase
    Given the user has a refundable purchase
    When refund is requested
    Then the refund form shows:
      | Field               | Content                         |
      | Original Purchase   | League Entry - $50.00           |
      | Refund Reason       | Dropdown selection              |
      | Additional Details  | Optional text                   |
      | Refund Amount       | $50.00 (full refund)            |
    And refund policy is displayed
    And submission confirms request

  Scenario: Process automatic refund
    Given a league is cancelled by commissioner
    When refund eligibility is checked
    Then automatic refund is processed:
      | Condition           | Action                          |
      | League not started  | Full refund                     |
      | Partial season      | Prorated refund                 |
      | Season complete     | No refund                       |
    And refund is credited to original payment method
    And notification is sent

  Scenario: View refund status
    Given the user has requested a refund
    When refund status is checked
    Then status shows:
      | Field               | Value                           |
      | Refund ID           | REF-987654                      |
      | Amount              | $50.00                          |
      | Status              | Processing                      |
      | Requested Date      | January 20, 2025                |
      | Expected Date       | 3-5 business days               |
      | Method              | Original payment method         |
    And status updates are sent via email

  Scenario: Handle partial refund
    Given a partial refund is warranted
    When partial refund is processed
    Then the refund shows:
      | Original Amount     | $100.00                         |
      | Refund Amount       | $75.00                          |
      | Reason              | Partial season participation    |
      | Retained            | $25.00 platform fee             |
    And breakdown is clearly explained

  Scenario: Refund denied
    Given refund request doesn't meet policy
    When denial is processed
    Then the user sees:
      | Element             | Content                         |
      | Status              | Denied                          |
      | Reason              | Outside refund window           |
      | Policy Reference    | Link to refund policy           |
      | Appeal Option       | Contact support                 |
    And denial reason is documented

  # ==================== LEAGUE DUES ====================

  Scenario: Set up league dues
    Given a commissioner creates a paid league
    When league dues are configured
    Then configuration options include:
      | Setting             | Options                         |
      | Entry Fee           | Custom amount ($1-$1000)        |
      | Payment Deadline    | Date picker                     |
      | Allow Late Payment  | Yes/No with late fee option     |
      | Collection Method   | Platform or external            |
    And dues are required before draft

  Scenario: Pay league dues
    Given the user joins a paid league
    When payment is due
    Then the payment flow shows:
      | Element             | Content                         |
      | League Name         | FFL Championship                |
      | Entry Fee           | $50.00                          |
      | Platform Fee        | $2.50 (5%)                      |
      | Total Due           | $52.50                          |
      | Due Date            | January 25, 2025                |
    And payment completes league join

  Scenario: Track league payment status
    Given a commissioner views payment status
    When the status page loads
    Then payments are tracked:
      | Player      | Amount   | Status    | Paid Date   |
      | john_doe    | $50.00   | Paid      | Jan 15      |
      | jane_doe    | $50.00   | Paid      | Jan 16      |
      | bob_player  | $50.00   | Pending   | -           |
    And reminders can be sent to unpaid
    And total collected is displayed

  Scenario: Send payment reminder
    Given players have unpaid dues
    When commissioner sends reminder
    Then the system:
      | Sends email to unpaid players           |
      | Shows in-app notification               |
      | Includes payment link                   |
      | Shows due date and consequences         |
    And reminder history is logged

  Scenario: Handle late payment
    Given payment deadline has passed
    When late payment is attempted
    Then late payment rules apply:
      | Scenario            | Action                          |
      | Late fee enabled    | Add late fee to amount          |
      | Late fee disabled   | Accept at original amount       |
      | Payment blocked     | Reject, contact commissioner    |
    And commissioner is notified

  Scenario: Collect league dues externally
    Given commissioner collects dues outside platform
    When manual payment tracking is used
    Then commissioner can:
      | Mark players as paid manually           |
      | Record payment method/date              |
      | Track partial payments                  |
      | Generate payment report                 |
    And platform fee may still apply

  # ==================== PRIZE PAYOUTS ====================

  Scenario: Configure prize structure
    Given a commissioner sets up prizes
    When prize configuration loads
    Then options include:
      | Setting             | Options                         |
      | Prize Pool Source   | Entry fees or custom            |
      | Distribution        | Winner-take-all or split        |
      | Payout Positions    | 1st, 2nd, 3rd, etc.             |
      | Percentage Split    | Customizable per position       |
    And total must equal 100%

  Scenario: View prize pool
    Given a league has collected dues
    When prize pool is viewed
    Then the display shows:
      | Element             | Value                           |
      | Total Entry Fees    | $600.00 (12 x $50)              |
      | Platform Fees       | -$30.00 (5%)                    |
      | Prize Pool          | $570.00                         |
      | 1st Place (60%)     | $342.00                         |
      | 2nd Place (30%)     | $171.00                         |
      | 3rd Place (10%)     | $57.00                          |
    And payout amounts update as entries come in

  Scenario: Process prize payout
    Given the season has ended
    When payouts are processed
    Then payout flow includes:
      | Step                | Action                          |
      | Verify Winners      | Confirm final standings         |
      | Calculate Amounts   | Apply prize structure           |
      | Initiate Transfers  | Send to winner payment methods  |
      | Confirm Completion  | Record payout status            |
    And winners receive notification

  Scenario: Claim prize winnings
    Given the user won prize money
    When claiming winnings
    Then the claim process shows:
      | Step                | Requirement                     |
      | Verify Identity     | Confirm account ownership       |
      | Select Payout Method| Bank, PayPal, check             |
      | Tax Information     | W-9 if over $600                |
      | Confirm             | Initiate payout                 |
    And payout timing is displayed

  Scenario: View payout status
    Given a payout is in process
    When status is checked
    Then payout status shows:
      | Field               | Value                           |
      | Amount              | $342.00                         |
      | Method              | Bank Transfer                   |
      | Status              | Processing                      |
      | Initiated           | January 22, 2025                |
      | Expected Arrival    | January 25-27, 2025             |
    And tracking updates are provided

  Scenario: Handle payout failure
    Given a payout fails
    When failure is detected
    Then the system:
      | Notifies winner of failure              |
      | Provides failure reason                 |
      | Allows payout method update             |
      | Retries after correction                |
    And support is available for issues

  # ==================== PAYMENT SECURITY ====================

  Scenario: Secure payment data handling
    Given payment information is entered
    When data is processed
    Then security measures include:
      | Measure             | Implementation                  |
      | Encryption          | TLS 1.3 in transit              |
      | Tokenization        | Card data tokenized             |
      | PCI Compliance      | Level 1 PCI DSS                 |
      | No Storage          | Raw card data not stored        |
    And security badges are displayed

  Scenario: Fraud detection
    Given a payment is submitted
    When fraud checks run
    Then detection includes:
      | Check               | Action                          |
      | Velocity Check      | Flag rapid transactions         |
      | Address Verification| Match billing address           |
      | CVV Verification    | Validate security code          |
      | Device Fingerprint  | Check device patterns           |
    And suspicious activity triggers review

  Scenario: Require authentication for payments
    Given strong authentication is enabled
    When payment is initiated
    Then authentication includes:
      | Method              | When Required                   |
      | 3D Secure           | Card payments                   |
      | Password            | Large transactions              |
      | 2FA                 | New payment methods             |
    And authentication failure blocks payment

  Scenario: Handle suspicious activity
    Given suspicious payment activity is detected
    When security review triggers
    Then the system:
      | Blocks the transaction                  |
      | Notifies the user                       |
      | Requires identity verification          |
      | Logs for security team review           |
    And false positives can be appealed

  Scenario: Payment method verification
    Given a new payment method is added
    When verification is required
    Then verification includes:
      | Method              | Verification Type               |
      | Credit Card         | Small auth charge ($1)          |
      | Bank Account        | Micro-deposits verification     |
      | PayPal              | OAuth authentication            |
    And verification confirms ownership

  # ==================== PROMO CODES ====================

  Scenario: Apply promo code at checkout
    Given the user has a promo code
    When the code is entered
    Then validation occurs:
      | Code Status         | Result                          |
      | Valid               | Discount applied, new total     |
      | Expired             | "Code has expired"              |
      | Invalid             | "Invalid promo code"            |
      | Already Used        | "Code already redeemed"         |
    And discount is shown in order summary

  Scenario: Promo code types
    Given various promo codes exist
    When codes are applied
    Then discount types include:
      | Code Type           | Example           | Discount        |
      | Percentage Off      | SAVE20            | 20% off         |
      | Fixed Amount        | 10OFF             | $10 off         |
      | Free Trial          | FREETRIAL         | 30 days free    |
      | First Purchase      | WELCOME           | 50% first month |
    And restrictions are displayed

  Scenario: Promo code restrictions
    Given a promo code has restrictions
    When restrictions are checked
    Then limitations include:
      | Restriction         | Example                         |
      | Minimum Purchase    | Min $25 order                   |
      | Specific Products   | Subscriptions only              |
      | New Users Only      | First-time customers            |
      | Expiration Date     | Valid until Feb 28              |
      | Usage Limit         | One per customer                |
    And ineligible items are indicated

  Scenario: Generate referral codes
    Given the user wants to refer friends
    When referral code is generated
    Then the code provides:
      | Benefit             | Value                           |
      | Referrer Reward     | $10 credit                      |
      | Referee Discount    | 20% off first purchase          |
      | Code Format         | FRIEND-JOHN123                  |
      | Sharing Options     | Email, social, copy link        |
    And referral tracking is enabled

  Scenario: Redeem referral reward
    Given a referral signs up and pays
    When referral is validated
    Then rewards are credited:
      | Recipient           | Reward                          |
      | Referrer            | $10 account credit              |
      | Referee             | Discount already applied        |
    And notification is sent to referrer
    And credit is visible in account

  # ==================== PAYMENT NOTIFICATIONS ====================

  Scenario: Payment confirmation notification
    Given a payment is successful
    When confirmation is sent
    Then notification includes:
      | Channel             | Content                         |
      | Email               | Full receipt with details       |
      | In-App              | Payment confirmed banner        |
      | Push (if enabled)   | Brief confirmation              |
    And notification is sent immediately

  Scenario: Payment failure notification
    Given a payment fails
    When failure notification is sent
    Then notification includes:
      | Element             | Content                         |
      | Reason              | Why payment failed              |
      | Action Required     | Update payment method           |
      | Deadline            | When to resolve by              |
      | Support Link        | Help with payment issues        |
    And urgency is indicated

  Scenario: Upcoming payment reminder
    Given a subscription renewal is upcoming
    When reminder is sent (3 days before)
    Then notification includes:
      | Element             | Content                         |
      | Renewal Date        | January 25, 2025                |
      | Amount              | $9.99                           |
      | Payment Method      | Visa ending 4242                |
      | Manage Link         | Update payment or cancel        |
    And reminder timing is configurable

  Scenario: Payment method expiring notification
    Given a card is expiring soon
    When expiration notice is sent (30 days before)
    Then notification includes:
      | Element             | Content                         |
      | Card Details        | Visa ending 4242 expires 02/25  |
      | Impact              | Subscriptions may fail          |
      | Update Link         | Update payment method           |
    And follow-up reminders are sent

  Scenario: Refund processed notification
    Given a refund is completed
    When notification is sent
    Then notification includes:
      | Element             | Content                         |
      | Refund Amount       | $50.00                          |
      | Original Purchase   | League Entry - FFL              |
      | Method              | Credited to Visa ending 4242    |
      | Timeline            | 3-5 business days               |
    And confirmation number is provided

  Scenario: Configure payment notifications
    Given the user manages notification preferences
    When payment notifications are configured
    Then options include:
      | Notification Type       | Email | Push | In-App |
      | Payment Confirmations   | On    | On   | On     |
      | Payment Failures        | On    | On   | On     |
      | Renewal Reminders       | On    | Off  | On     |
      | Expiration Warnings     | On    | Off  | On     |
    And preferences are saved per channel

  # ==================== PAYMENT DISPUTES ====================

  Scenario: Report payment dispute
    Given the user has an issue with a charge
    When dispute is initiated
    Then dispute form includes:
      | Field               | Content                         |
      | Transaction         | Select from history             |
      | Dispute Type        | Unauthorized, duplicate, etc.   |
      | Description         | Details of the issue            |
      | Evidence            | Upload supporting documents     |
    And dispute is submitted for review

  Scenario: Track dispute status
    Given a dispute is in progress
    When status is checked
    Then dispute status shows:
      | Field               | Value                           |
      | Dispute ID          | DSP-123456                      |
      | Status              | Under Review                    |
      | Filed Date          | January 20, 2025                |
      | Expected Resolution | 7-10 business days              |
    And updates are sent via email

  # ==================== ERROR HANDLING ====================

  Scenario: Handle payment gateway unavailable
    Given the payment gateway is down
    When payment is attempted
    Then the system:
      | Shows service unavailable message       |
      | Saves cart/order for later              |
      | Offers to notify when available         |
      | Provides alternative payment options    |
    And incident is logged

  Scenario: Handle timeout during payment
    Given payment processing times out
    When timeout occurs
    Then the system:
      | Shows timeout message                   |
      | Checks if payment completed             |
      | Prevents duplicate charges              |
      | Provides clear next steps               |
    And transaction status is verified
