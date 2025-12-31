@power-rankings @analytics
Feature: Power Rankings
  As a fantasy football manager
  I want to view power rankings and team analysis
  So that I can understand my team's true strength relative to the league

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the current week is Week 8

  # ============================================================================
  # WEEKLY RANKINGS CALCULATIONS
  # ============================================================================

  @happy-path @weekly
  Scenario: View current week power rankings
    When I view the power rankings
    Then I should see all teams ranked by power score
    And I should see each team's power rating
    And I should see rank changes from last week

  @happy-path @weekly
  Scenario: View power ranking details for a team
    When I view power ranking details for "TeamA"
    Then I should see their overall power score
    And I should see component breakdowns
    And I should see ranking factors

  @happy-path @weekly
  Scenario: View power rankings after weekly update
    Given Week 8 games have completed
    When power rankings are recalculated
    Then rankings should reflect Week 8 results
    And members should be notified of updates

  @happy-path @weekly
  Scenario: Compare power ranking to standings
    When I compare power rankings to standings
    Then I should see:
      | Team   | Power Rank | Standings Rank | Difference |
      | TeamA  | 1          | 3              | +2         |
      | TeamB  | 2          | 1              | -1         |
      | TeamC  | 3          | 5              | +2         |

  @happy-path @weekly
  Scenario: View power ranking methodology
    When I view the ranking methodology
    Then I should see all factors used
    And I should see the weight of each factor
    And I should understand the calculation

  # ============================================================================
  # ALGORITHM-BASED TEAM SCORING
  # ============================================================================

  @happy-path @algorithm
  Scenario: View power score breakdown
    When I view my team's power score
    Then I should see the composite score
    And I should see individual components:
      | Component          | Score | Weight |
      | Points Scored      | 85    | 30%    |
      | Win Percentage     | 70    | 20%    |
      | Recent Form        | 90    | 20%    |
      | Roster Strength    | 75    | 15%    |
      | Schedule Strength  | 65    | 15%    |

  @happy-path @algorithm
  Scenario: Calculate power score using weighted factors
    When the algorithm calculates power scores
    Then it should consider:
      | Factor                    | Impact  |
      | Season Points Per Game    | High    |
      | Win-Loss Record           | High    |
      | Last 3 Weeks Performance  | Medium  |
      | Strength of Schedule      | Medium  |
      | Roster Quality Score      | Medium  |
      | Head-to-Head Record       | Low     |

  @happy-path @algorithm
  Scenario: View algorithm confidence level
    When I view my power ranking
    Then I should see the confidence interval
    And I should understand the margin of error
    And I should see what could change the ranking

  @happy-path @algorithm
  Scenario: Compare algorithms
    When I compare different ranking algorithms
    Then I should see how rankings differ
    And I should understand each algorithm's approach

  # ============================================================================
  # POINTS ANALYSIS
  # ============================================================================

  @happy-path @points
  Scenario: View points scored analysis
    When I view points analysis
    Then I should see:
      | Metric               | Value  | League Rank |
      | Total Points         | 892.4  | 2nd         |
      | Points Per Game      | 111.6  | 1st         |
      | Highest Week         | 145.2  | 1st         |
      | Lowest Week          | 78.3   | 6th         |
      | Consistency Rating   | 85%    | 3rd         |

  @happy-path @points
  Scenario: View points against analysis
    When I view points against analysis
    Then I should see total points allowed
    And I should see my defensive luck rating
    And I should see expected vs actual performance

  @happy-path @points
  Scenario: View scoring efficiency
    When I view scoring efficiency
    Then I should see actual vs optimal lineup scores
    And I should see efficiency percentage
    And I should see missed opportunities

  @happy-path @points
  Scenario: View points trend over time
    When I view points trend chart
    Then I should see weekly scoring graph
    And I should see league average comparison
    And I should see trend direction

  # ============================================================================
  # STRENGTH OF SCHEDULE
  # ============================================================================

  @happy-path @schedule
  Scenario: View strength of schedule
    When I view strength of schedule
    Then I should see past schedule difficulty
    And I should see future schedule difficulty
    And I should see overall schedule ranking

  @happy-path @schedule
  Scenario: View opponent-adjusted metrics
    When I view opponent-adjusted performance
    Then I should see how I performed vs strong teams
    And I should see how I performed vs weak teams
    And I should see adjusted win expectation

  @happy-path @schedule
  Scenario: View remaining schedule analysis
    When I view remaining schedule
    Then I should see projected difficulty by week
    And I should see favorable matchups
    And I should see challenging matchups

  @happy-path @schedule
  Scenario: Compare schedule strength across league
    When I compare schedules
    Then I should see easiest schedules
    And I should see hardest schedules
    And I should see schedule luck factor

  # ============================================================================
  # TREND INDICATORS
  # ============================================================================

  @happy-path @trends
  Scenario: View rising teams
    When I view trending teams
    Then I should see teams trending upward
    And I should see their momentum score
    And I should see recent improvement metrics

  @happy-path @trends
  Scenario: View falling teams
    When I view declining teams
    Then I should see teams trending downward
    And I should see their decline metrics
    And I should see potential causes

  @happy-path @trends
  Scenario: View my team's trend
    When I view my team's trend
    Then I should see:
      | Week | Power Rank | Change | Trend    |
      | 8    | 3          | +2     | Rising   |
      | 7    | 5          | +1     | Rising   |
      | 6    | 6          | -1     | Falling  |
      | 5    | 5          | 0      | Stable   |

  @happy-path @trends
  Scenario: View trend alerts
    When significant trend changes occur
    Then I should receive trend alerts
    And alerts should explain the movement
    And I should see what caused the change

  @happy-path @trends
  Scenario: View hot streak indicator
    Given my team has won 4 straight
    When I view my power ranking
    Then I should see a "Hot Streak" indicator
    And my ranking should reflect momentum

  # ============================================================================
  # HEAD-TO-HEAD WEIGHTING
  # ============================================================================

  @happy-path @head-to-head
  Scenario: View head-to-head impact on ranking
    When I view head-to-head analysis
    Then I should see record vs each opponent
    And I should see how it affects my power ranking
    And I should see common opponent analysis

  @happy-path @head-to-head
  Scenario: View quality wins
    When I view quality wins analysis
    Then I should see wins vs top-5 teams
    And I should see wins vs bottom-5 teams
    And I should see win quality score

  @happy-path @head-to-head
  Scenario: View common opponent performance
    When I compare with "TeamB" using common opponents
    Then I should see how we each performed
    And I should see the head-to-head implication
    And I should see projected matchup result

  # ============================================================================
  # RECENT PERFORMANCE
  # ============================================================================

  @happy-path @recent
  Scenario: View recent performance weight
    When I view recent performance analysis
    Then I should see last 3 weeks emphasized
    And I should see decay factor for older weeks
    And I should see recency-weighted ranking

  @happy-path @recent
  Scenario: View performance momentum
    When I view momentum score
    Then I should see week-over-week improvement
    And I should see scoring trend
    And I should see projected next week

  @happy-path @recent
  Scenario: View form rating
    When I view current form rating
    Then I should see:
      | Form Metric        | Rating | Trend |
      | Last 3 Weeks       | A      | Up    |
      | Last Week Score    | 125.4  | High  |
      | Win Streak         | 3      | +     |

  # ============================================================================
  # ROSTER QUALITY ASSESSMENT
  # ============================================================================

  @happy-path @roster-quality
  Scenario: View roster quality score
    When I view roster quality assessment
    Then I should see overall roster grade
    And I should see position-by-position grades
    And I should see depth analysis

  @happy-path @roster-quality
  Scenario: View position strength analysis
    When I view position analysis
    Then I should see:
      | Position | Grade | League Rank | Notes           |
      | QB       | A     | 1st         | Elite starter   |
      | RB       | B+    | 4th         | Good depth      |
      | WR       | A-    | 2nd         | Strong duo      |
      | TE       | C     | 8th         | Weak spot       |

  @happy-path @roster-quality
  Scenario: View starter vs replacement comparison
    When I view replacement-level analysis
    Then I should see value above replacement
    And I should see positional advantages
    And I should see league-adjusted values

  @happy-path @roster-quality
  Scenario: View roster construction grade
    When I view roster construction
    Then I should see balance score
    And I should see upside potential
    And I should see floor/ceiling analysis

  # ============================================================================
  # INJURY IMPACT
  # ============================================================================

  @happy-path @injury
  Scenario: View injury impact on power ranking
    Given "Derrick Henry" is questionable
    When I view my power ranking
    Then I should see injury adjustment factor
    And I should see projected impact
    And I should see ranking with/without injuries

  @happy-path @injury
  Scenario: View league-wide injury impact
    When I view injury report impact
    Then I should see most affected teams
    And I should see ranking changes due to injuries
    And I should see recovery timeline projections

  @happy-path @injury
  Scenario: View injury-adjusted projections
    When I view injury-adjusted ranking
    Then I should see current ranking
    And I should see ranking if all healthy
    And I should see the injury penalty

  # ============================================================================
  # BYE WEEK ANALYSIS
  # ============================================================================

  @happy-path @bye-week
  Scenario: View bye week impact
    Given I have 3 players on bye Week 9
    When I view power ranking projections
    Then I should see bye week adjustment
    And I should see projected Week 9 decline
    And I should see recovery in Week 10

  @happy-path @bye-week
  Scenario: View bye week exposure by team
    When I view bye week analysis
    Then I should see:
      | Team   | Bye Week 9 | Bye Week 10 | Total Exposure |
      | TeamA  | 4 players  | 1 player    | High           |
      | TeamB  | 1 player   | 2 players   | Low            |

  @happy-path @bye-week
  Scenario: View bye week scheduling advantage
    When I compare bye week schedules
    Then I should see who faces weakened teams
    And I should see favorable matchup weeks
    And I should see potential upset opportunities

  # ============================================================================
  # COMMISSIONER OVERRIDES
  # ============================================================================

  @commissioner @overrides
  Scenario: Override power ranking
    Given I am the commissioner
    When I override "TeamA" ranking from 5 to 3
    Then the ranking should update
    And I should provide a reason
    And an override indicator should appear

  @commissioner @overrides
  Scenario: Add ranking commentary
    Given I am the commissioner
    When I add commentary to power rankings
    Then my commentary should appear with rankings
    And I should be able to add team-specific notes

  @commissioner @overrides
  Scenario: Lock rankings for the week
    Given I am the commissioner
    When I lock the power rankings
    Then rankings should not recalculate
    And the locked status should be visible

  @commissioner @overrides
  Scenario: Remove override
    Given I am the commissioner
    And I have an active override
    When I remove the override
    Then the algorithm ranking should restore
    And the removal should be logged

  # ============================================================================
  # HISTORICAL COMPARISONS
  # ============================================================================

  @happy-path @historical
  Scenario: Compare current to historical rankings
    When I view historical power rankings
    Then I should see my ranking over time
    And I should see peaks and valleys
    And I should see trend analysis

  @happy-path @historical
  Scenario: View all-time power ranking records
    When I view power ranking records
    Then I should see:
      | Record                    | Team   | Value | When    |
      | Highest Power Score       | TeamA  | 98.5  | 2023 W5 |
      | Longest #1 Streak         | TeamB  | 7 wks | 2022    |
      | Biggest Weekly Jump       | TeamC  | +8    | 2023 W8 |

  @happy-path @historical
  Scenario: Compare seasons
    When I compare 2023 and 2024 power rankings
    Then I should see how teams compare
    And I should see dynasty strength trends
    And I should see emerging and declining teams

  @happy-path @historical
  Scenario: View my historical power ranking
    When I view my all-time power ranking history
    Then I should see rankings by season
    And I should see my average power rank
    And I should see my best and worst stretches

  # ============================================================================
  # PLAYOFF PROJECTIONS
  # ============================================================================

  @happy-path @projections
  Scenario: View playoff probability based on power ranking
    When I view playoff projections
    Then I should see playoff probability percentage
    And I should see simulated outcomes
    And I should see key scenarios

  @happy-path @projections
  Scenario: View championship odds
    When I view championship projections
    Then I should see title odds for each team
    And I should see path to championship
    And I should see potential matchups

  @happy-path @projections
  Scenario: View projected final power rankings
    When I view end-of-season projections
    Then I should see projected final rankings
    And I should see confidence intervals
    And I should see what could change projections

  @happy-path @projections
  Scenario: Run playoff simulation
    When I run 10,000 playoff simulations
    Then I should see win probability distribution
    And I should see most likely bracket outcomes
    And I should see upset probabilities

  # ============================================================================
  # RANKING COMMENTARY
  # ============================================================================

  @happy-path @commentary
  Scenario: View auto-generated commentary
    When I view power ranking commentary
    Then I should see analysis for each team
    And commentary should explain ranking
    And key factors should be highlighted

  @happy-path @commentary
  Scenario: View team-specific analysis
    When I view "TeamA" power ranking analysis
    Then I should see detailed breakdown
    And I should see strengths and weaknesses
    And I should see improvement suggestions

  @happy-path @commentary
  Scenario: View league trends commentary
    When I view league-wide analysis
    Then I should see overall trends
    And I should see power balance assessment
    And I should see competitive analysis

  @happy-path @commentary
  Scenario: View matchup-based commentary
    When I view matchup analysis with power rankings
    Then I should see how power rankings predict outcomes
    And I should see key matchup factors
    And I should see upset potential

  # ============================================================================
  # SOCIAL SHARING
  # ============================================================================

  @happy-path @sharing
  Scenario: Share power rankings image
    When I generate a shareable power rankings image
    Then I should see a formatted graphic
    And it should include key rankings
    And I should be able to share on social media

  @happy-path @sharing
  Scenario: Share my ranking achievement
    Given I am ranked #1
    When I share my ranking
    Then I should get a shareable card
    And it should show my ranking and stats
    And it should be formatted for sharing

  @happy-path @sharing
  Scenario: Share power ranking comparison
    When I share a ranking comparison
    Then I should select teams to compare
    And I should get a comparison graphic
    And I should be able to share it

  @happy-path @sharing
  Scenario: Generate weekly rankings report
    When I generate the weekly report
    Then it should include all rankings
    And it should show week-over-week changes
    And I should be able to share with league

  # ============================================================================
  # NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive ranking change notification
    Given my ranking changed significantly
    When rankings are published
    Then I should receive a notification
    And it should show my new ranking
    And it should explain the change

  @happy-path @notifications
  Scenario: Receive #1 ranking notification
    Given I just became #1 in power rankings
    When rankings are published
    Then I should receive a celebration notification
    And the league should be notified

  @happy-path @notifications
  Scenario: Configure ranking notifications
    When I configure ranking notifications
    Then I should be able to set:
      | Notification Type        | Enabled |
      | Weekly Rankings Update   | Yes     |
      | Significant Rank Change  | Yes     |
      | Top 3 Achievement        | Yes     |
      | Trend Alerts             | No      |

  @happy-path @notifications
  Scenario: Receive power rankings preview
    Given rankings will be published tomorrow
    When the preview is ready
    Then I should receive a preview notification
    And I should see projected changes

  # ============================================================================
  # CUSTOM ALGORITHMS
  # ============================================================================

  @commissioner @custom
  Scenario: Create custom ranking algorithm
    Given I am the commissioner
    When I create a custom algorithm:
      | Factor             | Weight |
      | Points Per Game    | 40%    |
      | Win Percentage     | 30%    |
      | Recent Form        | 20%    |
      | Roster Quality     | 10%    |
    Then the custom algorithm should be applied
    And rankings should recalculate

  @commissioner @custom
  Scenario: Toggle between algorithms
    Given I am the commissioner
    When I switch between algorithms
    Then I should see different rankings
    And I should compare algorithm results

  @commissioner @custom
  Scenario: Save algorithm preset
    Given I am the commissioner
    When I save my algorithm as a preset
    Then I should be able to reuse it
    And I should share with other leagues

  @happy-path @custom
  Scenario: View algorithm comparison
    When I compare standard vs custom algorithm
    Then I should see ranking differences
    And I should see which teams are affected
    And I should understand the impact

  # ============================================================================
  # RANKING HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View ranking history timeline
    When I view ranking history
    Then I should see rankings week by week
    And I should see my movement over time
    And I should see key events

  @happy-path @history
  Scenario: View specific week's rankings
    When I view Week 5 power rankings
    Then I should see rankings as of Week 5
    And I should see the commentary from that week
    And I should compare to current

  @happy-path @history
  Scenario: Export ranking history
    When I export power ranking history
    Then I should receive a downloadable file
    And it should include all weeks
    And I should choose the format

  @happy-path @history
  Scenario: View ranking volatility
    When I view my ranking volatility
    Then I should see standard deviation
    And I should see most stable periods
    And I should see most volatile periods

  # ============================================================================
  # VISUAL CHARTS
  # ============================================================================

  @happy-path @charts
  Scenario: View power ranking bar chart
    When I view the power ranking chart
    Then I should see a horizontal bar chart
    And teams should be ordered by ranking
    And I should see power scores visualized

  @happy-path @charts
  Scenario: View ranking movement chart
    When I view ranking movement
    Then I should see a line chart over time
    And each team should have a line
    And I should see crossing points

  @happy-path @charts
  Scenario: View component breakdown chart
    When I view my power score breakdown
    Then I should see a radar/spider chart
    And each component should be a dimension
    And I should see strengths and weaknesses

  @happy-path @charts
  Scenario: View league power distribution
    When I view power distribution
    Then I should see a histogram
    And I should see competitive balance
    And I should see tiers of teams

  @happy-path @charts
  Scenario: Interactive chart filtering
    When I interact with the charts
    Then I should filter by time period
    And I should select specific teams
    And I should zoom and pan

  # ============================================================================
  # MOBILE DISPLAY
  # ============================================================================

  @mobile @responsive
  Scenario: View power rankings on mobile
    Given I am using a mobile device
    When I view power rankings
    Then I should see a mobile-optimized layout
    And I should be able to swipe through rankings
    And key info should be visible

  @mobile @responsive
  Scenario: View ranking details on mobile
    Given I am on mobile
    When I tap on a team's ranking
    Then I should see expanded details
    And I should see component breakdown
    And I should navigate easily

  @mobile @responsive
  Scenario: Share from mobile
    Given I am on mobile
    When I share my power ranking
    Then I should see native share options
    And I should be able to share to any app
    And the content should be formatted

  @mobile @responsive
  Scenario: View charts on mobile
    Given I am on mobile
    When I view power ranking charts
    Then charts should be responsive
    And I should be able to interact via touch
    And legends should be readable

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for rankings
    Given I am using a screen reader
    When I navigate power rankings
    Then rankings should be announced in order
    And rank changes should be described
    And charts should have text alternatives

  @accessibility @a11y
  Scenario: Keyboard navigation for rankings
    Given I am using keyboard only
    When I browse power rankings
    Then I should navigate with Tab
    And I should access all details
    And I should be able to interact with charts

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle calculation error
    Given the ranking calculation fails
    When I view power rankings
    Then I should see the last known rankings
    And I should see an error indicator
    And I should know when it will update

  @error @resilience
  Scenario: Handle missing data
    Given some data is unavailable
    When rankings are calculated
    Then partial rankings should be shown
    And missing data should be indicated
    And estimates should be used if available
