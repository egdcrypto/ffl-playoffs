@world @moderation @safety @content
Feature: World Owner Moderation
  As a world owner
  I want comprehensive moderation tools
  So that I can maintain a safe and positive environment

  Background:
    Given I am logged in as the owner of "Epic Fantasy Realm"
    And I have moderation permissions
    And my world has active players and content
    And the moderation service is operational

  # ===========================================================================
  # MODERATION DASHBOARD
  # ===========================================================================

  @api @moderation @dashboard
  Scenario: View moderation overview
    Given my world has pending moderation items
    When I navigate to the moderation dashboard
    Then I should see a response with status 200
    And the dashboard should display:
      | metric                    | description                      |
      | pending_reports           | Number of unreviewed reports     |
      | active_bans               | Currently banned players         |
      | flagged_content           | Content awaiting review          |
      | active_mutes              | Currently muted players          |
      | appeals_pending           | Ban appeals awaiting decision    |
    And I should see moderation activity timeline for last 7 days
    And I should see team member online status
    And dashboard should refresh automatically every 30 seconds

  @api @moderation @dashboard
  Scenario: View moderation queue priorities
    Given there are reports with different severities:
      | report_id | severity | category        | time_since_report |
      | RPT-001   | high     | harassment      | 2 hours           |
      | RPT-002   | low      | spam            | 30 minutes        |
      | RPT-003   | critical | threats         | 1 hour            |
      | RPT-004   | medium   | inappropriate   | 4 hours           |
    When I view the moderation queue
    Then reports should be sorted by severity then age
    And critical report RPT-003 should appear first
    And high severity report RPT-001 should appear second
    And I should see time since report was filed for each
    And I should see report category indicators with color coding
    And reports older than 24 hours should be highlighted in red

  @api @moderation @dashboard
  Scenario: Filter moderation queue by category
    Given there are various types of reports pending
    When I filter the queue by category "harassment"
    Then I should only see harassment-related reports
    And the filter should be applied instantly
    And I should see count of filtered vs total reports
    And I should be able to clear filter easily

  @api @moderation @dashboard
  Scenario: View moderation workload distribution
    Given I have multiple moderators on my team
    When I view workload distribution
    Then I should see reports assigned per moderator
    And I should see resolution rate per moderator
    And I should see average response time per moderator
    And I should be able to rebalance assignments

  # ===========================================================================
  # PLAYER REPORTS
  # ===========================================================================

  @api @moderation @reports
  Scenario: Review player reports queue
    Given players have submitted 15 reports
    When I view the reports queue
    Then I should see all pending reports
    And each report should display:
      | field            | description                        |
      | reporter         | Player who submitted the report    |
      | reported_player  | Player being reported              |
      | reason           | Category of violation              |
      | description      | Detailed description from reporter |
      | timestamp        | When report was submitted          |
      | evidence_count   | Number of attachments              |
    And I should be able to sort by date, severity, or category
    And I should be able to filter by report status

  @api @moderation @reports
  Scenario: Investigate report details
    Given a report exists for player "ToxicPlayer123"
    And the report is for harassment
    When I open the report details
    Then I should see complete report information:
      | field              | value                           |
      | report_id          | RPT-12345                       |
      | reporter           | VictimPlayer                    |
      | reported           | ToxicPlayer123                  |
      | category           | harassment                      |
      | severity           | high                            |
      | description        | (full text)                     |
    And I should see reported player's history:
      | metric               | value    |
      | account_age          | 45 days  |
      | previous_warnings    | 2        |
      | previous_bans        | 1        |
      | total_reports        | 5        |
    And I should see evidence attached to report
    And I should see chat logs 30 minutes before and after incident
    And I should see player's recent activity

  @api @moderation @reports
  Scenario: View evidence attached to report
    Given a report has multiple pieces of evidence
    When I view the report evidence
    Then I should see:
      | evidence_type  | count | preview_available |
      | screenshots    | 3     | yes               |
      | chat_logs      | 1     | yes               |
      | video_clips    | 1     | yes               |
    And I should be able to view each piece in detail
    And evidence should be timestamped
    And evidence should be tamper-proof

  @api @moderation @reports
  Scenario: Bulk process similar reports
    Given multiple reports exist for the same incident:
      | report_id | reporter      | incident_id |
      | RPT-001   | Player1       | INC-100     |
      | RPT-002   | Player2       | INC-100     |
      | RPT-003   | Player3       | INC-100     |
    When I select all related reports
    And I process them as a batch with action "verified - ban applied"
    Then all selected reports should be marked as resolved
    And single moderation action should apply to offender
    And all reporters should be notified of resolution
    And a BulkReportsProcessed event should be published

  @api @moderation @reports
  Scenario: Dismiss invalid report
    Given a report is determined to be invalid or false
    When I dismiss the report with reason "False report - no violation found"
    Then the report should be marked as dismissed
    And the reported player should not be penalized
    And the reporter should be notified of dismissal
    And if reporter has pattern of false reports, they should be flagged

  @api @moderation @reports
  Scenario: Request additional information from reporter
    Given a report lacks sufficient detail
    When I request more information from the reporter
    Then the reporter should receive notification
    And the report should be marked as "pending_info"
    And I should set a deadline for response
    And if no response, report can be auto-closed

  # ===========================================================================
  # MODERATION ACTIONS
  # ===========================================================================

  @api @moderation @actions
  Scenario: Apply warning to player
    Given I am reviewing a valid report for minor violation
    When I apply moderation action:
      | action_type     | warning                    |
      | reason          | Minor language violation   |
      | notify_player   | true                       |
      | add_to_record   | true                       |
    Then the warning should be recorded
    And player should receive in-game notification
    And player should receive email notification if configured
    And warning should appear in player's moderation history
    And a ModerationActionApplied event should be published

  @api @moderation @actions
  Scenario: Apply temporary mute to player
    Given a player is disrupting chat
    When I apply moderation action:
      | action_type     | mute           |
      | duration        | 1_hour         |
      | reason          | Spam in chat   |
      | notify_player   | true           |
      | scope           | all_channels   |
    Then the mute should be applied immediately
    And player should be unable to send messages
    And player should see mute notification with duration
    And mute should automatically expire after 1 hour
    And a PlayerMuted event should be published

  @api @moderation @actions
  Scenario: Kick player from world
    Given a player needs immediate removal
    When I apply kick action:
      | action_type     | kick                      |
      | reason          | Disruptive behavior       |
      | notify_player   | true                      |
      | cooldown        | 30_minutes                |
    Then player should be disconnected immediately
    And player should see kick reason
    And player should not be able to rejoin for 30 minutes
    And a PlayerKicked event should be published

  @api @moderation @actions
  Scenario: Apply temporary ban
    Given I am reviewing a serious violation
    When I apply moderation action:
      | action_type     | temporary_ban  |
      | duration        | 7_days         |
      | reason          | Harassment     |
      | notify_player   | true           |
      | appealable      | true           |
    Then the ban should be applied immediately
    And player should be disconnected
    And player should receive ban notification via email
    And ban should appear in banned players list
    And ban should automatically expire after 7 days
    And a PlayerBanned event should be published

  @api @moderation @actions
  Scenario: Apply permanent ban
    Given a player has committed severe or repeated violations
    When I apply moderation action:
      | action_type     | permanent_ban              |
      | reason          | Severe harassment/threats  |
      | notify_player   | true                       |
      | appealable      | true                       |
      | appeal_delay    | 30_days                    |
    Then the permanent ban should be applied
    And player should be disconnected
    And player should receive detailed ban notification
    And player should be unable to create new accounts (if detectable)
    And ban should not have expiration date
    And a PermanentBanApplied event should be published

  @api @moderation @actions
  Scenario Outline: Apply different moderation actions with durations
    Given a player has violated rules
    When I apply <action> for <duration>
    Then the action should take effect immediately
    And player should receive notification with:
      | field      | value      |
      | action     | <action>   |
      | duration   | <duration> |
      | reason     | (provided) |
    And action should be logged in moderation history

    Examples:
      | action          | duration    |
      | warning         | n/a         |
      | mute            | 1_hour      |
      | mute            | 24_hours    |
      | kick            | immediate   |
      | temporary_ban   | 1_day       |
      | temporary_ban   | 7_days      |
      | temporary_ban   | 30_days     |
      | permanent_ban   | indefinite  |

  @api @moderation @actions
  Scenario: Escalate severe violation to platform
    Given a player has committed severe violation requiring platform intervention
    And violation involves:
      | type                    |
      | real_world_threats      |
      | illegal_content         |
      | coordinated_harassment  |
    When I escalate to platform administrators
    Then escalation should be submitted with all evidence
    And platform team should be notified immediately
    And I should receive case reference number
    And I should be able to track escalation status
    And local temporary action should still be applicable
    And a ViolationEscalated event should be published

  @api @moderation @actions
  Scenario: Undo recent moderation action
    Given I applied a warning to "Player123" 5 minutes ago
    And I realize the action was incorrect
    When I undo the moderation action
    Then the warning should be removed from player's record
    And player should be notified of reversal
    And undo should be logged with reason
    And original action should be marked as reversed

  @api @moderation @actions
  Scenario: Schedule moderation action
    Given I want to apply action during off-peak hours
    When I schedule moderation action:
      | action_type     | temporary_ban  |
      | scheduled_time  | 2024-12-31T03:00:00Z |
      | duration        | 24_hours       |
      | reason          | Repeated violations |
    Then action should be scheduled
    And I should see pending scheduled actions
    And action should execute at scheduled time
    And I should be able to cancel before execution

  # ===========================================================================
  # LIVE CHAT MONITORING
  # ===========================================================================

  @api @moderation @chat
  Scenario: Monitor live chat in real-time
    Given players are actively chatting in my world
    When I open live chat monitor
    Then I should see real-time chat messages as they appear
    And messages should include:
      | field       | description                    |
      | sender      | Player name                    |
      | channel     | Chat channel name              |
      | message     | Message content                |
      | timestamp   | When message was sent          |
      | flags       | Any automatic flags applied    |
    And flagged messages should be highlighted in red
    And I should be able to filter by channel
    And I should see typing indicators

  @api @moderation @chat
  Scenario: Take quick action on chat message
    Given I see a problematic message in chat from "BadActor"
    When I click on the message
    Then I should see quick action menu:
      | action        | description                    |
      | delete        | Remove message from chat       |
      | warn          | Send warning to sender         |
      | mute_1h       | Mute sender for 1 hour         |
      | mute_24h      | Mute sender for 24 hours       |
      | kick          | Kick sender from world         |
      | view_profile  | View sender's full profile     |
    When I select "delete" and "warn"
    Then message should be removed from chat
    And sender should receive warning notification
    And actions should be logged
    And a ChatMessageModerated event should be published

  @api @moderation @chat
  Scenario: View chat history for specific player
    Given I am investigating player "SuspiciousUser"
    When I view their chat history
    Then I should see their messages from last 30 days:
      | timestamp           | channel    | message        | status   |
      | 2024-12-28 10:00    | general    | Hello everyone | normal   |
      | 2024-12-28 10:05    | general    | [deleted]      | deleted  |
      | 2024-12-28 10:10    | private    | (content)      | flagged  |
    And I should see which messages were deleted
    And I should see previous warnings issued
    And I should be able to search within history
    And I should be able to export chat history

  @api @moderation @chat
  Scenario: Monitor private messages when warranted
    Given I have received reports about private message abuse
    And I have proper authorization to review private messages
    When I access private message logs for investigation
    Then I should see messages relevant to the report
    And access should be logged for audit
    And I should only see messages from reported incident timeframe
    And a PrivateMessageAccessLogged event should be published

  @api @moderation @chat
  Scenario: Create chat channel restrictions
    Given a chat channel is experiencing issues
    When I apply channel restrictions:
      | restriction      | value       |
      | slow_mode        | 30_seconds  |
      | verified_only    | true        |
      | min_account_age  | 7_days      |
    Then restrictions should apply immediately
    And players should see restriction notices
    And restrictions should be removable

  # ===========================================================================
  # CHAT FILTERS
  # ===========================================================================

  @api @moderation @filters
  Scenario: Configure chat filter rules
    Given I want to set up automated chat filtering
    When I configure chat filter rules:
      | filter_type    | action      | configuration              |
      | profanity      | block       | built_in_list + custom     |
      | spam           | rate_limit  | max 3 identical in 1 min   |
      | advertising    | flag        | urls and promotions        |
      | threats        | block+alert | threat keywords            |
    Then filters should be activated immediately
    And filter matches should be logged
    And I should see filter effectiveness metrics
    And a ChatFiltersConfigured event should be published

  @api @moderation @filters
  Scenario: Add custom words to filter list
    Given I want to block world-specific terms
    When I add words to filter list:
      | word              | action   | match_type     |
      | competitor_name   | block    | exact          |
      | spoiler_word      | flag     | contains       |
      | offensive_slang   | block    | fuzzy          |
    Then words should be added to filter
    And filter should apply to new messages immediately
    And filter should detect common variations (l33t speak, spacing)
    And I should see word hit statistics

  @api @moderation @filters
  Scenario: Configure filter sensitivity levels
    Given different content types need different sensitivity
    When I adjust filter sensitivity:
      | category      | level    | false_positive_tolerance |
      | profanity     | strict   | low                      |
      | spam          | moderate | medium                   |
      | threats       | strict   | very_low                 |
      | advertising   | lenient  | high                     |
    Then sensitivity should be updated
    And I should see estimated impact on message filtering
    And I should see projected false positive rates

  @api @moderation @filters
  Scenario: Test filter configuration
    Given I have configured chat filters
    When I test with sample messages:
      | message                     | expected_result |
      | Hello everyone!             | pass            |
      | Buy cheap gold at xyz.com   | flag            |
      | You are a f***ing idiot     | block           |
    Then I should see how each message would be handled
    And I should see which rules triggered
    And I can adjust rules based on test results

  @api @moderation @filters
  Scenario: Import filter list from template
    Given the platform provides filter templates
    When I import "gaming_community_standard" template
    Then template filters should be added
    And I should see what was imported
    And I should be able to customize imported filters
    And I should be able to merge with existing filters

  @api @moderation @filters
  Scenario: View filter analytics
    Given filters have been active for 30 days
    When I view filter analytics
    Then I should see:
      | metric                    | description                    |
      | messages_scanned          | Total messages processed       |
      | messages_blocked          | Messages prevented from posting|
      | messages_flagged          | Messages flagged for review    |
      | false_positives_reported  | User-reported false positives  |
      | top_triggered_rules       | Most frequently triggered      |
    And I should see trends over time
    And I should see recommendations for optimization

  # ===========================================================================
  # FLAGGED CONTENT
  # ===========================================================================

  @api @moderation @content
  Scenario: Review flagged content queue
    Given content has been flagged by system or users
    When I view flagged content queue
    Then I should see all flagged items:
      | content_id | type          | flag_reason      | flagged_by    | timestamp   |
      | CNT-001    | image         | inappropriate    | auto_filter   | 2 hours ago |
      | CNT-002    | text_post     | spam             | user_report   | 1 hour ago  |
      | CNT-003    | custom_item   | copyright        | user_report   | 30 min ago  |
    And I should see content preview for each
    And I should be able to approve or remove each item
    And I should be able to bulk process items

  @api @moderation @content
  Scenario: Review flagged user-generated content
    Given a player-created item has been flagged
    When I review the content "Offensive Banner"
    Then I should see:
      | field          | value                    |
      | content_name   | Offensive Banner         |
      | creator        | CreativePlayer           |
      | created_date   | 2024-12-28               |
      | flag_count     | 5                        |
      | flag_reasons   | inappropriate, offensive |
    And I should see the full content rendering
    And I should see flag history and reporters
    And I should be able to:
      | action    | description                        |
      | approve   | Mark as acceptable                 |
      | edit      | Modify content to be acceptable    |
      | remove    | Delete content from world          |
      | warn      | Remove and warn creator            |

  @api @moderation @content
  Scenario: Bulk approve safe content
    Given multiple items are flagged as false positives
    And I have reviewed and verified they are safe
    When I select 10 items and bulk approve
    Then all items should be unmarked as flagged
    And items should be visible in world again
    And filter rules should be noted for potential adjustment
    And a BulkContentApproved event should be published

  @api @moderation @content
  Scenario: Remove content and notify creator
    Given content "Inappropriate Image" violates guidelines
    When I remove the content with notification:
      | reason           | Violates community guidelines      |
      | guideline_ref    | Section 3.2 - Appropriate Content  |
      | warn_creator     | true                               |
    Then content should be removed from world
    And creator should receive notification with reason
    And removal should be logged
    And creator's content history should be updated

  @api @moderation @content
  Scenario: Content quarantine pending review
    Given new content is flagged but requires detailed review
    When I quarantine the content
    Then content should be hidden from public view
    And creator should be notified of pending review
    And content should remain in quarantine queue
    And I should have configurable quarantine duration

  # ===========================================================================
  # BANNED PLAYERS
  # ===========================================================================

  @api @moderation @bans
  Scenario: View banned players list
    Given my world has players who have been banned
    When I view banned players list
    Then I should see all currently banned players:
      | player_name   | ban_type      | reason           | start_date  | end_date    |
      | BannedUser1   | temporary     | Harassment       | 2024-12-20  | 2024-12-27  |
      | BannedUser2   | permanent     | Threats          | 2024-12-15  | never       |
      | BannedUser3   | temporary     | Cheating         | 2024-12-25  | 2025-01-01  |
    And I should be able to search banned players
    And I should be able to filter by ban type
    And I should see who issued each ban

  @api @moderation @bans
  Scenario: View ban details
    Given player "BannedUser" has an active ban
    When I view the ban details
    Then I should see:
      | field              | value                           |
      | player_name        | BannedUser                      |
      | player_id          | PLR-12345                       |
      | ban_type           | temporary                       |
      | duration           | 7 days                          |
      | reason             | Repeated harassment             |
      | issued_by          | ModeratorJane                   |
      | issued_date        | 2024-12-20 14:30:00             |
      | expires_date       | 2024-12-27 14:30:00             |
      | appeal_status      | pending                         |
    And I should see linked evidence and reports
    And I should see player's full moderation history

  @api @moderation @bans
  Scenario: Modify existing ban duration
    Given player "BannedUser" has active 7-day ban
    When I modify the ban:
      | field          | new_value                        |
      | duration       | extend by 7 days                 |
      | reason_update  | Additional evidence discovered   |
    Then ban end date should be extended by 7 days
    And player should be notified of change
    And modification should be logged with reason
    And a BanModified event should be published

  @api @moderation @bans
  Scenario: Convert temporary ban to permanent
    Given player has shown no improvement during temp ban
    When I convert to permanent ban with justification
    Then ban should be updated to permanent
    And player should be notified
    And all evidence should be preserved
    And conversion should be logged

  @api @moderation @bans
  Scenario: Lift ban early
    Given player "BannedUser" has 5 days remaining on ban
    And player has shown genuine remorse
    When I lift ban early with reason "Genuine apology and commitment to follow rules"
    Then ban should be removed immediately
    And player should be notified they can rejoin
    And early lift should be documented with reason
    And player should be on probation for 30 days
    And a BanLiftedEarly event should be published

  @api @moderation @bans
  Scenario: View ban expiration calendar
    Given multiple temporary bans are active
    When I view ban expiration calendar
    Then I should see upcoming ban expirations
    And I should see players returning per day
    And I should receive reminders before high-risk players return
    And I should be able to extend bans before expiration

  # ===========================================================================
  # BAN APPEALS
  # ===========================================================================

  @api @moderation @appeals
  Scenario: View ban appeals queue
    Given banned players have submitted appeals
    When I view the appeals queue
    Then I should see pending appeals:
      | appeal_id | player        | ban_type   | submitted    | status   |
      | APL-001   | BannedUser1   | permanent  | 2 days ago   | pending  |
      | APL-002   | BannedUser2   | temporary  | 1 day ago    | pending  |
    And appeals should be sorted by submission date
    And I should see appeal deadline if set

  @api @moderation @appeals
  Scenario: Review ban appeal details
    Given player "BannedUser" has submitted an appeal
    When I review the appeal
    Then I should see original ban details:
      | field          | value                    |
      | ban_date       | 2024-12-15               |
      | ban_type       | permanent                |
      | ban_reason     | Severe harassment        |
      | evidence_count | 5 items                  |
    And I should see player's appeal statement
    And I should see player's complete history
    And I should see any supporting evidence from player
    And I should see recommended action based on history

  @api @moderation @appeals
  Scenario: Approve ban appeal - full lift
    Given appeal has merit and player shows genuine change
    When I approve the appeal with full lift:
      | decision        | approved               |
      | action          | lift_ban               |
      | conditions      | 90_day_probation       |
      | reason          | Genuine remorse shown  |
    Then ban should be lifted immediately
    And player should be notified of approval
    And player should be placed on probation
    And probation conditions should be explained
    And a BanAppealApproved event should be published

  @api @moderation @appeals
  Scenario: Approve ban appeal - reduce sentence
    Given appeal has partial merit
    When I approve with reduced sentence:
      | decision        | partially_approved     |
      | action          | reduce_ban             |
      | new_duration    | 7_days_remaining       |
      | reason          | First offense, apology |
    Then ban should be reduced to 7 days
    And player should be notified of decision
    And original end date should be updated
    And a BanAppealPartiallyApproved event should be published

  @api @moderation @appeals
  Scenario: Deny ban appeal with explanation
    Given appeal lacks merit or player shows no remorse
    When I deny with detailed explanation:
      | decision        | denied                              |
      | reason          | No acknowledgment of wrongdoing     |
      | evidence_ref    | Original evidence still valid       |
      | re_appeal_wait  | 30_days                             |
    Then denial should be recorded
    And player should receive detailed explanation
    And player should see when they can re-appeal
    And a BanAppealDenied event should be published

  @api @moderation @appeals
  Scenario: Request more information for appeal
    Given appeal needs clarification
    When I request more information:
      | questions                                    |
      | Please explain what led to your behavior    |
      | What will you do differently going forward  |
    Then request should be sent to player
    And appeal should be marked as "awaiting_response"
    And response deadline should be set (7 days)
    And if no response, appeal can be auto-denied

  @api @moderation @appeals
  Scenario: Escalate appeal decision
    Given I am unsure about appeal decision
    When I escalate to senior moderator or platform
    Then appeal should be escalated
    And escalation reason should be recorded
    And higher authority should be notified
    And I should be able to track escalation status

  # ===========================================================================
  # AUTO-MODERATION
  # ===========================================================================

  @api @moderation @auto
  Scenario: Configure auto-moderation rules
    Given I want to automate common moderation tasks
    When I configure auto-moderation rules:
      | rule_id | trigger                | action        | threshold     |
      | AUTO-01 | profanity_detected     | auto_delete   | any           |
      | AUTO-02 | spam_pattern           | temp_mute     | 3_in_1min     |
      | AUTO-03 | reported_5_times       | flag_review   | 5_reports     |
      | AUTO-04 | threat_detected        | alert_mod     | any           |
      | AUTO-05 | new_account_spam       | shadow_mute   | 5_in_5min     |
    Then rules should be activated
    And auto-actions should be logged for review
    And I should receive summary notifications
    And an AutoModerationConfigured event should be published

  @api @moderation @auto
  Scenario: Review auto-moderation action log
    Given auto-moderation has taken actions over the past week
    When I review auto-action log
    Then I should see all automated actions:
      | timestamp           | rule_id | player        | action        | trigger_reason    |
      | 2024-12-28 10:00    | AUTO-01 | Player1       | auto_delete   | profanity         |
      | 2024-12-28 10:30    | AUTO-02 | SpamBot       | temp_mute     | 5 msgs in 30 sec  |
      | 2024-12-28 11:00    | AUTO-03 | ReportedUser  | flag_review   | 5 reports         |
    And I should be able to filter by rule or action type
    And I should be able to override any action
    And I should see auto-mod effectiveness metrics

  @api @moderation @auto
  Scenario: Handle auto-moderation false positive
    Given auto-moderation incorrectly muted "InnocentPlayer"
    And the trigger was a false positive on word filter
    When I mark the action as false positive:
      | action_id       | ACT-12345                    |
      | reason          | Word used in innocent context |
      | reverse_action  | true                          |
      | update_rule     | true                          |
    Then mute should be removed immediately
    And player should be notified of reversal with apology
    And rule should be flagged for tuning
    And similar false positives should be reviewed
    And a FalsePositiveMarked event should be published

  @api @moderation @auto
  Scenario: Tune auto-moderation based on performance
    Given auto-moderation has 15% false positive rate
    When I review and tune rules
    Then I should see rule performance metrics:
      | rule_id | true_positives | false_positives | accuracy |
      | AUTO-01 | 95             | 5               | 95%      |
      | AUTO-02 | 80             | 20              | 80%      |
    And I should be able to adjust thresholds
    And I should see projected impact of changes
    And changes should take effect immediately

  @api @moderation @auto
  Scenario: Set auto-moderation exceptions
    Given some trusted players should bypass auto-mod
    When I add exception rules:
      | exception_type   | criteria              |
      | trusted_players  | role = moderator      |
      | veteran_players  | account_age > 1_year  |
      | verified_players | verification = true   |
    Then excepted players should bypass auto-moderation
    And exceptions should be logged when triggered
    And I should be able to review exception usage

  # ===========================================================================
  # MODERATION TEAM
  # ===========================================================================

  @api @moderation @team
  Scenario: View moderation team
    Given I have a moderation team
    When I view moderation team roster
    Then I should see all team members:
      | name          | role              | status   | actions_today |
      | ModeratorJane | senior_moderator  | online   | 25            |
      | ModeratorJohn | moderator         | offline  | 0             |
      | ModeratorSam  | junior_moderator  | online   | 12            |
    And I should see their permission levels
    And I should see their activity metrics
    And I should see their availability schedule

  @api @moderation @team
  Scenario: Add new moderator to team
    Given I need more moderation coverage
    When I add moderator:
      | field        | value                |
      | email        | newmod@example.com   |
      | username     | NewModerator         |
      | role         | junior_moderator     |
      | permissions  | chat, reports        |
    Then invitation should be sent to email
    And moderator should appear as "pending_acceptance"
    And permissions should be configured
    And I should see invitation expiry date
    And a ModeratorInvited event should be published

  @api @moderation @team
  Scenario: Configure moderator permissions
    Given moderator "JuniorMod" needs permission update
    When I update their permissions:
      | permission         | granted |
      | view_reports       | true    |
      | resolve_reports    | true    |
      | apply_warnings     | true    |
      | apply_mutes        | true    |
      | apply_kicks        | false   |
      | apply_bans         | false   |
      | manage_filters     | false   |
      | view_private_msgs  | false   |
    Then permissions should be updated
    And moderator should see only permitted actions
    And permission changes should be logged

  @api @moderation @team
  Scenario: Review moderator performance
    Given moderator has been active for 30 days
    When I view their performance report
    Then I should see:
      | metric                    | value    |
      | reports_handled           | 150      |
      | average_response_time     | 2.5 hrs  |
      | actions_taken             | 120      |
      | appeals_overturned        | 3        |
      | overturn_rate             | 2.5%     |
      | player_feedback_positive  | 85%      |
    And I should see quality metrics
    And I should see comparison to team average
    And I should see recommendations

  @api @moderation @team
  Scenario: Remove moderator from team
    Given moderator "FormerMod" needs to be removed
    When I remove them from the team:
      | reason          | No longer available    |
      | reassign_cases  | true                   |
    Then moderator should be removed
    And their access should be revoked immediately
    And their pending cases should be reassigned
    And removal should be logged
    And a ModeratorRemoved event should be published

  @api @moderation @team
  Scenario: Set moderator schedules
    Given I want to ensure coverage across time zones
    When I configure moderator schedules:
      | moderator     | timezone    | hours              |
      | ModeratorJane | US_Eastern  | 9am-5pm            |
      | ModeratorJohn | EU_London   | 9am-5pm            |
      | ModeratorSam  | Asia_Tokyo  | 9am-5pm            |
    Then schedules should be saved
    And I should see coverage gaps highlighted
    And reports should be routed based on availability

  # ===========================================================================
  # EVIDENCE GATHERING
  # ===========================================================================

  @api @moderation @evidence
  Scenario: Gather evidence for case
    Given I am building a case against player "SerialOffender"
    When I gather evidence:
      | evidence_type   | date_range           | quantity |
      | chat_logs       | last_30_days         | all      |
      | screenshots     | attached_to_reports  | 5        |
      | player_reports  | all_time             | 12       |
      | action_history  | all_time             | 8        |
    Then evidence should be compiled into case file
    And case file should be timestamped
    And evidence should be immutable once gathered
    And case file should have unique reference number
    And an EvidenceGathered event should be published

  @api @moderation @evidence
  Scenario: Add notes to evidence
    Given I have a case file for investigation
    When I add moderator notes:
      | note                                              |
      | Pattern of escalating behavior observed           |
      | Player has been warned 3 times with no change     |
      | Recommend permanent ban based on evidence         |
    Then notes should be attached to case file
    And notes should be timestamped and attributed
    And notes should be visible to other moderators

  @api @moderation @evidence
  Scenario: Export evidence package
    Given I have compiled evidence for escalation
    When I export evidence package
    Then package should include:
      | component           | format    |
      | case_summary        | PDF       |
      | chat_logs           | JSON/CSV  |
      | screenshots         | PNG/JPG   |
      | moderator_notes     | PDF       |
      | timeline            | PDF       |
    And package should be in standard format
    And package should be suitable for platform escalation
    And package should be securely downloadable

  @api @moderation @evidence
  Scenario: Chain of custody for evidence
    Given evidence has been collected
    When evidence is accessed or modified
    Then all access should be logged:
      | timestamp           | action    | user          |
      | 2024-12-28 10:00    | viewed    | ModeratorJane |
      | 2024-12-28 10:05    | exported  | ModeratorJane |
    And evidence integrity should be verifiable
    And tampering should be detectable

  # ===========================================================================
  # REHABILITATION
  # ===========================================================================

  @api @moderation @rehabilitation
  Scenario: Create rehabilitation program for player
    Given player "ReformingPlayer" has repeated minor violations
    And player shows willingness to improve
    When I enroll them in rehabilitation program:
      | component            | duration    | details                    |
      | behavior_monitoring  | 30_days     | Extra scrutiny on actions  |
      | restricted_chat      | 7_days      | Limited to safe channels   |
      | mentorship_program   | optional    | Paired with helpful player |
      | community_service    | optional    | Help new players           |
    Then player should be enrolled in program
    And player should receive program details
    And progress tracking should begin
    And a RehabilitationStarted event should be published

  @api @moderation @rehabilitation
  Scenario: Track rehabilitation progress
    Given player is in rehabilitation program for 15 days
    When I check their progress
    Then I should see:
      | metric                    | value    |
      | days_completed            | 15       |
      | days_remaining            | 15       |
      | violations_during_period  | 0        |
      | positive_interactions     | 45       |
      | mentor_feedback           | positive |
      | compliance_score          | 95%      |
    And I should see daily behavior log
    And I should see mentor comments if assigned

  @api @moderation @rehabilitation
  Scenario: Complete rehabilitation successfully
    Given player has completed rehabilitation period
    And player had no violations during period
    When I mark rehabilitation as complete
    Then restrictions should be lifted
    And player should receive completion notice
    And player's record should note successful rehabilitation
    And a RehabilitationCompleted event should be published

  @api @moderation @rehabilitation
  Scenario: Handle rehabilitation failure
    Given player violates rules during rehabilitation
    When I record the violation
    Then rehabilitation should be marked as failed
    And original or enhanced penalty should apply
    And player should be notified
    And future rehabilitation eligibility should be reviewed
    And a RehabilitationFailed event should be published

  # ===========================================================================
  # MODERATION STATISTICS
  # ===========================================================================

  @api @moderation @stats
  Scenario: View moderation statistics dashboard
    Given I want to analyze moderation effectiveness
    When I view moderation analytics
    Then I should see:
      | metric                      | current_period | previous_period | trend  |
      | total_reports               | 450            | 380             | +18%   |
      | reports_resolved            | 425            | 360             | +18%   |
      | average_resolution_time     | 3.2 hours      | 4.5 hours       | -29%   |
      | player_satisfaction         | 85%            | 80%             | +5%    |
    And I should see violation type distribution pie chart
    And I should see action type distribution
    And I should see trend lines over time

  @api @moderation @stats
  Scenario: Analyze violation patterns
    Given I want to understand violation trends
    When I view violation analysis
    Then I should see peak violation times (hourly heatmap)
    And I should see violation hotspots (locations/channels)
    And I should see repeat offender statistics
    And I should see correlation with events or updates

  @api @moderation @stats
  Scenario: Generate monthly moderation report
    Given the month has ended
    When I generate monthly moderation report
    Then report should include:
      | section                      | content                         |
      | executive_summary            | Key metrics and highlights      |
      | report_statistics            | Reports received and resolved   |
      | action_breakdown             | Actions by type                 |
      | team_performance             | Individual moderator stats      |
      | trend_analysis               | Comparison to previous periods  |
      | recommendations              | Suggested improvements          |
    And report should be exportable as PDF
    And report should be shareable with stakeholders

  @api @moderation @stats
  Scenario: Track moderator efficiency metrics
    Given I want to optimize team performance
    When I view team efficiency report
    Then I should see:
      | moderator     | reports_per_hour | accuracy | response_time |
      | ModeratorJane | 8.5              | 97%      | 1.5 hrs       |
      | ModeratorJohn | 6.2              | 95%      | 2.0 hrs       |
      | ModeratorSam  | 7.0              | 92%      | 2.5 hrs       |
    And I should see workload distribution
    And I should see recommendations for balancing

  # ===========================================================================
  # CRISIS MANAGEMENT
  # ===========================================================================

  @api @moderation @crisis
  Scenario: Activate crisis mode during attack
    Given a coordinated harassment attack is occurring
    And multiple bad actors are flooding chat
    When I activate crisis mode
    Then enhanced moderation should activate:
      | measure                    | effect                        |
      | strict_chat_filters        | Maximum sensitivity           |
      | new_account_restrictions   | Cannot chat for 24 hours      |
      | enhanced_rate_limits       | Stricter spam prevention      |
      | all_moderators_alerted     | Emergency notification        |
    And additional filters should apply
    And I should be able to restrict new player access
    And platform support should be automatically notified
    And a CrisisModeActivated event should be published

  @api @moderation @crisis
  Scenario: Lock world during crisis
    Given situation requires immediate containment
    When I lock the world:
      | lock_type       | full                          |
      | reason          | Coordinated attack in progress|
      | duration        | until_manually_unlocked       |
    Then all players should be disconnected
    And new joins should be blocked
    And I should see lock confirmation
    And players should see maintenance message
    And I should be able to unlock when resolved
    And a WorldLocked event should be published

  @api @moderation @crisis
  Scenario: Gradual world unlock after crisis
    Given world was locked due to crisis
    And crisis has been resolved
    When I unlock the world gradually:
      | phase   | access_level           | duration   |
      | 1       | moderators_only        | 15 min     |
      | 2       | trusted_players        | 30 min     |
      | 3       | verified_players       | 1 hour     |
      | 4       | all_players            | indefinite |
    Then world should unlock in phases
    And I should monitor for recurring issues
    And full unlock should occur when stable

  @api @moderation @crisis
  Scenario: Post-crisis analysis
    Given crisis mode was active for 2 hours
    When I generate post-crisis report
    Then report should include:
      | section                | content                          |
      | timeline               | Minute-by-minute events          |
      | actors_identified      | Bad actors and their actions     |
      | actions_taken          | Moderation actions during crisis |
      | effectiveness          | What worked and what didn't      |
      | recommendations        | Prevention for future            |
    And report should be suitable for stakeholders
    And lessons learned should be documented

  # ===========================================================================
  # MODERATION POLICIES
  # ===========================================================================

  @api @moderation @policy
  Scenario: Define community guidelines
    Given I want to establish clear rules
    When I define community guidelines:
      | policy_area      | rules                                   |
      | language         | No profanity, harassment, or hate speech|
      | behavior         | Respect all players and staff           |
      | content          | Keep all content age-appropriate        |
      | cheating         | No exploits, hacks, or unfair advantages|
      | advertising      | No unsolicited promotions               |
    Then policies should be saved
    And policies should be published with version number
    And players should acknowledge on join
    And policies should be referenceable in actions

  @api @moderation @policy
  Scenario: Update moderation policies
    Given policies need updating for new situation
    When I update policies:
      | action          | details                              |
      | add_section     | New rules about streaming            |
      | modify_section  | Clarify harassment definition        |
      | version         | 2.1                                  |
    Then new policies should be published
    And existing players should be prompted to re-acknowledge
    And old policy versions should be archived
    And players can view policy change history
    And a PolicyUpdated event should be published

  @api @moderation @policy
  Scenario: Configure policy acknowledgment
    Given I want players to formally accept rules
    When I configure acknowledgment settings:
      | setting                  | value              |
      | require_on_first_join    | true               |
      | require_after_update     | true               |
      | block_until_accepted     | true               |
      | reminder_frequency       | every_30_days      |
    Then settings should be applied
    And non-acknowledging players should be restricted
    And acknowledgment status should be trackable

  @api @moderation @policy
  Scenario: Reference policy in moderation action
    Given I am applying a moderation action
    When I reference specific policy violation:
      | policy_section  | Section 3.2 - Harassment        |
      | specific_rule   | No targeted harassment of players|
      | action          | 7_day_ban                        |
    Then action notification should include policy reference
    And player should see which rule they violated
    And action should be linked to policy version

  # ===========================================================================
  # APPEAL PROCESS CONFIGURATION
  # ===========================================================================

  @api @moderation @appeals @config
  Scenario: Configure appeal process settings
    Given I want to define appeal rules
    When I configure appeal settings:
      | setting             | value       | description                     |
      | appeal_window       | 30_days     | Time to submit appeal           |
      | max_appeals         | 2           | Maximum appeals per ban         |
      | appeal_cooldown     | 14_days     | Wait time between appeals       |
      | auto_review_minor   | true        | Auto-approve minor ban appeals  |
      | require_statement   | true        | Require written appeal          |
    Then settings should be applied
    And players should see appeal options based on config
    And settings should affect all future bans
    And an AppealSettingsUpdated event should be published

  @api @moderation @appeals @config
  Scenario: Configure appeal escalation path
    Given appeals may need multiple levels of review
    When I configure escalation:
      | level   | reviewer              | auto_escalate_after |
      | 1       | moderator             | n/a                 |
      | 2       | senior_moderator      | 7_days              |
      | 3       | world_owner           | 14_days             |
      | 4       | platform_admin        | manual_only         |
    Then escalation path should be configured
    And appeals should auto-escalate if not resolved
    And escalation status should be visible

  # ===========================================================================
  # EXTERNAL INTEGRATION
  # ===========================================================================

  @api @moderation @integration
  Scenario: Integrate external moderation service
    Given I want to use AI-powered moderation
    When I configure external moderation service:
      | service          | purpose           | configuration         |
      | ai_content_mod   | image_scanning    | scan_all_uploads      |
      | toxicity_api     | chat_analysis     | real_time_scoring     |
      | age_verification | player_verification| for_mature_content   |
    Then integrations should be connected
    And external results should feed into moderation queue
    And I should see integration health status
    And an IntegrationConfigured event should be published

  @api @moderation @integration
  Scenario: Handle external service failure
    Given external moderation service is configured
    When service becomes unavailable
    Then I should receive alert about service failure
    And fallback to internal moderation should activate
    And content should be queued for later scanning
    And I should see service status in dashboard

  @api @moderation @integration
  Scenario: Review external moderation decisions
    Given external service has flagged content
    When I review external decisions
    Then I should see:
      | content_id | service      | confidence | decision   |
      | IMG-001    | ai_content   | 95%        | block      |
      | MSG-002    | toxicity_api | 75%        | flag       |
    And I should be able to override decisions
    And feedback should be sent to improve accuracy

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: ModerationActionApplied triggers notifications and logging
    Given a moderator applies action to a player
    When ModerationActionApplied event is published
    Then the event should contain:
      | field           | description                    |
      | action_id       | Unique action identifier       |
      | action_type     | warning/mute/kick/ban          |
      | player_id       | Affected player                |
      | moderator_id    | Who applied action             |
      | reason          | Reason for action              |
      | evidence_refs   | Linked evidence                |
    And affected player should be notified
    And action should be logged to player history
    And moderation analytics should be updated
    And if severe, platform may be notified

  @domain-events
  Scenario: CrisisModeActivated triggers platform alert
    Given crisis mode is activated in a world
    When CrisisModeActivated event is published
    Then the event should contain:
      | field           | description                    |
      | world_id        | Affected world                 |
      | activated_by    | Who activated crisis mode      |
      | reason          | Why crisis mode was activated  |
      | measures        | What measures are in effect    |
    And platform support should be alerted
    And enhanced logging should begin
    And additional resources may be allocated
    And other world owners should be notified if pattern detected

  @domain-events
  Scenario: BanAppealSubmitted triggers review workflow
    Given a banned player submits an appeal
    When BanAppealSubmitted event is published
    Then the event should contain:
      | field           | description                    |
      | appeal_id       | Unique appeal identifier       |
      | player_id       | Appealing player               |
      | ban_id          | Original ban reference         |
      | appeal_text     | Player's appeal statement      |
    And appeal should appear in moderation queue
    And appropriate moderator should be assigned
    And response deadline should be set
    And player should receive confirmation

  @domain-events
  Scenario: PlayerReportSubmitted triggers investigation
    Given a player reports another player
    When PlayerReportSubmitted event is published
    Then the event should contain:
      | field           | description                    |
      | report_id       | Unique report identifier       |
      | reporter_id     | Who submitted report           |
      | reported_id     | Who is being reported          |
      | category        | Type of violation              |
      | description     | Report details                 |
    And report should enter moderation queue
    And if reported player has history, priority should increase
    And reporter should receive acknowledgment

  @domain-events
  Scenario: RehabilitationCompleted triggers record update
    Given a player completes rehabilitation program
    When RehabilitationCompleted event is published
    Then the event should contain:
      | field           | description                    |
      | player_id       | Rehabilitated player           |
      | program_id      | Program identifier             |
      | duration        | How long program lasted        |
      | success         | Whether completed successfully |
    And player record should be updated
    And restrictions should be removed
    And player should receive completion certificate
    And success should be factored into future decisions

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle moderation service unavailable
    Given moderation service has issues
    When I attempt to apply moderation action
    Then I should see service error message
    And action should be queued for retry
    And I should see retry status
    And I should be able to take manual action if critical
    And a ModerationServiceError event should be published

  @api @error
  Scenario: Handle concurrent moderation conflict
    Given two moderators are viewing the same report
    When both attempt to resolve simultaneously
    Then first action should take precedence
    And second moderator should see conflict notice:
      | field          | value                               |
      | message        | Report already resolved             |
      | resolved_by    | ModeratorJane                       |
      | resolution     | Warning applied                     |
    And both actions should be logged
    And second moderator should be redirected to next item

  @api @error
  Scenario: Handle invalid moderation action
    Given I attempt to apply invalid action
    When I submit action with missing required fields
    Then action should be rejected
    And I should see validation errors:
      | field    | error                    |
      | reason   | Reason is required       |
      | duration | Duration must be positive|
    And no action should be applied
    And I should be able to correct and resubmit

  @api @error
  Scenario: Handle player not found during action
    Given I am applying action to a player
    And player has deleted their account
    When action is submitted
    Then action should fail gracefully
    And I should see "Player no longer exists" message
    And related reports should be auto-closed
    And action attempt should be logged

  @api @error @recovery
  Scenario: Recover from moderation data inconsistency
    Given moderation counts are inconsistent
    When reconciliation process runs
    Then actual counts should be recalculated
    And dashboard should show correct numbers
    And any discrepancies should be logged
    And a ModerationDataReconciled event should be published

  @api @error
  Scenario: Handle rate limit on moderation actions
    Given moderator is taking actions very rapidly
    When rate limit is exceeded (100 actions/hour)
    Then action should be blocked
    And moderator should see rate limit message
    And moderator should see when they can continue
    And this should be flagged for review (potential abuse)
