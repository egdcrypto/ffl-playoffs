@dashboard @anima-1367
Feature: Dashboard
  As a fantasy football manager
  I want a customizable dashboard home screen
  So that I can quickly access important information and take action

  Background:
    Given I am a logged-in user
    And I have at least one fantasy team
    And I am on the dashboard

  # ============================================================================
  # DASHBOARD HOME
  # ============================================================================

  @happy-path @dashboard-home
  Scenario: View dashboard overview panel
    Given I navigate to the dashboard
    Then I should see the overview panel
    And I should see key information at a glance

  @happy-path @dashboard-home
  Scenario: View personalized welcome message
    Given I am on the dashboard
    Then I should see a personalized welcome message
    And the message should include my name or team name

  @happy-path @dashboard-home
  Scenario: View quick stats summary
    Given I am on the dashboard
    Then I should see quick stats for my team
    And stats should include record and points

  @happy-path @dashboard-home
  Scenario: View recent activity feed
    Given I am on the dashboard
    Then I should see recent activity
    And activity should include transactions and news

  @happy-path @dashboard-home
  Scenario: View dashboard alerts
    Given I have pending alerts
    Then I should see alert notifications on dashboard
    And alerts should be prioritized by urgency

  @happy-path @dashboard-home
  Scenario: View multiple leagues on dashboard
    Given I am in multiple leagues
    Then I should see information for each league
    And I should be able to switch between leagues

  @happy-path @dashboard-home
  Scenario: View dashboard during game day
    Given NFL games are in progress
    Then I should see live scoring updates
    And game day information should be prominent

  @happy-path @dashboard-home
  Scenario: View dashboard during off-season
    Given it is the off-season
    Then I should see off-season relevant content
    And draft preparation tools should be available

  @mobile @dashboard-home
  Scenario: View dashboard on mobile
    Given I am on a mobile device
    When I view the dashboard
    Then the layout should be mobile-optimized
    And all content should be accessible

  @accessibility @dashboard-home
  Scenario: Navigate dashboard with screen reader
    Given I am using a screen reader
    When I navigate the dashboard
    Then all sections should be announced
    And navigation should be logical

  # ============================================================================
  # WIDGET SYSTEM
  # ============================================================================

  @happy-path @widget-system
  Scenario: Add widget to dashboard
    Given I am customizing my dashboard
    When I add a widget from the library
    Then the widget should appear on my dashboard
    And my configuration should be saved

  @happy-path @widget-system
  Scenario: Remove widget from dashboard
    Given I have widgets on my dashboard
    When I remove a widget
    Then the widget should be removed
    And the layout should adjust

  @happy-path @widget-system
  Scenario: Arrange widgets on dashboard
    Given I have multiple widgets
    When I drag and drop widgets
    Then widgets should rearrange
    And the new layout should be saved

  @happy-path @widget-system
  Scenario: Resize widget
    Given I have a resizable widget
    When I resize the widget
    Then the widget should adjust to new size
    And content should adapt to the size

  @happy-path @widget-system
  Scenario: Browse widget library
    Given I want to add widgets
    When I open the widget library
    Then I should see available widgets
    And I should see widget descriptions

  @happy-path @widget-system
  Scenario: Preview widget before adding
    Given I am in the widget library
    When I preview a widget
    Then I should see how it will look
    And I should see what data it displays

  @happy-path @widget-system
  Scenario: Configure widget settings
    Given I have a configurable widget
    When I access widget settings
    Then I should see configuration options
    And I should be able to customize behavior

  @happy-path @widget-system
  Scenario: Reset widget layout to default
    Given I have customized my layout
    When I reset to default layout
    Then the default widgets should appear
    And custom configurations should be cleared

  # ============================================================================
  # MY TEAM WIDGET
  # ============================================================================

  @happy-path @my-team-widget
  Scenario: View roster summary in widget
    Given I have the my team widget
    Then I should see my roster summary
    And I should see player count by position

  @happy-path @my-team-widget
  Scenario: View starting lineup in widget
    Given I have the my team widget
    Then I should see my starting lineup
    And starters should show projected points

  @happy-path @my-team-widget
  Scenario: View bench highlights in widget
    Given I have the my team widget
    Then I should see notable bench players
    And high-projected bench players should be highlighted

  @happy-path @my-team-widget
  Scenario: View IR status in widget
    Given I have players on IR
    Then I should see IR status in the widget
    And IR-eligible players should be indicated

  @happy-path @my-team-widget
  Scenario: View projected points in widget
    Given I have the my team widget
    Then I should see total projected points
    And projections should update in real-time

  @happy-path @my-team-widget
  Scenario: Click through to full roster
    Given I am viewing the my team widget
    When I click on the widget
    Then I should be taken to my full roster page

  @happy-path @my-team-widget
  Scenario: See lineup alerts in widget
    Given my lineup has issues
    Then I should see alerts in the my team widget
    And I should see what needs attention

  # ============================================================================
  # MATCHUP WIDGET
  # ============================================================================

  @happy-path @matchup-widget
  Scenario: View current matchup in widget
    Given I have the matchup widget
    Then I should see my current matchup
    And I should see my opponent's team

  @happy-path @matchup-widget
  Scenario: View opponent info in widget
    Given I am viewing the matchup widget
    Then I should see opponent details
    And I should see opponent's record

  @happy-path @matchup-widget
  Scenario: View score projection in widget
    Given I am viewing the matchup widget
    Then I should see projected scores
    And win probability should be shown

  @happy-path @matchup-widget
  Scenario: View key players in widget
    Given I am viewing the matchup widget
    Then I should see key players to watch
    And high-impact players should be highlighted

  @happy-path @matchup-widget
  Scenario: View live score updates in widget
    Given games are in progress
    Then I should see live scores in the widget
    And scores should update automatically

  @happy-path @matchup-widget
  Scenario: See matchup comparison in widget
    Given I am viewing the matchup widget
    Then I should see head-to-head comparison
    And advantages should be indicated

  @happy-path @matchup-widget
  Scenario: Click through to full matchup
    Given I am viewing the matchup widget
    When I click on the widget
    Then I should be taken to the full matchup page

  # ============================================================================
  # LEAGUE WIDGET
  # ============================================================================

  @happy-path @league-widget
  Scenario: View standings snapshot in widget
    Given I have the league widget
    Then I should see current standings
    And my team position should be highlighted

  @happy-path @league-widget
  Scenario: View upcoming matchups in widget
    Given I am viewing the league widget
    Then I should see this week's matchups
    And matchups should show projections

  @happy-path @league-widget
  Scenario: View league news in widget
    Given I am viewing the league widget
    Then I should see recent league news
    And commissioner announcements should appear

  @happy-path @league-widget
  Scenario: View recent transactions in widget
    Given I am viewing the league widget
    Then I should see recent transactions
    And trades and pickups should be listed

  @happy-path @league-widget
  Scenario: Switch leagues in widget
    Given I am in multiple leagues
    When I switch leagues in the widget
    Then the widget should update to show that league

  @happy-path @league-widget
  Scenario: Click through to league page
    Given I am viewing the league widget
    When I click on the widget
    Then I should be taken to the league page

  # ============================================================================
  # NEWS WIDGET
  # ============================================================================

  @happy-path @news-widget
  Scenario: View player news feed in widget
    Given I have the news widget
    Then I should see player news
    And news should be relevant to my roster

  @happy-path @news-widget
  Scenario: View injury updates in widget
    Given I am viewing the news widget
    Then I should see injury updates
    And injuries affecting my players should be prioritized

  @happy-path @news-widget
  Scenario: View team news in widget
    Given I am viewing the news widget
    Then I should see NFL team news
    And news should be recent and relevant

  @happy-path @news-widget
  Scenario: View fantasy analysis in widget
    Given I am viewing the news widget
    Then I should see fantasy analysis articles
    And analysis should be from trusted sources

  @happy-path @news-widget
  Scenario: View breaking alerts in widget
    Given there is breaking news
    Then I should see breaking alerts prominently
    And alerts should be timely

  @happy-path @news-widget
  Scenario: Filter news in widget
    Given I am viewing the news widget
    When I filter by news type
    Then I should see only that type of news

  @happy-path @news-widget
  Scenario: Click through to full news
    Given I am viewing the news widget
    When I click on a news item
    Then I should be taken to the full article

  # ============================================================================
  # QUICK ACTIONS
  # ============================================================================

  @happy-path @quick-actions
  Scenario: Set lineup from dashboard
    Given I am on the dashboard
    When I use the set lineup quick action
    Then I should be able to set my lineup quickly
    And changes should be saved

  @happy-path @quick-actions
  Scenario: Add/drop player from dashboard
    Given I am on the dashboard
    When I use the add/drop quick action
    Then I should be able to add or drop a player
    And the transaction should be processed

  @happy-path @quick-actions
  Scenario: Propose trade from dashboard
    Given I am on the dashboard
    When I use the propose trade quick action
    Then I should be able to start a trade proposal
    And I should be guided through the process

  @happy-path @quick-actions
  Scenario: View waivers from dashboard
    Given I am on the dashboard
    When I use the view waivers quick action
    Then I should see available waiver players
    And I should be able to make claims

  @happy-path @quick-actions
  Scenario: Check scores from dashboard
    Given games are in progress
    When I use the check scores quick action
    Then I should see live scores
    And my players' scores should be highlighted

  @happy-path @quick-actions
  Scenario: View quick actions menu
    Given I am on the dashboard
    When I access the quick actions menu
    Then I should see all available actions
    And actions should be organized logically

  @happy-path @quick-actions
  Scenario: Customize quick actions
    Given I am customizing my dashboard
    When I customize quick actions
    Then I should be able to choose visible actions
    And my preferences should be saved

  # ============================================================================
  # DASHBOARD CUSTOMIZATION
  # ============================================================================

  @happy-path @dashboard-customization
  Scenario: Select layout option
    Given I am customizing my dashboard
    When I select a layout option
    Then the layout should be applied
    And widgets should adjust to the layout

  @happy-path @dashboard-customization
  Scenario: Apply color theme
    Given I am customizing my dashboard
    When I select a color theme
    Then the theme should be applied
    And the dashboard should reflect the colors

  @happy-path @dashboard-customization
  Scenario: Set widget preferences
    Given I am customizing my dashboard
    When I set widget preferences
    Then preferences should be saved
    And widgets should behave according to preferences

  @happy-path @dashboard-customization
  Scenario: Set data refresh rate
    Given I am customizing my dashboard
    When I set the data refresh rate
    Then data should refresh at that rate
    And my preference should be saved

  @happy-path @dashboard-customization
  Scenario: Save dashboard configuration
    Given I have customized my dashboard
    When I save my configuration
    Then all customizations should be saved
    And they should persist across sessions

  @happy-path @dashboard-customization
  Scenario: Import dashboard configuration
    Given I have a saved configuration
    When I import the configuration
    Then my dashboard should be configured
    And the import should be successful

  @happy-path @dashboard-customization
  Scenario: Export dashboard configuration
    Given I have a customized dashboard
    When I export my configuration
    Then I should receive a configuration file
    And I should be able to use it on another device

  # ============================================================================
  # DASHBOARD NOTIFICATIONS
  # ============================================================================

  @happy-path @dashboard-notifications
  Scenario: View inline alerts on dashboard
    Given I have pending alerts
    Then I should see inline alerts on dashboard
    And alerts should be clearly visible

  @happy-path @dashboard-notifications
  Scenario: View action items on dashboard
    Given I have pending action items
    Then I should see action items listed
    And I should be able to act on them

  @happy-path @dashboard-notifications
  Scenario: View reminders on dashboard
    Given I have upcoming reminders
    Then I should see reminders on dashboard
    And reminders should show timing

  @happy-path @dashboard-notifications
  Scenario: View urgent notices on dashboard
    Given there are urgent notices
    Then I should see urgent notices prominently
    And they should demand attention

  @happy-path @dashboard-notifications
  Scenario: Dismiss dashboard notification
    Given I have a dashboard notification
    When I dismiss the notification
    Then it should be removed from view
    And my action should be recorded

  @happy-path @dashboard-notifications
  Scenario: Act on notification from dashboard
    Given I have an actionable notification
    When I click to act on it
    Then I should be taken to the relevant action
    And the notification should be marked as handled

  # ============================================================================
  # MOBILE DASHBOARD
  # ============================================================================

  @mobile @mobile-dashboard
  Scenario: View responsive dashboard layout
    Given I am on a mobile device
    When I view the dashboard
    Then the layout should be responsive
    And content should fit the screen

  @mobile @mobile-dashboard
  Scenario: View mobile-optimized widgets
    Given I am on a mobile device
    Then widgets should be mobile-optimized
    And they should be touch-friendly

  @mobile @mobile-dashboard
  Scenario: Use swipe navigation on dashboard
    Given I am on a mobile device
    When I swipe between sections
    Then I should navigate between dashboard areas
    And swipe gestures should feel natural

  @mobile @mobile-dashboard
  Scenario: View compact dashboard view
    Given I am on a mobile device
    When I enable compact view
    Then the dashboard should show condensed information
    And more content should fit on screen

  @mobile @mobile-dashboard
  Scenario: Access quick actions on mobile
    Given I am on a mobile device
    When I access quick actions
    Then quick actions should be easily accessible
    And they should work on touch

  @mobile @mobile-dashboard
  Scenario: Pull to refresh dashboard
    Given I am on a mobile device
    When I pull down to refresh
    Then the dashboard should refresh
    And I should see updated data

  @mobile @mobile-dashboard
  Scenario: View dashboard in landscape mode
    Given I am on a mobile device
    When I rotate to landscape
    Then the dashboard should adapt to landscape
    And layout should be optimized

  @mobile @mobile-dashboard
  Scenario: Use dashboard offline
    Given I am on a mobile device with cached data
    When I lose connectivity
    Then I should see cached dashboard data
    And offline status should be indicated

  @error @mobile-dashboard
  Scenario: Handle mobile dashboard loading failure
    Given I am on a mobile device
    When the dashboard fails to load
    Then I should see an error message
    And I should have option to retry
