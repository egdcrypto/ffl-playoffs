@admin @compliance @regulatory @platform
Feature: Admin Regulatory Compliance
  As a platform administrator
  I want to manage regulatory compliance across jurisdictions
  So that I can ensure the platform meets all applicable regulations

  Background:
    Given I am logged in as a platform administrator
    And I have regulatory compliance permissions
    And the following regulations are configured in the system:
      | regulation | full_name                                    | jurisdiction | status     | last_assessment     |
      | GDPR       | General Data Protection Regulation           | EU           | compliant  | 2024-12-01          |
      | CCPA       | California Consumer Privacy Act              | California   | compliant  | 2024-11-15          |
      | COPPA      | Children's Online Privacy Protection Act     | US           | compliant  | 2024-10-20          |
      | PCI DSS    | Payment Card Industry Data Security Standard | Global       | certified  | 2024-09-30          |
      | SOX        | Sarbanes-Oxley Act                           | US           | compliant  | 2024-12-15          |
      | HIPAA      | Health Insurance Portability and Accountability| US         | n/a        | N/A                 |

  # ============================================
  # COMPLIANCE DASHBOARD
  # ============================================

  Scenario: View comprehensive regulatory compliance dashboard
    When I navigate to the compliance dashboard
    Then I should see overall compliance score:
      | metric                    | value   | trend   |
      | overall_score             | 94%     | +2%     |
      | regulations_compliant     | 5       | stable  |
      | regulations_at_risk       | 0       | stable  |
      | open_findings             | 3       | -2      |
      | pending_assessments       | 2       | +1      |
    And I should see compliance status by regulation:
      | regulation | status    | score | next_assessment | days_until |
      | GDPR       | compliant | 96%   | 2025-03-01      | 62         |
      | CCPA       | compliant | 92%   | 2025-02-15      | 48         |
      | COPPA      | compliant | 98%   | 2025-04-20      | 112        |
      | PCI DSS    | certified | 100%  | 2025-09-30      | 275        |
      | SOX        | compliant | 91%   | 2025-06-15      | 168        |
    And I should see upcoming regulatory deadlines:
      | deadline            | regulation | requirement                    | priority |
      | 2025-01-15          | GDPR       | Annual DPO report submission   | high     |
      | 2025-02-01          | CCPA       | Privacy policy update          | medium   |
      | 2025-02-28          | PCI DSS    | Quarterly penetration test     | high     |
    And I should see recent compliance activities:
      | date       | activity                          | regulation | status    |
      | 2024-12-28 | DSAR processed                    | GDPR       | completed |
      | 2024-12-27 | Vulnerability scan completed      | PCI DSS    | passed    |
      | 2024-12-26 | Consent audit completed           | GDPR       | findings  |

  Scenario: View compliance filtered by jurisdiction
    When I filter the compliance dashboard by jurisdiction "EU"
    Then I should see only EU-applicable regulations:
      | regulation | description                         | status    |
      | GDPR       | General Data Protection Regulation  | compliant |
      | ePrivacy   | ePrivacy Directive                  | compliant |
      | DSA        | Digital Services Act                | in_progress|
    And I should see jurisdiction-specific requirements:
      | requirement                     | status      | evidence_available |
      | Data Protection Officer         | appointed   | yes                |
      | EU representative               | designated  | yes                |
      | Records of processing           | maintained  | yes                |
      | Cross-border transfer mechanism | active      | yes                |
    And I should see EU-specific metrics:
      | metric                    | value       |
      | EU_users                  | 125,000     |
      | DSARs_processed_ytd       | 342         |
      | avg_DSAR_response_days    | 18          |
      | consent_rate              | 78%         |

  Scenario: Drill down into regulation-specific compliance
    When I click on regulation "GDPR"
    Then I should see detailed compliance breakdown:
      | principle                   | status    | score | findings |
      | Lawfulness                  | compliant | 98%   | 0        |
      | Purpose limitation          | compliant | 95%   | 1        |
      | Data minimization           | compliant | 92%   | 1        |
      | Accuracy                    | compliant | 96%   | 0        |
      | Storage limitation          | at_risk   | 85%   | 2        |
      | Integrity and confidentiality| compliant| 99%   | 0        |
      | Accountability              | compliant | 94%   | 1        |
    And I should see related policies and controls
    And I should see historical compliance trend

  # ============================================
  # GDPR COMPLIANCE
  # ============================================

  Scenario: View GDPR compliance dashboard with detailed metrics
    When I view GDPR compliance dashboard
    Then I should see data processing activities:
      | activity                | legal_basis  | data_categories       | recipients    | retention |
      | User account management | Contract     | Contact, Profile      | Internal      | Account+2y|
      | Marketing emails        | Consent      | Email, Preferences    | Email service | Consent   |
      | Analytics               | Legitimate   | Usage, Device         | Analytics svc | 2 years   |
      | Payment processing      | Contract     | Payment, Transaction  | Payment proc  | 7 years   |
    And I should see consent management status:
      | purpose             | consents_given | consent_rate | withdrawals_30d |
      | Marketing           | 98,500         | 78%          | 245             |
      | Analytics           | 112,000        | 89%          | 128             |
      | Third-party sharing | 45,000         | 36%          | 89              |
    And I should see data subject rights fulfillment:
      | right               | requests_ytd | avg_response_days | compliance_rate |
      | Access (DSAR)       | 342          | 18                | 100%            |
      | Erasure             | 156          | 12                | 100%            |
      | Portability         | 45           | 20                | 100%            |
      | Rectification       | 89           | 5                 | 100%            |
      | Objection           | 23           | 8                 | 100%            |
    And I should see cross-border transfer status:
      | destination | mechanism                  | status  | last_review     |
      | US          | Standard Contractual Clauses| active | 2024-11-15      |
      | India       | SCCs + Supplementary       | active  | 2024-10-01      |
      | UK          | Adequacy decision          | active  | 2024-09-15      |

  Scenario: Process GDPR Data Subject Access Request (DSAR) with full workflow
    Given a data subject has submitted an access request via the portal
    When I receive the data subject access request:
      | field              | value                           |
      | request_id         | DSAR-2024-0343                  |
      | subject_email      | user@example.com                |
      | request_type       | access                          |
      | submitted_date     | 2024-12-29                      |
      | deadline           | 2025-01-28 (30 days)            |
    Then the request should be logged with:
      | field              | value                           |
      | status             | received                        |
      | deadline           | 2025-01-28                      |
      | assigned_to        | privacy_team                    |
      | priority           | normal                          |
    And identity verification should be initiated:
      | verification_method | status   |
      | Email confirmation  | pending  |
      | ID document         | optional |
    When identity is verified
    Then data collection should be initiated from:
      | system             | data_categories            | status      |
      | User database      | Profile, Contact           | in_progress |
      | Transaction system | Payments, Orders           | pending     |
      | Analytics          | Usage, Preferences         | pending     |
      | Support tickets    | Communications             | pending     |
    And response should be compiled within 30 days including:
      | section                    | content                        |
      | Personal data held         | All data categories            |
      | Processing purposes        | List of purposes               |
      | Recipients                 | Third parties and categories   |
      | Retention periods          | By data category               |
      | Rights information         | Available rights               |
    And a DSARProcessed domain event should be published with:
      | field              | value                           |
      | request_id         | DSAR-2024-0343                  |
      | response_time_days | actual_days                     |
      | data_categories    | count                           |
      | outcome            | completed                       |

  Scenario: Process GDPR erasure request (Right to be Forgotten)
    Given a data subject requests erasure of their data
    When I process erasure request "DSAR-2024-0344":
      | field              | value                           |
      | request_type       | erasure                         |
      | subject_id         | user-12345                      |
      | scope              | all_personal_data               |
    Then I should evaluate erasure eligibility:
      | data_category      | erasable | reason_if_not                  |
      | Profile data       | yes      | N/A                            |
      | Transaction history| partial  | 7-year financial retention     |
      | Support tickets    | yes      | N/A                            |
      | Analytics          | yes      | N/A                            |
    And erasure should be executed for eligible data:
      | system             | records_deleted | confirmation  |
      | User database      | 1               | yes           |
      | Analytics          | 4,532 events    | yes           |
      | Support tickets    | 12              | yes           |
      | Email preferences  | 1               | yes           |
    And non-erasable data should be documented:
      | data_category      | retention_until | legal_basis           |
      | Transaction history| 2031-12-29      | Legal obligation (tax)|
    And third-party processors should be notified
    And a DataErasureCompleted event should be published

  Scenario: Manage GDPR consent records with audit trail
    When I view consent management for purpose "Marketing"
    Then I should see consent records:
      | metric                    | value       |
      | total_consents            | 98,500      |
      | active_consents           | 97,200      |
      | withdrawn_consents        | 1,300       |
      | avg_consent_age           | 8.5 months  |
    And I should see consent by collection point:
      | collection_point          | consents | rate  |
      | Registration form         | 65,000   | 82%   |
      | Account settings          | 22,000   | 75%   |
      | Marketing popup           | 11,500   | 45%   |
    And I should see consent withdrawal trend over 12 months
    When I export consent proof for "user@example.com"
    Then I should receive proof document containing:
      | field                     | value                          |
      | consent_timestamp         | 2024-03-15 14:32:00 UTC        |
      | consent_version           | v2.1                           |
      | consent_text_hash         | sha256:abc123...               |
      | collection_method         | Registration form              |
      | ip_address_hash           | sha256:def456...               |
      | user_agent                | Chrome 120, Windows 11         |

  Scenario: Configure GDPR data retention with automated enforcement
    When I configure retention policy for data category "user_activity_logs":
      | setting                   | value                          |
      | retention_period          | 2 years                        |
      | retention_basis           | Legitimate interest            |
      | auto_deletion             | enabled                        |
      | pre_deletion_review       | 30 days                        |
      | archive_before_deletion   | yes                            |
      | archive_location          | secure_cold_storage            |
    Then retention policy should be saved
    And automated jobs should be configured:
      | job                       | schedule    | action                    |
      | Identify expired data     | Daily       | Flag for review           |
      | Pre-deletion notification | 30 days out | Notify data owners        |
      | Execute deletion          | After review| Permanent deletion        |
    And I should see data currently exceeding retention:
      | data_type           | records_affected | oldest_record | action_date  |
      | user_activity_logs  | 45,230           | 2022-06-15    | 2025-01-28   |

  # ============================================
  # CCPA COMPLIANCE
  # ============================================

  Scenario: View CCPA compliance dashboard with California-specific metrics
    When I view CCPA compliance dashboard
    Then I should see California user data inventory:
      | data_category           | ca_users_affected | collection_method      |
      | Identifiers             | 45,000            | Direct                 |
      | Commercial information  | 38,000            | Direct, Inferred       |
      | Internet activity       | 45,000            | Automatic              |
      | Geolocation             | 32,000            | Device-based           |
      | Inferences              | 45,000            | Derived                |
    And I should see "Do Not Sell" opt-out status:
      | metric                    | value       |
      | total_ca_users            | 45,000      |
      | opt_out_requests_ytd      | 2,340       |
      | current_opt_outs          | 8,500       |
      | opt_out_rate              | 18.9%       |
    And I should see consumer request fulfillment:
      | request_type        | requests_ytd | avg_response_days | compliance_rate |
      | Know                | 156          | 32                | 100%            |
      | Delete              | 89           | 25                | 100%            |
      | Opt-out             | 2,340        | 1                 | 100%            |
      | Opt-in              | 145          | 1                 | 100%            |

  Scenario: Process CCPA "Do Not Sell" opt-out request
    Given a California user accesses the "Do Not Sell My Personal Information" link
    When the user submits opt-out request:
      | field              | value                           |
      | user_id            | ca-user-6789                    |
      | email              | causer@example.com              |
      | request_source     | Website footer link             |
    Then opt-out should be recorded immediately with:
      | field              | value                           |
      | effective_date     | immediate                       |
      | scope              | all_sale_activities             |
      | confirmation_sent  | yes                             |
    And data sharing should be stopped for:
      | third_party              | data_shared_previously | action           |
      | Advertising Partner A   | Yes                    | Sharing stopped  |
      | Data Broker B           | Yes                    | Sharing stopped  |
      | Analytics Provider C    | No (service provider)  | No change        |
    And third parties should be notified:
      | notification_method | parties_notified | confirmation |
      | API call            | 2                | Yes          |
      | Email               | 1                | Pending      |
    And a CCPAOptOutProcessed event should be published

  Scenario: Generate CCPA annual disclosure report
    When I generate CCPA disclosure report for calendar year 2024
    Then report should include data categories collected:
      | category                | collected | sold | disclosed_for_business |
      | Identifiers             | Yes       | No   | Yes                    |
      | Commercial information  | Yes       | No   | Yes                    |
      | Internet activity       | Yes       | No   | Yes                    |
      | Geolocation             | Yes       | No   | No                     |
      | Inferences              | Yes       | No   | No                     |
    And report should include consumer request metrics:
      | request_type | received | complied_full | complied_part | denied | avg_days |
      | Know         | 156      | 152           | 4             | 0      | 32       |
      | Delete       | 89       | 85            | 4             | 0      | 25       |
      | Opt-out      | 2,340    | 2,340         | 0             | 0      | 1        |
    And report should be formatted for:
      | format     | purpose                              |
      | Website    | Public privacy policy                |
      | PDF        | Regulatory submission                |
      | CSV        | Internal analysis                    |

  Scenario: Handle CCPA authorized agent request
    Given an authorized agent submits a request on behalf of a consumer
    When I receive the agent request:
      | field              | value                              |
      | consumer_email     | consumer@example.com               |
      | agent_name         | Privacy Rights Agency              |
      | request_type       | deletion                           |
      | authorization      | signed_document_attached           |
    Then agent authorization should be verified:
      | verification_step        | status    |
      | Agent registration check | passed    |
      | Consumer authorization   | pending   |
      | Identity verification    | pending   |
    And consumer should be contacted for confirmation
    When consumer confirms authorization
    Then request should proceed as standard deletion request

  # ============================================
  # COPPA COMPLIANCE
  # ============================================

  Scenario: View COPPA compliance dashboard for child user protection
    When I view COPPA compliance dashboard
    Then I should see verified parental consents:
      | metric                    | value       |
      | users_under_13            | 1,250       |
      | verified_consents         | 1,250       |
      | pending_verification      | 0           |
      | consent_rate              | 100%        |
    And I should see minor user data inventory:
      | data_type           | collected | purpose              | minimized |
      | Username            | Yes       | Account              | Yes       |
      | Email (parent)      | Yes       | Consent verification | Yes       |
      | Game scores         | Yes       | Gameplay             | Yes       |
      | Chat messages       | No        | N/A                  | N/A       |
      | Precise location    | No        | N/A                  | N/A       |
    And I should see age verification status:
      | method                    | users_verified | accuracy     |
      | Date of birth entry       | 1,250          | Self-reported|
      | Parental confirmation     | 1,250          | Verified     |

  Scenario: Execute COPPA-compliant parental consent verification
    Given a user indicates their age as under 13 during registration
    When the COPPA consent flow initiates:
      | step | action                              | status    |
      | 1    | Block account creation              | completed |
      | 2    | Collect parent/guardian email       | completed |
      | 3    | Send consent request to parent      | in_progress|
    Then a verifiable consent method should be offered:
      | method                    | description                         |
      | Signed consent form       | Mail/fax signed form                |
      | Credit card verification  | $0.50 charge to verify identity     |
      | Video call verification   | Live video with ID check            |
      | Knowledge-based auth      | Questions only parent would know    |
    When parent completes "Credit card verification"
    Then consent should be recorded with proof:
      | field                     | value                               |
      | parent_email              | parent@example.com                  |
      | verification_method       | Credit card                         |
      | verification_timestamp    | 2024-12-29 15:30:00 UTC             |
      | card_last_four            | 4242                                |
      | consent_scope             | Account creation, gameplay          |
    And a ParentalConsentVerified domain event should be published
    And child account should be activated with restrictions:
      | restriction               | status    |
      | No direct marketing       | enforced  |
      | No third-party sharing    | enforced  |
      | Limited data collection   | enforced  |
      | No chat functionality     | enforced  |

  Scenario: Handle COPPA parental data deletion request
    Given a parent requests deletion of their child's data
    When I process the parental deletion request:
      | field              | value                              |
      | parent_email       | parent@example.com                 |
      | child_username     | player_kiddo123                    |
      | request_type       | full_deletion                      |
    Then parent identity should be verified using original consent method
    And all child data should be identified:
      | data_type           | records_found | location            |
      | Account data        | 1             | User database       |
      | Game scores         | 156           | Gameplay database   |
      | Session logs        | 2,340         | Analytics           |
      | Support tickets     | 0             | Support system      |
    When parent confirms deletion
    Then deletion should complete within 48 hours:
      | step                      | status    | completion_time |
      | Account deactivation      | completed | 1 minute        |
      | Primary data deletion     | completed | 2 hours         |
      | Analytics purge           | completed | 24 hours        |
      | Backup removal            | completed | 48 hours        |
    And confirmation should be sent to parent email
    And a ChildDataDeleted event should be published

  Scenario: Detect and prevent underage user bypass attempts
    Given the platform has COPPA protections enabled
    When a user enters birth date indicating age 12
    And then creates a new account with birth date indicating age 18
    Then the bypass attempt should be detected:
      | detection_method          | triggered |
      | Same device fingerprint   | yes       |
      | Same IP address           | yes       |
      | Time between attempts     | 5 minutes |
    And the second account should be flagged for review
    And COPPA restrictions should be applied pending verification

  # ============================================
  # SOX COMPLIANCE
  # ============================================

  Scenario: View SOX compliance dashboard for financial controls
    When I view SOX compliance dashboard
    Then I should see financial control inventory:
      | control_area            | total_controls | tested | effective | deficient |
      | Revenue Recognition     | 12             | 12     | 11        | 1         |
      | Financial Reporting     | 18             | 18     | 18        | 0         |
      | Access Controls         | 15             | 15     | 14        | 1         |
      | Change Management       | 10             | 10     | 10        | 0         |
      | Data Integrity          | 8              | 8      | 8         | 0         |
    And I should see control testing status:
      | testing_period | controls_tested | pass_rate | deficiencies_found |
      | Q4 2024        | 63              | 97%       | 2                  |
      | Q3 2024        | 63              | 98%       | 1                  |
      | Q2 2024        | 63              | 100%      | 0                  |
    And I should see deficiency tracking:
      | deficiency_id | control           | severity  | remediation_status | due_date   |
      | DEF-2024-001  | Revenue cutoff    | significant| in_progress       | 2025-01-31 |
      | DEF-2024-002  | Admin access review| material  | planned           | 2025-02-28 |

  Scenario: Document SOX control with full attributes
    When I document a new SOX control:
      | field              | value                                    |
      | control_id         | CTRL-REV-013                             |
      | control_name       | Revenue Recognition - Subscription       |
      | objective          | Ensure subscription revenue is recognized per ASC 606 |
      | owner              | Finance Manager - Revenue                |
      | frequency          | Daily                                    |
      | control_type       | Automated                                |
      | assertion          | Accuracy, Completeness, Cutoff           |
      | evidence_type      | System-generated report                  |
      | key_control        | Yes                                      |
    Then control should be added to the control inventory
    And control should be linked to:
      | linkage_type        | linked_to                               |
      | Process             | Revenue Recognition Process             |
      | Risk                | RISK-REV-005 (Revenue misstatement)     |
      | IT System           | Billing System                          |
    And testing schedule should be created:
      | test_type           | frequency   | next_test_date |
      | Design effectiveness| Annual      | 2025-06-30     |
      | Operating effectiveness| Quarterly| 2025-03-31     |

  Scenario: Conduct SOX control effectiveness testing
    Given control "CTRL-REV-013" is scheduled for testing
    When I conduct control test with the following:
      | field              | value                                    |
      | test_id            | TEST-2024-Q4-042                         |
      | control_id         | CTRL-REV-013                             |
      | test_type          | Operating effectiveness                  |
      | sample_size        | 25 transactions                          |
      | testing_period     | Q4 2024                                  |
      | tester             | Internal Audit - John Smith              |
    Then test results should be documented:
      | test_attribute      | result                                   |
      | samples_tested      | 25                                       |
      | samples_passed      | 24                                       |
      | samples_failed      | 1                                        |
      | pass_rate           | 96%                                      |
      | conclusion          | Control operating effectively with exception |
    And exception should be documented:
      | exception_field     | value                                    |
      | sample_id           | TXN-2024-11-15-0042                      |
      | exception_type      | Timing difference                        |
      | root_cause          | Manual processing delay                  |
      | impact              | $5,000 revenue recognized 2 days late    |
    When exception is evaluated
    Then deficiency assessment should be performed:
      | assessment_field    | value                                    |
      | control_deficiency  | Yes                                      |
      | severity            | Control deficiency (not significant)     |
      | remediation_required| Yes                                      |

  # ============================================
  # PCI DSS COMPLIANCE
  # ============================================

  Scenario: View PCI DSS compliance dashboard with all requirements
    When I view PCI DSS compliance dashboard
    Then I should see cardholder data environment (CDE) scope:
      | component           | in_scope | justification                    |
      | Payment API         | Yes      | Processes card data              |
      | Tokenization service| Yes      | Stores tokens                    |
      | Web application     | Yes      | Transmits card data              |
      | User database       | No       | No cardholder data               |
      | Analytics system    | No       | No cardholder data               |
    And I should see requirement compliance status:
      | requirement | description                          | status    | last_validated |
      | 1           | Install and maintain firewall        | compliant | 2024-12-15     |
      | 2           | No vendor-supplied defaults          | compliant | 2024-12-15     |
      | 3           | Protect stored cardholder data       | compliant | 2024-12-15     |
      | 4           | Encrypt transmission                 | compliant | 2024-12-15     |
      | 5           | Protect against malware              | compliant | 2024-12-15     |
      | 6           | Develop secure systems               | compliant | 2024-12-15     |
      | 7           | Restrict access by business need     | compliant | 2024-12-15     |
      | 8           | Identify and authenticate access     | compliant | 2024-12-15     |
      | 9           | Restrict physical access             | compliant | 2024-12-15     |
      | 10          | Track and monitor access             | compliant | 2024-12-15     |
      | 11          | Test security systems                | compliant | 2024-12-01     |
      | 12          | Maintain security policy             | compliant | 2024-11-15     |
    And I should see vulnerability scan results:
      | scan_date   | scan_type    | result | vulnerabilities_found | remediated |
      | 2024-12-01  | External ASV | Pass   | 0                     | N/A        |
      | 2024-11-15  | Internal     | Pass   | 2 (low)               | 2          |

  Scenario: View PCI DSS requirement details with evidence
    When I view PCI DSS requirement "3.4 - Render PAN unreadable"
    Then I should see implementation status:
      | sub_requirement | description                  | status    | method              |
      | 3.4.1           | Encryption in storage        | compliant | AES-256             |
      | 3.4.1           | Truncation displayed         | compliant | First 6, Last 4     |
      | 3.4.1           | Tokenization                 | compliant | Token vault         |
    And I should see evidence documentation:
      | evidence_type       | description                  | date       | location            |
      | Architecture diagram| CDE data flow                | 2024-11-01 | /docs/pci/arch.pdf  |
      | Encryption config   | Database encryption settings | 2024-12-01 | /docs/pci/enc.pdf   |
      | Sample output       | Masked PAN screenshot        | 2024-12-15 | /docs/pci/mask.png  |
    And I should see assessment history:
      | assessment_date | assessor       | result    | notes                    |
      | 2024-09-30      | QSA Company    | Compliant | Annual assessment        |
      | 2024-06-15      | Internal audit | Compliant | Mid-year review          |

  Scenario: Schedule and track PCI vulnerability scan
    When I schedule quarterly vulnerability scan:
      | field              | value                              |
      | scan_type          | External ASV                       |
      | vendor             | Approved Scanning Vendor Inc       |
      | scheduled_date     | 2025-03-01                         |
      | scope              | All external-facing CDE systems    |
      | notification       | security-team@company.com          |
    Then scan should be scheduled and tracked:
      | status_field        | value                             |
      | scan_id             | SCAN-2025-Q1-001                  |
      | status              | Scheduled                         |
      | reminder            | 7 days before                     |
    When scan is completed
    Then results should be documented:
      | result_field        | value                             |
      | scan_date           | 2025-03-01                        |
      | overall_result      | Pass                              |
      | hosts_scanned       | 12                                |
      | vulnerabilities     | 0 critical, 0 high, 1 medium      |
    And remediation should be tracked for any findings:
      | finding             | severity | remediation_deadline | owner         |
      | Outdated TLS cipher | Medium   | 2025-03-15           | Security Team |
    And a PciScanCompleted event should be published

  # ============================================
  # INTERNATIONAL DATA TRANSFERS
  # ============================================

  Scenario: View international data transfer dashboard
    When I view the data transfer dashboard
    Then I should see cross-border data flows:
      | origin | destination | data_categories       | volume_monthly | mechanism            |
      | EU     | US          | User data, Analytics  | 2.5 TB         | SCCs                 |
      | EU     | India       | Support tickets       | 500 GB         | SCCs + Supplementary |
      | EU     | UK          | All categories        | 1.2 TB         | Adequacy decision    |
      | US     | EU          | Account data          | 800 GB         | SCCs                 |
    And I should see transfer mechanism status:
      | mechanism                    | status  | last_review | next_review |
      | EU-US SCCs (2021 version)    | Active  | 2024-11-15  | 2025-05-15  |
      | EU-India SCCs                | Active  | 2024-10-01  | 2025-04-01  |
      | UK Adequacy                  | Active  | 2024-09-15  | 2025-03-15  |
    And I should see adequacy decision tracking:
      | country    | adequacy_status | expiry_date | renewal_status |
      | UK         | Adequate        | 2025-06-27  | Under review   |
      | Japan      | Adequate        | Indefinite  | N/A            |
      | Canada     | Adequate        | Indefinite  | N/A            |

  Scenario: Configure new international data transfer mechanism
    When I configure a new EU-US data transfer:
      | field              | value                              |
      | origin_region      | EU                                 |
      | destination_region | US                                 |
      | data_categories    | User profiles, Transaction data    |
      | transfer_purpose   | Cloud infrastructure hosting       |
      | data_importer      | US Cloud Provider Inc              |
    And I select transfer mechanism:
      | mechanism                    | version      |
      | Standard Contractual Clauses | Module 2 (C2P)|
    Then mechanism configuration should be validated:
      | validation_check        | result  |
      | SCC version current     | passed  |
      | Module appropriate      | passed  |
      | Annexes complete        | pending |
    And required documentation should be generated:
      | document                | status    |
      | SCC main clauses        | generated |
      | Annex I (parties)       | pending   |
      | Annex II (measures)     | pending   |
      | Annex III (sub-processors)| pending |
    And a DataTransferConfigured event should be published

  Scenario: Conduct Transfer Impact Assessment (TIA)
    When I conduct Transfer Impact Assessment for "EU to India" transfer:
      | field              | value                              |
      | transfer_id        | TIA-2024-005                       |
      | data_categories    | Customer support tickets           |
      | data_volume        | 500 GB monthly                     |
      | data_importer      | India Support Center Pvt Ltd       |
    Then TIA should assess legal framework:
      | assessment_area         | finding                            |
      | Government access laws  | IT Act allows lawful interception  |
      | Data protection law     | DPDP Act 2023 in effect            |
      | Independent oversight   | Data Protection Board established  |
    And risks should be identified:
      | risk                    | severity | likelihood |
      | Government access       | High     | Low        |
      | Inadequate legal remedy | Medium   | Medium     |
    And supplementary measures should be documented:
      | measure                 | description                        |
      | Encryption in transit   | TLS 1.3 for all transfers          |
      | Encryption at rest      | AES-256 with EU-held keys          |
      | Access controls         | EU approval for data access        |
      | Pseudonymization        | Personal identifiers tokenized     |
    And assessment should be scheduled for annual review

  # ============================================
  # REGULATORY CHANGE TRACKING
  # ============================================

  Scenario: Track new regulation enactment
    When a new regulation is enacted:
      | field              | value                              |
      | regulation_name    | EU AI Act                          |
      | jurisdiction       | EU                                 |
      | enactment_date     | 2024-08-01                         |
      | effective_date     | 2025-08-01                         |
      | compliance_deadline| 2026-08-01 (high-risk AI)          |
    Then I should receive notification:
      | notification_type  | recipients                         |
      | Email              | compliance-team@company.com        |
      | Dashboard alert    | All compliance users               |
      | Calendar entry     | Key deadlines added                |
    And requirements should be analyzed:
      | requirement_area        | applicability | assessment_status |
      | High-risk AI systems    | Potentially   | Analysis needed   |
      | Prohibited AI practices | Not applicable| Confirmed         |
      | Transparency obligations| Applicable    | Analysis needed   |
    And implementation timeline should be created:
      | milestone               | target_date  | owner            |
      | Applicability assessment| 2025-01-15   | Legal            |
      | Gap analysis            | 2025-03-01   | Compliance       |
      | Implementation plan     | 2025-06-01   | All teams        |
      | Compliance verification | 2026-06-01   | Internal Audit   |
    And a RegulatoryChangeTracked domain event should be published

  Scenario: Monitor regulatory updates dashboard
    When I view regulatory monitoring dashboard
    Then I should see pending regulatory changes:
      | regulation          | change_type    | effective_date | days_until | status        |
      | EU AI Act           | New regulation | 2025-08-01     | 215        | In assessment |
      | CCPA Amendments     | Amendment      | 2025-01-01     | 3          | Implementation|
      | UK GDPR updates     | Amendment      | 2025-04-01     | 93         | Analysis      |
    And I should see implementation progress:
      | regulation          | progress | on_track | blockers         |
      | CCPA Amendments     | 85%      | Yes      | None             |
      | UK GDPR updates     | 30%      | Yes      | None             |
      | EU AI Act           | 10%      | Yes      | Legal review     |
    And I should see assigned owners:
      | regulation          | owner              | backup             |
      | EU AI Act           | Chief Compliance   | Legal Counsel      |
      | CCPA Amendments     | Privacy Manager    | Compliance Analyst |

  Scenario: Assess regulatory impact on platform
    When I assess impact of "EU AI Act" on the platform:
      | analysis_area       | scope                              |
      | AI systems inventory| All AI/ML features                 |
      | Risk classification | Per AI Act categories              |
      | Gap analysis        | Current vs required controls       |
    Then affected systems should be identified:
      | system              | ai_type              | risk_level   | action_required |
      | Recommendation engine| Personalization     | Limited      | Transparency    |
      | Fraud detection     | Risk assessment      | High         | Full compliance |
      | Chatbot             | Conversational AI    | Limited      | Disclosure      |
    And compliance gaps should be documented:
      | gap                      | regulation_ref | priority | remediation_effort |
      | Risk management system   | Article 9      | High     | 6 months           |
      | Technical documentation  | Article 11     | High     | 3 months           |
      | Human oversight         | Article 14     | Medium   | 2 months           |
    And remediation plan should be created with timeline

  # ============================================
  # REGULATORY AUDITS
  # ============================================

  Scenario: Schedule and conduct internal regulatory audit
    When I schedule internal audit for GDPR compliance:
      | field              | value                              |
      | audit_id           | AUD-2025-GDPR-001                  |
      | scope              | Full GDPR compliance               |
      | audit_period       | 2025-01-15 to 2025-02-15           |
      | lead_auditor       | Internal Audit - Jane Doe          |
      | audit_team         | 3 auditors                         |
    Then audit scope should be defined:
      | area                    | included | testing_approach    |
      | Data processing register| Yes      | Documentation review|
      | Consent management      | Yes      | Sample testing      |
      | Data subject rights     | Yes      | Process walkthrough |
      | Security measures       | Yes      | Technical testing   |
      | Vendor management       | Yes      | Contract review     |
    And evidence requests should be generated:
      | evidence_type           | requested_from | due_date   |
      | Processing register     | DPO            | 2025-01-20 |
      | Consent records sample  | IT             | 2025-01-22 |
      | DSAR process docs       | Privacy Team   | 2025-01-25 |
    And audit timeline should be established:
      | phase                   | dates                | deliverable     |
      | Planning                | 2025-01-01 - 01-14   | Audit plan      |
      | Fieldwork               | 2025-01-15 - 02-05   | Working papers  |
      | Reporting               | 2025-02-06 - 02-15   | Audit report    |

  Scenario: Document and track audit finding
    When audit identifies finding:
      | field              | value                              |
      | finding_id         | FND-2025-001                       |
      | title              | Incomplete consent records         |
      | description        | 5% of consent records missing timestamp |
      | regulation         | GDPR                               |
      | requirement        | Article 7 - Conditions for consent |
      | severity           | Medium                             |
    Then finding should be documented with:
      | attribute          | value                              |
      | root_cause         | System migration data loss         |
      | impact             | Cannot demonstrate valid consent   |
      | affected_records   | 4,925 users                        |
      | risk_rating        | Medium                             |
    And remediation owner should be assigned:
      | field              | value                              |
      | owner              | Privacy Manager - Bob Smith        |
      | deadline           | 2025-03-15                         |
      | priority           | P2                                 |
    And an AuditFindingCreated domain event should be published

  Scenario: Track audit finding remediation
    When I view the remediation dashboard
    Then I should see open findings by regulation:
      | regulation | critical | high | medium | low | total |
      | GDPR       | 0        | 1    | 2      | 1   | 4     |
      | PCI DSS    | 0        | 0    | 1      | 0   | 1     |
      | SOX        | 0        | 1    | 1      | 0   | 2     |
    And I should see remediation progress:
      | finding_id    | title                       | progress | on_track | days_remaining |
      | FND-2025-001  | Incomplete consent records  | 45%      | Yes      | 45             |
      | FND-2024-089  | Access review gaps          | 80%      | Yes      | 10             |
      | FND-2024-076  | Encryption key management   | 100%     | Yes      | -5 (closed)    |
    And I should see overdue items highlighted:
      | finding_id    | title                 | days_overdue | escalated_to    |
      | FND-2024-045  | Legacy data cleanup   | 15           | Chief Compliance|

  Scenario: Prepare evidence package for external audit
    Given external auditor requests evidence for PCI DSS assessment
    When I prepare evidence package:
      | requirement | evidence_type                  | collection_method |
      | 1.1         | Firewall configuration         | Automated export  |
      | 3.4         | Encryption documentation       | Manual collection |
      | 10.1        | Audit log samples              | Automated export  |
    Then evidence should be collected:
      | evidence_id      | requirement | status    | collected_date |
      | EVD-PCI-001      | 1.1         | Collected | 2024-12-28     |
      | EVD-PCI-002      | 3.4         | Collected | 2024-12-28     |
      | EVD-PCI-003      | 10.1        | Collected | 2024-12-28     |
    And documents should be organized by requirement:
      | folder                | files | size    |
      | /Requirement_1        | 15    | 25 MB   |
      | /Requirement_3        | 22    | 45 MB   |
      | /Requirement_10       | 8     | 120 MB  |
    And secure access should be provided:
      | access_type    | expires     | permissions |
      | Secure portal  | 2025-02-28  | View only   |

  # ============================================
  # BREACH NOTIFICATIONS
  # ============================================

  Scenario: Initiate regulatory breach notification process
    Given a data breach has been detected:
      | field              | value                              |
      | incident_id        | INC-2024-0089                      |
      | detected_date      | 2024-12-29 08:30:00                |
      | data_affected      | User emails, hashed passwords      |
      | records_affected   | 15,000                             |
      | regions_affected   | EU, US                             |
    When I initiate breach notification process
    Then affected regulations should be identified:
      | regulation | applicable | reason                    |
      | GDPR       | Yes        | EU users affected         |
      | CCPA       | Yes        | CA users affected         |
      | State laws | Yes        | Multi-state US users      |
    And notification timelines should be calculated:
      | regulation | deadline              | hours_remaining |
      | GDPR       | 2024-12-30 08:30:00   | 24              |
      | CCPA       | Reasonable time       | Best effort     |
      | NY SHIELD  | Expedient             | Best effort     |
    And template notifications should be generated:
      | notification_type      | template_ready | customization_needed |
      | Supervisory authority  | Yes            | Incident details     |
      | Affected individuals   | Yes            | Personalization      |
      | Internal stakeholders  | Yes            | None                 |
    And a BreachNotificationInitiated domain event should be published

  Scenario: Track GDPR 72-hour notification deadline
    Given a GDPR-applicable breach requires supervisory authority notification
    When I view the breach dashboard
    Then I should see countdown timer:
      | field              | value                              |
      | deadline           | 2024-12-30 08:30:00                |
      | hours_remaining    | 18                                 |
      | status             | On track                           |
    And I should see notification preparation status:
      | task                        | status      | owner           |
      | Impact assessment           | Completed   | Security Team   |
      | Root cause analysis         | In progress | IT              |
      | Draft notification          | Completed   | Legal           |
      | DPO review                  | Pending     | DPO             |
      | Executive approval          | Pending     | CISO            |
    And I should see required notification contents:
      | element                     | status      |
      | Nature of breach            | Complete    |
      | Categories of data          | Complete    |
      | Approximate number affected | Complete    |
      | DPO contact details         | Complete    |
      | Likely consequences         | In progress |
      | Measures taken              | In progress |

  Scenario: Submit breach notification to supervisory authority
    Given breach notification is prepared and approved
    When I submit notification to supervisory authority:
      | field              | value                              |
      | authority          | Irish Data Protection Commission   |
      | submission_method  | Online portal                      |
      | submission_time    | 2024-12-30 06:15:00                |
    Then submission should be recorded:
      | field              | value                              |
      | confirmation_id    | DPC-2024-BREACH-1234               |
      | submitted_within   | 70 hours (within 72-hour limit)    |
      | status             | Submitted                          |
    And follow-up actions should be tracked:
      | action                 | deadline   | status   |
      | Authority response     | TBD        | Awaiting |
      | Individual notification| 2025-01-05 | Planned  |
      | Remediation completion | 2025-01-15 | Planned  |

  Scenario: Document complete breach response timeline
    When I document breach response for incident "INC-2024-0089"
    Then timeline should be recorded:
      | timestamp           | event                              | actor           |
      | 2024-12-29 08:30    | Breach detected                    | Security system |
      | 2024-12-29 08:45    | Incident response activated        | SOC Team        |
      | 2024-12-29 09:00    | Breach confirmed                   | Security Lead   |
      | 2024-12-29 10:00    | Containment measures implemented   | IT Team         |
      | 2024-12-29 14:00    | Impact assessment completed        | Privacy Team    |
      | 2024-12-30 06:15    | Authority notification submitted   | DPO             |
    And containment measures should be logged:
      | measure                 | implemented_at      | effectiveness |
      | Credential reset        | 2024-12-29 10:30    | Contained     |
      | Access revocation       | 2024-12-29 10:15    | Contained     |
      | System isolation        | 2024-12-29 10:00    | Contained     |
    And lessons learned should be captured for post-incident review

  # ============================================
  # DATA LOCALIZATION
  # ============================================

  Scenario: Configure data localization for Russia
    When I configure data localization for Russian users:
      | data_type         | storage_requirement | current_location | action_needed |
      | User PII          | Russia only         | EU               | Migration     |
      | Transactions      | Russia only         | EU               | Migration     |
      | Analytics         | Any                 | EU               | None          |
    Then data routing should be configured:
      | rule                    | applies_to     | action            |
      | Russian user signup     | New users      | Store in Russia   |
      | Russian user data access| All operations | Route to Russia   |
      | Data export             | Russian data   | Block cross-border|
    And compliance should be validated:
      | validation_check        | result    | details               |
      | Infrastructure exists   | Passed    | Russia DC available   |
      | Data routing configured | Passed    | Rules applied         |
      | Migration plan created  | Pending   | Requires scheduling   |
    And a DataLocalizationConfigured event should be published

  Scenario: Monitor data localization compliance
    When I view the data localization dashboard
    Then I should see data distribution by jurisdiction:
      | jurisdiction | data_volume | users_affected | compliance_status |
      | Russia       | 450 GB      | 12,500         | Compliant         |
      | China        | N/A         | 0              | Not applicable    |
      | EU           | 2.5 TB      | 125,000        | Compliant         |
    And I should see any violations:
      | violation_id | jurisdiction | violation_type        | detected_date | status      |
      | LOC-2024-001 | Russia       | Cross-border transfer | 2024-11-15    | Remediated  |
    And I should see remediation status for any open violations

  # ============================================
  # REGULATORY REPORTING
  # ============================================

  Scenario: Generate comprehensive compliance report for board
    When I generate compliance report for board with sections:
      | section                  | included | content_summary                    |
      | Executive Summary        | Yes      | Overall compliance posture         |
      | Compliance Status        | Yes      | By regulation and jurisdiction     |
      | Risk Assessment          | Yes      | Top compliance risks               |
      | Remediation Progress     | Yes      | Open findings and status           |
      | Incident Summary         | Yes      | Breaches and regulatory actions    |
      | Forward Look             | Yes      | Upcoming regulatory changes        |
    Then report should be generated with:
      | attribute          | value                              |
      | report_id          | RPT-BOARD-2024-Q4                  |
      | generated_date     | 2024-12-29                         |
      | period_covered     | Q4 2024                            |
      | pages              | 35                                 |
    And report should include metrics:
      | metric                    | value   | trend   |
      | Overall compliance score  | 94%     | +2%     |
      | Open critical findings    | 0       | stable  |
      | Regulatory deadlines met  | 100%    | stable  |
      | Training completion       | 92%     | +5%     |
    And report should be exportable as PDF and PowerPoint

  Scenario: Schedule automated regulatory reports
    When I schedule automated compliance report:
      | field              | value                              |
      | report_type        | Monthly compliance summary         |
      | schedule           | First Monday of month              |
      | recipients         | compliance-team@company.com, ciso@company.com |
      | format             | PDF                                |
      | include_attachments| Yes                                |
    Then report schedule should be saved
    And reports should generate automatically on schedule
    And distribution should occur via:
      | method             | recipients                         |
      | Email              | All listed recipients              |
      | Dashboard          | Available in report library        |
      | Archive            | Retained for 7 years               |

  # ============================================
  # THIRD-PARTY COMPLIANCE
  # ============================================

  Scenario: Assess third-party vendor regulatory compliance
    When I assess vendor "Payment Processor Inc":
      | assessment_field   | value                              |
      | vendor_id          | VND-001                            |
      | vendor_name        | Payment Processor Inc              |
      | service_provided   | Payment processing                 |
      | data_shared        | Payment card data                  |
      | applicable_regs    | PCI DSS, GDPR                      |
    Then I should review their compliance certifications:
      | certification      | status    | valid_until | verified |
      | PCI DSS Level 1    | Current   | 2025-09-30  | Yes      |
      | SOC 2 Type II      | Current   | 2025-06-30  | Yes      |
      | ISO 27001          | Current   | 2025-12-31  | Yes      |
    And I should verify PCI DSS attestation:
      | verification_check | result    | details                    |
      | AOC on file        | Yes       | Dated 2024-09-30           |
      | Service provider   | Yes       | Listed as SP               |
      | Scope coverage     | Yes       | Payment processing covered |
    And assessment results should be documented:
      | field              | value                              |
      | assessment_date    | 2024-12-29                         |
      | overall_rating     | Satisfactory                       |
      | next_review        | 2025-06-29                         |
      | findings           | None                               |

  Scenario: Monitor third-party compliance with alerts
    When I view the vendor compliance dashboard
    Then I should see certification expiry dates:
      | vendor                 | certification | expires     | days_until | status   |
      | Payment Processor Inc  | PCI DSS       | 2025-09-30  | 275        | Current  |
      | Cloud Provider LLC     | SOC 2         | 2025-02-28  | 61         | Expiring |
      | Email Service Co       | ISO 27001     | 2025-01-15  | 17         | Urgent   |
    And I should see assessment due dates:
      | vendor                 | last_assessment | next_due   | status    |
      | Payment Processor Inc  | 2024-06-29      | 2025-06-29 | Scheduled |
      | Data Analytics Ltd     | 2024-03-15      | 2025-03-15 | Due soon  |
    And alerts should be configured for:
      | alert_type             | threshold      | recipients              |
      | Certification expiry   | 60 days        | vendor-mgmt@company.com |
      | Assessment due         | 30 days        | compliance@company.com  |

  # ============================================
  # COMPLIANCE TRAINING
  # ============================================

  Scenario: Assign regulatory compliance training to teams
    When I assign GDPR training to team "Customer Support":
      | field              | value                              |
      | training_id        | TRN-GDPR-2025-001                  |
      | training_name      | GDPR Fundamentals for Support      |
      | duration           | 2 hours                            |
      | deadline           | 2025-01-31                         |
      | passing_score      | 80%                                |
    Then training should be assigned:
      | field              | value                              |
      | team_size          | 25 employees                       |
      | assigned_date      | 2024-12-29                         |
      | notifications_sent | Yes                                |
    And completion should be tracked:
      | status             | count | percentage |
      | Not started        | 20    | 80%        |
      | In progress        | 3     | 12%        |
      | Completed          | 2     | 8%         |
    And certificates should be issued upon completion

  Scenario: Track organization-wide training compliance
    When I view training compliance dashboard
    Then I should see completion rates by training:
      | training                 | assigned | completed | rate  | deadline   |
      | GDPR Fundamentals        | 250      | 230       | 92%   | 2024-12-31 |
      | PCI DSS Awareness        | 50       | 48        | 96%   | 2024-11-30 |
      | Security Awareness       | 500      | 485       | 97%   | 2024-12-15 |
    And I should see overdue training:
      | employee           | training            | days_overdue | escalated |
      | John Smith         | GDPR Fundamentals   | 5            | Yes       |
      | Jane Doe           | GDPR Fundamentals   | 3            | No        |
    And I should see training history for audit purposes

  # ============================================
  # COMPLIANCE AUTOMATION
  # ============================================

  Scenario: Configure automated compliance monitoring
    When I configure automated compliance monitoring:
      | monitoring_type    | scope                    | frequency   | alert_on      |
      | Policy violations  | All systems              | Real-time   | Any violation |
      | Access anomalies   | CDE systems              | Real-time   | High risk     |
      | Data classification| New data assets          | Daily       | Unclassified  |
      | Retention violations| All databases           | Weekly      | Exceeded      |
    Then monitoring should be activated
    And violations should be detected automatically:
      | violation_type     | detection_method         | response_time |
      | Unencrypted PII    | Data scanning            | < 1 hour      |
      | Unauthorized access| Access log analysis      | < 5 minutes   |
      | Policy breach      | Rule engine              | Real-time     |
    And alerts should be generated per configuration
    And remediation workflows should initiate automatically

  Scenario: Configure automated DSAR response system
    When I set up automated DSAR processing:
      | automation_step    | configuration                       |
      | Request intake     | Portal submission, email parser     |
      | Identity verification| Email confirmation + knowledge-based|
      | Data collection    | Automated query across systems      |
      | Response generation| Template population                 |
      | Review queue       | Exceptions only                     |
    Then DSAR automation should be configured
    And incoming requests should be:
      | step               | automation_level | human_review     |
      | Classification     | 95% automated    | Complex requests |
      | Verification       | 80% automated    | Failed attempts  |
      | Data gathering     | 100% automated   | System errors    |
      | Response draft     | 90% automated    | All responses    |
    And expected processing time should improve:
      | metric                    | before   | after    |
      | Avg processing time       | 18 days  | 8 days   |
      | Manual effort per DSAR    | 4 hours  | 1 hour   |

  # ============================================
  # CRISIS MANAGEMENT
  # ============================================

  Scenario: Handle major regulatory compliance crisis
    Given a major compliance violation is detected:
      | field              | value                                   |
      | violation_type     | Systemic data protection failure        |
      | scope              | 500,000 affected users                  |
      | severity           | Critical                                |
      | regulatory_exposure| GDPR, CCPA, multiple state laws         |
    When I initiate crisis response:
      | action             | triggered                              |
      | Crisis team alert  | Immediate                              |
      | War room setup     | Within 30 minutes                      |
      | Executive briefing | Within 1 hour                          |
    Then crisis team should be assembled:
      | role               | person              | contact_method |
      | Crisis Lead        | Chief Compliance    | Mobile         |
      | Legal Counsel      | General Counsel     | Mobile         |
      | Communications     | VP Communications   | Mobile         |
      | Technical Lead     | CISO                | Mobile         |
      | Business Rep       | COO                 | Mobile         |
    And communication plan should be activated:
      | audience           | timing              | channel         |
      | Regulators         | Within 72 hours     | Formal notice   |
      | Board              | Within 24 hours     | Emergency call  |
      | Affected users     | Within 7 days       | Email + website |
      | Media              | Reactive only       | Press statement |
    And regulatory notifications should be prepared
    And a ComplianceCrisisInitiated domain event should be published

  Scenario: Coordinate regulatory authority communication
    Given a regulator has requested information about an incident
    When I receive regulatory request:
      | field              | value                              |
      | authority          | Irish DPC                          |
      | request_type       | Information request                |
      | reference          | INQ-2024-5678                      |
      | deadline           | 2025-01-15                         |
    Then response should be coordinated:
      | step               | owner           | deadline   |
      | Legal review       | Legal Counsel   | 2025-01-05 |
      | Evidence gathering | Compliance      | 2025-01-08 |
      | Response drafting  | Privacy Team    | 2025-01-10 |
      | Executive approval | CEO             | 2025-01-12 |
      | Submission         | DPO             | 2025-01-14 |
    And all communications should be logged
    And timeline should be tracked for future reference

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  Scenario: Handle missed regulatory compliance deadline
    Given a compliance deadline was missed:
      | field              | value                              |
      | deadline_type      | GDPR DSAR response                 |
      | original_deadline  | 2024-12-28                         |
      | missed_by          | 1 day                              |
      | reason             | Resource constraints               |
    When the violation is detected
    Then incident should be logged:
      | field              | value                              |
      | incident_id        | CMP-2024-0156                      |
      | severity           | Medium                             |
      | regulation         | GDPR                               |
      | article            | Article 12(3)                      |
    And escalation should occur:
      | escalation_level   | notified                           |
      | Level 1            | Privacy Manager                    |
      | Level 2            | DPO                                |
      | Level 3            | Chief Compliance (if pattern)      |
    And remediation should be prioritized:
      | action             | deadline        | owner          |
      | Complete response  | Immediate       | Privacy Team   |
      | Root cause analysis| Within 7 days   | Compliance     |
      | Process improvement| Within 30 days  | Operations     |

  Scenario: Handle conflicting regulatory requirements
    Given regulations have conflicting requirements:
      | conflict           | regulation_1  | requirement_1      | regulation_2 | requirement_2        |
      | Data retention     | GDPR          | Delete after 2 yrs | Tax law      | Retain for 7 years   |
      | Data localization  | Russia        | Store locally      | GDPR         | EU adequacy required |
    When conflict is identified
    Then legal analysis should be requested:
      | analysis_type      | scope                              |
      | Conflict assessment| Both regulations                   |
      | Priority analysis  | Which takes precedence             |
      | Resolution options | Possible approaches                |
    And resolution should be documented:
      | conflict           | resolution                         | legal_basis          |
      | Data retention     | Anonymize after 2 yrs, retain anon | GDPR Art 17(3)(e)    |
      | Data localization  | Local storage + SCCs for EU        | Both satisfied       |
    And resolution should be approved by legal counsel

  Scenario: Handle regulatory enforcement action
    Given a regulator initiates enforcement action:
      | field              | value                              |
      | authority          | Irish DPC                          |
      | action_type        | Investigation                      |
      | reference          | INV-2024-9876                      |
      | subject            | Cross-border data transfers        |
    When enforcement notice is received
    Then immediate actions should be taken:
      | action             | owner           | timeline    |
      | Acknowledge receipt| DPO             | 24 hours    |
      | Legal engagement   | General Counsel | Immediate   |
      | Evidence preservation| IT            | Immediate   |
      | Internal investigation| Compliance   | 7 days      |
    And response strategy should be developed
    And board should be notified
    And external counsel should be engaged if necessary
