@admin @community @moderation @ANIMA-1074
Feature: Admin Community Management
  As a platform administrator
  I want to manage community interactions and moderation
  So that I can maintain a healthy and engaging user community

  Background:
    Given an authenticated administrator with "community_management" permissions
    And the community management system is operational
    And the following community statistics exist:
      | metric              | value    |
      | total_members       | 50,000   |
      | active_members      | 35,000   |
      | posts_this_month    | 125,000  |
      | comments_this_month | 450,000  |
      | reports_pending     | 45       |

  # =============================================================================
  # COMMUNITY DASHBOARD AND OVERVIEW
  # =============================================================================

  @dashboard @happy-path
  Scenario: View community dashboard
    Given the community has been active for 12 months
    When I access the community management dashboard
    Then I should see community health metrics:
      | metric                  | value    | trend   |
      | total_members           | 50,000   | +12%    |
      | daily_active_users      | 8,500    | +5%     |
      | weekly_active_users     | 25,000   | +8%     |
      | monthly_active_users    | 35,000   | +10%    |
      | engagement_rate         | 68%      | +3%     |
      | avg_session_duration    | 12m      | +15%    |
    And I should see a real-time activity feed
    And I should see pending moderation items count

  @dashboard @metrics
  Scenario: View detailed engagement metrics
    Given engagement data is being tracked
    When I view detailed engagement metrics
    Then I should see:
      | metric                | value    | benchmark |
      | posts_per_user        | 2.5      | 2.0       |
      | comments_per_post     | 3.6      | 3.0       |
      | likes_per_post        | 8.2      | 5.0       |
      | shares_per_post       | 1.2      | 1.0       |
      | reply_rate            | 45%      | 40%       |
    And I should see engagement trends over time

  @dashboard @activity
  Scenario: View real-time community activity
    Given community members are currently active
    When I view the activity feed
    Then I should see real-time updates:
      | activity_type    | frequency        |
      | new_posts        | 5 per minute     |
      | new_comments     | 20 per minute    |
      | new_members      | 2 per minute     |
      | reactions        | 50 per minute    |
    And I should be able to filter by activity type
    And I should be able to click through to details

  # =============================================================================
  # CONTENT MODERATION
  # =============================================================================

  @moderation @queue
  Scenario: View content moderation queue
    Given there are 45 items pending moderation
    When I access the moderation queue
    Then I should see items sorted by priority:
      | priority | count | avg_wait_time |
      | critical | 5     | 10 minutes    |
      | high     | 15    | 30 minutes    |
      | medium   | 20    | 2 hours       |
      | low      | 5     | 8 hours       |
    And each item should show reporter information
    And each item should show reported content preview

  @moderation @review
  Scenario: Review reported content
    Given a post has been reported for "hate speech"
    When I review the reported content
    Then I should see:
      | field              | value                          |
      | content_type       | post                           |
      | reported_by        | 3 users                        |
      | report_reasons     | hate_speech, harassment        |
      | author             | user123                        |
      | author_history     | 2 previous violations          |
      | content_context    | Full thread visible            |
    And I should have moderation actions available

  @moderation @actions
  Scenario: Take moderation action on content
    Given I am reviewing a policy-violating post
    When I take moderation action
    Then I should be able to:
      | action              | effect                         |
      | approve             | Mark as acceptable             |
      | remove              | Delete content                 |
      | hide                | Hide from public view          |
      | warn                | Send warning to author         |
      | restrict            | Limit author's posting         |
      | ban                 | Ban author temporarily         |
    And the action should be logged
    And the reporter should be notified

  @moderation @bulk
  Scenario: Bulk moderate similar content
    Given there are 10 posts with similar violations
    When I select bulk moderation
    Then I should be able to:
      | action              | scope                          |
      | remove_all          | Delete all selected            |
      | warn_authors        | Send warnings to all authors   |
      | apply_filter        | Add content to filter list     |
    And each action should be logged individually
    And a domain event "BulkModerationApplied" should be published

  @moderation @auto
  Scenario: Configure automated moderation
    Given I want to automate content filtering
    When I configure auto-moderation rules:
      | rule_type           | action             | threshold    |
      | profanity_filter    | auto_remove        | high_match   |
      | spam_detection      | auto_hide          | 90% confidence|
      | duplicate_content   | flag_for_review    | 95% match    |
      | suspicious_links    | auto_hold          | any_match    |
    Then the rules should be activated
    And matching content should be handled automatically
    And a domain event "AutoModerationConfigured" should be published

  @moderation @appeals
  Scenario: Handle moderation appeals
    Given a user has appealed a content removal
    When I review the appeal
    Then I should see:
      | field              | value                          |
      | original_content   | Full content visible           |
      | removal_reason     | Policy violation               |
      | moderator_notes    | Previous moderator's notes     |
      | user_appeal        | User's appeal message          |
      | user_history       | Complete moderation history    |
    And I should be able to uphold or reverse the decision

  # =============================================================================
  # COMMUNITY MEMBER MANAGEMENT
  # =============================================================================

  @members @view
  Scenario: View community members
    Given there are 50,000 community members
    When I access the member management interface
    Then I should see member list with:
      | column              | sortable | filterable |
      | username            | yes      | yes        |
      | join_date           | yes      | yes        |
      | reputation_score    | yes      | yes        |
      | posts_count         | yes      | yes        |
      | status              | yes      | yes        |
      | last_active         | yes      | yes        |
    And I should be able to search by username or email

  @members @profile
  Scenario: View member profile details
    Given I am viewing a member's profile
    When I access their admin view
    Then I should see:
      | section             | information                    |
      | basic_info          | Username, email, join date     |
      | activity_stats      | Posts, comments, reactions     |
      | reputation          | Score, badges, achievements    |
      | moderation_history  | Warnings, bans, appeals        |
      | report_history      | Reports filed and received     |
    And I should see a timeline of their activity

  @members @actions
  Scenario: Take action on a member
    Given I have identified a problematic member
    When I take action on their account
    Then I should be able to:
      | action              | duration         | effect                |
      | warn                | permanent        | Add warning to record |
      | mute                | 1-30 days        | Cannot post/comment   |
      | suspend             | 1-90 days        | Cannot access community|
      | ban                 | permanent        | Permanently banned    |
      | shadow_ban          | indefinite       | Hidden from others    |
    And the member should be notified
    And a domain event "MemberActionTaken" should be published

  @members @roles
  Scenario: Assign member roles
    Given I want to elevate a member's privileges
    When I assign roles:
      | role                | permissions                    |
      | trusted_member      | Skip some moderation queues    |
      | helper              | Answer support questions       |
      | moderator           | Moderate content               |
      | community_lead      | Manage community sections      |
    Then the role should be assigned
    And the member should receive role-specific permissions
    And a domain event "MemberRoleAssigned" should be published

  @members @verification
  Scenario: Verify member identity
    Given a member has requested verification
    When I review their verification request
    Then I should see submitted documents
    And I should be able to:
      | action              | result                         |
      | approve             | Grant verified status          |
      | reject              | Deny with reason               |
      | request_more        | Ask for additional documents   |
    And verified members should display a badge

  # =============================================================================
  # COMMUNITY FORUMS
  # =============================================================================

  @forums @manage
  Scenario: Manage community forums
    Given the community has multiple forum sections
    When I access forum management
    Then I should see:
      | forum               | posts   | members | moderators |
      | General Discussion  | 25,000  | 45,000  | 5          |
      | Strategy & Tips     | 15,000  | 30,000  | 3          |
      | Trade Talk          | 20,000  | 35,000  | 4          |
      | League Help         | 10,000  | 25,000  | 3          |
      | Off-Topic           | 8,000   | 20,000  | 2          |
    And I should be able to manage each forum's settings

  @forums @create
  Scenario: Create new forum section
    Given I want to add a new discussion area
    When I create a new forum:
      | field               | value                          |
      | name                | Rookie Corner                  |
      | description         | For new fantasy players        |
      | access_level        | all_members                    |
      | posting_rules       | standard                       |
      | moderators          | mod1, mod2                     |
    Then the forum should be created
    And be visible to members
    And a domain event "ForumCreated" should be published

  @forums @configure
  Scenario: Configure forum settings
    Given I am managing forum "Trade Talk"
    When I update forum settings:
      | setting             | value                          |
      | posting_frequency   | 5 posts per hour max           |
      | link_restrictions   | Verified members only          |
      | image_attachments   | Allowed with size limit        |
      | auto_lock_threads   | After 30 days inactivity       |
    Then the settings should be applied
    And existing threads should be updated accordingly

  @forums @threads
  Scenario: Manage forum threads
    Given there are threads needing attention
    When I manage threads
    Then I should be able to:
      | action              | effect                         |
      | pin                 | Keep at top of forum           |
      | lock                | Prevent new replies            |
      | move                | Transfer to different forum    |
      | merge               | Combine duplicate threads      |
      | archive             | Move to archive section        |
    And actions should be logged

  # =============================================================================
  # COMMUNITY GUIDELINES
  # =============================================================================

  @guidelines @manage
  Scenario: Manage community guidelines
    Given community guidelines exist
    When I access guidelines management
    Then I should see all current guidelines:
      | guideline           | status   | last_updated |
      | Code of Conduct     | active   | 2024-01-01   |
      | Posting Rules       | active   | 2024-01-01   |
      | Trading Guidelines  | active   | 2024-01-01   |
      | Privacy Policy      | active   | 2024-01-01   |
    And I should be able to edit any guideline

  @guidelines @update
  Scenario: Update community guidelines
    Given I need to update the Code of Conduct
    When I edit the guidelines:
      | field               | value                          |
      | section             | Harassment Policy              |
      | changes             | Added social media policy      |
      | effective_date      | 2024-02-01                     |
      | notification        | Required                       |
    Then the updated guidelines should be saved
    And members should be notified of changes
    And acknowledgment should be required
    And a domain event "GuidelinesUpdated" should be published

  @guidelines @enforcement
  Scenario: Configure guideline enforcement
    Given guidelines need enforcement rules
    When I configure enforcement:
      | violation           | first_offense  | second_offense | third_offense |
      | spam                | warning        | 3-day mute     | 30-day ban    |
      | harassment          | 7-day ban      | 30-day ban     | permanent ban |
      | hate_speech         | 30-day ban     | permanent ban  | -             |
      | misinformation      | warning        | warning        | 7-day mute    |
    Then the enforcement rules should be saved
    And applied automatically during moderation

  @guidelines @acknowledgment
  Scenario: Track guideline acknowledgments
    Given new guidelines have been published
    When I view acknowledgment status
    Then I should see:
      | metric              | value          |
      | total_members       | 50,000         |
      | acknowledged        | 35,000 (70%)   |
      | pending             | 15,000 (30%)   |
      | reminder_sent       | 10,000         |
    And I should be able to send reminders to pending members

  # =============================================================================
  # MODERATION TEAM MANAGEMENT
  # =============================================================================

  @mod-team @view
  Scenario: View moderation team
    Given there is a moderation team
    When I access team management
    Then I should see all moderators:
      | moderator    | role           | assigned_areas    | actions_today |
      | mod_alice    | senior_mod     | All forums        | 45            |
      | mod_bob      | moderator      | General, Trading  | 32            |
      | mod_carol    | moderator      | Strategy, Help    | 28            |
      | mod_dave     | junior_mod     | General           | 15            |
    And I should see team performance metrics

  @mod-team @add
  Scenario: Add new moderator
    Given I want to expand the moderation team
    When I add a new moderator:
      | field               | value                          |
      | user                | trusted_user_123               |
      | role                | junior_mod                     |
      | assigned_areas      | Off-Topic                      |
      | permissions         | review, warn, mute             |
      | training_required   | yes                            |
    Then the user should be added as a moderator
    And receive moderator training materials
    And a domain event "ModeratorAdded" should be published

  @mod-team @performance
  Scenario: Track moderator performance
    Given moderators have been active
    When I view performance metrics
    Then I should see for each moderator:
      | metric              | value          |
      | actions_per_day     | 35             |
      | avg_response_time   | 15 minutes     |
      | accuracy_rate       | 95%            |
      | appeals_overturned  | 2%             |
      | user_satisfaction   | 4.5/5          |
    And identify top performers

  @mod-team @schedule
  Scenario: Manage moderation schedule
    Given moderation needs 24/7 coverage
    When I manage the moderation schedule
    Then I should be able to:
      | action              | purpose                        |
      | assign_shifts       | Cover all time zones           |
      | set_availability    | Track moderator availability   |
      | handle_absences     | Manage time off                |
      | escalation_rules    | After-hours escalation         |
    And ensure adequate coverage at all times

  # =============================================================================
  # COMMUNITY EVENTS
  # =============================================================================

  @events @create
  Scenario: Create community event
    Given I want to organize a community event
    When I create an event:
      | field               | value                          |
      | name                | Fantasy Draft Party            |
      | type                | virtual                        |
      | date                | 2024-09-01 19:00 UTC           |
      | duration            | 3 hours                        |
      | capacity            | 500                            |
      | registration        | required                       |
    Then the event should be created
    And announced to the community
    And a domain event "CommunityEventCreated" should be published

  @events @manage
  Scenario: Manage ongoing event
    Given a community event is in progress
    When I manage the event
    Then I should be able to:
      | action              | purpose                        |
      | monitor_chat        | Watch event discussions        |
      | moderate_live       | Real-time moderation           |
      | send_announcements  | Event-wide messages            |
      | manage_participants | Mute/remove disruptive users   |
      | record_highlights   | Capture key moments            |

  @events @recurring
  Scenario: Set up recurring community events
    Given I want regular community activities
    When I create a recurring event:
      | field               | value                          |
      | name                | Weekly Strategy Session        |
      | recurrence          | Every Saturday 14:00 UTC       |
      | duration            | 2 hours                        |
      | auto_announce       | 24 hours before                |
    Then events should be scheduled automatically
    And reminders should be sent to interested members

  @events @analytics
  Scenario: Analyze event performance
    Given past events have been held
    When I view event analytics
    Then I should see:
      | metric              | value          |
      | total_events        | 24             |
      | avg_attendance      | 350            |
      | satisfaction_score  | 4.6/5          |
      | repeat_attendance   | 65%            |
    And recommendations for future events

  # =============================================================================
  # USER RECOGNITION PROGRAMS
  # =============================================================================

  @recognition @badges
  Scenario: Manage achievement badges
    Given a badge system exists
    When I manage badges
    Then I should see:
      | badge               | criteria                       | holders |
      | Veteran             | 2+ years membership            | 5,000   |
      | Contributor         | 100+ helpful posts             | 3,000   |
      | Champion            | Won community contests         | 500     |
      | Helper              | 500+ helpful answers           | 200     |
    And I should be able to create new badges

  @recognition @create-badge
  Scenario: Create new achievement badge
    Given I want to recognize a new achievement
    When I create a badge:
      | field               | value                          |
      | name                | Rising Star                    |
      | description         | Exceptional new member         |
      | criteria            | 50+ helpful posts in first 90 days |
      | icon                | star_rising.png                |
      | rarity              | rare                           |
    Then the badge should be created
    And eligible members should receive it automatically

  @recognition @leaderboards
  Scenario: Manage community leaderboards
    Given leaderboards track member achievements
    When I configure leaderboards:
      | leaderboard         | metric                 | reset_period |
      | Top Contributors    | Helpful posts          | Monthly      |
      | Most Helpful        | Accepted answers       | Weekly       |
      | Engagement Kings    | Total interactions     | Monthly      |
      | Rising Stars        | Reputation gained      | Weekly       |
    Then leaderboards should display rankings
    And members should be notified of position changes

  @recognition @rewards
  Scenario: Configure member rewards
    Given I want to reward top members
    When I configure rewards:
      | achievement         | reward                         |
      | monthly_top_10      | Premium badge + profile flair  |
      | quarterly_champion  | Exclusive access + merchandise |
      | yearly_mvp          | Special recognition event      |
    Then rewards should be distributed automatically
    And winners should be announced

  # =============================================================================
  # TOXIC BEHAVIOR DETECTION
  # =============================================================================

  @toxic @detection
  Scenario: Configure toxicity detection
    Given I want to detect harmful behavior
    When I configure detection settings:
      | behavior            | sensitivity | action              |
      | harassment          | high        | auto_flag           |
      | hate_speech         | very_high   | auto_remove         |
      | bullying            | high        | auto_flag           |
      | threats             | very_high   | auto_remove + alert |
      | spam                | medium      | auto_hide           |
    Then content should be analyzed in real-time
    And matching content should be handled appropriately

  @toxic @patterns
  Scenario: Identify toxic behavior patterns
    Given user behavior is being tracked
    When I analyze behavior patterns
    Then I should see flagged users:
      | user           | risk_score | behaviors                     |
      | problem_user_1 | 85%        | Repeated harassment, spam     |
      | problem_user_2 | 72%        | Trolling, derailing threads   |
      | problem_user_3 | 68%        | Aggressive language, insults  |
    And receive recommendations for intervention

  @toxic @intervention
  Scenario: Apply graduated interventions
    Given a user has escalating violations
    When I apply interventions
    Then the system should follow escalation:
      | step | intervention        | trigger                    |
      | 1    | warning_message     | First minor violation      |
      | 2    | temporary_mute      | Repeated violations        |
      | 3    | restricted_posting  | Continued violations       |
      | 4    | suspension          | Serious or persistent      |
      | 5    | permanent_ban       | Severe or unrepentant      |
    And each step should be documented

  @toxic @reporting
  Scenario: Handle user-submitted reports
    Given users can report harmful content
    When reports are submitted
    Then the system should:
      | action              | detail                         |
      | categorize          | By report type and severity    |
      | prioritize          | Based on urgency and patterns  |
      | route               | To appropriate moderator       |
      | track               | Report resolution status       |
      | feedback            | Notify reporter of outcome     |

  # =============================================================================
  # COMMUNITY HEALTH ANALYSIS
  # =============================================================================

  @health @metrics
  Scenario: Analyze community health metrics
    Given community health is being monitored
    When I view health analysis
    Then I should see:
      | metric              | score   | status    |
      | engagement_health   | 8.2/10  | healthy   |
      | sentiment_score     | 7.5/10  | good      |
      | toxicity_level      | 1.2/10  | low       |
      | growth_rate         | 7.8/10  | healthy   |
      | retention_rate      | 8.0/10  | healthy   |
    And overall community health score

  @health @sentiment
  Scenario: Monitor community sentiment
    Given sentiment analysis is enabled
    When I view sentiment trends
    Then I should see:
      | time_period | positive | neutral | negative |
      | today       | 65%      | 28%     | 7%       |
      | this_week   | 63%      | 29%     | 8%       |
      | this_month  | 62%      | 30%     | 8%       |
    And identify topics with negative sentiment

  @health @alerts
  Scenario: Receive community health alerts
    Given health thresholds are configured
    When a threshold is breached
    Then I should receive alerts for:
      | condition                        | severity |
      | Toxicity spike above 5%          | high     |
      | Engagement drop above 20%        | medium   |
      | Report volume spike above 50%    | high     |
      | Member churn above 10%           | medium   |
    And recommendations for intervention

  @health @reports
  Scenario: Generate community health reports
    Given I need to report on community status
    When I generate a health report
    Then the report should include:
      | section             | content                        |
      | executive_summary   | Key metrics and trends         |
      | engagement_analysis | Activity and participation     |
      | moderation_summary  | Actions taken and outcomes     |
      | growth_metrics      | Member acquisition and retention|
      | recommendations     | Suggested improvements         |
    And be exportable in multiple formats

  # =============================================================================
  # QUALITY CONTENT PROMOTION
  # =============================================================================

  @content @quality
  Scenario: Identify quality content
    Given content quality is being analyzed
    When I view quality content rankings
    Then I should see top content:
      | content_type | criteria                       | top_count |
      | posts        | Engagement + helpfulness       | 100       |
      | guides       | Views + saves + ratings        | 50        |
      | discussions  | Reply depth + quality          | 75        |
    And be able to feature quality content

  @content @feature
  Scenario: Feature quality content
    Given I have identified excellent content
    When I feature content
    Then I should be able to:
      | action              | effect                         |
      | pin_to_top          | Display at top of forum        |
      | add_to_featured     | Show in featured section       |
      | send_to_newsletter  | Include in community digest    |
      | award_badge         | Give author recognition        |
    And track featured content performance

  @content @curation
  Scenario: Curate content collections
    Given valuable content exists across forums
    When I create a curated collection:
      | field               | value                          |
      | name                | Fantasy Draft Masterclass      |
      | description         | Best draft strategy content    |
      | content_items       | 15 selected posts/guides       |
      | visibility          | All members                    |
    Then the collection should be published
    And promoted to relevant members

  @content @creators
  Scenario: Recognize top content creators
    Given members create valuable content
    When I identify top creators
    Then I should see:
      | creator        | content_score | followers | engagement |
      | expert_user_1  | 95            | 5,000     | 15%        |
      | expert_user_2  | 92            | 4,200     | 14%        |
      | expert_user_3  | 88            | 3,800     | 12%        |
    And offer creator incentives

  # =============================================================================
  # COMMUNITY FEEDBACK
  # =============================================================================

  @feedback @collect
  Scenario: Collect community feedback
    Given I want to gather member input
    When I create a feedback survey:
      | field               | value                          |
      | name                | Q1 Community Survey            |
      | questions           | 10 questions                   |
      | target_audience     | All active members             |
      | duration            | 2 weeks                        |
    Then the survey should be distributed
    And responses should be collected

  @feedback @analyze
  Scenario: Analyze community feedback
    Given feedback has been collected
    When I analyze the results
    Then I should see:
      | category            | satisfaction | common_themes         |
      | overall_experience  | 4.2/5        | Great community vibe  |
      | moderation          | 3.8/5        | Sometimes slow        |
      | features            | 4.0/5        | Want more badges      |
      | content_quality     | 4.3/5        | Helpful discussions   |
    And actionable insights

  @feedback @suggestions
  Scenario: Manage feature suggestions
    Given members submit feature suggestions
    When I view the suggestion queue
    Then I should see suggestions with:
      | suggestion          | votes | status    | assigned_to |
      | Dark mode           | 500   | planned   | product     |
      | Mobile app          | 450   | under_review | product  |
      | More badges         | 300   | approved  | community   |
    And be able to update status and respond

  @feedback @respond
  Scenario: Respond to community feedback
    Given feedback requires response
    When I respond to feedback
    Then my response should be:
      | attribute           | requirement                    |
      | timely              | Within 48 hours                |
      | visible             | Public or private as appropriate|
      | actionable          | Clear next steps if any        |
      | tracked             | Response logged for analytics  |

  # =============================================================================
  # COMMUNITY GROWTH
  # =============================================================================

  @growth @acquisition
  Scenario: Track member acquisition
    Given new members are joining
    When I view acquisition metrics
    Then I should see:
      | source              | new_members | conversion_rate |
      | organic_search      | 2,000       | 15%             |
      | social_media        | 1,500       | 12%             |
      | referrals           | 1,000       | 25%             |
      | partnerships        | 500         | 20%             |
    And identify high-performing channels

  @growth @retention
  Scenario: Analyze member retention
    Given member retention is tracked
    When I view retention metrics
    Then I should see:
      | cohort              | day_1  | day_7  | day_30 | day_90 |
      | January 2024        | 85%    | 65%    | 45%    | 35%    |
      | December 2023       | 82%    | 62%    | 42%    | 32%    |
    And identify retention drop-off points

  @growth @campaigns
  Scenario: Launch growth campaigns
    Given I want to grow the community
    When I create a growth campaign:
      | field               | value                          |
      | name                | Refer-a-Friend Program         |
      | type                | referral                       |
      | incentive           | Premium badge for both parties |
      | duration            | 30 days                        |
    Then the campaign should be launched
    And tracked for effectiveness

  @growth @reactivation
  Scenario: Reactivate dormant members
    Given there are inactive members
    When I launch a reactivation campaign
    Then I should target:
      | segment             | count   | last_active    |
      | recently_inactive   | 5,000   | 30-60 days ago |
      | dormant             | 8,000   | 60-180 days ago|
      | churned             | 15,000  | 180+ days ago  |
    And send personalized re-engagement messages

  # =============================================================================
  # CRISIS MANAGEMENT
  # =============================================================================

  @crisis @detection
  Scenario: Detect community crisis
    Given crisis detection is enabled
    When a crisis pattern is detected
    Then I should be alerted for:
      | crisis_type         | indicators                     |
      | brigading           | Coordinated negative activity  |
      | controversy         | Heated debates, report spike   |
      | misinformation      | Viral false content            |
      | security_breach     | Account compromises            |
    And receive severity assessment

  @crisis @response
  Scenario: Execute crisis response
    Given a community crisis is detected
    When I initiate crisis response
    Then I should be able to:
      | action              | effect                         |
      | enable_slow_mode    | Limit posting frequency        |
      | restrict_new_users  | Limit new member actions       |
      | lockdown_areas      | Close affected forums          |
      | deploy_mods         | Alert additional moderators    |
      | communicate         | Post official statement        |
    And a domain event "CrisisResponseActivated" should be published

  @crisis @communication
  Scenario: Manage crisis communications
    Given a crisis is being handled
    When I manage communications
    Then I should:
      | step                | action                         |
      | acknowledge         | Confirm awareness of issue     |
      | update              | Provide regular status updates |
      | resolve             | Announce resolution            |
      | learn               | Share lessons learned          |
    And maintain transparency with community

  @crisis @post-mortem
  Scenario: Conduct crisis post-mortem
    Given a crisis has been resolved
    When I conduct post-mortem analysis
    Then I should document:
      | section             | content                        |
      | timeline            | When events occurred           |
      | response            | Actions taken                  |
      | effectiveness       | What worked and didn't         |
      | improvements        | Process improvements           |
    And implement preventive measures

  # =============================================================================
  # NEW USER ONBOARDING
  # =============================================================================

  @onboarding @configure
  Scenario: Configure onboarding flow
    Given I want to improve new user experience
    When I configure onboarding:
      | step                | required | content                    |
      | welcome_message     | yes      | Personalized greeting      |
      | community_tour      | yes      | Interactive walkthrough    |
      | guidelines_accept   | yes      | Community rules            |
      | profile_setup       | no       | Avatar, bio, interests     |
      | first_post_prompt   | no       | Encourage introduction     |
    Then the onboarding flow should be updated
    And new members should experience it

  @onboarding @metrics
  Scenario: Track onboarding effectiveness
    Given new members are going through onboarding
    When I view onboarding metrics
    Then I should see:
      | metric              | value    | target   |
      | completion_rate     | 75%      | 80%      |
      | time_to_first_post  | 2 days   | 1 day    |
      | 7_day_retention     | 65%      | 70%      |
      | satisfaction_score  | 4.2/5    | 4.5/5    |
    And identify drop-off points

  @onboarding @mentorship
  Scenario: Match new members with mentors
    Given a mentorship program exists
    When a new member opts in
    Then they should be matched with:
      | criteria            | matching_factor              |
      | interests           | Similar fantasy interests    |
      | timezone            | Compatible time zones        |
      | experience_level    | Mentor has expertise         |
    And the mentor should be notified

  @onboarding @welcome
  Scenario: Automate welcome activities
    Given new members need engagement
    When I configure welcome automation
    Then new members should receive:
      | timing              | activity                     |
      | immediate           | Welcome message              |
      | day_1               | Suggested forums to follow   |
      | day_3               | Prompt to introduce themselves|
      | day_7               | Highlight popular content    |
      | day_14              | Invitation to community event|

  # =============================================================================
  # COMMUNITY INSIGHTS
  # =============================================================================

  @insights @trends
  Scenario: Analyze community trends
    Given community activity generates data
    When I view trend analysis
    Then I should see:
      | trend_type          | insights                       |
      | topic_trends        | Rising and falling topics      |
      | sentiment_shifts    | Changes in community mood      |
      | engagement_patterns | Peak activity times            |
      | user_behavior       | Changing usage patterns        |
    And predictions for future trends

  @insights @segmentation
  Scenario: Segment community members
    Given I want to understand member segments
    When I view member segmentation
    Then I should see:
      | segment             | size   | characteristics            |
      | power_users         | 5%     | Daily active, high posts   |
      | regular_members     | 25%    | Weekly active, moderate    |
      | casual_visitors     | 40%    | Monthly active, lurkers    |
      | at_risk             | 15%    | Declining engagement       |
      | dormant             | 15%    | Inactive 60+ days          |
    And engagement strategies for each

  @insights @reports
  Scenario: Generate community insights report
    Given I need comprehensive analytics
    When I generate an insights report
    Then the report should include:
      | section             | content                        |
      | growth_analysis     | Member growth and churn        |
      | engagement_deep_dive| Activity patterns and trends   |
      | content_analysis    | Popular topics and creators    |
      | health_assessment   | Community health indicators    |
      | recommendations     | Data-driven suggestions        |
    And be scheduled for automatic generation

  @insights @benchmarks
  Scenario: Compare against industry benchmarks
    Given benchmark data is available
    When I view benchmark comparison
    Then I should see:
      | metric              | our_value | benchmark | status     |
      | DAU/MAU ratio       | 24%       | 20%       | above      |
      | posts_per_user      | 2.5       | 2.0       | above      |
      | retention_30_day    | 45%       | 40%       | above      |
      | moderation_rate     | 0.5%      | 1.0%      | better     |
    And identify areas for improvement

  # =============================================================================
  # API SCENARIOS
  # =============================================================================

  @api @members
  Scenario: Get member information via API
    Given I have a valid API token with community permissions
    When I send a GET request to /api/v1/admin/community/members/{userId}
    Then the response status should be 200 OK
    And the response should contain member details and activity

  @api @moderation
  Scenario: Submit moderation action via API
    Given I have a valid API token with moderation permissions
    When I send a POST request to /api/v1/admin/community/moderation/actions:
      """
      {
        "content_id": "post-12345",
        "action": "remove",
        "reason": "policy_violation",
        "notify_user": true
      }
      """
    Then the response status should be 200 OK
    And the moderation action should be applied

  @api @analytics
  Scenario: Get community analytics via API
    Given I have a valid API token
    When I send a GET request to /api/v1/admin/community/analytics?period=30d
    Then the response status should be 200 OK
    And the response should contain engagement and health metrics

  @api @webhook
  Scenario: Configure community event webhooks
    Given I want to receive community notifications
    When I configure a webhook:
      """
      {
        "url": "https://example.com/webhooks/community",
        "events": ["member.joined", "content.reported", "crisis.detected"],
        "secret": "webhook-secret"
      }
      """
    Then the webhook should be registered
    And events should be delivered in real-time

  # =============================================================================
  # ERROR SCENARIOS
  # =============================================================================

  @error @moderation
  Scenario: Handle moderation action failure
    Given I am taking moderation action
    When the action cannot be completed
    Then I should see an appropriate error message
    And the original content should remain unchanged
    And the failure should be logged for investigation

  @error @permissions
  Scenario: Prevent unauthorized community actions
    Given I have limited community permissions
    When I attempt to ban a member
    Then the action should be denied with 403 Forbidden
    And display "Insufficient permissions for member bans"
    And the attempt should be logged

  @error @rate-limit
  Scenario: Handle bulk action rate limits
    Given I am performing bulk moderation
    When I exceed the rate limit
    Then I should see "Rate limit exceeded"
    And be told to wait before continuing
    And partial actions should be completed

  @error @invalid-action
  Scenario: Prevent invalid moderation actions
    Given I am moderating content
    When I attempt an invalid action combination
    Then the action should be rejected
    And I should see specific validation errors
    And be guided to correct the action

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events
  Scenario: Publish domain events for community management
    Given the event bus is configured
    When community management events occur
    Then the following events should be published:
      | event_type                  | payload_includes                  |
      | MemberJoined                | member_id, source, timestamp      |
      | MemberActionTaken           | member_id, action, moderator      |
      | MemberRoleAssigned          | member_id, role, assigned_by      |
      | ContentModerated            | content_id, action, reason        |
      | BulkModerationApplied       | content_ids, action, count        |
      | CommunityEventCreated       | event_id, name, date              |
      | CrisisResponseActivated     | crisis_type, severity, actions    |
      | GuidelinesUpdated           | version, changes, effective_date  |
      | CommunityHealthAlert        | metric, value, threshold          |
