@payments @anima-1368
Feature: Payments
  As a fantasy football league participant
  I want to manage league payments and financial transactions
  So that I can handle dues, prizes, and financial obligations

  Background:
    Given I am a logged-in user
    And the payment system is available
    And I am part of a league with financial transactions

  # ============================================================================
  # LEAGUE DUES
  # ============================================================================

  @happy-path @league-dues
  Scenario: Collect league dues from members
    Given I am a league commissioner
    When I set up dues collection
    Then I should configure the dues amount
    And members should be notified to pay

  @happy-path @league-dues
  Scenario: Pay league dues
    Given I owe league dues
    When I pay my dues
    Then my payment should be processed
    And my dues status should be marked as paid

  @happy-path @league-dues
  Scenario: Track payment status
    Given I am a league commissioner
    When I view payment tracking
    Then I should see who has paid
    And I should see who still owes dues

  @happy-path @league-dues
  Scenario: Set dues due date
    Given I am a league commissioner
    When I set a dues due date
    Then the due date should be recorded
    And reminders should be scheduled

  @happy-path @league-dues
  Scenario: Send dues reminders
    Given dues are outstanding
    When I send payment reminders
    Then members with unpaid dues should be notified
    And reminder history should be logged

  @happy-path @league-dues
  Scenario: Apply late fees
    Given the dues due date has passed
    When late fees are configured
    Then late fees should be applied to unpaid dues
    And members should be notified of late fees

  @commissioner @league-dues
  Scenario: Mark dues as paid manually
    Given I am a league commissioner
    When I mark a member's dues as paid
    Then their status should be updated
    And a record should be created

  @error @league-dues
  Scenario: Handle dues payment failure
    Given I am paying my dues
    When the payment fails
    Then I should see an error message
    And I should be able to retry

  # ============================================================================
  # PRIZE PAYOUTS
  # ============================================================================

  @happy-path @prize-payouts
  Scenario: Configure winner payouts
    Given I am a league commissioner
    When I configure prize payouts
    Then I should set payout amounts for each place
    And the payout structure should be saved

  @happy-path @prize-payouts
  Scenario: Distribute payouts to winners
    Given the season has ended
    When I distribute payouts
    Then winners should receive their prizes
    And payout records should be created

  @happy-path @prize-payouts
  Scenario: Configure payout schedule
    Given I am setting up payouts
    When I set a payout schedule
    Then payouts should follow the schedule
    And recipients should be notified

  @happy-path @prize-payouts
  Scenario: Select payout method
    Given I am receiving a payout
    When I select my preferred payout method
    Then the payout should be sent to that method
    And I should receive confirmation

  @happy-path @prize-payouts
  Scenario: View payout breakdown
    Given payouts are configured
    When I view payout breakdown
    Then I should see how prizes are distributed
    And I should see my potential payout

  @happy-path @prize-payouts
  Scenario: Process weekly payouts
    Given the league has weekly prizes
    When a week ends
    Then weekly payouts should be processed
    And weekly winners should be paid

  @commissioner @prize-payouts
  Scenario: Manually trigger payout
    Given I am a league commissioner
    When I manually trigger a payout
    Then the payout should be processed
    And recipients should be notified

  # ============================================================================
  # PAYMENT METHODS
  # ============================================================================

  @happy-path @payment-methods
  Scenario: Add credit card
    Given I am adding a payment method
    When I add a credit card
    Then the card should be securely stored
    And I should see the last 4 digits

  @happy-path @payment-methods
  Scenario: Link PayPal account
    Given I am adding a payment method
    When I link my PayPal account
    Then PayPal should be connected
    And I can pay with PayPal

  @happy-path @payment-methods
  Scenario: Link Venmo account
    Given I am adding a payment method
    When I link my Venmo account
    Then Venmo should be connected
    And I can receive payments via Venmo

  @happy-path @payment-methods
  Scenario: Add bank transfer details
    Given I am adding a payment method
    When I add bank transfer information
    Then my bank details should be securely stored
    And I can receive direct deposits

  @happy-path @payment-methods
  Scenario: Connect digital wallet
    Given I am adding a payment method
    When I connect a digital wallet
    Then the wallet should be linked
    And I can use it for transactions

  @happy-path @payment-methods
  Scenario: Set default payment method
    Given I have multiple payment methods
    When I set a default method
    Then that method should be used by default
    And my preference should be saved

  @happy-path @payment-methods
  Scenario: Remove payment method
    Given I have a saved payment method
    When I remove the payment method
    Then it should be deleted
    And I should see confirmation

  @error @payment-methods
  Scenario: Handle invalid card details
    Given I am adding a credit card
    When I enter invalid card details
    Then I should see a validation error
    And the card should not be saved

  # ============================================================================
  # PAYMENT PROCESSING
  # ============================================================================

  @happy-path @payment-processing
  Scenario: Complete secure checkout
    Given I am making a payment
    When I complete checkout
    Then the payment should be processed securely
    And I should see a confirmation page

  @happy-path @payment-processing
  Scenario: Receive payment confirmation
    Given I made a payment
    Then I should receive payment confirmation
    And confirmation should include transaction details

  @happy-path @payment-processing
  Scenario: Generate payment receipt
    Given a payment was successful
    When I request a receipt
    Then a receipt should be generated
    And the receipt should be downloadable

  @happy-path @payment-processing
  Scenario: Request refund
    Given I made a payment
    When I request a refund
    Then my refund request should be submitted
    And I should see the request status

  @happy-path @payment-processing
  Scenario: Process refund
    Given a refund is approved
    When the refund is processed
    Then the amount should be returned
    And I should receive confirmation

  @happy-path @payment-processing
  Scenario: View pending transactions
    Given I have pending transactions
    When I view pending transactions
    Then I should see all pending payments
    And I should see their status

  @error @payment-processing
  Scenario: Handle payment timeout
    Given I am processing a payment
    When the transaction times out
    Then I should see an error message
    And I should be able to retry

  @error @payment-processing
  Scenario: Handle insufficient funds
    Given I am making a payment
    When there are insufficient funds
    Then I should see an error message
    And I should be prompted to use another method

  # ============================================================================
  # PAYMENT HISTORY
  # ============================================================================

  @happy-path @payment-history
  Scenario: View transaction log
    Given I have made payments
    When I view my transaction log
    Then I should see all transactions
    And transactions should be chronological

  @happy-path @payment-history
  Scenario: View payment receipts
    Given I have payment receipts
    When I view receipts
    Then I should see all my receipts
    And I should be able to download them

  @happy-path @payment-history
  Scenario: Export payment history
    Given I have payment history
    When I export my history
    Then I should receive a downloadable file
    And all transactions should be included

  @happy-path @payment-history
  Scenario: Generate tax documents
    Given I have taxable transactions
    When I request tax documents
    Then tax documents should be generated
    And they should be available for download

  @happy-path @payment-history
  Scenario: Filter payment history
    Given I am viewing payment history
    When I filter by date range
    Then I should see filtered transactions
    And the filter should be clearable

  @happy-path @payment-history
  Scenario: Search payment history
    Given I am viewing payment history
    When I search for a specific transaction
    Then matching transactions should appear
    And search should be fast

  # ============================================================================
  # SUBSCRIPTION MANAGEMENT
  # ============================================================================

  @happy-path @subscription
  Scenario: Subscribe to premium features
    Given premium features are available
    When I subscribe to premium
    Then my subscription should be activated
    And I should have access to premium features

  @happy-path @subscription
  Scenario: Enable auto-renewal
    Given I have a subscription
    When I enable auto-renewal
    Then my subscription should renew automatically
    And I should be charged on renewal date

  @happy-path @subscription
  Scenario: Disable auto-renewal
    Given auto-renewal is enabled
    When I disable auto-renewal
    Then auto-renewal should be cancelled
    And my subscription will end at period end

  @happy-path @subscription
  Scenario: Upgrade subscription
    Given I have a basic subscription
    When I upgrade to a higher tier
    Then my subscription should be upgraded
    And I should have new features immediately

  @happy-path @subscription
  Scenario: Downgrade subscription
    Given I have a premium subscription
    When I downgrade to a lower tier
    Then the downgrade should be scheduled
    And it should take effect at period end

  @happy-path @subscription
  Scenario: Cancel subscription
    Given I have an active subscription
    When I cancel my subscription
    Then cancellation should be confirmed
    And I should retain access until period end

  @happy-path @subscription
  Scenario: View subscription status
    Given I have a subscription
    When I view my subscription
    Then I should see subscription details
    And I should see renewal date

  # ============================================================================
  # BUY-IN MANAGEMENT
  # ============================================================================

  @happy-path @buy-in
  Scenario: Set league entry fee
    Given I am a league commissioner
    When I set the entry fee
    Then the buy-in amount should be saved
    And members should be notified

  @happy-path @buy-in
  Scenario: Pay league buy-in
    Given I need to pay a buy-in
    When I pay the entry fee
    Then my payment should be processed
    And I should be confirmed in the league

  @happy-path @buy-in
  Scenario: Manage multi-league buy-ins
    Given I am in multiple paid leagues
    When I view my buy-ins
    Then I should see all buy-in amounts
    And I should see total commitment

  @happy-path @buy-in
  Scenario: Hold funds in escrow
    Given buy-ins are being collected
    Then funds should be held in escrow
    And escrow balance should be visible

  @happy-path @buy-in
  Scenario: Provide payout guarantee
    Given the league has a payout guarantee
    Then guaranteed payouts should be displayed
    And members should have confidence in payouts

  @happy-path @buy-in
  Scenario: Refund buy-in for withdrawn team
    Given a team withdraws before the season
    When a refund is processed
    Then the buy-in should be refunded
    And escrow should be updated

  @commissioner @buy-in
  Scenario: View league buy-in status
    Given I am a league commissioner
    When I view buy-in status
    Then I should see all member payments
    And I should see total collected

  # ============================================================================
  # PAYMENT SETTINGS
  # ============================================================================

  @happy-path @payment-settings
  Scenario: Set default payment method
    Given I have multiple payment methods
    When I set a default
    Then the default should be used for transactions
    And my preference should be saved

  @happy-path @payment-settings
  Scenario: Update billing address
    Given I am in payment settings
    When I update my billing address
    Then the address should be saved
    And it should be used for future transactions

  @happy-path @payment-settings
  Scenario: Set currency preference
    Given I am in payment settings
    When I set my currency preference
    Then amounts should display in that currency
    And conversions should be applied

  @happy-path @payment-settings
  Scenario: Enable payment notifications
    Given I am in payment settings
    When I enable payment notifications
    Then I should receive payment alerts
    And my preference should be saved

  @happy-path @payment-settings
  Scenario: Set spending limits
    Given I am in payment settings
    When I set spending limits
    Then limits should be enforced
    And I should be warned when approaching limits

  @happy-path @payment-settings
  Scenario: View saved payment methods
    Given I am in payment settings
    When I view my payment methods
    Then I should see all saved methods
    And I should be able to manage them

  # ============================================================================
  # SPLIT PAYMENTS
  # ============================================================================

  @happy-path @split-payments
  Scenario: Make partial payment
    Given I owe a large amount
    When I make a partial payment
    Then the partial payment should be accepted
    And remaining balance should be updated

  @happy-path @split-payments
  Scenario: Set up payment plan
    Given I need to pay a large amount
    When I set up a payment plan
    Then installments should be scheduled
    And I should be charged automatically

  @happy-path @split-payments
  Scenario: Split payment among group
    Given multiple people owe jointly
    When we split the payment
    Then each person should pay their share
    And all payments should be tracked

  @happy-path @split-payments
  Scenario: Track cost sharing
    Given expenses are being shared
    When I view cost sharing
    Then I should see who owes what
    And balances should be clear

  @happy-path @split-payments
  Scenario: Request payment from group member
    Given I covered a shared expense
    When I request payment from others
    Then payment requests should be sent
    And members should be notified

  @happy-path @split-payments
  Scenario: View payment plan status
    Given I have a payment plan
    When I view plan status
    Then I should see remaining payments
    And I should see next payment date

  # ============================================================================
  # FINANCIAL REPORTS
  # ============================================================================

  @happy-path @financial-reports
  Scenario: View league treasury
    Given I am a league commissioner
    When I view the league treasury
    Then I should see total funds
    And I should see fund sources

  @happy-path @financial-reports
  Scenario: Track league balance
    Given the league has financial activity
    When I view balance tracking
    Then I should see current balance
    And I should see transaction history

  @happy-path @financial-reports
  Scenario: Generate expense report
    Given the league has expenses
    When I generate an expense report
    Then the report should list all expenses
    And totals should be calculated

  @happy-path @financial-reports
  Scenario: View audit trail
    Given financial transactions have occurred
    When I view the audit trail
    Then I should see all financial actions
    And each action should be timestamped

  @happy-path @financial-reports
  Scenario: Export financial reports
    Given I need financial records
    When I export financial reports
    Then reports should be downloadable
    And formats should include PDF and CSV

  @happy-path @financial-reports
  Scenario: View year-end financial summary
    Given the season has ended
    When I view year-end summary
    Then I should see total collected
    And I should see total disbursed

  @commissioner @financial-reports
  Scenario: Reconcile league finances
    Given I am a league commissioner
    When I reconcile finances
    Then all transactions should be accounted for
    And any discrepancies should be flagged

  @error @financial-reports
  Scenario: Handle report generation failure
    Given I am generating a report
    When generation fails
    Then I should see an error message
    And I should be able to retry
