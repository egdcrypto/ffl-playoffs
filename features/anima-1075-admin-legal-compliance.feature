@admin @legal @compliance @regulatory
Feature: Admin Legal Compliance
  As a platform administrator
  I want to manage legal compliance and regulatory requirements
  So that I can ensure the platform operates within legal boundaries

  Background:
    Given I am logged in as a platform administrator
    And I have legal compliance management permissions
    And the compliance management system is operational

  # ===========================================================================
  # COMPLIANCE OVERVIEW DASHBOARD
  # ===========================================================================

  @api @compliance @dashboard
  Scenario: View compliance dashboard overview
    Given the platform operates across multiple jurisdictions
    When I navigate to the compliance dashboard
    Then I should see a response with status 200
    And I should see overall compliance status:
      | metric                    | value    | status  |
      | overall_compliance_score  | 94%      | good    |
      | open_issues               | 7        | warning |
      | pending_audits            | 2        | info    |
      | upcoming_deadlines        | 5        | warning |
    And I should see compliance by regulation:
      | regulation | status    | last_review  | next_review |
      | GDPR       | compliant | 2024-11-15   | 2025-02-15  |
      | CCPA       | compliant | 2024-10-01   | 2025-01-01  |
      | COPPA      | warning   | 2024-09-15   | 2024-12-31  |
      | HIPAA      | n/a       | n/a          | n/a         |
    And I should see recent compliance activities

  @api @compliance @dashboard
  Scenario: View compliance issues requiring attention
    Given there are open compliance issues
    When I view compliance issues
    Then I should see issues prioritized by severity:
      | issue_id | severity | regulation | description                    | due_date   |
      | CI-001   | high     | GDPR       | Data retention policy update   | 2025-01-15 |
      | CI-002   | medium   | CCPA       | Privacy notice update needed   | 2025-01-31 |
      | CI-003   | low      | Internal   | Documentation refresh          | 2025-02-28 |
    And I should be able to assign issues to team members
    And I should see issue resolution progress

  @api @compliance @dashboard
  Scenario: View compliance calendar
    Given there are upcoming compliance deadlines
    When I view the compliance calendar
    Then I should see upcoming events:
      | date       | event_type     | description                    |
      | 2025-01-15 | deadline       | GDPR annual review due         |
      | 2025-01-20 | audit          | External audit scheduled       |
      | 2025-02-01 | renewal        | Privacy certification renewal  |
    And I should be able to export calendar
    And I should be able to set reminders

  # ===========================================================================
  # PRIVACY COMPLIANCE (GDPR, CCPA, etc.)
  # ===========================================================================

  @api @compliance @privacy
  Scenario: Manage GDPR compliance settings
    Given GDPR applies to our European users
    When I configure GDPR compliance settings
    Then I should be able to set:
      | setting                    | value              |
      | data_retention_period      | 36 months          |
      | consent_required           | true               |
      | right_to_erasure           | enabled            |
      | data_portability           | enabled            |
      | dpo_contact                | dpo@platform.com   |
    And settings should be validated for GDPR requirements
    And a GDPRSettingsUpdated event should be published

  @api @compliance @privacy
  Scenario: Manage CCPA compliance settings
    Given CCPA applies to our California users
    When I configure CCPA compliance settings
    Then I should be able to set:
      | setting                       | value    |
      | do_not_sell_enabled           | true     |
      | opt_out_mechanism             | enabled  |
      | disclosure_requirements       | enabled  |
      | consumer_request_handling     | enabled  |
      | response_time_days            | 45       |
    And settings should be validated for CCPA requirements
    And a CCPASettingsUpdated event should be published

  @api @compliance @privacy
  Scenario: Configure consent management
    Given users must consent to data processing
    When I configure consent management:
      | consent_type          | required | default | description                  |
      | essential_cookies     | true     | true    | Required for site function   |
      | analytics             | false    | false   | Usage analytics              |
      | marketing             | false    | false   | Marketing communications     |
      | third_party_sharing   | false    | false   | Share with partners          |
    Then consent settings should be saved
    And consent UI should reflect configuration
    And consent records should be auditable

  @api @compliance @privacy
  Scenario: View consent analytics
    Given users have provided consent choices
    When I view consent analytics
    Then I should see:
      | consent_type        | opt_in_rate | total_users |
      | essential_cookies   | 100%        | 50,000      |
      | analytics           | 72%         | 36,000      |
      | marketing           | 35%         | 17,500      |
      | third_party_sharing | 18%         | 9,000       |
    And I should see consent trends over time
    And I should see geographic breakdown

  @api @compliance @privacy
  Scenario: Manage data processing agreements
    Given we share data with third parties
    When I manage data processing agreements
    Then I should see all DPAs:
      | vendor          | status  | signed_date | expiry_date | coverage    |
      | Analytics Co    | active  | 2024-01-15  | 2025-01-15  | GDPR, CCPA  |
      | Cloud Provider  | active  | 2024-03-01  | 2025-03-01  | GDPR        |
      | Email Service   | expiring| 2024-06-01  | 2025-01-01  | GDPR, CCPA  |
    And I should be able to upload new DPAs
    And I should receive alerts for expiring agreements

  # ===========================================================================
  # TERMS OF SERVICE MANAGEMENT
  # ===========================================================================

  @api @compliance @tos
  Scenario: Manage terms of service versions
    Given the platform has terms of service
    When I view terms of service management
    Then I should see all TOS versions:
      | version | effective_date | status   | acceptance_rate |
      | 3.0     | 2024-09-01     | current  | 98.5%           |
      | 2.5     | 2024-03-01     | archived | 100%            |
      | 2.0     | 2023-09-01     | archived | 100%            |
    And I should see pending version drafts
    And I should be able to create new versions

  @api @compliance @tos
  Scenario: Create new terms of service version
    Given I need to update terms of service
    When I create a new TOS version:
      | field            | value                              |
      | version          | 3.1                                |
      | effective_date   | 2025-02-01                         |
      | summary_changes  | Updated data sharing provisions    |
      | requires_reaccept| true                               |
    Then the draft should be created
    And I should be able to attach legal review notes
    And I should be able to preview user-facing version
    And a TOSVersionCreated event should be published

  @api @compliance @tos
  Scenario: Publish terms of service update
    Given a TOS version 3.1 is ready for publication
    When I publish the TOS update
    Then I should configure notification settings:
      | setting                   | value      |
      | notification_lead_time    | 30 days    |
      | email_notification        | true       |
      | in_app_notification       | true       |
      | require_acknowledgment    | true       |
    And users should be notified of upcoming changes
    And a TOSPublished event should be published

  @api @compliance @tos
  Scenario: Track terms of service acceptance
    Given a new TOS version is in effect
    When I view acceptance tracking
    Then I should see:
      | metric                    | value      |
      | total_users               | 50,000     |
      | accepted                  | 49,250     |
      | pending_acceptance        | 750        |
      | acceptance_rate           | 98.5%      |
    And I should see acceptance by user segment
    And I should be able to send reminders to pending users

  @api @compliance @tos
  Scenario: Handle users who reject terms
    Given some users have not accepted new terms
    When the grace period expires
    Then I should see options for non-accepting users:
      | option                    | description                        |
      | extend_grace_period       | Give more time to accept           |
      | restrict_access           | Limit features until accepted      |
      | suspend_account           | Suspend until terms accepted       |
    And I should be able to apply action in bulk
    And actions should be documented

  # ===========================================================================
  # CONTENT MODERATION COMPLIANCE
  # ===========================================================================

  @api @compliance @content
  Scenario: Configure content moderation policies
    Given content must comply with legal requirements
    When I configure content moderation policies
    Then I should be able to set:
      | policy_type           | settings                            |
      | illegal_content       | auto_remove, report_to_authorities  |
      | hate_speech           | auto_remove, escalate               |
      | copyright_violation   | notice_and_takedown                 |
      | age_restricted        | age_gate, restrict_distribution     |
    And policies should align with regulatory requirements
    And a ContentPolicyUpdated event should be published

  @api @compliance @content
  Scenario: Manage DMCA compliance
    Given we receive copyright takedown requests
    When I view DMCA management
    Then I should see DMCA requests:
      | request_id | status    | received    | content_type | deadline   |
      | DMCA-001   | pending   | 2024-12-20  | image        | 2024-12-27 |
      | DMCA-002   | completed | 2024-12-15  | video        | completed  |
      | DMCA-003   | disputed  | 2024-12-10  | audio        | in_review  |
    And I should be able to process requests
    And I should track response times
    And I should maintain DMCA agent information

  @api @compliance @content
  Scenario: Process DMCA takedown request
    Given a DMCA request DMCA-001 is pending
    When I process the request:
      | action          | remove_content    |
      | notify_uploader | true              |
      | preserve_evidence| true             |
      | response_notes  | Valid claim       |
    Then content should be removed
    And uploader should be notified with counter-notice rights
    And takedown should be logged
    And a DMCATakedownProcessed event should be published

  @api @compliance @content
  Scenario: Handle DMCA counter-notice
    Given content was removed via DMCA
    And uploader has filed counter-notice
    When I review counter-notice:
      | field              | value                              |
      | uploader_claim     | Fair use - educational content     |
      | evidence_provided  | yes                                |
      | valid_signature    | yes                                |
    Then I should evaluate counter-notice validity
    And if valid, start 10-14 day waiting period
    And notify original claimant
    And restore content if no lawsuit filed

  @api @compliance @content
  Scenario: Manage age-restricted content compliance
    Given platform has age-restricted content
    When I configure age verification settings
    Then I should be able to set:
      | setting                   | value              |
      | age_verification_method   | self_declaration   |
      | minimum_age               | 18                 |
      | verification_frequency    | once_per_session   |
      | content_categories        | mature_themes      |
    And age gates should be applied to restricted content
    And verification logs should be maintained

  # ===========================================================================
  # DATA SUBJECT RIGHTS REQUESTS
  # ===========================================================================

  @api @compliance @dsr
  Scenario: View data subject rights requests queue
    Given users have submitted DSR requests
    When I view the DSR queue
    Then I should see pending requests:
      | request_id | type           | user         | received    | deadline   | status   |
      | DSR-001    | access         | user123      | 2024-12-20  | 2025-01-19 | pending  |
      | DSR-002    | erasure        | user456      | 2024-12-18  | 2025-01-17 | in_progress |
      | DSR-003    | portability    | user789      | 2024-12-15  | 2025-01-14 | completed |
    And requests should be sorted by deadline
    And I should see SLA compliance metrics

  @api @compliance @dsr
  Scenario: Process data access request
    Given a data access request DSR-001 is pending
    When I process the access request:
      | step                   | action                              |
      | verify_identity        | ID verified via support             |
      | gather_data            | Collect all user data               |
      | review_data            | Ensure no third-party data included |
      | prepare_export         | Generate downloadable package       |
    Then user data should be compiled
    And data should be reviewed for third-party information
    And secure download link should be generated
    And request should be marked complete
    And a DataAccessRequestCompleted event should be published

  @api @compliance @dsr
  Scenario: Process data erasure request (right to be forgotten)
    Given an erasure request DSR-002 is pending
    When I process the erasure request:
      | step                   | action                              |
      | verify_identity        | ID verified                         |
      | check_legal_holds      | No active legal holds               |
      | check_retention_req    | No mandatory retention applies      |
      | execute_deletion       | Delete all user data                |
    Then I should see data categories to be deleted:
      | category           | records | can_delete |
      | account_data       | 1       | yes        |
      | activity_logs      | 5,432   | yes        |
      | content_created    | 234     | yes        |
      | transaction_records| 12      | no (legal) |
    And deletable data should be erased
    And non-deletable data should be anonymized
    And a DataErasureCompleted event should be published

  @api @compliance @dsr
  Scenario: Process data portability request
    Given a portability request DSR-003 is pending
    When I process the portability request
    Then I should generate export in machine-readable format:
      | format_options | description                    |
      | JSON           | Standard JSON format           |
      | CSV            | Comma-separated values         |
      | XML            | XML format                     |
    And export should include all portable data
    And export should be securely delivered
    And a DataPortabilityCompleted event should be published

  @api @compliance @dsr
  Scenario: Handle request that cannot be fulfilled
    Given an erasure request conflicts with legal retention
    When I deny the request
    Then I should provide:
      | field              | value                              |
      | reason             | Legal retention requirement        |
      | legal_basis        | Tax records - 7 year retention     |
      | alternative_action | Data will be anonymized            |
      | appeal_process     | Contact dpo@platform.com           |
    And user should be notified of decision
    And decision should be documented

  @api @compliance @dsr
  Scenario: Track DSR response times
    Given DSRs have been processed over time
    When I view DSR metrics
    Then I should see:
      | metric                    | value    | target   |
      | average_response_time     | 18 days  | 30 days  |
      | requests_completed_on_time| 97%      | 100%     |
      | requests_pending          | 5        | n/a      |
      | requests_this_month       | 45       | n/a      |
    And I should see trends over time
    And I should see breakdown by request type

  # ===========================================================================
  # COMPLIANCE AUDITS
  # ===========================================================================

  @api @compliance @audit
  Scenario: Schedule compliance audit
    Given an annual compliance audit is due
    When I schedule a new audit:
      | field              | value                    |
      | audit_type         | external                 |
      | scope              | GDPR, CCPA               |
      | auditor            | Big Four Auditors Inc    |
      | start_date         | 2025-02-01               |
      | end_date           | 2025-02-15               |
    Then audit should be scheduled
    And audit team should be notified
    And preparation tasks should be created
    And a ComplianceAuditScheduled event should be published

  @api @compliance @audit
  Scenario: Prepare for compliance audit
    Given an audit is scheduled for 2025-02-01
    When I view audit preparation checklist
    Then I should see required items:
      | item                        | status    | owner          | due_date   |
      | Policy documentation        | complete  | Legal Team     | 2025-01-20 |
      | Access logs for review      | pending   | IT Team        | 2025-01-25 |
      | Consent records export      | pending   | Data Team      | 2025-01-25 |
      | Employee training records   | complete  | HR Team        | 2025-01-20 |
      | Vendor compliance docs      | in_progress| Procurement   | 2025-01-28 |
    And I should be able to assign tasks
    And I should track preparation progress

  @api @compliance @audit
  Scenario: Document audit findings
    Given an audit has been completed
    When I document audit findings:
      | finding_id | severity | area          | description                    | remediation_required |
      | AF-001     | high     | Data access   | Excessive access permissions   | yes                  |
      | AF-002     | medium   | Documentation | Policy version control gaps    | yes                  |
      | AF-003     | low      | Training      | Refresher training overdue     | yes                  |
    Then findings should be recorded
    And remediation plans should be created
    And stakeholders should be notified
    And a AuditFindingsRecorded event should be published

  @api @compliance @audit
  Scenario: Track audit remediation
    Given audit findings require remediation
    When I view remediation tracking
    Then I should see remediation status:
      | finding_id | remediation_action              | owner      | status      | due_date   |
      | AF-001     | Implement RBAC review process   | IT Team    | in_progress | 2025-03-01 |
      | AF-002     | Implement document versioning   | Legal Team | pending     | 2025-03-15 |
      | AF-003     | Schedule training sessions      | HR Team    | completed   | 2025-02-15 |
    And I should be able to update status
    And I should see overall remediation progress

  @api @compliance @audit
  Scenario: Generate audit report
    Given an audit cycle is complete
    When I generate the audit report
    Then report should include:
      | section                    | content                          |
      | executive_summary          | High-level findings and status   |
      | scope_and_methodology      | What was audited and how         |
      | findings_detail            | All findings with evidence       |
      | remediation_status         | Progress on fixes                |
      | recommendations            | Improvement suggestions          |
      | management_response        | Official response to findings    |
    And report should be exportable as PDF
    And report should be stored in compliance records

  # ===========================================================================
  # THIRD-PARTY VENDOR COMPLIANCE
  # ===========================================================================

  @api @compliance @vendor
  Scenario: Manage vendor compliance registry
    Given the platform uses third-party vendors
    When I view vendor compliance registry
    Then I should see all vendors:
      | vendor_name     | category      | risk_level | compliance_status | last_review |
      | Cloud Host Inc  | infrastructure| high       | compliant         | 2024-11-01  |
      | Analytics Co    | analytics     | medium     | compliant         | 2024-10-15  |
      | Email Service   | communication | low        | review_needed     | 2024-06-01  |
    And I should see compliance documentation per vendor
    And I should see contract expiration dates

  @api @compliance @vendor
  Scenario: Conduct vendor risk assessment
    Given a new vendor "Payment Processor" is being onboarded
    When I conduct risk assessment:
      | assessment_area       | rating | notes                         |
      | data_handling         | high   | Processes payment data        |
      | security_controls     | good   | SOC 2 Type II certified       |
      | business_continuity   | good   | Multi-region redundancy       |
      | regulatory_compliance | good   | PCI-DSS Level 1               |
    Then risk score should be calculated
    And approval workflow should be triggered if high risk
    And a VendorRiskAssessed event should be published

  @api @compliance @vendor
  Scenario: Review vendor compliance documentation
    Given vendor "Cloud Host Inc" requires annual review
    When I review their compliance documentation
    Then I should verify:
      | document              | status   | expiry_date | action_needed |
      | SOC 2 Type II Report  | valid    | 2025-06-30  | none          |
      | ISO 27001 Certificate | valid    | 2025-03-15  | renewal_soon  |
      | DPA Agreement         | valid    | 2025-01-15  | renew_now     |
      | Insurance Certificate | valid    | 2025-12-31  | none          |
    And I should be able to upload new documents
    And I should flag expiring documents

  @api @compliance @vendor
  Scenario: Handle vendor compliance incident
    Given a vendor has experienced a security incident
    When I document the incident:
      | field              | value                              |
      | vendor             | Analytics Co                       |
      | incident_type      | data_breach                        |
      | date_notified      | 2024-12-28                         |
      | data_affected      | possibly user analytics data       |
      | vendor_response    | investigation in progress          |
    Then incident should be logged
    And impact assessment should be initiated
    And notification obligations should be evaluated
    And a VendorIncidentRecorded event should be published

  # ===========================================================================
  # LEGAL DOCUMENT MANAGEMENT
  # ===========================================================================

  @api @compliance @documents
  Scenario: Manage legal document repository
    Given the platform maintains legal documents
    When I view the document repository
    Then I should see documents organized by category:
      | category           | document_count | last_updated |
      | Policies           | 15             | 2024-12-15   |
      | Contracts          | 45             | 2024-12-20   |
      | Regulatory_Filings | 12             | 2024-11-01   |
      | Audit_Reports      | 8              | 2024-10-15   |
    And I should be able to search documents
    And I should see document version history

  @api @compliance @documents
  Scenario: Upload legal document with metadata
    Given I need to add a new contract
    When I upload the document:
      | field              | value                              |
      | document_type      | vendor_contract                    |
      | title              | Cloud Services Agreement 2025      |
      | parties            | Platform, Cloud Host Inc           |
      | effective_date     | 2025-01-01                         |
      | expiry_date        | 2026-12-31                         |
      | confidentiality    | confidential                       |
      | tags               | vendor, infrastructure, cloud      |
    Then document should be uploaded
    And metadata should be indexed
    And access controls should be applied
    And a LegalDocumentUploaded event should be published

  @api @compliance @documents
  Scenario: Manage document access controls
    Given sensitive legal documents exist
    When I configure access controls for "Executive Contracts":
      | role               | access_level |
      | legal_admin        | full         |
      | legal_team         | read         |
      | executive          | read         |
      | general_staff      | none         |
    Then access controls should be applied
    And access should be enforced on document requests
    And access attempts should be logged

  @api @compliance @documents
  Scenario: Track document version history
    Given a policy document has multiple versions
    When I view version history for "Privacy Policy"
    Then I should see all versions:
      | version | date       | author      | changes_summary              |
      | 3.0     | 2024-09-01 | LegalTeam   | GDPR updates                 |
      | 2.5     | 2024-03-01 | LegalTeam   | CCPA compliance additions    |
      | 2.0     | 2023-09-01 | LegalTeam   | Major restructure            |
    And I should be able to compare versions
    And I should be able to restore previous versions

  @api @compliance @documents
  Scenario: Set document retention policies
    Given documents have different retention requirements
    When I configure retention policies:
      | document_type      | retention_period | action_after  |
      | contracts          | 7 years          | archive       |
      | audit_reports      | 10 years         | archive       |
      | policies           | indefinite       | version_only  |
      | correspondence     | 3 years          | delete        |
    Then retention policies should be applied
    And documents should be flagged when retention expires
    And disposal should require approval

  # ===========================================================================
  # DATA BREACH RESPONSE
  # ===========================================================================

  @api @compliance @breach
  Scenario: Initiate data breach response
    Given a potential data breach has been detected
    When I initiate breach response:
      | field              | value                              |
      | incident_id        | BR-2024-001                        |
      | detected_date      | 2024-12-28                         |
      | detected_by        | Security Monitoring                |
      | initial_assessment | Potential unauthorized access      |
      | severity           | high                               |
    Then breach response workflow should start
    And incident response team should be notified
    And containment procedures should be initiated
    And a DataBreachInitiated event should be published

  @api @compliance @breach
  Scenario: Assess breach scope and impact
    Given breach response BR-2024-001 is active
    When I assess breach impact:
      | assessment_area    | finding                            |
      | data_types_affected| email, username, hashed_password   |
      | records_affected   | approximately 5,000                |
      | user_segments      | EU users, US users                 |
      | root_cause         | SQL injection vulnerability        |
      | ongoing_risk       | vulnerability patched              |
    Then impact assessment should be documented
    And regulatory notification requirements should be evaluated
    And affected users should be identified

  @api @compliance @breach
  Scenario: Determine regulatory notification requirements
    Given breach impact has been assessed
    When I evaluate notification requirements
    Then I should see notification obligations:
      | regulation | threshold_met | notification_deadline | authority              |
      | GDPR       | yes           | 72 hours              | Lead DPA (Ireland)     |
      | CCPA       | yes           | without delay         | California AG          |
      | State_Laws | varies        | varies                | Multiple state AGs     |
    And I should see user notification requirements
    And notification templates should be prepared

  @api @compliance @breach
  Scenario: Notify regulatory authorities
    Given GDPR notification is required
    When I submit regulatory notification:
      | field                  | value                              |
      | authority              | Irish Data Protection Commission   |
      | notification_date      | 2024-12-28                         |
      | incident_summary       | Unauthorized access to user data   |
      | data_categories        | email, username                    |
      | records_affected       | 5,000 EU residents                 |
      | containment_measures   | Vulnerability patched              |
      | dpo_contact            | dpo@platform.com                   |
    Then notification should be submitted
    And submission should be documented
    And follow-up requirements should be tracked
    And a RegulatoryNotificationSent event should be published

  @api @compliance @breach
  Scenario: Notify affected users
    Given user notification is required
    When I initiate user notifications:
      | setting                | value                              |
      | notification_method    | email                              |
      | template               | breach_notification_v1             |
      | include_details        | breach description, steps taken    |
      | recommended_actions    | password reset, monitor accounts   |
      | support_contact        | breach-support@platform.com        |
    Then notifications should be sent to affected users
    And delivery should be tracked
    And bounce/failure handling should be configured
    And a UserBreachNotificationSent event should be published

  @api @compliance @breach
  Scenario: Document breach response and lessons learned
    Given breach response is complete
    When I document the incident closure:
      | section                | content                            |
      | incident_timeline      | Full chronology of events          |
      | root_cause_analysis    | SQL injection via search feature   |
      | containment_actions    | Patched vulnerability, rotated keys|
      | remediation_steps      | Code review, security training     |
      | lessons_learned        | Input validation critical          |
      | preventive_measures    | Implement WAF, penetration testing |
    Then incident report should be created
    And preventive actions should be tracked
    And report should be stored in compliance records

  # ===========================================================================
  # REGULATORY REPORTING
  # ===========================================================================

  @api @compliance @reporting
  Scenario: Generate regulatory compliance report
    Given quarterly reporting is due
    When I generate GDPR compliance report
    Then report should include:
      | section                    | data_included                      |
      | processing_activities      | All data processing records        |
      | data_subject_requests      | DSR statistics and outcomes        |
      | breach_incidents           | Any breaches and responses         |
      | consent_statistics         | Opt-in/opt-out rates               |
      | vendor_compliance          | Third-party processor status       |
      | training_completion        | Staff training records             |
    And report should be formatted per regulatory requirements
    And report should be reviewed before submission

  @api @compliance @reporting
  Scenario: Submit regulatory filing
    Given a regulatory filing is due
    When I submit the filing:
      | field              | value                              |
      | regulation         | GDPR Article 30 Records            |
      | authority          | Irish DPC                          |
      | filing_type        | Annual processing records          |
      | submission_method  | Online portal                      |
    Then filing should be submitted
    And confirmation should be received
    And filing should be logged
    And a RegulatoryFilingSubmitted event should be published

  @api @compliance @reporting
  Scenario: Track regulatory correspondence
    Given we communicate with regulators
    When I view regulatory correspondence
    Then I should see all correspondence:
      | date       | authority    | type         | subject                    | status   |
      | 2024-12-15 | Irish DPC    | inquiry      | Processing activities      | resolved |
      | 2024-11-01 | California AG| notification | CCPA annual certification  | complete |
    And I should be able to log new correspondence
    And response deadlines should be tracked

  # ===========================================================================
  # INTERNATIONAL COMPLIANCE
  # ===========================================================================

  @api @compliance @international
  Scenario: Manage multi-jurisdiction compliance
    Given the platform operates internationally
    When I view jurisdiction compliance map
    Then I should see compliance status by region:
      | jurisdiction       | regulations       | status    | notes                   |
      | European Union     | GDPR              | compliant | Annual review completed |
      | United States      | CCPA, State Laws  | compliant | Multiple state laws     |
      | United Kingdom     | UK GDPR           | compliant | Post-Brexit updates     |
      | Canada             | PIPEDA            | compliant | Provincial variations   |
      | Brazil             | LGPD              | in_progress| Implementation ongoing |
    And I should see per-jurisdiction requirements
    And I should see upcoming regulatory changes

  @api @compliance @international
  Scenario: Manage data transfer mechanisms
    Given data is transferred internationally
    When I configure data transfer settings
    Then I should see transfer mechanisms:
      | transfer_route   | mechanism                    | status    | expiry     |
      | EU to US         | Standard Contractual Clauses | active    | 2025-06-30 |
      | EU to UK         | Adequacy Decision            | active    | indefinite |
      | EU to Brazil     | SCCs + supplementary measures| active    | 2025-03-15 |
    And I should be able to manage transfer agreements
    And I should monitor regulatory changes affecting transfers

  @api @compliance @international
  Scenario: Configure geo-specific privacy settings
    Given different regions have different requirements
    When I configure regional settings:
      | region    | setting                      | value           |
      | EU        | cookie_consent_required      | true            |
      | EU        | right_to_erasure            | enabled         |
      | US_CA     | do_not_sell_option          | enabled         |
      | Brazil    | portuguese_privacy_notice    | enabled         |
    Then regional settings should be applied
    And users should see region-appropriate options
    And compliance should be verified per region

  # ===========================================================================
  # COMPLIANCE RISK ASSESSMENT
  # ===========================================================================

  @api @compliance @risk
  Scenario: Conduct compliance risk assessment
    Given annual risk assessment is due
    When I initiate risk assessment:
      | field              | value                    |
      | assessment_type    | comprehensive            |
      | scope              | all_regulations          |
      | methodology        | NIST_RMF                 |
      | assessor           | Internal Audit Team      |
    Then assessment framework should be applied
    And risk areas should be identified
    And a ComplianceRiskAssessmentStarted event should be published

  @api @compliance @risk
  Scenario: Document compliance risks
    Given risk assessment is in progress
    When I document identified risks:
      | risk_id | area            | description                    | likelihood | impact | score |
      | CR-001  | Data Retention  | Over-retention of user data    | medium     | high   | high  |
      | CR-002  | Access Control  | Overly broad data access       | low        | high   | medium|
      | CR-003  | Documentation   | Policy documentation gaps      | medium     | medium | medium|
    Then risks should be recorded
    And risk scores should be calculated
    And mitigation plans should be required for high risks

  @api @compliance @risk
  Scenario: Create risk mitigation plans
    Given high-priority risks have been identified
    When I create mitigation plan for CR-001:
      | field              | value                              |
      | mitigation_action  | Implement automated data purging   |
      | owner              | Data Engineering Team              |
      | target_date        | 2025-03-31                         |
      | resources_required | Development time, testing          |
      | success_criteria   | No data held beyond policy limits  |
    Then mitigation plan should be created
    And progress tracking should be enabled
    And stakeholders should be notified

  @api @compliance @risk
  Scenario: Monitor risk trends
    Given risks have been tracked over time
    When I view risk dashboard
    Then I should see:
      | metric                    | current | previous | trend   |
      | total_risks               | 15      | 18       | down    |
      | high_risks                | 2       | 4        | down    |
      | risks_mitigated           | 8       | 5        | up      |
      | average_mitigation_time   | 45 days | 60 days  | improved|
    And I should see risk heat map
    And I should see emerging risk areas

  # ===========================================================================
  # COMPLIANCE TRAINING
  # ===========================================================================

  @api @compliance @training
  Scenario: Manage compliance training programs
    Given staff require compliance training
    When I view training management
    Then I should see training programs:
      | program                 | audience      | frequency | completion_rate |
      | GDPR Fundamentals       | all_staff     | annual    | 92%             |
      | Data Handling           | data_team     | quarterly | 88%             |
      | Security Awareness      | all_staff     | annual    | 95%             |
      | Incident Response       | security_team | semi-annual| 100%           |
    And I should see upcoming training deadlines
    And I should see staff completion status

  @api @compliance @training
  Scenario: Assign compliance training
    Given new staff have joined
    When I assign training:
      | training_program    | assignees              | due_date   |
      | GDPR Fundamentals   | new_employees_group    | 2025-01-31 |
      | Data Handling       | data_team_new          | 2025-01-15 |
    Then training should be assigned
    And assignees should be notified
    And progress should be tracked
    And a TrainingAssigned event should be published

  @api @compliance @training
  Scenario: Track training completion
    Given training has been assigned
    When I view training status
    Then I should see completion details:
      | employee     | training_program   | status     | score | completed_date |
      | John Doe     | GDPR Fundamentals  | completed  | 95%   | 2024-12-20     |
      | Jane Smith   | GDPR Fundamentals  | in_progress| n/a   | n/a            |
      | Bob Wilson   | GDPR Fundamentals  | not_started| n/a   | n/a            |
    And I should be able to send reminders
    And I should see overdue training alerts

  @api @compliance @training
  Scenario: Generate training compliance report
    Given training records need to be reported
    When I generate training report
    Then report should include:
      | section                | content                          |
      | overall_completion     | 94% staff trained                |
      | program_breakdown      | Completion by program            |
      | department_breakdown   | Completion by department         |
      | overdue_training       | Staff with overdue training      |
      | certification_status   | Valid certifications             |
    And report should be suitable for audit

  # ===========================================================================
  # LEGAL ADVISORY INTEGRATION
  # ===========================================================================

  @api @compliance @legal
  Scenario: Request legal advisory review
    Given a new feature requires legal review
    When I submit advisory request:
      | field              | value                              |
      | request_type       | feature_review                     |
      | description        | New data sharing feature with API  |
      | urgency            | standard                           |
      | affected_areas     | privacy, data_protection           |
      | attachments        | feature_spec.pdf                   |
    Then request should be submitted
    And legal team should be notified
    And SLA tracking should begin
    And a LegalAdvisoryRequested event should be published

  @api @compliance @legal
  Scenario: Track legal advisory status
    Given legal advisory requests have been submitted
    When I view advisory status
    Then I should see requests:
      | request_id | subject                    | status      | assigned_to | due_date   |
      | LA-001     | API data sharing feature   | in_review   | Legal Team  | 2025-01-10 |
      | LA-002     | New terms of service       | completed   | Legal Team  | completed  |
      | LA-003     | International expansion    | pending     | External    | 2025-01-20 |
    And I should see response times
    And I should be able to escalate urgent requests

  @api @compliance @legal
  Scenario: Receive legal advisory opinion
    Given advisory request LA-001 is complete
    When I view the advisory opinion
    Then I should see:
      | field              | value                              |
      | summary            | Feature approved with modifications|
      | recommendations    | Add explicit consent flow          |
      | required_changes   | Update privacy notice              |
      | risk_assessment    | Low risk with recommendations      |
      | follow_up_required | Implementation review              |
    And I should be able to acknowledge and act
    And opinion should be stored in records

  # ===========================================================================
  # COMPLIANCE AUTOMATION
  # ===========================================================================

  @api @compliance @automation
  Scenario: Configure compliance automation rules
    Given manual compliance checks are time-consuming
    When I configure automation rules:
      | rule_type              | trigger                  | action                    |
      | consent_expiry         | consent_older_than_1yr   | prompt_renewal            |
      | data_retention         | data_past_retention      | flag_for_deletion         |
      | dsr_deadline           | 5_days_before_deadline   | send_reminder             |
      | vendor_cert_expiry     | 30_days_before_expiry    | alert_procurement         |
    Then automation rules should be active
    And automated actions should be logged
    And a ComplianceAutomationConfigured event should be published

  @api @compliance @automation
  Scenario: Review automated compliance actions
    Given automation has taken actions
    When I review automation log
    Then I should see automated actions:
      | timestamp    | rule                   | action_taken             | outcome      |
      | 2024-12-28   | consent_expiry         | prompted 150 users       | 120 renewed  |
      | 2024-12-27   | data_retention         | flagged 5,000 records    | pending      |
      | 2024-12-26   | dsr_deadline           | sent 3 reminders         | all resolved |
    And I should be able to override automated actions
    And I should be able to adjust rule parameters

  @api @compliance @automation
  Scenario: Set up compliance monitoring alerts
    Given I want proactive compliance monitoring
    When I configure monitoring alerts:
      | alert_type             | condition                   | recipients           |
      | high_risk_vendor       | risk_score > 80             | procurement, legal   |
      | dsr_backlog            | pending_dsr > 10            | privacy_team         |
      | consent_rate_drop      | opt_in_rate_drop > 10%      | marketing, privacy   |
      | audit_finding          | new_high_severity_finding   | ciso, legal          |
    Then alerts should be configured
    And alert conditions should be monitored
    And notifications should be sent when triggered

  # ===========================================================================
  # COMPLIANCE METRICS
  # ===========================================================================

  @api @compliance @metrics
  Scenario: Track overall compliance metrics
    Given compliance activities are ongoing
    When I view compliance metrics dashboard
    Then I should see:
      | metric                        | value    | target   | status  |
      | overall_compliance_score      | 94%      | 95%      | warning |
      | dsr_completion_rate           | 98%      | 100%     | good    |
      | training_completion           | 92%      | 95%      | warning |
      | vendor_compliance_rate        | 100%     | 100%     | good    |
      | open_audit_findings           | 3        | 0        | warning |
    And I should see trends over time
    And I should see comparison to industry benchmarks

  @api @compliance @metrics
  Scenario: Generate compliance scorecard
    Given stakeholders need compliance visibility
    When I generate compliance scorecard
    Then scorecard should include:
      | category               | score | grade | trend   |
      | Privacy Compliance     | 95%   | A     | stable  |
      | Data Protection        | 92%   | A-    | up      |
      | Vendor Management      | 100%  | A+    | stable  |
      | Training & Awareness   | 88%   | B+    | down    |
      | Incident Response      | 96%   | A     | up      |
    And scorecard should be exportable
    And scorecard should be suitable for board reporting

  @api @compliance @metrics
  Scenario: Set compliance KPIs and targets
    Given I want to track against goals
    When I set compliance KPIs:
      | kpi                           | target   | measurement_period |
      | DSR response within SLA       | 100%     | monthly            |
      | Staff training completion     | 95%      | quarterly          |
      | Zero critical audit findings  | 0        | annual             |
      | Vendor compliance rate        | 100%     | monthly            |
    Then KPIs should be tracked
    And progress should be visible on dashboard
    And alerts should trigger when off-track

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: ComplianceIssueCreated triggers workflow
    Given a compliance issue is identified
    When ComplianceIssueCreated event is published
    Then the event should contain:
      | field           | description                    |
      | issue_id        | Unique issue identifier        |
      | severity        | high/medium/low                |
      | regulation      | Affected regulation            |
      | description     | Issue description              |
    And issue should appear in compliance queue
    And notifications should be sent based on severity
    And SLA tracking should begin

  @domain-events
  Scenario: DataBreachDetected triggers response
    Given a data breach is detected
    When DataBreachDetected event is published
    Then the event should contain:
      | field           | description                    |
      | incident_id     | Unique incident identifier     |
      | detection_time  | When breach was detected       |
      | initial_scope   | Preliminary impact assessment  |
      | severity        | Severity level                 |
    And incident response team should be alerted
    And containment procedures should initiate
    And timeline documentation should begin

  @domain-events
  Scenario: DSRCompleted updates metrics
    Given a data subject request is completed
    When DSRCompleted event is published
    Then the event should contain:
      | field           | description                    |
      | request_id      | DSR identifier                 |
      | request_type    | access/erasure/portability     |
      | completion_time | Time to complete               |
      | within_sla      | Met regulatory deadline        |
    And compliance metrics should be updated
    And if SLA missed, escalation should occur

  @domain-events
  Scenario: AuditFindingResolved updates status
    Given an audit finding is resolved
    When AuditFindingResolved event is published
    Then the event should contain:
      | field           | description                    |
      | finding_id      | Finding identifier             |
      | resolution      | How it was resolved            |
      | resolved_by     | Who resolved it                |
      | evidence        | Supporting documentation       |
    And finding status should update
    And audit report should be refreshed
    And stakeholders should be notified

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle compliance service unavailable
    Given compliance service is experiencing issues
    When I attempt to access compliance dashboard
    Then I should see graceful error message
    And cached compliance data should be shown if available
    And I should see last updated timestamp
    And a ComplianceServiceError event should be published

  @api @error
  Scenario: Handle DSR processing failure
    Given a DSR is being processed
    And a system error occurs
    When processing fails
    Then error should be logged
    And DSR should remain in queue
    And responsible team should be notified
    And I should be able to retry processing
    And SLA clock should be preserved

  @api @error
  Scenario: Handle regulatory submission failure
    Given I am submitting a regulatory filing
    And the authority's portal is unavailable
    When submission fails
    Then failure should be documented
    And alternative submission methods should be suggested
    And deadline tracking should continue
    And retry should be scheduled

  @api @error
  Scenario: Handle concurrent compliance updates
    Given two admins are updating the same compliance record
    When both submit updates simultaneously
    Then one update should succeed
    And the other should see conflict notification
    And conflict resolution options should be presented
    And audit trail should capture both attempts
