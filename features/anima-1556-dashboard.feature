@dashboard
Feature: Dashboard
  As a fantasy football user
  I want comprehensive dashboard functionality
  So that I can quickly access all important information about my fantasy teams

  Background:
    Given I am logged in as a user
    And I have an active fantasy football league
    And I am on the dashboard

  # --------------------------------------------------------------------------
  # Home Dashboard Scenarios
  # --------------------------------------------------------------------------
  @home-dashboard
  Scenario: View league overview on home dashboard
    Given I have leagues to display
    When I access the home dashboard
    Then I should see an overview of all my leagues
    And key stats should be summarized
    And I should be able to navigate to any league

  @home-dashboard
  Scenario: Access quick actions
    Given quick actions are available
    When I view the quick actions panel
    Then I should see common actions
    And I should be able to set lineup with one click
    And I should access frequently used features

  @home-dashboard
  Scenario: View recent activity feed
    Given activity has occurred in my leagues
    When I view the activity feed
    Then I should see recent transactions
    And I should see chat highlights
    And activities should be chronological

  @home-dashboard
  Scenario: View upcoming matchups
    Given matchups are scheduled
    When I view upcoming matchups
    Then I should see this week's opponents
    And projected scores should be shown
    And matchup times should be displayed

  @home-dashboard
  Scenario: View important alerts
    Given I have alerts requiring attention
    When I view the home dashboard
    Then alerts should be prominently displayed
    And I should see injury notifications
    And deadline reminders should be visible

  @home-dashboard
  Scenario: Customize home dashboard layout
    Given I want to personalize my view
    When I customize the layout
    Then I should arrange sections as desired
    And my layout should be saved
    And I should be able to reset to default

  @home-dashboard
  Scenario: View cross-league summary
    Given I am in multiple leagues
    When I view the summary
    Then aggregate stats should be shown
    And my overall record should be displayed
    And league-specific details should be accessible

  @home-dashboard
  Scenario: Access home dashboard shortcuts
    Given keyboard shortcuts are available
    When I use shortcuts
    Then I should navigate quickly
    And common actions should have shortcuts
    And shortcuts should be documented

  # --------------------------------------------------------------------------
  # Team Dashboard Scenarios
  # --------------------------------------------------------------------------
  @team-dashboard
  Scenario: View roster summary
    Given my team has a roster
    When I view the team dashboard
    Then I should see all my players
    And their status should be indicated
    And projected points should be shown

  @team-dashboard
  Scenario: View lineup status
    Given my lineup needs management
    When I view lineup status
    Then I should see starters and bench
    And empty slots should be highlighted
    And suboptimal lineups should be flagged

  @team-dashboard
  Scenario: View injury alerts
    Given players have injury designations
    When I view injury alerts
    Then injured players should be highlighted
    And injury status should be shown
    And I should see replacement suggestions

  @team-dashboard
  Scenario: View bye week warnings
    Given players have upcoming byes
    When I view bye week warnings
    Then bye week conflicts should be shown
    And affected positions should be highlighted
    And I should see alternative options

  @team-dashboard
  Scenario: View team health score
    Given team health is calculated
    When I view team health
    Then overall health score should be shown
    And factors should be broken down
    And improvement tips should be offered

  @team-dashboard
  Scenario: View roster value summary
    Given players have trade values
    When I view roster value
    Then total team value should be shown
    And value by position should be displayed
    And trends should be visible

  @team-dashboard
  Scenario: View upcoming player schedules
    Given players have upcoming games
    When I view schedules
    Then game times should be shown
    And opponent matchups should be rated
    And relevant factors should be noted

  @team-dashboard
  Scenario: Access team dashboard quick edit
    Given I need to make quick changes
    When I use quick edit
    Then I should modify lineup easily
    And changes should save immediately
    And confirmation should be shown

  # --------------------------------------------------------------------------
  # Matchup Dashboard Scenarios
  # --------------------------------------------------------------------------
  @matchup-dashboard
  Scenario: View current matchup
    Given I have an active matchup
    When I view the matchup dashboard
    Then my matchup should be displayed
    And both teams should be visible
    And the score should be current

  @matchup-dashboard
  Scenario: View live scoring
    Given games are in progress
    When I view live scoring
    Then scores should update in real-time
    And player performances should be tracked
    And point totals should be accurate

  @matchup-dashboard
  Scenario: View opponent comparison
    Given I am facing an opponent
    When I view the comparison
    Then side-by-side roster should be shown
    And position matchups should be compared
    And advantages should be highlighted

  @matchup-dashboard
  Scenario: View projected outcome
    Given projections are available
    When I view projected outcome
    Then win probability should be shown
    And projected final score should be displayed
    And key players should be identified

  @matchup-dashboard
  Scenario: View players yet to play
    Given some players haven't played yet
    When I view remaining players
    Then players yet to play should be listed
    And potential points should be shown
    And game times should be displayed

  @matchup-dashboard
  Scenario: View matchup history
    Given I have faced this opponent before
    When I view matchup history
    Then past results should be shown
    And historical trends should be visible
    And all-time record should be displayed

  @matchup-dashboard
  Scenario: View scoring breakdown
    Given scoring has occurred
    When I view scoring breakdown
    Then points by category should be shown
    And I should compare to opponent
    And scoring details should be expandable

  @matchup-dashboard
  Scenario: View matchup alerts
    Given matchup-specific alerts exist
    When I view matchup alerts
    Then relevant alerts should be shown
    And injury impacts should be noted
    And lineup recommendations should appear

  # --------------------------------------------------------------------------
  # League Dashboard Scenarios
  # --------------------------------------------------------------------------
  @league-dashboard
  Scenario: View standings snapshot
    Given the league has standings
    When I view the standings snapshot
    Then current standings should be shown
    And my position should be highlighted
    And movement should be indicated

  @league-dashboard
  Scenario: View playoff picture
    Given playoff races are active
    When I view the playoff picture
    Then playoff positions should be shown
    And clinching scenarios should be noted
    And elimination scenarios should be visible

  @league-dashboard
  Scenario: View transaction feed
    Given transactions have occurred
    When I view the transaction feed
    Then recent transactions should be listed
    And transaction types should be indicated
    And I should be able to filter

  @league-dashboard
  Scenario: View league news
    Given news is available
    When I view league news
    Then commissioner announcements should appear
    And league updates should be shown
    And important dates should be noted

  @league-dashboard
  Scenario: View league activity summary
    Given activity is tracked
    When I view activity summary
    Then activity metrics should be shown
    And most active members should be noted
    And engagement trends should be visible

  @league-dashboard
  Scenario: View league leaderboards
    Given leaderboards are calculated
    When I view leaderboards
    Then top scorers should be shown
    And various categories should be available
    And my rankings should be highlighted

  @league-dashboard
  Scenario: View upcoming league events
    Given events are scheduled
    When I view upcoming events
    Then events should be listed
    And deadlines should be prominent
    And I should be able to add to calendar

  @league-dashboard
  Scenario: View league health indicators
    Given league health is measured
    When I view health indicators
    Then overall league health should be shown
    And potential issues should be flagged
    And recommendations should be offered

  # --------------------------------------------------------------------------
  # Player Dashboard Scenarios
  # --------------------------------------------------------------------------
  @player-dashboard
  Scenario: View my players overview
    Given I have rostered players
    When I view my players
    Then all my players should be listed
    And their status should be current
    And performance should be summarized

  @player-dashboard
  Scenario: View watchlist on dashboard
    Given I have a watchlist
    When I view my watchlist
    Then watched players should be shown
    And availability should be indicated
    And I should be able to add or remove

  @player-dashboard
  Scenario: View trending players
    Given players are trending
    When I view trending players
    Then trending up players should be shown
    And trending down should be visible
    And trend reasons should be noted

  @player-dashboard
  Scenario: View waiver priorities
    Given waiver claims are possible
    When I view waiver priorities
    Then recommended pickups should be shown
    And FAAB suggestions should be included
    And I should be able to add claims

  @player-dashboard
  Scenario: View player news feed
    Given player news exists
    When I view player news
    Then relevant news should be shown
    And news should be filterable by my players
    And I should see impact analysis

  @player-dashboard
  Scenario: View injury report dashboard
    Given injuries are tracked
    When I view the injury report
    Then all injuries should be listed
    And my players should be highlighted
    And return timelines should be shown

  @player-dashboard
  Scenario: View player comparison tool
    Given I want to compare players
    When I access comparison tool
    Then I should select players to compare
    And side-by-side stats should be shown
    And recommendations should be provided

  @player-dashboard
  Scenario: View player schedule dashboard
    Given schedules are known
    When I view player schedules
    Then upcoming games should be shown
    And bye weeks should be highlighted
    And matchup difficulty should be rated

  # --------------------------------------------------------------------------
  # Stats Dashboard Scenarios
  # --------------------------------------------------------------------------
  @stats-dashboard
  Scenario: View scoring leaders
    Given scoring data exists
    When I view scoring leaders
    Then top scorers should be listed
    And I should filter by position
    And time period should be selectable

  @stats-dashboard
  Scenario: View performance trends
    Given trend data is available
    When I view performance trends
    Then trends should be visualized
    And I should see week-over-week changes
    And I should identify patterns

  @stats-dashboard
  Scenario: View weekly recap
    Given a week has completed
    When I view the weekly recap
    Then key stats should be summarized
    And notable performances should be highlighted
    And my team's performance should be shown

  @stats-dashboard
  Scenario: View season totals
    Given the season has data
    When I view season totals
    Then cumulative stats should be shown
    And rankings should be displayed
    And comparisons should be available

  @stats-dashboard
  Scenario: View statistical categories
    Given multiple stat categories exist
    When I view categories
    Then I should browse by category
    And leaders in each should be shown
    And I should compare to my team

  @stats-dashboard
  Scenario: View efficiency stats
    Given efficiency is calculated
    When I view efficiency stats
    Then lineup efficiency should be shown
    And points left on bench should be calculated
    And improvement areas should be noted

  @stats-dashboard
  Scenario: View historical stats comparison
    Given historical data exists
    When I compare historical stats
    Then I should compare seasons
    And trends should be visible
    And progress should be measurable

  @stats-dashboard
  Scenario: Export stats dashboard data
    Given I want to save stats
    When I export stats
    Then data should be exported
    And format should be selectable
    And all relevant stats should be included

  # --------------------------------------------------------------------------
  # Fantasy Dashboard Scenarios
  # --------------------------------------------------------------------------
  @fantasy-dashboard
  Scenario: View start/sit advice
    Given advice is available
    When I view start/sit advice
    Then recommendations should be shown
    And reasoning should be provided
    And confidence levels should be indicated

  @fantasy-dashboard
  Scenario: View trade suggestions
    Given trade opportunities exist
    When I view trade suggestions
    Then suggested trades should be shown
    And value analysis should be included
    And I should be able to initiate trades

  @fantasy-dashboard
  Scenario: View waiver recommendations
    Given waiver wire has value
    When I view waiver recommendations
    Then top pickups should be shown
    And priority order should be suggested
    And FAAB bids should be recommended

  @fantasy-dashboard
  Scenario: View lineup optimizer
    Given lineup can be optimized
    When I use the lineup optimizer
    Then optimal lineup should be suggested
    And changes should be explained
    And I should be able to apply changes

  @fantasy-dashboard
  Scenario: View fantasy insights
    Given insights are generated
    When I view fantasy insights
    Then actionable insights should be shown
    And I should understand the analysis
    And I should be able to act on insights

  @fantasy-dashboard
  Scenario: View matchup preparation
    Given I have an upcoming matchup
    When I view matchup preparation
    Then key factors should be highlighted
    And strategy should be suggested
    And risks should be identified

  @fantasy-dashboard
  Scenario: View rest of season outlook
    Given projections are available
    When I view ROS outlook
    Then remaining schedule should be analyzed
    And projected finish should be shown
    And playoff odds should be calculated

  @fantasy-dashboard
  Scenario: View personalized tips
    Given tips are personalized
    When I view tips
    Then tips should be relevant to my team
    And tips should be actionable
    And I should be able to dismiss tips

  # --------------------------------------------------------------------------
  # Widget System Scenarios
  # --------------------------------------------------------------------------
  @widget-system
  Scenario: View customizable widgets
    Given widgets are available
    When I view the dashboard
    Then I should see widget options
    And widgets should be configurable
    And widget content should be relevant

  @widget-system
  Scenario: Use drag-and-drop layout
    Given I want to rearrange widgets
    When I drag and drop widgets
    Then widgets should move smoothly
    And the new layout should be saved
    And I should be able to undo changes

  @widget-system
  Scenario: Browse widget library
    Given a widget library exists
    When I browse the library
    Then available widgets should be shown
    And widget descriptions should be provided
    And I should be able to add widgets

  @widget-system
  Scenario: Save widget configurations
    Given I have configured widgets
    When I save my configuration
    Then the configuration should be stored
    And it should persist across sessions
    And I should be able to reset

  @widget-system
  Scenario: Add new widget to dashboard
    Given I want to add a widget
    When I add a widget
    Then the widget should appear
    And I should position it
    And it should be configurable

  @widget-system
  Scenario: Remove widget from dashboard
    Given I want to remove a widget
    When I remove the widget
    Then the widget should be removed
    And the layout should adjust
    And I should be able to re-add later

  @widget-system
  Scenario: Resize widgets
    Given widgets can be resized
    When I resize a widget
    Then the widget should change size
    And content should adapt
    And the size should be saved

  @widget-system
  Scenario: Configure widget settings
    Given widgets have settings
    When I configure a widget
    Then I should access widget settings
    And I should customize display
    And settings should be saved

  # --------------------------------------------------------------------------
  # Dashboard Preferences Scenarios
  # --------------------------------------------------------------------------
  @dashboard-preferences
  Scenario: Configure theme settings
    Given theme options are available
    When I configure theme
    Then I should choose light or dark mode
    And color accents should be selectable
    And my theme should be applied

  @dashboard-preferences
  Scenario: Set data refresh rates
    Given data can auto-refresh
    When I set refresh rates
    Then I should choose refresh frequency
    And data should refresh accordingly
    And I should be able to pause refresh

  @dashboard-preferences
  Scenario: Set default views
    Given multiple views are available
    When I set defaults
    Then my preferred views should be default
    And defaults should apply on login
    And I should be able to change anytime

  @dashboard-preferences
  Scenario: Configure notification badges
    Given badges indicate alerts
    When I configure badges
    Then I should choose what shows badges
    And badge counts should be accurate
    And I should be able to disable badges

  @dashboard-preferences
  Scenario: Set dashboard density
    Given density can be adjusted
    When I set density
    Then I should choose compact or spacious
    And the layout should adjust
    And my preference should be saved

  @dashboard-preferences
  Scenario: Configure auto-save settings
    Given changes can auto-save
    When I configure auto-save
    Then auto-save behavior should be settable
    And I should be notified of saves
    And I should be able to disable

  @dashboard-preferences
  Scenario: Set timezone preferences
    Given timezone affects display
    When I set timezone
    Then times should display in my timezone
    And game times should be correct
    And the setting should persist

  @dashboard-preferences
  Scenario: Export dashboard preferences
    Given I want to backup preferences
    When I export preferences
    Then preferences should be exported
    And I should be able to import later
    And the format should be portable

  # --------------------------------------------------------------------------
  # Mobile Dashboard Scenarios
  # --------------------------------------------------------------------------
  @mobile-dashboard
  Scenario: View responsive dashboard design
    Given I am on a mobile device
    When I view the dashboard
    Then the layout should be responsive
    And all content should be visible
    And navigation should be mobile-friendly

  @mobile-dashboard
  Scenario: Use touch optimization
    Given touch input is primary
    When I interact with the dashboard
    Then touch targets should be sized appropriately
    And gestures should work correctly
    And the experience should be smooth

  @mobile-dashboard
  Scenario: Use offline mode
    Given I may lose connectivity
    When I go offline
    Then cached data should be available
    And I should be notified of offline status
    And data should sync when reconnected

  @mobile-dashboard
  Scenario: View quick stats on mobile
    Given I need quick information
    When I view quick stats
    Then key stats should be immediately visible
    And I should access details with taps
    And information should be scannable

  @mobile-dashboard
  Scenario: Use mobile quick actions
    Given quick actions are needed
    When I use mobile quick actions
    Then I should set lineup quickly
    And I should access common features
    And actions should be finger-friendly

  @mobile-dashboard
  Scenario: View mobile notifications
    Given notifications arrive
    When I view on mobile
    Then notifications should be prominent
    And I should be able to act on them
    And they should not obstruct content

  @mobile-dashboard
  Scenario: Use mobile gesture navigation
    Given gestures are supported
    When I use gestures
    Then swipe navigation should work
    And pull to refresh should work
    And gestures should be discoverable

  @mobile-dashboard
  Scenario: Switch between mobile and desktop
    Given I use multiple devices
    When I switch devices
    Then my experience should be consistent
    And preferences should sync
    And I should pick up where I left off

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle dashboard load failure
    Given the dashboard fails to load
    When the error occurs
    Then I should see a clear error message
    And I should be able to retry
    And cached data should be shown if available

  @error-handling
  Scenario: Handle widget load failure
    Given a widget fails to load
    When the error occurs
    Then the error should be contained to that widget
    And other widgets should work
    And retry should be available

  @error-handling
  Scenario: Handle real-time update failure
    Given live updates stop working
    When the failure is detected
    Then I should be notified
    And I should see last known data
    And reconnection should be attempted

  @error-handling
  Scenario: Handle offline data sync failure
    Given offline data fails to sync
    When I reconnect
    Then I should be notified of sync issues
    And I should see what failed
    And retry should be available

  @error-handling
  Scenario: Handle preference save failure
    Given I save preferences
    And the save fails
    When the error occurs
    Then I should be notified
    And my changes should not be lost
    And I should be able to retry

  @error-handling
  Scenario: Handle layout save failure
    Given I customize layout
    And the save fails
    When the error occurs
    Then I should be notified
    And the layout should be preserved locally
    And I should be able to retry

  @error-handling
  Scenario: Handle data refresh failure
    Given data refresh fails
    When the failure occurs
    Then I should be notified
    And last refresh time should be shown
    And manual refresh should be available

  @error-handling
  Scenario: Handle session timeout
    Given my session times out
    When I try to interact
    Then I should be prompted to re-authenticate
    And my work should be preserved
    And I should return to my dashboard

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate dashboard with keyboard
    Given I am on the dashboard
    When I navigate using only keyboard
    Then all sections should be accessible
    And widgets should be navigable
    And focus should be clearly visible

  @accessibility
  Scenario: Use dashboard with screen reader
    Given I am using a screen reader
    When I access the dashboard
    Then all content should be announced
    And regions should be labeled
    And updates should be announced

  @accessibility
  Scenario: View dashboard in high contrast
    Given I have high contrast mode enabled
    When I view the dashboard
    Then all elements should be visible
    And colors should be distinguishable
    And text should be readable

  @accessibility
  Scenario: Resize dashboard widgets accessibly
    Given I need to resize widgets
    When I use assistive technology
    Then resize should be possible
    And current size should be announced
    And I should confirm changes

  @accessibility
  Scenario: Use drag and drop accessibly
    Given I need to rearrange widgets
    When I use keyboard
    Then alternative to drag should exist
    And movement should be possible
    And changes should be confirmed

  @accessibility
  Scenario: View live updates accessibly
    Given live updates are occurring
    When I use assistive technology
    Then updates should be announced appropriately
    And I should control update frequency
    And updates should not be overwhelming

  @accessibility
  Scenario: Configure preferences accessibly
    Given I need to change preferences
    When I use assistive technology
    Then all settings should be accessible
    And changes should be confirmed
    And I should be able to navigate settings

  @accessibility
  Scenario: Use mobile dashboard accessibly
    Given I am on mobile with assistive tech
    When I use the dashboard
    Then all features should be accessible
    And touch alternatives should exist
    And the experience should be complete

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load dashboard quickly
    Given I am accessing the dashboard
    When the page loads
    Then core content should appear within 2 seconds
    And widgets should load progressively
    And the interface should be usable quickly

  @performance
  Scenario: Render multiple widgets efficiently
    Given I have many widgets
    When widgets are rendered
    Then all widgets should load smoothly
    And no lag should be noticeable
    And memory should be managed

  @performance
  Scenario: Handle real-time updates efficiently
    Given live data is streaming
    When updates arrive continuously
    Then updates should be processed quickly
    And the interface should remain responsive
    And battery should be conserved on mobile

  @performance
  Scenario: Load widget library quickly
    Given I access the widget library
    When the library loads
    Then widgets should appear quickly
    And I should browse without lag
    And previews should load efficiently

  @performance
  Scenario: Save preferences quickly
    Given I change preferences
    When I save changes
    Then saves should complete quickly
    And I should see immediate feedback
    And no delay should be noticeable

  @performance
  Scenario: Handle large data sets
    Given dashboard displays lots of data
    When data is loaded
    Then data should be handled efficiently
    And pagination should be smooth
    And the interface should stay responsive

  @performance
  Scenario: Cache dashboard data appropriately
    Given I visit the dashboard frequently
    When I return to the dashboard
    Then cached data should load instantly
    And fresh data should update in background
    And staleness should be indicated

  @performance
  Scenario: Optimize mobile performance
    Given I am on a mobile device
    When I use the dashboard
    Then performance should be optimized
    And data usage should be minimal
    And battery impact should be low
