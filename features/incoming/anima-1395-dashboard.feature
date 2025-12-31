@dashboard @anima-1395
Feature: Dashboard
  As a fantasy football user
  I want a comprehensive dashboard
  So that I can quickly view and manage my fantasy experience

  Background:
    Given I am a logged-in user
    And the dashboard system is available

  # ============================================================================
  # DASHBOARD HOME
  # ============================================================================

  @happy-path @dashboard-home
  Scenario: View homepage
    Given I have active leagues
    When I view the dashboard
    Then I should see the homepage
    And key information should be displayed

  @happy-path @dashboard-home
  Scenario: View quick stats
    Given stats are available
    When I view quick stats
    Then I should see summary statistics
    And stats should be current

  @happy-path @dashboard-home
  Scenario: View league overview
    Given I have leagues
    When I view league overview
    Then I should see all my leagues
    And status should be shown for each

  @happy-path @dashboard-home
  Scenario: View matchup summary
    Given I have active matchups
    When I view matchup summary
    Then I should see current matchups
    And scores should be displayed

  @happy-path @dashboard-home
  Scenario: View notification feed
    Given notifications exist
    When I view notification feed
    Then I should see recent notifications
    And they should be organized

  @happy-path @dashboard-home
  Scenario: Refresh dashboard
    Given dashboard is displayed
    When I refresh dashboard
    Then data should be updated
    And I should see current info

  @happy-path @dashboard-home
  Scenario: View dashboard on mobile
    Given I am on mobile device
    When I view dashboard
    Then dashboard should be mobile-friendly
    And all info should be accessible

  @happy-path @dashboard-home
  Scenario: Navigate from dashboard
    Given dashboard is displayed
    When I click on an item
    Then I should navigate to details
    And context should be maintained

  @happy-path @dashboard-home
  Scenario: View multi-league summary
    Given I have multiple leagues
    When I view summary
    Then I should see all leagues
    And I can expand each

  @happy-path @dashboard-home
  Scenario: Collapse dashboard sections
    Given sections are expanded
    When I collapse a section
    Then section should collapse
    And I can expand later

  # ============================================================================
  # DASHBOARD WIDGETS
  # ============================================================================

  @happy-path @dashboard-widgets
  Scenario: View widget library
    Given widgets are available
    When I view widget library
    Then I should see all widgets
    And descriptions should be shown

  @happy-path @dashboard-widgets
  Scenario: Add widget to dashboard
    Given I want to add widget
    When I add a widget
    Then widget should be added
    And it should display on dashboard

  @happy-path @dashboard-widgets
  Scenario: Remove widget from dashboard
    Given widget is on dashboard
    When I remove widget
    Then widget should be removed
    And dashboard should update

  @happy-path @dashboard-widgets
  Scenario: Resize widget
    Given widget supports resizing
    When I resize widget
    Then widget should resize
    And content should adapt

  @happy-path @dashboard-widgets
  Scenario: Rearrange widgets
    Given multiple widgets exist
    When I rearrange widgets
    Then new arrangement should be saved
    And layout should update

  @happy-path @dashboard-widgets
  Scenario: Configure widget settings
    Given widget has settings
    When I configure widget
    Then settings should be saved
    And widget should behave accordingly

  @happy-path @dashboard-widgets
  Scenario: Minimize widget
    Given widget is displayed
    When I minimize widget
    Then widget should be minimized
    And I can expand later

  @happy-path @dashboard-widgets
  Scenario: Maximize widget
    Given widget is normal size
    When I maximize widget
    Then widget should fill screen
    And I can restore later

  @happy-path @dashboard-widgets
  Scenario: Refresh individual widget
    Given widget displays data
    When I refresh widget
    Then widget data should update
    And other widgets stay same

  @happy-path @dashboard-widgets
  Scenario: Duplicate widget
    Given widget exists
    When I duplicate widget
    Then copy should be created
    And I can configure separately

  # ============================================================================
  # DASHBOARD CUSTOMIZATION
  # ============================================================================

  @happy-path @dashboard-customization
  Scenario: Choose layout option
    Given layouts are available
    When I choose a layout
    Then layout should be applied
    And widgets should rearrange

  @happy-path @dashboard-customization
  Scenario: Select dashboard theme
    Given themes are available
    When I select theme
    Then theme should be applied
    And dashboard should reflect theme

  @happy-path @dashboard-customization
  Scenario: Set default view
    Given view options exist
    When I set default view
    Then default should be saved
    And dashboard should open to that view

  @happy-path @dashboard-customization
  Scenario: Save current layout
    Given I have arranged widgets
    When I save layout
    Then layout should be saved
    And I can load it later

  @happy-path @dashboard-customization
  Scenario: Load saved layout
    Given saved layouts exist
    When I load a layout
    Then layout should be applied
    And widgets should arrange accordingly

  @happy-path @dashboard-customization
  Scenario: Reset layout to default
    Given I have custom layout
    When I reset layout
    Then default layout should be restored
    And I should confirm first

  @happy-path @dashboard-customization
  Scenario: Delete saved layout
    Given saved layout exists
    When I delete layout
    Then layout should be removed
    And I should confirm first

  @happy-path @dashboard-customization
  Scenario: Rename saved layout
    Given saved layout exists
    When I rename layout
    Then new name should be saved
    And it should appear in list

  @happy-path @dashboard-customization
  Scenario: Share dashboard layout
    Given I have custom layout
    When I share layout
    Then shareable link should be created
    And others can import it

  @happy-path @dashboard-customization
  Scenario: Import shared layout
    Given I have layout link
    When I import layout
    Then layout should be applied
    And I can customize further

  # ============================================================================
  # LIVE SCORES WIDGET
  # ============================================================================

  @happy-path @live-scores-widget
  Scenario: View real-time scores
    Given games are in progress
    When I view live scores
    Then I should see current scores
    And scores should update in real-time

  @happy-path @live-scores-widget
  Scenario: View game progress
    Given game is ongoing
    When I view game progress
    Then I should see quarter and time
    And status should be current

  @happy-path @live-scores-widget
  Scenario: View scoring plays
    Given scoring has occurred
    When I view scoring plays
    Then I should see recent scores
    And player details should be shown

  @happy-path @live-scores-widget
  Scenario: Receive red zone alerts
    Given team is in red zone
    When red zone is entered
    Then I should see alert
    And opportunity should be highlighted

  @happy-path @live-scores-widget
  Scenario: View game status
    Given games are scheduled
    When I view game status
    Then I should see all game statuses
    And times should be shown

  @happy-path @live-scores-widget
  Scenario: Filter by my players
    Given I have active players
    When I filter by my players
    Then I should see only my players' games
    And their stats should be shown

  @happy-path @live-scores-widget
  Scenario: Expand game details
    Given game is displayed
    When I expand game
    Then I should see full details
    And stats should be comprehensive

  @happy-path @live-scores-widget
  Scenario: View halftime stats
    Given game is at halftime
    When I view stats
    Then I should see first half stats
    And projections should update

  @happy-path @live-scores-widget
  Scenario: View final scores
    Given games have ended
    When I view final scores
    Then I should see final results
    And stats should be complete

  @happy-path @live-scores-widget
  Scenario: Configure live score alerts
    Given alerts are available
    When I configure alerts
    Then settings should be saved
    And I should receive alerts

  # ============================================================================
  # MATCHUP WIDGET
  # ============================================================================

  @happy-path @matchup-widget
  Scenario: View current matchup
    Given I have a matchup
    When I view matchup widget
    Then I should see current matchup
    And scores should be displayed

  @happy-path @matchup-widget
  Scenario: View opponent roster
    Given matchup exists
    When I view opponent roster
    Then I should see opponent's players
    And their performance should be shown

  @happy-path @matchup-widget
  Scenario: View projected scores
    Given projections exist
    When I view projected scores
    Then I should see projections
    And confidence should be indicated

  @happy-path @matchup-widget
  Scenario: View live comparison
    Given matchup is in progress
    When I view comparison
    Then I should see side-by-side comparison
    And differences should be highlighted

  @happy-path @matchup-widget
  Scenario: View win probability
    Given probability is calculated
    When I view win probability
    Then I should see my chances
    And it should update in real-time

  @happy-path @matchup-widget
  Scenario: View position-by-position breakdown
    Given matchup exists
    When I view breakdown
    Then I should see position comparison
    And advantages should be shown

  @happy-path @matchup-widget
  Scenario: View matchup history
    Given we have played before
    When I view history
    Then I should see past meetings
    And records should be shown

  @happy-path @matchup-widget
  Scenario: View player-to-player comparison
    Given matchup exists
    When I compare players
    Then I should see player comparison
    And stats should be compared

  @happy-path @matchup-widget
  Scenario: View key players
    Given matchup exists
    When I view key players
    Then I should see impact players
    And importance should be indicated

  @happy-path @matchup-widget
  Scenario: Navigate to full matchup
    Given matchup widget is displayed
    When I click for more
    Then I should go to full matchup page
    And all details should be available

  # ============================================================================
  # STANDINGS WIDGET
  # ============================================================================

  @happy-path @standings-widget
  Scenario: View league standings
    Given standings exist
    When I view standings widget
    Then I should see current standings
    And my position should be highlighted

  @happy-path @standings-widget
  Scenario: View division standings
    Given divisions exist
    When I view division standings
    Then I should see division rankings
    And leaders should be clear

  @happy-path @standings-widget
  Scenario: View playoff picture
    Given playoff race exists
    When I view playoff picture
    Then I should see who's in
    And clinch/elimination status should be shown

  @happy-path @standings-widget
  Scenario: View standings trends
    Given weeks have passed
    When I view trends
    Then I should see position changes
    And movement should be indicated

  @happy-path @standings-widget
  Scenario: View power rankings
    Given power rankings exist
    When I view power rankings
    Then I should see rankings
    And methodology should be clear

  @happy-path @standings-widget
  Scenario: Compare to last week
    Given previous week exists
    When I compare standings
    Then I should see changes
    And movers should be highlighted

  @happy-path @standings-widget
  Scenario: View points standings
    Given points are tracked
    When I view points standings
    Then I should see points-based ranking
    And total points should be shown

  @happy-path @standings-widget
  Scenario: Filter standings by metric
    Given metrics exist
    When I filter by metric
    Then standings should re-sort
    And selected metric should be shown

  @happy-path @standings-widget
  Scenario: Expand team details
    Given standings are shown
    When I expand a team
    Then I should see team details
    And stats should be comprehensive

  @happy-path @standings-widget
  Scenario: Navigate to full standings
    Given standings widget is displayed
    When I click for more
    Then I should go to full standings page
    And all details should be available

  # ============================================================================
  # PLAYER NEWS WIDGET
  # ============================================================================

  @happy-path @player-news-widget
  Scenario: View breaking news
    Given breaking news exists
    When I view news widget
    Then I should see breaking news
    And urgency should be indicated

  @happy-path @player-news-widget
  Scenario: View injury updates
    Given injury news exists
    When I view injury updates
    Then I should see injury news
    And status should be current

  @happy-path @player-news-widget
  Scenario: View transaction alerts
    Given transactions occurred
    When I view transaction alerts
    Then I should see recent moves
    And details should be shown

  @happy-path @player-news-widget
  Scenario: View trending players
    Given players are trending
    When I view trending
    Then I should see trending players
    And trend direction should be shown

  @happy-path @player-news-widget
  Scenario: View expert analysis
    Given analysis exists
    When I view expert analysis
    Then I should see expert takes
    And source should be shown

  @happy-path @player-news-widget
  Scenario: Filter news by my players
    Given I have players
    When I filter by my players
    Then I should see news for my players
    And relevance should be clear

  @happy-path @player-news-widget
  Scenario: Mark news as read
    Given news item exists
    When I mark as read
    Then item should be marked
    And it should be less prominent

  @happy-path @player-news-widget
  Scenario: Share news item
    Given news item exists
    When I share news
    Then shareable link should be created
    And I can share with others

  @happy-path @player-news-widget
  Scenario: Set news preferences
    Given preferences exist
    When I set news preferences
    Then preferences should be saved
    And news should follow preferences

  @happy-path @player-news-widget
  Scenario: Navigate to full news
    Given news widget is displayed
    When I click for more
    Then I should go to full news page
    And all news should be available

  # ============================================================================
  # QUICK ACTIONS
  # ============================================================================

  @happy-path @quick-actions
  Scenario: Set lineup from dashboard
    Given I need to set lineup
    When I use set lineup action
    Then I should be taken to lineup
    And I can make changes

  @happy-path @quick-actions
  Scenario: Make trade from dashboard
    Given I want to trade
    When I use make trade action
    Then I should be taken to trade
    And I can propose trade

  @happy-path @quick-actions
  Scenario: Submit waiver claim from dashboard
    Given waivers are available
    When I use waiver action
    Then I should be taken to waivers
    And I can submit claim

  @happy-path @quick-actions
  Scenario: Send message from dashboard
    Given I want to message
    When I use send message action
    Then I should be taken to messaging
    And I can compose message

  @happy-path @quick-actions
  Scenario: View schedule from dashboard
    Given schedule exists
    When I use view schedule action
    Then I should be taken to schedule
    And full schedule should be shown

  @happy-path @quick-actions
  Scenario: Customize quick actions
    Given actions are available
    When I customize quick actions
    Then my preferred actions should be saved
    And they should appear on dashboard

  @happy-path @quick-actions
  Scenario: Reorder quick actions
    Given I have quick actions
    When I reorder them
    Then new order should be saved
    And they should appear in order

  @happy-path @quick-actions
  Scenario: Add quick action
    Given more actions are available
    When I add action
    Then action should be added
    And it should appear on dashboard

  @happy-path @quick-actions
  Scenario: Remove quick action
    Given action is on dashboard
    When I remove action
    Then action should be removed
    And dashboard should update

  @happy-path @quick-actions
  Scenario: Use keyboard shortcut
    Given shortcuts are enabled
    When I use keyboard shortcut
    Then corresponding action should execute
    And I should navigate appropriately

  # ============================================================================
  # DASHBOARD FILTERS
  # ============================================================================

  @happy-path @dashboard-filters
  Scenario: Select week
    Given multiple weeks exist
    When I select a week
    Then dashboard should show that week
    And data should reflect selection

  @happy-path @dashboard-filters
  Scenario: Select league
    Given I have multiple leagues
    When I select a league
    Then dashboard should show that league
    And data should reflect selection

  @happy-path @dashboard-filters
  Scenario: Select team
    Given I have multiple teams
    When I select a team
    Then dashboard should show that team
    And data should reflect selection

  @happy-path @dashboard-filters
  Scenario: Set date range
    Given date range is supported
    When I set date range
    Then dashboard should filter by dates
    And data should be within range

  @happy-path @dashboard-filters
  Scenario: Apply custom filter
    Given custom filters are available
    When I apply custom filter
    Then filter should be applied
    And data should match criteria

  @happy-path @dashboard-filters
  Scenario: Save filter combination
    Given I have filters applied
    When I save filter combination
    Then combination should be saved
    And I can apply it later

  @happy-path @dashboard-filters
  Scenario: Clear all filters
    Given filters are applied
    When I clear all filters
    Then all filters should reset
    And full data should be shown

  @happy-path @dashboard-filters
  Scenario: Load saved filter
    Given saved filter exists
    When I load saved filter
    Then filter should be applied
    And data should match

  @happy-path @dashboard-filters
  Scenario: Set default filter
    Given I have preferred filter
    When I set as default
    Then filter should apply on load
    And I can change if needed

  @happy-path @dashboard-filters
  Scenario: View filter history
    Given I have applied filters
    When I view filter history
    Then I should see recent filters
    And I can reapply them

  # ============================================================================
  # DASHBOARD ANALYTICS
  # ============================================================================

  @happy-path @dashboard-analytics
  Scenario: View performance trends
    Given performance data exists
    When I view trends
    Then I should see performance over time
    And trajectory should be clear

  @happy-path @dashboard-analytics
  Scenario: View season summary
    Given season data exists
    When I view season summary
    Then I should see season overview
    And key stats should be highlighted

  @happy-path @dashboard-analytics
  Scenario: View weekly recap
    Given week has completed
    When I view weekly recap
    Then I should see week summary
    And highlights should be shown

  @happy-path @dashboard-analytics
  Scenario: View comparative analysis
    Given comparison data exists
    When I view analysis
    Then I should see comparisons
    And insights should be provided

  @happy-path @dashboard-analytics
  Scenario: View historical data
    Given history exists
    When I view historical data
    Then I should see past performance
    And I can drill down

  @happy-path @dashboard-analytics
  Scenario: Export analytics
    Given analytics are displayed
    When I export analytics
    Then I should receive export file
    And data should be complete

  @happy-path @dashboard-analytics
  Scenario: Share analytics
    Given analytics are displayed
    When I share analytics
    Then shareable link should be created
    And others can view

  @happy-path @dashboard-analytics
  Scenario: Customize analytics view
    Given analytics exist
    When I customize view
    Then view should be saved
    And analytics should reflect preferences

  @happy-path @dashboard-analytics
  Scenario: Set analytics time period
    Given periods are available
    When I set time period
    Then analytics should adjust
    And data should match period

  @happy-path @dashboard-analytics
  Scenario: Compare analytics across leagues
    Given I have multiple leagues
    When I compare analytics
    Then I should see cross-league comparison
    And patterns should be visible

