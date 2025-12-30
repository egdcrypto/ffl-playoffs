Feature: Admin Vendor Onboarding
  As a Platform Administrator
  I want to manage vendor onboarding and approval processes
  So that I can maintain marketplace quality and vendor standards

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have vendor onboarding permissions
    And the vendor management system is enabled

  # ===========================================
  # Vendor Application Overview
  # ===========================================

  Scenario: Admin views vendor application dashboard
    When the admin navigates to vendor onboarding
    Then the dashboard displays:
      | metric                    | description                          |
      | Pending Applications      | Applications awaiting review         |
      | In Review                 | Applications being processed         |
      | Approved This Month       | Recently approved vendors            |
      | Rejected This Month       | Applications declined                |
      | Average Processing Time   | Days from submission to decision     |
    And application queue is displayed

  Scenario: Admin views application queue
    When the admin views pending applications
    Then applications are displayed:
      | applicant           | business_name        | submitted    | category        | status    |
      | vendor1@example.com | Fantasy Stats Pro    | 2024-01-14   | Data Provider   | Pending   |
      | vendor2@example.com | Sports Merch Inc     | 2024-01-13   | Merchandise     | In Review |
      | vendor3@example.com | Analytics Hub        | 2024-01-12   | Analytics       | Pending   |
    And applications are sorted by submission date

  Scenario: Admin filters applications
    When the admin applies filters:
      | filter              | value                |
      | status              | Pending              |
      | category            | Data Provider        |
      | submitted_after     | 2024-01-01           |
    Then only matching applications are displayed
    And filter results show count

  Scenario: Admin searches applications
    When the admin searches for "Fantasy Stats"
    Then matching applications are displayed
    And search highlights matched terms
    And results include business name, contact, and category

  # ===========================================
  # Application Review
  # ===========================================

  Scenario: Admin reviews vendor application
    Given a pending application exists
    When the admin opens the application for review
    Then application details are displayed:
      | section             | information                          |
      | Business Info       | Name, address, website, phone        |
      | Contact Person      | Name, email, role                    |
      | Business Type       | Corporation, LLC, Sole Proprietor    |
      | Category            | Requested vendor category            |
      | Description         | Business description and offerings   |
      | References          | Business references provided         |

  Scenario: Admin views applicant business details
    Given an application is under review
    When the admin views business information
    Then details are displayed:
      | field               | value                          |
      | Legal Name          | Fantasy Stats Pro LLC          |
      | DBA                 | Fantasy Stats Pro              |
      | EIN/Tax ID          | **-***1234 (masked)            |
      | Business Address    | 123 Sports Ave, Dallas, TX     |
      | Years in Business   | 5                              |
      | Annual Revenue      | $500K - $1M                    |
      | Employee Count      | 10-25                          |

  Scenario: Admin views applicant product offerings
    Given an application is under review
    When the admin views proposed products
    Then offerings are displayed:
      | product             | category        | price_range   | description            |
      | Premium Stats API   | Data Service    | $99-499/mo    | Real-time player stats |
      | Fantasy Insights    | Analytics       | $9.99/mo      | AI-powered predictions |
      | Custom Reports      | Reports         | $29.99 each   | Personalized analysis  |

  Scenario: Admin requests additional information
    Given an application needs more details
    When the admin requests information:
      | field               | value                          |
      | request_type        | Documentation                  |
      | specific_items      | Business license, Insurance    |
      | reason              | Verify business legitimacy     |
      | deadline            | 7 days                         |
    Then the request is sent to the applicant
    And application status changes to "Awaiting Info"
    And deadline is tracked

  Scenario: Admin adds review notes
    Given an application is under review
    When the admin adds notes:
      | note                                              |
      | Verified business website is active               |
      | Product offerings align with marketplace goals    |
      | Recommend proceeding to credential verification   |
    Then notes are saved
    And visible to other reviewers
    And timestamped with reviewer info

  Scenario: Admin assigns application to reviewer
    Given a pending application exists
    When the admin assigns to a reviewer:
      | field               | value                    |
      | reviewer            | reviewer@ffl.com         |
      | priority            | High                     |
      | due_date            | 2024-01-20               |
      | notes               | Expedited review needed  |
    Then the assignment is saved
    And reviewer is notified
    And SLA tracking begins

  # ===========================================
  # Credential Verification
  # ===========================================

  Scenario: Admin initiates credential verification
    Given an application passed initial review
    When the admin starts verification
    Then verification checklist is displayed:
      | check               | status    | required |
      | Business License    | Pending   | Yes      |
      | Tax Registration    | Pending   | Yes      |
      | Insurance Cert      | Pending   | Yes      |
      | Bank Account        | Pending   | Yes      |
      | Identity Check      | Pending   | Yes      |
      | Background Check    | Pending   | Optional |

  Scenario: Admin verifies business license
    When the admin verifies business license:
      | field               | value                          |
      | license_number      | BL-2024-12345                  |
      | issuing_authority   | State of Texas                 |
      | issue_date          | 2023-06-15                     |
      | expiry_date         | 2025-06-15                     |
      | verification_method | State database lookup          |
    Then the license is marked as verified
    And verification evidence is stored

  Scenario: Admin verifies tax registration
    When the admin verifies tax ID:
      | field               | value                    |
      | ein                 | 12-3456789               |
      | verification_source | IRS TIN Matching         |
      | business_name_match | Yes                      |
      | address_match       | Yes                      |
    Then tax registration is verified
    And compliance status is updated

  Scenario: Admin verifies insurance coverage
    When the admin reviews insurance:
      | field               | value                          |
      | policy_number       | POL-2024-56789                 |
      | provider            | Business Insurance Co          |
      | coverage_type       | General Liability              |
      | coverage_amount     | $2,000,000                     |
      | expiry_date         | 2025-01-15                     |
    Then insurance is verified
    And expiry monitoring is set up

  Scenario: Admin runs background check
    Given background check consent is provided
    When the admin initiates background check:
      | field               | value                    |
      | check_type          | Business + Principal     |
      | provider            | BackgroundCheck.io       |
      | subjects            | Company, CEO, CFO        |
    Then the check is submitted
    And results are expected within 3-5 days

  Scenario: Admin reviews background check results
    Given a background check has completed
    When the admin reviews results
    Then findings are displayed:
      | subject             | result    | flags                    |
      | Fantasy Stats Pro   | Clear     | No issues found          |
      | John Smith (CEO)    | Clear     | No issues found          |
      | Jane Doe (CFO)      | Flag      | Minor civil matter 2019  |
    And the admin can proceed or escalate

  Scenario: Admin verifies bank account
    When the admin verifies banking:
      | field               | value                    |
      | bank_name           | First National Bank      |
      | account_type        | Business Checking        |
      | verification_method | Micro-deposit            |
      | status              | Verified                 |
    Then banking is confirmed
    And payout setup can proceed

  # ===========================================
  # Onboarding Workflow
  # ===========================================

  Scenario: Admin views onboarding workflow
    Given an application is approved
    When the admin views the onboarding workflow
    Then workflow stages are displayed:
      | stage               | status      | due_date   | assigned_to      |
      | Agreement Signing   | In Progress | 2024-01-18 | legal@ffl        |
      | Account Setup       | Pending     | 2024-01-20 | onboarding@ffl   |
      | Payment Config      | Pending     | 2024-01-22 | finance@ffl      |
      | Training            | Pending     | 2024-01-25 | support@ffl      |
      | Go-Live             | Pending     | 2024-01-30 | onboarding@ffl   |

  Scenario: Admin sends vendor agreement
    Given an application is approved
    When the admin sends the vendor agreement:
      | field               | value                          |
      | agreement_type      | Standard Vendor Agreement      |
      | commission_rate     | 15%                            |
      | payment_terms       | Net 30                         |
      | contract_term       | 12 months                      |
      | auto_renewal        | Yes                            |
    Then the agreement is sent for e-signature
    And the vendor is notified

  Scenario: Admin tracks agreement signing
    Given an agreement is pending signature
    When the admin views signing status
    Then status is displayed:
      | document            | sent_date  | viewed    | signed    |
      | Vendor Agreement    | 2024-01-15 | Yes       | No        |
      | Terms of Service    | 2024-01-15 | Yes       | Yes       |
      | Privacy Policy      | 2024-01-15 | Yes       | Yes       |
    And reminders can be sent for unsigned docs

  Scenario: Admin completes account setup
    Given agreements are signed
    When the admin sets up vendor account:
      | field               | value                    |
      | vendor_id           | VND-2024-00123           |
      | username            | fantasystats             |
      | portal_access       | Enabled                  |
      | api_access          | Enabled                  |
      | commission_tier     | Standard (15%)           |
    Then the vendor account is created
    And credentials are sent securely

  Scenario: Admin configures payment settings
    When the admin configures vendor payments:
      | field               | value                    |
      | payout_method       | Bank Transfer            |
      | payout_frequency    | Weekly                   |
      | minimum_payout      | $100                     |
      | currency            | USD                      |
      | tax_form            | W-9 on file              |
    Then payment configuration is saved
    And vendor can receive payouts

  Scenario: Admin schedules vendor training
    When the admin schedules training:
      | session             | date       | duration | format    |
      | Platform Overview   | 2024-01-22 | 1 hour   | Video     |
      | Seller Portal       | 2024-01-23 | 2 hours  | Live      |
      | Best Practices      | 2024-01-24 | 1 hour   | Video     |
      | Q&A Session         | 2024-01-25 | 30 min   | Live      |
    Then training is scheduled
    And vendor receives calendar invites

  Scenario: Admin tracks training completion
    When the admin views training progress
    Then completion is displayed:
      | module              | status      | score   | completed_on |
      | Platform Overview   | Completed   | 95%     | 2024-01-22   |
      | Seller Portal       | Completed   | 88%     | 2024-01-23   |
      | Best Practices      | In Progress | -       | -            |
      | Q&A Session         | Scheduled   | -       | -            |

  # ===========================================
  # Vendor Approval
  # ===========================================

  Scenario: Admin approves vendor application
    Given all verification steps are complete
    And training is completed
    When the admin approves the vendor:
      | field               | value                    |
      | approval_type       | Full Approval            |
      | effective_date      | 2024-01-30               |
      | initial_tier        | Standard                 |
      | product_limit       | 10                       |
      | notes               | Ready for marketplace    |
    Then the vendor is approved
    And welcome package is sent
    And vendor appears in marketplace

  Scenario: Admin conditionally approves vendor
    Given verification is mostly complete
    When the admin grants conditional approval:
      | field               | value                    |
      | approval_type       | Conditional              |
      | conditions          | Insurance renewal by Feb |
      | review_date         | 2024-02-15               |
      | restrictions        | Max 5 products           |
    Then conditional approval is granted
    And conditions are tracked
    And vendor is notified of requirements

  Scenario: Admin rejects vendor application
    Given the application does not meet standards
    When the admin rejects the application:
      | field               | value                          |
      | reason              | Business verification failed   |
      | detailed_feedback   | Unable to verify business license |
      | reapply_eligible    | Yes                            |
      | reapply_after       | 90 days                        |
    Then the application is rejected
    And applicant is notified with reasons
    And rejection is logged

  Scenario: Admin escalates application
    Given an application requires senior review
    When the admin escalates:
      | field               | value                    |
      | escalate_to         | senior-review@ffl        |
      | reason              | Background check flag    |
      | priority            | High                     |
      | notes               | Requires management decision |
    Then the application is escalated
    And escalation is tracked
    And SLA is adjusted

  Scenario: Admin views approval history
    Given vendors have been processed
    When the admin views approval history
    Then history is displayed:
      | vendor              | decision    | date       | reviewer         |
      | Fantasy Stats Pro   | Approved    | 2024-01-30 | admin@example.com|
      | Bad Actor Inc       | Rejected    | 2024-01-28 | reviewer@ffl     |
      | Sports Gear Co      | Conditional | 2024-01-25 | admin@example.com|

  # ===========================================
  # Vendor Tier Management
  # ===========================================

  Scenario: Admin views vendor tiers
    When the admin views tier configuration
    Then tiers are displayed:
      | tier        | commission | features                    | requirements           |
      | Starter     | 20%        | Basic listing, 5 products   | New vendors            |
      | Standard    | 15%        | Featured spots, 25 products | 3+ months, good rating |
      | Premium     | 10%        | Priority placement, unlimited| 12+ months, top seller|
      | Enterprise  | Custom     | Dedicated support, API      | Negotiated             |

  Scenario: Admin upgrades vendor tier
    Given a vendor qualifies for upgrade
    When the admin upgrades the tier:
      | field               | value                    |
      | vendor              | Fantasy Stats Pro        |
      | current_tier        | Starter                  |
      | new_tier            | Standard                 |
      | effective_date      | 2024-02-01               |
      | reason              | Performance milestone    |
    Then the tier is upgraded
    And vendor is notified
    And new benefits are activated

  Scenario: Admin downgrades vendor tier
    Given a vendor violates tier requirements
    When the admin downgrades the tier:
      | field               | value                    |
      | vendor              | Poor Performer Inc       |
      | current_tier        | Standard                 |
      | new_tier            | Starter                  |
      | reason              | Rating below threshold   |
      | appeal_window       | 14 days                  |
    Then the tier is downgraded
    And vendor is notified with appeal options

  # ===========================================
  # Vendor Performance Monitoring
  # ===========================================

  Scenario: Admin views vendor performance
    When the admin views vendor metrics
    Then performance is displayed:
      | vendor              | sales_mtd | rating | response_time | issues |
      | Fantasy Stats Pro   | $12,450   | 4.8    | 2 hours       | 0      |
      | Sports Merch Inc    | $8,900    | 4.5    | 4 hours       | 2      |
      | Analytics Hub       | $5,670    | 4.2    | 8 hours       | 1      |

  Scenario: Admin sets performance thresholds
    When the admin configures thresholds:
      | metric              | warning   | critical | action           |
      | Average Rating      | < 4.0     | < 3.5    | Tier review      |
      | Response Time       | > 12 hrs  | > 24 hrs | Warning          |
      | Cancellation Rate   | > 5%      | > 10%    | Suspend          |
      | Complaint Rate      | > 2%      | > 5%     | Investigation    |
    Then thresholds are saved
    And automated monitoring begins

  Scenario: Admin reviews vendor violations
    Given a vendor has policy violations
    When the admin reviews violations
    Then violations are displayed:
      | date       | violation           | severity | status    |
      | 2024-01-14 | Late shipment       | Minor    | Resolved  |
      | 2024-01-12 | Misleading listing  | Major    | Pending   |
      | 2024-01-10 | Customer complaint  | Minor    | Resolved  |
    And violation history affects tier eligibility

  # ===========================================
  # Vendor Communication
  # ===========================================

  Scenario: Admin sends vendor communication
    When the admin sends message:
      | field               | value                          |
      | recipient           | Fantasy Stats Pro              |
      | type                | Policy Update                  |
      | subject             | New Commission Structure       |
      | message             | Effective Feb 1, new rates...  |
      | requires_ack        | Yes                            |
    Then the message is sent
    And delivery is tracked
    And acknowledgment is monitored

  Scenario: Admin sends bulk communication
    When the admin sends bulk message:
      | field               | value                    |
      | recipients          | All Active Vendors       |
      | type                | Announcement             |
      | subject             | Platform Update v2.0     |
      | schedule            | 2024-02-01 09:00 UTC     |
    Then the message is scheduled
    And delivery stats are tracked

  Scenario: Admin views communication history
    When the admin views vendor communications
    Then history is displayed:
      | date       | type          | recipient       | status    | opened |
      | 2024-01-15 | Policy Update | All Vendors     | Delivered | 89%    |
      | 2024-01-12 | Warning       | Sports Merch    | Delivered | Yes    |
      | 2024-01-10 | Welcome       | Analytics Hub   | Delivered | Yes    |

  # ===========================================
  # Vendor Suspension and Termination
  # ===========================================

  Scenario: Admin suspends vendor
    Given a vendor has serious violations
    When the admin suspends the vendor:
      | field               | value                          |
      | vendor              | Problem Vendor Inc             |
      | suspension_type     | Temporary                      |
      | duration            | 30 days                        |
      | reason              | Multiple customer complaints   |
      | appeal_allowed      | Yes                            |
    Then the vendor is suspended
    And listings are hidden
    And pending orders are handled
    And vendor is notified

  Scenario: Admin terminates vendor
    Given a vendor has critical violations
    When the admin terminates the vendor:
      | field               | value                          |
      | vendor              | Fraudulent Vendor LLC          |
      | termination_type    | Permanent                      |
      | reason              | Fraudulent activity            |
      | effective           | Immediate                      |
      | payout_status       | Held pending review            |
    Then the vendor is terminated
    And all access is revoked
    And customers are notified
    And legal is informed

  Scenario: Admin handles vendor appeal
    Given a suspended vendor files appeal
    When the admin reviews the appeal
    Then appeal details are displayed:
      | field               | value                          |
      | vendor              | Problem Vendor Inc             |
      | original_action     | 30-day suspension              |
      | appeal_reason       | Claims false complaint         |
      | evidence_provided   | Customer communication logs    |
      | deadline            | 2024-02-01                     |
    And the admin can uphold, modify, or overturn

  # ===========================================
  # Onboarding Analytics
  # ===========================================

  Scenario: Admin views onboarding metrics
    When the admin views onboarding analytics
    Then metrics are displayed:
      | metric                    | value   | trend   |
      | Applications Received     | 45      | +12%    |
      | Approval Rate             | 78%     | +5%     |
      | Average Time to Approval  | 8 days  | -2 days |
      | First Sale (Avg Days)     | 14 days | -3 days |
      | 90-Day Retention          | 92%     | +4%     |

  Scenario: Admin views onboarding funnel
    When the admin views the onboarding funnel
    Then funnel is displayed:
      | stage               | count | conversion | avg_time |
      | Application         | 100   | -          | -        |
      | Initial Review      | 95    | 95%        | 2 days   |
      | Verification        | 85    | 89%        | 5 days   |
      | Agreement           | 80    | 94%        | 3 days   |
      | Training            | 78    | 98%        | 5 days   |
      | Go-Live             | 75    | 96%        | 2 days   |

  Scenario: Admin identifies bottlenecks
    When the admin analyzes processing times
    Then bottlenecks are highlighted:
      | stage               | target  | actual  | status  | cause                |
      | Initial Review      | 2 days  | 2.1 days| Good    | -                    |
      | Verification        | 3 days  | 5.2 days| Warning | Background check delay|
      | Agreement           | 2 days  | 3.5 days| Warning | Legal review backlog |
    And improvement suggestions are provided

  # ===========================================
  # Vendor Self-Service
  # ===========================================

  Scenario: Admin configures self-service options
    When the admin configures vendor self-service:
      | feature             | enabled | approval_required |
      | Profile Updates     | Yes     | No                |
      | Product Listings    | Yes     | First 5 only      |
      | Pricing Changes     | Yes     | > 20% change      |
      | Promotion Creation  | Yes     | Yes               |
      | Payout Requests     | Yes     | No                |
    Then self-service settings are saved
    And vendors can manage accordingly

  Scenario: Admin reviews self-service actions
    When the admin views vendor self-service log
    Then actions are displayed:
      | timestamp           | vendor          | action           | status    |
      | 2024-01-15 14:30:00 | Fantasy Stats   | New Product      | Approved  |
      | 2024-01-15 10:15:00 | Sports Merch    | Price Change 25% | Pending   |
      | 2024-01-14 16:45:00 | Analytics Hub   | Profile Update   | Auto-OK   |

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot approve without verification
    Given verification is incomplete
    When the admin attempts to approve
    Then the request is blocked with error "VERIFICATION_INCOMPLETE"
    And outstanding requirements are listed

  Scenario: Admin cannot terminate without documentation
    When the admin attempts to terminate without reason
    Then the request is rejected with error "DOCUMENTATION_REQUIRED"
    And required fields are highlighted

  Scenario: Duplicate application detected
    Given a business has a pending application
    When the same business submits another application
    Then the system flags duplicate:
      """
      Duplicate Application Detected:
      - Existing Application: APP-2024-00100 (Pending)
      - Business: Fantasy Stats Pro LLC
      - EIN Match: Yes

      Options:
      1. Link to existing application
      2. Mark as intentional resubmission
      3. Reject as duplicate
      """

  Scenario: Vendor agreement expires during onboarding
    Given the agreement signing deadline passed
    When the admin views the application
    Then a warning is displayed:
      """
      Agreement Expired:
      - Sent: 2024-01-10
      - Deadline: 2024-01-17
      - Status: Not Signed

      Options:
      1. Resend agreement (extends deadline)
      2. Contact applicant
      3. Cancel application
      """

  Scenario: Background check returns critical flag
    Given a background check has critical findings
    When results are received
    Then automatic escalation occurs:
      | field               | value                    |
      | escalated_to        | legal@ffl, compliance@ffl|
      | reason              | Criminal record found    |
      | application_status  | On Hold                  |
      | action_required     | Management decision      |
    And applicant is not notified until reviewed
