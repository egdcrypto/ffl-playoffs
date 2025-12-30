@admin @support @tools @debugging
Feature: Admin Support Tools
  As a platform administrator
  I want to access powerful support and debugging tools
  So that I can efficiently resolve user issues and investigate problems

  Background:
    Given I am logged in as a platform administrator
    And I have support tools permissions
    And the support tools system is operational

  # ===========================================
  # SUPPORT DASHBOARD
  # ===========================================

  @dashboard @overview
  Scenario: View support tools dashboard
    Given I am on the admin dashboard
    When I navigate to the support tools section
    Then I should see the support tools dashboard
    And I should see user search functionality
    And I should see recent support activities
    And I should see active impersonation sessions
    And I should see quick action buttons
    And I should see support queue metrics

  @dashboard @search
  Scenario: Search for users in support tools
    Given I am on the support tools dashboard
    When I enter a user search query
    Then I should see matching user results
    And each result should show user ID
    And each result should show email address
    And each result should show account status
    And each result should show last activity
    And I should be able to click to view user details

  @dashboard @search-advanced
  Scenario: Perform advanced user search
    Given I am on the support tools dashboard
    When I click on advanced search
    Then I should see advanced search options
    And I should be able to search by user ID
    And I should be able to search by email
    And I should be able to search by phone number
    And I should be able to search by transaction ID
    And I should be able to search by IP address
    And I should be able to combine multiple criteria

  @dashboard @recent-activity
  Scenario: View recent support activities
    Given I am on the support tools dashboard
    When I view the recent activities panel
    Then I should see recent impersonation sessions
    And I should see recent data modifications
    And I should see recent debug sessions
    And I should see recent query executions
    And each activity should show the administrator who performed it
    And each activity should show timestamp

  @dashboard @quick-actions
  Scenario: Access quick action shortcuts
    Given I am on the support tools dashboard
    When I view the quick actions panel
    Then I should see "Impersonate User" action
    And I should see "Reset Password" action
    And I should see "Unlock Account" action
    And I should see "View Logs" action
    And I should see "Generate Report" action
    And I should be able to customize quick actions

  # ===========================================
  # USER IMPERSONATION
  # ===========================================

  @impersonation @start
  Scenario: Impersonate user account
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Impersonate User"
    Then I should see an impersonation confirmation dialog
    And I should see the user details being impersonated
    And I should be required to provide a reason
    When I confirm the impersonation
    Then I should be logged in as the impersonated user
    And I should see an impersonation indicator banner
    And the impersonation should be logged for audit

  @impersonation @reason
  Scenario: Require reason for impersonation
    Given I am initiating user impersonation
    When the impersonation dialog appears
    Then I must provide a reason for impersonation
    And I should see reason category options
    And I should be able to enter custom reason text
    And the reason should be linked to a support ticket
    And I cannot proceed without providing a reason

  @impersonation @restrictions
  Scenario: Enforce impersonation restrictions
    Given I am attempting to impersonate a user
    When the user has impersonation restrictions
    Then I should see a restriction notice
    And I should see what restrictions apply
    And I should see who can grant access
    And I should not be able to impersonate protected accounts
    And attempts should be logged for security

  @impersonation @actions
  Scenario: Perform actions while impersonating
    Given I am impersonating a user account
    When I navigate the platform as the user
    Then I should see the user's dashboard
    And I should see the user's data
    And I should be able to perform allowed actions
    But I should not be able to perform restricted actions
    And all actions should be logged as impersonated
    And the impersonation banner should remain visible

  @impersonation @allowed-actions
  Scenario: View allowed actions during impersonation
    Given I am impersonating a user account
    When I view my impersonation permissions
    Then I should see which actions I can perform
    And I should be able to view user data
    And I should be able to submit forms as user
    And I should be able to test user workflows
    But I should not be able to change password
    But I should not be able to modify security settings

  @impersonation @restricted-actions
  Scenario: Block restricted actions during impersonation
    Given I am impersonating a user account
    When I attempt a restricted action
    Then the action should be blocked
    And I should see a restriction message
    And I should see why the action is restricted
    And I should see how to request the action
    And the attempt should be logged

  @impersonation @end
  Scenario: End user impersonation session
    Given I am impersonating a user account
    When I click "End Impersonation"
    Then I should see an end session confirmation
    And I should be returned to my admin account
    And I should see a session summary
    And the session end should be logged
    And any temporary tokens should be invalidated

  @impersonation @timeout
  Scenario: Handle impersonation session timeout
    Given I am impersonating a user account
    And the impersonation session has a time limit
    When the session timeout approaches
    Then I should see a timeout warning
    And I should be able to extend the session
    When the session times out
    Then the impersonation should end automatically
    And I should be returned to my admin account
    And the timeout should be logged

  # ===========================================
  # DEBUG MODE
  # ===========================================

  @debug @enable
  Scenario: Enable debug mode for user
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Enable Debug Mode"
    Then I should see debug mode configuration options
    And I should be able to set debug duration
    And I should be able to select debug components
    And I should be required to provide a reason
    When I enable debug mode
    Then debug mode should be activated for the user
    And debug information should start collecting

  @debug @configuration
  Scenario: Configure debug mode settings
    Given I am enabling debug mode for a user
    When I configure debug settings
    Then I should be able to enable console logging
    And I should be able to enable network request logging
    And I should be able to enable performance profiling
    And I should be able to enable error tracking
    And I should be able to set log verbosity level
    And I should be able to set data retention period

  @debug @view
  Scenario: View debug information
    Given debug mode is enabled for a user
    When I access the debug information panel
    Then I should see real-time log stream
    And I should see error logs
    And I should see network request logs
    And I should see performance metrics
    And I should see user action timeline
    And I should be able to filter and search logs

  @debug @logs
  Scenario: Analyze debug logs in real-time
    Given I am viewing debug information for a user
    When I view the real-time log stream
    Then I should see logs as they occur
    And I should see log severity levels
    And I should see log timestamps
    And I should see log source components
    And I should be able to pause the stream
    And I should be able to download logs

  @debug @errors
  Scenario: View user-specific error information
    Given I am viewing debug information for a user
    When I view the errors panel
    Then I should see all errors encountered
    And I should see error stack traces
    And I should see error context data
    And I should see error frequency
    And I should see related errors grouped
    And I should be able to mark errors as resolved

  @debug @network
  Scenario: Inspect network requests
    Given I am viewing debug information for a user
    When I view the network panel
    Then I should see all API requests made
    And I should see request URLs and methods
    And I should see request and response headers
    And I should see request and response bodies
    And I should see request timing information
    And I should see failed request details

  @debug @disable
  Scenario: Disable debug mode
    Given debug mode is enabled for a user
    When I click "Disable Debug Mode"
    Then debug mode should be deactivated
    And debug data collection should stop
    And I should be able to retain or delete collected data
    And the user should be notified if configured
    And the action should be logged

  # ===========================================
  # USER DATA INSPECTION
  # ===========================================

  @data @inspect
  Scenario: Inspect user data
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Inspect User Data"
    Then I should see a comprehensive data view
    And I should see account information
    And I should see profile data
    And I should see activity history
    And I should see transaction history
    And I should see settings and preferences

  @data @account
  Scenario: View user account information
    Given I am inspecting user data
    When I view the account information section
    Then I should see user ID and identifiers
    And I should see account creation date
    And I should see account status
    And I should see verification status
    And I should see security settings
    And I should see linked accounts

  @data @profile
  Scenario: View user profile details
    Given I am inspecting user data
    When I view the profile section
    Then I should see personal information
    And I should see contact information
    And I should see address information
    And I should see profile completeness
    And I should see profile update history
    And sensitive data should be masked by default

  @data @activity
  Scenario: View user activity history
    Given I am inspecting user data
    When I view the activity history section
    Then I should see login history
    And I should see feature usage history
    And I should see content interaction history
    And I should see session history
    And I should be able to filter by date range
    And I should be able to filter by activity type

  @data @transactions
  Scenario: View user transaction history
    Given I am inspecting user data
    When I view the transaction history section
    Then I should see all financial transactions
    And I should see transaction amounts
    And I should see transaction statuses
    And I should see payment methods used
    And I should see refund history
    And I should see dispute history

  @data @sensitive
  Scenario: Access sensitive user data
    Given I am inspecting user data
    And I have elevated data access permissions
    When I request to view sensitive data
    Then I should be required to provide justification
    And I should acknowledge data access policies
    When I confirm access
    Then sensitive data should be revealed
    And the access should be logged for audit
    And access should be time-limited

  @data @export
  Scenario: Export user data for analysis
    Given I am inspecting user data
    When I click on "Export Data"
    Then I should see export options
    And I should be able to select data sections
    And I should be able to choose export format
    And I should be able to redact sensitive fields
    And the export should be logged
    And I should receive the export securely

  # ===========================================
  # SAFE DATA EDITING
  # ===========================================

  @edit @safely
  Scenario: Edit data safely
    Given I am inspecting user data
    When I click on "Edit Data"
    Then I should see editable fields
    And I should see non-editable fields grayed out
    And I should see field validation rules
    And I should be required to provide a reason
    And I should see change preview before saving

  @edit @validation
  Scenario: Validate data changes before saving
    Given I am editing user data
    When I modify a data field
    Then the field should be validated in real-time
    And I should see validation error messages
    And I should see field format requirements
    And invalid changes should be blocked
    And I should see impact assessment for changes

  @edit @preview
  Scenario: Preview changes before applying
    Given I have made data modifications
    When I click on "Preview Changes"
    Then I should see a diff view of changes
    And I should see old values
    And I should see new values
    And I should see affected related data
    And I should see potential side effects
    And I should be able to modify before confirming

  @edit @approval
  Scenario: Require approval for sensitive changes
    Given I am editing sensitive user data
    When I attempt to save the changes
    Then I should see an approval requirement notice
    And I should submit the change for approval
    And I should specify the approver
    And the change should be queued pending approval
    And I should be notified when approved or rejected

  @edit @history
  Scenario: View data modification history
    Given I am inspecting user data
    When I view the modification history
    Then I should see all past modifications
    And I should see who made each change
    And I should see when changes were made
    And I should see change reasons
    And I should see before and after values
    And I should be able to revert changes

  @edit @revert
  Scenario: Revert data changes
    Given I am viewing data modification history
    When I select a change to revert
    Then I should see what will be reverted
    And I should be required to provide a reason
    When I confirm the revert
    Then the data should be restored to previous state
    And the revert should be logged
    And affected user should be notified if configured

  # ===========================================
  # SESSION MANAGEMENT
  # ===========================================

  @sessions @view
  Scenario: View active sessions
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "View Sessions"
    Then I should see all active sessions
    And I should see session device information
    And I should see session location
    And I should see session start time
    And I should see last activity time
    And I should see session type

  @sessions @details
  Scenario: View session details
    Given I am viewing active sessions for a user
    When I click on a specific session
    Then I should see detailed session information
    And I should see browser and OS details
    And I should see IP address and geolocation
    And I should see session activity log
    And I should see authentication method used
    And I should see security flags

  @sessions @terminate
  Scenario: Terminate user session
    Given I am viewing active sessions for a user
    When I click "Terminate" on a session
    Then I should see a termination confirmation
    And I should be required to provide a reason
    When I confirm termination
    Then the session should be ended
    And the user should be logged out
    And the termination should be logged
    And the user should receive a notification

  @sessions @terminate-all
  Scenario: Terminate all user sessions
    Given I am viewing active sessions for a user
    When I click "Terminate All Sessions"
    Then I should see a bulk termination confirmation
    And I should see the number of sessions affected
    And I should be required to provide a reason
    When I confirm bulk termination
    Then all sessions should be ended
    And the user should receive security notification

  @sessions @history
  Scenario: View session history
    Given I am viewing user sessions
    When I click on "Session History"
    Then I should see past sessions
    And I should see session durations
    And I should see how sessions ended
    And I should see any suspicious sessions flagged
    And I should be able to filter by date range
    And I should be able to export session history

  # ===========================================
  # APPLICATION LOG SEARCH
  # ===========================================

  @logs @search
  Scenario: Search application logs
    Given I am on the support tools dashboard
    When I navigate to the log search section
    Then I should see the log search interface
    And I should see search query input
    And I should see filter options
    And I should see date range selector
    And I should see log source selector

  @logs @query
  Scenario: Build log search query
    Given I am on the log search interface
    When I build a search query
    Then I should be able to search by keyword
    And I should be able to search by user ID
    And I should be able to search by error code
    And I should be able to search by request ID
    And I should be able to use regex patterns
    And I should be able to combine conditions

  @logs @filters
  Scenario: Apply log search filters
    Given I am on the log search interface
    When I configure search filters
    Then I should be able to filter by log level
    And I should be able to filter by service
    And I should be able to filter by environment
    And I should be able to filter by time range
    And I should be able to filter by host
    And I should be able to save filter presets

  @logs @results
  Scenario: View log search results
    Given I have executed a log search
    When the results are displayed
    Then I should see matching log entries
    And I should see log timestamps
    And I should see log severity
    And I should see log messages
    And I should see log context
    And I should be able to expand for details

  @logs @context
  Scenario: View log entry context
    Given I am viewing log search results
    When I click on a log entry
    Then I should see the full log message
    And I should see surrounding log entries
    And I should see related request chain
    And I should see parsed structured data
    And I should be able to copy log details
    And I should be able to share log entry

  @logs @export
  Scenario: Export log search results
    Given I have log search results
    When I click "Export Results"
    Then I should see export format options
    And I should be able to export to JSON
    And I should be able to export to CSV
    And I should be able to export to PDF
    And I should be able to set export limits
    And the export should be logged

  # ===========================================
  # LOG PATTERN ANALYSIS
  # ===========================================

  @logs @patterns
  Scenario: Analyze log patterns
    Given I am on the log search section
    When I navigate to pattern analysis
    Then I should see log pattern dashboard
    And I should see common error patterns
    And I should see trend analysis
    And I should see anomaly detection results
    And I should see pattern correlations

  @logs @trends
  Scenario: View log trends over time
    Given I am on the pattern analysis section
    When I view the trends panel
    Then I should see log volume over time
    And I should see error rate trends
    And I should see latency trends
    And I should see trend comparison periods
    And I should see trend predictions
    And I should see outlier highlighting

  @logs @anomalies
  Scenario: Detect log anomalies
    Given I am on the pattern analysis section
    When I view the anomaly detection panel
    Then I should see detected anomalies
    And I should see anomaly severity
    And I should see anomaly timeframes
    And I should see affected components
    And I should see similar past anomalies
    And I should see recommended actions

  @logs @correlations
  Scenario: View log correlations
    Given I am viewing a log pattern
    When I analyze correlations
    Then I should see related patterns
    And I should see cause-effect relationships
    And I should see temporal correlations
    And I should see service dependency impacts
    And I should see correlation confidence scores

  # ===========================================
  # DATABASE QUERY TOOLS
  # ===========================================

  @query @builder
  Scenario: Build custom database query
    Given I am on the support tools dashboard
    When I navigate to the query builder
    Then I should see the query interface
    And I should see available data sources
    And I should see schema browser
    And I should see query templates
    And I should see syntax highlighting

  @query @visual
  Scenario: Build query using visual builder
    Given I am on the query builder
    When I use the visual query builder
    Then I should be able to select tables
    And I should be able to select columns
    And I should be able to add conditions
    And I should be able to add joins
    And I should be able to add sorting
    And I should see the generated SQL

  @query @manual
  Scenario: Write query manually
    Given I am on the query builder
    When I use the manual query editor
    Then I should see syntax highlighting
    And I should see auto-completion
    And I should see schema suggestions
    And I should see query validation
    And I should see query formatting
    And I should see query history

  @query @validation
  Scenario: Validate query before execution
    Given I have written a query
    When I click "Validate Query"
    Then the query should be syntax checked
    And I should see any syntax errors
    And I should see performance warnings
    And I should see estimated row count
    And I should see estimated execution time
    And dangerous operations should be flagged

  @query @execute
  Scenario: Execute safe queries
    Given I have a validated query
    And the query passes safety checks
    When I click "Execute Query"
    Then the query should be executed
    And I should see query results
    And I should see execution time
    And I should see rows returned count
    And I should be able to page through results
    And the execution should be logged

  @query @restrictions
  Scenario: Block unsafe query operations
    Given I have written a query
    When the query contains unsafe operations
    Then the query should be blocked
    And I should see why it was blocked
    And I should see what operations are restricted
    And I should see how to request elevated access
    And the attempt should be logged

  @query @results
  Scenario: Work with query results
    Given I have query results displayed
    When I interact with the results
    Then I should be able to sort columns
    And I should be able to filter results
    And I should be able to export results
    And I should be able to copy cell values
    And I should be able to save the query
    And I should be able to share results

  @query @templates
  Scenario: Use query templates
    Given I am on the query builder
    When I browse query templates
    Then I should see common support queries
    And I should see query descriptions
    And I should see required parameters
    When I select a template
    Then the template should load into editor
    And I should be prompted for parameters
    And I should be able to customize the query

  # ===========================================
  # ISSUE RESOLUTION TEMPLATES
  # ===========================================

  @resolution @templates
  Scenario: Use issue resolution template
    Given I am on the support tools dashboard
    When I navigate to resolution templates
    Then I should see available templates
    And I should see template categories
    And I should see template usage statistics
    And I should be able to search templates

  @resolution @select
  Scenario: Select and apply resolution template
    Given I am viewing resolution templates
    When I select a template
    Then I should see template steps
    And I should see required actions
    And I should see automated actions available
    And I should see verification steps
    When I apply the template
    Then the resolution workflow should start
    And I should be guided through each step

  @resolution @automated
  Scenario: Execute automated resolution steps
    Given I am using a resolution template
    And the template has automated steps
    When I reach an automated step
    Then I should see what will be automated
    And I should be able to preview the action
    When I confirm execution
    Then the automated action should run
    And I should see the result
    And I should proceed to the next step

  @resolution @create
  Scenario: Create custom resolution template
    Given I am on the resolution templates section
    When I click "Create Template"
    Then I should see the template builder
    And I should be able to add manual steps
    And I should be able to add automated steps
    And I should be able to add conditions
    And I should be able to add verification checks
    And I should be able to set template permissions

  @resolution @modify
  Scenario: Modify existing resolution template
    Given I have permission to edit templates
    When I select a template to edit
    Then I should see the template configuration
    And I should be able to modify steps
    And I should be able to update automation
    And I should see change history
    When I save changes
    Then the template should be versioned
    And team members should be notified

  # ===========================================
  # USER EXPERIENCE PROFILING
  # ===========================================

  @profiling @experience
  Scenario: Profile user experience
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Profile Experience"
    Then I should see user experience metrics
    And I should see performance data
    And I should see user journey visualization
    And I should see friction point analysis
    And I should see comparison to baseline

  @profiling @performance
  Scenario: Analyze user performance metrics
    Given I am profiling user experience
    When I view the performance section
    Then I should see page load times
    And I should see interaction response times
    And I should see client-side errors
    And I should see network latency data
    And I should see device performance impact
    And I should see performance trends

  @profiling @journey
  Scenario: Visualize user journey
    Given I am profiling user experience
    When I view the journey visualization
    Then I should see the user's path through the app
    And I should see time spent at each step
    And I should see drop-off points
    And I should see navigation patterns
    And I should see feature usage flow
    And I should see session recordings if available

  @profiling @friction
  Scenario: Identify friction points
    Given I am profiling user experience
    When I view friction analysis
    Then I should see identified friction points
    And I should see error encounters
    And I should see repeated actions indicating confusion
    And I should see abandonment points
    And I should see rage click detection
    And I should see recommended improvements

  @profiling @comparison
  Scenario: Compare user experience to baseline
    Given I am profiling user experience
    When I view comparison metrics
    Then I should see user metrics vs platform average
    And I should see percentile rankings
    And I should see cohort comparisons
    And I should see temporal comparisons
    And I should identify outlier behaviors

  # ===========================================
  # SUPPORT MACROS
  # ===========================================

  @macros @create
  Scenario: Create support macro
    Given I am on the support tools dashboard
    When I navigate to the macros section
    And I click "Create Macro"
    Then I should see the macro builder
    And I should be able to name the macro
    And I should be able to add action steps
    And I should be able to add conditions
    And I should be able to set parameters
    And I should be able to set permissions

  @macros @actions
  Scenario: Add actions to support macro
    Given I am creating a support macro
    When I add actions to the macro
    Then I should be able to add account actions
    And I should be able to add data modifications
    And I should be able to add notifications
    And I should be able to add delays
    And I should be able to add conditional branches
    And I should be able to add loops

  @macros @execute
  Scenario: Execute support macro
    Given I have support macros available
    When I select a macro to execute
    Then I should see macro details
    And I should see required parameters
    And I should be able to provide parameter values
    When I execute the macro
    Then the macro should run through its steps
    And I should see progress and results
    And the execution should be logged

  @macros @schedule
  Scenario: Schedule macro execution
    Given I have a support macro
    When I click "Schedule Execution"
    Then I should see scheduling options
    And I should be able to set execution time
    And I should be able to set recurrence
    And I should be able to set conditions
    And I should receive notification on completion

  @macros @library
  Scenario: Manage macro library
    Given I am on the macros section
    When I view the macro library
    Then I should see all available macros
    And I should see macro categories
    And I should see usage statistics
    And I should be able to share macros
    And I should be able to clone macros
    And I should be able to archive macros

  # ===========================================
  # IN-APP MESSAGING
  # ===========================================

  @messaging @send
  Scenario: Send in-app message to user
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Send Message"
    Then I should see the message composer
    And I should see message templates
    And I should see rich text editor
    And I should see preview option
    And I should see delivery options

  @messaging @compose
  Scenario: Compose user message
    Given I am composing a message to a user
    When I write the message
    Then I should be able to format text
    And I should be able to add links
    And I should be able to add images
    And I should be able to use variables
    And I should be able to add call-to-action buttons
    And I should see character count

  @messaging @templates
  Scenario: Use message templates
    Given I am composing a message
    When I browse message templates
    Then I should see categorized templates
    And I should see template previews
    When I select a template
    Then the template should load into composer
    And variables should be highlighted
    And I should be prompted to fill variables

  @messaging @delivery
  Scenario: Configure message delivery
    Given I have composed a message
    When I configure delivery options
    Then I should be able to send immediately
    And I should be able to schedule delivery
    And I should be able to set expiration
    And I should be able to set priority level
    And I should be able to request read receipt
    And I should be able to enable reply option

  @messaging @history
  Scenario: View message history with user
    Given I am on user support tools
    When I view message history
    Then I should see all messages sent to user
    And I should see message timestamps
    And I should see delivery status
    And I should see read status
    And I should see user replies
    And I should be able to continue conversation

  # ===========================================
  # DIAGNOSTIC REPORTS
  # ===========================================

  @diagnostics @generate
  Scenario: Generate diagnostic report
    Given I am on the support tools dashboard
    And I have located a user account
    When I click on "Generate Diagnostic Report"
    Then I should see report configuration options
    And I should see available report sections
    And I should be able to select sections to include
    And I should see estimated generation time

  @diagnostics @sections
  Scenario: Configure diagnostic report sections
    Given I am generating a diagnostic report
    When I configure report sections
    Then I should be able to include account summary
    And I should be able to include activity logs
    And I should be able to include error history
    And I should be able to include performance data
    And I should be able to include session data
    And I should be able to include transaction history

  @diagnostics @generate-run
  Scenario: Run diagnostic report generation
    Given I have configured a diagnostic report
    When I click "Generate Report"
    Then the report generation should start
    And I should see generation progress
    And I should be notified when complete
    When the report is ready
    Then I should be able to view the report
    And I should be able to download the report

  @diagnostics @view
  Scenario: View generated diagnostic report
    Given a diagnostic report has been generated
    When I view the report
    Then I should see an executive summary
    And I should see detailed findings
    And I should see identified issues
    And I should see recommendations
    And I should see supporting data
    And I should be able to navigate sections

  @diagnostics @share
  Scenario: Share diagnostic report
    Given I have a generated diagnostic report
    When I click "Share Report"
    Then I should see sharing options
    And I should be able to share with team members
    And I should be able to share with user
    And I should be able to redact sensitive data
    And I should be able to set access expiration
    And sharing should be logged

  # ===========================================
  # BULK SUPPORT OPERATIONS
  # ===========================================

  @bulk @operations
  Scenario: Perform bulk support operations
    Given I am on the support tools dashboard
    When I navigate to bulk operations
    Then I should see bulk operation options
    And I should see user selection interface
    And I should see operation templates
    And I should see safety warnings

  @bulk @select
  Scenario: Select users for bulk operation
    Given I am on the bulk operations section
    When I select users for an operation
    Then I should be able to search and add users
    And I should be able to upload user list
    And I should be able to use saved segments
    And I should see selected user count
    And I should be able to preview selection
    And I should be able to modify selection

  @bulk @configure
  Scenario: Configure bulk operation
    Given I have selected users for bulk operation
    When I configure the operation
    Then I should see available bulk actions
    And I should be able to send bulk messages
    And I should be able to apply bulk updates
    And I should be able to schedule operations
    And I should see estimated completion time

  @bulk @review
  Scenario: Review bulk operation before execution
    Given I have configured a bulk operation
    When I review the operation
    Then I should see operation summary
    And I should see affected user count
    And I should see sample of changes
    And I should see rollback options
    And I should see approval requirements if any
    And I should acknowledge potential impact

  @bulk @execute
  Scenario: Execute bulk operation
    Given I have reviewed a bulk operation
    When I execute the operation
    Then the operation should process in batches
    And I should see real-time progress
    And I should see success and failure counts
    And I should be able to pause if needed
    And I should receive completion notification
    And a detailed report should be generated

  @bulk @rollback
  Scenario: Rollback bulk operation
    Given a bulk operation has been executed
    When I need to rollback the operation
    Then I should see rollback options
    And I should see what will be reverted
    And I should be able to do full rollback
    And I should be able to do partial rollback
    When I confirm rollback
    Then the changes should be reverted
    And affected users should be notified

  # ===========================================
  # SUPPORT TOOL USAGE ANALYTICS
  # ===========================================

  @usage @analytics
  Scenario: View support tool usage
    Given I am on the support tools dashboard
    When I navigate to usage analytics
    Then I should see tool usage dashboard
    And I should see usage by administrator
    And I should see usage by tool type
    And I should see usage trends
    And I should see efficiency metrics

  @usage @administrator
  Scenario: View administrator activity
    Given I am on the usage analytics section
    When I view administrator activity
    Then I should see actions per administrator
    And I should see tool preferences
    And I should see resolution rates
    And I should see time spent per case
    And I should see activity patterns
    And I should be able to filter by date range

  @usage @tools
  Scenario: Analyze tool effectiveness
    Given I am on the usage analytics section
    When I view tool effectiveness metrics
    Then I should see most used tools
    And I should see tool success rates
    And I should see average resolution time by tool
    And I should see tool adoption trends
    And I should see underutilized tools
    And I should see tool feedback scores

  @usage @audit
  Scenario: View comprehensive audit trail
    Given I am on the usage analytics section
    When I view the audit trail
    Then I should see all support actions taken
    And I should see action timestamps
    And I should see action outcomes
    And I should see affected resources
    And I should be able to filter and search
    And I should be able to export audit logs

  # ===========================================
  # PERMISSION MANAGEMENT
  # ===========================================

  @permissions @manage
  Scenario: Manage support tool permissions
    Given I am an admin with permission management access
    When I navigate to permissions management
    Then I should see permission groups
    And I should see individual permissions
    And I should see role assignments
    And I should see permission inheritance

  @permissions @roles
  Scenario: Configure permission roles
    Given I am managing support tool permissions
    When I configure a role
    Then I should see all available permissions
    And I should be able to grant tool access
    And I should be able to set data access levels
    And I should be able to set action limits
    And I should be able to set approval requirements
    And I should be able to set time restrictions

  @permissions @assign
  Scenario: Assign permissions to administrators
    Given I am managing permissions
    When I assign permissions to an administrator
    Then I should be able to select roles
    And I should be able to grant individual permissions
    And I should be able to set permission scope
    And I should be able to set expiration
    And the assignment should require approval if configured

  @permissions @review
  Scenario: Review permission assignments
    Given I am managing permissions
    When I review current assignments
    Then I should see all permission holders
    And I should see their access levels
    And I should see last permission use
    And I should see expiring permissions
    And I should be able to revoke permissions
    And I should be able to bulk modify

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @user-not-found
  Scenario: Handle user not found
    Given I am on the support tools dashboard
    When I search for a non-existent user
    Then I should see a "User not found" message
    And I should see search suggestions
    And I should be able to refine search criteria
    And I should see recently deleted users if applicable

  @error-handling @permission-denied
  Scenario: Handle permission denied for tool access
    Given I am on the support tools dashboard
    When I attempt to access a tool I don't have permission for
    Then I should see an access denied message
    And I should see what permission is required
    And I should see who can grant access
    And I should be able to request access

  @error-handling @operation-failed
  Scenario: Handle operation failure
    Given I am performing a support operation
    When the operation fails
    Then I should see a clear error message
    And I should see the failure reason
    And I should see what was completed
    And I should see what was not completed
    And I should see recovery options
    And the failure should be logged

  @error-handling @timeout
  Scenario: Handle operation timeout
    Given I am performing a long-running operation
    When the operation times out
    Then I should see a timeout notification
    And I should see operation progress
    And I should be able to retry
    And I should be able to run in background
    And the timeout should be logged

  @error-handling @concurrent-access
  Scenario: Handle concurrent user data access
    Given another administrator is editing user data
    When I attempt to edit the same data
    Then I should see a concurrent access warning
    And I should see who is editing
    And I should be able to view read-only
    And I should be able to request edit access
    And I should be notified when available

  @edge-case @deleted-user
  Scenario: Handle deleted user data access
    Given I am searching for user data
    When I find a deleted user account
    Then I should see the deleted status
    And I should see deletion date
    And I should see limited data based on retention
    And I should see restoration options if within window
    And I should see compliance requirements

  @edge-case @large-data
  Scenario: Handle users with large data volumes
    Given I am inspecting a user with extensive data
    When I view their data
    Then data should load progressively
    And I should see loading indicators
    And I should be able to filter data scope
    And I should see data pagination
    And I should be warned about export size

  @edge-case @rate-limiting
  Scenario: Handle rate limiting on operations
    Given I am performing multiple operations
    When I hit rate limits
    Then I should see a rate limit notification
    And I should see the limit details
    And I should see when I can retry
    And I should see options to request limit increase
    And critical operations should be prioritized

  @edge-case @offline-mode
  Scenario: Handle partial system availability
    Given some support tools are unavailable
    When I access the support tools dashboard
    Then I should see system status indicators
    And available tools should be functional
    And unavailable tools should be grayed out
    And I should see estimated restoration time
    And I should see alternative workflows
