@admin @announcement-system
Feature: Admin Announcement System
  As a platform administrator
  I want to manage platform-wide announcements and notifications
  So that I can communicate effectively with all users

  Background:
    Given I am logged in as a platform administrator
    And I have announcement management permissions

  # =============================================================================
  # ANNOUNCEMENT DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View announcement dashboard
    When I navigate to the announcement dashboard
    Then I should see announcement overview metrics:
      | Metric                    | Description                      |
      | Active announcements      | Currently displayed              |
      | Scheduled announcements   | Pending future delivery          |
      | Draft announcements       | Unpublished drafts               |
      | Total sent (30 days)      | Recent announcements sent        |
      | Average engagement rate   | Open/read rate                   |
      | Pending approvals         | Awaiting approval                |
    And I should see recent announcement activity
    And I should see upcoming scheduled announcements
    And I should see announcement performance trends

  @dashboard @list
  Scenario: View and manage announcement list
    When I view the announcement list
    Then I should see all announcements with:
      | Field                | Description                      |
      | Title                | Announcement title               |
      | Type                 | System, feature, maintenance     |
      | Status               | Draft, scheduled, active, ended  |
      | Target audience      | Who receives it                  |
      | Delivery channels    | Email, in-app, push, etc.        |
      | Created by           | Author                           |
      | Created date         | When created                     |
      | Publish date         | When published/scheduled         |
    And I should be able to filter by status and type
    And I should be able to search announcements
    And I should be able to sort by any column

  @dashboard @calendar
  Scenario: View announcement calendar
    When I access the announcement calendar
    Then I should see announcements on a calendar view
    And I should see:
      | Calendar Element      | Information                      |
      | Scheduled sends       | Future announcement dates        |
      | Active periods        | When announcements are visible   |
      | Blackout dates        | Dates to avoid announcements     |
      | Conflicts             | Overlapping announcements        |
    And I should be able to drag and drop to reschedule
    And I should switch between day, week, and month views

  @dashboard @quick-actions
  Scenario: Access quick announcement actions
    When I use quick actions from the dashboard
    Then I should be able to:
      | Quick Action          | Description                      |
      | Create announcement   | Start new announcement           |
      | Duplicate             | Copy existing announcement       |
      | Preview               | View how it will appear          |
      | Pause                 | Temporarily stop active          |
      | Resume                | Restart paused announcement      |
      | Archive               | Move to archive                  |

  # =============================================================================
  # ANNOUNCEMENT CREATION
  # =============================================================================

  @create @basic
  Scenario: Create system announcement
    When I create a new announcement
    Then I should be able to specify:
      | Field                 | Options                          |
      | Title                 | Announcement title               |
      | Announcement type     | System, feature, maintenance     |
      | Priority              | Critical, high, normal, low      |
      | Content               | Rich text with formatting        |
      | Call to action        | Button text and link             |
      | Expiration            | When to stop showing             |
    And I should be able to save as draft
    And I should be able to preview before publishing

  @create @rich-content
  Scenario: Create announcement with rich content
    When I compose announcement content
    Then I should have access to:
      | Content Feature       | Description                      |
      | Rich text editor      | Formatting, lists, links         |
      | Image upload          | Add images to content            |
      | Video embed           | Embed videos                     |
      | File attachments      | Attach documents                 |
      | Emoji support         | Add emojis                       |
      | Code blocks           | Technical announcements          |
      | Tables                | Structured information           |
    And I should see character/word count
    And I should have auto-save functionality

  @create @types
  Scenario: Create different announcement types
    When I select announcement type
    Then I should be able to choose from:
      | Type                  | Use Case                         |
      | System update         | Platform changes                 |
      | New feature           | Feature launches                 |
      | Maintenance           | Scheduled downtime               |
      | Security alert        | Security notifications           |
      | Policy update         | Terms/policy changes             |
      | Event                 | Upcoming events                  |
      | Promotional           | Marketing announcements          |
      | Survey/feedback       | User feedback requests           |
    And each type should have appropriate templates
    And each type should have default styling

  @create @banner
  Scenario: Create banner announcement
    When I create a banner announcement
    Then I should be able to configure:
      | Banner Setting        | Options                          |
      | Position              | Top, bottom, floating            |
      | Style                 | Info, warning, success, error    |
      | Dismissible           | Can user dismiss                 |
      | Sticky                | Stays visible on scroll          |
      | Animation             | Slide, fade, none                |
      | Background color      | Custom or preset                 |
      | Icon                  | Optional icon display            |
    And I should preview banner appearance
    And I should set banner display rules

  @create @modal
  Scenario: Create modal announcement
    When I create a modal announcement
    Then I should be able to configure:
      | Modal Setting         | Options                          |
      | Size                  | Small, medium, large, fullscreen |
      | Backdrop              | Clickable to dismiss or not      |
      | Close button          | Show or hide                     |
      | Buttons               | Primary, secondary actions       |
      | Image/video           | Header media                     |
      | Animation             | Entry/exit animations            |
    And I should set modal trigger conditions
    And I should configure modal frequency

  # =============================================================================
  # ANNOUNCEMENT TARGETING
  # =============================================================================

  @targeting @audience
  Scenario: Configure announcement targeting
    When I configure audience targeting
    Then I should be able to target by:
      | Target Criteria       | Options                          |
      | All users             | Platform-wide                    |
      | User role             | Admin, user, guest               |
      | Subscription tier     | Free, premium, enterprise        |
      | Account age           | New, established, veteran        |
      | Geographic location   | Country, region, timezone        |
      | Language preference   | User's language setting          |
      | Activity level        | Active, dormant, churned         |
      | Feature usage         | Users of specific features       |
    And I should see estimated audience size
    And I should be able to combine criteria

  @targeting @segments
  Scenario: Target user segments
    When I target specific user segments
    Then I should be able to:
      | Segment Action        | Description                      |
      | Select saved segments | Choose pre-defined segments      |
      | Create new segment    | Define custom segment            |
      | Combine segments      | AND/OR segment logic             |
      | Exclude segments      | Remove specific users            |
      | Import list           | Upload user list                 |
    And I should see segment overlap analysis
    And I should validate targeting before send

  @targeting @behavioral
  Scenario: Configure behavioral targeting
    When I set up behavioral targeting
    Then I should be able to target based on:
      | Behavior              | Trigger Condition                |
      | First login           | User's first session             |
      | Feature discovery     | First use of feature             |
      | Inactivity            | Days since last active           |
      | Cart abandonment      | Incomplete purchase              |
      | Upgrade eligibility   | Ready for upsell                 |
      | Renewal approaching   | Subscription near expiry         |
    And I should set behavior timing windows
    And I should configure frequency caps

  @targeting @exclusions
  Scenario: Configure audience exclusions
    When I configure targeting exclusions
    Then I should be able to exclude:
      | Exclusion Type        | Description                      |
      | Previous recipients   | Already received this            |
      | Recent recipients     | Received any in X days           |
      | Opted-out users       | Notification preferences         |
      | Specific users        | Individual exclusions            |
      | User segments         | Entire segments                  |
    And exclusions should be applied before send
    And I should see exclusion impact on audience size

  # =============================================================================
  # ANNOUNCEMENT TEMPLATES
  # =============================================================================

  @template @management
  Scenario: Manage announcement templates
    When I access template management
    Then I should see available templates:
      | Template Category     | Examples                         |
      | System updates        | Maintenance, upgrades            |
      | Feature launches      | New feature, improvement         |
      | Promotional           | Discount, event                  |
      | Security              | Alert, breach notification       |
      | Transactional         | Welcome, renewal reminder        |
    And I should be able to preview templates
    And I should see template usage statistics

  @template @create
  Scenario: Create custom announcement template
    When I create a new template
    Then I should be able to define:
      | Template Element      | Configuration                    |
      | Template name         | Unique identifier                |
      | Category              | Template grouping                |
      | Layout                | Structure and design             |
      | Placeholders          | Dynamic content fields           |
      | Default styling       | Colors, fonts, spacing           |
      | Required fields       | Mandatory content areas          |
    And I should save template for reuse
    And I should set template permissions

  @template @variables
  Scenario: Use template variables
    When I use templates with variables
    Then I should have access to:
      | Variable Type         | Examples                         |
      | User variables        | {{first_name}}, {{email}}        |
      | Account variables     | {{company}}, {{plan_name}}       |
      | Date variables        | {{current_date}}, {{expiry}}     |
      | Custom variables      | User-defined placeholders        |
      | Conditional content   | IF/THEN content blocks           |
    And variables should auto-populate
    And I should preview with sample data

  @template @branding
  Scenario: Configure template branding
    When I configure template branding
    Then I should be able to set:
      | Branding Element      | Configuration                    |
      | Logo                  | Header logo image                |
      | Colors                | Brand color palette              |
      | Fonts                 | Typography settings              |
      | Footer                | Standard footer content          |
      | Social links          | Social media icons/links         |
      | Legal text            | Terms, privacy links             |
    And branding should apply across templates
    And I should maintain brand consistency

  # =============================================================================
  # DELIVERY CHANNELS
  # =============================================================================

  @delivery @channels
  Scenario: Configure delivery channels
    When I configure announcement delivery
    Then I should be able to select:
      | Channel               | Configuration                    |
      | In-app notification   | Banner, modal, toast             |
      | Email                 | HTML or plain text               |
      | Push notification     | Mobile and web push              |
      | SMS                   | Text message                     |
      | Slack                 | Workspace integration            |
      | Webhook               | External system notification     |
    And I should configure channel-specific content
    And I should set channel priorities

  @delivery @in-app
  Scenario: Configure in-app announcement display
    When I configure in-app delivery
    Then I should be able to set:
      | Display Setting       | Options                          |
      | Display location      | Dashboard, specific pages        |
      | Display format        | Banner, modal, sidebar, toast    |
      | Display timing        | Immediate, delayed, triggered    |
      | Display frequency     | Once, recurring, persistent      |
      | Dismissal behavior    | Remember, reset, never dismiss   |
    And I should preview in-app appearance
    And I should configure page-specific rules

  @delivery @email
  Scenario: Configure email announcement delivery
    When I configure email delivery
    Then I should be able to set:
      | Email Setting         | Configuration                    |
      | Subject line          | With A/B testing option          |
      | Preheader text        | Email preview text               |
      | From name             | Sender display name              |
      | Reply-to address      | Response handling                |
      | Email template        | HTML layout selection            |
      | Plain text version    | Fallback content                 |
    And I should preview email rendering
    And I should test across email clients

  @delivery @push
  Scenario: Configure push notification delivery
    When I configure push notifications
    Then I should be able to set:
      | Push Setting          | Configuration                    |
      | Title                 | Notification title               |
      | Body                  | Short message content            |
      | Icon                  | Notification icon                |
      | Image                 | Rich notification image          |
      | Action buttons        | Interactive buttons              |
      | Deep link             | App destination                  |
      | Sound                 | Notification sound               |
    And I should configure platform-specific settings
    And I should respect device notification settings

  @delivery @multi-channel
  Scenario: Configure multi-channel delivery
    When I set up multi-channel delivery
    Then I should be able to:
      | Multi-channel Config  | Description                      |
      | Channel sequence      | Order of channel delivery        |
      | Channel fallback      | If primary fails, try secondary  |
      | Channel coordination  | Prevent duplicate messaging      |
      | Timing offsets        | Delay between channels           |
      | Stop conditions       | Stop if user engages             |
    And I should see delivery status by channel
    And I should analyze cross-channel performance

  # =============================================================================
  # ANNOUNCEMENT SCHEDULING
  # =============================================================================

  @schedule @future
  Scenario: Schedule future announcements
    When I schedule an announcement for the future
    Then I should be able to set:
      | Schedule Setting      | Options                          |
      | Publish date          | Specific date and time           |
      | Timezone              | Target timezone                  |
      | Optimal time          | AI-suggested best time           |
      | Time window           | Range for delivery               |
    And I should see scheduled announcement in calendar
    And I should receive confirmation of scheduling

  @schedule @recurring
  Scenario: Set up recurring announcements
    When I configure recurring announcements
    Then I should be able to set:
      | Recurrence Pattern    | Options                          |
      | Daily                 | Every day at specific time       |
      | Weekly                | Specific days of week            |
      | Monthly               | Specific date or day of month    |
      | Custom                | Complex recurrence rules         |
    And I should set:
      | Recurrence Setting    | Configuration                    |
      | Start date            | When to begin                    |
      | End date              | When to stop                     |
      | Max occurrences       | Limit number of sends            |
      | Skip conditions       | Skip holidays, weekends          |
    And I should see all future occurrences

  @schedule @timezone
  Scenario: Handle timezone-aware scheduling
    When I schedule timezone-aware delivery
    Then I should be able to:
      | Timezone Option       | Description                      |
      | Sender timezone       | Based on admin's timezone        |
      | Recipient timezone    | Based on user's timezone         |
      | Specific timezone     | Fixed timezone delivery          |
      | Optimal by region     | Best time per region             |
    And I should see delivery time by recipient location
    And I should handle daylight saving transitions

  @schedule @expiration
  Scenario: Configure announcement expiration
    When I configure announcement expiration
    Then I should be able to set:
      | Expiration Type       | Configuration                    |
      | Time-based            | Expires at specific date/time    |
      | Duration-based        | Expires after X hours/days       |
      | Event-based           | Expires when condition met       |
      | Never expire          | Persistent announcement          |
    And I should configure post-expiration behavior
    And I should receive expiration notifications

  # =============================================================================
  # EMERGENCY ANNOUNCEMENTS
  # =============================================================================

  @emergency @broadcast
  Scenario: Send emergency announcement
    When I send an emergency announcement
    Then I should have expedited workflow:
      | Emergency Feature     | Description                      |
      | Bypass approval       | Skip approval workflow           |
      | Priority delivery     | Immediate send                   |
      | All channels          | Simultaneous multi-channel       |
      | Override preferences  | Ignore user opt-outs             |
      | High visibility       | Maximum prominence               |
    And emergency should be logged with justification
    And I should notify stakeholders of emergency send

  @emergency @templates
  Scenario: Use emergency announcement templates
    When I access emergency templates
    Then I should see pre-approved templates for:
      | Emergency Type        | Template Content                 |
      | Security incident     | Breach notification              |
      | System outage         | Service disruption               |
      | Data issue            | Data integrity problem           |
      | Safety alert          | User safety concern              |
      | Regulatory            | Urgent compliance notice         |
    And templates should have pre-configured settings
    And I should customize as needed

  @emergency @escalation
  Scenario: Configure emergency escalation
    When I configure emergency escalation
    Then I should be able to set:
      | Escalation Setting    | Configuration                    |
      | Auto-escalation       | Escalate if not acknowledged     |
      | Escalation path       | Who to notify next               |
      | Escalation timing     | How long before escalation       |
      | Required actions      | What recipient must do           |
    And I should track acknowledgment status
    And I should see escalation history

  # =============================================================================
  # PERSONALIZATION
  # =============================================================================

  @personalization @content
  Scenario: Personalize announcement content
    When I personalize announcement content
    Then I should be able to use:
      | Personalization Type  | Examples                         |
      | User attributes       | Name, role, location             |
      | Account attributes    | Company, plan, tenure            |
      | Behavior data         | Last action, usage patterns      |
      | Preferences           | Language, timezone               |
      | Dynamic content       | Conditional content blocks       |
    And personalization should preview correctly
    And I should test with sample users

  @personalization @dynamic
  Scenario: Configure dynamic content blocks
    When I set up dynamic content
    Then I should be able to create:
      | Dynamic Block Type    | Description                      |
      | Conditional text      | Different text by segment        |
      | Conditional images    | Different images by attribute    |
      | Conditional CTAs      | Different actions by user        |
      | Recommendations       | Personalized suggestions         |
      | Usage summaries       | User-specific data               |
    And I should set fallback content
    And I should validate all variations

  @personalization @ab-testing
  Scenario: A/B test personalization strategies
    When I A/B test personalization
    Then I should be able to test:
      | Test Element          | Variations                       |
      | Subject lines         | Different headlines              |
      | Content blocks        | Different body content           |
      | CTAs                  | Different call to action         |
      | Images                | Different visuals                |
      | Send times            | Different delivery times         |
    And I should set test parameters
    And I should see winning variation

  # =============================================================================
  # APPROVAL WORKFLOW
  # =============================================================================

  @approval @workflow
  Scenario: Configure announcement approval
    When I configure approval workflow
    Then I should be able to set:
      | Approval Setting      | Configuration                    |
      | Approval required     | Which types need approval        |
      | Approvers             | Who can approve                  |
      | Approval levels       | Single or multi-level            |
      | Timeout               | Auto-escalation timing           |
      | Delegation            | Backup approvers                 |
    And I should define approval criteria
    And I should track approval history

  @approval @submit
  Scenario: Submit announcement for approval
    When I submit for approval
    Then the system should:
      | Submission Action     | Description                      |
      | Validate content      | Check for required elements      |
      | Notify approvers      | Alert assigned approvers         |
      | Lock content          | Prevent edits during approval    |
      | Track status          | Show approval progress           |
      | Allow recall          | Enable author to recall          |
    And approvers should receive notification
    And I should see approval queue position

  @approval @review
  Scenario: Review and approve announcements
    When I review announcements for approval
    Then I should be able to:
      | Review Action         | Description                      |
      | Preview announcement  | See full content                 |
      | View targeting        | See audience definition          |
      | Check compliance      | Verify content guidelines        |
      | Approve               | Approve for publishing           |
      | Reject                | Reject with feedback             |
      | Request changes       | Ask for modifications            |
    And I should provide approval comments
    And approval should be logged

  # =============================================================================
  # PERFORMANCE TRACKING
  # =============================================================================

  @performance @metrics
  Scenario: Track announcement performance
    When I view announcement performance
    Then I should see metrics:
      | Metric                | Description                      |
      | Delivery rate         | Successfully delivered           |
      | Open rate             | Email/notification opened        |
      | Click rate            | CTA clicks                       |
      | Read rate             | In-app content read              |
      | Dismissal rate        | How quickly dismissed            |
      | Engagement time       | Time spent reading               |
    And I should see metrics by channel
    And I should see trends over time

  @performance @engagement
  Scenario: Analyze announcement engagement
    When I analyze engagement
    Then I should see:
      | Engagement Metric     | Information                      |
      | Click heatmap         | Where users clicked              |
      | Scroll depth          | How far users read               |
      | Time on content       | Reading duration                 |
      | CTA performance       | Button click comparison          |
      | Device breakdown      | Engagement by device             |
    And I should compare against benchmarks
    And I should identify optimization opportunities

  @performance @comparison
  Scenario: Compare announcement performance
    When I compare announcements
    Then I should be able to compare:
      | Comparison Type       | Metrics Compared                 |
      | A/B test results      | Variant performance              |
      | Time period           | Performance over time            |
      | Type comparison       | Different announcement types     |
      | Channel comparison    | Performance by channel           |
    And I should see statistical significance
    And I should export comparison reports

  @performance @attribution
  Scenario: Track announcement attribution
    When I view attribution analytics
    Then I should see:
      | Attribution Metric    | Information                      |
      | Feature adoption      | Announcements driving adoption   |
      | Conversion impact     | Influence on conversions         |
      | Engagement lift       | Impact on platform engagement    |
      | Revenue attribution   | Announcements driving revenue    |
    And I should see attribution by announcement
    And I should calculate ROI

  # =============================================================================
  # USER PREFERENCES
  # =============================================================================

  @preferences @management
  Scenario: Manage user notification preferences
    When I manage notification preferences
    Then I should see:
      | Preference Setting    | Options                          |
      | Channel preferences   | Preferred delivery channels      |
      | Frequency preferences | How often to receive             |
      | Type preferences      | Which announcement types         |
      | Quiet hours           | Do not disturb periods           |
      | Unsubscribe status    | Opt-out status                   |
    And I should see preference distribution
    And I should respect legal requirements

  @preferences @defaults
  Scenario: Configure default preferences
    When I configure default preferences
    Then I should be able to set:
      | Default Setting       | Configuration                    |
      | New user defaults     | Initial preference settings      |
      | Mandatory channels    | Channels users cannot disable    |
      | Preference templates  | Pre-configured preference sets   |
      | Preference limits     | Minimum/maximum settings         |
    And defaults should be applied to new users
    And I should allow user customization

  @preferences @compliance
  Scenario: Ensure preference compliance
    When I verify preference compliance
    Then the system should:
      | Compliance Check      | Verification                     |
      | GDPR consent          | Verify consent status            |
      | CAN-SPAM compliance   | Honor unsubscribe requests       |
      | CCPA requirements     | California privacy compliance    |
      | Opt-out processing    | Timely preference updates        |
    And I should see compliance status
    And I should audit preference changes

  # =============================================================================
  # CONTENT MODERATION
  # =============================================================================

  @moderation @review
  Scenario: Moderate announcement content
    When I moderate announcement content
    Then I should check for:
      | Moderation Check      | Criteria                         |
      | Brand guidelines      | Tone, style, messaging           |
      | Legal compliance      | Terms, disclosures               |
      | Accessibility         | Alt text, contrast, readability  |
      | Link validation       | Working links                    |
      | Sensitive content     | Inappropriate content            |
      | Factual accuracy      | Correct information              |
    And I should provide moderation feedback
    And I should track moderation history

  @moderation @auto
  Scenario: Configure automated moderation
    When I configure auto-moderation
    Then I should be able to set:
      | Auto-moderation Rule  | Configuration                    |
      | Keyword filters       | Blocked words/phrases            |
      | Link whitelist        | Approved domains                 |
      | Image scanning        | Inappropriate image detection    |
      | Spam detection        | Promotional content limits       |
      | Tone analysis         | Sentiment appropriateness        |
    And flagged content should be queued for review
    And I should configure auto-action rules

  @moderation @guidelines
  Scenario: Manage content guidelines
    When I manage content guidelines
    Then I should be able to:
      | Guideline Action      | Description                      |
      | Define guidelines     | Document content standards       |
      | Share guidelines      | Make available to creators       |
      | Update guidelines     | Modify as needed                 |
      | Check compliance      | Verify against guidelines        |
      | Train creators        | Educate on guidelines            |
    And guidelines should be version controlled
    And I should track guideline violations

  # =============================================================================
  # LOCALIZATION
  # =============================================================================

  @localization @languages
  Scenario: Support multiple languages
    When I configure multi-language support
    Then I should be able to:
      | Localization Action   | Description                      |
      | Add translations      | Provide content in languages     |
      | Auto-translate        | Use translation service          |
      | Set default language  | Fallback language                |
      | Language detection    | Auto-detect user language        |
      | RTL support           | Right-to-left languages          |
    And I should preview each language version
    And I should track translation status

  @localization @regional
  Scenario: Configure regional customization
    When I configure regional content
    Then I should be able to customize:
      | Regional Element      | Customization                    |
      | Date formats          | Local date conventions           |
      | Currency              | Local currency display           |
      | Units                 | Metric/imperial                  |
      | Cultural references   | Region-appropriate content       |
      | Legal requirements    | Region-specific disclosures      |
    And I should set regional defaults
    And I should test regional variations

  @localization @workflow
  Scenario: Manage translation workflow
    When I manage translation workflow
    Then I should be able to:
      | Workflow Step         | Description                      |
      | Request translation   | Send for translation             |
      | Assign translators    | Designate translation resource   |
      | Review translation    | Verify translation quality       |
      | Approve translation   | Sign off on translation          |
      | Sync updates          | Keep translations synchronized   |
    And I should track translation progress
    And I should handle translation versioning

  # =============================================================================
  # EXTERNAL INTEGRATIONS
  # =============================================================================

  @integration @external
  Scenario: Configure external integrations
    When I configure external integrations
    Then I should be able to integrate with:
      | Integration           | Purpose                          |
      | Email service         | Transactional email delivery     |
      | Push service          | Mobile/web push delivery         |
      | SMS gateway           | Text message delivery            |
      | Slack                 | Team notifications               |
      | Microsoft Teams       | Enterprise collaboration         |
      | CRM                   | Customer data sync               |
    And I should configure integration credentials
    And I should test integration connectivity

  @integration @webhooks
  Scenario: Configure announcement webhooks
    When I configure webhooks
    Then I should be able to:
      | Webhook Configuration | Options                          |
      | Trigger events        | What triggers the webhook        |
      | Endpoint URL          | Where to send data               |
      | Payload format        | JSON structure                   |
      | Authentication        | API key, OAuth, etc.             |
      | Retry policy          | Failure retry settings           |
    And I should see webhook delivery logs
    And I should handle webhook failures

  @integration @api
  Scenario: Use announcement API
    When I access the announcement API
    Then I should be able to:
      | API Capability        | Description                      |
      | Create announcements  | Programmatic creation            |
      | Trigger announcements | Event-based triggering           |
      | Query status          | Check delivery status            |
      | Retrieve analytics    | Access performance data          |
      | Manage templates      | CRUD template operations         |
    And API should be documented
    And API should have rate limits

  # =============================================================================
  # USER FEEDBACK
  # =============================================================================

  @feedback @collection
  Scenario: Collect announcement feedback
    When I configure feedback collection
    Then I should be able to:
      | Feedback Option       | Configuration                    |
      | Reaction buttons      | Like, helpful, not helpful       |
      | Star rating           | 1-5 star rating                  |
      | Text feedback         | Open comment field               |
      | Survey link           | Link to detailed survey          |
      | Feedback timing       | When to request feedback         |
    And I should see feedback aggregation
    And I should analyze feedback trends

  @feedback @analysis
  Scenario: Analyze announcement feedback
    When I analyze feedback
    Then I should see:
      | Feedback Analysis     | Information                      |
      | Sentiment score       | Positive/negative ratio          |
      | Common themes         | Frequent feedback topics         |
      | Segment breakdown     | Feedback by user segment         |
      | Trend analysis        | Feedback over time               |
      | Actionable insights   | Recommendations from feedback    |
    And I should export feedback data
    And I should track feedback resolution

  @feedback @response
  Scenario: Respond to announcement feedback
    When I respond to feedback
    Then I should be able to:
      | Response Action       | Description                      |
      | Acknowledge           | Thank for feedback               |
      | Respond               | Address specific feedback        |
      | Follow up             | Request more details             |
      | Close loop            | Report action taken              |
    And responses should be tracked
    And I should measure response impact

  # =============================================================================
  # ARCHIVE MANAGEMENT
  # =============================================================================

  @archive @management
  Scenario: Manage announcement archive
    When I access announcement archive
    Then I should see archived announcements with:
      | Archive Field         | Information                      |
      | Announcement title    | Original title                   |
      | Archive date          | When archived                    |
      | Original dates        | Publish and end dates            |
      | Performance summary   | Final metrics                    |
      | Target audience       | Who received it                  |
    And I should search archived announcements
    And I should filter by date range and type

  @archive @retention
  Scenario: Configure archive retention
    When I configure archive retention
    Then I should be able to set:
      | Retention Setting     | Configuration                    |
      | Retention period      | How long to keep                 |
      | Auto-archive          | When to auto-archive             |
      | Permanent archive     | Never delete certain types       |
      | Compliance retention  | Legal retention requirements     |
    And I should see retention schedule
    And I should receive deletion warnings

  @archive @restore
  Scenario: Restore archived announcement
    When I restore an archived announcement
    Then I should be able to:
      | Restore Option        | Description                      |
      | Restore as new        | Create copy for new send         |
      | Restore as template   | Save as template                 |
      | View only             | Read-only access                 |
      | Export                | Download for reference           |
    And restoration should preserve history
    And I should update content as needed

  # =============================================================================
  # DELIVERY OPTIMIZATION
  # =============================================================================

  @optimization @timing
  Scenario: Optimize announcement delivery
    When I optimize delivery timing
    Then the system should analyze:
      | Optimization Factor   | Analysis                         |
      | Historical engagement | Best past performance times      |
      | User activity         | When users are most active       |
      | Timezone distribution | Optimal times by timezone        |
      | Channel performance   | Best times per channel           |
    And I should see recommended send times
    And I should use AI-powered optimization

  @optimization @frequency
  Scenario: Optimize announcement frequency
    When I manage announcement frequency
    Then I should be able to:
      | Frequency Control     | Configuration                    |
      | Global caps           | Max announcements per period     |
      | Per-user caps         | Individual frequency limits      |
      | Type caps             | Limits by announcement type      |
      | Fatigue detection     | Identify over-messaged users     |
    And I should see frequency impact analysis
    And I should balance reach and fatigue

  @optimization @content
  Scenario: Optimize announcement content
    When I optimize content
    Then I should receive suggestions for:
      | Content Optimization  | Recommendation                   |
      | Subject lines         | Higher open rate suggestions     |
      | CTAs                  | More effective call to actions   |
      | Content length        | Optimal length for engagement    |
      | Imagery               | Image recommendations            |
      | Personalization       | Additional personalization opps  |
    And suggestions should be data-driven
    And I should A/B test recommendations

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient announcement permissions
    Given I do not have announcement management permissions
    When I attempt to access announcement features
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @delivery-failed
  Scenario: Handle announcement delivery failure
    Given I am sending an announcement
    When delivery fails for some recipients
    Then I should see delivery failure report
    And I should see failure reasons:
      | Failure Reason        | Suggested Action                 |
      | Invalid email         | Update contact info              |
      | Bounce                | Remove from list                 |
      | Blocked               | Check spam reputation            |
      | Opt-out               | Respect preferences              |
    And I should be able to retry failed deliveries

  @error @template-error
  Scenario: Handle template rendering error
    Given I am using a template with variables
    When a variable cannot be resolved
    Then I should see which variables failed
    And I should see fallback behavior applied
    And I should be able to fix variable mappings
    And failed sends should be logged

  @error @scheduling-conflict
  Scenario: Handle scheduling conflicts
    Given I am scheduling an announcement
    When there is a scheduling conflict
    Then I should see the conflict details
    And I should see suggestions:
      | Resolution Option     | Description                      |
      | Reschedule            | Choose different time            |
      | Override              | Send anyway with notification    |
      | Combine               | Merge with existing              |
    And I should resolve the conflict

  @error @quota-exceeded
  Scenario: Handle sending quota exceeded
    Given there are sending limits configured
    When I exceed the sending quota
    Then I should see quota exceeded message
    And I should see current usage vs limit
    And I should see options:
      | Quota Option          | Description                      |
      | Wait                  | Wait for quota reset             |
      | Request increase      | Request higher limit             |
      | Prioritize            | Choose most important recipients |
    And I should plan future sends accordingly
