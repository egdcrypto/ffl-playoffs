@standings
Feature: Standings
  As a fantasy football league member
  I want to view comprehensive standings information
  So that I can track my position and playoff chances

  # League Standings Scenarios
  @league-standings
  Scenario: View overall league standings
    Given the season is in progress
    When I view league standings
    Then I should see all teams ranked
    And I should see current positions
    And my team should be highlighted

  @league-standings
  Scenario: View win-loss records
    Given teams have played games
    When I view standings
    Then I should see wins for each team
    And I should see losses for each team
    And I should see ties if applicable

  @league-standings
  Scenario: View points for and against
    Given teams have scored points
    When I view standings
    Then I should see total points for
    And I should see total points against
    And I should see point differential

  @league-standings
  Scenario: View winning percentage
    Given teams have records
    When I view standings
    Then I should see winning percentage
    And percentages should be accurate
    And sorting by percentage should work

  @league-standings
  Scenario: View games back
    Given teams have different records
    When I view standings
    Then I should see games back from first
    And calculation should be correct
    And leader should show as "-"

  @league-standings
  Scenario: View streak information
    Given teams have recent results
    When I view standings
    Then I should see current streaks
    And win streaks should show as W#
    And loss streaks should show as L#

  @league-standings
  Scenario: View last 5 games record
    Given teams have played at least 5 games
    When I view standings
    Then I should see recent form
    And last 5 record should display
    And trend should be indicated

  @league-standings
  Scenario: View average points per week
    Given teams have scored points
    When I view standings
    Then I should see average points
    And average should be accurate
    And I should be able to sort by average

  # Division Standings Scenarios
  @division-standings
  Scenario: View divisional rankings
    Given league has divisions
    When I view division standings
    Then I should see standings by division
    And each division should be separate
    And division leaders should be marked

  @division-standings
  Scenario: Identify division leaders
    Given divisions have teams
    When I view division standings
    Then leaders should be highlighted
    And leader indicators should be clear
    And tiebreakers should be applied

  @division-standings
  Scenario: View cross-division records
    Given teams play cross-division games
    When I view standings details
    Then I should see cross-division record
    And I should see in-division record
    And both should be accurate

  @division-standings
  Scenario: Apply division tiebreakers
    Given division teams are tied
    When tiebreakers are applied
    Then correct tiebreaker should determine order
    And tiebreaker used should be noted
    And result should be fair

  @division-standings
  Scenario: View division standings table
    Given divisions are configured
    When I view division table
    Then I should see all divisions
    And standings should be correct
    And navigation between divisions should work

  @division-standings
  Scenario: Compare divisions
    Given multiple divisions exist
    When I compare divisions
    Then I should see division strengths
    And cross-division performance should show
    And comparison should be insightful

  @division-standings
  Scenario: View division clinching status
    Given division race is ongoing
    When I view division standings
    Then clinched status should show
    And magic numbers should display
    And scenarios should be explained

  @division-standings
  Scenario: View division historical performance
    Given divisions have history
    When I view division history
    Then past champions should show
    And division records should display
    And trends should be visible

  # Playoff Standings Scenarios
  @playoff-standings
  Scenario: View playoff seeding
    Given playoffs are approaching
    When I view playoff standings
    Then I should see current seeds
    And seeding criteria should be clear
    And playoff teams should be highlighted

  @playoff-standings
  Scenario: View playoff picture
    Given season is in progress
    When I view playoff picture
    Then I should see who's in
    And I should see who's out
    And I should see bubble teams

  @playoff-standings
  Scenario: View clinching scenarios
    Given playoff race is ongoing
    When I view clinching scenarios
    Then I should see what I need to clinch
    And magic numbers should display
    And scenarios should be accurate

  @playoff-standings
  Scenario: View elimination scenarios
    Given some teams are at risk
    When I view elimination scenarios
    Then I should see elimination numbers
    And I should see what eliminates me
    And scenarios should be clear

  @playoff-standings
  Scenario: View wildcard standings
    Given wildcard spots exist
    When I view wildcard race
    Then I should see wildcard contenders
    And I should see wildcard cutoff
    And I should see games back

  @playoff-standings
  Scenario: View bye week seeds
    Given top seeds get byes
    When I view playoff seeding
    Then bye-eligible seeds should be marked
    And bye threshold should be clear
    And bye impact should be explained

  @playoff-standings
  Scenario: View playoff bracket preview
    Given playoff field is taking shape
    When I view bracket preview
    Then projected matchups should show
    And seeds should be indicated
    And preview should update with standings

  @playoff-standings
  Scenario: View playoff tiebreakers
    Given playoff spots may be tied
    When I view tiebreaker rules
    Then playoff tiebreakers should display
    And application should be clear
    And I should understand how they work

  # Power Rankings Scenarios
  @power-rankings
  Scenario: View weekly power rankings
    Given week has completed
    When I view power rankings
    Then I should see all teams ranked
    And rankings should reflect performance
    And my ranking should be clear

  @power-rankings
  Scenario: Understand ranking algorithm
    Given power rankings are displayed
    When I view ranking methodology
    Then algorithm should be explained
    And factors should be listed
    And weights should be shown

  @power-rankings
  Scenario: View ranking history
    Given multiple weeks have passed
    When I view ranking history
    Then I should see rankings over time
    And I should see my trajectory
    And trends should be visible

  @power-rankings
  Scenario: View ranking trends
    Given rankings change weekly
    When I view trends
    Then rising teams should be identified
    And falling teams should be identified
    And momentum should be indicated

  @power-rankings
  Scenario: Compare power ranking to standings
    Given rankings differ from standings
    When I compare
    Then differences should be highlighted
    And reasons should be explainable
    And both views should be valuable

  @power-rankings
  Scenario: View power ranking breakdown
    Given ranking has components
    When I view breakdown
    Then I should see scoring component
    And I should see consistency component
    And I should see strength of schedule

  @power-rankings
  Scenario: Share power rankings
    Given power rankings are interesting
    When I share rankings
    Then rankings should be shareable
    And format should be attractive
    And recipients should understand

  @power-rankings
  Scenario: View league-voted rankings
    Given league allows voting
    When I view voted rankings
    Then member votes should aggregate
    And I should be able to vote
    And results should be visible

  # Standings Tiebreakers Scenarios
  @standings-tiebreakers
  Scenario: Apply head-to-head tiebreaker
    Given two teams are tied
    And they have played each other
    When tiebreaker is applied
    Then head-to-head winner should rank higher
    And record should be shown
    And tiebreaker should be noted

  @standings-tiebreakers
  Scenario: Apply points scored tiebreaker
    Given teams are tied on record
    When points tiebreaker applies
    Then higher scorer should rank higher
    And point totals should show
    And tiebreaker should be clear

  @standings-tiebreakers
  Scenario: Apply division record tiebreaker
    Given divisional teams are tied
    When division record applies
    Then better division record wins
    And division records should show
    And tiebreaker should be noted

  @standings-tiebreakers
  Scenario: Apply strength of schedule tiebreaker
    Given other tiebreakers are tied
    When strength of schedule applies
    Then tougher schedule should win
    And SOS should be calculated
    And result should be fair

  @standings-tiebreakers
  Scenario: Handle multi-team tiebreaker
    Given three or more teams are tied
    When tiebreaker is applied
    Then all teams should be considered
    And proper procedure should follow
    And all positions should be determined

  @standings-tiebreakers
  Scenario: View tiebreaker details
    Given tiebreaker has been applied
    When I view tiebreaker details
    Then I should see which was used
    And I should see the values
    And I should understand the outcome

  @standings-tiebreakers
  Scenario: Configure tiebreaker order
    Given I am a commissioner
    When I configure tiebreakers
    Then I should set tiebreaker priority
    And I should select from options
    And settings should save

  @standings-tiebreakers
  Scenario: Preview tiebreaker scenarios
    Given ties may occur
    When I preview scenarios
    Then I should see potential outcomes
    And tiebreaker impact should be clear
    And I should understand implications

  # Weekly Standings Scenarios
  @weekly-standings
  Scenario: View weekly standings updates
    Given week has completed
    When I view updated standings
    Then standings should reflect results
    And changes should be visible
    And update time should show

  @weekly-standings
  Scenario: View standings movement
    Given standings have changed
    When I view movement
    Then I should see position changes
    And arrows should indicate direction
    And magnitude should be shown

  @weekly-standings
  Scenario: View risers and fallers
    Given teams have moved significantly
    When I view risers and fallers
    Then biggest movers should highlight
    And risers should be celebrated
    And fallers should be noted

  @weekly-standings
  Scenario: View week-over-week changes
    Given multiple weeks exist
    When I compare weeks
    Then I should see position changes
    And point changes should show
    And trends should be visible

  @weekly-standings
  Scenario: View standings as of specific week
    Given season has progressed
    When I select a past week
    Then standings as of that week should show
    And I should navigate weeks
    And historical view should be accurate

  @weekly-standings
  Scenario: View standings before and after matchups
    Given matchups affect standings
    When I view pre and post
    Then I should see impact of results
    And changes should be clear
    And projections vs actual should compare

  @weekly-standings
  Scenario: Receive weekly standings summary
    Given week has completed
    When summary is sent
    Then I should see standings recap
    And key changes should highlight
    And my position should be noted

  @weekly-standings
  Scenario: View live standings during games
    Given games are in progress
    When I view live standings
    Then standings should update live
    And projected changes should show
    And final standings should differ

  # Standings History Scenarios
  @standings-history
  Scenario: View historical final standings
    Given past seasons exist
    When I view historical standings
    Then I should see past final standings
    And champions should be highlighted
    And I should navigate seasons

  @standings-history
  Scenario: View final standings archive
    Given seasons have been archived
    When I access archive
    Then all seasons should be available
    And details should be preserved
    And access should be easy

  @standings-history
  Scenario: View all-time records
    Given league has history
    When I view all-time records
    Then best records should show
    And worst records should show
    And notable achievements should highlight

  @standings-history
  Scenario: Compare seasons
    Given multiple seasons exist
    When I compare seasons
    Then standings should compare
    And team performance should compare
    And trends should emerge

  @standings-history
  Scenario: View personal standings history
    Given I have participated in multiple seasons
    When I view my history
    Then I should see my finishes
    And I should see improvement
    And milestones should be noted

  @standings-history
  Scenario: Export standings history
    Given standings history exists
    When I export history
    Then export should include all data
    And format should be selectable
    And export should be complete

  @standings-history
  Scenario: View championship history
    Given championships have been won
    When I view championship history
    Then I should see all champions
    And I should see runner-ups
    And dynasty streaks should show

  @standings-history
  Scenario: View rivalry history in standings
    Given rivalries exist
    When I view rivalry standings
    Then head-to-head should show
    And all-time record should display
    And key matchups should highlight

  # Standings Projections Scenarios
  @standings-projections
  Scenario: View projected final standings
    Given season is in progress
    When I view projections
    Then projected final standings should show
    And projections should be reasonable
    And confidence should be indicated

  @standings-projections
  Scenario: View playoff odds
    Given playoff race is ongoing
    When I view playoff odds
    Then I should see my playoff chances
    And odds should be percentage
    And all teams should have odds

  @standings-projections
  Scenario: View simulation results
    Given simulations have run
    When I view simulation results
    Then I should see projected outcomes
    And I should see distribution
    And methodology should be explained

  @standings-projections
  Scenario: Perform scenario analysis
    Given I want to explore scenarios
    When I run scenario analysis
    Then I should input scenarios
    And I should see resulting standings
    And multiple scenarios should compare

  @standings-projections
  Scenario: View championship odds
    Given season is progressing
    When I view championship odds
    Then I should see title chances
    And contenders should be identified
    And odds should update

  @standings-projections
  Scenario: View projected draft position
    Given non-playoff teams exist
    When I view draft projections
    Then projected draft order should show
    And lottery odds should factor in
    And projections should be fair

  @standings-projections
  Scenario: Update projections with results
    Given new results are in
    When projections update
    Then projections should reflect results
    And changes should be visible
    And accuracy should improve

  @standings-projections
  Scenario: Compare projection sources
    Given multiple projection models exist
    When I compare sources
    Then different projections should show
    And I should see variance
    And I should choose preferred source

  # Standings Display Scenarios
  @standings-display
  Scenario: View standings table format
    Given standings data exists
    When I view standings table
    Then table should be well formatted
    And columns should be appropriate
    And data should be aligned

  @standings-display
  Scenario: Sort standings by column
    Given standings table is displayed
    When I sort by a column
    Then standings should reorder
    And sort indicator should show
    And sort should be toggleable

  @standings-display
  Scenario: Filter standings display
    Given standings are displayed
    When I apply filters
    Then filtered standings should show
    And I should filter by division
    And filters should combine

  @standings-display
  Scenario: View standings on mobile
    Given I am on mobile device
    When I view standings
    Then display should be mobile-optimized
    And data should be readable
    And scrolling should work properly

  @standings-display
  Scenario: Customize standings columns
    Given standings have many columns
    When I customize display
    Then I should choose visible columns
    And preferences should save
    And display should update

  @standings-display
  Scenario: Expand standings row
    Given I want more details
    When I expand a team row
    Then additional details should show
    And details should be relevant
    And I should be able to collapse

  @standings-display
  Scenario: Print standings
    Given I want to print standings
    When I print
    Then print format should be clean
    And all data should be included
    And print should be readable

  @standings-display
  Scenario: Switch standings views
    Given multiple views exist
    When I switch views
    Then view should change
    And data should be consistent
    And I should navigate between views

  # Standings Notifications Scenarios
  @standings-notifications
  Scenario: Receive standings update alerts
    Given standings have changed
    When update alert triggers
    Then I should receive notification
    And changes should be summarized
    And I should see new position

  @standings-notifications
  Scenario: Receive playoff clinch notification
    Given I clinch playoff spot
    When clinch occurs
    Then I should receive notification
    And clinch should be celebrated
    And details should be included

  @standings-notifications
  Scenario: Receive elimination alert
    Given I am eliminated
    When elimination occurs
    Then I should receive notification
    And elimination should be noted
    And next steps should be suggested

  @standings-notifications
  Scenario: Receive ranking change notification
    Given my power ranking changed
    When significant change occurs
    Then I should be notified
    And change should be explained
    And new ranking should show

  @standings-notifications
  Scenario: Configure standings notification preferences
    Given I want to customize alerts
    When I configure preferences
    Then I should set alert types
    And I should set thresholds
    And preferences should save

  @standings-notifications
  Scenario: Receive magic number alerts
    Given magic number is low
    When number decreases
    Then I should be notified
    And magic number should show
    And clinching scenario should explain

  @standings-notifications
  Scenario: Receive division standings alerts
    Given division race is close
    When standings change
    Then I should be alerted
    And division impact should be clear
    And position should be noted

  @standings-notifications
  Scenario: Receive weekly standings summary
    Given week has completed
    When summary is generated
    Then I should receive summary
    And key standings points should highlight
    And my status should be clear

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle standings calculation error
    Given standings are being calculated
    When calculation error occurs
    Then error should be logged
    And last known standings should show
    And users should be notified

  @error-handling
  Scenario: Handle missing game results
    Given some results are missing
    When standings are displayed
    Then partial standings should show
    And missing data should be noted
    And updates should be expected

  @error-handling
  Scenario: Handle tiebreaker calculation failure
    Given tiebreaker needs calculating
    When calculation fails
    Then fallback order should apply
    And issue should be logged
    And commissioner should review

  @error-handling
  Scenario: Handle projection service unavailable
    Given projection service is down
    When I view projections
    Then unavailable message should show
    And cached data may display
    And alternative should be offered

  @error-handling
  Scenario: Handle standings sync issue
    Given standings are out of sync
    When sync issue is detected
    Then reconciliation should occur
    And users should be notified
    And correct data should prevail

  @error-handling
  Scenario: Handle division configuration error
    Given division config is invalid
    When standings are accessed
    Then graceful handling should occur
    And league standings should show
    And commissioner should be alerted

  @error-handling
  Scenario: Handle historical data unavailable
    Given historical data is missing
    When history is accessed
    Then available data should show
    And missing data should be noted
    And alternatives should be suggested

  @error-handling
  Scenario: Handle concurrent standings updates
    Given multiple updates happen
    When updates conflict
    Then last update should win
    And consistency should be maintained
    And audit trail should exist

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate standings with keyboard
    Given I am viewing standings
    When I navigate with keyboard
    Then all features should be accessible
    And focus should be visible
    And actions should be executable

  @accessibility
  Scenario: Screen reader announces standings
    Given I am using a screen reader
    When I view standings
    Then positions should be announced
    And records should be stated
    And my team should be identified

  @accessibility
  Scenario: High contrast standings display
    Given high contrast mode is enabled
    When I view standings
    Then all text should be visible
    And position indicators should be clear
    And highlighting should work

  @accessibility
  Scenario: Standings table is accessible
    Given standings table is displayed
    When I navigate table
    Then headers should be announced
    And cells should be navigable
    And relationships should be clear

  @accessibility
  Scenario: Standings charts have alternatives
    Given standings charts are shown
    When I access charts
    Then text alternatives should exist
    And data should be in tables
    And trends should be describable

  @accessibility
  Scenario: Standings notifications are accessible
    Given notifications are displayed
    When I receive notification
    Then notification should be announced
    And content should be readable
    And actions should be accessible

  @accessibility
  Scenario: Mobile standings accessibility
    Given I am on mobile with accessibility
    When I view standings
    Then all features should work
    And touch targets should be adequate
    And zoom should function

  @accessibility
  Scenario: Projections are accessible
    Given projections are displayed
    When I access projections
    Then probabilities should be stated
    And scenarios should be described
    And all data should be accessible

  # Performance Scenarios
  @performance
  Scenario: Standings page loads quickly
    Given I am viewing standings
    When page loads
    Then page should load within 2 seconds
    And standings should appear promptly
    And no layout shifts should occur

  @performance
  Scenario: Standings update efficiently
    Given new results are in
    When standings update
    Then update should be fast
    And changes should appear smoothly
    And no flicker should occur

  @performance
  Scenario: Sorting performs well
    Given large standings table exists
    When I sort columns
    Then sorting should be instant
    And no delay should be perceptible
    And multiple sorts should work

  @performance
  Scenario: Projections calculate quickly
    Given projection is requested
    When calculation runs
    Then results should appear quickly
    And complex scenarios should be manageable
    And progress should show if long

  @performance
  Scenario: Historical standings load efficiently
    Given extensive history exists
    When history loads
    Then initial data should appear quickly
    And navigation should be smooth
    And older data should lazy load

  @performance
  Scenario: Live standings update smoothly
    Given games are in progress
    When standings update live
    Then updates should be smooth
    And no jarring changes should occur
    And performance should be maintained

  @performance
  Scenario: Handle many teams efficiently
    Given league has many teams
    When standings display
    Then all teams should load
    And scrolling should be smooth
    And performance should not degrade

  @performance
  Scenario: Mobile standings performance
    Given I am on mobile device
    When I view standings
    Then performance should be acceptable
    And data should be efficient
    And battery impact should be minimal
