@admin @audit @logs @security @compliance @MVP-ADMIN
Feature: Admin Audit Logs
  As a platform administrator
  I want to access comprehensive audit logs
  So that I can ensure security compliance and investigate incidents

  Background:
    Given I am logged in as a platform administrator
    And I have audit log permissions
    And the audit logging system is operational

  # ===========================================
  # AUDIT LOG DASHBOARD
  # ===========================================

  @dashboard @overview
  Scenario: View audit log dashboard
    Given I am on the admin dashboard
    When I navigate to the audit logs section
    Then I should see the audit log dashboard
    And I should see recent audit events
    And I should see audit activity summary
    And I should see security alerts panel
    And I should see quick search functionality
    And I should see log volume statistics

  @dashboard @summary
  Scenario: View audit activity summary
    Given I am on the audit log dashboard
    When I view the activity summary panel
    Then I should see total events in last 24 hours
    And I should see events by category breakdown
    And I should see events by severity level
    And I should see top users by activity
    And I should see top actions performed
    And I should see trend comparison indicators

  @dashboard @recent
  Scenario: View recent audit events
    Given I am on the audit log dashboard
    When I view the recent events panel
    Then I should see the most recent audit entries
    And each entry should show timestamp
    And each entry should show event type
    And each entry should show actor information
    And each entry should show action performed
    And each entry should show result status
    And I should be able to click for details

  @dashboard @alerts
  Scenario: View security alerts from audit logs
    Given I am on the audit log dashboard
    And there are security-related audit events
    When I view the security alerts panel
    Then I should see failed authentication attempts
    And I should see permission escalation events
    And I should see suspicious activity alerts
    And I should see policy violation events
    And each alert should show severity level
    And I should be able to acknowledge alerts

  @dashboard @statistics
  Scenario: View audit log statistics
    Given I am on the audit log dashboard
    When I view the statistics panel
    Then I should see log volume over time
    And I should see storage utilization
    And I should see log ingestion rate
    And I should see retention status
    And I should see data integrity status
    And I should see system health indicators

  # ===========================================
  # DETAILED AUDIT ENTRY
  # ===========================================

  @entry @details
  Scenario: View detailed audit entry
    Given I am on the audit log dashboard
    And there are audit entries available
    When I click on an audit entry
    Then I should see the detailed audit view
    And I should see the event ID
    And I should see the timestamp with timezone
    And I should see the event category
    And I should see the action type
    And I should see the outcome status

  @entry @actor
  Scenario: View audit entry actor information
    Given I am viewing a detailed audit entry
    When I view the actor section
    Then I should see the actor user ID
    And I should see the actor username
    And I should see the actor role
    And I should see the actor IP address
    And I should see the actor user agent
    And I should see the actor session ID

  @entry @target
  Scenario: View audit entry target information
    Given I am viewing a detailed audit entry
    When I view the target section
    Then I should see the target resource type
    And I should see the target resource ID
    And I should see the target resource name
    And I should see the resource owner
    And I should see the resource state before action
    And I should see the resource state after action

  @entry @context
  Scenario: View audit entry context information
    Given I am viewing a detailed audit entry
    When I view the context section
    Then I should see the request ID
    And I should see the service name
    And I should see the API endpoint
    And I should see the request method
    And I should see the geographic location
    And I should see the device information

  @entry @changes
  Scenario: View data changes in audit entry
    Given I am viewing an audit entry for a data modification
    When I view the changes section
    Then I should see the fields that were modified
    And I should see the previous values
    And I should see the new values
    And I should see a diff visualization
    And sensitive data should be masked
    And I should see change reason if provided

  @entry @related
  Scenario: View related audit entries
    Given I am viewing a detailed audit entry
    When I view related entries
    Then I should see entries from the same session
    And I should see entries for the same target
    And I should see entries from the same request chain
    And I should see preceding and following events
    And I should be able to navigate to related entries

  @entry @raw
  Scenario: View raw audit log data
    Given I am viewing a detailed audit entry
    And I have raw log access permission
    When I click "View Raw Data"
    Then I should see the complete raw log entry
    And the data should be in JSON format
    And I should be able to copy the raw data
    And I should be able to download the entry
    And the raw access should be logged

  # ===========================================
  # SEARCH AUDIT LOGS
  # ===========================================

  @search @basic
  Scenario: Search audit logs
    Given I am on the audit log dashboard
    When I enter a search query in the search bar
    Then I should see matching audit entries
    And results should be sorted by relevance
    And search terms should be highlighted
    And I should see the total match count
    And I should be able to refine the search

  @search @keywords
  Scenario: Search by keywords
    Given I am on the audit log search
    When I search for specific keywords
    Then I should find entries containing those keywords
    And I should be able to use quotes for exact match
    And I should be able to use AND/OR operators
    And I should be able to use NOT to exclude terms
    And I should see search suggestions

  @search @user
  Scenario: Search by user information
    Given I am on the audit log search
    When I search for a specific user
    Then I should find all entries for that user
    And I should be able to search by user ID
    And I should be able to search by username
    And I should be able to search by email
    And I should see user activity summary

  @search @resource
  Scenario: Search by resource
    Given I am on the audit log search
    When I search for a specific resource
    Then I should find all entries for that resource
    And I should be able to search by resource ID
    And I should be able to search by resource type
    And I should be able to search by resource name
    And I should see resource audit history

  @search @timerange
  Scenario: Search within time range
    Given I am on the audit log search
    When I specify a time range for the search
    Then I should see only entries within that range
    And I should be able to use preset ranges
    And I should be able to specify custom dates
    And I should be able to specify exact times
    And I should see the timezone being used

  @search @save
  Scenario: Save search query
    Given I have performed an audit log search
    When I click "Save Search"
    And I provide a name for the search
    Then the search should be saved
    And I should be able to access saved searches
    And I should be able to share saved searches
    And I should be able to set search as default

  # ===========================================
  # FILTER AUDIT LOGS
  # ===========================================

  @filter @criteria
  Scenario: Filter audit logs by criteria
    Given I am on the audit log dashboard
    When I open the filter panel
    Then I should see available filter options
    And I should be able to combine multiple filters
    And I should see active filter count
    And I should be able to clear all filters

  @filter @event-type
  Scenario: Filter by event type
    Given I am on the audit log filter panel
    When I filter by event type
    Then I should see event type options
    And I should be able to select authentication events
    And I should be able to select authorization events
    And I should be able to select data access events
    And I should be able to select configuration events
    And results should reflect the filter

  @filter @severity
  Scenario: Filter by severity level
    Given I am on the audit log filter panel
    When I filter by severity level
    Then I should be able to select critical events
    And I should be able to select warning events
    And I should be able to select informational events
    And I should be able to select debug events
    And I should be able to select multiple levels

  @filter @outcome
  Scenario: Filter by outcome status
    Given I am on the audit log filter panel
    When I filter by outcome
    Then I should be able to filter by success
    And I should be able to filter by failure
    And I should be able to filter by error
    And I should be able to filter by partial success
    And results should update accordingly

  @filter @actor
  Scenario: Filter by actor attributes
    Given I am on the audit log filter panel
    When I filter by actor
    Then I should be able to filter by user role
    And I should be able to filter by department
    And I should be able to filter by IP range
    And I should be able to filter by location
    And I should be able to filter by device type

  @filter @service
  Scenario: Filter by service or component
    Given I am on the audit log filter panel
    When I filter by service
    Then I should see available services
    And I should be able to select specific services
    And I should be able to select service groups
    And I should see event distribution by service
    And I should be able to filter by API endpoint

  @filter @presets
  Scenario: Use filter presets
    Given I am on the audit log filter panel
    When I view filter presets
    Then I should see common filter combinations
    And I should see "Security Events" preset
    And I should see "Failed Authentications" preset
    And I should see "Admin Actions" preset
    And I should see "Data Modifications" preset
    When I select a preset
    Then the filters should be applied

  @filter @save
  Scenario: Save custom filter preset
    Given I have configured custom filters
    When I click "Save as Preset"
    And I provide a preset name
    Then the filter combination should be saved
    And I should be able to access it later
    And I should be able to share with team
    And I should be able to set as default

  # ===========================================
  # BROWSE EVENTS BY CATEGORY
  # ===========================================

  @categories @browse
  Scenario: Browse events by category
    Given I am on the audit log dashboard
    When I navigate to the category browser
    Then I should see event categories
    And I should see category hierarchy
    And I should see event count per category
    And I should be able to expand subcategories

  @categories @authentication
  Scenario: Browse authentication events
    Given I am browsing audit categories
    When I select the authentication category
    Then I should see login success events
    And I should see login failure events
    And I should see logout events
    And I should see password change events
    And I should see MFA events
    And I should see session events

  @categories @authorization
  Scenario: Browse authorization events
    Given I am browsing audit categories
    When I select the authorization category
    Then I should see permission grant events
    And I should see permission revoke events
    And I should see access denied events
    And I should see role assignment events
    And I should see privilege escalation events

  @categories @data-access
  Scenario: Browse data access events
    Given I am browsing audit categories
    When I select the data access category
    Then I should see data read events
    And I should see data create events
    And I should see data update events
    And I should see data delete events
    And I should see data export events
    And I should see bulk operation events

  @categories @configuration
  Scenario: Browse configuration events
    Given I am browsing audit categories
    When I select the configuration category
    Then I should see system setting changes
    And I should see security policy changes
    And I should see integration configuration events
    And I should see feature flag changes
    And I should see infrastructure changes

  @categories @security
  Scenario: Browse security events
    Given I am browsing audit categories
    When I select the security category
    Then I should see threat detection events
    And I should see vulnerability scan events
    And I should see security policy violations
    And I should see incident response events
    And I should see compliance check events

  # ===========================================
  # COMPLIANCE REPORTS
  # ===========================================

  @compliance @report
  Scenario: Generate compliance report
    Given I am on the audit log dashboard
    When I navigate to compliance reports
    Then I should see report generation options
    And I should see compliance framework templates
    And I should see scheduled reports
    And I should see report history

  @compliance @frameworks
  Scenario: Select compliance framework
    Given I am generating a compliance report
    When I select a compliance framework
    Then I should see SOC 2 template
    And I should see GDPR template
    And I should see HIPAA template
    And I should see PCI-DSS template
    And I should see ISO 27001 template
    And I should see custom framework option

  @compliance @configure
  Scenario: Configure compliance report parameters
    Given I have selected a compliance framework
    When I configure report parameters
    Then I should be able to set date range
    And I should be able to select control categories
    And I should be able to include evidence attachments
    And I should be able to add custom sections
    And I should be able to set report format

  @compliance @generate
  Scenario: Generate and view compliance report
    Given I have configured a compliance report
    When I click "Generate Report"
    Then the report generation should start
    And I should see generation progress
    When the report is ready
    Then I should see the compliance summary
    And I should see control status overview
    And I should see evidence documentation
    And I should see remediation recommendations

  @compliance @evidence
  Scenario: Include audit evidence in report
    Given I am generating a compliance report
    When the report includes evidence sections
    Then I should see relevant audit log entries
    And I should see access control evidence
    And I should see change management evidence
    And I should see security monitoring evidence
    And evidence should be linked to controls

  @compliance @export
  Scenario: Export compliance report
    Given I have generated a compliance report
    When I export the report
    Then I should be able to export as PDF
    And I should be able to export as Word document
    And I should be able to export as Excel
    And I should be able to include appendices
    And the export should be audit logged

  # ===========================================
  # AUDIT LOG INTEGRITY
  # ===========================================

  @integrity @verify
  Scenario: Verify audit log integrity
    Given I am on the audit log dashboard
    When I navigate to integrity verification
    Then I should see integrity status dashboard
    And I should see last verification timestamp
    And I should see verification method details
    And I should see chain integrity status

  @integrity @check
  Scenario: Run integrity verification check
    Given I am on the integrity verification section
    When I click "Run Integrity Check"
    Then the verification process should start
    And I should see verification progress
    And I should see entries being validated
    When verification completes
    Then I should see the verification result
    And I should see any integrity issues found

  @integrity @chain
  Scenario: Verify audit chain integrity
    Given I am running an integrity check
    When verifying the audit chain
    Then each entry should be hash-verified
    And chain links should be validated
    And temporal consistency should be checked
    And I should see chain visualization
    And breaks in chain should be highlighted

  @integrity @tamper
  Scenario: Detect audit log tampering
    Given integrity verification is running
    When potential tampering is detected
    Then I should receive an alert
    And I should see the affected entries
    And I should see the type of anomaly
    And I should see forensic details
    And I should see recommended actions
    And the detection should trigger incident workflow

  @integrity @cryptographic
  Scenario: View cryptographic verification details
    Given I am viewing integrity verification results
    When I view cryptographic details
    Then I should see hashing algorithm used
    And I should see signature verification status
    And I should see certificate chain status
    And I should see timestamping authority details
    And I should see key rotation history

  @integrity @schedule
  Scenario: Schedule automatic integrity checks
    Given I am on the integrity verification section
    When I configure scheduled checks
    Then I should be able to set check frequency
    And I should be able to set check scope
    And I should be able to configure notifications
    And I should see scheduled check history
    And I should receive alerts on failures

  # ===========================================
  # COMPLEX AUDIT SEARCH
  # ===========================================

  @search @complex
  Scenario: Perform complex audit search
    Given I am on the audit log search
    When I switch to advanced search mode
    Then I should see the query builder interface
    And I should see field selection options
    And I should see operator options
    And I should see logical grouping options

  @search @query-builder
  Scenario: Build complex search query
    Given I am in advanced search mode
    When I build a complex query
    Then I should be able to add multiple conditions
    And I should be able to group conditions
    And I should be able to use AND/OR/NOT operators
    And I should be able to nest condition groups
    And I should see query preview

  @search @fields
  Scenario: Search across multiple fields
    Given I am building a complex query
    When I select search fields
    Then I should be able to search actor fields
    And I should be able to search target fields
    And I should be able to search context fields
    And I should be able to search metadata fields
    And I should see field data types

  @search @operators
  Scenario: Use advanced search operators
    Given I am building a complex query
    When I select operators
    Then I should be able to use equals/not equals
    And I should be able to use contains/not contains
    And I should be able to use greater than/less than
    And I should be able to use regex patterns
    And I should be able to use in/not in list
    And I should be able to use exists/not exists

  @search @aggregations
  Scenario: Search with aggregations
    Given I am in advanced search mode
    When I add aggregations to my query
    Then I should be able to count by field
    And I should be able to group by field
    And I should be able to calculate statistics
    And I should see aggregation results
    And I should be able to drill down into groups

  @search @correlate
  Scenario: Correlate events across searches
    Given I have multiple search results
    When I correlate the results
    Then I should see common actors
    And I should see common targets
    And I should see temporal relationships
    And I should see causal chains
    And I should see correlation strength

  # ===========================================
  # EXPORT AUDIT LOGS
  # ===========================================

  @export @logs
  Scenario: Export audit logs
    Given I am on the audit log dashboard
    And I have export permissions
    When I click on "Export Logs"
    Then I should see export configuration options
    And I should see format selection
    And I should see field selection
    And I should see date range selection

  @export @format
  Scenario: Select export format
    Given I am configuring an audit log export
    When I select the export format
    Then I should be able to export as JSON
    And I should be able to export as CSV
    And I should be able to export as XML
    And I should be able to export as PDF report
    And I should be able to export as SIEM-compatible format

  @export @fields
  Scenario: Select fields for export
    Given I am configuring an audit log export
    When I select fields to include
    Then I should see all available fields
    And I should be able to select specific fields
    And I should be able to use field templates
    And I should be able to rename fields
    And I should be able to exclude sensitive fields

  @export @scope
  Scenario: Configure export scope
    Given I am configuring an audit log export
    When I configure the export scope
    Then I should be able to set date range
    And I should be able to apply filters
    And I should see estimated export size
    And I should see record count
    And I should be warned about large exports

  @export @execute
  Scenario: Execute audit log export
    Given I have configured an audit log export
    When I execute the export
    Then the export should be processed
    And I should see export progress
    And I should be notified when complete
    And I should be able to download the export
    And the export action should be audit logged

  @export @schedule
  Scenario: Schedule recurring exports
    Given I am on the export configuration
    When I configure scheduled export
    Then I should be able to set export frequency
    And I should be able to set delivery destination
    And I should be able to set notification preferences
    And I should see scheduled export history
    And I should be able to pause or cancel schedules

  @export @sensitive
  Scenario: Handle sensitive data in exports
    Given I am exporting audit logs
    And the logs contain sensitive data
    When I configure the export
    Then I should see sensitive field warnings
    And I should be able to mask sensitive data
    And I should be able to redact specific fields
    And I should acknowledge data handling policies
    And the sensitivity handling should be logged

  # ===========================================
  # SIEM INTEGRATION
  # ===========================================

  @siem @configure
  Scenario: Configure SIEM integration
    Given I am on the audit log dashboard
    When I navigate to SIEM integration
    Then I should see integration configuration
    And I should see supported SIEM platforms
    And I should see connection status
    And I should see data flow metrics

  @siem @connect
  Scenario: Connect to SIEM platform
    Given I am configuring SIEM integration
    When I set up a new SIEM connection
    Then I should be able to select SIEM type
    And I should be able to enter connection details
    And I should be able to configure authentication
    And I should be able to test the connection
    And the connection should be encrypted

  @siem @mapping
  Scenario: Configure field mapping
    Given I have connected to a SIEM platform
    When I configure field mapping
    Then I should see source audit fields
    And I should see target SIEM fields
    And I should be able to map fields
    And I should be able to create custom mappings
    And I should be able to transform field values

  @siem @filters
  Scenario: Configure SIEM event filters
    Given I have SIEM integration configured
    When I configure event filters
    Then I should be able to select event types to forward
    And I should be able to set severity thresholds
    And I should be able to filter by source
    And I should be able to exclude specific events
    And I should see estimated event volume

  @siem @monitor
  Scenario: Monitor SIEM integration
    Given SIEM integration is active
    When I view the integration monitor
    Then I should see events forwarded count
    And I should see forwarding latency
    And I should see any failed forwards
    And I should see queue status
    And I should see error logs

  @siem @troubleshoot
  Scenario: Troubleshoot SIEM connection issues
    Given SIEM integration has issues
    When I view the troubleshooting panel
    Then I should see connection diagnostics
    And I should see recent errors
    And I should see retry attempts
    And I should see recommended fixes
    And I should be able to test connectivity

  # ===========================================
  # AUDIT ALERTS
  # ===========================================

  @alerts @setup
  Scenario: Set up audit alerts
    Given I am on the audit log dashboard
    When I navigate to alert configuration
    Then I should see existing alerts
    And I should see alert templates
    And I should see alert history
    And I should see alert statistics

  @alerts @create
  Scenario: Create new audit alert
    Given I am on the alert configuration
    When I click "Create Alert"
    Then I should see alert configuration form
    And I should be able to set alert name
    And I should be able to define trigger conditions
    And I should be able to set severity
    And I should be able to configure notifications

  @alerts @conditions
  Scenario: Configure alert trigger conditions
    Given I am creating an audit alert
    When I configure trigger conditions
    Then I should be able to set event type triggers
    And I should be able to set threshold triggers
    And I should be able to set pattern triggers
    And I should be able to set time-based triggers
    And I should be able to combine multiple conditions

  @alerts @thresholds
  Scenario: Configure threshold-based alerts
    Given I am configuring alert conditions
    When I set up threshold alerts
    Then I should be able to set count thresholds
    And I should be able to set rate thresholds
    And I should be able to set time windows
    And I should be able to set baseline deviation
    And I should see threshold preview

  @alerts @notifications
  Scenario: Configure alert notifications
    Given I am creating an audit alert
    When I configure notifications
    Then I should be able to add email recipients
    And I should be able to add Slack channels
    And I should be able to add PagerDuty integration
    And I should be able to add webhook endpoints
    And I should be able to set escalation rules

  @alerts @templates
  Scenario: Use alert templates
    Given I am creating an audit alert
    When I browse alert templates
    Then I should see "Brute Force Detection" template
    And I should see "Privilege Escalation" template
    And I should see "Data Exfiltration" template
    And I should see "Account Lockout" template
    When I select a template
    Then the alert should be pre-configured

  @alerts @manage
  Scenario: Manage existing alerts
    Given I have configured audit alerts
    When I view alert management
    Then I should be able to enable/disable alerts
    And I should be able to edit alert configurations
    And I should be able to view alert history
    And I should be able to test alerts
    And I should be able to delete alerts

  # ===========================================
  # AUDIT RETENTION
  # ===========================================

  @retention @configure
  Scenario: Configure audit retention
    Given I am on the audit log settings
    When I navigate to retention configuration
    Then I should see current retention policies
    And I should see storage utilization
    And I should see compliance requirements
    And I should see archival settings

  @retention @policies
  Scenario: Set retention policies
    Given I am configuring retention
    When I set retention policies
    Then I should be able to set default retention period
    And I should be able to set category-specific retention
    And I should be able to set compliance-based retention
    And I should be able to set legal hold overrides
    And I should see retention impact preview

  @retention @categories
  Scenario: Configure retention by category
    Given I am setting retention policies
    When I configure category retention
    Then I should set security event retention
    And I should set authentication event retention
    And I should set access event retention
    And I should set configuration event retention
    And different categories can have different periods

  @retention @archive
  Scenario: Configure log archival
    Given I am configuring retention
    When I set up archival settings
    Then I should be able to configure archive destination
    And I should be able to set archive compression
    And I should be able to set archive encryption
    And I should be able to schedule archival
    And I should be able to configure archive access

  @retention @deletion
  Scenario: Configure secure deletion
    Given I am configuring retention
    When I configure deletion settings
    Then I should be able to set deletion method
    And I should be able to require deletion approval
    And I should be able to set deletion verification
    And I should see deletion audit trail
    And deletion should be compliance-verified

  @retention @legal-hold
  Scenario: Apply legal hold to audit logs
    Given I am on the retention configuration
    When I apply a legal hold
    Then I should be able to specify hold scope
    And I should be able to set hold reason
    And I should be able to set hold duration
    And held logs should be protected from deletion
    And the hold should be audit logged

  # ===========================================
  # SECURITY INCIDENT INVESTIGATION
  # ===========================================

  @investigation @incident
  Scenario: Investigate security incident
    Given I am on the audit log dashboard
    And there is a security incident to investigate
    When I start an incident investigation
    Then I should see the investigation workspace
    And I should see incident timeline
    And I should see related audit events
    And I should see affected resources
    And I should see investigation tools

  @investigation @timeline
  Scenario: Build incident timeline
    Given I am investigating a security incident
    When I build the incident timeline
    Then I should see events in chronological order
    And I should see event relationships
    And I should be able to zoom into time periods
    And I should be able to add annotations
    And I should be able to mark key events

  @investigation @scope
  Scenario: Determine incident scope
    Given I am investigating a security incident
    When I analyze the incident scope
    Then I should see all affected users
    And I should see all affected resources
    And I should see all affected systems
    And I should see lateral movement patterns
    And I should see data exposure assessment

  @investigation @root-cause
  Scenario: Perform root cause analysis
    Given I am investigating a security incident
    When I perform root cause analysis
    Then I should see the initial compromise point
    And I should see the attack vector
    And I should see contributing factors
    And I should see security control gaps
    And I should be able to document findings

  @investigation @evidence
  Scenario: Collect investigation evidence
    Given I am investigating a security incident
    When I collect evidence
    Then I should be able to tag relevant events
    And I should be able to take snapshots
    And I should be able to preserve log segments
    And I should be able to add evidence notes
    And evidence should be chain-of-custody tracked

  @investigation @report
  Scenario: Generate investigation report
    Given I have completed an investigation
    When I generate the investigation report
    Then I should see executive summary
    And I should see detailed timeline
    And I should see technical analysis
    And I should see impact assessment
    And I should see recommendations
    And I should see evidence references

  @investigation @collaborate
  Scenario: Collaborate on investigation
    Given I am investigating a security incident
    When I add collaborators
    Then I should be able to invite team members
    And team members should see the workspace
    And we should be able to share findings
    And we should be able to assign tasks
    And all activities should be logged

  # ===========================================
  # AUDIT ANALYTICS
  # ===========================================

  @analytics @dashboard
  Scenario: View audit analytics
    Given I am on the audit log dashboard
    When I navigate to audit analytics
    Then I should see analytics dashboard
    And I should see event trend analysis
    And I should see behavior analytics
    And I should see anomaly detection results
    And I should see risk indicators

  @analytics @trends
  Scenario: Analyze audit event trends
    Given I am on the audit analytics section
    When I view trend analysis
    Then I should see event volume trends
    And I should see category distribution trends
    And I should see user activity trends
    And I should see temporal patterns
    And I should see forecast projections

  @analytics @behavior
  Scenario: View user behavior analytics
    Given I am on the audit analytics section
    When I view behavior analytics
    Then I should see baseline behavior profiles
    And I should see deviation detection
    And I should see peer group comparisons
    And I should see activity clustering
    And I should see risk scores

  @analytics @anomalies
  Scenario: Review detected anomalies
    Given I am on the audit analytics section
    When I view anomaly detection
    Then I should see detected anomalies
    And I should see anomaly classification
    And I should see confidence scores
    And I should see related normal patterns
    And I should be able to mark as investigated

  @analytics @risk
  Scenario: View risk indicators
    Given I am on the audit analytics section
    When I view risk indicators
    Then I should see overall risk score
    And I should see risk by category
    And I should see risk trends
    And I should see high-risk entities
    And I should see recommended mitigations

  @analytics @reports
  Scenario: Generate analytics reports
    Given I am on the audit analytics section
    When I generate an analytics report
    Then I should see report configuration options
    And I should be able to select metrics
    And I should be able to set time periods
    And I should be able to add visualizations
    And I should be able to schedule reports

  # ===========================================
  # SENSITIVE DATA MANAGEMENT
  # ===========================================

  @sensitive @manage
  Scenario: Manage sensitive data in logs
    Given I am on the audit log settings
    When I navigate to sensitive data management
    Then I should see sensitive data policies
    And I should see masking configurations
    And I should see access controls
    And I should see data classification

  @sensitive @classification
  Scenario: Configure data classification
    Given I am managing sensitive data
    When I configure classification
    Then I should be able to define sensitivity levels
    And I should be able to classify field types
    And I should be able to set auto-classification rules
    And I should see classification coverage
    And I should see unclassified data

  @sensitive @masking
  Scenario: Configure data masking
    Given I am managing sensitive data
    When I configure masking rules
    Then I should be able to set masking patterns
    And I should be able to set role-based visibility
    And I should be able to set context-based visibility
    And I should be able to test masking rules
    And I should see masking preview

  @sensitive @access
  Scenario: Configure sensitive data access
    Given I am managing sensitive data
    When I configure access controls
    Then I should be able to set role requirements
    And I should be able to require justification
    And I should be able to require approval
    And I should be able to set time-limited access
    And access should be fully logged

  @sensitive @unmasking
  Scenario: Request sensitive data unmasking
    Given I am viewing a masked audit entry
    When I request unmasking
    Then I should provide justification
    And the request should go for approval if required
    When approved
    Then I should see unmasked data temporarily
    And the unmasking should be logged
    And access should auto-expire

  # ===========================================
  # SCHEDULED AUDIT REPORTS
  # ===========================================

  @schedule @reports
  Scenario: Schedule audit reports
    Given I am on the audit log dashboard
    When I navigate to scheduled reports
    Then I should see existing schedules
    And I should see report templates
    And I should see delivery history
    And I should be able to create new schedules

  @schedule @create
  Scenario: Create scheduled report
    Given I am on the scheduled reports section
    When I create a new schedule
    Then I should be able to select report type
    And I should be able to configure report parameters
    And I should be able to set schedule frequency
    And I should be able to set delivery method
    And I should be able to set recipients

  @schedule @frequency
  Scenario: Configure report frequency
    Given I am creating a scheduled report
    When I configure the frequency
    Then I should be able to set daily reports
    And I should be able to set weekly reports
    And I should be able to set monthly reports
    And I should be able to set custom intervals
    And I should be able to set specific times

  @schedule @delivery
  Scenario: Configure report delivery
    Given I am creating a scheduled report
    When I configure delivery
    Then I should be able to deliver via email
    And I should be able to deliver to file storage
    And I should be able to deliver via API
    And I should be able to set multiple destinations
    And I should be able to configure format per destination

  @schedule @manage
  Scenario: Manage scheduled reports
    Given I have scheduled reports configured
    When I manage the schedules
    Then I should be able to view run history
    And I should be able to pause schedules
    And I should be able to edit configurations
    And I should be able to run immediately
    And I should be able to delete schedules

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @no-access
  Scenario: Handle insufficient audit log permissions
    Given I am logged in as an administrator
    And I do not have audit log permissions
    When I try to access audit logs
    Then I should see an access denied message
    And I should see what permission is required
    And I should see how to request access
    And the access attempt should be logged

  @error-handling @large-results
  Scenario: Handle large result sets
    Given I am searching audit logs
    When the search returns a very large result set
    Then I should see a warning about result size
    And I should see suggestions to narrow the search
    And results should be paginated
    And I should be offered background processing
    And I should be offered export option

  @error-handling @timeout
  Scenario: Handle search timeout
    Given I am performing a complex audit search
    When the search times out
    Then I should see a timeout notification
    And I should see suggestions to simplify query
    And I should be offered to run in background
    And I should see partial results if available
    And I should be able to retry with modifications

  @error-handling @data-unavailable
  Scenario: Handle unavailable audit data
    Given I am viewing audit logs
    When some log data is unavailable
    Then I should see an availability indicator
    And I should see which data is affected
    And I should see the reason for unavailability
    And I should see expected restoration time
    And I should see alternative data sources

  @edge-case @timezone
  Scenario: Handle timezone differences in logs
    Given I am viewing audit logs
    And events occurred in multiple timezones
    When I view the logs
    Then I should see consistent timestamp display
    And I should be able to switch timezone view
    And I should see original event timezone
    And I should see timezone conversion indicator
    And filtering should work correctly across zones

  @edge-case @high-volume
  Scenario: Handle high volume audit events
    Given the system is experiencing high event volume
    When I access the audit dashboard
    Then I should see volume indicators
    And I should see any ingestion delays
    And I should see queue status
    And real-time view should handle load gracefully
    And I should see performance impact warnings

  @edge-case @archived-data
  Scenario: Access archived audit logs
    Given I need to access archived audit data
    When I search for archived logs
    Then I should see archive availability status
    And I should be able to request archive retrieval
    And I should see estimated retrieval time
    When the archive is retrieved
    Then I should be able to search the data
    And I should see archive expiration time

  @edge-case @concurrent-investigation
  Scenario: Handle concurrent investigations
    Given multiple administrators are investigating
    When we access the same incident
    Then we should see collaboration indicators
    And we should see who else is investigating
    And we should see real-time updates
    And we should be able to coordinate actions
    And all activities should be tracked

  @edge-case @log-gap
  Scenario: Detect and report log gaps
    Given the audit system detects a log gap
    When I view the affected time period
    Then I should see gap indicators
    And I should see the gap duration
    And I should see possible causes
    And I should see remediation status
    And I should see data recovery options
