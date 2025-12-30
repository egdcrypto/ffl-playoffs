Feature: Admin Data Governance
  As a Platform Administrator
  I want to manage data governance policies and procedures
  So that I can ensure proper data stewardship and compliance

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have data governance permissions
    And the data governance system is enabled

  # ===========================================
  # Data Governance Dashboard
  # ===========================================

  Scenario: Admin views data governance overview
    When the admin navigates to the data governance dashboard
    Then the dashboard displays:
      | metric                    | description                          |
      | Governance Score          | Overall compliance percentage        |
      | Data Assets Cataloged     | Number of documented data assets     |
      | Quality Score             | Average data quality rating          |
      | Policy Violations         | Current policy violation count       |
      | Pending Reviews           | Items awaiting governance review     |
    And governance health indicators are shown

  Scenario: Admin views governance metrics by domain
    Given data is organized by business domain
    When the admin views domain metrics
    Then metrics are displayed by domain:
      | domain              | assets | quality | compliance | owner            |
      | Player Data         | 45     | 94%     | 98%        | data-team@ffl    |
      | League Data         | 32     | 92%     | 96%        | product@ffl      |
      | User Data           | 28     | 96%     | 100%       | privacy@ffl      |
      | Transaction Data    | 18     | 98%     | 100%       | finance@ffl      |
      | Analytics Data      | 56     | 88%     | 92%        | analytics@ffl    |

  Scenario: Admin views governance timeline
    Given governance activities have been logged
    When the admin views the activity timeline
    Then recent activities are displayed:
      | timestamp           | activity                    | actor            | domain      |
      | 2024-01-15 14:30:00 | Policy updated              | admin@example.com| User Data   |
      | 2024-01-15 10:15:00 | Data classified             | steward@ffl      | Player Data |
      | 2024-01-14 16:45:00 | Access review completed     | privacy@ffl      | All         |
    And activities can be filtered by type and domain

  # ===========================================
  # Data Classification
  # ===========================================

  Scenario: Admin views data classification schema
    When the admin views classification settings
    Then the classification schema is displayed:
      | level               | label           | description                    | handling           |
      | 1                   | Public          | Publicly available data        | No restrictions    |
      | 2                   | Internal        | Internal business data         | Employee access    |
      | 3                   | Confidential    | Sensitive business data        | Need-to-know       |
      | 4                   | Restricted      | Highly sensitive/regulated     | Strict controls    |
      | 5                   | PII             | Personal identifiable info     | Privacy controls   |

  Scenario: Admin classifies data asset
    Given an unclassified data asset exists
    When the admin classifies the asset:
      | field               | value                    |
      | asset_name          | player_statistics        |
      | classification      | Internal                 |
      | contains_pii        | No                       |
      | business_owner      | analytics@ffl            |
      | data_steward        | data-team@ffl            |
      | retention_period    | 7 years                  |
    Then the classification is saved
    And appropriate controls are applied

  Scenario: Admin bulk classifies data assets
    Given multiple unclassified assets exist
    When the admin performs bulk classification:
      | assets              | classification | reason               |
      | game_scores_*       | Public         | Published statistics |
      | user_preferences_*  | Confidential   | User settings        |
      | payment_*           | Restricted     | Financial data       |
    Then all assets are classified
    And audit trail is created

  Scenario: Admin reviews classification recommendations
    Given the system has analyzed data patterns
    When the admin views classification suggestions
    Then recommendations are displayed:
      | asset               | current     | suggested   | confidence | reason              |
      | email_logs          | Unclassified| Confidential| 95%        | Contains emails     |
      | api_access_logs     | Internal    | Restricted  | 88%        | Contains IP/keys    |
      | player_names        | Confidential| Public      | 92%        | Publicly available  |
    And the admin can accept or reject each

  Scenario: Admin configures auto-classification rules
    When the admin creates auto-classification rules:
      | pattern             | classification | trigger              |
      | *_email*            | PII            | Contains email field |
      | *_ssn*              | Restricted     | Contains SSN pattern |
      | *_public*           | Public         | Naming convention    |
      | payment_*           | Restricted     | Payment data         |
    Then rules are saved
    And new assets are auto-classified

  # ===========================================
  # Data Quality Monitoring
  # ===========================================

  Scenario: Admin views data quality dashboard
    When the admin views data quality metrics
    Then quality scores are displayed:
      | dimension           | score | trend   | issues |
      | Completeness        | 94.5% | +1.2%   | 23     |
      | Accuracy            | 97.8% | -0.3%   | 12     |
      | Consistency         | 92.3% | +0.5%   | 45     |
      | Timeliness          | 98.1% | +0.8%   | 8      |
      | Uniqueness          | 99.2% | 0%      | 5      |
      | Validity            | 96.7% | +0.2%   | 18     |

  Scenario: Admin configures quality rules
    When the admin creates quality rules:
      | rule_name           | dataset         | condition                    | severity |
      | Email Format        | users           | email matches RFC5322        | Error    |
      | Score Range         | player_scores   | score between 0 and 100      | Error    |
      | Null Check          | leagues         | name is not null             | Error    |
      | Freshness           | live_scores     | updated < 5 minutes ago      | Warning  |
    Then quality rules are saved
    And monitoring begins

  Scenario: Admin views quality issues
    When the admin views quality issues
    Then issues are displayed:
      | issue               | dataset         | affected_rows | severity | status    |
      | Invalid emails      | users           | 234           | Error    | Open      |
      | Duplicate records   | player_stats    | 56            | Warning  | In Review |
      | Missing values      | league_settings | 12            | Error    | Open      |
    And the admin can assign issues for resolution

  Scenario: Admin tracks quality trends
    Given quality data is collected over time
    When the admin views quality trends
    Then trends are displayed:
      | period     | completeness | accuracy | overall |
      | This Week  | 94.5%        | 97.8%    | 95.2%   |
      | Last Week  | 93.3%        | 98.1%    | 94.8%   |
      | Last Month | 92.1%        | 97.5%    | 93.9%   |
    And improvement areas are highlighted

  # ===========================================
  # Data Steward Management
  # ===========================================

  Scenario: Admin views data stewards
    When the admin navigates to steward management
    Then stewards are displayed:
      | steward             | domain          | assets | responsibilities         |
      | data-team@ffl       | Player Data     | 45     | Quality, Classification  |
      | product@ffl         | League Data     | 32     | Quality, Access          |
      | privacy@ffl         | User Data       | 28     | Privacy, Retention       |
      | analytics@ffl       | Analytics Data  | 56     | Quality, Lineage         |

  Scenario: Admin assigns data steward
    When the admin assigns a steward:
      | field               | value                    |
      | steward             | newsteward@ffl           |
      | domain              | Transaction Data         |
      | responsibilities    | Quality, Access, Privacy |
      | effective_date      | 2024-02-01               |
    Then the steward is assigned
    And receives access and notifications

  Scenario: Admin defines steward responsibilities
    When the admin configures steward duties:
      | responsibility      | description                        | frequency |
      | Quality Review      | Review data quality metrics        | Weekly    |
      | Access Audit        | Audit data access patterns         | Monthly   |
      | Classification      | Maintain data classifications      | Ongoing   |
      | Issue Resolution    | Resolve data quality issues        | As needed |
      | Policy Compliance   | Ensure policy adherence            | Quarterly |
    Then responsibilities are documented
    And reminders are scheduled

  Scenario: Admin reviews steward performance
    When the admin views steward metrics
    Then performance is displayed:
      | steward             | issues_resolved | avg_resolution | compliance | rating |
      | data-team@ffl       | 45              | 2.3 days       | 98%        | 4.8/5  |
      | product@ffl         | 32              | 3.1 days       | 96%        | 4.5/5  |
      | privacy@ffl         | 28              | 1.8 days       | 100%       | 5.0/5  |

  # ===========================================
  # Data Lineage Tracking
  # ===========================================

  Scenario: Admin views data lineage
    When the admin views lineage for "player_fantasy_scores"
    Then the lineage graph shows:
      | source              | transformation      | destination           |
      | nfl_api.stats       | ETL Pipeline        | raw_player_stats      |
      | raw_player_stats    | Scoring Engine      | calculated_scores     |
      | calculated_scores   | Aggregation         | player_fantasy_scores |
      | player_fantasy_scores| Report Generator   | weekly_reports        |
    And dependencies are visualized

  Scenario: Admin tracks data transformations
    When the admin views transformation details
    Then transformations are documented:
      | transformation      | input               | output              | logic                |
      | Scoring Engine      | raw_player_stats    | calculated_scores   | Apply scoring rules  |
      | Aggregation         | calculated_scores   | weekly_totals       | Sum by player/week   |
      | Anonymization       | user_data           | anon_user_data      | Remove PII           |

  Scenario: Admin performs impact analysis
    Given the admin wants to change "scoring_rules" table
    When the admin runs impact analysis
    Then affected assets are displayed:
      | asset                   | impact_type | severity | downstream_count |
      | calculated_scores       | Direct      | High     | 5                |
      | player_fantasy_scores   | Indirect    | High     | 3                |
      | weekly_reports          | Indirect    | Medium   | 0                |
      | leaderboards            | Indirect    | Medium   | 0                |
    And notification list is generated

  Scenario: Admin configures lineage tracking
    When the admin enables lineage capture:
      | setting             | value                    |
      | capture_mode        | Automatic                |
      | granularity         | Column-level             |
      | include_transforms  | Yes                      |
      | track_queries       | Yes                      |
      | retention_period    | 2 years                  |
    Then lineage tracking is configured
    And metadata collection begins

  # ===========================================
  # Data Access Controls
  # ===========================================

  Scenario: Admin views access control policies
    When the admin views access policies
    Then policies are displayed:
      | policy              | applies_to      | permissions          | conditions           |
      | Player Data Read    | analysts        | SELECT               | Business hours       |
      | User Data Admin     | data-team       | ALL                  | Approval required    |
      | Financial Read      | finance-team    | SELECT               | Audit logged         |
      | PII Access          | privacy-team    | SELECT, UPDATE       | Purpose required     |

  Scenario: Admin creates access policy
    When the admin creates an access policy:
      | field               | value                    |
      | name                | Sensitive Analytics      |
      | dataset             | user_behavior            |
      | roles               | senior-analysts          |
      | permissions         | SELECT                   |
      | conditions          | Purpose documented       |
      | approval_required   | Yes                      |
      | audit_level         | Full                     |
    Then the policy is created
    And access controls are enforced

  Scenario: Admin reviews access requests
    When the admin views pending access requests
    Then requests are displayed:
      | requester           | dataset         | purpose              | status    |
      | analyst@ffl         | user_segments   | Marketing analysis   | Pending   |
      | dev@ffl             | player_pii      | Bug investigation    | Pending   |
      | partner@external    | game_scores     | Integration          | In Review |
    And the admin can approve or deny

  Scenario: Admin audits data access
    When the admin views access audit log
    Then access events are displayed:
      | timestamp           | user            | dataset         | action  | rows     |
      | 2024-01-15 14:30:00 | analyst@ffl     | player_stats    | SELECT  | 10,000   |
      | 2024-01-15 14:25:00 | dev@ffl         | user_settings   | UPDATE  | 1        |
      | 2024-01-15 14:20:00 | system          | game_scores     | INSERT  | 500      |
    And unusual patterns are flagged

  Scenario: Admin configures row-level security
    When the admin sets up row-level security:
      | dataset             | condition                    | applies_to       |
      | league_data         | league_id IN user_leagues    | league-members   |
      | player_contracts    | team_id = user_team          | team-managers    |
      | user_data           | user_id = current_user       | all-users        |
    Then row-level security is enforced
    And users see only permitted data

  # ===========================================
  # Data Retention Policies
  # ===========================================

  Scenario: Admin views retention policies
    When the admin views retention configuration
    Then policies are displayed:
      | data_category       | retention_period | legal_basis          | auto_delete |
      | User Account Data   | 3 years          | Contractual          | Yes         |
      | Game History        | 7 years          | Legitimate Interest  | Yes         |
      | Transaction Records | 10 years         | Legal Obligation     | No          |
      | Audit Logs          | 5 years          | Compliance           | Yes         |
      | Analytics Data      | 2 years          | Legitimate Interest  | Yes         |

  Scenario: Admin creates retention policy
    When the admin creates a retention policy:
      | field               | value                    |
      | data_category       | AI Training Data         |
      | retention_period    | 3 years                  |
      | legal_basis         | Legitimate Interest      |
      | auto_delete         | Yes                      |
      | archive_first       | Yes                      |
      | notification_days   | 30                       |
    Then the policy is created
    And enforcement is scheduled

  Scenario: Admin views retention compliance
    When the admin views compliance status
    Then compliance is displayed:
      | data_category       | total_records | compliant | expired | action_needed |
      | User Account Data   | 125,000       | 124,500   | 500     | Delete 500    |
      | Game History        | 2,450,000     | 2,450,000 | 0       | None          |
      | Audit Logs          | 890,000       | 880,000   | 10,000  | Archive 10k   |

  Scenario: Admin configures legal holds
    When the admin creates a legal hold:
      | field               | value                    |
      | name                | Litigation Hold 2024-001 |
      | scope               | User data for case #1234 |
      | data_categories     | User, Transaction        |
      | start_date          | 2024-01-15               |
      | end_date            | TBD                      |
      | reason              | Pending litigation       |
    Then the legal hold is applied
    And affected data is preserved

  # ===========================================
  # Privacy Impact Assessments
  # ===========================================

  Scenario: Admin initiates privacy impact assessment
    When the admin creates a PIA:
      | field               | value                    |
      | project             | New AI Prediction Feature|
      | data_involved       | Player stats, User prefs |
      | processing_purpose  | Personalized predictions |
      | assessor            | privacy@ffl              |
      | due_date            | 2024-02-15               |
    Then the PIA is created
    And assessment workflow begins

  Scenario: Admin completes PIA questionnaire
    When the admin completes the assessment:
      | question                        | answer                      |
      | What data is collected?         | Player stats, preferences   |
      | Is consent obtained?            | Yes, explicit consent       |
      | How long is data retained?      | Duration of feature use     |
      | Is data shared with third parties?| No                        |
      | What security measures exist?   | Encryption, access controls |
    Then responses are recorded
    And risk score is calculated

  Scenario: Admin views PIA risk assessment
    When the admin views PIA results
    Then risks are displayed:
      | risk_area           | level   | mitigation                   |
      | Data Minimization   | Low     | Only necessary data used     |
      | Consent             | Low     | Explicit consent obtained    |
      | Data Security       | Medium  | Enhance encryption           |
      | Third-Party Sharing | Low     | No sharing planned           |
      | Retention           | Low     | Clear retention policy       |
    And overall risk rating is shown

  Scenario: Admin tracks PIA completion
    When the admin views PIA dashboard
    Then assessments are displayed:
      | project             | status      | risk_level | due_date   |
      | AI Predictions      | In Progress | Medium     | 2024-02-15 |
      | Mobile App Update   | Complete    | Low        | 2024-01-10 |
      | Partner Integration | Pending     | TBD        | 2024-03-01 |

  # ===========================================
  # Breach Prevention
  # ===========================================

  Scenario: Admin views breach prevention dashboard
    When the admin views breach prevention
    Then metrics are displayed:
      | metric                    | value    | status  |
      | Security Score            | 94%      | Good    |
      | Vulnerable Assets         | 3        | Warning |
      | Failed Access Attempts    | 234      | Normal  |
      | Encryption Coverage       | 98%      | Good    |
      | Access Anomalies          | 2        | Warning |

  Scenario: Admin configures breach detection rules
    When the admin sets detection rules:
      | rule                    | threshold            | action           |
      | Bulk Data Export        | > 10,000 rows        | Alert + Block    |
      | Off-Hours Access        | After 10PM           | Alert            |
      | Geographic Anomaly      | New country          | Alert + MFA      |
      | Failed Logins           | > 5 in 10 minutes    | Block + Alert    |
    Then detection rules are active
    And monitoring begins

  Scenario: Admin responds to security alert
    Given a security alert is triggered
    When the admin reviews the alert:
      | field               | value                    |
      | alert_type          | Bulk Data Export         |
      | user                | analyst@ffl              |
      | dataset             | user_emails              |
      | rows_accessed       | 50,000                   |
      | timestamp           | 2024-01-15 02:30:00      |
    Then the admin can investigate
    And take remediation actions

  Scenario: Admin conducts breach simulation
    When the admin runs breach simulation:
      | scenario            | target              | expected_detection |
      | SQL Injection       | Player database     | < 1 second         |
      | Data Exfiltration   | User data           | < 5 minutes        |
      | Privilege Escalation| Admin access        | < 30 seconds       |
    Then simulation results are recorded
    And gaps are identified

  # ===========================================
  # Consent Management
  # ===========================================

  Scenario: Admin views consent dashboard
    When the admin views consent management
    Then consent metrics are displayed:
      | purpose                 | consented | declined | pending |
      | Essential Processing    | 125,000   | 0        | 0       |
      | Analytics               | 98,500    | 21,000   | 5,500   |
      | Marketing               | 67,890    | 52,000   | 5,110   |
      | AI Features             | 89,450    | 30,000   | 5,550   |

  Scenario: Admin configures consent purposes
    When the admin creates consent purpose:
      | field               | value                    |
      | name                | Personalized Predictions |
      | description         | AI-powered game insights |
      | legal_basis         | Consent                  |
      | required            | No                       |
      | default_state       | Unchecked                |
    Then the consent purpose is created
    And appears in consent UI

  Scenario: Admin tracks consent changes
    When the admin views consent history
    Then changes are displayed:
      | timestamp           | user            | purpose         | action    |
      | 2024-01-15 14:30:00 | user@example.com| Marketing       | Withdrawn |
      | 2024-01-15 14:25:00 | user2@example.com| AI Features    | Granted   |
      | 2024-01-15 14:20:00 | user3@example.com| Analytics      | Granted   |

  Scenario: Admin handles consent withdrawal
    Given a user withdraws consent
    When the admin reviews the withdrawal
    Then affected processing is displayed:
      | processing              | status              | action_required     |
      | Email marketing         | Stopped             | None                |
      | Personalized content    | Stopped             | Clear preferences   |
      | Third-party sharing     | Stopped             | Notify partners     |
    And data deletion is scheduled if requested

  # ===========================================
  # Data Discovery and Cataloging
  # ===========================================

  Scenario: Admin runs data discovery
    When the admin initiates data discovery:
      | scope               | value                    |
      | databases           | All production           |
      | file_systems        | S3 buckets               |
      | scan_depth          | Full                     |
      | pii_detection       | Enabled                  |
    Then discovery scan begins
    And progress is tracked

  Scenario: Admin views discovery results
    When the admin views discovery results
    Then findings are displayed:
      | location            | assets_found | pii_detected | unclassified |
      | PostgreSQL          | 145          | 23           | 12           |
      | MongoDB             | 89           | 8            | 5            |
      | S3 Data Lake        | 234          | 45           | 34           |
      | Redis Cache         | 12           | 2            | 0            |

  Scenario: Admin catalogs data asset
    When the admin catalogs an asset:
      | field               | value                    |
      | name                | player_performance_metrics|
      | description         | Weekly player statistics |
      | location            | PostgreSQL.analytics     |
      | owner               | analytics-team           |
      | classification      | Internal                 |
      | tags                | player, stats, weekly    |
    Then the asset is cataloged
    And searchable in the catalog

  Scenario: Admin searches data catalog
    When the admin searches for "player statistics"
    Then matching assets are displayed:
      | asset                   | location        | classification | relevance |
      | player_statistics       | PostgreSQL      | Internal       | 95%       |
      | player_weekly_stats     | Data Lake       | Internal       | 88%       |
      | historical_player_data  | Archive         | Internal       | 75%       |

  # ===========================================
  # Governance Compliance Monitoring
  # ===========================================

  Scenario: Admin views compliance dashboard
    When the admin views compliance monitoring
    Then compliance status is displayed:
      | regulation          | status    | score | issues | last_audit   |
      | GDPR                | Compliant | 96%   | 2      | 2024-01-10   |
      | CCPA                | Compliant | 94%   | 3      | 2024-01-08   |
      | SOC 2               | Compliant | 98%   | 1      | 2024-01-05   |
      | PCI-DSS             | Compliant | 100%  | 0      | 2024-01-12   |

  Scenario: Admin runs compliance assessment
    When the admin runs GDPR assessment:
      | requirement             | status    | evidence                     |
      | Lawful Basis            | Compliant | Documented for all processing|
      | Data Subject Rights     | Compliant | Rights portal implemented    |
      | Data Protection Officer | Compliant | DPO appointed                |
      | Breach Notification     | Compliant | 72-hour process in place     |
      | International Transfers | Partial   | SCCs needed for 2 vendors    |
    Then assessment is recorded
    And gaps are tracked

  Scenario: Admin configures compliance alerts
    When the admin sets compliance monitoring:
      | trigger                 | threshold | action               |
      | Compliance Score Drop   | < 90%     | Alert leadership     |
      | New Violation           | Any       | Alert steward        |
      | Audit Due               | 30 days   | Schedule reminder    |
      | Policy Expiring         | 60 days   | Alert governance     |
    Then alerts are configured
    And monitoring is active

  # ===========================================
  # Data Sharing Agreements
  # ===========================================

  Scenario: Admin views data sharing agreements
    When the admin views sharing agreements
    Then agreements are displayed:
      | partner             | data_shared         | purpose           | expiry       |
      | ESPN                | Game scores         | Integration       | 2025-06-15   |
      | Analytics Co        | Anonymized usage    | Analytics         | 2024-12-31   |
      | Research Inst       | Aggregated stats    | Research          | 2025-03-01   |

  Scenario: Admin creates sharing agreement
    When the admin creates agreement:
      | field               | value                    |
      | partner             | New Partner Inc          |
      | data_categories     | Player statistics        |
      | purpose             | Mobile app integration   |
      | legal_basis         | Contract                 |
      | security_requirements| Encryption, Audit       |
      | start_date          | 2024-02-01               |
      | end_date            | 2025-02-01               |
    Then the agreement is created
    And access is provisioned

  Scenario: Admin monitors data sharing
    When the admin views sharing activity
    Then activity is displayed:
      | partner             | data_transferred | last_access      | anomalies |
      | ESPN                | 45.2 GB          | 5 minutes ago    | None      |
      | Analytics Co        | 12.8 GB          | 1 hour ago       | None      |
      | Research Inst       | 2.3 GB           | 3 days ago       | Low usage |

  # ===========================================
  # Data Anonymization
  # ===========================================

  Scenario: Admin configures anonymization rules
    When the admin creates anonymization rules:
      | field               | method              | parameters           |
      | email               | Hash                | SHA-256              |
      | name                | Pseudonymize        | Consistent mapping   |
      | ip_address          | Generalize          | /24 subnet           |
      | date_of_birth       | Generalize          | Year only            |
      | location            | Generalize          | Region level         |
    Then anonymization rules are saved
    And applied to exports

  Scenario: Admin runs anonymization job
    When the admin runs anonymization:
      | setting             | value                    |
      | source_dataset      | user_analytics           |
      | destination         | anon_user_analytics      |
      | k_anonymity         | 5                        |
      | verify_quality      | Yes                      |
    Then anonymization completes
    And quality is verified

  Scenario: Admin validates anonymization
    When the admin runs anonymization validation
    Then validation results show:
      | check               | result   | details                    |
      | K-Anonymity (k=5)   | Passed   | All groups have >= 5       |
      | L-Diversity         | Passed   | Sensitive values diverse   |
      | Re-identification   | Low Risk | < 0.1% probability         |
      | Utility Preserved   | 92%      | Analytical value retained  |

  # ===========================================
  # Governance Reports
  # ===========================================

  Scenario: Admin generates governance report
    When the admin generates monthly report:
      | section             | included |
      | Executive Summary   | Yes      |
      | Compliance Status   | Yes      |
      | Quality Metrics     | Yes      |
      | Access Audit        | Yes      |
      | Incidents           | Yes      |
      | Recommendations     | Yes      |
    Then the report is generated
    And available for distribution

  Scenario: Admin schedules recurring reports
    When the admin schedules governance reports:
      | report              | frequency | recipients           |
      | Executive Summary   | Weekly    | leadership@ffl       |
      | Compliance Detailed | Monthly   | governance@ffl       |
      | Quality Metrics     | Daily     | stewards@ffl         |
      | Audit Log           | Weekly    | security@ffl         |
    Then reports are scheduled
    And delivered automatically

  Scenario: Admin exports audit evidence
    When the admin exports for audit:
      | evidence_type       | date_range           | format |
      | Access Logs         | Last 90 days         | CSV    |
      | Policy Changes      | Last 12 months       | PDF    |
      | Consent Records     | Last 12 months       | CSV    |
      | Incident Reports    | Last 12 months       | PDF    |
    Then audit package is generated
    And securely delivered

  # ===========================================
  # Governance Training
  # ===========================================

  Scenario: Admin views training dashboard
    When the admin views training status
    Then training metrics are displayed:
      | course                  | enrolled | completed | compliance |
      | Data Privacy Basics     | 245      | 230       | 94%        |
      | GDPR Fundamentals       | 180      | 165       | 92%        |
      | Data Classification     | 120      | 115       | 96%        |
      | Security Awareness      | 245      | 240       | 98%        |

  Scenario: Admin assigns governance training
    When the admin assigns training:
      | setting             | value                    |
      | course              | Data Handling 2024       |
      | assignees           | All data stewards        |
      | due_date            | 2024-02-28               |
      | mandatory           | Yes                      |
    Then training is assigned
    And reminders are scheduled

  Scenario: Admin tracks training completion
    When the admin views completion report
    Then status is displayed:
      | user                | course              | status    | score | due_date   |
      | steward1@ffl        | Data Handling 2024  | Completed | 92%   | 2024-02-28 |
      | steward2@ffl        | Data Handling 2024  | In Progress| -    | 2024-02-28 |
      | analyst@ffl         | Data Handling 2024  | Not Started| -   | 2024-02-28 |

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot classify without required fields
    When the admin attempts to classify without owner
    Then the request is rejected with error "OWNER_REQUIRED"
    And required fields are highlighted

  Scenario: Admin cannot delete data under legal hold
    Given data is under legal hold
    When the admin attempts to delete
    Then the request is blocked with error "LEGAL_HOLD_ACTIVE"
    And the hold details are displayed

  Scenario: Admin cannot share restricted data externally
    Given data is classified as Restricted
    When the admin attempts to create external sharing agreement
    Then the request is rejected with error "RESTRICTED_DATA_NO_EXTERNAL_SHARING"
    And approval escalation is required

  Scenario: Anonymization validation fails
    When anonymization produces insufficient k-anonymity
    Then the job fails with error "K_ANONYMITY_NOT_MET"
    And remediation suggestions are provided

  Scenario: Access policy conflicts detected
    When the admin creates conflicting access policies
    Then a warning is displayed:
      """
      Policy Conflict Detected:
      - "Analyst Read" grants SELECT on user_data
      - "PII Restricted" denies SELECT on user_data for analysts

      Resolution options:
      1. Add exception to PII Restricted
      2. Remove analyst role from new policy
      3. Create more specific scoping
      """
