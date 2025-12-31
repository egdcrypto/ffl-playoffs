@free-agents @anima-1398
Feature: Free Agents
  As a fantasy football user
  I want comprehensive free agent management
  So that I can find and add available players

  Background:
    Given I am a logged-in user
    And the free agent system is available

  # ============================================================================
  # FREE AGENT LIST
  # ============================================================================

  @happy-path @free-agent-list
  Scenario: View free agents
    Given free agents exist
    When I view free agents
    Then I should see available players
    And they should be sorted by relevance

  @happy-path @free-agent-list
  Scenario: View available players
    Given players are available
    When I view available players
    Then I should see unrostered players
    And ownership status should be clear

  @happy-path @free-agent-list
  Scenario: Filter by position
    Given I want specific position
    When I filter by position
    Then I should see only that position
    And count should update

  @happy-path @free-agent-list
  Scenario: Filter by team
    Given I want specific team
    When I filter by team
    Then I should see only that team
    And players should be listed

  @happy-path @free-agent-list
  Scenario: View availability status
    Given players have statuses
    When I view status
    Then I should see availability
    And waivers should be indicated

  @happy-path @free-agent-list
  Scenario: View free agent count
    Given free agents exist
    When I view count
    Then I should see total available
    And count should be accurate

  @happy-path @free-agent-list
  Scenario: Paginate free agent list
    Given many free agents exist
    When I paginate
    Then I should see pages
    And I can navigate between them

  @happy-path @free-agent-list
  Scenario: Refresh free agent list
    Given list may have changed
    When I refresh list
    Then list should update
    And changes should be reflected

  @happy-path @free-agent-list
  Scenario: View free agents by bye week
    Given bye weeks exist
    When I filter by bye
    Then I should see filtered results
    And bye weeks should be considered

  @happy-path @free-agent-list
  Scenario: View recently dropped players
    Given players were dropped
    When I view recently dropped
    Then I should see dropped players
    And drop date should be shown

  # ============================================================================
  # FREE AGENT SEARCH
  # ============================================================================

  @happy-path @free-agent-search
  Scenario: Search players by name
    Given I know player name
    When I search by name
    Then I should see matching players
    And results should be relevant

  @happy-path @free-agent-search
  Scenario: Use advanced filters
    Given advanced filters exist
    When I apply advanced filters
    Then I should see filtered results
    And all criteria should match

  @happy-path @free-agent-search
  Scenario: Sort search results
    Given results exist
    When I sort results
    Then results should be sorted
    And order should match selection

  @happy-path @free-agent-search
  Scenario: Use quick filters
    Given quick filters exist
    When I use quick filter
    Then filter should apply immediately
    And results should update

  @happy-path @free-agent-search
  Scenario: Save search
    Given I have useful search
    When I save search
    Then search should be saved
    And I can reuse later

  @happy-path @free-agent-search
  Scenario: Load saved search
    Given saved search exists
    When I load search
    Then filters should apply
    And results should match

  @happy-path @free-agent-search
  Scenario: Delete saved search
    Given saved search exists
    When I delete search
    Then search should be removed
    And I should confirm first

  @happy-path @free-agent-search
  Scenario: Clear all filters
    Given filters are applied
    When I clear filters
    Then all filters should reset
    And full list should show

  @happy-path @free-agent-search
  Scenario: Search with autocomplete
    Given I start typing
    When autocomplete appears
    Then I should see suggestions
    And I can select one

  @happy-path @free-agent-search
  Scenario: Search by stat threshold
    Given stat data exists
    When I set stat threshold
    Then I should see players meeting threshold
    And stats should be compared

  # ============================================================================
  # FREE AGENT PICKUP
  # ============================================================================

  @happy-path @free-agent-pickup
  Scenario: Add player to roster
    Given I have roster space
    When I add player
    Then player should be added
    And roster should update

  @happy-path @free-agent-pickup
  Scenario: Drop player from roster
    Given I have player to drop
    When I drop player
    Then player should be dropped
    And they become free agent

  @happy-path @free-agent-pickup
  Scenario: Complete add/drop transaction
    Given I need to swap
    When I complete add/drop
    Then transaction should process
    And both moves should complete

  @happy-path @free-agent-pickup
  Scenario: Check roster space
    Given roster has limits
    When I check space
    Then I should see available spots
    And limits should be clear

  @happy-path @free-agent-pickup
  Scenario: Confirm transaction
    Given I am making move
    When I confirm transaction
    Then I should see confirmation
    And move should complete

  @error @free-agent-pickup
  Scenario: Handle full roster
    Given roster is full
    When I try to add
    Then I should see error
    And I must drop someone first

  @happy-path @free-agent-pickup
  Scenario: View transaction preview
    Given I am making move
    When I preview transaction
    Then I should see impact
    And I can proceed or cancel

  @happy-path @free-agent-pickup
  Scenario: Cancel pending pickup
    Given pickup is pending
    When I cancel pickup
    Then pickup should be cancelled
    And player remains available

  @happy-path @free-agent-pickup
  Scenario: View pickup restrictions
    Given restrictions exist
    When I view restrictions
    Then I should see rules
    And eligibility should be clear

  @happy-path @free-agent-pickup
  Scenario: Complete immediate pickup
    Given player is free agent
    When I pick up immediately
    Then player should be added now
    And no waiting period

  # ============================================================================
  # FREE AGENT BIDDING
  # ============================================================================

  @happy-path @free-agent-bidding
  Scenario: Place FAAB bid
    Given FAAB is enabled
    When I place bid
    Then bid should be submitted
    And I should see confirmation

  @happy-path @free-agent-bidding
  Scenario: Set bid amount
    Given I am bidding
    When I set amount
    Then amount should be saved
    And it should be within budget

  @happy-path @free-agent-bidding
  Scenario: View bid deadline
    Given deadline exists
    When I view deadline
    Then I should see deadline time
    And countdown should be shown

  @happy-path @free-agent-bidding
  Scenario: Submit blind bid
    Given blind bidding is enabled
    When I submit bid
    Then bid should be hidden
    And others cannot see amount

  @happy-path @free-agent-bidding
  Scenario: View bid results
    Given bids have processed
    When I view results
    Then I should see outcomes
    And winning bids should be shown

  @happy-path @free-agent-bidding
  Scenario: Modify existing bid
    Given I have pending bid
    When I modify bid
    Then changes should be saved
    And new amount should apply

  @happy-path @free-agent-bidding
  Scenario: Cancel bid
    Given I have pending bid
    When I cancel bid
    Then bid should be cancelled
    And budget should be restored

  @happy-path @free-agent-bidding
  Scenario: View remaining FAAB budget
    Given FAAB is tracked
    When I view budget
    Then I should see remaining amount
    And spent should be shown

  @happy-path @free-agent-bidding
  Scenario: Set conditional bid
    Given conditions are allowed
    When I set conditional bid
    Then condition should be saved
    And it should process accordingly

  @happy-path @free-agent-bidding
  Scenario: View bidding history
    Given bids have occurred
    When I view history
    Then I should see past bids
    And outcomes should be shown

  # ============================================================================
  # FREE AGENT RECOMMENDATIONS
  # ============================================================================

  @happy-path @free-agent-recommendations
  Scenario: View recommended pickups
    Given recommendations exist
    When I view recommendations
    Then I should see suggested players
    And reasoning should be provided

  @happy-path @free-agent-recommendations
  Scenario: View trending adds
    Given trending data exists
    When I view trending
    Then I should see most added
    And trend should be indicated

  @happy-path @free-agent-recommendations
  Scenario: View hot players
    Given hot players exist
    When I view hot players
    Then I should see breakout candidates
    And heat should be indicated

  @happy-path @free-agent-recommendations
  Scenario: View sleeper picks
    Given sleepers exist
    When I view sleepers
    Then I should see under-radar players
    And potential should be shown

  @happy-path @free-agent-recommendations
  Scenario: View matchup streamers
    Given streaming is relevant
    When I view streamers
    Then I should see good matchups
    And week should be specified

  @happy-path @free-agent-recommendations
  Scenario: Get personalized recommendations
    Given my team is analyzed
    When I get recommendations
    Then they should fit my needs
    And weaknesses should be addressed

  @happy-path @free-agent-recommendations
  Scenario: Filter recommendations by position
    Given recommendations exist
    When I filter by position
    Then I should see position-specific picks
    And relevance should remain

  @happy-path @free-agent-recommendations
  Scenario: View recommendation reasoning
    Given recommendation exists
    When I view reasoning
    Then I should see why recommended
    And factors should be explained

  @happy-path @free-agent-recommendations
  Scenario: Dismiss recommendation
    Given recommendation exists
    When I dismiss it
    Then it should be removed
    And I won't see it again

  @happy-path @free-agent-recommendations
  Scenario: Save recommendation for later
    Given recommendation exists
    When I save it
    Then it should be bookmarked
    And I can review later

  # ============================================================================
  # FREE AGENT STATS
  # ============================================================================

  @happy-path @free-agent-stats
  Scenario: View player statistics
    Given player has stats
    When I view stats
    Then I should see full statistics
    And all categories should be shown

  @happy-path @free-agent-stats
  Scenario: View recent performance
    Given recent games exist
    When I view recent performance
    Then I should see last few games
    And trends should be visible

  @happy-path @free-agent-stats
  Scenario: View season stats
    Given season is ongoing
    When I view season stats
    Then I should see season totals
    And averages should be shown

  @happy-path @free-agent-stats
  Scenario: View projection stats
    Given projections exist
    When I view projections
    Then I should see expected stats
    And confidence should be indicated

  @happy-path @free-agent-stats
  Scenario: View matchup stats
    Given matchup data exists
    When I view matchup stats
    Then I should see vs opponent
    And historical should be shown

  @happy-path @free-agent-stats
  Scenario: Compare stats to position average
    Given averages exist
    When I compare to average
    Then I should see comparison
    And above/below should be clear

  @happy-path @free-agent-stats
  Scenario: View advanced stats
    Given advanced metrics exist
    When I view advanced stats
    Then I should see advanced metrics
    And explanations should be available

  @happy-path @free-agent-stats
  Scenario: View target share stats
    Given target data exists
    When I view targets
    Then I should see target share
    And opportunity should be clear

  @happy-path @free-agent-stats
  Scenario: View red zone stats
    Given red zone data exists
    When I view red zone stats
    Then I should see red zone usage
    And TD potential should be shown

  @happy-path @free-agent-stats
  Scenario: Export player stats
    Given stats exist
    When I export stats
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # FREE AGENT NEWS
  # ============================================================================

  @happy-path @free-agent-news
  Scenario: View player updates
    Given updates exist
    When I view updates
    Then I should see recent news
    And relevance should be clear

  @happy-path @free-agent-news
  Scenario: View injury news
    Given injury news exists
    When I view injury news
    Then I should see injury updates
    And status should be current

  @happy-path @free-agent-news
  Scenario: View depth chart changes
    Given depth changed
    When I view depth changes
    Then I should see movement
    And impact should be explained

  @happy-path @free-agent-news
  Scenario: View opportunity alerts
    Given opportunities exist
    When I view opportunity alerts
    Then I should see opportunities
    And I can take action

  @happy-path @free-agent-news
  Scenario: View breakout candidates
    Given breakouts are predicted
    When I view breakouts
    Then I should see candidates
    And reasoning should be shown

  @happy-path @free-agent-news
  Scenario: Filter news by relevance
    Given news exists
    When I filter by relevance
    Then I should see most relevant
    And importance should be clear

  @happy-path @free-agent-news
  Scenario: Subscribe to player news
    Given player interests me
    When I subscribe to news
    Then I should receive updates
    And they should be timely

  @happy-path @free-agent-news
  Scenario: View news timeline
    Given news history exists
    When I view timeline
    Then I should see chronological news
    And dates should be shown

  @happy-path @free-agent-news
  Scenario: Share news item
    Given news item exists
    When I share news
    Then shareable link should be created
    And I can share with others

  @happy-path @free-agent-news
  Scenario: Mark news as read
    Given unread news exists
    When I mark as read
    Then news should be marked
    And it should be less prominent

  # ============================================================================
  # FREE AGENT OWNERSHIP
  # ============================================================================

  @happy-path @free-agent-ownership
  Scenario: View ownership trends
    Given ownership is tracked
    When I view trends
    Then I should see ownership changes
    And direction should be clear

  @happy-path @free-agent-ownership
  Scenario: View add percentage
    Given add data exists
    When I view add percentage
    Then I should see add rate
    And trend should be shown

  @happy-path @free-agent-ownership
  Scenario: View drop percentage
    Given drop data exists
    When I view drop percentage
    Then I should see drop rate
    And trend should be shown

  @happy-path @free-agent-ownership
  Scenario: View start percentage
    Given start data exists
    When I view start percentage
    Then I should see start rate
    And confidence should be indicated

  @happy-path @free-agent-ownership
  Scenario: View roster percentage
    Given roster data exists
    When I view roster percentage
    Then I should see ownership rate
    And league context should be shown

  @happy-path @free-agent-ownership
  Scenario: Compare ownership across platforms
    Given multi-platform data exists
    When I compare platforms
    Then I should see comparison
    And differences should be highlighted

  @happy-path @free-agent-ownership
  Scenario: View ownership history
    Given history is tracked
    When I view history
    Then I should see ownership over time
    And trends should be visible

  @happy-path @free-agent-ownership
  Scenario: Sort by ownership
    Given ownership data exists
    When I sort by ownership
    Then players should sort by ownership
    And order should be correct

  @happy-path @free-agent-ownership
  Scenario: View under-owned players
    Given ownership varies
    When I view under-owned
    Then I should see low ownership players
    And potential should be indicated

  @happy-path @free-agent-ownership
  Scenario: Receive ownership change alerts
    Given alerts are enabled
    When ownership changes significantly
    Then I should receive alert
    And change should be shown

  # ============================================================================
  # FREE AGENT COMPARISON
  # ============================================================================

  @happy-path @free-agent-comparison
  Scenario: Compare players
    Given I select players
    When I compare them
    Then I should see comparison
    And stats should be side-by-side

  @happy-path @free-agent-comparison
  Scenario: View side-by-side stats
    Given comparison is displayed
    When I view stats
    Then I should see all stats
    And differences should be highlighted

  @happy-path @free-agent-comparison
  Scenario: Compare player values
    Given values exist
    When I compare values
    Then I should see value comparison
    And better value should be indicated

  @happy-path @free-agent-comparison
  Scenario: Compare schedules
    Given schedules exist
    When I compare schedules
    Then I should see schedule comparison
    And difficulty should be shown

  @happy-path @free-agent-comparison
  Scenario: View opportunity analysis
    Given opportunity data exists
    When I view analysis
    Then I should see opportunity comparison
    And upside should be indicated

  @happy-path @free-agent-comparison
  Scenario: Add player to comparison
    Given comparison exists
    When I add player
    Then player should be added
    And comparison should update

  @happy-path @free-agent-comparison
  Scenario: Remove player from comparison
    Given comparison exists
    When I remove player
    Then player should be removed
    And comparison should update

  @happy-path @free-agent-comparison
  Scenario: Save comparison
    Given comparison is displayed
    When I save comparison
    Then comparison should be saved
    And I can access later

  @happy-path @free-agent-comparison
  Scenario: Share comparison
    Given comparison is displayed
    When I share comparison
    Then shareable link should be created
    And others can view

  @happy-path @free-agent-comparison
  Scenario: View comparison recommendations
    Given comparison exists
    When I view recommendations
    Then I should see suggested pick
    And reasoning should be provided

  # ============================================================================
  # FREE AGENT ALERTS
  # ============================================================================

  @happy-path @free-agent-alerts
  Scenario: Set availability alert
    Given player is owned
    When I set availability alert
    Then alert should be saved
    And I will be notified when available

  @happy-path @free-agent-alerts
  Scenario: Receive player notification
    Given notification is set
    When trigger occurs
    Then I should receive notification
    And I can take action

  @happy-path @free-agent-alerts
  Scenario: Set watchlist alert
    Given player is on watchlist
    When I set alert
    Then alert should be saved
    And I will be notified of changes

  @happy-path @free-agent-alerts
  Scenario: Set price alert
    Given FAAB is enabled
    When I set price alert
    Then alert should be saved
    And I will be notified of bids

  @happy-path @free-agent-alerts
  Scenario: Receive hot pickup alert
    Given player is trending
    When threshold is reached
    Then I should receive alert
    And urgency should be indicated

  @happy-path @free-agent-alerts
  Scenario: Configure alert preferences
    Given preferences exist
    When I configure alerts
    Then preferences should be saved
    And alerts should follow them

  @happy-path @free-agent-alerts
  Scenario: View active alerts
    Given I have alerts set
    When I view alerts
    Then I should see all alerts
    And status should be shown

  @happy-path @free-agent-alerts
  Scenario: Delete alert
    Given alert exists
    When I delete alert
    Then alert should be removed
    And I should confirm first

  @happy-path @free-agent-alerts
  Scenario: Pause alerts temporarily
    Given I need break
    When I pause alerts
    Then alerts should pause
    And I can resume later

  @happy-path @free-agent-alerts
  Scenario: View alert history
    Given alerts have triggered
    When I view history
    Then I should see past alerts
    And actions should be shown

