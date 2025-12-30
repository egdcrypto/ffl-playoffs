Feature: Admin Data Privacy Management
  As an Admin
  I want to manage data privacy, GDPR compliance, and user data rights
  So that the platform adheres to privacy regulations and protects user data

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And the privacy management system is enabled
    And the platform operates in GDPR-compliant mode

  # ===========================================
  # GDPR Compliance Dashboard
  # ===========================================

  Scenario: Admin views GDPR compliance dashboard
    When the admin navigates to the privacy compliance dashboard
    Then the dashboard displays the following compliance metrics:
      | metric                        | description                          |
      | Overall Compliance Score      | Percentage of GDPR requirements met  |
      | Pending Data Requests         | Number of unprocessed user requests  |
      | Consent Coverage              | Percentage of users with valid consent |
      | Data Retention Compliance     | Status of retention policy adherence |
      | Last Audit Date               | Date of most recent compliance audit |
    And compliance issues are highlighted with severity levels

  Scenario: Admin views GDPR compliance by category
    When the admin views compliance breakdown
    Then compliance is shown by category:
      | category                    | status    | score |
      | Lawful Basis for Processing | Compliant | 100%  |
      | Data Subject Rights         | Compliant | 98%   |
      | Data Breach Notification    | Compliant | 100%  |
      | Privacy by Design           | Partial   | 85%   |
      | Data Protection Officer     | Compliant | 100%  |
      | International Transfers     | Compliant | 95%   |
    And each category shows detailed requirements and status

  Scenario: Admin views pending compliance actions
    Given there are outstanding compliance actions
    When the admin views pending actions
    Then the following actions are displayed:
      | action                           | priority | due_date   |
      | Process deletion request #1234   | High     | 2024-01-15 |
      | Update privacy policy            | Medium   | 2024-01-30 |
      | Complete DPO quarterly review    | Low      | 2024-02-28 |
    And actions are sorted by priority and due date

  Scenario: Admin acknowledges compliance action
    Given there is a pending compliance action
    When the admin marks the action as completed
    Then the action status changes to "COMPLETED"
    And the completion is logged with timestamp and admin details
    And the compliance score is recalculated

  Scenario: Admin views GDPR compliance timeline
    Given the platform has compliance history
    When the admin views the compliance timeline
    Then historical compliance events are displayed:
      | date       | event                              | actor            |
      | 2024-01-10 | Privacy policy updated             | admin@example.com|
      | 2024-01-08 | Deletion request processed         | system           |
      | 2024-01-05 | New consent mechanism deployed     | admin@example.com|
    And the admin can filter by event type and date range

  # ===========================================
  # Data Retention Policies
  # ===========================================

  Scenario: Admin views data retention policies
    When the admin navigates to data retention settings
    Then the following retention policies are displayed:
      | data_category        | retention_period | auto_delete | legal_basis          |
      | User Account Data    | 3 years          | Yes         | Contractual          |
      | Game History         | 5 years          | Yes         | Legitimate Interest  |
      | Transaction Records  | 7 years          | No          | Legal Obligation     |
      | Audit Logs           | 2 years          | Yes         | Legitimate Interest  |
      | Marketing Preferences| Until Withdrawn  | Yes         | Consent              |

  Scenario: Admin creates a new retention policy
    Given the admin is on the retention policies page
    When the admin creates a retention policy with:
      | field              | value                   |
      | data_category      | AI Interaction Logs     |
      | retention_period   | 1 year                  |
      | auto_delete        | true                    |
      | legal_basis        | Legitimate Interest     |
      | description        | AI chat history cleanup |
    Then the retention policy is created
    And the policy is applied to existing data
    And an audit log entry is created

  Scenario: Admin modifies an existing retention policy
    Given a retention policy exists for "Game History"
    When the admin updates the retention period to "7 years"
    Then the policy is updated successfully
    And affected data is recalculated for new retention dates
    And users are notified of the policy change if required

  Scenario: Admin views data scheduled for deletion
    Given retention policies are configured
    When the admin views data scheduled for deletion
    Then the report shows:
      | data_category      | records_count | scheduled_date | size_gb |
      | Expired Sessions   | 12,450        | 2024-01-20     | 0.8     |
      | Old Game History   | 3,280         | 2024-01-25     | 2.4     |
      | Inactive Accounts  | 156           | 2024-02-01     | 0.3     |
    And the admin can preview data before deletion

  Scenario: Admin manually triggers retention cleanup
    Given data has exceeded its retention period
    When the admin triggers manual cleanup for "Expired Sessions"
    Then a confirmation dialog is shown:
      """
      You are about to permanently delete 12,450 records.
      This action cannot be undone.
      Estimated time: 5 minutes
      """
    And upon confirmation, the data is deleted
    And a deletion certificate is generated

  Scenario: Admin pauses automatic retention deletion
    Given automatic deletion is enabled
    When the admin pauses deletion for "Game History"
    Then automatic deletion is suspended for that category
    And a reason must be provided:
      | reason          | description                    |
      | Legal Hold      | Litigation preservation        |
      | Audit           | Compliance review in progress  |
      | Investigation   | Internal investigation ongoing |
    And the pause is logged with expiration date

  Scenario: Admin views retention policy audit trail
    Given retention policies have been modified
    When the admin views the policy audit trail
    Then changes are displayed:
      | timestamp           | policy           | change              | actor            |
      | 2024-01-10 14:30:00 | Game History     | Period: 5y -> 7y    | admin@example.com|
      | 2024-01-08 10:15:00 | AI Logs          | Policy created      | admin@example.com|
      | 2024-01-05 09:00:00 | User Data        | Auto-delete enabled | system           |

  # ===========================================
  # User Consent Management
  # ===========================================

  Scenario: Admin views consent overview
    When the admin navigates to consent management
    Then the consent dashboard shows:
      | metric                    | value   |
      | Total Users               | 5,420   |
      | Valid Consent             | 5,180   |
      | Pending Consent           | 156     |
      | Withdrawn Consent         | 84      |
      | Consent Rate              | 95.6%   |

  Scenario: Admin views consent by purpose
    When the admin views consent breakdown by purpose
    Then consent is shown for each purpose:
      | purpose                   | consented | declined | pending |
      | Essential Services        | 5,420     | 0        | 0       |
      | Analytics                 | 4,890     | 374      | 156     |
      | Marketing Communications  | 3,245     | 2,019    | 156     |
      | Third-Party Sharing       | 2,156     | 3,108    | 156     |
      | AI-Powered Features       | 4,567     | 697      | 156     |

  Scenario: Admin configures consent purposes
    Given the admin is on consent configuration
    When the admin creates a new consent purpose:
      | field           | value                              |
      | name            | Personalized Recommendations       |
      | description     | Use gameplay data for suggestions  |
      | required        | false                              |
      | default         | false                              |
      | legal_basis     | Consent                            |
    Then the consent purpose is created
    And new users will see this consent option
    And existing users are prompted for consent on next login

  Scenario: Admin views individual user consent
    Given a user "player@example.com" exists
    When the admin views consent for this user
    Then the user's consent history is displayed:
      | purpose                   | status    | timestamp           | method    |
      | Essential Services        | Granted   | 2024-01-01 10:00:00 | Implicit  |
      | Analytics                 | Granted   | 2024-01-01 10:00:00 | Explicit  |
      | Marketing Communications  | Withdrawn | 2024-01-15 14:30:00 | Explicit  |
    And consent changes are tracked with full history

  Scenario: Admin exports consent records
    Given the admin needs consent documentation
    When the admin exports consent records for audit
    Then the export includes:
      | field              | included |
      | user_id            | Yes      |
      | email_hash         | Yes      |
      | consent_purpose    | Yes      |
      | consent_status     | Yes      |
      | consent_timestamp  | Yes      |
      | consent_method     | Yes      |
      | ip_address_hash    | Yes      |
      | user_agent         | Yes      |
    And the export is available in CSV and JSON formats

  Scenario: Admin updates consent collection mechanism
    Given the platform has a consent banner
    When the admin updates the consent banner:
      | field           | value                                    |
      | title           | Your Privacy Choices                     |
      | description     | Control how we use your data             |
      | accept_all      | true                                     |
      | reject_all      | true                                     |
      | granular_opts   | true                                     |
    Then the consent banner is updated
    And changes are previewed before deployment
    And the update is logged for compliance

  Scenario: Admin handles consent withdrawal
    Given a user has withdrawn consent for "Marketing Communications"
    When the admin views the withdrawal
    Then the system shows:
      | field                | value                    |
      | user                 | player@example.com       |
      | purpose              | Marketing Communications |
      | withdrawal_date      | 2024-01-15 14:30:00      |
      | data_processing_stopped | Yes                   |
      | data_deleted         | Pending (7 days)         |
    And marketing data is queued for deletion

  # ===========================================
  # Data Anonymization
  # ===========================================

  Scenario: Admin views anonymization overview
    When the admin navigates to data anonymization
    Then the dashboard shows:
      | metric                    | value     |
      | Total Anonymized Records  | 45,230    |
      | Pending Anonymization     | 1,234     |
      | Anonymization Jobs (24h)  | 12        |
      | Failed Jobs               | 0         |
      | Storage Saved             | 2.4 GB    |

  Scenario: Admin configures anonymization rules
    Given the admin is on anonymization settings
    When the admin creates an anonymization rule:
      | field               | value                          |
      | data_type           | Player Statistics              |
      | trigger             | Account deletion               |
      | fields_to_anonymize | name, email, ip_address        |
      | method              | Pseudonymization               |
      | retain_aggregates   | true                           |
    Then the anonymization rule is created
    And it will be applied to future deletions

  Scenario: Admin views anonymization methods
    When the admin views available anonymization methods
    Then the following methods are displayed:
      | method              | description                           | reversible |
      | Pseudonymization    | Replace with consistent pseudonym     | Yes        |
      | Generalization      | Replace with broader category         | No         |
      | Suppression         | Remove data entirely                  | No         |
      | Data Masking        | Partial redaction (e.g., email)       | No         |
      | Noise Addition      | Add statistical noise                 | No         |
      | K-Anonymity         | Ensure k identical records exist      | No         |

  Scenario: Admin runs manual anonymization
    Given a user has requested account deletion
    When the admin runs anonymization for the user
    Then the following data is anonymized:
      | data_field          | original_value        | anonymized_value     |
      | name                | John Smith            | User_A7F3B9C2        |
      | email               | john@example.com      | anon_a7f3b9@ffl.anon |
      | ip_address          | 192.168.1.100         | 0.0.0.0              |
      | date_of_birth       | 1990-05-15            | 1990-01-01           |
    And game statistics are retained with anonymized user reference
    And an anonymization certificate is generated

  Scenario: Admin verifies anonymization completeness
    Given anonymization has been performed
    When the admin runs anonymization verification
    Then the verification report shows:
      | check                    | status  | details                    |
      | PII Removal              | Passed  | No PII found in records    |
      | Cross-Reference Check    | Passed  | No re-identification risk  |
      | Backup Purge             | Passed  | PII removed from backups   |
      | Log Sanitization         | Passed  | Logs cleaned               |
    And any failures are flagged for manual review

  Scenario: Admin views anonymization job history
    Given anonymization jobs have been executed
    When the admin views job history
    Then completed jobs are displayed:
      | job_id     | type           | records | duration | status    |
      | JOB-001234 | User Deletion  | 1       | 2.3s     | Completed |
      | JOB-001233 | Batch Cleanup  | 450     | 45.2s    | Completed |
      | JOB-001232 | Retention Rule | 1,234   | 120.5s   | Completed |
    And job details can be expanded for audit purposes

  Scenario: Admin configures anonymization for analytics
    Given the admin wants to preserve analytics value
    When the admin configures analytics anonymization:
      | setting                   | value                |
      | aggregate_threshold       | 10                   |
      | time_granularity          | Weekly               |
      | geographic_precision      | Country              |
      | demographic_buckets       | Age ranges (10 year) |
    Then anonymized data can still be used for analytics
    And individual identification is prevented

  # ===========================================
  # Privacy Reports
  # ===========================================

  Scenario: Admin generates privacy impact assessment
    Given the admin needs to assess privacy impact
    When the admin generates a Privacy Impact Assessment (PIA)
    Then the report includes:
      | section                    | included |
      | Data Processing Overview   | Yes      |
      | Data Flow Diagrams         | Yes      |
      | Risk Assessment            | Yes      |
      | Mitigation Measures        | Yes      |
      | Third-Party Processors     | Yes      |
      | Data Subject Rights        | Yes      |
      | Retention Schedules        | Yes      |
    And the report is timestamped and versioned

  Scenario: Admin views data processing activities register
    When the admin views the processing activities register
    Then the register shows:
      | activity                | purpose              | legal_basis    | recipients     |
      | User Registration       | Account creation     | Contract       | None           |
      | Game Score Processing   | Service delivery     | Contract       | None           |
      | Analytics Processing    | Service improvement  | Consent        | Analytics Co   |
      | Marketing Emails        | Promotional content  | Consent        | Email Provider |
      | Fraud Detection         | Security             | Legit Interest | None           |
    And each activity includes data categories and retention periods

  Scenario: Admin generates data subject access report
    Given a user "player@example.com" exists
    When the admin generates a data access report for this user
    Then the report includes all data held:
      | category           | data_types                           |
      | Account Info       | Name, email, profile picture         |
      | Game Data          | Team selections, scores, rankings    |
      | Activity Logs      | Login history, feature usage         |
      | Preferences        | Notification settings, consent       |
      | Financial          | Transaction history (if applicable)  |
    And the report is available in machine-readable format

  Scenario: Admin views privacy metrics report
    When the admin generates a privacy metrics report
    Then the report shows:
      | metric                          | current | previous | trend |
      | Data Subject Requests           | 45      | 38       | +18%  |
      | Average Response Time (days)    | 2.3     | 3.1      | -26%  |
      | Consent Rate                    | 95.6%   | 94.2%    | +1.4% |
      | Data Breach Incidents           | 0       | 0        | 0%    |
      | Privacy Complaints              | 2       | 5        | -60%  |

  Scenario: Admin schedules recurring privacy reports
    Given the admin wants regular privacy reporting
    When the admin schedules a monthly privacy report
    Then the report is configured:
      | field         | value                              |
      | frequency     | Monthly                            |
      | day           | First Monday                       |
      | recipients    | admin@example.com, dpo@example.com |
      | format        | PDF                                |
      | sections      | All                                |
    And reports are automatically generated and distributed

  Scenario: Admin views third-party data sharing report
    When the admin views third-party data sharing
    Then the report shows data shared with:
      | third_party        | data_categories      | purpose            | safeguards         |
      | Analytics Provider | Usage statistics     | Service improvement| DPA signed         |
      | Email Service      | Email addresses      | Communications     | SCCs in place      |
      | Payment Processor  | Transaction data     | Payment processing | PCI-DSS compliant  |
    And data transfer mechanisms are documented

  Scenario: Admin exports compliance documentation
    Given the admin needs compliance evidence
    When the admin exports compliance documentation
    Then a compliance package is generated including:
      | document                    | format |
      | Privacy Policy              | PDF    |
      | Cookie Policy               | PDF    |
      | Processing Register         | CSV    |
      | Consent Records             | CSV    |
      | DPA Agreements              | PDF    |
      | Security Measures           | PDF    |
    And the package is timestamped for audit purposes

  # ===========================================
  # Right to Be Forgotten (Data Deletion)
  # ===========================================

  Scenario: Admin views deletion request queue
    Given there are pending deletion requests
    When the admin views the deletion request queue
    Then pending requests are displayed:
      | request_id | user              | request_date | deadline   | status    |
      | DEL-001234 | player@example.com| 2024-01-10   | 2024-02-10 | Pending   |
      | DEL-001235 | user2@example.com | 2024-01-12   | 2024-02-12 | In Review |
      | DEL-001236 | user3@example.com | 2024-01-14   | 2024-02-14 | Pending   |
    And requests approaching deadline are highlighted

  Scenario: Admin reviews deletion request
    Given a deletion request exists for "player@example.com"
    When the admin reviews the request
    Then the review screen shows:
      | field                    | value                          |
      | user_email               | player@example.com             |
      | account_created          | 2023-06-15                     |
      | data_categories          | Account, Game, Activity, Prefs |
      | data_volume              | 2.4 MB                         |
      | legal_holds              | None                           |
      | third_party_sharing      | Analytics, Email Service       |
    And the admin can see data that will be deleted vs retained

  Scenario: Admin approves deletion request
    Given a deletion request is under review
    When the admin approves the deletion
    Then the following actions are triggered:
      | action                          | status    |
      | Account deactivation            | Completed |
      | Personal data anonymization     | Queued    |
      | Third-party deletion requests   | Sent      |
      | Backup data queued for purge    | Scheduled |
      | Audit log entry created         | Completed |
    And the user receives confirmation email
    And deletion must complete within 30 days

  Scenario: Admin rejects deletion request with reason
    Given a deletion request exists
    And there is a legal obligation to retain data
    When the admin rejects the request with reason "Legal Hold - Active Investigation"
    Then the request status changes to "REJECTED"
    And the user is notified with:
      """
      Your data deletion request has been declined.
      Reason: Legal Hold - Active Investigation

      Under GDPR Article 17(3), we are required to retain certain data
      for compliance with legal obligations. You may contact our DPO
      for more information.
      """
    And the rejection is logged with full justification

  Scenario: Admin handles partial deletion request
    Given a user requests deletion of specific data only
    When the admin reviews the partial deletion request:
      | data_to_delete      | data_to_retain           |
      | Marketing data      | Account data             |
      | Activity logs       | Transaction records      |
      | AI interaction logs | Game history (anonymized)|
    Then the admin can approve partial deletion
    And only specified data categories are deleted
    And retained data categories are documented

  Scenario: Admin tracks deletion request progress
    Given a deletion request has been approved
    When the admin views deletion progress
    Then the progress shows:
      | step                        | status      | completed_at        |
      | Account Deactivation        | Completed   | 2024-01-15 10:00:00 |
      | Primary Database Deletion   | Completed   | 2024-01-15 10:05:00 |
      | Cache Invalidation          | Completed   | 2024-01-15 10:06:00 |
      | Third-Party Notifications   | In Progress | -                   |
      | Backup Purge                | Pending     | -                   |
    And estimated completion time is displayed

  Scenario: Admin verifies deletion completion
    Given a deletion request has been processed
    When the admin runs deletion verification
    Then the verification checks:
      | check                       | status  | details                    |
      | Primary Database            | Passed  | No user records found      |
      | Secondary Databases         | Passed  | All references removed     |
      | File Storage                | Passed  | User files deleted         |
      | Backup Systems              | Passed  | Marked for next purge      |
      | Third-Party Confirmation    | Passed  | 3/3 confirmations received |
    And a deletion certificate is generated

  Scenario: Admin generates deletion certificate
    Given deletion has been verified
    When the admin generates the deletion certificate
    Then the certificate includes:
      | field                    | value                              |
      | request_id               | DEL-001234                         |
      | user_identifier          | player@example.com (now anonymized)|
      | request_date             | 2024-01-10                         |
      | completion_date          | 2024-01-15                         |
      | data_deleted             | Account, Game, Activity, Marketing |
      | data_retained            | Anonymized aggregates              |
      | retention_justification  | Statistical purposes               |
      | verified_by              | admin@example.com                  |
    And the certificate is stored for compliance records

  Scenario: Admin handles deletion request timeout
    Given a deletion request is approaching its 30-day deadline
    When 5 days remain before the deadline
    Then an escalation alert is sent to:
      | recipient        | priority |
      | Assigned Admin   | High     |
      | DPO              | High     |
      | Compliance Team  | Medium   |
    And the request is flagged as urgent

  # ===========================================
  # Data Subject Access Requests (DSAR)
  # ===========================================

  Scenario: Admin views DSAR queue
    Given there are pending data access requests
    When the admin views the DSAR queue
    Then pending requests are displayed:
      | request_id | user              | type        | deadline   | status    |
      | DSAR-001   | player@example.com| Full Export | 2024-02-10 | Pending   |
      | DSAR-002   | user2@example.com | Specific    | 2024-02-12 | In Review |

  Scenario: Admin processes data access request
    Given a DSAR exists for "player@example.com"
    When the admin processes the request
    Then the system compiles all user data
    And the export is prepared in the requested format
    And sensitive internal data is excluded
    And the user is notified when export is ready

  Scenario: Admin verifies requester identity
    Given a DSAR has been submitted
    When the admin initiates identity verification
    Then verification options are offered:
      | method                  | description                    |
      | Email Verification      | Send code to registered email  |
      | Security Questions      | Answer account security Qs     |
      | ID Document Upload      | Upload government ID           |
    And the request is held until verification completes

  # ===========================================
  # Data Portability
  # ===========================================

  Scenario: Admin processes data portability request
    Given a user requests data portability
    When the admin processes the request
    Then the export includes:
      | data_type          | format   | machine_readable |
      | Profile Data       | JSON     | Yes              |
      | Game History       | JSON     | Yes              |
      | Preferences        | JSON     | Yes              |
      | Transaction History| CSV      | Yes              |
    And data is provided in commonly-used formats
    And the export can be imported to other services

  Scenario: Admin transfers data to another service
    Given a user requests data transfer to a competitor
    When the admin initiates data transfer
    Then the transfer package is prepared
    And secure transfer mechanism is used
    And transfer confirmation is obtained
    And the transfer is logged for compliance

  # ===========================================
  # Access Control and Audit
  # ===========================================

  Scenario: Only authorized admins can access privacy settings
    Given I am authenticated as a regular admin
    When I attempt to access privacy management
    Then access is granted based on role:
      | permission                  | admin | privacy_admin | super_admin |
      | View privacy dashboard      | No    | Yes           | Yes         |
      | Process deletion requests   | No    | Yes           | Yes         |
      | Modify retention policies   | No    | Yes           | Yes         |
      | Generate compliance reports | No    | Yes           | Yes         |

  Scenario: Privacy actions are audited
    Given the admin processes a deletion request
    Then an audit log entry is created:
      | field           | value                    |
      | action          | DELETION_REQUEST_APPROVED|
      | actor           | admin@example.com        |
      | subject         | player@example.com       |
      | timestamp       | <now>                    |
      | ip_address      | <client_ip>              |
      | justification   | User requested           |

  Scenario: DPO receives privacy action notifications
    Given the DPO notification is enabled
    When a high-impact privacy action occurs
    Then the DPO receives notification:
      | action                    | notification_type |
      | Deletion request approved | Email             |
      | Retention policy changed  | Email             |
      | Data breach detected      | SMS + Email       |
      | Compliance score dropped  | Email             |

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot delete data under legal hold
    Given user data is under legal hold
    When the admin attempts to process a deletion request
    Then the request is blocked with error "DATA_UNDER_LEGAL_HOLD"
    And the admin must contact legal team to proceed

  Scenario: Admin cannot modify active deletion request
    Given a deletion request is being processed
    When the admin attempts to modify the request
    Then the request is rejected with error "REQUEST_IN_PROGRESS"
    And modifications must wait until current processing completes

  Scenario: Deletion request rejected for invalid identity
    Given a deletion request fails identity verification
    Then the request is suspended with status "IDENTITY_VERIFICATION_FAILED"
    And the user is notified to retry verification
    And the deadline is paused until verification succeeds

  Scenario: Admin cannot access privacy data for other leagues
    Given another admin owns league "Other League"
    When the admin attempts to view privacy data for "Other League"
    Then the request is rejected with error "UNAUTHORIZED_LEAGUE_ACCESS"
    And no privacy data is returned

  Scenario: Export fails for excessively large data
    Given a user has an unusually large data footprint
    When the admin attempts to generate an export
    Then the request is queued for background processing
    And the admin is notified when export is ready
    And the export may be split into multiple files

  Scenario: Retention policy validation errors
    When the admin creates a retention policy with invalid settings:
      | error_case                    | error_code                    |
      | Retention period < 0          | INVALID_RETENTION_PERIOD      |
      | Missing legal basis           | LEGAL_BASIS_REQUIRED          |
      | Conflicting with legal req    | CONFLICTS_LEGAL_REQUIREMENT   |
      | Auto-delete on required data  | CANNOT_DELETE_REQUIRED_DATA   |
    Then the policy is rejected with appropriate error
