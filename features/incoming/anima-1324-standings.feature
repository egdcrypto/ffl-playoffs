@standings @ANIMA-1324
Feature: Standings
  As a fantasy football league member
  I want to view comprehensive league standings
  So that I can track my position and playoff chances

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a league member
    And the league has active teams with game results

  # ============================================================================
  # OVERALL STANDINGS DISPLAY - HAPPY PATH
  # ============================================================================

  @happy-path @overall-standings
  Scenario: View current league standings
    Given I am on the standings page
    When I view the overall standings
    Then I should see all teams ranked by record
    And I should see win-loss records
    And I should see points for and against

  @happy-path @overall-standings
  Scenario: View standings with playoff line
    Given I am viewing standings
    When I look at the playoff picture
    Then I should see the playoff cutoff line
    And teams above the line should be highlighted
    And I should see how many teams make playoffs

  @happy-path @overall-standings
  Scenario: Sort standings by different criteria
    Given I am viewing standings
    When I change the sort criteria
    Then I should be able to sort by wins
    And I should be able to sort by points for
    And I should be able to sort by points against

  @happy-path @overall-standings
  Scenario: View standings with additional stats
    Given I am viewing standings
    When I expand standings details
    Then I should see winning percentage
    And I should see point differential
    And I should see streak information

  @happy-path @overall-standings
  Scenario: View standings in table format
    Given I am on the standings page
    When I select table view
    Then I should see a comprehensive table
    And columns should be sortable
    And I should be able to customize columns

  @happy-path @overall-standings
  Scenario: View standings in card format
    Given I am on the standings page
    When I select card view
    Then each team should appear as a card
    And cards should show key stats
    And I should see team logos and colors

  # ============================================================================
  # DIVISION STANDINGS
  # ============================================================================

  @happy-path @division-standings
  Scenario: View standings by division
    Given the league has divisions
    When I view division standings
    Then I should see standings grouped by division
    And each division should show its leader
    And division records should be displayed

  @happy-path @division-standings
  Scenario: View division leader indicators
    Given I am viewing division standings
    When I look at division leaders
    Then division leaders should be marked
    And I should see games behind leader
    And clinch scenarios should be shown

  @happy-path @division-standings
  Scenario: Compare divisions
    Given the league has multiple divisions
    When I compare divisions
    Then I should see cross-division records
    And I should see division strength metrics
    And I should see inter-division performance

  @happy-path @division-standings
  Scenario: View division vs overall standings
    Given divisions affect playoffs
    When I toggle between division and overall
    Then I should see how division winners rank
    And I should see wild card positions
    And seeding should reflect both

  # ============================================================================
  # WIN-LOSS RECORDS
  # ============================================================================

  @happy-path @win-loss
  Scenario: View detailed win-loss record
    Given I am viewing a team's record
    When I expand the record details
    Then I should see total wins and losses
    And I should see home vs away record if applicable
    And I should see division record

  @happy-path @win-loss
  Scenario: View win-loss record by opponent
    Given I am viewing a team's record
    When I view head-to-head records
    Then I should see record against each opponent
    And I should see all-time record
    And I should see current season record

  @happy-path @win-loss
  Scenario: View winning and losing streaks
    Given I am viewing standings
    When I check streak information
    Then I should see current streak for each team
    And streak type should be indicated
    And streak length should be shown

  @happy-path @win-loss
  Scenario: View record in close games
    Given I am viewing advanced standings
    When I check close game records
    Then I should see record in games within 10 points
    And I should see clutch performance rating
    And I should see luck factor analysis

  @happy-path @win-loss
  Scenario: View record by scoring threshold
    Given I am viewing team records
    When I check scoring performance
    Then I should see record when scoring above average
    And I should see record when scoring below average
    And I should see consistency metrics

  # ============================================================================
  # POINTS FOR/AGAINST TRACKING
  # ============================================================================

  @happy-path @points-tracking
  Scenario: View total points for and against
    Given I am viewing standings
    When I look at point totals
    Then I should see total points scored
    And I should see total points allowed
    And I should see point differential

  @happy-path @points-tracking
  Scenario: View weekly points breakdown
    Given I am viewing a team's points
    When I expand to weekly view
    Then I should see points for each week
    And I should see points against each week
    And I should see the matchup outcomes

  @happy-path @points-tracking
  Scenario: View average points per game
    Given I am viewing standings
    When I check scoring averages
    Then I should see average points for
    And I should see average points against
    And I should see league ranking for each

  @happy-path @points-tracking
  Scenario: View points trend over season
    Given I am viewing a team's scoring
    When I view the trend chart
    Then I should see scoring over time
    And I should see trend direction
    And I should see comparison to league average

  @happy-path @points-tracking
  Scenario: View highest and lowest scoring weeks
    Given I am viewing points history
    When I check extremes
    Then I should see highest scoring week
    And I should see lowest scoring week
    And I should see scoring consistency

  @happy-path @points-tracking
  Scenario: Compare points across all teams
    Given I am viewing league points
    When I compare all teams
    Then I should see points for ranking
    And I should see points against ranking
    And I should see efficiency metrics

  # ============================================================================
  # PLAYOFF SEEDING
  # ============================================================================

  @happy-path @playoff-seeding
  Scenario: View current playoff seeding
    Given playoff positions are set
    When I view playoff seeding
    Then I should see seeded positions
    And I should see matchup previews
    And I should see bye positions if applicable

  @happy-path @playoff-seeding
  Scenario: View projected playoff seeding
    Given the regular season is ongoing
    When I view projected seeding
    Then I should see projected final seeds
    And I should see seeding probability
    And I should see scenarios to change

  @happy-path @playoff-seeding
  Scenario: View seeding tiebreaker application
    Given teams are tied in record
    When I view seeding details
    Then I should see how tiebreakers apply
    And I should see tiebreaker order used
    And I should see what separates teams

  @happy-path @playoff-seeding
  Scenario: View seed matchup implications
    Given I am viewing playoff seeding
    When I check matchup implications
    Then I should see who each seed plays
    And I should see bracket position
    And I should see path to championship

  @happy-path @playoff-seeding
  Scenario: View bye week earning scenarios
    Given the league has playoff byes
    When I view bye scenarios
    Then I should see who has earned byes
    And I should see who can still earn byes
    And I should see bye clinching scenarios

  # ============================================================================
  # TIEBREAKER RULES
  # ============================================================================

  @happy-path @tiebreakers
  Scenario: View league tiebreaker rules
    Given I want to understand tiebreakers
    When I view tiebreaker rules
    Then I should see the tiebreaker order
    And I should see each rule explained
    And I should see how they apply

  @happy-path @tiebreakers
  Scenario: View active tiebreaker situations
    Given teams are tied in standings
    When I view tiebreaker breakdown
    Then I should see which tiebreaker applies
    And I should see the determining factor
    And I should see the outcome

  @happy-path @tiebreakers
  Scenario: View head-to-head tiebreaker
    Given teams are tied and have played
    When I check head-to-head record
    Then I should see their matchup results
    And I should see who wins the tiebreaker
    And I should see if it's split or decisive

  @happy-path @tiebreakers
  Scenario: View points-based tiebreaker
    Given head-to-head is even
    When I check points tiebreaker
    Then I should see total points comparison
    And I should see the point difference
    And I should see who wins on points

  @happy-path @tiebreakers
  Scenario: View multi-team tiebreaker
    Given three or more teams are tied
    When I view the tiebreaker resolution
    Then I should see how multi-way tie is broken
    And I should see combined head-to-head
    And I should see the resulting order

  # ============================================================================
  # STANDINGS HISTORY
  # ============================================================================

  @happy-path @standings-history
  Scenario: View standings from previous weeks
    Given the season has been ongoing
    When I select a previous week
    Then I should see standings as of that week
    And I should see how standings have changed
    And I should be able to compare to current

  @happy-path @standings-history
  Scenario: View standings from previous seasons
    Given there is multi-season history
    When I select a previous season
    Then I should see final standings from that season
    And I should see playoff results
    And I should see the champion

  @happy-path @standings-history
  Scenario: View standings progression animation
    Given I want to see standings evolution
    When I play standings animation
    Then I should see standings change over time
    And key movements should be highlighted
    And I can pause at any point

  @happy-path @standings-history
  Scenario: Export historical standings
    Given I want to save standings data
    When I export standings
    Then I should receive historical data
    And the format should be selectable
    And all weeks should be included

  # ============================================================================
  # WEEKLY STANDINGS MOVEMENT
  # ============================================================================

  @happy-path @standings-movement
  Scenario: View standings changes this week
    Given the current week has completed
    When I view standings movement
    Then I should see position changes
    And I should see arrows indicating direction
    And I should see how many spots moved

  @happy-path @standings-movement
  Scenario: View biggest movers this week
    Given there were standings changes
    When I view biggest movers
    Then I should see teams that moved most
    And I should see risers and fallers
    And I should see what caused movement

  @happy-path @standings-movement
  Scenario: View movement over multiple weeks
    Given several weeks have completed
    When I view movement trends
    Then I should see cumulative movement
    And I should see trajectory direction
    And I should see volatility measure

  @happy-path @standings-movement
  Scenario: Receive standings movement notification
    Given I have notifications enabled
    When standings change affects my team
    Then I should receive a notification
    And the notification should show my new position
    And I should see what changed

  # ============================================================================
  # CLINCHING SCENARIOS
  # ============================================================================

  @happy-path @clinching
  Scenario: View playoff clinching scenarios
    Given playoffs have not been clinched
    When I view clinching scenarios
    Then I should see what each team needs
    And I should see simplest path to clinch
    And I should see magic number if applicable

  @happy-path @clinching
  Scenario: View when team clinches playoff spot
    Given a team clinches playoffs
    When I view the standings
    Then the clinched team should be marked
    And I should see when they clinched
    And celebration should be displayed

  @happy-path @clinching
  Scenario: View division clinching scenarios
    Given divisions affect playoffs
    When I view division clinching
    Then I should see division clinch possibilities
    And I should see magic numbers
    And I should see relevant matchups

  @happy-path @clinching
  Scenario: View first-round bye clinching
    Given byes are available
    When I view bye clinching
    Then I should see bye clinch scenarios
    And I should see who can still earn bye
    And I should see what must happen

  @happy-path @clinching
  Scenario: View home field advantage scenarios
    Given seeding matters for matchups
    When I view seeding scenarios
    Then I should see higher seed scenarios
    And I should see matchup implications
    And I should see clinching possibilities

  # ============================================================================
  # ELIMINATION TRACKING
  # ============================================================================

  @happy-path @elimination
  Scenario: View elimination scenarios
    Given playoffs are not clinched
    When I view elimination scenarios
    Then I should see who can be eliminated
    And I should see what would cause elimination
    And I should see elimination magic numbers

  @happy-path @elimination
  Scenario: View when team is eliminated
    Given a team is eliminated from playoffs
    When I view the standings
    Then the eliminated team should be marked
    And I should see when elimination occurred
    And remaining games should still show

  @happy-path @elimination
  Scenario: View playoff contention status
    Given the season is midway
    When I view contention status
    Then I should see teams in contention
    And I should see teams on the bubble
    And I should see already eliminated teams

  @happy-path @elimination
  Scenario: View must-win situations
    Given a team is near elimination
    When I view their status
    Then I should see must-win games
    And I should see scenarios to survive
    And I should see help needed from others

  @happy-path @elimination
  Scenario: Track consolation bracket qualification
    Given consolation brackets exist
    When I view consolation scenarios
    Then I should see who qualifies for consolation
    And I should see consolation seeding
    And I should see toilet bowl matchups

  # ============================================================================
  # STRENGTH OF SCHEDULE
  # ============================================================================

  @happy-path @strength-of-schedule
  Scenario: View past strength of schedule
    Given games have been played
    When I view SOS for completed games
    Then I should see opponents' combined record
    And I should see opponents' combined points
    And I should see difficulty ranking

  @happy-path @strength-of-schedule
  Scenario: View future strength of schedule
    Given games remain on schedule
    When I view future SOS
    Then I should see remaining opponents
    And I should see projected difficulty
    And I should see matchup analysis

  @happy-path @strength-of-schedule
  Scenario: Compare strength of schedule across teams
    Given I want to compare schedules
    When I view league-wide SOS
    Then I should see SOS for all teams
    And I should see easiest and hardest schedules
    And I should see luck factor analysis

  @happy-path @strength-of-schedule
  Scenario: View adjusted standings by SOS
    Given strength of schedule varies
    When I view SOS-adjusted standings
    Then I should see adjusted rankings
    And I should see expected record adjustment
    And I should see schedule advantage/disadvantage

  @happy-path @strength-of-schedule
  Scenario: View all-play record
    Given I want unbiased comparison
    When I view all-play standings
    Then I should see record vs all teams each week
    And I should see all-play win percentage
    And I should see luck differential

  # ============================================================================
  # STANDINGS PROJECTIONS
  # ============================================================================

  @happy-path @projections
  Scenario: View projected final standings
    Given the season is not complete
    When I view projected standings
    Then I should see projected final positions
    And I should see projection confidence
    And I should see range of outcomes

  @happy-path @projections
  Scenario: View playoff probability
    Given playoff race is ongoing
    When I view playoff odds
    Then I should see playoff percentage for each team
    And I should see probability changes from last week
    And I should see probability chart

  @happy-path @projections
  Scenario: View championship probability
    Given standings matter for championship
    When I view title odds
    Then I should see championship probability
    And I should see path to championship
    And I should see key factors

  @happy-path @projections
  Scenario: View simulation-based projections
    Given I want detailed projections
    When I run season simulations
    Then I should see simulation results
    And I should see distribution of outcomes
    And I should see most likely scenarios

  @happy-path @projections
  Scenario: View how outcomes change projections
    Given I want to explore scenarios
    When I input hypothetical results
    Then I should see how standings would change
    And I should see updated playoff odds
    And I should see seeding implications

  # ============================================================================
  # POWER RANKINGS
  # ============================================================================

  @happy-path @power-rankings
  Scenario: View weekly power rankings
    Given I want subjective rankings
    When I view power rankings
    Then I should see teams ranked by perceived strength
    And I should see movement from last week
    And I should see ranking rationale

  @happy-path @power-rankings
  Scenario: View algorithm-based power rankings
    Given I want objective rankings
    When I view calculated rankings
    Then I should see formula-based rankings
    And I should see factors considered
    And I should see how it differs from standings

  @happy-path @power-rankings
  Scenario: Compare power rankings to standings
    Given I want to see discrepancies
    When I compare rankings to standings
    Then I should see overachievers
    And I should see underachievers
    And I should see expected regression

  @happy-path @power-rankings
  Scenario: View manager-submitted power rankings
    Given league members can vote
    When I view community rankings
    Then I should see aggregated manager rankings
    And I should see consensus rating
    And I should see my own rankings

  # ============================================================================
  # STANDINGS WIDGETS AND NOTIFICATIONS
  # ============================================================================

  @happy-path @widgets
  Scenario: View standings widget on dashboard
    Given I am on my dashboard
    When I view the standings widget
    Then I should see my current position
    And I should see teams near me
    And I should see quick standings summary

  @happy-path @widgets
  Scenario: Customize standings display preferences
    Given I want to customize my view
    When I set display preferences
    Then I should choose which stats to show
    And I should choose sort order
    And preferences should be saved

  @happy-path @widgets
  Scenario: Receive standings update notifications
    Given I have notifications enabled
    When standings significantly change
    Then I should receive a notification
    And the notification should summarize changes
    And I should be able to view full standings

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Standings data fails to load
    Given I try to view standings
    When data fails to load
    Then I should see an error message
    And I should be able to retry
    And cached standings should show if available

  @error
  Scenario: Tiebreaker calculation error
    Given there is a complex tiebreaker
    When calculation fails
    Then I should see error indication
    And manual resolution should be shown
    And commissioner should be notified

  @error
  Scenario: Historical standings unavailable
    Given I try to view past standings
    When historical data is missing
    Then I should see availability message
    And I should see what data exists
    And I should see earliest available data

  @error
  Scenario: Projection model unavailable
    Given I try to view projections
    When projections cannot be calculated
    Then I should see a fallback view
    And I should see current standings only
    And I should see when projections resume

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View standings on mobile device
    Given I am using the mobile app
    When I view standings
    Then the layout should be mobile-optimized
    And I should be able to scroll horizontally
    And key columns should be visible

  @mobile
  Scenario: Swipe between standings views on mobile
    Given I am viewing standings on mobile
    When I swipe between tabs
    Then I should move between overall and division
    And transitions should be smooth
    And current view should be indicated

  @mobile
  Scenario: View team details from mobile standings
    Given I am viewing mobile standings
    When I tap on a team
    Then I should see team detail sheet
    And details should be well formatted
    And I should be able to dismiss easily

  @mobile
  Scenario: Share standings from mobile
    Given I am viewing standings on mobile
    When I share standings
    Then I should use native share sheet
    And standings image should be generated
    And share should work with social apps

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate standings with keyboard
    Given I am using keyboard navigation
    When I navigate the standings table
    Then I should move through cells logically
    And sorting should work with keyboard
    And focus should be visible

  @accessibility
  Scenario: Screen reader standings access
    Given I am using a screen reader
    When I view standings
    Then table should be properly labeled
    And rankings should be announced
    And updates should be communicated

  @accessibility
  Scenario: High contrast standings display
    Given I have high contrast mode enabled
    When I view standings
    Then playoff line should be visible
    And team positions should be clear
    And all text should be readable

  @accessibility
  Scenario: Standings with reduced motion
    Given I have reduced motion preferences
    When I view standings changes
    Then animations should be minimized
    And changes should still be clear
    And functionality should be preserved
