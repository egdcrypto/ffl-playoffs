@admin @security-compliance @mvp-admin
Feature: Admin Security Compliance
  As a platform administrator
  I want to manage security compliance and certifications
  So that I can ensure the platform meets industry security standards

  Background:
    Given I am logged in as a platform administrator
    And I have security compliance permissions

  # =============================================================================
  # COMPLIANCE DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View security compliance dashboard
    When I navigate to the security compliance dashboard
    Then I should see the overall compliance score
    And I should see compliance status for each framework:
      | Framework    | Status Indicators                    |
      | SOC 2        | Type I/II status, last audit         |
      | ISO 27001    | Certification status, expiry         |
      | PCI DSS      | Compliance level, last assessment    |
      | HIPAA        | Compliance status, gaps              |
      | GDPR         | Compliance status, DPO assigned      |
      | SOX          | Control status, audit findings       |
    And I should see upcoming compliance deadlines
    And I should see recent compliance activities

  @dashboard @metrics
  Scenario: View compliance metrics and KPIs
    When I view compliance metrics
    Then I should see key performance indicators:
      | KPI                        | Target    | Measurement     |
      | Control effectiveness      | > 95%     | Monthly         |
      | Audit findings open        | < 5       | Current         |
      | Remediation completion     | > 90%     | Quarterly       |
      | Policy compliance rate     | 100%      | Continuous      |
      | Training completion        | 100%      | Quarterly       |
      | Vulnerability remediation  | < 30 days | Average         |
    And I should see metric trends over time
    And I should see areas requiring attention

  @dashboard @timeline
  Scenario: View compliance calendar and timeline
    When I access the compliance calendar
    Then I should see scheduled events:
      | Event Type              | Information Shown                |
      | Audits                  | Date, scope, auditor             |
      | Certifications expiry   | Framework, expiry date           |
      | Control reviews         | Control, review due date         |
      | Training deadlines      | Course, completion deadline      |
      | Policy reviews          | Policy, review due date          |
      | Remediation deadlines   | Finding, due date                |
    And I should be able to filter by framework
    And I should receive reminders for upcoming events

  @dashboard @gap-analysis
  Scenario: View compliance gap analysis
    When I view gap analysis report
    Then I should see gaps identified by framework
    And each gap should display:
      | Field                   | Description                      |
      | Gap description         | What is missing                  |
      | Affected controls       | Related control requirements     |
      | Risk level              | Critical/High/Medium/Low         |
      | Remediation plan        | Steps to address gap             |
      | Owner                   | Responsible party                |
      | Target date             | Expected resolution date         |
    And I should see gap closure progress
    And I should be able to prioritize gaps

  # =============================================================================
  # SECURITY CONTROLS MANAGEMENT
  # =============================================================================

  @controls @inventory
  Scenario: Manage security controls inventory
    When I access security controls management
    Then I should see all security controls with:
      | Control Field           | Description                      |
      | Control ID              | Unique identifier                |
      | Control name            | Descriptive name                 |
      | Control category        | Access, network, data, etc.      |
      | Framework mapping       | SOC 2, ISO, PCI requirements     |
      | Implementation status   | Implemented, partial, planned    |
      | Effectiveness           | Effective, needs improvement     |
      | Owner                   | Control owner                    |
      | Last tested             | Most recent test date            |
    And I should be able to filter and search controls
    And I should be able to export controls inventory

  @controls @implementation
  Scenario: Document control implementation
    When I document a security control
    Then I should be able to specify:
      | Documentation           | Content                          |
      | Control objective       | What the control achieves        |
      | Implementation details  | How control is implemented       |
      | Evidence location       | Where evidence is stored         |
      | Testing procedures      | How to test effectiveness        |
      | Frequency               | How often control operates       |
      | Dependencies            | Related controls or systems      |
    And I should link supporting documentation
    And I should track implementation history

  @controls @testing
  Scenario: Conduct control testing
    When I test a security control
    Then I should be able to:
      | Action                  | Description                      |
      | Select test procedure   | Choose from predefined tests     |
      | Execute test            | Perform control test             |
      | Document results        | Record test outcomes             |
      | Attach evidence         | Upload supporting evidence       |
      | Rate effectiveness      | Score control effectiveness      |
      | Identify exceptions     | Document any failures            |
    And test results should update control status
    And I should be able to schedule recurring tests

  @controls @mapping
  Scenario: Map controls to compliance frameworks
    When I map controls to frameworks
    Then I should be able to:
      | Mapping Action          | Description                      |
      | View framework reqs     | See all framework requirements   |
      | Map controls            | Link controls to requirements    |
      | Identify gaps           | Find unmapped requirements       |
      | Cross-reference         | See shared controls              |
      | Generate matrix         | Create control mapping matrix    |
    And mappings should support multiple frameworks
    And I should see coverage percentage by framework

  @controls @exceptions
  Scenario: Manage control exceptions
    When I manage control exceptions
    Then I should be able to create exceptions with:
      | Exception Field         | Description                      |
      | Control affected        | Which control has exception      |
      | Exception type          | Compensating, risk acceptance    |
      | Justification           | Why exception is needed          |
      | Compensating controls   | Alternative controls in place    |
      | Risk assessment         | Residual risk evaluation         |
      | Approval                | Required approvals               |
      | Expiration date         | When exception expires           |
    And exceptions should require appropriate approval
    And I should track exception renewal

  @controls @evidence
  Scenario: Manage control evidence
    When I manage control evidence
    Then I should be able to:
      | Action                  | Description                      |
      | Upload evidence         | Add supporting documentation     |
      | Categorize evidence     | Tag by control and period        |
      | Link to controls        | Associate with specific controls |
      | Set retention           | Define retention period          |
      | Track collection        | Monitor evidence collection      |
      | Generate requests       | Request evidence from owners     |
    And evidence should be version controlled
    And I should see evidence collection status

  # =============================================================================
  # COMPLIANCE AUDITS
  # =============================================================================

  @audit @planning
  Scenario: Plan compliance audits
    When I plan a compliance audit
    Then I should be able to specify:
      | Audit Planning          | Configuration                    |
      | Audit type              | Internal, external, regulatory   |
      | Framework scope         | Which frameworks to audit        |
      | Control scope           | Which controls to test           |
      | Audit period            | Time period under review         |
      | Auditor                 | Internal team or external firm   |
      | Timeline                | Start date, duration, end date   |
      | Resources               | Personnel and system access      |
    And I should generate audit preparation checklist
    And I should notify relevant stakeholders

  @audit @preparation
  Scenario: Prepare for compliance audit
    When I prepare for an audit
    Then I should be able to:
      | Preparation Task        | Description                      |
      | Gather evidence         | Collect required documentation   |
      | Review controls         | Pre-test control effectiveness   |
      | Identify gaps           | Find potential issues            |
      | Prepare responses       | Draft responses to common items  |
      | Schedule interviews     | Plan auditor meetings            |
      | Assign owners           | Designate response owners        |
    And I should track preparation progress
    And I should see readiness score

  @audit @execution
  Scenario: Execute compliance audit
    When I execute a compliance audit
    Then I should be able to:
      | Audit Activity          | Description                      |
      | Track requests          | Manage information requests      |
      | Submit evidence         | Provide requested documentation  |
      | Schedule walkthroughs   | Arrange system demonstrations    |
      | Log interviews          | Document interview sessions      |
      | Track findings          | Log preliminary findings         |
      | Respond to queries      | Answer auditor questions         |
    And I should see audit progress dashboard
    And I should communicate with audit team

  @audit @findings
  Scenario: Manage audit findings
    When I manage audit findings
    Then I should see all findings with:
      | Finding Field           | Description                      |
      | Finding ID              | Unique identifier                |
      | Description             | Finding details                  |
      | Severity                | Critical, High, Medium, Low      |
      | Control affected        | Related control                  |
      | Framework requirement   | Requirement not met              |
      | Recommendation          | Auditor recommendation           |
      | Management response     | Our response plan                |
      | Remediation owner       | Responsible party                |
      | Target date             | Resolution deadline              |
    And I should track finding status
    And I should prioritize by severity

  @audit @remediation
  Scenario: Track audit remediation
    When I track audit remediation
    Then I should see:
      | Tracking Information    | Description                      |
      | Open findings           | Findings awaiting remediation    |
      | In progress             | Actively being remediated        |
      | Pending validation      | Awaiting verification            |
      | Closed                  | Validated and resolved           |
      | Overdue                 | Past target date                 |
    And I should see remediation timeline
    And I should receive alerts for overdue items

  @audit @reports
  Scenario: Generate audit reports
    When I generate audit reports
    Then I should be able to create:
      | Report Type             | Content                          |
      | Audit summary           | High-level audit results         |
      | Detailed findings       | Complete finding details         |
      | Remediation status      | Progress on addressing findings  |
      | Management assertion    | Management attestation           |
      | Board report            | Executive-level summary          |
    And reports should be customizable
    And reports should be exportable in multiple formats

  # =============================================================================
  # SECURITY RISK ASSESSMENTS
  # =============================================================================

  @risk @assessment
  Scenario: Conduct security risk assessment
    When I conduct a security risk assessment
    Then I should be able to:
      | Assessment Step         | Description                      |
      | Define scope            | Assets and systems in scope      |
      | Identify threats        | Potential threat sources         |
      | Identify vulnerabilities| Weaknesses that could be exploited|
      | Assess likelihood       | Probability of occurrence        |
      | Assess impact           | Potential damage or loss         |
      | Calculate risk score    | Combined risk rating             |
      | Recommend controls      | Mitigation measures              |
    And I should use standardized risk methodology
    And I should document assessment results

  @risk @register
  Scenario: Maintain risk register
    When I access the risk register
    Then I should see all identified risks with:
      | Risk Field              | Description                      |
      | Risk ID                 | Unique identifier                |
      | Risk description        | What could go wrong              |
      | Category                | Operational, compliance, etc.    |
      | Inherent risk           | Risk before controls             |
      | Control effectiveness   | How well controls mitigate       |
      | Residual risk           | Risk after controls              |
      | Risk owner              | Accountable party                |
      | Treatment plan          | How risk will be addressed       |
      | Status                  | Open, mitigated, accepted        |
    And I should be able to filter and sort risks
    And I should see risk trends over time

  @risk @treatment
  Scenario: Define risk treatment plans
    When I create a risk treatment plan
    Then I should be able to specify:
      | Treatment Option        | Description                      |
      | Mitigate                | Implement controls to reduce     |
      | Transfer                | Insurance or outsourcing         |
      | Accept                  | Acknowledge and monitor          |
      | Avoid                   | Eliminate the risk source        |
    And for mitigation I should define:
      | Mitigation Detail       | Description                      |
      | Control measures        | Specific controls to implement   |
      | Implementation steps    | Action items                     |
      | Resources required      | Budget and personnel             |
      | Timeline                | Implementation schedule          |
      | Success criteria        | How to measure effectiveness     |
    And treatment plans should be tracked

  @risk @monitoring
  Scenario: Monitor risk indicators
    When I configure risk monitoring
    Then I should be able to set:
      | Risk Indicator          | Configuration                    |
      | Key Risk Indicators     | Metrics that signal risk changes |
      | Thresholds              | Warning and critical levels      |
      | Data sources            | Where metrics come from          |
      | Monitoring frequency    | How often to check               |
      | Alert recipients        | Who to notify                    |
    And I should see KRI dashboard
    And I should receive alerts for threshold breaches

  @risk @third-party
  Scenario: Assess third-party security risks
    When I assess third-party risks
    Then I should be able to:
      | Assessment Action       | Description                      |
      | Inventory vendors       | List all third parties           |
      | Categorize by risk      | Critical, high, medium, low      |
      | Request assessments     | Send security questionnaires     |
      | Review responses        | Evaluate vendor responses        |
      | Conduct due diligence   | Verify security practices        |
      | Track certifications    | Monitor vendor certifications    |
      | Set review schedule     | Periodic reassessment dates      |
    And I should see vendor risk scores
    And I should track remediation items

  # =============================================================================
  # COMPLIANCE CERTIFICATIONS
  # =============================================================================

  @certification @soc2
  Scenario: Manage SOC 2 compliance
    When I manage SOC 2 compliance
    Then I should be able to track:
      | SOC 2 Element           | Information                      |
      | Trust service criteria  | Security, availability, etc.     |
      | Control coverage        | Controls mapped to criteria      |
      | Type I/II status        | Current certification type       |
      | Audit period            | Period covered by report         |
      | Report availability     | Where reports can be accessed    |
      | Customer requests       | Track report requests            |
    And I should see SOC 2 readiness score
    And I should prepare for annual audits

  @certification @iso27001
  Scenario: Manage ISO 27001 certification
    When I manage ISO 27001 certification
    Then I should be able to:
      | ISO 27001 Activity      | Description                      |
      | Track ISMS scope        | Information security boundaries  |
      | Manage policy set       | Required policies and procedures |
      | Conduct internal audits | Pre-certification assessments    |
      | Track nonconformities   | Issues requiring correction      |
      | Prepare for surveillance| Annual surveillance audits       |
      | Manage recertification  | Three-year recertification       |
    And I should see Annex A control status
    And I should track certification validity

  @certification @pci-dss
  Scenario: Manage PCI DSS compliance
    When I manage PCI DSS compliance
    Then I should be able to track:
      | PCI DSS Element         | Information                      |
      | Compliance level        | Level 1-4 based on volume        |
      | SAQ type                | Applicable questionnaire         |
      | Requirements status     | Status of each requirement       |
      | ASV scan results        | Quarterly scan status            |
      | Penetration tests       | Annual test results              |
      | AOC status              | Attestation of compliance        |
    And I should see PCI DSS requirement mapping
    And I should track quarterly deadlines

  @certification @hipaa
  Scenario: Manage HIPAA compliance
    When I manage HIPAA compliance
    Then I should be able to:
      | HIPAA Activity          | Description                      |
      | Track PHI inventory     | Where protected health info is   |
      | Manage BAAs             | Business associate agreements    |
      | Conduct risk analysis   | Required security risk analysis  |
      | Track safeguards        | Administrative, physical, tech   |
      | Document policies       | Required HIPAA policies          |
      | Manage training         | Workforce training records       |
    And I should see HIPAA compliance status
    And I should prepare for OCR audits

  @certification @gdpr
  Scenario: Manage GDPR compliance
    When I manage GDPR compliance
    Then I should be able to:
      | GDPR Activity           | Description                      |
      | Track processing        | Data processing activities       |
      | Manage legal basis      | Consent, contract, legitimate    |
      | Handle DSARs            | Data subject access requests     |
      | Conduct DPIAs           | Data protection impact assess    |
      | Track transfers         | International data transfers     |
      | Document accountability | Records of processing            |
    And I should see GDPR compliance dashboard
    And I should track data subject rights

  # =============================================================================
  # SECURITY POLICIES
  # =============================================================================

  @policy @management
  Scenario: Manage security policies
    When I access security policy management
    Then I should see all policies with:
      | Policy Field            | Description                      |
      | Policy name             | Title of the policy              |
      | Version                 | Current version number           |
      | Category                | Policy category                  |
      | Owner                   | Policy owner                     |
      | Effective date          | When policy became effective     |
      | Review date             | Next scheduled review            |
      | Status                  | Draft, active, retired           |
    And I should be able to search and filter policies
    And I should track policy acknowledgments

  @policy @creation
  Scenario: Create and approve security policies
    When I create a new security policy
    Then I should follow the workflow:
      | Workflow Step           | Description                      |
      | Draft policy            | Create initial policy content    |
      | Submit for review       | Send for stakeholder review      |
      | Collect feedback        | Gather and address comments      |
      | Legal review            | Ensure legal compliance          |
      | Management approval     | Obtain required approvals        |
      | Publish                 | Make policy effective            |
      | Communicate             | Notify affected personnel        |
    And policy should be version controlled
    And I should maintain approval records

  @policy @review
  Scenario: Conduct periodic policy reviews
    When I conduct policy reviews
    Then I should be able to:
      | Review Action           | Description                      |
      | Schedule reviews        | Set review frequency             |
      | Assign reviewers        | Designate review owners          |
      | Track review status     | Monitor review completion        |
      | Document changes        | Record what was updated          |
      | Approve revisions       | Get approval for changes         |
      | Update effective date   | Set new effective date           |
    And I should see policies due for review
    And I should archive superseded versions

  @policy @acknowledgment
  Scenario: Track policy acknowledgments
    When I track policy acknowledgments
    Then I should be able to:
      | Acknowledgment Action   | Description                      |
      | Assign policies         | Determine who must acknowledge   |
      | Send notifications      | Notify users of required acks    |
      | Track completion        | Monitor who has acknowledged     |
      | Send reminders          | Follow up on outstanding acks    |
      | Generate reports        | Report on acknowledgment status  |
      | Maintain records        | Store acknowledgment history     |
    And I should see acknowledgment compliance rate
    And I should escalate non-compliance

  # =============================================================================
  # SECURITY TRAINING AND AWARENESS
  # =============================================================================

  @training @program
  Scenario: Manage security training program
    When I manage security training
    Then I should be able to configure:
      | Training Element        | Configuration                    |
      | Training courses        | Required courses by role         |
      | Training frequency      | Annual, quarterly, on-hire       |
      | Completion tracking     | Monitor who has completed        |
      | Assessment requirements | Quiz or exam requirements        |
      | Remediation training    | For failed assessments           |
      | Specialized training    | Role-specific requirements       |
    And I should see training completion dashboard
    And I should track training effectiveness

  @training @content
  Scenario: Manage training content
    When I manage training content
    Then I should be able to:
      | Content Action          | Description                      |
      | Create courses          | Develop training materials       |
      | Import content          | Use external training content    |
      | Assign courses          | Assign to user groups            |
      | Track versions          | Maintain content versions        |
      | Gather feedback         | Collect learner feedback         |
      | Update regularly        | Keep content current             |
    And content should be tagged by topic
    And I should track content effectiveness

  @training @phishing
  Scenario: Conduct phishing simulations
    When I run phishing simulations
    Then I should be able to:
      | Simulation Action       | Description                      |
      | Create campaigns        | Design phishing scenarios        |
      | Select targets          | Choose user groups               |
      | Schedule delivery       | Set send time                    |
      | Track results           | Monitor click rates              |
      | Provide training        | Auto-assign training for clicks  |
      | Generate reports        | Analyze campaign results         |
    And I should see phishing susceptibility trends
    And I should identify high-risk users

  @training @compliance
  Scenario: Track training compliance
    When I track training compliance
    Then I should see:
      | Compliance Metric       | Description                      |
      | Completion rate         | Percentage completed             |
      | Overdue training        | Not completed by deadline        |
      | Upcoming deadlines      | Training due soon                |
      | By department           | Compliance by team               |
      | By course               | Completion by course             |
    And I should send automated reminders
    And I should escalate non-compliance

  # =============================================================================
  # INCIDENT AND BREACH MANAGEMENT
  # =============================================================================

  @incident @response
  Scenario: Manage security incident response
    When I manage security incidents
    Then I should be able to:
      | Incident Action         | Description                      |
      | Log incident            | Record incident details          |
      | Classify severity       | Rate impact and urgency          |
      | Assign responders       | Designate response team          |
      | Track response          | Monitor response activities      |
      | Document actions        | Record all response steps        |
      | Conduct post-mortem     | Analyze and learn from incident  |
    And incidents should follow defined playbooks
    And I should track incident metrics

  @incident @breach
  Scenario: Manage data breach response
    When a data breach occurs
    Then I should follow breach procedures:
      | Breach Step             | Description                      |
      | Contain breach          | Stop further data exposure       |
      | Assess scope            | Determine what data affected     |
      | Notify stakeholders     | Alert required parties           |
      | Regulatory notification | Notify regulators if required    |
      | Customer notification   | Notify affected individuals      |
      | Document response       | Maintain breach records          |
    And I should track notification deadlines
    And I should comply with breach notification laws

  @incident @lessons-learned
  Scenario: Document lessons learned from incidents
    When I document lessons learned
    Then I should capture:
      | Lessons Element         | Content                          |
      | Root cause              | Why incident occurred            |
      | Detection gaps          | How detection could improve      |
      | Response gaps           | How response could improve       |
      | Preventive measures     | Controls to prevent recurrence   |
      | Process improvements    | Procedure updates needed         |
      | Training needs          | Additional training required     |
    And lessons should be tracked to implementation
    And I should share relevant findings

  # =============================================================================
  # VENDOR AND THIRD-PARTY COMPLIANCE
  # =============================================================================

  @vendor @assessment
  Scenario: Assess vendor security compliance
    When I assess vendor compliance
    Then I should be able to:
      | Assessment Action       | Description                      |
      | Send questionnaire      | Security assessment questions    |
      | Review certifications   | SOC 2, ISO, etc. reports         |
      | Verify insurance        | Cyber liability coverage         |
      | Review contracts        | Security terms and SLAs          |
      | Conduct site visits     | On-site security review          |
      | Document findings       | Record assessment results        |
    And I should calculate vendor risk score
    And I should track remediation items

  @vendor @monitoring
  Scenario: Monitor ongoing vendor compliance
    When I monitor vendor compliance
    Then I should track:
      | Monitoring Activity     | Description                      |
      | Certification status    | Track cert validity              |
      | Incident notifications  | Vendor security incidents        |
      | SLA compliance          | Security SLA performance         |
      | Contract renewals       | Review at renewal                |
      | Continuous monitoring   | Automated security feeds         |
    And I should receive alerts for compliance changes
    And I should schedule periodic reassessments

  @vendor @contracts
  Scenario: Manage security contract requirements
    When I manage security contracts
    Then I should ensure contracts include:
      | Contract Clause         | Requirements                     |
      | Security standards      | Required security practices      |
      | Data protection         | Data handling requirements       |
      | Incident notification   | Breach notification terms        |
      | Audit rights            | Right to audit vendor            |
      | Subcontractor terms     | Requirements for subcontractors  |
      | Termination provisions  | Data return and destruction      |
    And I should track contract compliance
    And I should maintain contract repository

  # =============================================================================
  # COMPLIANCE REPORTING AND ANALYTICS
  # =============================================================================

  @reporting @executive
  Scenario: Generate executive compliance reports
    When I generate executive reports
    Then I should include:
      | Report Section          | Content                          |
      | Compliance summary      | Overall compliance posture       |
      | Risk overview           | Key risks and trends             |
      | Audit status            | Recent and upcoming audits       |
      | Certification status    | All active certifications        |
      | Key metrics             | Critical KPIs and trends         |
      | Action items            | Items requiring attention        |
    And reports should be visually clear
    And I should schedule automated delivery

  @reporting @regulatory
  Scenario: Generate regulatory compliance reports
    When I generate regulatory reports
    Then I should be able to create:
      | Report Type             | Purpose                          |
      | Compliance attestation  | Management assertions            |
      | Evidence package        | Supporting documentation         |
      | Gap analysis            | Identified compliance gaps       |
      | Remediation status      | Progress on addressing gaps      |
      | Audit response          | Responses to regulatory findings |
    And reports should meet regulatory format requirements
    And I should maintain report history

  @reporting @analytics
  Scenario: Analyze compliance trends and metrics
    When I access compliance analytics
    Then I should see:
      | Analytics Category      | Insights                         |
      | Compliance score trend  | Score changes over time          |
      | Control effectiveness   | Control performance trends       |
      | Audit finding trends    | Finding patterns over time       |
      | Risk trend analysis     | How risk profile is changing     |
      | Training effectiveness  | Training impact on incidents     |
      | Vendor risk trends      | Third-party risk changes         |
    And I should identify patterns and correlations
    And I should export data for further analysis

  @reporting @dashboards
  Scenario: Configure compliance dashboards
    When I configure compliance dashboards
    Then I should be able to:
      | Dashboard Action        | Description                      |
      | Create custom views     | Build tailored dashboards        |
      | Select metrics          | Choose displayed KPIs            |
      | Set refresh rate        | Configure update frequency       |
      | Define drill-down       | Enable detailed views            |
      | Share dashboards        | Grant access to others           |
      | Schedule snapshots      | Capture point-in-time views      |
    And dashboards should be role-based
    And I should save dashboard configurations

  # =============================================================================
  # COMPLIANCE AUTOMATION
  # =============================================================================

  @automation @evidence
  Scenario: Automate evidence collection
    When I configure evidence automation
    Then I should be able to:
      | Automation Action       | Description                      |
      | Connect data sources    | Link to systems and tools        |
      | Define evidence rules   | What to collect automatically    |
      | Schedule collection     | Set collection frequency         |
      | Validate evidence       | Auto-verify evidence quality     |
      | Organize evidence       | Auto-categorize and tag          |
      | Alert on gaps           | Notify when evidence missing     |
    And evidence should be automatically mapped to controls
    And I should see evidence freshness status

  @automation @monitoring
  Scenario: Configure continuous compliance monitoring
    When I configure continuous monitoring
    Then I should be able to:
      | Monitoring Config       | Description                      |
      | Define checks           | What to monitor continuously     |
      | Set thresholds          | Alert triggers                   |
      | Configure frequency     | How often to check               |
      | Define alerts           | Who to notify and how            |
      | Auto-remediation        | Automatic fixes where possible   |
      | Integration             | Connect to SIEM, GRC tools       |
    And I should see real-time compliance status
    And I should receive proactive alerts

  @automation @workflow
  Scenario: Automate compliance workflows
    When I configure compliance workflows
    Then I should be able to automate:
      | Workflow Type           | Automation                       |
      | Policy acknowledgment   | Auto-assign and remind           |
      | Control testing         | Schedule and track               |
      | Risk assessment         | Periodic reassessment triggers   |
      | Vendor reviews          | Annual review reminders          |
      | Training assignments    | Auto-assign based on role        |
      | Audit preparation       | Pre-audit checklist automation   |
    And workflows should be customizable
    And I should track workflow completion

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient compliance permissions
    Given I do not have security compliance permissions
    When I attempt to access compliance features
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @framework-not-configured
  Scenario: Handle unconfigured compliance framework
    Given a compliance framework is not configured
    When I attempt to view framework status
    Then I should see a "Framework Not Configured" message
    And I should see steps to configure the framework
    And I should be able to initiate configuration

  @error @audit-conflict
  Scenario: Handle audit scheduling conflict
    Given I am scheduling a compliance audit
    When the proposed date conflicts with existing audits
    Then I should see a scheduling conflict warning
    And I should see the conflicting audits
    And I should be able to:
      | Option                  | Description                      |
      | Choose different date   | Select non-conflicting date      |
      | Combine audits          | Merge with existing audit        |
      | Override                | Proceed with conflict noted      |

  @error @evidence-missing
  Scenario: Handle missing compliance evidence
    Given I am preparing for an audit
    When required evidence is missing
    Then I should see a list of missing evidence
    And I should see the affected controls
    And I should be able to:
      | Action                  | Description                      |
      | Request evidence        | Send collection request          |
      | Mark as N/A             | Document as not applicable       |
      | Document exception      | Record evidence exception        |
    And the evidence gap should be tracked

  @error @certification-expiring
  Scenario: Handle expiring certifications
    Given a certification is nearing expiration
    When I view certification status
    Then I should see an expiration warning
    And I should see days until expiration
    And I should see required renewal actions
    And I should be able to initiate renewal process
