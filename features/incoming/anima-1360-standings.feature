@standings @anima-1360
Feature: Standings
  As a fantasy football manager
  I want to view and analyze league standings
  So that I can track my position and playoff chances throughout the season

  Background:
    Given I am a logged-in user
    And I have at least one fantasy team
    And the current fantasy season is active

  # ============================================================================
  # LEAGUE STANDINGS
  # ============================================================================

  @happy-path @league-standings
  Scenario: View overall league standings
    Given I am on the league page
    When I navigate to standings
    Then I should see all teams ranked by record
    And standings should show win-loss records
    And standings should display points for and against

  @happy-path @league-standings
  Scenario: View standings with winning percentage
    Given I am viewing league standings
    Then I should see winning percentage for each team
    And teams should be sorted by winning percentage

  @happy-path @league-standings
  Scenario: View standings with points for
    Given I am viewing league standings
    Then I should see total points scored by each team
    And points for should be sortable

  @happy-path @league-standings
  Scenario: View standings with points against
    Given I am viewing league standings
    Then I should see total points allowed by each team
    And points against should be sortable

  @happy-path @league-standings
  Scenario: View standings with current streak
    Given I am viewing league standings
    Then I should see current win/loss streak for each team
    And streak should display format like "W3" or "L2"

  @happy-path @league-standings
  Scenario: View standings with last 5 games
    Given I am viewing league standings
    Then I should see results of last 5 games for each team
    And recent performance should be visually indicated

  @happy-path @league-standings
  Scenario: Sort standings by different columns
    Given I am viewing league standings
    When I click on a column header
    Then standings should sort by that column
    And sort direction should toggle on repeated clicks

  @happy-path @league-standings
  Scenario: View my team highlighted in standings
    Given I am viewing league standings
    Then my team should be visually highlighted
    And I should easily identify my position

  @mobile @league-standings
  Scenario: View league standings on mobile
    Given I am on a mobile device
    When I view league standings
    Then standings should be mobile-optimized
    And I should be able to scroll horizontally for more data

  @accessibility @league-standings
  Scenario: Navigate standings with screen reader
    Given I am using a screen reader
    When I navigate to standings
    Then all team rankings should be announced
    And table structure should be accessible

  # ============================================================================
  # DIVISION STANDINGS
  # ============================================================================

  @happy-path @division-standings
  Scenario: View division standings
    Given my league has divisions
    When I view division standings
    Then I should see teams grouped by division
    And each division should show its own rankings

  @happy-path @division-standings
  Scenario: View division leaders
    Given I am viewing division standings
    Then division leaders should be clearly indicated
    And leaders should appear at top of each division

  @happy-path @division-standings
  Scenario: View wildcard standings
    Given my league has wildcard playoff spots
    When I view wildcard standings
    Then I should see teams competing for wildcard
    And wildcard cutoff should be indicated

  @happy-path @division-standings
  Scenario: View division records
    Given I am viewing division standings
    Then I should see each team's divisional record
    And divisional record should show wins and losses

  @happy-path @division-standings
  Scenario: View games behind division leader
    Given I am viewing division standings
    Then I should see games behind for each team
    And the leader should show "-" for games behind

  @happy-path @division-standings
  Scenario: Compare divisions side by side
    Given my league has multiple divisions
    When I select division comparison view
    Then I should see divisions displayed side by side
    And I should be able to compare division strength

  @error @division-standings
  Scenario: View standings when league has no divisions
    Given my league does not have divisions
    When I navigate to division standings
    Then I should see a message that divisions are not configured
    And I should be redirected to overall standings

  # ============================================================================
  # PLAYOFF STANDINGS
  # ============================================================================

  @happy-path @playoff-standings
  Scenario: View playoff picture
    Given the season is in progress
    When I view the playoff picture
    Then I should see teams in playoff position
    And I should see teams outside playoff position
    And the playoff cutoff line should be visible

  @happy-path @playoff-standings
  Scenario: View clinching scenarios
    Given I am viewing playoff standings
    When teams are close to clinching
    Then I should see clinching scenarios
    And scenarios should show what teams need to clinch

  @happy-path @playoff-standings
  Scenario: View elimination scenarios
    Given I am viewing playoff standings
    When teams are at risk of elimination
    Then I should see elimination scenarios
    And scenarios should show how teams can be eliminated

  @happy-path @playoff-standings
  Scenario: View magic numbers
    Given I am viewing playoff standings
    Then I should see magic numbers for clinching
    And magic numbers should update after each week

  @happy-path @playoff-standings
  Scenario: View playoff bracket preview
    Given playoff positions are taking shape
    When I view playoff bracket preview
    Then I should see projected matchups
    And seeding should be based on current standings

  @happy-path @playoff-standings
  Scenario: View clinched status indicators
    Given some teams have clinched playoff spots
    When I view playoff standings
    Then clinched teams should have special indicators
    And clinch type should be shown (division, wildcard, bye)

  @happy-path @playoff-standings
  Scenario: View eliminated status indicators
    Given some teams have been eliminated
    When I view playoff standings
    Then eliminated teams should be marked
    And elimination should be visually distinct

  @happy-path @playoff-standings
  Scenario: Filter playoff standings by conference
    Given my league has conferences
    When I filter by conference
    Then I should see only that conference's playoff picture

  # ============================================================================
  # POWER RANKINGS
  # ============================================================================

  @happy-path @power-rankings
  Scenario: View algorithmic power rankings
    Given I am on the standings page
    When I view power rankings
    Then I should see teams ranked by algorithm
    And rankings should consider multiple factors

  @happy-path @power-rankings
  Scenario: View power ranking factors
    Given I am viewing power rankings
    When I view ranking details
    Then I should see factors contributing to rankings
    And factors should include strength of schedule

  @happy-path @power-rankings
  Scenario: View expert power rankings
    Given expert rankings are available
    When I view expert power rankings
    Then I should see expert-generated rankings
    And expert names should be credited

  @happy-path @power-rankings
  Scenario: View composite power rankings
    Given multiple ranking sources exist
    When I view composite rankings
    Then I should see averaged/weighted rankings
    And source contributions should be visible

  @happy-path @power-rankings
  Scenario: View weekly power ranking changes
    Given I am viewing power rankings
    Then I should see weekly movement indicators
    And teams moving up should show green arrows
    And teams moving down should show red arrows

  @happy-path @power-rankings
  Scenario: View power ranking history
    Given I am viewing power rankings
    When I select a previous week
    Then I should see power rankings from that week
    And I should be able to compare to current

  @happy-path @power-rankings
  Scenario: View power ranking explanation
    Given I am viewing my team's power ranking
    When I request explanation
    Then I should see why my team is ranked there
    And strengths and weaknesses should be listed

  @happy-path @power-rankings
  Scenario: Compare power rankings to actual standings
    Given I am viewing power rankings
    When I compare to actual standings
    Then I should see differences highlighted
    And over/under performers should be identified

  # ============================================================================
  # STANDINGS HISTORY
  # ============================================================================

  @happy-path @standings-history
  Scenario: View week-by-week standings
    Given I am on the standings page
    When I select standings history
    Then I should see standings for each week
    And I should be able to navigate between weeks

  @happy-path @standings-history
  Scenario: View historical standings from past seasons
    Given I have played in previous seasons
    When I view historical standings
    Then I should see final standings from past seasons
    And I should be able to select specific seasons

  @happy-path @standings-history
  Scenario: View season progression chart
    Given I am viewing standings history
    When I select progression view
    Then I should see standings changes over time
    And a line chart should show ranking movement

  @happy-path @standings-history
  Scenario: View standings at specific point in season
    Given I am viewing standings history
    When I select a specific week
    Then I should see standings as of that week
    And all metrics should reflect that timepoint

  @happy-path @standings-history
  Scenario: Compare standings across seasons
    Given I have multiple seasons of data
    When I compare seasons
    Then I should see side-by-side season comparisons
    And trends should be identifiable

  @happy-path @standings-history
  Scenario: View trend charts for standings
    Given I am viewing standings history
    Then I should see trend charts
    And charts should show my team's progression

  @happy-path @standings-history
  Scenario: Export standings history
    Given I am viewing standings history
    When I export the data
    Then I should receive a downloadable file
    And the file should contain historical standings

  # ============================================================================
  # STANDINGS STATISTICS
  # ============================================================================

  @happy-path @standings-stats
  Scenario: View points scored statistics
    Given I am viewing standings statistics
    Then I should see total points scored by each team
    And average points per week should be shown

  @happy-path @standings-stats
  Scenario: View points allowed statistics
    Given I am viewing standings statistics
    Then I should see total points allowed by each team
    And average points against should be shown

  @happy-path @standings-stats
  Scenario: View average margin of victory
    Given I am viewing standings statistics
    Then I should see average margin for each team
    And positive margins indicate strong performance

  @happy-path @standings-stats
  Scenario: View consistency rating
    Given I am viewing standings statistics
    Then I should see consistency ratings
    And consistency should measure scoring variance

  @happy-path @standings-stats
  Scenario: View luck factor analysis
    Given I am viewing standings statistics
    Then I should see luck factor for each team
    And luck should compare expected vs actual wins

  @happy-path @standings-stats
  Scenario: View scoring efficiency
    Given I am viewing standings statistics
    Then I should see scoring efficiency metrics
    And efficiency should show points vs potential

  @happy-path @standings-stats
  Scenario: View all-play record
    Given I am viewing standings statistics
    Then I should see all-play records
    And all-play shows record vs all teams each week

  @happy-path @standings-stats
  Scenario: View statistical leaders
    Given I am viewing standings statistics
    When I view statistical leaders
    Then I should see top teams in each category
    And leaders should be highlighted

  # ============================================================================
  # TIEBREAKER DISPLAY
  # ============================================================================

  @happy-path @tiebreaker
  Scenario: View tiebreaker rules
    Given I am on the standings page
    When I view tiebreaker information
    Then I should see the tiebreaker rules
    And rules should be in priority order

  @happy-path @tiebreaker
  Scenario: View head-to-head records
    Given teams are tied in standings
    When I view head-to-head tiebreaker
    Then I should see head-to-head records
    And the winner of head-to-head should be indicated

  @happy-path @tiebreaker
  Scenario: View divisional records for tiebreaker
    Given teams are tied after head-to-head
    When I view divisional record tiebreaker
    Then I should see divisional records compared
    And the better divisional record should be highlighted

  @happy-path @tiebreaker
  Scenario: View common opponents tiebreaker
    Given teams are tied and share common opponents
    When I view common opponents tiebreaker
    Then I should see records against common opponents
    And the comparison should be clear

  @happy-path @tiebreaker
  Scenario: View points for tiebreaker
    Given teams are tied after other tiebreakers
    When I view points for tiebreaker
    Then I should see total points comparison
    And the team with more points should be highlighted

  @happy-path @tiebreaker
  Scenario: View tiebreaker application in standings
    Given multiple teams have the same record
    Then tiebreakers should be automatically applied
    And the standings should reflect tiebreaker results

  @happy-path @tiebreaker
  Scenario: View tiebreaker explanation
    Given teams are separated by tiebreaker
    When I click on tiebreaker indicator
    Then I should see which tiebreaker was applied
    And the deciding factor should be explained

  # ============================================================================
  # STANDINGS PROJECTIONS
  # ============================================================================

  @happy-path @standings-projections
  Scenario: View projected final standings
    Given the season is in progress
    When I view projected standings
    Then I should see projected final positions
    And projections should be based on remaining schedule

  @happy-path @standings-projections
  Scenario: View playoff probability
    Given I am viewing standings projections
    Then I should see playoff probability for each team
    And probability should be displayed as percentage

  @happy-path @standings-projections
  Scenario: View championship odds
    Given I am viewing standings projections
    Then I should see championship odds for each team
    And odds should factor in roster strength

  @happy-path @standings-projections
  Scenario: View division winner probability
    Given my league has divisions
    When I view projections
    Then I should see division winner probabilities
    And each division should show likely winner

  @happy-path @standings-projections
  Scenario: View projection methodology
    Given I am viewing standings projections
    When I view methodology
    Then I should see how projections are calculated
    And key factors should be explained

  @happy-path @standings-projections
  Scenario: View projection confidence intervals
    Given I am viewing standings projections
    Then I should see confidence ranges
    And ranges should indicate projection certainty

  @happy-path @standings-projections
  Scenario: Compare projections to current standings
    Given I am viewing projections
    When I compare to current standings
    Then I should see expected changes
    And teams likely to move should be highlighted

  @happy-path @standings-projections
  Scenario: View weekly projection updates
    Given projections update weekly
    When I view projection changes
    Then I should see how projections changed
    And significant changes should be highlighted

  # ============================================================================
  # STANDINGS COMPARISON
  # ============================================================================

  @happy-path @standings-comparison
  Scenario: Compare two teams in standings
    Given I am viewing standings
    When I select two teams to compare
    Then I should see head-to-head comparison
    And all relevant stats should be compared

  @happy-path @standings-comparison
  Scenario: View historical matchup record
    Given I am comparing two teams
    When I view historical matchups
    Then I should see all-time head-to-head record
    And matchup history should include scores

  @happy-path @standings-comparison
  Scenario: View all-time records
    Given I am viewing team comparison
    Then I should see all-time records for both teams
    And records should span all seasons

  @happy-path @standings-comparison
  Scenario: View rivalry information
    Given two teams have played many times
    When I view rivalry details
    Then I should see rivalry statistics
    And notable matchups should be highlighted

  @happy-path @standings-comparison
  Scenario: Compare multiple teams simultaneously
    Given I want to compare several teams
    When I select multiple teams
    Then I should see multi-team comparison
    And key metrics should be side by side

  @happy-path @standings-comparison
  Scenario: View strength of schedule comparison
    Given I am comparing teams
    Then I should see strength of schedule
    And future schedule difficulty should be shown

  @mobile @standings-comparison
  Scenario: View standings comparison on mobile
    Given I am on a mobile device
    When I compare teams
    Then the comparison should be mobile-friendly
    And I should be able to swipe between stats

  # ============================================================================
  # STANDINGS NOTIFICATIONS
  # ============================================================================

  @happy-path @standings-notifications
  Scenario: Receive clinch alert
    Given my team has clinched a playoff spot
    Then I should receive a clinch notification
    And the notification should specify what was clinched

  @happy-path @standings-notifications
  Scenario: Receive elimination alert
    Given my team has been mathematically eliminated
    Then I should receive an elimination notification
    And the notification should explain the elimination

  @happy-path @standings-notifications
  Scenario: Receive division leader change alert
    Given the division leader changes
    When I have alerts enabled
    Then I should receive a division leader notification
    And the notification should show old and new leader

  @happy-path @standings-notifications
  Scenario: Receive ranking move alert
    Given my team moves significantly in rankings
    Then I should receive a ranking change notification
    And the notification should show position change

  @happy-path @standings-notifications
  Scenario: Configure standings notification preferences
    Given I am in notification settings
    When I configure standings alerts
    Then I should be able to enable/disable alert types
    And I should set notification thresholds

  @happy-path @standings-notifications
  Scenario: Receive weekly standings summary
    Given I have weekly summary enabled
    When the week ends
    Then I should receive a standings summary
    And the summary should show my position and changes

  @happy-path @standings-notifications
  Scenario: Receive playoff race update
    Given playoff positions are competitive
    When standings change affects playoff picture
    Then I should receive playoff race updates

  @mobile @standings-notifications
  Scenario: Receive push notification for standings
    Given I have push notifications enabled
    When a significant standings event occurs
    Then I should receive a push notification

  @error @standings-notifications
  Scenario: Handle notification delivery failure
    Given a notification fails to deliver
    Then the system should retry delivery
    And the notification should be logged

  @commissioner @standings-notifications
  Scenario: Send custom standings announcement
    Given I am a league commissioner
    When I send a standings announcement
    Then all league members should receive it
    And the announcement should include standings data
