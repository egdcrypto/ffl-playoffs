@admin @payment-processing
Feature: Admin Payment Processing
  As a platform administrator
  I want to manage payment processing operations
  So that I can ensure secure and efficient payment handling

  Background:
    Given I am logged in as a platform administrator
    And I have payment processing permissions

  # =============================================================================
  # PAYMENT GATEWAY DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View payment processing overview dashboard
    When I navigate to the payment processing dashboard
    Then I should see the overall payment health status
    And I should see the following key metrics:
      | Metric                    | Time Period    |
      | Total transactions        | Today          |
      | Total volume              | Today          |
      | Success rate              | Today          |
      | Average transaction value | Today          |
      | Pending transactions      | Current        |
      | Failed transactions       | Today          |
    And I should see transaction volume charts
    And I should see gateway status indicators
    And I should see recent transaction activity feed

  @dashboard @gateway-status
  Scenario: Monitor payment gateway health status
    When I view the gateway status panel
    Then I should see all configured gateways with:
      | Gateway Field       | Description                      |
      | Gateway name        | Payment provider name            |
      | Connection status   | Connected/Disconnected           |
      | Response time       | Average latency in ms            |
      | Success rate        | Percentage of successful txns    |
      | Volume today        | Transaction count today          |
      | Last transaction    | Timestamp of last transaction    |
      | Health score        | Overall health rating            |
    And I should see alerts for degraded gateways
    And I should be able to view detailed gateway metrics

  @dashboard @real-time
  Scenario: Monitor real-time transaction flow
    When I enable real-time transaction monitoring
    Then I should see transactions as they process
    And each transaction should display:
      | Field               | Description                      |
      | Transaction ID      | Unique identifier                |
      | Amount              | Transaction amount               |
      | Currency            | Payment currency                 |
      | Gateway             | Processing gateway               |
      | Status              | Processing/Success/Failed        |
      | Duration            | Processing time                  |
    And I should see transaction velocity metrics
    And I should receive alerts for anomalies

  @dashboard @comparison
  Scenario: Compare payment performance across time periods
    When I access payment performance comparison
    Then I should be able to compare metrics between:
      | Comparison Type     | Options                          |
      | Day over day        | Today vs yesterday               |
      | Week over week      | This week vs last week           |
      | Month over month    | This month vs last month         |
      | Year over year      | This year vs last year           |
      | Custom range        | Any two date ranges              |
    And I should see percentage changes highlighted
    And I should be able to drill down into specific metrics

  # =============================================================================
  # PAYMENT GATEWAY CONFIGURATION
  # =============================================================================

  @gateway @configuration
  Scenario: Configure payment gateway settings
    When I access payment gateway configuration
    Then I should be able to configure:
      | Setting               | Options                          |
      | Gateway provider      | Stripe, Braintree, PayPal, etc.  |
      | API credentials       | Keys, secrets, merchant IDs      |
      | Environment           | Sandbox, Production              |
      | Webhook endpoints     | Callback URLs                    |
      | Retry policy          | Max retries, backoff strategy    |
      | Timeout settings      | Connection and read timeouts     |
    And I should be able to test gateway connectivity
    And credentials should be stored securely

  @gateway @multi-gateway
  Scenario: Set up multiple payment gateways
    When I configure multiple payment gateways
    Then I should be able to add gateways:
      | Gateway          | Type           | Use Case                  |
      | Stripe           | Primary        | Default processor         |
      | Braintree        | Backup         | Failover processor        |
      | PayPal           | Alternative    | Customer choice           |
      | Apple Pay        | Wallet         | Mobile payments           |
      | Google Pay       | Wallet         | Mobile payments           |
    And I should set priority order for gateways
    And I should configure failover rules
    And I should enable/disable gateways as needed

  @gateway @intelligent-routing
  Scenario: Configure intelligent payment routing
    When I configure intelligent payment routing
    Then I should be able to create routing rules based on:
      | Routing Factor        | Rule Options                     |
      | Transaction amount    | Route by amount thresholds       |
      | Card type             | Route by Visa, MC, Amex, etc.    |
      | Currency              | Route by payment currency        |
      | Geographic region     | Route by customer location       |
      | Success rate          | Route to highest performing      |
      | Cost                  | Route to lowest fee gateway      |
      | Risk score            | Route high-risk to specific GW   |
    And routing should be automatically optimized
    And I should see routing performance analytics

  @gateway @failover
  Scenario: Configure gateway failover settings
    When I configure gateway failover
    Then I should be able to set:
      | Setting               | Configuration                    |
      | Primary gateway       | Default payment processor        |
      | Failover triggers     | Timeout, error codes, threshold  |
      | Failover sequence     | Order of backup gateways         |
      | Retry attempts        | Number of retries before failover|
      | Circuit breaker       | Auto-disable failing gateway     |
      | Recovery check        | Interval to test failed gateway  |
    And failover should be automatic and seamless
    And I should receive alerts on failover events

  @gateway @webhooks
  Scenario: Manage payment gateway webhooks
    When I configure webhook settings
    Then I should be able to:
      | Configuration         | Options                          |
      | Endpoint URL          | HTTPS callback URL               |
      | Events subscribed     | Select specific events           |
      | Authentication        | Signature verification method    |
      | Retry policy          | Failed webhook retry settings    |
      | Event filtering       | Filter by event type             |
    And I should see webhook delivery logs
    And I should be able to manually retry failed webhooks

  # =============================================================================
  # TRANSACTION MANAGEMENT
  # =============================================================================

  @transaction @search
  Scenario: Search and filter transactions
    When I access the transaction search
    Then I should be able to search by:
      | Search Field          | Description                      |
      | Transaction ID        | Unique transaction identifier    |
      | Customer ID           | Customer account ID              |
      | Customer email        | Customer email address           |
      | Card last four        | Last four digits of card         |
      | Amount range          | Min and max amount               |
      | Date range            | Start and end date               |
    And I should be able to filter by:
      | Filter                | Options                          |
      | Status                | Success, Failed, Pending, etc.   |
      | Gateway               | Payment processor used           |
      | Payment method        | Card, ACH, wallet, etc.          |
      | Currency              | Transaction currency             |
      | Transaction type      | Sale, refund, auth, capture      |
    And results should be sortable and exportable

  @transaction @details
  Scenario: View detailed transaction information
    When I view a transaction's details
    Then I should see:
      | Section               | Information                      |
      | Transaction info      | ID, amount, currency, status     |
      | Customer info         | Name, email, billing address     |
      | Payment method        | Card type, last four, expiry     |
      | Gateway response      | Response code, message, auth     |
      | Timeline              | All status changes with times    |
      | Related transactions  | Refunds, chargebacks, captures   |
      | Metadata              | Custom fields, order info        |
    And I should see the raw gateway response
    And I should be able to take actions on the transaction

  @transaction @manual
  Scenario: Process manual payment transaction
    When I initiate a manual payment
    Then I should be able to enter:
      | Field                 | Requirement                      |
      | Customer              | Select or create customer        |
      | Amount                | Transaction amount               |
      | Currency              | Payment currency                 |
      | Payment method        | Card, ACH, or invoice            |
      | Description           | Transaction description          |
      | Metadata              | Custom fields                    |
    And I should select the processing gateway
    And I should see real-time authorization result
    And the transaction should be logged with audit trail

  @transaction @batch
  Scenario: Process batch payment transactions
    When I initiate batch payment processing
    Then I should be able to:
      | Action                | Description                      |
      | Upload file           | CSV/Excel with payment data      |
      | Map fields            | Match columns to required fields |
      | Validate data         | Pre-process validation           |
      | Preview batch         | Review before processing         |
      | Schedule processing   | Immediate or scheduled           |
    And I should see batch processing progress
    And I should receive a summary report upon completion
    And failed transactions should be flagged for review

  @transaction @capture
  Scenario: Capture authorized transactions
    When I view authorized transactions pending capture
    Then I should see transactions with:
      | Field                 | Description                      |
      | Authorization ID      | Original auth identifier         |
      | Amount authorized     | Original authorized amount       |
      | Authorization date    | When auth was obtained           |
      | Expiration date       | Auth expiration deadline         |
      | Customer              | Customer information             |
    And I should be able to:
      | Action                | Description                      |
      | Full capture          | Capture full authorized amount   |
      | Partial capture       | Capture less than authorized     |
      | Void authorization    | Cancel the authorization         |
    And capture should update transaction status

  @transaction @void
  Scenario: Void pending transactions
    When I need to void a transaction
    Then I should be able to void transactions that are:
      | Transaction State     | Void Allowed                     |
      | Authorized            | Yes                              |
      | Pending settlement    | Yes                              |
      | Settled               | No - must refund                 |
      | Already voided        | No                               |
    And I should provide a void reason
    And the void should be processed immediately
    And customer should be notified if configured

  # =============================================================================
  # REFUND MANAGEMENT
  # =============================================================================

  @refund @process
  Scenario: Process refund request
    When I process a refund request
    Then I should be able to:
      | Action                | Description                      |
      | Select transaction    | Original transaction to refund   |
      | Refund amount         | Full or partial amount           |
      | Refund reason         | Categorized reason code          |
      | Refund method         | Original method or store credit  |
      | Add notes             | Internal notes for record        |
    And I should see refund eligibility status
    And refund should process through original gateway
    And customer should receive refund confirmation

  @refund @partial
  Scenario: Process partial refund
    When I process a partial refund
    Then I should:
      | Step                  | Action                           |
      | View original         | See original transaction amount  |
      | Enter amount          | Specify partial refund amount    |
      | Validate              | Ensure amount <= remaining       |
      | Process               | Submit partial refund            |
    And the system should track:
      | Tracking              | Information                      |
      | Original amount       | Full transaction amount          |
      | Total refunded        | Sum of all refunds               |
      | Remaining             | Amount still refundable          |
    And multiple partial refunds should be supported

  @refund @bulk
  Scenario: Process bulk refunds
    When I need to process bulk refunds
    Then I should be able to:
      | Action                | Description                      |
      | Select transactions   | Choose multiple transactions     |
      | Apply criteria        | Filter by date, amount, reason   |
      | Review selection      | Confirm transactions to refund   |
      | Set refund type       | Full or percentage               |
      | Process batch         | Execute bulk refund              |
    And I should see processing progress
    And I should receive a summary report
    And failed refunds should be flagged

  @refund @policy
  Scenario: Configure refund policies
    When I configure refund policies
    Then I should be able to set:
      | Policy Setting        | Options                          |
      | Refund window         | Days after purchase              |
      | Auto-approval limit   | Amount for auto-approval         |
      | Approval required     | Transactions requiring approval  |
      | Refund methods        | Allowed refund methods           |
      | Partial refund        | Enable/disable partial refunds   |
      | Restocking fee        | Percentage or fixed fee          |
    And policies should be enforced automatically
    And exceptions should require manager approval

  @refund @tracking
  Scenario: Track refund status and history
    When I view refund tracking
    Then I should see all refunds with:
      | Field                 | Information                      |
      | Refund ID             | Unique identifier                |
      | Original transaction  | Link to original                 |
      | Amount                | Refund amount                    |
      | Status                | Pending, processed, failed       |
      | Initiated by          | User who initiated               |
      | Initiated date        | When refund was requested        |
      | Processed date        | When refund was completed        |
      | Reason                | Refund reason code               |
    And I should be able to filter and export refund data

  # =============================================================================
  # FRAUD DETECTION AND PREVENTION
  # =============================================================================

  @fraud @monitoring
  Scenario: Monitor fraud indicators in real-time
    When I access fraud monitoring dashboard
    Then I should see:
      | Metric                | Description                      |
      | Risk score average    | Average transaction risk score   |
      | High-risk count       | Transactions flagged high-risk   |
      | Fraud rate            | Percentage of fraudulent txns    |
      | False positive rate   | Legitimate txns flagged          |
      | Blocked transactions  | Auto-blocked by rules            |
      | Manual review queue   | Awaiting human review            |
    And I should see fraud pattern visualizations
    And I should receive real-time fraud alerts

  @fraud @rules
  Scenario: Configure fraud detection rules
    When I configure fraud detection rules
    Then I should be able to create rules based on:
      | Rule Type             | Parameters                       |
      | Velocity              | Transaction count per time       |
      | Amount threshold      | Single or cumulative amounts     |
      | Geographic            | Location-based restrictions      |
      | Device fingerprint    | Device reputation checks         |
      | IP analysis           | IP reputation and proxy detect   |
      | Card BIN              | Card issuer analysis             |
      | Behavioral            | Pattern deviation detection      |
    And rules should have configurable actions:
      | Action                | Description                      |
      | Allow                 | Process normally                 |
      | Review                | Queue for manual review          |
      | Challenge             | Require additional verification  |
      | Block                 | Decline transaction              |

  @fraud @review
  Scenario: Review high-risk transaction
    When I review a high-risk transaction
    Then I should see:
      | Information           | Details                          |
      | Risk score            | Numerical risk assessment        |
      | Risk factors          | Reasons for high score           |
      | Customer history      | Previous transactions            |
      | Device info           | Device fingerprint details       |
      | Location data         | Geographic information           |
      | Velocity data         | Recent transaction frequency     |
    And I should be able to:
      | Action                | Description                      |
      | Approve               | Allow transaction to proceed     |
      | Decline               | Reject the transaction           |
      | Request verification  | Contact customer for verify      |
      | Flag account          | Mark for ongoing monitoring      |
    And my decision should be logged with reasoning

  @fraud @machine-learning
  Scenario: Configure ML-based fraud detection
    When I configure machine learning fraud detection
    Then I should be able to:
      | Configuration         | Options                          |
      | Model selection       | Choose fraud detection model     |
      | Threshold tuning      | Adjust sensitivity levels        |
      | Feature weights       | Customize feature importance     |
      | Training data         | Provide labeled transaction data |
      | A/B testing           | Test model improvements          |
    And I should see model performance metrics:
      | Metric                | Description                      |
      | Precision             | Accuracy of fraud predictions    |
      | Recall                | Fraud detection rate             |
      | F1 score              | Balanced accuracy measure        |
      | AUC-ROC               | Model discrimination ability     |

  @fraud @blocklist
  Scenario: Manage fraud blocklists
    When I manage fraud blocklists
    Then I should be able to maintain lists of:
      | Blocklist Type        | Blocked Items                    |
      | Card numbers          | Specific card numbers            |
      | Card BINs             | Card issuer ranges               |
      | Email addresses       | Fraudulent email addresses       |
      | IP addresses          | Suspicious IP addresses          |
      | Device IDs            | Known fraud devices              |
      | Countries             | High-risk countries              |
    And I should be able to:
      | Action                | Description                      |
      | Add entries           | Add new blocked items            |
      | Remove entries        | Remove from blocklist            |
      | Import list           | Bulk import from file            |
      | Set expiration        | Auto-remove after date           |
    And blocklist matches should be logged

  @fraud @3ds
  Scenario: Configure 3D Secure authentication
    When I configure 3D Secure settings
    Then I should be able to set:
      | Setting               | Options                          |
      | 3DS version           | 3DS 1.0, 3DS 2.0                 |
      | Trigger conditions    | When to require 3DS              |
      | Amount threshold      | Minimum amount for 3DS           |
      | Risk-based trigger    | Trigger based on risk score      |
      | Exemptions            | Low-value, trusted customer      |
      | Fallback behavior     | Action if 3DS unavailable        |
    And I should see 3DS authentication metrics
    And I should track liability shift coverage

  # =============================================================================
  # CHARGEBACK MANAGEMENT
  # =============================================================================

  @chargeback @monitoring
  Scenario: Monitor chargeback activity
    When I access chargeback monitoring
    Then I should see:
      | Metric                | Description                      |
      | Chargeback rate       | Percentage of transactions       |
      | Total chargebacks     | Count by time period             |
      | Amount disputed       | Total disputed amount            |
      | Win rate              | Percentage won                   |
      | Open cases            | Active chargeback cases          |
      | Response deadline     | Cases needing immediate action   |
    And I should see chargeback trends
    And I should receive alerts for threshold breaches

  @chargeback @case
  Scenario: Handle chargeback case
    When I manage a chargeback case
    Then I should see case details:
      | Field                 | Information                      |
      | Case ID               | Chargeback identifier            |
      | Transaction           | Original transaction details     |
      | Reason code           | Chargeback reason category       |
      | Amount                | Disputed amount                  |
      | Filing date           | When chargeback was filed        |
      | Response deadline     | Date to respond by               |
      | Status                | Open, responded, won, lost       |
    And I should be able to:
      | Action                | Description                      |
      | Accept                | Accept the chargeback            |
      | Dispute               | Submit representment             |
      | Request info          | Get more details from issuer     |

  @chargeback @representment
  Scenario: Submit chargeback representment
    When I submit a representment
    Then I should be able to provide:
      | Evidence Type         | Description                      |
      | Transaction proof     | Authorization records            |
      | Delivery proof        | Shipping/delivery confirmation   |
      | Customer communication| Emails, support tickets          |
      | Refund proof          | If already refunded              |
      | Terms acceptance      | Customer agreement records       |
      | Custom evidence       | Additional supporting docs       |
    And I should use reason-specific templates
    And I should track representment status
    And I should see outcome and reason if lost

  @chargeback @prevention
  Scenario: Configure chargeback prevention measures
    When I configure chargeback prevention
    Then I should be able to enable:
      | Prevention Measure    | Description                      |
      | Descriptor clarity    | Clear billing descriptors        |
      | Alert services        | Ethoca, Verifi alerts            |
      | Pre-dispute resolution| Resolve before chargeback        |
      | Customer communication| Proactive outreach               |
      | Fraud screening       | Enhanced fraud detection         |
      | Purchase confirmation | Order confirmation emails        |
    And I should see prevention effectiveness metrics
    And I should track prevented chargebacks

  @chargeback @analytics
  Scenario: Analyze chargeback patterns
    When I access chargeback analytics
    Then I should see analysis by:
      | Dimension             | Insights                         |
      | Reason code           | Most common chargeback reasons   |
      | Product/service       | Items with high chargeback rate  |
      | Customer segment      | Customer groups with issues      |
      | Payment method        | Cards/methods with high CBs      |
      | Time pattern          | When chargebacks occur           |
      | Geography             | Regional chargeback patterns     |
    And I should see recommended actions
    And I should be able to export detailed reports

  # =============================================================================
  # SETTLEMENT AND RECONCILIATION
  # =============================================================================

  @settlement @monitoring
  Scenario: Monitor settlement status
    When I monitor settlements
    Then I should see:
      | Information           | Details                          |
      | Pending settlement    | Amount awaiting settlement       |
      | Expected date         | When funds will be available     |
      | Last settlement       | Most recent settlement details   |
      | Settlement schedule   | Expected settlement frequency    |
      | Holds                 | Funds on hold with reasons       |
    And I should see settlement by gateway
    And I should receive alerts for settlement issues

  @settlement @reconciliation
  Scenario: Perform payment reconciliation
    When I perform reconciliation
    Then I should be able to:
      | Action                | Description                      |
      | Import statements     | Upload bank/gateway statements   |
      | Auto-match            | Automatic transaction matching   |
      | Review exceptions     | Handle unmatched transactions    |
      | Resolve discrepancies | Fix amount or missing txns       |
      | Generate report       | Create reconciliation report     |
    And I should see reconciliation status:
      | Status                | Description                      |
      | Matched               | Transactions fully matched       |
      | Unmatched             | No matching transaction found    |
      | Discrepancy           | Amount or date mismatch          |
      | Pending               | Awaiting settlement              |

  @settlement @payout
  Scenario: Manage payout schedules
    When I configure payout settings
    Then I should be able to set:
      | Setting               | Options                          |
      | Payout frequency      | Daily, weekly, monthly           |
      | Minimum payout        | Minimum amount to trigger        |
      | Payout delay          | Days to hold before payout       |
      | Bank account          | Destination account              |
      | Auto-payout           | Enable/disable automatic         |
    And I should see payout history
    And I should be able to initiate manual payouts

  @settlement @reserves
  Scenario: Manage payment reserves
    When I view reserve management
    Then I should see:
      | Information           | Details                          |
      | Current reserve       | Amount held in reserve           |
      | Reserve rate          | Percentage of transactions       |
      | Reserve reason        | Why reserve is required          |
      | Release schedule      | When reserves will be released   |
      | Reserve history       | Historical reserve changes       |
    And I should be able to request reserve release
    And I should see reserve impact on cash flow

  # =============================================================================
  # PCI COMPLIANCE
  # =============================================================================

  @compliance @pci
  Scenario: Manage PCI compliance status
    When I access PCI compliance dashboard
    Then I should see:
      | Compliance Area       | Status                           |
      | SAQ status            | Current questionnaire status     |
      | Scan results          | Latest vulnerability scan        |
      | Penetration test      | Most recent pen test results     |
      | Compliance level      | Current PCI DSS level            |
      | Certification expiry  | When certification expires       |
      | Action items          | Required compliance actions      |
    And I should see compliance history
    And I should receive expiration reminders

  @compliance @data-security
  Scenario: Configure payment data security
    When I configure payment data security
    Then I should ensure:
      | Security Measure      | Implementation                   |
      | Card tokenization     | Replace PAN with tokens          |
      | Encryption at rest    | Encrypt stored card data         |
      | Encryption in transit | TLS for all transmissions        |
      | Key management        | Secure key storage and rotation  |
      | Access controls       | Limit who can view card data     |
      | Audit logging         | Log all card data access         |
    And I should see security compliance status
    And I should track security incidents

  @compliance @audit
  Scenario: Manage PCI audit requirements
    When I manage PCI audit requirements
    Then I should be able to:
      | Action                | Description                      |
      | Track requirements    | List all PCI DSS requirements    |
      | Document evidence     | Upload compliance evidence       |
      | Schedule audits       | Plan and track audit dates       |
      | Manage findings       | Track and resolve findings       |
      | Generate reports      | Create compliance reports        |
    And evidence should be version controlled
    And I should track remediation progress

  @compliance @scanning
  Scenario: Manage vulnerability scanning
    When I manage vulnerability scanning
    Then I should be able to:
      | Action                | Description                      |
      | Schedule scans        | Set up recurring ASV scans       |
      | View results          | See scan findings                |
      | Track remediation     | Monitor fix progress             |
      | Request rescan        | Verify fixes with new scan       |
      | Export reports        | Download scan reports            |
    And critical vulnerabilities should trigger alerts
    And I should see scan history and trends

  # =============================================================================
  # PAYMENT METHODS
  # =============================================================================

  @payment-methods @configuration
  Scenario: Configure accepted payment methods
    When I configure payment methods
    Then I should be able to enable:
      | Payment Method        | Configuration Options            |
      | Credit cards          | Visa, MC, Amex, Discover         |
      | Debit cards           | PIN debit, signature debit       |
      | ACH/Bank transfer     | One-time, recurring              |
      | Digital wallets       | Apple Pay, Google Pay, PayPal    |
      | BNPL                  | Affirm, Klarna, Afterpay         |
      | Cryptocurrency        | Bitcoin, Ethereum, stablecoins   |
    And I should set method-specific settings
    And I should see usage analytics by method

  @payment-methods @cards
  Scenario: Configure card payment settings
    When I configure card payment settings
    Then I should be able to set:
      | Setting               | Options                          |
      | Accepted networks     | Visa, MC, Amex, etc.             |
      | Card types            | Credit, debit, prepaid           |
      | CVV requirement       | Required, optional               |
      | AVS settings          | Address verification rules       |
      | International cards   | Allow/restrict by country        |
      | Saved cards           | Enable card-on-file              |
    And I should see card acceptance metrics
    And I should track decline reasons by card type

  @payment-methods @ach
  Scenario: Configure ACH payment settings
    When I configure ACH settings
    Then I should be able to set:
      | Setting               | Options                          |
      | Account types         | Checking, savings                |
      | Verification method   | Micro-deposits, instant verify   |
      | SEC codes             | WEB, CCD, PPD                    |
      | Return handling       | Auto-retry, notification         |
      | Settlement timing     | Same-day, next-day, standard     |
    And I should see ACH success rates
    And I should track return reasons

  @payment-methods @wallets
  Scenario: Configure digital wallet payments
    When I configure digital wallets
    Then I should be able to enable:
      | Wallet                | Configuration                    |
      | Apple Pay             | Merchant ID, certificates        |
      | Google Pay            | Merchant ID, gateway config      |
      | PayPal                | Client ID, integration type      |
      | Venmo                 | Business profile setup           |
    And I should configure wallet-specific settings
    And I should see wallet adoption metrics
    And I should track wallet transaction success rates

  # =============================================================================
  # SUBSCRIPTION BILLING
  # =============================================================================

  @subscription @management
  Scenario: Manage subscription billing
    When I access subscription management
    Then I should see:
      | Metric                | Description                      |
      | Active subscriptions  | Current subscriber count         |
      | MRR                   | Monthly recurring revenue        |
      | Churn rate            | Subscription cancellation rate   |
      | Failed renewals       | Unsuccessful renewal attempts    |
      | Upcoming renewals     | Renewals in next 7 days          |
    And I should see subscription trends
    And I should be able to search subscriptions

  @subscription @plans
  Scenario: Configure subscription plans
    When I configure subscription plans
    Then I should be able to create plans with:
      | Setting               | Options                          |
      | Plan name             | Display name                     |
      | Billing interval      | Monthly, quarterly, annual       |
      | Price                 | Amount per interval              |
      | Trial period          | Free trial duration              |
      | Setup fee             | One-time initial fee             |
      | Usage limits          | Feature/usage restrictions       |
    And I should support plan tiers
    And I should enable plan upgrades/downgrades

  @subscription @dunning
  Scenario: Configure dunning management
    When I configure dunning settings
    Then I should be able to set:
      | Setting               | Configuration                    |
      | Retry schedule        | Days between retry attempts      |
      | Max retries           | Number of attempts before fail   |
      | Notification emails   | Email templates per attempt      |
      | Grace period          | Days before cancellation         |
      | Card update request   | Prompt for new payment method    |
      | Pause option          | Allow subscription pause         |
    And I should see dunning effectiveness metrics
    And I should track recovery rates

  @subscription @proration
  Scenario: Configure proration settings
    When I configure proration
    Then I should be able to set:
      | Scenario              | Proration Behavior               |
      | Upgrade mid-cycle     | Credit/charge difference         |
      | Downgrade mid-cycle   | Credit for next period           |
      | Cancellation          | Refund remaining or no refund    |
      | Plan change           | Immediate or next cycle          |
    And proration should be calculated automatically
    And customers should see proration details

  @subscription @lifecycle
  Scenario: Manage subscription lifecycle events
    When I configure lifecycle automation
    Then I should be able to trigger actions on:
      | Event                 | Possible Actions                 |
      | Subscription created  | Welcome email, provision access  |
      | Trial ending          | Reminder email, conversion offer |
      | Renewal success       | Confirmation, thank you          |
      | Renewal failed        | Dunning sequence start           |
      | Subscription paused   | Pause access, win-back offer     |
      | Subscription canceled | Exit survey, retention offer     |
    And lifecycle events should be logged
    And I should see lifecycle analytics

  # =============================================================================
  # PAYMENT ANALYTICS
  # =============================================================================

  @analytics @dashboard
  Scenario: View payment analytics dashboard
    When I access payment analytics
    Then I should see:
      | Analytics Category    | Metrics                          |
      | Transaction volume    | Count and amount over time       |
      | Success rates         | By gateway, method, card type    |
      | Revenue metrics       | Gross, net, fees, refunds        |
      | Customer metrics      | New, returning, lifetime value   |
      | Geographic            | Revenue by region/country        |
      | Payment method        | Usage and performance by method  |
    And I should see trend visualizations
    And I should be able to customize date ranges

  @analytics @revenue
  Scenario: Analyze revenue metrics
    When I view revenue analytics
    Then I should see:
      | Metric                | Description                      |
      | Gross revenue         | Total transaction amount         |
      | Net revenue           | After fees and refunds           |
      | Processing fees       | Total gateway/processor fees     |
      | Refund amount         | Total refunded                   |
      | Chargeback losses     | Lost to chargebacks              |
      | Fee percentage        | Fees as % of gross               |
    And I should see revenue by:
      | Dimension             | Breakdown                        |
      | Time                  | Daily, weekly, monthly           |
      | Gateway               | By payment processor             |
      | Payment method        | By payment type                  |
      | Product               | By product/service               |

  @analytics @conversion
  Scenario: Analyze payment conversion rates
    When I view conversion analytics
    Then I should see:
      | Funnel Stage          | Metric                           |
      | Checkout started      | Users who started payment        |
      | Payment attempted     | Submitted payment info           |
      | Payment successful    | Completed payments               |
      | Payment failed        | Failed transactions              |
    And I should see drop-off analysis
    And I should see conversion by:
      | Dimension             | Breakdown                        |
      | Device type           | Desktop, mobile, tablet          |
      | Payment method        | Card, ACH, wallet                |
      | Customer type         | New vs returning                 |
      | Gateway               | By processor                     |

  @analytics @decline
  Scenario: Analyze decline reasons
    When I view decline analytics
    Then I should see declines categorized by:
      | Category              | Examples                         |
      | Card issues           | Invalid, expired, insufficient   |
      | Fraud                 | Suspected fraud, velocity        |
      | Technical             | Gateway error, timeout           |
      | Compliance            | 3DS failure, AVS mismatch        |
    And I should see decline trends over time
    And I should see recommended actions to reduce declines

  @analytics @reporting
  Scenario: Generate custom payment reports
    When I create custom reports
    Then I should be able to:
      | Configuration         | Options                          |
      | Select metrics        | Choose from available metrics    |
      | Set dimensions        | Group by various attributes      |
      | Apply filters         | Filter by any field              |
      | Set date range        | Custom date selection            |
      | Schedule delivery     | Email reports automatically      |
      | Export format         | PDF, CSV, Excel                  |
    And reports should be saved for reuse
    And I should see report generation history

  # =============================================================================
  # INTERNATIONAL PAYMENTS
  # =============================================================================

  @international @currency
  Scenario: Configure multi-currency support
    When I configure currency settings
    Then I should be able to:
      | Configuration         | Options                          |
      | Supported currencies  | Enable/disable currencies        |
      | Base currency         | Set primary currency             |
      | Exchange rates        | Manual or auto-update            |
      | Rate source           | Select exchange rate provider    |
      | Markup                | Add margin to exchange rate      |
      | Rounding rules        | Configure rounding behavior      |
    And I should see currency conversion preview
    And I should track exchange rate history

  @international @regional
  Scenario: Configure regional payment settings
    When I configure regional payment settings
    Then I should be able to set by region:
      | Setting               | Regional Configuration           |
      | Payment methods       | Region-specific methods          |
      | Gateway routing       | Regional gateway preference      |
      | Tax handling          | Regional tax rules               |
      | Compliance            | Regional requirements            |
      | Currency              | Default currency per region      |
    And I should see regional payment analytics
    And I should configure region detection rules

  @international @local-methods
  Scenario: Enable local payment methods
    When I configure local payment methods
    Then I should be able to enable:
      | Region                | Local Methods                    |
      | Europe                | iDEAL, Bancontact, SEPA          |
      | Asia                  | Alipay, WeChat Pay, GrabPay      |
      | Latin America         | Boleto, OXXO, PIX                |
      | India                 | UPI, Paytm, NetBanking           |
    And each method should have specific configuration
    And I should see adoption and performance by method

  @international @cross-border
  Scenario: Manage cross-border payment settings
    When I configure cross-border payments
    Then I should be able to:
      | Configuration         | Options                          |
      | Allowed countries     | Enable/restrict countries        |
      | High-risk countries   | Additional verification required |
      | Currency conversion   | Customer or merchant side        |
      | Cross-border fees     | Fee structure for international  |
      | Dynamic conversion    | Offer customer currency choice   |
    And I should see cross-border analytics
    And I should track cross-border success rates

  # =============================================================================
  # SECURITY CONFIGURATION
  # =============================================================================

  @security @access
  Scenario: Configure payment security access controls
    When I configure payment security settings
    Then I should be able to set:
      | Setting               | Configuration                    |
      | Role permissions      | Who can perform payment actions  |
      | IP restrictions       | Allowed IP addresses             |
      | MFA requirements      | Multi-factor for sensitive ops   |
      | Session timeout       | Auto-logout duration             |
      | Action limits         | Max amounts per user             |
    And all access should be audit logged
    And I should see access analytics

  @security @encryption
  Scenario: Manage payment data encryption
    When I manage encryption settings
    Then I should configure:
      | Encryption Type       | Configuration                    |
      | Data at rest          | AES-256 for stored data          |
      | Data in transit       | TLS 1.3 for transmission         |
      | Field-level           | Encrypt specific sensitive fields|
      | Key rotation          | Automatic key rotation schedule  |
      | Key storage           | HSM or key management service    |
    And I should see encryption status
    And I should track key usage and rotation

  @security @audit
  Scenario: Review payment audit logs
    When I access payment audit logs
    Then I should see logs for:
      | Event Type            | Logged Information               |
      | Transaction events    | All payment transactions         |
      | Configuration changes | Settings modifications           |
      | User actions          | Manual operations performed      |
      | Security events       | Auth failures, suspicious acts   |
      | API access            | All API calls with credentials   |
    And logs should be searchable and filterable
    And logs should be tamper-proof and exportable

  @security @api-keys
  Scenario: Manage payment API keys
    When I manage payment API keys
    Then I should be able to:
      | Action                | Description                      |
      | Create keys           | Generate new API credentials     |
      | Set permissions       | Limit key capabilities           |
      | Set expiration        | Key validity period              |
      | Monitor usage         | Track API key usage              |
      | Rotate keys           | Generate new, invalidate old     |
      | Revoke keys           | Immediately disable a key        |
    And I should see key usage analytics
    And I should receive alerts for suspicious usage

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient payment permissions
    Given I do not have payment processing permissions
    When I attempt to access payment features
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @gateway-unavailable
  Scenario: Handle payment gateway unavailability
    Given I am processing a payment
    When the payment gateway is unavailable
    Then I should see a gateway error message
    And the system should attempt failover if configured
    And I should see options to:
      | Option                | Description                      |
      | Retry                 | Attempt again on same gateway    |
      | Use backup            | Try backup gateway               |
      | Queue                 | Queue for later processing       |
    And the failure should be logged

  @error @transaction-failed
  Scenario: Handle transaction failure
    Given I am processing a payment
    When the transaction fails
    Then I should see the specific failure reason:
      | Failure Type          | Message                          |
      | Declined              | Card declined by issuer          |
      | Insufficient funds    | Not enough funds available       |
      | Invalid card          | Card number invalid              |
      | Expired card          | Card has expired                 |
      | Fraud block           | Transaction blocked for fraud    |
    And I should see suggested resolution steps
    And the failure should be logged for analysis

  @error @refund-failed
  Scenario: Handle refund processing failure
    Given I am processing a refund
    When the refund fails to process
    Then I should see the failure reason
    And I should see available actions:
      | Action                | Description                      |
      | Retry refund          | Attempt refund again             |
      | Manual refund         | Process through alternative      |
      | Issue credit          | Provide store credit instead     |
      | Escalate              | Send to supervisor               |
    And the failure should be logged

  @error @reconciliation-mismatch
  Scenario: Handle reconciliation discrepancies
    Given I am performing reconciliation
    When discrepancies are found
    Then I should see:
      | Discrepancy Type      | Details                          |
      | Missing transaction   | In gateway but not system        |
      | Amount mismatch       | Different amounts recorded       |
      | Duplicate entry       | Transaction recorded twice       |
      | Status mismatch       | Different status in systems      |
    And I should be able to investigate each discrepancy
    And I should document resolution actions
