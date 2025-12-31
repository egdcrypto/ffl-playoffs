@dashboard @ANIMA-1329
Feature: Dashboard
  As a fantasy football team manager
  I want a comprehensive dashboard view
  So that I can quickly access all important information and take action

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a team manager
    And I have at least one active team

  # ============================================================================
  # LEAGUE OVERVIEW - HAPPY PATH
  # ============================================================================

  @happy-path @league-overview
  Scenario: View league overview on dashboard
    Given I am on the main dashboard
    When I view the league overview section
    Then I should see my active leagues
    And I should see my position in each league
    And I should see league activity summary

  @happy-path @league-overview
  Scenario: Switch between multiple leagues
    Given I have multiple active leagues
    When I switch between leagues on dashboard
    Then the dashboard should update for selected league
    And all widgets should reflect the active league
    And the switch should be seamless

  @happy-path @league-overview
  Scenario: View league at a glance
    Given I am viewing the dashboard
    When I check the league summary
    Then I should see total teams
    And I should see current week
    And I should see playoff race status

  @happy-path @league-overview
  Scenario: View league alerts
    Given there are league-wide alerts
    When I view the dashboard
    Then I should see important alerts prominently
    And alerts should indicate urgency
    And I should be able to dismiss or act on them

  # ============================================================================
  # TEAM SUMMARY
  # ============================================================================

  @happy-path @team-summary
  Scenario: View team summary widget
    Given I am on the dashboard
    When I view my team summary
    Then I should see my current record
    And I should see my standings position
    And I should see my total points

  @happy-path @team-summary
  Scenario: View team roster snapshot
    Given I am viewing team summary
    When I check roster snapshot
    Then I should see key starters
    And I should see injury indicators
    And I should see bye week warnings

  @happy-path @team-summary
  Scenario: View team performance trend
    Given I am viewing team summary
    When I view performance trend
    Then I should see recent scoring trend
    And I should see win/loss streak
    And I should see trajectory indicator

  @happy-path @team-summary
  Scenario: Quick access to team management
    Given I am viewing my team summary
    When I click on team actions
    Then I should see quick action buttons
    And I should access roster management
    And I should access lineup setting

  @happy-path @team-summary
  Scenario: View team health report
    Given I have injured players
    When I view team health
    Then I should see injury statuses
    And I should see expected return dates
    And I should see lineup impact

  # ============================================================================
  # UPCOMING MATCHUPS
  # ============================================================================

  @happy-path @upcoming-matchups
  Scenario: View current week matchup
    Given I am on the dashboard
    When I view my upcoming matchup
    Then I should see my opponent
    And I should see projected scores
    And I should see win probability

  @happy-path @upcoming-matchups
  Scenario: View matchup preview details
    Given I am viewing matchup widget
    When I expand matchup preview
    Then I should see key player matchups
    And I should see advantages and disadvantages
    And I should see recommended actions

  @happy-path @upcoming-matchups
  Scenario: View opponent information
    Given I am viewing my matchup
    When I check opponent details
    Then I should see opponent's record
    And I should see their projected lineup
    And I should see their recent performance

  @happy-path @upcoming-matchups
  Scenario: Quick lineup check for matchup
    Given I am viewing matchup widget
    When I check my lineup status
    Then I should see if lineup is set
    And I should see empty positions if any
    And I should see quick set option

  @happy-path @upcoming-matchups
  Scenario: View countdown to game time
    Given games are approaching
    When I view the matchup widget
    Then I should see time until first game
    And I should see lineup lock countdown
    And urgency should be indicated

  # ============================================================================
  # RECENT ACTIVITY FEED
  # ============================================================================

  @happy-path @activity-feed
  Scenario: View league activity feed
    Given there is recent activity
    When I view the activity feed
    Then I should see recent transactions
    And I should see trade activity
    And I should see lineup changes

  @happy-path @activity-feed
  Scenario: Filter activity feed
    Given the activity feed has many items
    When I filter by activity type
    Then I should see only selected types
    And I should be able to clear filter
    And counts should update

  @happy-path @activity-feed
  Scenario: View activity details
    Given I see an activity item
    When I click for details
    Then I should see full activity information
    And I should see timestamp
    And I should see related actions

  @happy-path @activity-feed
  Scenario: Real-time activity updates
    Given I am viewing the activity feed
    When new activity occurs
    Then the feed should update automatically
    And new items should be highlighted
    And I should see notification indicator

  @happy-path @activity-feed
  Scenario: View my activity history
    Given I have made transactions
    When I filter to my activity
    Then I should see my recent actions
    And I should see outcomes
    And I should see timestamps

  # ============================================================================
  # QUICK ACTIONS
  # ============================================================================

  @happy-path @quick-actions
  Scenario: Access quick action buttons
    Given I am on the dashboard
    When I view quick actions
    Then I should see set lineup button
    And I should see waiver claim button
    And I should see propose trade button

  @happy-path @quick-actions
  Scenario: Quick set lineup
    Given I need to set my lineup
    When I use quick set lineup
    Then I should access lineup page directly
    And optimal lineup should be suggested
    And I should save with minimal clicks

  @happy-path @quick-actions
  Scenario: Quick waiver claim
    Given I want to make a waiver claim
    When I use quick waiver action
    Then I should access waiver page
    And recommended adds should be shown
    And I should submit claim quickly

  @happy-path @quick-actions
  Scenario: Quick propose trade
    Given I want to propose a trade
    When I use quick trade action
    Then I should access trade creation
    And trade suggestions should be shown
    And I should navigate to trade wizard

  @happy-path @quick-actions
  Scenario: Customize quick actions
    Given I want to customize shortcuts
    When I edit quick actions
    Then I should add or remove actions
    And I should reorder actions
    And preferences should be saved

  # ============================================================================
  # SCORE TICKER
  # ============================================================================

  @happy-path @score-ticker
  Scenario: View live score ticker
    Given games are in progress
    When I view the score ticker
    Then I should see real-time scores
    And I should see my matchup score
    And scores should update automatically

  @happy-path @score-ticker
  Scenario: View all league matchup scores
    Given the week is in progress
    When I expand the score ticker
    Then I should see all matchup scores
    And I should see live vs final indicators
    And I should navigate to any matchup

  @happy-path @score-ticker
  Scenario: Score ticker during game day
    Given it is game day
    When I view the ticker
    Then updates should be frequent
    And I should see scoring plays
    And my players should be highlighted

  @happy-path @score-ticker
  Scenario: Configure ticker display
    Given I want to customize the ticker
    When I adjust ticker settings
    Then I should show/hide specific info
    And I should set update frequency
    And I should set ticker position

  @happy-path @score-ticker
  Scenario: View score notifications in ticker
    Given scores are updating
    When my player scores
    Then the ticker should highlight the score
    And I should see point animation
    And the update should be prominent

  # ============================================================================
  # PLAYER NEWS HIGHLIGHTS
  # ============================================================================

  @happy-path @player-news
  Scenario: View player news on dashboard
    Given there is player news
    When I view news highlights
    Then I should see news for my players
    And I should see fantasy impact
    And I should see recency

  @happy-path @player-news
  Scenario: Filter news to my players only
    Given there is league-wide news
    When I filter to my roster
    Then I should only see my players' news
    And I should see priority ordering
    And I can expand filter

  @happy-path @player-news
  Scenario: View breaking news alert
    Given breaking news affects my player
    When news is published
    Then I should see alert on dashboard
    And the news should be prominent
    And I should see recommended action

  @happy-path @player-news
  Scenario: Read full news article
    Given I see a news headline
    When I click to read more
    Then I should see full article
    And I should see analysis
    And I should return to dashboard easily

  @happy-path @player-news
  Scenario: Share player news
    Given I see interesting news
    When I share the news
    Then I should share to league chat
    And I should share externally
    And share should include context

  # ============================================================================
  # WAIVER WIRE SUGGESTIONS
  # ============================================================================

  @happy-path @waiver-suggestions
  Scenario: View waiver wire suggestions
    Given I am on the dashboard
    When I view waiver suggestions
    Then I should see recommended adds
    And I should see reasoning
    And I should see one-click add option

  @happy-path @waiver-suggestions
  Scenario: View suggestions based on my needs
    Given my team has weaknesses
    When I view personalized suggestions
    Then suggestions should address my needs
    And I should see priority ranking
    And I should see who to drop

  @happy-path @waiver-suggestions
  Scenario: View trending waiver adds
    Given players are being added
    When I view trending adds
    Then I should see most added players
    And I should see add percentages
    And I should see availability

  @happy-path @waiver-suggestions
  Scenario: Quick add from suggestions
    Given I see a suggested player
    When I click quick add
    Then I should be prompted for drop
    And the claim should be submitted
    And confirmation should be shown

  @happy-path @waiver-suggestions
  Scenario: Dismiss waiver suggestions
    Given I see suggestions I don't want
    When I dismiss a suggestion
    Then it should be removed
    And I should provide optional feedback
    And future suggestions should improve

  # ============================================================================
  # TRADE OFFERS
  # ============================================================================

  @happy-path @trade-offers
  Scenario: View pending trade offers
    Given I have pending trade offers
    When I view trade offers widget
    Then I should see incoming offers
    And I should see outgoing offers
    And I should see offer details

  @happy-path @trade-offers
  Scenario: Quick respond to trade offer
    Given I have an incoming offer
    When I respond from dashboard
    Then I should accept or decline
    And I should counter offer
    And the response should be processed

  @happy-path @trade-offers
  Scenario: View trade offer details
    Given I see a trade offer
    When I view offer details
    Then I should see full trade terms
    And I should see value analysis
    And I should see recommended action

  @happy-path @trade-offers
  Scenario: View trade suggestions
    Given I want trade ideas
    When I view trade suggestions
    Then I should see potential trades
    And I should see willing trade partners
    And I should see mutual benefit analysis

  @happy-path @trade-offers
  Scenario: Track trade offer status
    Given I have pending offers
    When I check offer status
    Then I should see time remaining
    And I should see if viewed
    And I should see offer history

  # ============================================================================
  # LINEUP ALERTS
  # ============================================================================

  @happy-path @lineup-alerts
  Scenario: View lineup alerts on dashboard
    Given there are lineup issues
    When I view lineup alerts
    Then I should see empty position alerts
    And I should see injured player alerts
    And I should see bye week alerts

  @happy-path @lineup-alerts
  Scenario: View injured starter alert
    Given a starter is injured
    When I view the alert
    Then I should see injury details
    And I should see replacement options
    And I should quick swap players

  @happy-path @lineup-alerts
  Scenario: View bye week alert
    Given a starter is on bye
    When I view the alert
    Then I should see which player
    And I should see bench alternatives
    And I should set replacement

  @happy-path @lineup-alerts
  Scenario: View game time decision alert
    Given a starter is game time decision
    When I view the alert
    Then I should see status update timing
    And I should see backup plan
    And I should monitor status

  @happy-path @lineup-alerts
  Scenario: Dismiss resolved alerts
    Given I have resolved an issue
    When I dismiss the alert
    Then the alert should be removed
    And my lineup should show updated
    And future alerts should show

  # ============================================================================
  # STANDINGS SNAPSHOT
  # ============================================================================

  @happy-path @standings-snapshot
  Scenario: View standings snapshot
    Given I am on the dashboard
    When I view standings widget
    Then I should see top teams
    And I should see my position
    And I should see playoff line

  @happy-path @standings-snapshot
  Scenario: View my standings context
    Given I am viewing standings
    When I check my position
    Then I should see teams around me
    And I should see games back/ahead
    And I should see playoff probability

  @happy-path @standings-snapshot
  Scenario: View division standings
    Given the league has divisions
    When I view division standings
    Then I should see my division
    And I should see division leader
    And I should see my division position

  @happy-path @standings-snapshot
  Scenario: Quick standings update
    Given the week completed
    When standings update
    Then the widget should refresh
    And I should see movement indicators
    And changes should be highlighted

  @happy-path @standings-snapshot
  Scenario: Navigate to full standings
    Given I want more standings detail
    When I click view full standings
    Then I should navigate to standings page
    And context should be preserved
    And return should be easy

  # ============================================================================
  # WEATHER AND GAME INFO
  # ============================================================================

  @happy-path @weather-game-info
  Scenario: View game weather conditions
    Given there are outdoor games
    When I view weather widget
    Then I should see weather for my players' games
    And I should see temperature and conditions
    And I should see fantasy impact

  @happy-path @weather-game-info
  Scenario: View adverse weather alert
    Given there is severe weather
    When I view weather alerts
    Then I should see weather warnings
    And I should see affected players
    And I should see lineup considerations

  @happy-path @weather-game-info
  Scenario: View game time information
    Given games are scheduled
    When I view game info
    Then I should see game times
    And I should see TV channels
    And I should see stadium info

  @happy-path @weather-game-info
  Scenario: View wind advisory for kickers
    Given there is high wind
    When I check kicker game weather
    Then I should see wind speed
    And I should see kicker impact
    And I should see alternative kickers

  @happy-path @weather-game-info
  Scenario: View dome game indicator
    Given a game is in a dome
    When I view game conditions
    Then dome games should be indicated
    And weather should show as controlled
    And no weather impact should be noted

  # ============================================================================
  # CUSTOMIZABLE DASHBOARD WIDGETS
  # ============================================================================

  @happy-path @dashboard-widgets
  Scenario: Add widget to dashboard
    Given I want to customize my dashboard
    When I add a new widget
    Then I should see available widgets
    And I should select one to add
    And it should appear on dashboard

  @happy-path @dashboard-widgets
  Scenario: Remove widget from dashboard
    Given I have a widget I don't want
    When I remove the widget
    Then it should be removed from view
    And the layout should adjust
    And I can add it back later

  @happy-path @dashboard-widgets
  Scenario: Rearrange dashboard widgets
    Given I want to reorganize
    When I drag and drop widgets
    Then widgets should be repositioned
    And the layout should be saved
    And preferences should persist

  @happy-path @dashboard-widgets
  Scenario: Resize dashboard widgets
    Given I want different widget sizes
    When I resize a widget
    Then the widget should expand or shrink
    And content should adjust
    And layout should reflow

  @happy-path @dashboard-widgets
  Scenario: Configure individual widget settings
    Given I want to customize a widget
    When I access widget settings
    Then I should set display options
    And I should set data preferences
    And settings should be saved

  @happy-path @dashboard-widgets
  Scenario: Reset dashboard to default
    Given I want to start fresh
    When I reset dashboard layout
    Then widgets should return to default
    And custom settings should clear
    And I should confirm the reset

  @happy-path @dashboard-widgets
  Scenario: Save dashboard layout
    Given I have customized my dashboard
    When I save my layout
    Then the layout should persist
    And it should load on next visit
    And I can have multiple saved layouts

  # ============================================================================
  # DASHBOARD REFRESH AND UPDATES
  # ============================================================================

  @happy-path @dashboard-updates
  Scenario: Auto-refresh dashboard data
    Given I am on the dashboard
    When time passes
    Then data should refresh automatically
    And I should see last updated time
    And refresh should be seamless

  @happy-path @dashboard-updates
  Scenario: Manual refresh dashboard
    Given I want fresh data now
    When I click refresh
    Then all widgets should update
    And I should see refresh indicator
    And new data should appear

  @happy-path @dashboard-updates
  Scenario: View update notification
    Given new data is available
    When an update occurs
    Then I should see update notification
    And I can view what changed
    And notification should be dismissable

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Dashboard fails to load
    Given I try to access dashboard
    When loading fails
    Then I should see an error message
    And I should be able to retry
    And partial data should show if possible

  @error
  Scenario: Widget fails to load
    Given a specific widget fails
    When rendering fails
    Then the widget should show error state
    And other widgets should still work
    And I should retry the widget

  @error
  Scenario: Real-time updates fail
    Given live updates are failing
    When connection is lost
    Then I should see connection warning
    And cached data should remain
    And reconnection should be attempted

  @error
  Scenario: Dashboard slow to load
    Given the dashboard is loading slowly
    When load time is excessive
    Then I should see loading indicators
    And progressive loading should occur
    And timeout should be handled

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View dashboard on mobile
    Given I am using the mobile app
    When I access the dashboard
    Then the layout should be mobile-optimized
    And widgets should stack vertically
    And touch interactions should work

  @mobile
  Scenario: Swipe between dashboard sections
    Given I am on mobile dashboard
    When I swipe between sections
    Then I should navigate smoothly
    And section indicators should show
    And current section should be clear

  @mobile
  Scenario: Mobile quick actions
    Given I am on mobile
    When I access quick actions
    Then actions should be touch-friendly
    And I should complete actions easily
    And confirmation should be clear

  @mobile
  Scenario: Mobile widget management
    Given I am customizing on mobile
    When I manage widgets
    Then I should add/remove with touch
    And I should reorder with drag
    And changes should save properly

  @mobile
  Scenario: Pull to refresh on mobile
    Given I am on mobile dashboard
    When I pull down to refresh
    Then the dashboard should refresh
    And animation should indicate refresh
    And new data should load

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate dashboard with keyboard
    Given I am using keyboard navigation
    When I navigate the dashboard
    Then all widgets should be accessible
    And focus should move logically
    And actions should work with keyboard

  @accessibility
  Scenario: Screen reader dashboard access
    Given I am using a screen reader
    When I access the dashboard
    Then widgets should be announced
    And data should be readable
    And structure should be clear

  @accessibility
  Scenario: High contrast dashboard display
    Given I have high contrast mode enabled
    When I view the dashboard
    Then widgets should be visible
    And text should be readable
    And status indicators should be clear

  @accessibility
  Scenario: Dashboard with reduced motion
    Given I have reduced motion preferences
    When I view the dashboard
    Then animations should be minimized
    And updates should be subtle
    And functionality should be preserved
