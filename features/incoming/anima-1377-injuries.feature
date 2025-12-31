@injuries @anima-1377
Feature: Injuries
  As a fantasy football user
  I want comprehensive injury tracking and information
  So that I can make informed roster decisions based on player health

  Background:
    Given I am a logged-in user
    And the injury tracking system is available

  # ============================================================================
  # INJURY REPORTS
  # ============================================================================

  @happy-path @injury-reports
  Scenario: View injury updates
    Given players have injury updates
    When I view injury reports
    Then I should see current injury updates
    And updates should be sorted by recency

  @happy-path @injury-reports
  Scenario: View injury status
    Given a player has an injury
    When I check their injury status
    Then I should see their current status
    And status should be clearly indicated

  @happy-path @injury-reports
  Scenario: View injury severity
    Given a player has an injury
    When I view injury details
    Then I should see injury severity
    And severity should be categorized

  @happy-path @injury-reports
  Scenario: View recovery timelines
    Given a player has an injury
    When I check recovery timeline
    Then I should see estimated return date
    And timeline should show progress

  @happy-path @injury-reports
  Scenario: View medical reports
    Given medical reports are available
    When I view medical reports
    Then I should see official medical information
    And reports should be from trusted sources

  @happy-path @injury-reports
  Scenario: View injury report by team
    Given I want team injury information
    When I view a team's injury report
    Then I should see all injured players on the team
    And their statuses should be listed

  @happy-path @injury-reports
  Scenario: View weekly injury report
    Given it is game week
    When I view weekly injury report
    Then I should see all injuries for the week
    And game-time decisions should be highlighted

  @happy-path @injury-reports
  Scenario: View injury report updates
    Given I am tracking injuries
    When injury reports are updated
    Then I should see the latest information
    And changes should be highlighted

  @mobile @injury-reports
  Scenario: View injury reports on mobile
    Given I am on a mobile device
    When I view injury reports
    Then reports should be mobile-friendly
    And I should be able to scroll easily

  # ============================================================================
  # INJURY ALERTS
  # ============================================================================

  @happy-path @injury-alerts
  Scenario: Receive injury notifications
    Given I have notification preferences set
    When a tracked player gets injured
    Then I should receive an injury notification
    And the notification should be timely

  @happy-path @injury-alerts
  Scenario: Receive real-time alerts
    Given I have real-time alerts enabled
    When an injury occurs
    Then I should receive an immediate alert
    And alert should include key details

  @happy-path @injury-alerts
  Scenario: Receive push notifications for injuries
    Given I have push notifications enabled
    When a rostered player is injured
    Then I should receive a push notification
    And I can tap to see details

  @happy-path @injury-alerts
  Scenario: Configure custom alert settings
    Given I am in injury alert settings
    When I configure custom alerts
    Then I should set alert thresholds
    And my preferences should be saved

  @happy-path @injury-alerts
  Scenario: Set alerts for specific players
    Given I want alerts for specific players
    When I set player-specific alerts
    Then I should be notified for those players
    And other players should not trigger alerts

  @happy-path @injury-alerts
  Scenario: Set alerts by severity
    Given I want alerts for serious injuries
    When I set severity-based alerts
    Then I should only get alerts for matching severity
    And minor injuries should be filtered

  @happy-path @injury-alerts
  Scenario: Disable injury alerts
    Given I am receiving too many alerts
    When I disable injury alerts
    Then I should stop receiving alerts
    And I can re-enable later

  @happy-path @injury-alerts
  Scenario: View alert history
    Given I have received alerts
    When I view alert history
    Then I should see past alerts
    And alerts should be chronological

  @happy-path @injury-alerts
  Scenario: Configure quiet hours for alerts
    Given I want quiet hours
    When I set quiet hours
    Then alerts should be suppressed during those hours
    And they should queue for later

  @happy-path @injury-alerts
  Scenario: Receive game-day injury alerts
    Given it is game day
    When there are last-minute injury updates
    Then I should receive urgent alerts
    And I should have time to adjust lineup

  # ============================================================================
  # INJURY HISTORY
  # ============================================================================

  @happy-path @injury-history
  Scenario: View past injuries
    Given a player has injury history
    When I view their injury history
    Then I should see past injuries
    And injuries should be listed chronologically

  @happy-path @injury-history
  Scenario: View injury patterns
    Given a player has recurring injuries
    When I analyze their injury patterns
    Then I should see injury trends
    And problem areas should be identified

  @happy-path @injury-history
  Scenario: Identify injury-prone players
    Given I want to assess injury risk
    When I check injury-prone status
    Then I should see injury frequency
    And risk should be indicated

  @happy-path @injury-history
  Scenario: View historical injury data
    Given I want comprehensive history
    When I view historical data
    Then I should see multi-season injury data
    And trends should be visible

  @happy-path @injury-history
  Scenario: Compare injury history between players
    Given I am comparing players
    When I compare injury histories
    Then I should see side-by-side comparison
    And durability should be clear

  @happy-path @injury-history
  Scenario: View career injury summary
    Given I am viewing a player
    Then I should see career injury summary
    And games missed should be totaled

  @happy-path @injury-history
  Scenario: View injury recovery history
    Given a player has recovered from injuries
    When I view recovery history
    Then I should see how they recovered
    And performance after recovery should be shown

  @happy-path @injury-history
  Scenario: Filter injury history by type
    Given I want specific injury types
    When I filter by injury type
    Then I should see matching injuries
    And filter should be clearable

  # ============================================================================
  # INJURY IMPACT
  # ============================================================================

  @happy-path @injury-impact
  Scenario: View fantasy impact analysis
    Given a player is injured
    When I view fantasy impact
    Then I should see projected point impact
    And impact should be quantified

  @happy-path @injury-impact
  Scenario: Get roster recommendations
    Given I have injured players
    When I view roster recommendations
    Then I should see suggested replacements
    And recommendations should be actionable

  @happy-path @injury-impact
  Scenario: Get start/sit advice
    Given a player has an injury
    When I check start/sit advice
    Then I should see recommendation
    And confidence level should be shown

  @happy-path @injury-impact
  Scenario: View adjusted point projections
    Given a player has an injury
    Then I should see adjusted projections
    And projections should account for injury

  @happy-path @injury-impact
  Scenario: Analyze backup impact
    Given a starter is injured
    When I view backup analysis
    Then I should see backup player value
    And usage increase should be projected

  @happy-path @injury-impact
  Scenario: View team-wide injury impact
    Given a team has multiple injuries
    When I view team impact
    Then I should see overall team impact
    And fantasy implications should be explained

  @happy-path @injury-impact
  Scenario: Compare injured vs healthy projections
    Given a player is questionable
    When I compare projections
    Then I should see healthy vs injured scenarios
    And risk/reward should be clear

  @happy-path @injury-impact
  Scenario: View matchup impact
    Given my opponent has injured players
    When I view matchup impact
    Then I should see how injuries affect matchup
    And win probability should adjust

  @happy-path @injury-impact
  Scenario: Get waiver priority suggestions
    Given I have injuries affecting my team
    When I view waiver suggestions
    Then I should see priority pickups
    And suggestions should address my needs

  @happy-path @injury-impact
  Scenario: View rest-of-season impact
    Given a player has a long-term injury
    When I view ROS impact
    Then I should see season-long implications
    And roster strategy should be suggested

  # ============================================================================
  # INJURY DESIGNATIONS
  # ============================================================================

  @happy-path @injury-designations
  Scenario: View IR status
    Given a player is on IR
    When I view their status
    Then I should see IR designation
    And expected return should be shown

  @happy-path @injury-designations
  Scenario: View questionable status
    Given a player is questionable
    When I view their status
    Then I should see questionable designation
    And game-time decision should be noted

  @happy-path @injury-designations
  Scenario: View doubtful status
    Given a player is doubtful
    When I view their status
    Then I should see doubtful designation
    And low play probability should be clear

  @happy-path @injury-designations
  Scenario: View out status
    Given a player is ruled out
    When I view their status
    Then I should see out designation
    And I should plan accordingly

  @happy-path @injury-designations
  Scenario: View practice participation status
    Given practice reports are available
    When I check practice status
    Then I should see participation level
    And status should be DNP, limited, or full

  @happy-path @injury-designations
  Scenario: Track designation changes
    Given I am tracking a player
    When their designation changes
    Then I should see the update
    And change history should be tracked

  @happy-path @injury-designations
  Scenario: View designation timeline
    Given a player has been injured
    When I view designation timeline
    Then I should see progression of status
    And recovery trend should be visible

  @happy-path @injury-designations
  Scenario: Filter players by designation
    Given I want to see specific designations
    When I filter by designation
    Then I should see matching players
    And I can select multiple designations

  @happy-path @injury-designations
  Scenario: View PUP list players
    Given players are on PUP list
    When I view PUP list
    Then I should see affected players
    And activation eligibility should be shown

  @happy-path @injury-designations
  Scenario: View NFI list players
    Given players are on NFI list
    When I view NFI list
    Then I should see affected players
    And return status should be indicated

  # ============================================================================
  # INJURY NEWS
  # ============================================================================

  @happy-path @injury-news
  Scenario: View injury news feed
    Given there is injury news
    When I view the injury news feed
    Then I should see recent injury news
    And news should be sorted by recency

  @happy-path @injury-news
  Scenario: View beat reporter updates
    Given beat reporters post updates
    When I view beat reporter news
    Then I should see insider information
    And reporter sources should be shown

  @happy-path @injury-news
  Scenario: View official team reports
    Given teams release injury reports
    When I view official reports
    Then I should see team announcements
    And official status should be highlighted

  @happy-path @injury-news
  Scenario: View press conference notes
    Given press conferences occurred
    When I view press conference news
    Then I should see coach statements
    And relevant quotes should be highlighted

  @happy-path @injury-news
  Scenario: Filter news by player
    Given I want specific player news
    When I filter by player
    Then I should see only that player's news
    And filter should be clearable

  @happy-path @injury-news
  Scenario: Filter news by team
    Given I want team-specific news
    When I filter by team
    Then I should see that team's injury news
    And all injured players should be covered

  @happy-path @injury-news
  Scenario: View breaking injury news
    Given breaking injury news occurs
    Then I should see breaking news highlighted
    And it should be prominently displayed

  @happy-path @injury-news
  Scenario: Share injury news
    Given I find important injury news
    When I share the news
    Then sharing options should appear
    And I can share to various platforms

  @happy-path @injury-news
  Scenario: Bookmark injury news
    Given I want to save injury news
    When I bookmark the article
    Then it should be saved
    And I can access it later

  # ============================================================================
  # INJURY TRACKING
  # ============================================================================

  @happy-path @injury-tracking
  Scenario: Add player to injury watchlist
    Given I want to track a player's injury
    When I add them to my watchlist
    Then they should be added
    And I should receive updates

  @happy-path @injury-tracking
  Scenario: View tracked injuries
    Given I have players on my watchlist
    When I view tracked injuries
    Then I should see all tracked players
    And their current status should be shown

  @happy-path @injury-tracking
  Scenario: Configure custom tracking alerts
    Given I have tracked players
    When I configure custom alerts
    Then I should set alert preferences per player
    And preferences should be saved

  @happy-path @injury-tracking
  Scenario: View monitored players dashboard
    Given I monitor multiple players
    When I view my dashboard
    Then I should see all monitored players
    And status changes should be highlighted

  @happy-path @injury-tracking
  Scenario: Remove player from watchlist
    Given I am tracking a player
    When I remove them from watchlist
    Then they should be removed
    And I should stop receiving updates

  @happy-path @injury-tracking
  Scenario: Organize watchlist by priority
    Given I have multiple tracked players
    When I organize by priority
    Then players should be sorted by importance
    And I can adjust priorities

  @happy-path @injury-tracking
  Scenario: Track injuries for my roster
    Given I have rostered players
    Then my roster injuries should be auto-tracked
    And I should see roster-specific updates

  @happy-path @injury-tracking
  Scenario: Track opponent injuries
    Given I have an upcoming matchup
    When I track opponent injuries
    Then I should monitor their team
    And matchup advantages should be noted

  # ============================================================================
  # INJURY ANALYSIS
  # ============================================================================

  @happy-path @injury-analysis
  Scenario: View expert analysis
    Given experts provide injury analysis
    When I view expert opinions
    Then I should see detailed analysis
    And expert credentials should be shown

  @happy-path @injury-analysis
  Scenario: View return predictions
    Given an injured player is recovering
    When I view return predictions
    Then I should see projected return date
    And confidence level should be indicated

  @happy-path @injury-analysis
  Scenario: View risk assessments
    Given I am evaluating a player
    When I view injury risk assessment
    Then I should see injury risk score
    And contributing factors should be shown

  @happy-path @injury-analysis
  Scenario: Track recovery progress
    Given a player is recovering
    When I track recovery progress
    Then I should see recovery milestones
    And progress should be visualized

  @happy-path @injury-analysis
  Scenario: View comparable injuries
    Given a player has an injury
    When I view comparable injuries
    Then I should see similar past cases
    And recovery outcomes should be shown

  @happy-path @injury-analysis
  Scenario: Analyze injury type severity
    Given I want to understand an injury
    When I view injury type analysis
    Then I should see typical recovery time
    And long-term implications should be explained

  @happy-path @injury-analysis
  Scenario: View performance after injury
    Given players have returned from injury
    When I analyze post-injury performance
    Then I should see performance trends
    And recovery curves should be shown

  @happy-path @injury-analysis
  Scenario: Get second opinion analysis
    Given I want multiple perspectives
    When I view second opinions
    Then I should see various expert takes
    And consensus should be indicated

  # ============================================================================
  # INJURY SEARCH
  # ============================================================================

  @happy-path @injury-search
  Scenario: Search injuries by player
    Given I want a specific player's injury info
    When I search by player name
    Then I should find matching results
    And search should be fast

  @happy-path @injury-search
  Scenario: Search injuries by team
    Given I want a team's injury report
    When I search by team
    Then I should see team injuries
    And all positions should be covered

  @happy-path @injury-search
  Scenario: Filter injuries by status
    Given I want specific injury statuses
    When I filter by status
    Then I should see matching injuries
    And I can select multiple statuses

  @happy-path @injury-search
  Scenario: Filter injuries by position
    Given I need a specific position
    When I filter by position
    Then I should see injured players at that position
    And filter should be clearable

  @happy-path @injury-search
  Scenario: Filter injuries by injury type
    Given I want specific injury types
    When I filter by injury type
    Then I should see matching injuries
    And type categories should be clear

  @happy-path @injury-search
  Scenario: Use advanced injury search
    Given I need specific results
    When I use advanced search
    Then I should combine multiple criteria
    And results should be precise

  @happy-path @injury-search
  Scenario: View recent search history
    Given I have searched before
    When I view search history
    Then I should see past searches
    And I can repeat a search

  @happy-path @injury-search
  Scenario: Save injury search
    Given I want to repeat a search
    When I save the search
    Then the search should be saved
    And I can run it again

  @happy-path @injury-search
  Scenario: Search with autocomplete
    Given I am searching
    When I type a query
    Then I should see autocomplete suggestions
    And suggestions should be relevant

  # ============================================================================
  # INJURY INTEGRATION
  # ============================================================================

  @happy-path @injury-integration
  Scenario: View injury impact on roster
    Given I have injured roster players
    When I view my roster
    Then injury status should be integrated
    And affected positions should be highlighted

  @happy-path @injury-integration
  Scenario: Get waiver suggestions for injuries
    Given I have roster injuries
    When I view waiver suggestions
    Then I should see replacement options
    And suggestions should match my needs

  @happy-path @injury-integration
  Scenario: View trade implications
    Given I am considering a trade
    When I view injury impact
    Then I should see injury risk factors
    And trade value should be adjusted

  @happy-path @injury-integration
  Scenario: Get lineup adjustment suggestions
    Given I have injured starters
    When I view lineup suggestions
    Then I should see recommended changes
    And optimal lineup should be suggested

  @happy-path @injury-integration
  Scenario: View injury warnings in lineup
    Given I am setting my lineup
    When I add an injured player
    Then I should see an injury warning
    And I should confirm the decision

  @happy-path @injury-integration
  Scenario: Auto-swap injured players
    Given I have an injured starter
    When auto-swap is enabled
    Then healthy players should be substituted
    And I should be notified of changes

  @happy-path @injury-integration
  Scenario: View IR eligibility
    Given a player qualifies for IR
    When I view roster options
    Then IR eligibility should be indicated
    And I should be able to move them to IR

  @happy-path @injury-integration
  Scenario: Integrate injuries with projections
    Given projections are available
    Then injury status should affect projections
    And adjusted values should be shown

  @happy-path @injury-integration
  Scenario: View injury impact on rankings
    Given rankings are available
    When a player is injured
    Then rankings should reflect injury status
    And rank changes should be shown

  @happy-path @injury-integration
  Scenario: Get draft day injury alerts
    Given I am in a draft
    When a player has an injury
    Then I should see injury warning
    And I can make an informed pick
