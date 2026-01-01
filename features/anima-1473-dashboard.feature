@dashboard
Feature: Dashboard
  As a fantasy football manager
  I want a comprehensive dashboard experience
  So that I can quickly access important information and take action

  # --------------------------------------------------------------------------
  # Home Dashboard
  # --------------------------------------------------------------------------

  @home-dashboard
  Scenario: View home dashboard overview
    Given I am logged in
    When I navigate to the home dashboard
    Then I should see overview widgets
    And I should see my leagues at a glance
    And I should see quick stats summary
    And I should see action items requiring attention

  @home-dashboard
  Scenario: View quick stats on home dashboard
    Given I am on the home dashboard
    When I view the quick stats section
    Then I should see my overall record across leagues
    And I should see total fantasy points scored
    And I should see current week performance
    And I should see ranking among friends

  @home-dashboard
  Scenario: See action items requiring attention
    Given I am on the home dashboard
    When I view action items
    Then I should see unset lineups
    And I should see pending trade offers
    And I should see injured players needing attention
    And I should see items prioritized by urgency

  @home-dashboard
  Scenario: View recent activity feed
    Given I am on the home dashboard
    When I view recent activity
    Then I should see my recent transactions
    And I should see league transactions
    And I should see recent matchup results
    And I should see activity timestamps

  @home-dashboard
  Scenario: Access multiple leagues from home
    Given I am on the home dashboard
    And I am a member of multiple leagues
    When I view the leagues section
    Then I should see all my leagues
    And I should see status for each league
    And I should be able to switch to any league

  @home-dashboard
  Scenario: View personalized recommendations
    Given I am on the home dashboard
    When I view recommendations
    Then I should see suggested roster moves
    And I should see waiver wire recommendations
    And I should see trade suggestions
    And recommendations should be contextual

  # --------------------------------------------------------------------------
  # League Dashboard
  # --------------------------------------------------------------------------

  @league-dashboard
  Scenario: View league standings
    Given I am on a league dashboard
    When I view the standings widget
    Then I should see current standings
    And I should see win-loss records
    And I should see points for and against
    And I should see my position highlighted

  @league-dashboard
  Scenario: View upcoming matchups
    Given I am on a league dashboard
    When I view upcoming matchups
    Then I should see this week's matchups
    And I should see projected scores
    And I should see my matchup prominently
    And I should see start times

  @league-dashboard
  Scenario: View transaction feed
    Given I am on a league dashboard
    When I view the transaction feed
    Then I should see recent trades
    And I should see waiver claims
    And I should see add/drop activity
    And I should see who made each transaction

  @league-dashboard
  Scenario: View league news
    Given I am on a league dashboard
    When I view league news
    Then I should see commissioner announcements
    And I should see recent message board posts
    And I should see league milestone notifications
    And I should see important updates

  @league-dashboard
  Scenario: View playoff race status
    Given I am on a league dashboard
    And the season is in progress
    When I view playoff race
    Then I should see playoff positions
    And I should see teams on the bubble
    And I should see clinching scenarios
    And I should see my playoff probability

  @league-dashboard
  Scenario: View league leaderboards
    Given I am on a league dashboard
    When I view leaderboards
    Then I should see scoring leaders
    And I should see position leaders
    And I should see weekly high scores
    And I should see trending players

  # --------------------------------------------------------------------------
  # Team Dashboard
  # --------------------------------------------------------------------------

  @team-dashboard
  Scenario: View team roster overview
    Given I am on my team dashboard
    When I view the roster widget
    Then I should see my full roster
    And I should see player statuses
    And I should see bye week indicators
    And I should see injury designations

  @team-dashboard
  Scenario: View lineup status
    Given I am on my team dashboard
    When I view lineup status
    Then I should see if lineup is set
    And I should see lineup warnings
    And I should see empty roster spots
    And I should see players on bye

  @team-dashboard
  Scenario: View projected points
    Given I am on my team dashboard
    When I view projected points
    Then I should see total projected points
    And I should see projections by player
    And I should see projection confidence
    And I should see comparison to opponent

  @team-dashboard
  Scenario: View injury alerts
    Given I am on my team dashboard
    When I view injury alerts
    Then I should see injured players
    And I should see injury severity
    And I should see expected return
    And I should see replacement suggestions

  @team-dashboard
  Scenario: View team performance trends
    Given I am on my team dashboard
    When I view performance trends
    Then I should see weekly scoring trend
    And I should see position group performance
    And I should see comparison to league average
    And I should see trajectory indicator

  @team-dashboard
  Scenario: View roster alerts and recommendations
    Given I am on my team dashboard
    When I view roster alerts
    Then I should see underperforming players
    And I should see breakout candidates
    And I should see trade value opportunities
    And I should see waiver targets

  # --------------------------------------------------------------------------
  # Matchup Dashboard
  # --------------------------------------------------------------------------

  @matchup-dashboard
  Scenario: View current matchup overview
    Given I have an active matchup
    When I view the matchup dashboard
    Then I should see my team vs opponent
    And I should see current scores
    And I should see remaining players
    And I should see matchup timeline

  @matchup-dashboard
  Scenario: View live scores during games
    Given games are in progress
    When I view live scores
    Then I should see real-time point updates
    And I should see player scoring breakdown
    And I should see game status
    And scores should update automatically

  @matchup-dashboard
  Scenario: View player performance details
    Given I am on the matchup dashboard
    When I view player performance
    Then I should see individual player stats
    And I should see fantasy points earned
    And I should see performance vs projection
    And I should see key plays

  @matchup-dashboard
  Scenario: View win probability
    Given I am on the matchup dashboard
    When I view win probability
    Then I should see current win probability
    And I should see probability changes over time
    And I should see key factors affecting odds
    And I should see projected final score

  @matchup-dashboard
  Scenario: View head-to-head comparison
    Given I am on the matchup dashboard
    When I view head-to-head comparison
    Then I should see position-by-position matchup
    And I should see projected point differential
    And I should see historical head-to-head record
    And I should see advantage indicators

  @matchup-dashboard
  Scenario: Track points needed to win
    Given I am on the matchup dashboard
    And the matchup is in progress
    When I view points tracker
    Then I should see points needed from remaining players
    And I should see probability of achieving points
    And I should see critical players to watch

  # --------------------------------------------------------------------------
  # Dashboard Widgets
  # --------------------------------------------------------------------------

  @dashboard-widgets
  Scenario: Add widget to dashboard
    Given I am customizing my dashboard
    When I add a widget from the library
    Then the widget should appear on my dashboard
    And I should be able to position the widget
    And the widget should display its content

  @dashboard-widgets
  Scenario: Browse widget library
    Given I am customizing my dashboard
    When I browse the widget library
    Then I should see available widgets
    And I should see widget descriptions
    And I should see widget previews
    And I should be able to filter widgets

  @dashboard-widgets
  Scenario: Configure widget settings
    Given I have a widget on my dashboard
    When I configure the widget
    Then I should see configuration options
    And I should be able to change data source
    And I should be able to set display preferences
    And changes should apply immediately

  @dashboard-widgets
  Scenario: Resize widgets
    Given I have widgets on my dashboard
    When I resize a widget
    Then the widget should change size
    And content should adapt to new size
    And other widgets should adjust layout
    And size should be saved

  @dashboard-widgets
  Scenario: Remove widget from dashboard
    Given I have a widget on my dashboard
    When I remove the widget
    Then the widget should be removed
    And other widgets should fill the space
    And I should be able to re-add the widget

  @dashboard-widgets
  Scenario: Refresh widget data
    Given I have widgets on my dashboard
    When I refresh a widget
    Then widget data should update
    And I should see refresh indicator
    And updated data should display

  # --------------------------------------------------------------------------
  # Dashboard Layout
  # --------------------------------------------------------------------------

  @dashboard-layout
  Scenario: Drag and drop widgets
    Given I am customizing my dashboard
    When I drag a widget to a new position
    Then the widget should move
    And other widgets should rearrange
    And the new layout should be saved

  @dashboard-layout
  Scenario: Use layout presets
    Given I am customizing my dashboard
    When I select a layout preset
    Then the dashboard should apply the preset
    And widgets should be arranged accordingly
    And I should be able to modify the preset

  @dashboard-layout
  Scenario: View responsive dashboard on mobile
    Given I am viewing my dashboard on mobile
    Then the layout should adapt to screen size
    And widgets should stack appropriately
    And all content should be accessible
    And I should be able to scroll through widgets

  @dashboard-layout
  Scenario: Configure multi-column layout
    Given I am customizing my dashboard
    When I configure column layout
    Then I should choose number of columns
    And widgets should arrange in columns
    And I should be able to span widgets across columns

  @dashboard-layout
  Scenario: Lock dashboard layout
    Given I have arranged my dashboard
    When I lock the layout
    Then widgets should not be movable
    And I should see locked indicator
    And I should be able to unlock to edit

  @dashboard-layout
  Scenario: Reset dashboard to default
    Given I have a customized dashboard
    When I reset to default layout
    Then dashboard should restore to default
    And my customizations should be removed
    And I should confirm before reset

  # --------------------------------------------------------------------------
  # Dashboard Personalization
  # --------------------------------------------------------------------------

  @dashboard-personalization
  Scenario: Select dashboard theme
    Given I am personalizing my dashboard
    When I select a theme
    Then the dashboard should apply the theme
    And colors should change accordingly
    And my preference should be saved

  @dashboard-personalization
  Scenario: Set favorite widgets
    Given I have widgets on my dashboard
    When I mark a widget as favorite
    Then the widget should be starred
    And favorite widgets should load first
    And favorites should persist across sessions

  @dashboard-personalization
  Scenario: Set default dashboard view
    Given I have multiple dashboard views
    When I set a default view
    Then that view should load on login
    And I should be able to change default
    And my preference should be saved

  @dashboard-personalization
  Scenario: Save custom dashboard layout
    Given I have arranged my dashboard
    When I save the layout
    Then the layout should be saved
    And I should be able to name the layout
    And I should be able to load saved layouts

  @dashboard-personalization
  Scenario: Share dashboard layout
    Given I have a saved dashboard layout
    When I share the layout
    Then I should generate shareable configuration
    And others should be able to import it
    And shared layout should be anonymized

  @dashboard-personalization
  Scenario: Import dashboard layout
    Given I have a shared layout configuration
    When I import the layout
    Then the layout should be applied
    And widgets should be configured
    And I should be able to modify after import

  # --------------------------------------------------------------------------
  # Quick Actions
  # --------------------------------------------------------------------------

  @quick-actions
  Scenario: Use one-click lineup set
    Given I am on my dashboard
    And I have lineup recommendations
    When I click quick set lineup
    Then the optimal lineup should be set
    And I should see confirmation
    And I should be able to review changes

  @quick-actions
  Scenario: Access action shortcuts
    Given I am on the dashboard
    When I access the shortcuts menu
    Then I should see common actions
    And I should see keyboard shortcuts
    And I should be able to customize shortcuts

  @quick-actions
  Scenario: Perform batch operations
    Given I have multiple action items
    When I select batch operation
    Then I should be able to select multiple items
    And I should apply action to all selected
    And I should see batch results

  @quick-actions
  Scenario: Use action menu
    Given I am on any dashboard
    When I open the action menu
    Then I should see context-appropriate actions
    And I should see action descriptions
    And I should be able to execute actions quickly

  @quick-actions
  Scenario: Use floating action button
    Given I am on the dashboard
    When I tap the floating action button
    Then I should see primary actions
    And I should be able to add players
    And I should be able to set lineup
    And I should be able to view waivers

  @quick-actions
  Scenario: Undo recent action
    Given I have performed a quick action
    When I click undo
    Then the action should be reversed
    And I should see undo confirmation
    And I should have limited time to undo

  # --------------------------------------------------------------------------
  # Dashboard Notifications
  # --------------------------------------------------------------------------

  @dashboard-notifications
  Scenario: View alert banners
    Given there are important alerts
    When I view the dashboard
    Then I should see alert banners at top
    And alerts should be color-coded by severity
    And I should be able to take action from alert
    And I should be able to dismiss alerts

  @dashboard-notifications
  Scenario: See notification badges
    Given I have unread notifications
    When I view the dashboard
    Then I should see badge counts on relevant sections
    And badges should update in real-time
    And clicking should show notification details

  @dashboard-notifications
  Scenario: View inline alerts
    Given there are issues with my roster
    When I view the roster widget
    Then I should see inline alerts
    And alerts should be next to relevant items
    And I should understand what needs attention

  @dashboard-notifications
  Scenario: Dismiss notices
    Given I have dismissible notices
    When I dismiss a notice
    Then the notice should be removed
    And it should not reappear
    And I should be able to view dismissed notices

  @dashboard-notifications
  Scenario: Configure notification display
    Given I am on the dashboard
    When I configure notification settings
    Then I should control which alerts appear
    And I should set notification priority
    And I should control notification sounds

  @dashboard-notifications
  Scenario: View notification center
    Given I have multiple notifications
    When I open the notification center
    Then I should see all notifications
    And I should see notification history
    And I should be able to mark as read
    And I should be able to clear all

  # --------------------------------------------------------------------------
  # Dashboard Analytics
  # --------------------------------------------------------------------------

  @dashboard-analytics
  Scenario: View performance charts
    Given I am on the dashboard
    When I view performance charts
    Then I should see scoring over time
    And I should see trend lines
    And I should be able to change time range
    And charts should be interactive

  @dashboard-analytics
  Scenario: View trend graphs
    Given I am on the dashboard
    When I view trend graphs
    Then I should see upward and downward trends
    And I should see comparison to average
    And I should see prediction lines
    And I should understand trend direction

  @dashboard-analytics
  Scenario: View comparison views
    Given I am on the dashboard
    When I view comparisons
    Then I should compare to league average
    And I should compare to previous weeks
    And I should compare to opponents
    And comparisons should be visual

  @dashboard-analytics
  Scenario: Interact with data visualizations
    Given I am viewing charts on dashboard
    When I interact with a visualization
    Then I should see detailed data on hover
    And I should be able to zoom and pan
    And I should be able to filter data
    And I should be able to export chart

  @dashboard-analytics
  Scenario: View real-time analytics
    Given games are in progress
    When I view real-time analytics
    Then data should update live
    And I should see performance metrics
    And I should see projections update
    And analytics should be current

  @dashboard-analytics
  Scenario: Download analytics data
    Given I am viewing analytics
    When I download the data
    Then I should receive data export
    And I should choose format
    And data should match displayed analytics

  # --------------------------------------------------------------------------
  # Dashboard Performance
  # --------------------------------------------------------------------------

  @dashboard @performance
  Scenario: Experience fast dashboard load
    Given I navigate to the dashboard
    When the dashboard loads
    Then it should load within 2 seconds
    And widgets should load progressively
    And critical data should appear first

  @dashboard @performance
  Scenario: Handle slow connection gracefully
    Given I am on a slow connection
    When I view the dashboard
    Then I should see loading indicators
    And partial data should display
    And dashboard should remain usable

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @dashboard @error-handling
  Scenario: Handle widget data failure
    Given a widget fails to load data
    Then I should see error state for that widget
    And other widgets should continue working
    And I should be able to retry loading

  @dashboard @error-handling
  Scenario: Handle dashboard unavailable
    Given the dashboard service is unavailable
    When I try to access the dashboard
    Then I should see appropriate error message
    And I should see last cached data if available
    And I should be able to retry

  @dashboard @accessibility
  Scenario: Navigate dashboard with keyboard
    Given I am using keyboard navigation
    When I navigate the dashboard
    Then I should tab through widgets
    And I should access widget actions
    And focus should be clearly visible

  @dashboard @accessibility
  Scenario: Use dashboard with screen reader
    Given I use a screen reader
    When I access the dashboard
    Then all widgets should be announced
    And data should be read correctly
    And navigation should be logical
