@teams @anima-1392
Feature: Teams
  As a fantasy football user
  I want comprehensive team management tools
  So that I can create, customize, and manage my fantasy teams

  Background:
    Given I am a logged-in user
    And the team system is available

  # ============================================================================
  # TEAM CREATION
  # ============================================================================

  @happy-path @team-creation
  Scenario: Create team
    Given I joined a league
    When I create my team
    Then team should be created
    And I should be the owner

  @happy-path @team-creation
  Scenario: Name team
    Given I am creating a team
    When I enter team name
    Then team name should be saved
    And name should be displayed

  @happy-path @team-creation
  Scenario: Set team logo
    Given I am creating a team
    When I select a logo
    Then logo should be saved
    And logo should be displayed

  @happy-path @team-creation
  Scenario: Set team colors
    Given I am creating a team
    When I choose team colors
    Then colors should be saved
    And team should reflect colors

  @happy-path @team-creation
  Scenario: Set team motto
    Given I am creating a team
    When I enter team motto
    Then motto should be saved
    And motto should be displayed

  @happy-path @team-creation
  Scenario: Use team name generator
    Given I need name ideas
    When I use name generator
    Then I should see suggestions
    And I can select one

  @happy-path @team-creation
  Scenario: Preview team before creation
    Given I have set options
    When I preview team
    Then I should see preview
    And I can confirm creation

  @error @team-creation
  Scenario: Handle duplicate team name
    Given team name exists in league
    When I try to use same name
    Then I should see error
    And I should choose different name

  @happy-path @team-creation
  Scenario: Create team from template
    Given templates exist
    When I use a template
    Then settings should be applied
    And I can customize further

  @happy-path @team-creation
  Scenario: Import team settings
    Given I have settings from another league
    When I import settings
    Then settings should be applied
    And team should be configured

  # ============================================================================
  # TEAM MANAGEMENT
  # ============================================================================

  @happy-path @team-management
  Scenario: Manage team
    Given I own a team
    When I access management
    Then I should see management options
    And I can make changes

  @happy-path @team-management
  Scenario: Update team settings
    Given I have a team
    When I update settings
    Then settings should be saved
    And changes should apply

  @happy-path @team-management
  Scenario: Set team preferences
    Given I have preferences
    When I set preferences
    Then preferences should be saved
    And behavior should match

  @happy-path @team-management
  Scenario: Configure notification settings
    Given I want notifications
    When I configure notifications
    Then settings should be saved
    And I will receive notifications

  @happy-path @team-management
  Scenario: Set privacy settings
    Given I have privacy preferences
    When I set privacy options
    Then privacy should be configured
    And visibility should match

  @happy-path @team-management
  Scenario: Rename team
    Given I want a new name
    When I rename team
    Then new name should be saved
    And name should update everywhere

  @happy-path @team-management
  Scenario: Transfer team ownership
    Given I want to transfer
    When I transfer ownership
    Then new owner should be set
    And I should lose control

  @happy-path @team-management
  Scenario: Deactivate team
    Given circumstances require
    When I deactivate team
    Then team should be inactive
    And commissioner should be notified

  @happy-path @team-management
  Scenario: View team activity log
    Given activity is tracked
    When I view activity log
    Then I should see all activity
    And timestamps should be shown

  @happy-path @team-management
  Scenario: Set auto-pilot settings
    Given I may be unavailable
    When I configure auto-pilot
    Then settings should be saved
    And team should manage itself

  # ============================================================================
  # TEAM PROFILE
  # ============================================================================

  @happy-path @team-profile
  Scenario: View team page
    Given team exists
    When I view team page
    Then I should see team profile
    And all info should be displayed

  @happy-path @team-profile
  Scenario: View team stats
    Given team has stats
    When I view team stats
    Then I should see all statistics
    And performance should be clear

  @happy-path @team-profile
  Scenario: View team history
    Given team has history
    When I view team history
    Then I should see past seasons
    And records should be shown

  @happy-path @team-profile
  Scenario: View team achievements
    Given team has achievements
    When I view achievements
    Then I should see all achievements
    And trophies should be displayed

  @happy-path @team-profile
  Scenario: View public profile
    Given profile is public
    When others view my profile
    Then they should see public info
    And private info should be hidden

  @happy-path @team-profile
  Scenario: Edit team profile
    Given I own the team
    When I edit profile
    Then changes should be saved
    And profile should update

  @happy-path @team-profile
  Scenario: View team summary
    Given team info exists
    When I view summary
    Then I should see overview
    And key stats should be highlighted

  @happy-path @team-profile
  Scenario: View team milestones
    Given milestones exist
    When I view milestones
    Then I should see all milestones
    And dates should be shown

  @happy-path @team-profile
  Scenario: Share team profile
    Given profile exists
    When I share profile
    Then shareable link should be created
    And others can view

  @happy-path @team-profile
  Scenario: View team on mobile
    Given I am on mobile
    When I view team profile
    Then profile should be mobile-friendly
    And all info should be accessible

  # ============================================================================
  # TEAM BRANDING
  # ============================================================================

  @happy-path @team-branding
  Scenario: Upload custom logo
    Given I have a logo file
    When I upload logo
    Then logo should be saved
    And logo should display

  @happy-path @team-branding
  Scenario: Select from logo library
    Given logo library exists
    When I select a logo
    Then logo should be applied
    And I can customize it

  @happy-path @team-branding
  Scenario: Set team avatar
    Given I want an avatar
    When I set avatar
    Then avatar should be saved
    And avatar should display

  @happy-path @team-branding
  Scenario: Upload banner image
    Given I have banner image
    When I upload banner
    Then banner should be saved
    And banner should display

  @happy-path @team-branding
  Scenario: Customize theme
    Given themes are available
    When I customize theme
    Then theme should be applied
    And team should reflect theme

  @happy-path @team-branding
  Scenario: Reset to default branding
    Given I have custom branding
    When I reset to defaults
    Then defaults should be restored
    And I should confirm first

  @happy-path @team-branding
  Scenario: Preview branding changes
    Given I am making changes
    When I preview changes
    Then I should see preview
    And I can apply or cancel

  @happy-path @team-branding
  Scenario: Import branding from another team
    Given I have another team
    When I import branding
    Then branding should be applied
    And I can adjust

  @happy-path @team-branding
  Scenario: Create logo with editor
    Given logo editor exists
    When I create logo
    Then logo should be generated
    And I can save it

  @happy-path @team-branding
  Scenario: Apply seasonal themes
    Given seasonal themes exist
    When I apply seasonal theme
    Then theme should be applied
    And I can revert later

  # ============================================================================
  # TEAM PERFORMANCE
  # ============================================================================

  @happy-path @team-performance
  Scenario: View team record
    Given games have been played
    When I view record
    Then I should see win-loss record
    And standing should be shown

  @happy-path @team-performance
  Scenario: View points scored
    Given points are tracked
    When I view points scored
    Then I should see total points
    And breakdown should be available

  @happy-path @team-performance
  Scenario: View points against
    Given opponent points tracked
    When I view points against
    Then I should see points allowed
    And comparison should be available

  @happy-path @team-performance
  Scenario: View weekly rankings
    Given rankings are calculated
    When I view weekly rankings
    Then I should see my weekly rank
    And league context should be shown

  @happy-path @team-performance
  Scenario: View season performance
    Given season is ongoing
    When I view season performance
    Then I should see overall performance
    And trends should be visible

  @happy-path @team-performance
  Scenario: View performance trends
    Given trend data exists
    When I view trends
    Then I should see performance trends
    And trajectory should be clear

  @happy-path @team-performance
  Scenario: View best/worst weeks
    Given weeks have passed
    When I view extremes
    Then I should see best and worst weeks
    And scores should be shown

  @happy-path @team-performance
  Scenario: View performance by position
    Given position data exists
    When I view by position
    Then I should see position performance
    And strengths should be identified

  @happy-path @team-performance
  Scenario: Compare to projections
    Given projections exist
    When I compare to projections
    Then I should see actual vs projected
    And variance should be shown

  @happy-path @team-performance
  Scenario: Export performance data
    Given performance data exists
    When I export data
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # TEAM COMPARISON
  # ============================================================================

  @happy-path @team-comparison
  Scenario: Compare teams
    Given multiple teams exist
    When I compare teams
    Then I should see comparison
    And differences should be highlighted

  @happy-path @team-comparison
  Scenario: View league rankings
    Given rankings exist
    When I view league rankings
    Then I should see all teams ranked
    And my position should be clear

  @happy-path @team-comparison
  Scenario: View head-to-head records
    Given matchups have occurred
    When I view head-to-head
    Then I should see H2H record
    And history should be shown

  @happy-path @team-comparison
  Scenario: View stat comparisons
    Given stats exist
    When I compare stats
    Then I should see stat comparison
    And categories should be compared

  @happy-path @team-comparison
  Scenario: View power rankings
    Given power rankings exist
    When I view power rankings
    Then I should see rankings
    And methodology should be clear

  @happy-path @team-comparison
  Scenario: Compare roster strength
    Given rosters exist
    When I compare rosters
    Then I should see roster comparison
    And strengths should be identified

  @happy-path @team-comparison
  Scenario: Compare to league average
    Given averages exist
    When I compare to average
    Then I should see vs average
    And deviations should be shown

  @happy-path @team-comparison
  Scenario: View historical comparisons
    Given history exists
    When I compare historically
    Then I should see past comparisons
    And trends should be visible

  @happy-path @team-comparison
  Scenario: Save comparison
    Given comparison is displayed
    When I save comparison
    Then comparison should be saved
    And I can access later

  @happy-path @team-comparison
  Scenario: Share comparison
    Given comparison is displayed
    When I share comparison
    Then shareable link should be created
    And others can view

  # ============================================================================
  # TEAM ROSTER VIEW
  # ============================================================================

  @happy-path @team-roster-view
  Scenario: View roster
    Given team has players
    When I view roster
    Then I should see all players
    And positions should be clear

  @happy-path @team-roster-view
  Scenario: View depth chart
    Given depth exists
    When I view depth chart
    Then I should see depth at each position
    And order should be clear

  @happy-path @team-roster-view
  Scenario: View position breakdown
    Given roster has positions
    When I view breakdown
    Then I should see position counts
    And balance should be shown

  @happy-path @team-roster-view
  Scenario: View roster value
    Given values are calculated
    When I view roster value
    Then I should see total value
    And breakdown should be available

  @happy-path @team-roster-view
  Scenario: View roster strength
    Given strength is assessed
    When I view strength
    Then I should see strength rating
    And comparison should be shown

  @happy-path @team-roster-view
  Scenario: Filter roster view
    Given roster exists
    When I filter view
    Then I should see filtered roster
    And filter should apply

  @happy-path @team-roster-view
  Scenario: Sort roster view
    Given roster exists
    When I sort roster
    Then roster should be sorted
    And order should apply

  @happy-path @team-roster-view
  Scenario: View roster projections
    Given projections exist
    When I view projections
    Then I should see projected performance
    And totals should be shown

  @happy-path @team-roster-view
  Scenario: Export roster
    Given roster exists
    When I export roster
    Then I should receive export file
    And data should be complete

  @happy-path @team-roster-view
  Scenario: Print roster
    Given roster exists
    When I print roster
    Then printable version should open
    And format should be clean

  # ============================================================================
  # TEAM SCHEDULE
  # ============================================================================

  @happy-path @team-schedule
  Scenario: View upcoming matchups
    Given schedule exists
    When I view upcoming
    Then I should see upcoming matchups
    And opponents should be shown

  @happy-path @team-schedule
  Scenario: View past results
    Given games have been played
    When I view past results
    Then I should see all results
    And scores should be shown

  @happy-path @team-schedule
  Scenario: View remaining schedule
    Given games remain
    When I view remaining
    Then I should see remaining games
    And opponents should be listed

  @happy-path @team-schedule
  Scenario: View playoff path
    Given playoffs are possible
    When I view playoff path
    Then I should see path to playoffs
    And requirements should be shown

  @happy-path @team-schedule
  Scenario: View strength of schedule
    Given schedule is set
    When I view SOS
    Then I should see schedule strength
    And ranking should be shown

  @happy-path @team-schedule
  Scenario: View matchup difficulty
    Given matchups exist
    When I view difficulty
    Then I should see difficulty ratings
    And easy/hard should be indicated

  @happy-path @team-schedule
  Scenario: Add schedule to calendar
    Given schedule exists
    When I add to calendar
    Then calendar events should be created
    And reminders should be set

  @happy-path @team-schedule
  Scenario: View bye week
    Given bye weeks exist
    When I view schedule
    Then I should see my bye week
    And it should be highlighted

  @happy-path @team-schedule
  Scenario: Compare schedules
    Given multiple schedules exist
    When I compare schedules
    Then I should see comparison
    And differences should be shown

  @happy-path @team-schedule
  Scenario: Export schedule
    Given schedule exists
    When I export schedule
    Then I should receive export file
    And format should be selectable

  # ============================================================================
  # TEAM TRANSACTIONS
  # ============================================================================

  @happy-path @team-transactions
  Scenario: View transaction history
    Given transactions have occurred
    When I view history
    Then I should see all transactions
    And timeline should be shown

  @happy-path @team-transactions
  Scenario: View trade history
    Given trades have occurred
    When I view trade history
    Then I should see all trades
    And details should be shown

  @happy-path @team-transactions
  Scenario: View waiver claims
    Given claims have been made
    When I view waiver claims
    Then I should see all claims
    And status should be shown

  @happy-path @team-transactions
  Scenario: View draft picks
    Given picks exist
    When I view draft picks
    Then I should see all picks
    And rounds should be shown

  @happy-path @team-transactions
  Scenario: View add/drops
    Given adds/drops occurred
    When I view add/drops
    Then I should see all moves
    And dates should be shown

  @happy-path @team-transactions
  Scenario: Filter transactions
    Given transactions exist
    When I filter transactions
    Then I should see filtered results
    And filter should apply

  @happy-path @team-transactions
  Scenario: Search transactions
    Given transactions exist
    When I search transactions
    Then I should find matching records
    And results should be relevant

  @happy-path @team-transactions
  Scenario: View transaction details
    Given transaction exists
    When I view details
    Then I should see full details
    And all info should be shown

  @happy-path @team-transactions
  Scenario: Export transactions
    Given transactions exist
    When I export transactions
    Then I should receive export file
    And data should be complete

  @happy-path @team-transactions
  Scenario: View transaction stats
    Given stats are tracked
    When I view stats
    Then I should see transaction statistics
    And counts should be shown

  # ============================================================================
  # TEAM MESSAGING
  # ============================================================================

  @happy-path @team-messaging
  Scenario: View team inbox
    Given messages exist
    When I view inbox
    Then I should see all messages
    And unread should be highlighted

  @happy-path @team-messaging
  Scenario: View commissioner messages
    Given commissioner sent messages
    When I view commissioner messages
    Then I should see all announcements
    And they should be prioritized

  @happy-path @team-messaging
  Scenario: View trade offers
    Given trade offers exist
    When I view trade offers
    Then I should see all offers
    And I can respond

  @happy-path @team-messaging
  Scenario: View league notifications
    Given notifications exist
    When I view notifications
    Then I should see all notifications
    And they should be organized

  @happy-path @team-messaging
  Scenario: Configure alert settings
    Given I have preferences
    When I configure alerts
    Then settings should be saved
    And alerts should follow preferences

  @happy-path @team-messaging
  Scenario: Send message to opponent
    Given I have an opponent
    When I send message
    Then message should be delivered
    And they should be notified

  @happy-path @team-messaging
  Scenario: Mark messages as read
    Given unread messages exist
    When I mark as read
    Then messages should be marked
    And count should update

  @happy-path @team-messaging
  Scenario: Delete messages
    Given messages exist
    When I delete messages
    Then messages should be removed
    And inbox should update

  @happy-path @team-messaging
  Scenario: Search messages
    Given messages exist
    When I search messages
    Then I should find matching messages
    And results should be relevant

  @happy-path @team-messaging
  Scenario: Archive messages
    Given messages exist
    When I archive messages
    Then messages should be archived
    And I can access later

