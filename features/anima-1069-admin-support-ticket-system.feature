@admin @support-ticket-system @ANIMA-1069
Feature: Admin Support Ticket System
  As an administrator
  I want to manage a comprehensive support ticket system
  So that I can efficiently handle customer issues and maintain service quality

  Background:
    Given an authenticated administrator with "support_management" permissions
    And the support ticket system is operational
    And the following support channels are configured:
      | channel    | status   | priority_weight |
      | email      | active   | 1.0             |
      | chat       | active   | 1.2             |
      | phone      | active   | 1.5             |
      | social     | active   | 1.3             |
      | in-app     | active   | 1.1             |

  # =============================================================================
  # SUPPORT DASHBOARD SCENARIOS
  # =============================================================================

  @dashboard @happy-path
  Scenario: View comprehensive support dashboard
    Given there are 150 open tickets across all channels
    And there are 25 agents currently online
    When I navigate to the support dashboard
    Then I should see the ticket overview panel showing:
      | metric                  | value |
      | open_tickets            | 150   |
      | pending_response        | 45    |
      | escalated               | 12    |
      | breaching_sla           | 8     |
    And I should see the agent status panel showing:
      | status      | count |
      | available   | 15    |
      | busy        | 8     |
      | break       | 2     |
    And I should see real-time ticket activity feed

  @dashboard @metrics
  Scenario: View support performance metrics
    Given historical support data for the past 30 days
    When I view the performance metrics section
    Then I should see the following KPIs:
      | kpi                        | current | trend   |
      | avg_first_response_time    | 2.5h    | -15%    |
      | avg_resolution_time        | 18h     | -8%     |
      | customer_satisfaction      | 4.2/5   | +5%     |
      | first_contact_resolution   | 72%     | +3%     |
      | ticket_backlog             | 45      | -12%    |
    And I should see trend charts for each metric

  @dashboard @queue-overview
  Scenario: View queue distribution across channels
    Given tickets distributed across multiple channels
    When I view the queue distribution
    Then I should see ticket counts per channel:
      | channel  | open | pending | resolved_today |
      | email    | 65   | 25      | 45             |
      | chat     | 40   | 10      | 85             |
      | phone    | 25   | 5       | 35             |
      | social   | 15   | 3       | 20             |
      | in-app   | 5    | 2       | 15             |

  # =============================================================================
  # TICKET CREATION SCENARIOS
  # =============================================================================

  @ticket-creation @happy-path
  Scenario: Create ticket from email channel
    Given a customer email with the following details:
      | field       | value                           |
      | from        | customer@example.com            |
      | subject     | Unable to access my account     |
      | body        | I'm getting an error message... |
      | attachments | screenshot.png                  |
    When the email is processed by the ticket system
    Then a new ticket should be created with:
      | field          | value                       |
      | channel        | email                       |
      | status         | new                         |
      | priority       | medium                      |
      | category       | auto-detected               |
    And the ticket should be added to the appropriate queue
    And a domain event "TicketCreated" should be published

  @ticket-creation @multi-channel
  Scenario: Create ticket from live chat session
    Given a customer initiates a chat session
    And the chat conversation includes:
      | message_type | content                              |
      | customer     | Hi, I need help with billing         |
      | bot          | I'll connect you with an agent       |
      | customer     | My subscription shows wrong amount   |
    When the chat session is converted to a ticket
    Then the ticket should include:
      | field              | value                |
      | channel            | chat                 |
      | chat_transcript    | included             |
      | customer_sentiment | neutral              |
    And the original chat context should be preserved

  @ticket-creation @phone
  Scenario: Create ticket from phone call
    Given a phone call with the following details:
      | field           | value              |
      | caller_id       | +1-555-123-4567    |
      | duration        | 5m 32s             |
      | recording_url   | /recordings/12345  |
      | agent_notes     | Customer frustrated|
    When the agent creates a ticket from the call
    Then the ticket should include call metadata
    And the call recording should be linked
    And the ticket priority should be adjusted based on sentiment

  @ticket-creation @social-media
  Scenario: Create ticket from social media mention
    Given a social media post mentioning our brand:
      | platform  | twitter                             |
      | handle    | @angrycustomer                      |
      | content   | @FFLPlayoffs your app is broken!    |
      | sentiment | negative                            |
      | followers | 50000                               |
    When the social monitoring system detects the mention
    Then a high-priority ticket should be created
    And the ticket should be flagged for social media response
    And the influencer score should be calculated

  @ticket-creation @duplicate-detection
  Scenario: Detect and merge duplicate tickets
    Given an existing open ticket:
      | ticket_id | customer_email       | subject              |
      | TKT-1001  | user@example.com     | Login issue          |
    When a new ticket is created with similar content:
      | customer_email   | user@example.com              |
      | subject          | Still can't login             |
    Then the system should detect a potential duplicate
    And suggest merging with ticket TKT-1001
    And display the similarity score

  # =============================================================================
  # TICKET LIFECYCLE SCENARIOS
  # =============================================================================

  @ticket-lifecycle @status-transitions
  Scenario: Progress ticket through standard lifecycle
    Given a new ticket "TKT-2001"
    When the following status transitions occur:
      | from        | to           | action              |
      | new         | open         | agent_assigned      |
      | open        | pending      | awaiting_customer   |
      | pending     | open         | customer_replied    |
      | open        | resolved     | solution_provided   |
      | resolved    | closed       | confirmation_period |
    Then each transition should be recorded in ticket history
    And appropriate notifications should be sent
    And SLA timers should be adjusted accordingly

  @ticket-lifecycle @reopen
  Scenario: Reopen a closed ticket
    Given a closed ticket "TKT-3001" from 2 days ago
    And the original customer replies:
      | content | The issue is happening again |
    When the system processes the reply
    Then the ticket should be reopened
    And the status should change to "open"
    And a new SLA timer should start
    And a domain event "TicketReopened" should be published

  @ticket-lifecycle @merge
  Scenario: Merge multiple related tickets
    Given the following related tickets:
      | ticket_id | subject               | customer          |
      | TKT-4001  | Payment failed        | user@example.com  |
      | TKT-4002  | Transaction error     | user@example.com  |
      | TKT-4003  | Billing problem       | user@example.com  |
    When I merge tickets TKT-4002 and TKT-4003 into TKT-4001
    Then TKT-4001 should contain all conversation history
    And TKT-4002 and TKT-4003 should be marked as "merged"
    And the customer should be notified of the consolidation

  @ticket-lifecycle @split
  Scenario: Split a ticket with multiple issues
    Given a ticket "TKT-5001" containing:
      | issue_type | description                   |
      | billing    | Overcharged this month        |
      | technical  | App crashes on startup        |
    When I split the ticket into separate issues
    Then two new tickets should be created:
      | ticket_id | category  | linked_to |
      | TKT-5002  | billing   | TKT-5001  |
      | TKT-5003  | technical | TKT-5001  |
    And the original ticket should reference both

  # =============================================================================
  # TICKET ASSIGNMENT SCENARIOS
  # =============================================================================

  @assignment @auto-routing
  Scenario: Automatically route ticket based on category
    Given the following routing rules:
      | category    | team          | skill_required |
      | billing     | finance       | billing_expert |
      | technical   | engineering   | tech_support   |
      | account     | account_mgmt  | account_mgmt   |
    When a new technical ticket is created
    Then the ticket should be routed to the engineering team
    And assigned to an available agent with "tech_support" skill

  @assignment @load-balancing
  Scenario: Balance ticket assignment across agents
    Given the following agent workloads:
      | agent_id | current_tickets | max_capacity |
      | AGT-001  | 8               | 10           |
      | AGT-002  | 5               | 10           |
      | AGT-003  | 9               | 10           |
    When a new ticket needs assignment
    Then the ticket should be assigned to AGT-002
    And the assignment should consider skill match

  @assignment @skill-based
  Scenario: Route ticket based on required skills
    Given a complex technical ticket requiring:
      | skill               | level    |
      | database_expertise  | expert   |
      | api_troubleshooting | advanced |
    And the following available agents:
      | agent_id | skills                                    |
      | AGT-010  | database_expertise:advanced               |
      | AGT-011  | database_expertise:expert,api:advanced    |
      | AGT-012  | general_support:expert                    |
    When the ticket is routed
    Then AGT-011 should be selected as the best match
    And the skill match score should be recorded

  @assignment @priority-override
  Scenario: Override automatic assignment for VIP customers
    Given a VIP customer with tier "platinum"
    And a dedicated support team for VIP customers
    When a ticket is created by the VIP customer
    Then the ticket should bypass normal queue
    And be assigned to VIP support team
    And priority should be automatically elevated

  @assignment @manual-reassign
  Scenario: Manually reassign ticket to different agent
    Given ticket "TKT-6001" assigned to agent AGT-020
    And the ticket requires specialized expertise
    When I reassign the ticket to agent AGT-025
    Then the assignment should be updated
    And AGT-020 should be notified of the reassignment
    And AGT-025 should receive full ticket context
    And the SLA timer should not reset

  # =============================================================================
  # SLA MANAGEMENT SCENARIOS
  # =============================================================================

  @sla @configuration
  Scenario: Configure SLA policies by priority
    When I configure SLA policies:
      | priority | first_response | resolution | business_hours |
      | critical | 15m            | 4h         | 24x7           |
      | high     | 1h             | 8h         | 24x7           |
      | medium   | 4h             | 24h        | business       |
      | low      | 8h             | 72h        | business       |
    Then the SLA policies should be saved
    And all new tickets should use these policies
    And a domain event "SLAPolicyUpdated" should be published

  @sla @breach-warning
  Scenario: Alert before SLA breach
    Given a high-priority ticket created 45 minutes ago
    And first response SLA is 1 hour
    When the SLA warning threshold of 75% is reached
    Then the assigned agent should be notified
    And the supervisor should be alerted
    And the ticket should be highlighted in the dashboard

  @sla @breach-handling
  Scenario: Handle SLA breach
    Given a ticket that has breached its response SLA
    When the breach is detected
    Then the ticket should be marked as "SLA breached"
    And automatically escalated to supervisor
    And the breach should be logged for reporting
    And a domain event "SLABreached" should be published

  @sla @pause-resume
  Scenario: Pause SLA timer while awaiting customer
    Given a ticket with active SLA timer
    When the status changes to "pending_customer"
    Then the SLA timer should pause
    And the pause should be recorded
    When the customer responds
    Then the SLA timer should resume
    And remaining time should be calculated correctly

  @sla @customer-tier
  Scenario: Apply different SLA based on customer tier
    Given the following customer tiers:
      | tier      | first_response_multiplier | resolution_multiplier |
      | platinum  | 0.25                      | 0.25                  |
      | gold      | 0.5                       | 0.5                   |
      | silver    | 0.75                      | 0.75                  |
      | standard  | 1.0                       | 1.0                   |
    When a platinum customer creates a medium priority ticket
    Then the first response SLA should be 1 hour (not 4 hours)
    And the resolution SLA should be 6 hours (not 24 hours)

  # =============================================================================
  # ESCALATION SCENARIOS
  # =============================================================================

  @escalation @automatic
  Scenario: Automatically escalate unresponsive tickets
    Given a ticket without response for 2 hours
    And the escalation rule: "escalate after 2 hours of inactivity"
    When the escalation check runs
    Then the ticket should be escalated to level 2
    And the supervisor should be notified
    And escalation reason should be "agent_inactivity"

  @escalation @customer-request
  Scenario: Escalate ticket upon customer request
    Given an open ticket "TKT-7001"
    And the customer requests to speak with a manager
    When the escalation is processed
    Then the ticket should be escalated
    And a manager should be assigned
    And the original agent should be notified
    And a domain event "TicketEscalated" should be published

  @escalation @severity
  Scenario: Escalate based on issue severity detection
    Given a ticket with content indicating:
      | indicator              | detected |
      | legal_threat           | true     |
      | data_breach_mention    | true     |
      | executive_mentioned    | false    |
    When the AI severity analyzer runs
    Then the ticket should be flagged as critical
    And escalated to legal/compliance team
    And executive notification should be sent

  @escalation @multi-level
  Scenario: Progress through escalation levels
    Given a ticket at escalation level 1
    And the issue remains unresolved for 24 hours
    When the escalation timer triggers
    Then the ticket should move to level 2
    And if still unresolved after 48 hours, move to level 3
    And each level should have different response requirements

  # =============================================================================
  # CUSTOMER COMMUNICATION SCENARIOS
  # =============================================================================

  @communication @response-templates
  Scenario: Use response templates with personalization
    Given the following response template:
      | template_id | name              | content                        |
      | TPL-001     | initial_response  | Hi {{customer_name}}, thank... |
    When an agent uses template TPL-001 for customer "John Smith"
    Then the response should be personalized:
      """
      Hi John, thank you for contacting us...
      """
    And the template usage should be tracked

  @communication @multi-language
  Scenario: Detect and respond in customer's language
    Given a ticket received in Spanish:
      | content | No puedo acceder a mi cuenta |
    When the language is detected
    Then the ticket should be tagged with "language:es"
    And routed to a Spanish-speaking agent
    And translation tools should be offered if needed

  @communication @canned-responses
  Scenario: Suggest relevant canned responses
    Given a ticket about "password reset"
    When an agent opens the ticket
    Then the system should suggest relevant responses:
      | response_type      | relevance_score |
      | password_reset_url | 0.95            |
      | account_recovery   | 0.85            |
      | security_tips      | 0.70            |

  @communication @follow-up
  Scenario: Schedule automated follow-up
    Given a resolved ticket "TKT-8001"
    When I schedule a follow-up for 3 days later
    Then a reminder should be created
    And if no response after 3 days, send follow-up email
    And track the follow-up engagement

  @communication @satisfaction-survey
  Scenario: Send satisfaction survey after resolution
    Given a ticket marked as resolved
    And customer survey is enabled
    When the 24-hour waiting period passes
    Then a satisfaction survey should be sent
    And the survey should include CSAT and NPS questions
    And responses should be linked to the ticket

  # =============================================================================
  # MULTI-CHANNEL SUPPORT SCENARIOS
  # =============================================================================

  @multi-channel @unified-view
  Scenario: View unified customer interaction history
    Given a customer with interactions across channels:
      | channel | date       | type         |
      | email   | 2024-01-10 | ticket       |
      | chat    | 2024-01-15 | conversation |
      | phone   | 2024-01-20 | call         |
    When an agent views the customer profile
    Then all interactions should be displayed chronologically
    And each interaction should show full context
    And the agent should see customer sentiment trend

  @multi-channel @channel-switching
  Scenario: Continue conversation across channels
    Given an ongoing chat conversation about ticket TKT-9001
    And the customer says "I need to continue this via email"
    When the channel switch is initiated
    Then the conversation context should transfer to email
    And the customer should receive an email summary
    And the ticket should track both channel interactions

  @multi-channel @omnichannel-routing
  Scenario: Route to the same agent across channels
    Given a customer with active ticket assigned to AGT-030
    When the customer starts a new chat
    Then the chat should be routed to AGT-030 if available
    And the customer should be informed about agent availability
    And context from the existing ticket should be shown

  # =============================================================================
  # KNOWLEDGE BASE INTEGRATION SCENARIOS
  # =============================================================================

  @knowledge-base @article-suggestion
  Scenario: Suggest relevant KB articles for ticket
    Given a ticket about "how to export data"
    When the AI analyzes the ticket content
    Then relevant knowledge base articles should be suggested:
      | article_id | title                    | relevance |
      | KB-201     | Data Export Guide        | 0.95      |
      | KB-205     | Export Formats Supported | 0.88      |
      | KB-210     | Bulk Data Operations     | 0.75      |

  @knowledge-base @article-linking
  Scenario: Link KB article to ticket resolution
    Given an agent resolves a ticket using KB article KB-201
    When the resolution is saved
    Then the article should be linked to the ticket
    And the article effectiveness should be tracked
    And the article view count should increment

  @knowledge-base @gap-detection
  Scenario: Detect knowledge base gaps
    Given 50 tickets about "API rate limiting"
    And no existing KB article on this topic
    When the gap analysis runs
    Then a suggestion should be created:
      | topic               | ticket_count | priority |
      | API rate limiting   | 50           | high     |
    And content team should be notified

  @knowledge-base @article-feedback
  Scenario: Collect feedback on KB article usefulness
    Given a customer views KB article KB-201
    When they provide feedback:
      | helpful | no                          |
      | comment | Outdated screenshots        |
    Then the feedback should be recorded
    And the article should be flagged for review
    And the author should be notified

  # =============================================================================
  # AUTOMATED RESPONSE SCENARIOS
  # =============================================================================

  @automation @auto-response
  Scenario: Send automated initial response
    Given a new ticket received outside business hours
    And auto-response is enabled
    When the ticket is created
    Then an automated response should be sent:
      """
      Thank you for contacting us. We have received your request
      and will respond within our SLA timeframe...
      """
    And the ticket should remain in "new" status

  @automation @chatbot-handoff
  Scenario: Handle chatbot to human agent handoff
    Given a chatbot conversation that cannot be resolved
    And the customer requests human assistance
    When the handoff is initiated
    Then a ticket should be created with:
      | chatbot_transcript | included     |
      | attempted_intents  | listed       |
      | handoff_reason     | user_request |
    And an available agent should be notified immediately

  @automation @ai-response-draft
  Scenario: Generate AI-drafted response for agent review
    Given a ticket about billing discrepancy
    And AI response assistance is enabled
    When an agent opens the ticket
    Then an AI-drafted response should be suggested
    And the agent should be able to edit before sending
    And the AI confidence score should be displayed

  @automation @auto-categorization
  Scenario: Automatically categorize incoming tickets
    Given a new ticket with content mentioning "refund request"
    When the AI categorizer processes the ticket
    Then the ticket should be categorized as:
      | category    | billing           |
      | subcategory | refund_request    |
      | confidence  | 0.92              |
    And routed to the billing team

  @automation @sentiment-analysis
  Scenario: Analyze and track customer sentiment
    Given a ticket with angry customer language
    When sentiment analysis runs
    Then the ticket should be tagged:
      | sentiment      | negative |
      | urgency        | high     |
      | emotion        | anger    |
    And priority should be adjusted accordingly
    And agent should see sentiment indicator

  # =============================================================================
  # QUALITY ASSURANCE SCENARIOS
  # =============================================================================

  @qa @ticket-review
  Scenario: Submit ticket for quality review
    Given a resolved ticket "TKT-1001"
    When a QA reviewer evaluates the ticket
    Then they should score the following criteria:
      | criterion           | score | max_score |
      | response_quality    | 4     | 5         |
      | resolution_accuracy | 5     | 5         |
      | communication_tone  | 4     | 5         |
      | process_compliance  | 5     | 5         |
    And the overall score should be calculated
    And feedback should be shared with the agent

  @qa @random-sampling
  Scenario: Automatically select tickets for QA review
    Given 1000 resolved tickets from this week
    And a QA sampling rate of 5%
    When the sampling algorithm runs
    Then 50 tickets should be selected for review
    And selection should be weighted by:
      | factor           | weight |
      | escalated        | 2.0    |
      | negative_csat    | 1.5    |
      | new_agent        | 1.3    |
      | random           | 1.0    |

  @qa @coaching
  Scenario: Generate coaching recommendations from QA data
    Given an agent with QA scores:
      | criterion           | avg_score | benchmark |
      | response_quality    | 3.5       | 4.0       |
      | resolution_accuracy | 4.5       | 4.0       |
    When the coaching analyzer runs
    Then recommendations should be generated:
      | area                | priority | suggested_training    |
      | response_quality    | high     | Writing Skills 101    |

  # =============================================================================
  # ANALYTICS SCENARIOS
  # =============================================================================

  @analytics @reporting
  Scenario: Generate support performance report
    Given data for the past month
    When I generate the monthly performance report
    Then the report should include:
      | section                  | metrics_count |
      | ticket_volume            | 5             |
      | resolution_times         | 4             |
      | customer_satisfaction    | 3             |
      | agent_performance        | 6             |
      | channel_distribution     | 5             |
    And the report should be exportable in PDF and Excel

  @analytics @trend-analysis
  Scenario: Identify trending support issues
    Given ticket data for the past 30 days
    When the trend analyzer runs
    Then trending issues should be identified:
      | topic              | ticket_count | change_pct | trend     |
      | login_issues       | 245          | +150%      | spike     |
      | mobile_app_crash   | 120          | +80%       | rising    |
      | payment_failures   | 50           | -20%       | declining |

  @analytics @agent-metrics
  Scenario: Track individual agent performance
    Given an agent's ticket history for this month
    When I view the agent performance dashboard
    Then I should see:
      | metric                    | value | rank     |
      | tickets_resolved          | 245   | top 10%  |
      | avg_resolution_time       | 4.2h  | top 25%  |
      | customer_satisfaction     | 4.6   | top 5%   |
      | first_contact_resolution  | 78%   | top 15%  |

  @analytics @forecasting
  Scenario: Forecast ticket volume
    Given historical ticket data for 12 months
    When I request a volume forecast for next month
    Then predictions should include:
      | metric          | predicted | confidence |
      | total_tickets   | 5200      | 85%        |
      | peak_hours      | 9-11 AM   | 90%        |
      | peak_days       | Mon, Tue  | 88%        |
    And staffing recommendations should be provided

  # =============================================================================
  # AGENT MANAGEMENT SCENARIOS
  # =============================================================================

  @agent-management @scheduling
  Scenario: Create agent shift schedule
    Given the following agents:
      | agent_id | skills                | availability |
      | AGT-101  | billing, technical    | flexible     |
      | AGT-102  | technical             | morning      |
      | AGT-103  | billing               | afternoon    |
    When I create the weekly schedule
    Then shifts should be assigned covering:
      | time_slot     | minimum_agents | skill_coverage |
      | 9AM-1PM       | 5              | all_categories |
      | 1PM-5PM       | 6              | all_categories |
      | 5PM-9PM       | 3              | high_priority  |

  @agent-management @capacity
  Scenario: Monitor and adjust agent capacity
    Given current queue status:
      | queue          | waiting | avg_wait_time |
      | billing        | 25      | 15m           |
      | technical      | 45      | 25m           |
    When capacity optimization runs
    Then recommendations should include:
      | action                        | impact        |
      | shift_2_agents_to_technical   | -10m_wait     |
      | enable_overflow_routing       | -5m_wait      |

  @agent-management @skills
  Scenario: Manage agent skill profiles
    Given agent AGT-110 completes "Advanced Billing" training
    When I update their skill profile
    Then the following should be updated:
      | skill           | level    |
      | billing_expert  | advanced |
    And the agent should receive relevant ticket types
    And routing rules should reflect new skills

  @agent-management @performance-alerts
  Scenario: Alert on agent performance issues
    Given agent performance thresholds:
      | metric              | warning | critical |
      | avg_handle_time     | 30m     | 45m      |
      | customer_satisfaction| 3.5     | 3.0      |
    When an agent falls below threshold
    Then the supervisor should be alerted
    And coaching should be recommended
    And the alert should include context

  # =============================================================================
  # INTEGRATION SCENARIOS
  # =============================================================================

  @integration @crm
  Scenario: Sync ticket data with CRM
    Given a ticket for customer with CRM ID "CRM-50001"
    When the ticket is resolved
    Then the following should sync to CRM:
      | field            | value              |
      | interaction_type | support_ticket     |
      | resolution       | issue_resolved     |
      | satisfaction     | 4/5                |
    And customer timeline should be updated

  @integration @billing-system
  Scenario: Process refund request through billing integration
    Given a ticket requesting refund of $50
    And the request is approved by agent
    When the refund is initiated
    Then the billing system should receive:
      | customer_id | amount | reason          | ticket_id |
      | CUST-001    | 50.00  | service_issue   | TKT-1234  |
    And the ticket should track refund status

  @integration @monitoring
  Scenario: Create ticket from system alert
    Given a system monitoring alert:
      | alert_type   | service_degradation   |
      | severity     | high                  |
      | affected     | payment_processing    |
    When the integration processes the alert
    Then a ticket should be auto-created
    And linked to affected customer tickets
    And engineering team should be notified

  @integration @slack-notification
  Scenario: Send ticket notifications to Slack
    Given Slack integration is configured for channel #support-alerts
    When a critical ticket is created
    Then a notification should be posted:
      | channel          | #support-alerts           |
      | message          | Critical ticket TKT-XXX   |
      | action_buttons   | View, Claim, Escalate     |

  # =============================================================================
  # SELF-SERVICE SCENARIOS
  # =============================================================================

  @self-service @portal
  Scenario: Customer views their ticket history
    Given a customer logged into the self-service portal
    When they view their ticket history
    Then they should see all their tickets:
      | ticket_id | subject          | status   | last_update |
      | TKT-001   | Login issue      | resolved | 2024-01-15  |
      | TKT-002   | Billing question | open     | 2024-01-18  |
    And they should be able to add updates to open tickets

  @self-service @ticket-deflection
  Scenario: Deflect ticket with self-service solution
    Given a customer attempting to create a ticket about "password reset"
    When they enter the subject
    Then relevant self-service options should appear:
      | option                  | type       |
      | Reset password now      | action     |
      | Password reset guide    | kb_article |
      | Two-factor auth help    | kb_article |
    And if self-resolved, no ticket should be created

  @self-service @status-tracking
  Scenario: Customer tracks ticket status
    Given an open ticket "TKT-3001" for a customer
    When the customer checks the status
    Then they should see:
      | field              | value                    |
      | current_status     | In Progress              |
      | assigned_to        | Support Agent            |
      | expected_response  | Within 4 hours           |
      | last_activity      | Agent is investigating   |

  # =============================================================================
  # FEEDBACK SCENARIOS
  # =============================================================================

  @feedback @csat-collection
  Scenario: Collect CSAT score after resolution
    Given a resolved ticket with customer email
    When the customer clicks the rating in the survey
    Then the rating should be recorded:
      | ticket_id | rating | response_time |
      | TKT-4001  | 5      | 2 hours       |
    And the agent should be credited
    And a domain event "CSATReceived" should be published

  @feedback @nps-survey
  Scenario: Conduct periodic NPS survey
    Given customers who had tickets resolved in the past 90 days
    When the NPS survey is triggered
    Then selected customers should receive:
      | question_type | question                              |
      | nps           | How likely are you to recommend us?   |
      | followup      | What could we improve?                |
    And responses should be aggregated for reporting

  @feedback @escalation-feedback
  Scenario: Collect feedback after escalation resolution
    Given an escalated ticket that was resolved
    When the post-escalation survey is sent
    Then it should include specific questions:
      | question                                    |
      | Was your issue resolved to your satisfaction? |
      | How was your experience with the supervisor?  |
      | Would you have preferred a faster resolution? |

  # =============================================================================
  # ERROR SCENARIOS
  # =============================================================================

  @error @assignment-failure
  Scenario: Handle ticket assignment failure
    Given no agents are available for the required skill
    When a ticket needs assignment
    Then the ticket should remain in queue
    And a notification should be sent to supervisors
    And the ticket should show "awaiting_agent" status
    And a domain event "AssignmentFailed" should be published

  @error @sla-calculation-error
  Scenario: Handle SLA calculation error gracefully
    Given a ticket with corrupted timestamp data
    When the SLA calculator runs
    Then the error should be logged
    And the ticket should be flagged for manual review
    And a default SLA should be applied temporarily
    And support team should be notified

  @error @integration-failure
  Scenario: Handle CRM integration failure
    Given a ticket resolution needs to sync to CRM
    And the CRM service is unavailable
    When the sync is attempted
    Then the sync should be queued for retry
    And the ticket should not be blocked
    And the failure should be logged
    And retry should occur with exponential backoff

  @error @email-delivery-failure
  Scenario: Handle customer notification failure
    Given a ticket update needs to be emailed
    And the email service returns an error
    When the notification fails
    Then the failure should be recorded
    And an alternative notification should be attempted
    And the ticket should show "notification_pending"

  @error @duplicate-submission
  Scenario: Handle rapid duplicate ticket submissions
    Given a customer submits the same ticket 3 times in 1 minute
    When the duplicates are detected
    Then only one ticket should be created
    And the customer should receive one acknowledgment
    And the duplicate attempts should be logged

  @error @attachment-processing
  Scenario: Handle corrupted attachment
    Given a ticket with an attachment that cannot be processed
    When the attachment processing fails
    Then the ticket should still be created
    And the attachment should be marked as "processing_failed"
    And the agent should be notified of the issue
    And the customer should be asked to resend if critical

  @error @rate-limiting
  Scenario: Handle API rate limit exceeded
    Given a customer makes 100 API requests in 1 minute
    When the rate limit is exceeded
    Then further requests should be rejected with 429 status
    And the customer should see a friendly error message
    And normal access should resume after cooldown period

  @error @data-validation
  Scenario: Handle invalid ticket data
    Given a ticket submission with invalid data:
      | field         | value              | error              |
      | email         | not-an-email       | invalid_format     |
      | subject       | (empty)            | required_field     |
    When validation runs
    Then specific error messages should be returned
    And the ticket should not be created
    And the user should see how to correct errors

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events
  Scenario: Publish domain events for ticket lifecycle
    Given the event bus is configured
    When ticket lifecycle events occur
    Then the following events should be published:
      | event_type           | payload_includes              |
      | TicketCreated        | ticket_id, channel, priority  |
      | TicketAssigned       | ticket_id, agent_id           |
      | TicketUpdated        | ticket_id, changes            |
      | TicketEscalated      | ticket_id, level, reason      |
      | TicketResolved       | ticket_id, resolution_type    |
      | TicketClosed         | ticket_id, duration           |
      | SLABreached          | ticket_id, sla_type           |
      | CSATReceived         | ticket_id, score              |
