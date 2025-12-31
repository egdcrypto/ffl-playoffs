@standings @platform
Feature: Standings
  As a fantasy football league
  I need comprehensive standings functionality
  So that owners can track league positions, playoff races, and competitive context

  Background:
    Given the standings system is operational
    And standings rules are configured for the league

  # ==================== League Standings Display ====================

  @display @win-loss-records
  Scenario: Display win-loss records
    Given the season is in progress
    When viewing standings
    Then each team's win-loss record should be shown
    And records should be accurate
    And sorting by record should work

  @display @win-loss-records
  Scenario: Include ties in records
    Given ties are possible in the league
    When displaying records
    Then W-L-T format should be used
    And tie games should be counted correctly
    And percentage should account for ties

  @display @points-for-against
  Scenario: Display points for and against
    Given teams have scored and allowed points
    When viewing standings
    Then points for should be displayed
    And points against should be shown
    And point differential should be calculated

  @display @points-for-against
  Scenario: Calculate point differential
    Given points data exists
    When calculating differential
    Then PF minus PA should calculate
    And positive/negative should be indicated
    And sorting by differential should work

  @display @winning-percentage
  Scenario: Display winning percentage
    Given teams have records
    When viewing winning percentage
    Then percentage should be calculated
    And decimal precision should be appropriate
    And ties should be factored correctly

  @display @winning-percentage
  Scenario: Sort by winning percentage
    Given percentages vary
    When sorting standings
    Then highest percentage should be first
    And ties should use tiebreakers
    And order should be accurate

  @display @current-rank
  Scenario: Display current rank
    Given standings are calculated
    When viewing rankings
    Then each team should have a rank number
    And ranks should be ordered correctly
    And tied ranks should be indicated

  @display @current-rank
  Scenario: Track rank changes
    Given standings update regularly
    When ranks change
    Then movement should be indicated
    And direction should be shown
    And magnitude should be visible

  # ==================== Standings Tiebreakers ====================

  @tiebreakers @rules
  Scenario: Apply tiebreaker rules
    Given two teams have identical records
    When determining standings order
    Then tiebreaker rules should apply in sequence
    And the winner should be ranked higher
    And the tiebreaker used should be noted

  @tiebreakers @rules
  Scenario: Configure tiebreaker sequence
    Given tiebreaker settings are available
    When configuring sequence
    Then order should include
      | priority | tiebreaker           |
      | 1        | head-to-head record  |
      | 2        | points for           |
      | 3        | points against       |
      | 4        | coin flip            |

  @tiebreakers @head-to-head
  Scenario: Apply head-to-head tiebreaker
    Given tied teams have played each other
    When applying head-to-head
    Then the winner of their matchups should rank higher
    And if split, next tiebreaker should apply
    And series record should be shown

  @tiebreakers @head-to-head
  Scenario: Handle multi-way head-to-head ties
    Given three or more teams are tied
    When applying head-to-head
    Then combined record among tied teams should be used
    And complexity should be handled correctly
    And result should be deterministic

  @tiebreakers @points-scored
  Scenario: Apply points scored tiebreaker
    Given head-to-head is not decisive
    When applying points scored
    Then higher total points should rank higher
    And exact points should be compared
    And the result should be clear

  @tiebreakers @points-scored
  Scenario: Break points tie with decimal precision
    Given points are very close
    When comparing points
    Then decimal precision should be sufficient
    And accurate comparison should occur
    And next tiebreaker should apply if still tied

  @tiebreakers @divisional-records
  Scenario: Apply divisional record tiebreaker
    Given divisions exist in the league
    When applying divisional tiebreaker
    Then division record should be compared
    And better division record should rank higher
    And division standings should be noted

  @tiebreakers @divisional-records
  Scenario: Handle cross-division tiebreakers
    Given tied teams are in different divisions
    When applying tiebreaker
    Then overall record should be used first
    And divisional records should be secondary
    And fair comparison should be made

  # ==================== Division Standings ====================

  @divisions @breakdown
  Scenario: Display divisional standings breakdown
    Given the league has divisions
    When viewing division standings
    Then each division should be shown separately
    And teams should be ranked within division
    And division names should be displayed

  @divisions @breakdown
  Scenario: Compare divisions
    Given multiple divisions exist
    When comparing divisions
    Then combined records should be shown
    And inter-division performance should display
    And relative strength should be indicated

  @divisions @leaders
  Scenario: Highlight division leaders
    Given each division has standings
    When viewing leaders
    Then the top team in each division should be highlighted
    And their lead should be shown
    And clinching status should be indicated

  @divisions @leaders
  Scenario: Track division leader changes
    Given division races are competitive
    When leaders change
    Then the change should be highlighted
    And new leader should be indicated
    And the displacement should be noted

  @divisions @cross-division
  Scenario: Display cross-division records
    Given inter-division games occur
    When viewing cross-division records
    Then record vs other divisions should show
    And breakdown by division should be available
    And patterns should be visible

  @divisions @cross-division
  Scenario: Analyze division strength
    Given inter-division data exists
    When analyzing strength
    Then division vs division should calculate
    And aggregate performance should show
    And rankings should be available

  @divisions @clinching
  Scenario: Display division clinching scenarios
    Given the season is progressing
    When viewing clinching scenarios
    Then teams that can clinch should be identified
    And requirements should be listed
    And probability should be shown

  @divisions @clinching
  Scenario: Announce division clinching
    Given a team clinches division
    When clinching occurs
    Then notification should be sent
    And standings should reflect clinched status
    And celebration should be appropriate

  # ==================== Playoff Picture ====================

  @playoff @positioning
  Scenario: Display playoff positioning
    Given playoff format is configured
    When viewing playoff picture
    Then current playoff teams should be shown
    And bubble teams should be highlighted
    And seeding should be displayed

  @playoff @positioning
  Scenario: Show playoff cutline
    Given playoff spots are limited
    When viewing standings
    Then the playoff cutline should be visible
    And teams above/below should be clear
    And games back should be shown

  @playoff @clinching-scenarios
  Scenario: Calculate clinching scenarios
    Given playoff race is ongoing
    When viewing clinching scenarios
    Then ways to clinch should be listed
    And this week's clinching scenarios should show
    And requirements should be specific

  @playoff @clinching-scenarios
  Scenario: Display magic numbers
    Given clinching is possible
    When calculating magic numbers
    Then the number needed to clinch should show
    And combination of wins/losses should be noted
    And countdown should update

  @playoff @elimination
  Scenario: Track elimination scenarios
    Given teams can be eliminated
    When viewing elimination
    Then teams at risk should be identified
    And ways to be eliminated should show
    And survival requirements should list

  @playoff @elimination
  Scenario: Announce team elimination
    Given a team is eliminated
    When elimination occurs
    Then notification should be sent
    And standings should reflect eliminated status
    And remaining scenarios should update

  @playoff @magic-numbers
  Scenario: Display playoff magic numbers
    Given the playoff race is competitive
    When viewing magic numbers
    Then each contender's magic number should show
    And the calculation should be explained
    And updates should be real-time

  @playoff @magic-numbers
  Scenario: Calculate tragic numbers
    Given elimination is possible
    When calculating tragic numbers
    Then games remaining before elimination should show
    And scenarios should be outlined
    And hope or despair should be indicated

  # ==================== Power Rankings ====================

  @power-rankings @algorithm
  Scenario: Generate algorithm-based rankings
    Given ranking algorithms are configured
    When generating power rankings
    Then rankings should be calculated objectively
    And methodology should be transparent
    And rankings should be displayed

  @power-rankings @algorithm
  Scenario: Configure ranking algorithm
    Given ranking settings are available
    When configuring algorithm
    Then factors should include
      | factor              | weight    |
      | win-loss record     | 30%       |
      | points scored       | 25%       |
      | consistency         | 20%       |
      | strength of schedule| 15%       |
      | recent performance  | 10%       |

  @power-rankings @trends
  Scenario: Display trend indicators
    Given power rankings update weekly
    When viewing trends
    Then movement from previous week should show
    And direction should be indicated
    And magnitude should be visible

  @power-rankings @trends
  Scenario: Track long-term trends
    Given multi-week data exists
    When viewing long-term trends
    Then trajectory should be shown
    And patterns should be identified
    And insights should be provided

  @power-rankings @strength-of-schedule
  Scenario: Calculate strength of schedule
    Given opponent data exists
    When calculating SOS
    Then opponent quality should be assessed
    And SOS rating should be assigned
    And rankings should factor SOS

  @power-rankings @strength-of-schedule
  Scenario: Display remaining schedule strength
    Given future schedule is known
    When viewing remaining SOS
    Then difficulty should be rated
    And comparison to others should show
    And strategic implications should be noted

  @power-rankings @expected-wins
  Scenario: Calculate expected wins
    Given scoring distribution exists
    When calculating expected wins
    Then luck-adjusted record should be shown
    And comparison to actual should display
    And over/under performance should be noted

  @power-rankings @expected-wins
  Scenario: Identify lucky/unlucky teams
    Given expected vs actual differs
    When identifying outliers
    Then lucky teams should be flagged
    And unlucky teams should be highlighted
    And regression expectations should be noted

  # ==================== Points Standings ====================

  @points @total-rankings
  Scenario: Display total points rankings
    Given teams have scored points
    When viewing points standings
    Then teams should be ranked by total points
    And exact point totals should show
    And the leader should be highlighted

  @points @total-rankings
  Scenario: Compare points to wins
    Given records and points exist
    When comparing metrics
    Then correlation should be shown
    And mismatches should be highlighted
    And insights should be provided

  @points @weekly-high-scores
  Scenario: Track weekly high scores
    Given weekly scores are recorded
    When viewing weekly leaders
    Then the top scorer each week should be shown
    And the score should be displayed
    And historical context should be available

  @points @weekly-high-scores
  Scenario: Display weekly high score leaderboard
    Given multiple high scores exist
    When viewing leaderboard
    Then top scores across all weeks should rank
    And team and week should be shown
    And records should be indicated

  @points @points-per-game
  Scenario: Calculate points per game average
    Given games have been played
    When calculating PPG
    Then average should be calculated
    And decimal precision should be appropriate
    And ranking by PPG should be available

  @points @points-per-game
  Scenario: Compare PPG across metrics
    Given PPG data exists
    When comparing metrics
    Then PF average and PA average should show
    And differential per game should calculate
    And trends should be visible

  @points @scoring-trends
  Scenario: Display scoring trends
    Given multi-week scoring exists
    When viewing trends
    Then week-over-week changes should show
    And patterns should be identified
    And trajectory should be indicated

  @points @scoring-trends
  Scenario: Analyze scoring distribution
    Given scoring data is available
    When analyzing distribution
    Then consistency should be rated
    And boom/bust pattern should show
    And variance should be calculated

  # ==================== Historical Standings ====================

  @historical @week-by-week
  Scenario: View week-by-week standings history
    Given multiple weeks have completed
    When viewing history
    Then standings as of each week should be viewable
    And navigation should be intuitive
    And progression should be visible

  @historical @week-by-week
  Scenario: Animate standings progression
    Given historical data exists
    When viewing animation
    Then standings should animate through weeks
    And changes should be visible
    And key moments should be highlighted

  @historical @season-progression
  Scenario: Track season progression
    Given the season is ongoing
    When viewing progression
    Then position changes should be tracked
    And trends should be visualized
    And narrative should emerge

  @historical @season-progression
  Scenario: Identify turning points
    Given standings have shifted
    When identifying turning points
    Then key weeks should be highlighted
    And impact events should be noted
    And narrative context should be provided

  @historical @final-archive
  Scenario: Archive final standings
    Given a season has completed
    When archiving
    Then final standings should be preserved
    And all records should be saved
    And the archive should be accessible

  @historical @final-archive
  Scenario: Access historical final standings
    Given multiple seasons are archived
    When accessing history
    Then past seasons should be viewable
    And navigation should be easy
    And comparisons should be available

  # ==================== Standings Projections ====================

  @projections @final-standings
  Scenario: Project final standings
    Given remaining schedule is known
    When projecting standings
    Then projected final order should show
    And methodology should be explained
    And confidence should be indicated

  @projections @final-standings
  Scenario: Run multiple projection scenarios
    Given uncertainty exists
    When running scenarios
    Then multiple outcomes should be modeled
    And distribution should be shown
    And most likely should be highlighted

  @projections @playoff-probability
  Scenario: Calculate playoff probability
    Given standings simulations are run
    When calculating probability
    Then each team's odds should be shown
    And the methodology should be transparent
    And updates should be regular

  @projections @playoff-probability
  Scenario: Display probability changes
    Given probabilities change weekly
    When viewing changes
    Then movement should be shown
    And factors should be explained
    And trends should be visible

  @projections @championship-odds
  Scenario: Calculate championship odds
    Given full simulations are run
    When calculating championship odds
    Then odds for each team should show
    And path difficulty should factor
    And rankings should be available

  @projections @championship-odds
  Scenario: Break down championship path
    Given odds are calculated
    When viewing path breakdown
    Then round-by-round odds should show
    And key matchups should be identified
    And probability at each stage should display

  @projections @simulation-results
  Scenario: Display simulation results
    Given simulations have been run
    When viewing results
    Then outcome distribution should show
    And frequency of results should display
    And statistical confidence should be noted

  @projections @simulation-results
  Scenario: Configure simulation parameters
    Given simulation settings exist
    When configuring parameters
    Then options should include
      | parameter           | description           |
      | num_simulations     | how many to run       |
      | variance_model      | scoring variance      |
      | injury_impact       | factor injuries       |
      | home_advantage      | if applicable         |

  # ==================== Standings Comparison ====================

  @comparison @team-comparison
  Scenario: Compare two teams
    Given two teams are selected
    When comparing
    Then side-by-side stats should show
    And head-to-head record should display
    And advantages should be highlighted

  @comparison @team-comparison
  Scenario: Compare multiple teams
    Given multiple teams are selected
    When comparing
    Then multi-way comparison should show
    And relative rankings should display
    And groupings should be clear

  @comparison @head-to-head-records
  Scenario: Display head-to-head records
    Given matchup history exists
    When viewing head-to-head
    Then record should be shown
    And all-time series should display
    And recent matchups should be visible

  @comparison @head-to-head-records
  Scenario: Generate head-to-head matrix
    Given league has multiple teams
    When generating matrix
    Then all pairwise records should show
    And patterns should be visible
    And interactive features should work

  @comparison @common-opponents
  Scenario: Compare against common opponents
    Given teams have played common opponents
    When comparing performance
    Then performance vs same teams should show
    And differences should be calculated
    And insights should be provided

  @comparison @common-opponents
  Scenario: Identify scheduling advantages
    Given schedules differ
    When analyzing schedules
    Then differences should be shown
    And impact should be calculated
    And fairness should be assessed

  @comparison @strength-metrics
  Scenario: Compare strength metrics
    Given various metrics are calculated
    When comparing strength
    Then multiple metrics should show
    And composite strength should calculate
    And rankings should be available

  @comparison @strength-metrics
  Scenario: Display radar chart comparison
    Given multiple dimensions exist
    When viewing radar chart
    Then visual comparison should display
    And strengths/weaknesses should be clear
    And interactive features should work

  # ==================== Standings Widgets ====================

  @widgets @condensed-views
  Scenario: Display condensed standings widget
    Given standings exist
    When viewing condensed widget
    Then key information should show
    And space should be efficient
    And expansion should be available

  @widgets @condensed-views
  Scenario: Configure widget content
    Given widget settings exist
    When configuring content
    Then selectable elements should include
      | element             | configurable    |
      | team_count          | yes             |
      | columns_shown       | yes             |
      | highlight_my_team   | yes             |
      | show_changes        | yes             |

  @widgets @mobile-standings
  Scenario: Display mobile-optimized standings
    Given mobile access occurs
    When viewing on mobile
    Then interface should be responsive
    And key info should be visible
    And scrolling should work smoothly

  @widgets @mobile-standings
  Scenario: Interact with mobile standings
    Given mobile standings are displayed
    When interacting
    Then tap to expand should work
    And swipe navigation should function
    And actions should be accessible

  @widgets @customization
  Scenario: Customize standings widget
    Given customization is available
    When customizing
    Then layout should be adjustable
    And colors should be selectable
    And preferences should save

  @widgets @customization
  Scenario: Save widget configurations
    Given customization is complete
    When saving configuration
    Then settings should persist
    And multiple configs should be available
    And defaults should be restorable

  @widgets @alerts
  Scenario: Configure standings alerts
    Given alert settings are available
    When configuring alerts
    Then triggers should include
      | trigger             | description           |
      | rank_change         | position changes      |
      | playoff_clinch      | clinching scenarios   |
      | division_lead       | taking/losing lead    |
      | elimination         | elimination risk      |

  @widgets @alerts
  Scenario: Receive standings alerts
    Given alerts are configured
    When trigger conditions are met
    Then notification should be sent
    And details should be included
    And action options should be available
