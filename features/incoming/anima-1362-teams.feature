@teams @anima-1362
Feature: Teams
  As a fantasy football manager
  I want to manage and customize my team
  So that I can build a unique identity and track my team's performance

  Background:
    Given I am a logged-in user
    And I own at least one fantasy team
    And the fantasy platform is available

  # ============================================================================
  # TEAM PROFILE
  # ============================================================================

  @happy-path @team-profile
  Scenario: View team profile
    Given I am on my team page
    When I view my team profile
    Then I should see my team name and logo
    And I should see owner information
    And I should see team bio if set

  @happy-path @team-profile
  Scenario: Set team name
    Given I am editing my team profile
    When I enter a new team name
    And I save the changes
    Then my team name should be updated
    And the new name should display throughout the league

  @happy-path @team-profile
  Scenario: Upload team logo
    Given I am editing my team profile
    When I upload a team logo image
    Then the logo should be saved
    And it should display on my team profile

  @happy-path @team-profile
  Scenario: Set team motto
    Given I am editing my team profile
    When I enter a team motto
    And I save the changes
    Then my motto should be displayed on my profile

  @happy-path @team-profile
  Scenario: Edit owner information
    Given I am editing my team profile
    When I update my owner display name
    Then the owner info should be updated
    And other managers should see the new info

  @happy-path @team-profile
  Scenario: Write team bio
    Given I am editing my team profile
    When I write a team bio
    And I save the changes
    Then the bio should appear on my profile
    And other managers can read it

  @happy-path @team-profile
  Scenario: View another team's profile
    Given I am viewing another team
    Then I should see their team name and logo
    And I should see their public profile information

  @mobile @team-profile
  Scenario: View team profile on mobile
    Given I am on a mobile device
    When I view a team profile
    Then the profile should be mobile-optimized
    And all information should be readable

  @error @team-profile
  Scenario: Attempt to set inappropriate team name
    Given I am editing my team profile
    When I enter an inappropriate team name
    Then I should see a content policy warning
    And the name should be rejected

  @error @team-profile
  Scenario: Attempt to upload invalid logo
    Given I am editing my team profile
    When I upload an invalid file type
    Then I should see an error message
    And the upload should be rejected

  # ============================================================================
  # TEAM DASHBOARD
  # ============================================================================

  @happy-path @team-dashboard
  Scenario: View team overview
    Given I am on my team dashboard
    Then I should see my team's current record
    And I should see my standings position
    And I should see key team metrics

  @happy-path @team-dashboard
  Scenario: View quick stats on dashboard
    Given I am on my team dashboard
    Then I should see points scored this week
    And I should see projected points
    And I should see season totals

  @happy-path @team-dashboard
  Scenario: View recent activity
    Given I am on my team dashboard
    When I view recent activity
    Then I should see recent transactions
    And I should see lineup changes
    And I should see trade activity

  @happy-path @team-dashboard
  Scenario: View upcoming matchups
    Given I am on my team dashboard
    Then I should see my next opponent
    And I should see matchup preview
    And I should see schedule outlook

  @happy-path @team-dashboard
  Scenario: View dashboard alerts
    Given I am on my team dashboard
    And I have pending alerts
    Then I should see alert notifications
    And alerts should be prioritized by importance

  @happy-path @team-dashboard
  Scenario: Customize dashboard widgets
    Given I am on my team dashboard
    When I customize widget layout
    Then I should be able to add or remove widgets
    And widget positions should be saved

  @happy-path @team-dashboard
  Scenario: View dashboard performance graph
    Given I am on my team dashboard
    Then I should see a performance trend graph
    And the graph should show scoring history

  @mobile @team-dashboard
  Scenario: View team dashboard on mobile
    Given I am on a mobile device
    When I view my team dashboard
    Then widgets should stack vertically
    And touch interactions should work smoothly

  @accessibility @team-dashboard
  Scenario: Navigate dashboard with screen reader
    Given I am using a screen reader
    When I navigate the team dashboard
    Then all widgets should be announced
    And navigation should be logical

  # ============================================================================
  # TEAM CUSTOMIZATION
  # ============================================================================

  @happy-path @team-customization
  Scenario: Upload custom logo
    Given I am customizing my team
    When I upload a custom logo
    Then the logo should be processed
    And it should display in appropriate sizes

  @happy-path @team-customization
  Scenario: Set team color scheme
    Given I am customizing my team
    When I select primary and secondary colors
    Then my team should display in those colors
    And colors should apply to team elements

  @happy-path @team-customization
  Scenario: Select team avatar
    Given I am customizing my team
    When I select a pre-made avatar
    Then the avatar should be set as my team icon
    And it should appear in matchups and standings

  @happy-path @team-customization
  Scenario: Set stadium name
    Given I am customizing my team
    When I enter a stadium name
    Then the stadium name should be saved
    And it should display on my home matchups

  @happy-path @team-customization
  Scenario: Choose team mascot
    Given I am customizing my team
    When I select or create a mascot
    Then the mascot should be associated with my team
    And it should appear on my team page

  @happy-path @team-customization
  Scenario: Preview customization changes
    Given I am making customization changes
    When I preview the changes
    Then I should see how my team will look
    And I should be able to adjust before saving

  @happy-path @team-customization
  Scenario: Reset to default appearance
    Given I have customized my team
    When I reset to defaults
    Then all customizations should be removed
    And the team should have default appearance

  @error @team-customization
  Scenario: Upload oversized logo file
    Given I am uploading a team logo
    When the file exceeds the size limit
    Then I should see a file size error
    And I should be prompted to resize

  @error @team-customization
  Scenario: Select invalid color combination
    Given I am setting team colors
    When colors have poor contrast
    Then I should see an accessibility warning
    And I should be prompted to choose better colors

  # ============================================================================
  # TEAM ROSTER
  # ============================================================================

  @happy-path @team-roster
  Scenario: View current roster
    Given I am on my team page
    When I view my roster
    Then I should see all rostered players
    And players should show position and status

  @happy-path @team-roster
  Scenario: View starting lineup
    Given I am viewing my roster
    When I check starting lineup
    Then I should see all starting players
    And starters should be organized by position

  @happy-path @team-roster
  Scenario: View bench players
    Given I am viewing my roster
    When I view the bench
    Then I should see all bench players
    And bench depth should be visible

  @happy-path @team-roster
  Scenario: View IR players
    Given I am viewing my roster
    And I have players on IR
    Then I should see IR slot players
    And their injury status should be displayed

  @happy-path @team-roster
  Scenario: View taxi squad
    Given my league has taxi squads
    When I view my taxi squad
    Then I should see taxi squad players
    And eligibility rules should be shown

  @happy-path @team-roster
  Scenario: View roster by position
    Given I am viewing my roster
    When I group by position
    Then players should be organized by position
    And depth at each position should be clear

  @happy-path @team-roster
  Scenario: View player details from roster
    Given I am viewing my roster
    When I click on a player
    Then I should see player details
    And I should see performance stats

  @happy-path @team-roster
  Scenario: Quick roster actions
    Given I am viewing my roster
    Then I should have quick action buttons
    And I should be able to start/bench with one click

  # ============================================================================
  # TEAM STATISTICS
  # ============================================================================

  @happy-path @team-statistics
  Scenario: View season statistics
    Given I am on my team stats page
    Then I should see season-to-date statistics
    And stats should include points, record, and rankings

  @happy-path @team-statistics
  Scenario: View all-time statistics
    Given I have played multiple seasons
    When I view all-time stats
    Then I should see cumulative statistics
    And historical records should be included

  @happy-path @team-statistics
  Scenario: View weekly performance breakdown
    Given I am viewing team statistics
    When I select weekly breakdown
    Then I should see performance by week
    And trends should be visible

  @happy-path @team-statistics
  Scenario: View scoring breakdown by position
    Given I am viewing team statistics
    When I view scoring breakdown
    Then I should see points by position
    And I should see contribution percentages

  @happy-path @team-statistics
  Scenario: View efficiency metrics
    Given I am viewing team statistics
    Then I should see efficiency metrics
    And optimal vs actual scoring should be shown

  @happy-path @team-statistics
  Scenario: Compare stats to league average
    Given I am viewing team statistics
    When I compare to league average
    Then I should see how I rank in each category
    And above/below average should be indicated

  @happy-path @team-statistics
  Scenario: Export team statistics
    Given I am viewing team statistics
    When I export the data
    Then I should receive a downloadable file
    And all statistics should be included

  @happy-path @team-statistics
  Scenario: View statistical trends
    Given I am viewing team statistics
    When I view trend charts
    Then I should see performance trends over time
    And improvement or decline should be visible

  # ============================================================================
  # TEAM HISTORY
  # ============================================================================

  @happy-path @team-history
  Scenario: View past seasons
    Given I have played multiple seasons
    When I view team history
    Then I should see all past seasons
    And final standings should be shown for each

  @happy-path @team-history
  Scenario: View championship wins
    Given I have won championships
    When I view team history
    Then championship seasons should be highlighted
    And trophies should be displayed

  @happy-path @team-history
  Scenario: View playoff appearances
    Given I have made playoffs
    When I view team history
    Then playoff seasons should be indicated
    And playoff performance should be shown

  @happy-path @team-history
  Scenario: View team records
    Given I am viewing team history
    When I check team records
    Then I should see best/worst performances
    And records should include various categories

  @happy-path @team-history
  Scenario: View historical rosters
    Given I am viewing team history
    When I select a past season
    Then I should see that season's roster
    And player stats from that season should be shown

  @happy-path @team-history
  Scenario: View head-to-head history
    Given I am viewing team history
    When I check rivalry records
    Then I should see records vs each opponent
    And all-time matchup history should be available

  @happy-path @team-history
  Scenario: View draft history
    Given I am viewing team history
    When I check draft history
    Then I should see all draft picks by season
    And pick outcomes should be evaluated

  # ============================================================================
  # TEAM COMPARISON
  # ============================================================================

  @happy-path @team-comparison
  Scenario: Compare to league average
    Given I am on team comparison
    When I compare to league average
    Then I should see how my team ranks
    And strengths and weaknesses should be highlighted

  @happy-path @team-comparison
  Scenario: Compare to specific opponent
    Given I am on team comparison
    When I select an opponent to compare
    Then I should see side-by-side comparison
    And position matchups should be shown

  @happy-path @team-comparison
  Scenario: View power ranking comparison
    Given I am on team comparison
    When I view power rankings
    Then I should see my ranking vs others
    And ranking factors should be explained

  @happy-path @team-comparison
  Scenario: View strength metrics comparison
    Given I am on team comparison
    When I view strength metrics
    Then I should see various strength indicators
    And relative rankings should be shown

  @happy-path @team-comparison
  Scenario: Compare roster depth
    Given I am on team comparison
    When I compare roster depth
    Then I should see depth at each position
    And depth advantages should be highlighted

  @happy-path @team-comparison
  Scenario: Compare schedule strength
    Given I am on team comparison
    When I compare schedules
    Then I should see strength of schedule
    And remaining schedule difficulty should be shown

  @mobile @team-comparison
  Scenario: View team comparison on mobile
    Given I am on a mobile device
    When I compare teams
    Then the comparison should be mobile-friendly
    And I should be able to swipe between stats

  # ============================================================================
  # TEAM VALUE
  # ============================================================================

  @happy-path @team-value
  Scenario: View dynasty team value
    Given my league is a dynasty league
    When I view team value
    Then I should see total dynasty value
    And value should factor in player ages

  @happy-path @team-value
  Scenario: View trade value summary
    Given I am viewing team value
    Then I should see trade value for each player
    And total roster trade value should be shown

  @happy-path @team-value
  Scenario: View roster worth breakdown
    Given I am viewing team value
    When I view roster worth
    Then I should see value by position
    And asset distribution should be visible

  @happy-path @team-value
  Scenario: View asset breakdown
    Given I am viewing team value
    When I view asset breakdown
    Then I should see players categorized by value tier
    And draft picks should be valued

  @happy-path @team-value
  Scenario: Compare team value to league
    Given I am viewing team value
    When I compare to other teams
    Then I should see relative value ranking
    And value gaps should be quantified

  @happy-path @team-value
  Scenario: View value trends over time
    Given I am viewing team value
    When I view value history
    Then I should see how value has changed
    And value trajectory should be shown

  @happy-path @team-value
  Scenario: View value projections
    Given I am viewing team value
    When I view future projections
    Then I should see projected future value
    And aging curves should be factored in

  # ============================================================================
  # TEAM MANAGEMENT
  # ============================================================================

  @happy-path @team-management
  Scenario: Rename team
    Given I am managing my team
    When I change my team name
    Then the new name should be saved
    And it should update everywhere

  @happy-path @team-management
  Scenario: Transfer team ownership
    Given I want to transfer my team
    When I initiate ownership transfer
    And the new owner accepts
    Then ownership should transfer
    And I should lose access to the team

  @happy-path @team-management
  Scenario: Archive inactive team
    Given the season has ended
    When I archive my team
    Then the team should be marked as archived
    And historical data should be preserved

  @happy-path @team-management
  Scenario: Reactivate archived team
    Given I have an archived team
    When I reactivate the team
    Then the team should become active
    And I should regain full access

  @commissioner @team-management
  Scenario: Delete abandoned team
    Given I am a league commissioner
    And a team has been abandoned
    When I delete the team
    Then the team should be removed
    And roster should become free agents

  @happy-path @team-management
  Scenario: Set team to autopilot
    Given I will be unavailable
    When I enable autopilot mode
    Then my team should auto-manage
    And lineups should be set automatically

  @happy-path @team-management
  Scenario: Disable autopilot mode
    Given my team is on autopilot
    When I disable autopilot
    Then I should regain manual control
    And auto-management should stop

  @error @team-management
  Scenario: Attempt to delete active team
    Given my team is active in a league
    When I try to delete my team
    Then I should see an error message
    And deletion should be blocked

  # ============================================================================
  # TEAM NOTIFICATIONS
  # ============================================================================

  @happy-path @team-notifications
  Scenario: Receive roster alerts
    Given I have notifications enabled
    When a roster event occurs
    Then I should receive a roster alert
    And the alert should describe the event

  @happy-path @team-notifications
  Scenario: Receive matchup reminders
    Given I have notifications enabled
    When a matchup is approaching
    Then I should receive a reminder
    And the reminder should include lineup status

  @happy-path @team-notifications
  Scenario: Receive trade offer notifications
    Given I have notifications enabled
    When I receive a trade offer
    Then I should be notified immediately
    And the notification should summarize the offer

  @happy-path @team-notifications
  Scenario: Receive league news notifications
    Given I have notifications enabled
    When league news is posted
    Then I should receive a notification
    And I should be able to read the news

  @happy-path @team-notifications
  Scenario: Configure notification preferences
    Given I am in notification settings
    When I configure my preferences
    Then I should enable/disable notification types
    And I should set notification methods

  @happy-path @team-notifications
  Scenario: Receive player injury alerts
    Given I have a player who gets injured
    Then I should receive an injury alert
    And the alert should include injury details

  @happy-path @team-notifications
  Scenario: Receive bye week warnings
    Given I have players on bye this week
    Then I should receive bye week warnings
    And the warning should list affected players

  @mobile @team-notifications
  Scenario: Receive push notifications
    Given I have push notifications enabled
    When a team event occurs
    Then I should receive a push notification
    And I should be able to take action from notification

  @happy-path @team-notifications
  Scenario: View notification history
    Given I have received notifications
    When I view notification history
    Then I should see all past notifications
    And notifications should be organized by date

  @error @team-notifications
  Scenario: Handle notification delivery failure
    Given a notification fails to deliver
    Then the system should retry delivery
    And failed notifications should be logged
