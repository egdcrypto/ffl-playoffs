@ANIMA-1428 @email @communication @platform
Feature: Email Communication System
  As a platform
  I want to manage email communications effectively
  So that users receive timely, relevant, and compliant email communications

  Background:
    Given the email service is configured and operational
    And email templates are loaded in the system
    And email delivery provider is connected

  # ==================== TRANSACTIONAL EMAILS ====================

  Scenario: Send account verification email on user registration
    Given a new user registers with email "user@example.com"
    When the registration is confirmed
    Then a verification email is sent to "user@example.com"
    And the email contains a unique verification link
    And the verification link expires in 24 hours
    And the email is logged with status "SENT"

  Scenario: Send password reset email
    Given user "john@example.com" requests a password reset
    When the password reset request is validated
    Then a password reset email is sent to "john@example.com"
    And the email contains a secure one-time reset token
    And the reset token expires in 1 hour
    And previous reset tokens for this user are invalidated

  Scenario: Send purchase confirmation email
    Given user "customer@example.com" completes a purchase
    And the order contains:
      | Item           | Quantity | Price  |
      | Premium Plan   | 1        | $29.99 |
    When the payment is processed successfully
    Then an order confirmation email is sent
    And the email includes order details and receipt
    And the email includes invoice PDF attachment
    And the email is marked as high priority

  Scenario: Send account activity notification for security events
    Given user "secure@example.com" has security notifications enabled
    When a login from a new device is detected
    Then a security alert email is sent immediately
    And the email includes:
      | Field        | Value                    |
      | Device       | Chrome on Windows        |
      | Location     | New York, USA            |
      | IP Address   | 192.168.1.xxx (masked)   |
      | Time         | 2025-01-15 10:30:00 UTC  |
    And the email includes a link to review account activity

  Scenario: Send invoice email for subscription billing
    Given user "subscriber@example.com" has an active subscription
    When the monthly billing cycle completes
    Then an invoice email is sent
    And the email includes payment summary
    And the email includes next billing date
    And the invoice PDF is attached

  Scenario: Handle transactional email delivery failure
    Given a transactional email is queued for "invalid-email"
    When the email delivery fails with "INVALID_RECIPIENT"
    Then the failure is logged with error details
    And the system retries delivery up to 3 times
    And if all retries fail, an alert is sent to support
    And the user is flagged for email validation

  # ==================== NOTIFICATION EMAILS ====================

  Scenario: Send game start notification email
    Given user "player@example.com" has game notifications enabled
    And the user is participating in league "NFL Playoffs 2025"
    When a playoff game is about to start in 1 hour
    Then a game reminder email is sent
    And the email includes game details and matchup information
    And the email includes a link to view live scores

  Scenario: Send weekly digest notification
    Given user "digest@example.com" has weekly digest enabled
    And the week's activity includes:
      | Activity Type       | Count |
      | New messages        | 5     |
      | Roster updates      | 3     |
      | League announcements| 2     |
    When the weekly digest schedule triggers
    Then a digest email is compiled and sent
    And the email summarizes all activities
    And the email includes links to each activity

  Scenario: Send achievement notification email
    Given user "achiever@example.com" has achievement notifications enabled
    When the user earns the "First Victory" achievement
    Then an achievement notification email is sent
    And the email includes achievement badge image
    And the email includes achievement description
    And the email encourages sharing on social media

  Scenario: Batch notification emails for efficiency
    Given 1000 users need to receive game start notifications
    When the notification batch is triggered
    Then emails are queued in batches of 100
    And batch processing respects rate limits
    And delivery progress is tracked per batch
    And completion status is logged

  Scenario: Send real-time score update notification
    Given user "scores@example.com" has real-time score notifications enabled
    And the user's team is in an active matchup
    When a significant scoring event occurs
    Then a score update email is sent within 5 minutes
    And the email includes current score comparison
    And the email is marked as time-sensitive

  # ==================== MARKETING EMAILS ====================

  Scenario: Send promotional campaign email
    Given a marketing campaign "Summer Sale 2025" is scheduled
    And the target audience includes users with:
      | Criteria              | Value            |
      | Subscription Status   | Free             |
      | Last Active           | Within 30 days   |
      | Marketing Opt-in      | True             |
    When the campaign launch time arrives
    Then promotional emails are sent to eligible recipients
    And each email includes campaign tracking parameters
    And unsubscribe link is prominently displayed

  Scenario: Send product announcement email
    Given a new feature "Advanced Analytics" is ready for launch
    And the announcement targets premium users
    When the product announcement is triggered
    Then announcement emails are sent
    And the email highlights key benefits
    And the email includes tutorial links
    And the email includes feedback request

  Scenario: Send re-engagement email for inactive users
    Given user "inactive@example.com" has not logged in for 60 days
    And the user has marketing emails enabled
    When the re-engagement campaign triggers
    Then a re-engagement email is sent
    And the email includes personalized content based on past activity
    And the email includes a special return offer
    And the email respects quiet hours

  Scenario: A/B test marketing email variations
    Given a marketing campaign has two variations:
      | Variation | Subject Line                     | CTA Button    |
      | A         | Don't Miss Our Best Deals        | Shop Now      |
      | B         | Exclusive Savings Just for You   | Claim Offer   |
    When the campaign is sent to 10,000 recipients
    Then 50% receive Variation A
    And 50% receive Variation B
    And engagement metrics are tracked per variation
    And winning variation is determined after 48 hours

  Scenario: Enforce marketing email frequency caps
    Given user "frequent@example.com" received 3 marketing emails this week
    And the weekly marketing email limit is 3
    When another marketing campaign targets this user
    Then the email is held until next week
    And the delay is logged with reason "FREQUENCY_CAP"
    And transactional emails are not affected by this limit

  # ==================== EMAIL TEMPLATES ====================

  Scenario: Create new email template
    Given an admin is managing email templates
    When the admin creates a template with:
      | Field       | Value                           |
      | Name        | Welcome Email                   |
      | Subject     | Welcome to {{platform_name}}!   |
      | Category    | Transactional                   |
      | Language    | en-US                           |
    Then the template is saved and versioned
    And the template is available for use
    And template variables are validated

  Scenario: Edit existing email template
    Given email template "Welcome Email" version 1.0 exists
    When an admin updates the template content
    Then a new version 1.1 is created
    And the previous version is archived
    And active campaigns are not affected until migration

  Scenario: Manage template translations
    Given email template "Password Reset" exists in English
    When translations are added for:
      | Language | Locale |
      | Spanish  | es-ES  |
      | French   | fr-FR  |
      | German   | de-DE  |
    Then each translation is validated for variables
    And language-specific formatting is applied
    And fallback to English is configured if translation missing

  Scenario: Preview email template with sample data
    Given email template "Order Confirmation" exists
    When an admin requests preview with sample data:
      | Variable       | Sample Value      |
      | customer_name  | John Doe          |
      | order_id       | ORD-12345         |
      | order_total    | $99.99            |
    Then the rendered email is displayed
    And both HTML and plain text versions are shown
    And mobile preview is available

  Scenario: Validate template variables before save
    Given an admin is editing a template
    And the template uses variable "{{user_name}}"
    When the admin saves with undefined variable "{{user_nmae}}"
    Then validation fails with error "Unknown variable: user_nmae"
    And similar variables are suggested: "user_name"
    And the template is not saved until corrected

  Scenario: Configure template with dynamic content blocks
    Given email template "Newsletter" exists
    When dynamic content blocks are configured:
      | Block Name      | Condition                    |
      | Premium Content | user.subscription = premium  |
      | Free Content    | user.subscription = free     |
      | Upsell Block    | user.eligible_for_upgrade    |
    Then appropriate blocks are included based on recipient
    And fallback content is defined for each block

  # ==================== EMAIL PREFERENCES ====================

  Scenario: User sets email notification preferences
    Given user "prefs@example.com" accesses email preferences
    When the user updates preferences:
      | Category              | Enabled |
      | Game Notifications    | True    |
      | Marketing Emails      | False   |
      | Weekly Digest         | True    |
      | Security Alerts       | True    |
    Then preferences are saved immediately
    And a confirmation email is sent
    And future emails respect these preferences

  Scenario: User unsubscribes from marketing emails
    Given user "unsub@example.com" clicks unsubscribe link
    When the unsubscribe request is processed
    Then marketing preference is set to False
    And transactional emails remain enabled
    And unsubscribe is logged for compliance
    And confirmation page is displayed

  Scenario: User manages email frequency preferences
    Given user "frequency@example.com" accesses preferences
    When the user sets:
      | Setting               | Value        |
      | Digest Frequency      | Weekly       |
      | Score Updates         | End of game  |
      | Quiet Hours Start     | 22:00        |
      | Quiet Hours End       | 08:00        |
    Then preferences are applied to future emails
    And emails during quiet hours are queued

  Scenario: Enforce preference changes immediately
    Given user "immediate@example.com" disables all marketing
    And there are 3 marketing emails queued for this user
    When the preference change is saved
    Then queued marketing emails are cancelled
    And cancellation is logged
    And no marketing emails are sent until preference changes

  Scenario: User opts into email categories granularly
    Given user "granular@example.com" manages preferences
    When the user selects specific notification types:
      | Type                    | Email | In-App | Push  |
      | Score Updates           | No    | Yes    | Yes   |
      | Roster Lock Reminders   | Yes   | Yes    | No    |
      | League Announcements    | Yes   | Yes    | Yes   |
      | Trade Offers            | No    | Yes    | Yes   |
    Then multi-channel preferences are saved
    And each channel respects individual settings

  Scenario: Provide one-click unsubscribe from all
    Given user "bulk-unsub@example.com" clicks "Unsubscribe from all"
    When the request is processed
    Then all optional email categories are disabled
    And only mandatory transactional emails remain
    And a confirmation is displayed
    And the action is logged for compliance

  # ==================== EMAIL DELIVERY ====================

  Scenario: Queue email for delivery
    Given an email is ready to be sent
    When the email is submitted to the delivery queue
    Then the email receives a unique message ID
    And the email is persisted in the queue
    And delivery priority is assigned
    And estimated delivery time is calculated

  Scenario: Retry failed email delivery
    Given email delivery to "temp-fail@example.com" fails with "TEMPORARY_FAILURE"
    When the retry policy is applied
    Then the email is requeued with exponential backoff:
      | Attempt | Delay    |
      | 1       | 1 minute |
      | 2       | 5 minutes|
      | 3       | 30 minutes|
    And each retry attempt is logged
    And if all retries fail, email is moved to dead letter queue

  Scenario: Process bounce notification
    Given email to "bounced@invalid.com" returns hard bounce
    When the bounce notification is received
    Then the email is marked as "BOUNCED"
    And the recipient address is added to suppression list
    And future emails to this address are blocked
    And bounce metrics are updated

  Scenario: Handle spam complaint
    Given recipient marks email as spam
    When the complaint is received via feedback loop
    Then the recipient is added to suppression list
    And the incident is logged for compliance
    And admin is notified if complaint rate exceeds threshold
    And the email campaign is flagged for review

  Scenario: Monitor email delivery health
    Given the email system has been sending for 24 hours
    When delivery metrics are calculated
    Then dashboard shows:
      | Metric           | Value    |
      | Delivery Rate    | 98.5%    |
      | Bounce Rate      | 0.8%     |
      | Complaint Rate   | 0.02%    |
      | Open Rate        | 35.2%    |
      | Click Rate       | 12.8%    |
    And alerts trigger if thresholds are exceeded

  Scenario: Implement email throttling to protect sender reputation
    Given the hourly sending limit is 10,000 emails
    When 8,000 emails are queued for immediate delivery
    Then emails are sent respecting the rate limit
    And overflow emails are queued for next hour
    And throttling status is logged
    And priority emails bypass throttling

  Scenario: Validate email before delivery
    Given an email is prepared for delivery
    When pre-delivery validation runs
    Then the system checks:
      | Validation               | Pass/Fail |
      | Recipient address format | Pass      |
      | Sender authentication    | Pass      |
      | Content spam score       | Pass      |
      | Suppression list check   | Pass      |
      | Template rendering       | Pass      |
    And only validated emails proceed to delivery

  # ==================== EMAIL PERSONALIZATION ====================

  Scenario: Personalize email with user data
    Given user "personal@example.com" has profile:
      | Field        | Value           |
      | First Name   | Sarah           |
      | Team Name    | Victory Eagles  |
      | League       | NFL Playoffs    |
    When a notification email is generated
    Then the email greeting is "Hi Sarah!"
    And content references "Victory Eagles"
    And links are personalized for the user

  Scenario: Apply dynamic content based on user segment
    Given user "segment@example.com" belongs to segment "High Value"
    When a promotional email is generated
    Then exclusive high-value offers are included
    And VIP support contact is displayed
    And special loyalty rewards are highlighted

  Scenario: Personalize email send time based on engagement
    Given user "timing@example.com" typically opens emails at 9:00 AM local
    When a non-urgent email is scheduled
    Then delivery is optimized for 9:00 AM user timezone
    And if timezone is unknown, default schedule is used
    And send time optimization is logged

  Scenario: Include personalized product recommendations
    Given user "recs@example.com" has purchase history
    And the user previously purchased "Premium Plan"
    When a recommendation email is generated
    Then complementary products are suggested:
      | Product              | Relevance Score |
      | Advanced Analytics   | 0.92            |
      | Priority Support     | 0.85            |
      | Extra Team Slots     | 0.78            |
    And recommendations are based on similar users

  Scenario: Personalize based on user behavior
    Given user "behavior@example.com" recently viewed:
      | Page                    | Views |
      | League Setup Guide      | 3     |
      | Scoring Rules           | 2     |
      | Draft Strategy          | 5     |
    When a follow-up email is generated
    Then content emphasizes draft preparation
    And relevant tutorial links are included
    And a draft preparation checklist is attached

  Scenario: Handle missing personalization data gracefully
    Given user "incomplete@example.com" has no first name on file
    When a personalized email is generated
    Then fallback greeting "Hi there!" is used
    And missing data is logged for quality tracking
    And data collection prompt is included in email

  # ==================== EMAIL SCHEDULING ====================

  Scenario: Schedule email for future delivery
    Given a campaign email is created
    When the sender schedules delivery for "2025-02-15 10:00 UTC"
    Then the email is saved with scheduled status
    And delivery is triggered at the specified time
    And the sender can cancel before delivery
    And timezone is clearly displayed

  Scenario: Schedule recurring email campaign
    Given a weekly newsletter campaign is configured
    When the schedule is set to "Every Monday at 9:00 AM EST"
    Then emails are generated and queued weekly
    And each occurrence uses latest template version
    And recipient list is refreshed per occurrence
    And the recurrence can be paused or stopped

  Scenario: Apply timezone-aware scheduling
    Given recipients are in multiple timezones:
      | Timezone        | Recipients |
      | America/New_York| 500        |
      | Europe/London   | 300        |
      | Asia/Tokyo      | 200        |
    When the campaign is scheduled for "9:00 AM local time"
    Then delivery is staggered by timezone
    And each recipient receives at their local 9:00 AM
    And sending spans multiple hours

  Scenario: Cancel scheduled email
    Given email campaign "Holiday Sale" is scheduled for tomorrow
    When the sender cancels the campaign
    Then all scheduled emails are cancelled
    And cancellation reason is logged
    And recipients are not notified of cancellation
    And the campaign can be rescheduled

  Scenario: Modify scheduled email before delivery
    Given email campaign is scheduled for 24 hours from now
    When the sender updates the subject line
    Then the updated content replaces the original
    And modification timestamp is recorded
    And audit trail shows all changes

  Scenario: Handle scheduling conflicts
    Given user "conflict@example.com" has emails scheduled:
      | Time              | Campaign          |
      | 2025-02-15 10:00  | Weekly Newsletter |
      | 2025-02-15 10:30  | Product Announce  |
    When a third email is scheduled for 10:15
    Then conflict warning is displayed
    And sender can override or reschedule
    And minimum gap policy is enforced if configured

  # ==================== EMAIL ANALYTICS ====================

  Scenario: Track email open events
    Given email with ID "msg-12345" is delivered
    When the recipient opens the email
    Then an open event is recorded with:
      | Field          | Value                    |
      | Message ID     | msg-12345                |
      | Opened At      | 2025-01-15 14:30:00 UTC  |
      | Device Type    | Mobile                   |
      | Email Client   | Gmail                    |
    And open rate metrics are updated

  Scenario: Track email click events
    Given email contains link with tracking ID "link-abc"
    When the recipient clicks the link
    Then a click event is recorded with:
      | Field          | Value                    |
      | Link ID        | link-abc                 |
      | Link URL       | /promo/summer-sale       |
      | Clicked At     | 2025-01-15 14:35:00 UTC  |
    And click-through rate is updated
    And the user is redirected to destination

  Scenario: Generate campaign performance report
    Given campaign "January Newsletter" has completed
    When the performance report is generated
    Then the report includes:
      | Metric             | Value   |
      | Emails Sent        | 10,000  |
      | Delivered          | 9,850   |
      | Opened             | 3,546   |
      | Unique Opens       | 2,890   |
      | Clicked            | 1,234   |
      | Unique Clicks      | 1,045   |
      | Unsubscribed       | 23      |
      | Spam Complaints    | 2       |
      | Bounced            | 150     |
    And trend comparison with previous campaigns is shown

  Scenario: Track link performance within email
    Given email contains multiple tracked links
    When click analytics are requested
    Then performance per link is shown:
      | Link Name          | Clicks | Click Rate |
      | Main CTA Button    | 450    | 4.5%       |
      | Secondary Link     | 180    | 1.8%       |
      | Footer Link        | 45     | 0.45%      |
      | Social Share       | 120    | 1.2%       |
    And heatmap visualization is available

  Scenario: Analyze email engagement by segment
    Given campaign was sent to multiple segments
    When segment performance is analyzed
    Then engagement by segment is displayed:
      | Segment         | Open Rate | Click Rate | Conversions |
      | Premium Users   | 45.2%     | 18.5%      | 12          |
      | Free Users      | 28.3%     | 8.2%       | 3           |
      | New Users       | 52.1%     | 22.4%      | 8           |
    And best performing segments are highlighted

  Scenario: Calculate email revenue attribution
    Given tracked emails contain purchase links
    When revenue analytics are requested
    Then attribution report shows:
      | Campaign          | Revenue    | Orders | Avg Order Value |
      | Welcome Series    | $12,500    | 125    | $100            |
      | Abandoned Cart    | $8,750     | 50     | $175            |
      | Weekly Promo      | $5,200     | 104    | $50             |
    And attribution window is configurable

  Scenario: Export analytics data
    Given an admin requests analytics export
    When export parameters are specified:
      | Parameter    | Value            |
      | Date Range   | Last 30 days     |
      | Campaigns    | All              |
      | Format       | CSV              |
    Then the export is generated
    And download link is provided
    And export includes all tracked metrics

  # ==================== EMAIL COMPLIANCE ====================

  Scenario: Include required unsubscribe link
    Given a marketing email is being generated
    When the email content is finalized
    Then an unsubscribe link is automatically included
    And the link is functional and one-click
    And the link is visible without scrolling
    And physical mailing address is included

  Scenario: Validate CAN-SPAM compliance
    Given an email campaign is ready to send
    When compliance validation runs
    Then the system verifies:
      | Requirement              | Status |
      | Unsubscribe link present | Pass   |
      | Physical address present | Pass   |
      | Clear sender identity    | Pass   |
      | Honest subject line      | Pass   |
      | Opt-out processed in 10 days | Pass |
    And non-compliant emails are blocked

  Scenario: Validate GDPR consent for EU recipients
    Given recipient "eu-user@example.eu" is in the EU
    When an email is queued for this recipient
    Then GDPR consent status is verified
    And if consent is not recorded, email is blocked
    And consent verification is logged
    And legitimate interest basis is documented if applicable

  Scenario: Process data subject access request for emails
    Given user "gdpr@example.com" submits a data access request
    When the request is processed
    Then all email records for this user are compiled:
      | Data Type            | Records |
      | Emails Sent          | 47      |
      | Open Events          | 32      |
      | Click Events         | 15      |
      | Preference Changes   | 3       |
    And data is provided in portable format

  Scenario: Handle right to erasure for email data
    Given user "erasure@example.com" requests data deletion
    When the erasure request is processed
    Then email history is anonymized or deleted
    And user is added to permanent suppression list
    And audit record of deletion is maintained
    And third-party integrations are notified

  Scenario: Maintain email consent audit trail
    Given user "consent@example.com" has marketing consent
    When consent history is requested
    Then the audit trail shows:
      | Date                | Action              | Source        |
      | 2024-06-15 10:00    | Consent Given       | Registration  |
      | 2024-09-20 15:30    | Preferences Updated | Account Page  |
      | 2025-01-10 08:45    | Consent Confirmed   | Double Opt-in |
    And each entry includes IP address and user agent

  Scenario: Enforce email retention policies
    Given email retention policy is 2 years
    When the retention cleanup job runs
    Then emails older than 2 years are archived or deleted
    And analytics data is aggregated before deletion
    And compliance exceptions are respected
    And cleanup is logged

  Scenario: Validate sending domain authentication
    Given the email system sends from "notifications@example.com"
    When domain authentication is verified
    Then the system confirms:
      | Protocol   | Status    |
      | SPF        | Configured |
      | DKIM       | Configured |
      | DMARC      | Configured |
    And authentication failures are alerted
    And reports are sent to postmaster

  Scenario: Handle international anti-spam regulations
    Given recipients include international addresses
    When compliance is checked per recipient country
    Then applicable regulations are enforced:
      | Country   | Regulation | Requirements Met |
      | Canada    | CASL       | Yes              |
      | Australia | Spam Act   | Yes              |
      | UK        | PECR       | Yes              |
    And non-compliant sends are blocked with reason logged
